/-
Copyright (c) 2026 Lean FRO, LLC. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Hunter Beast
-/
module
prelude
public import Systems.Scalars
public import Systems.Bytes
public import Systems.Numerics
public import Systems.Status

/-!
# Systems.Base64 (Systems Lean)

Standard **Base64 encode/decode** over dual caller buffers — base64-**shaped**, not MIME
line-wrap, not URL-safe alphabet, not crypto.

Ops:

* **encNeed** — output byte count for `n` input bytes (`4 * ceil(n/3)`)
* **encode** / **encodeStatus** — write base64 into caller `out`/`cap`; length or miss /
  status (`0` ok, `3` bounds)
* **decNeed** — decoded byte count for base64 length `n` (padding-aware)
* **decode** / **decodeStatus** — decode into caller buffer (`0` ok, `1` bad input, `3` bounds)

Honesty:

* **Standard alphabet** `A-Za-z0-9+/` with `=` padding. Not URL-safe (`-`/`_`).
* Not claimed: MIME CRLF wrapping, crypto, streaming multipart, or constant-time.
* Miss sentinel for length APIs is `USize.neg1` (**LP64 harness**). Pair with status.
* Store status is dataflow-used so EmitC cannot DCE output writes.

## Intentional TCB (Base64-local)

Alphabet bases, bit masks/shifts, pad char, and widen/narrow helpers are freestanding
`@[extern]` axioms kept **here** (Hex parity). Name-pinned on ComplianceCorpus
(`path name=Ident`).
-/

namespace Systems.Base64

open Systems.Scalars
open Systems.Bytes
open Systems.Numerics
open Systems.Status

/-- ASCII `'A'` (65). -/
@[extern c inline "((uint32_t)65)"] public axiom cA : U32
/-- ASCII `'a'` (97). -/
@[extern c inline "((uint32_t)97)"] public axiom ca : U32
/-- ASCII `'0'` (48). -/
@[extern c inline "((uint32_t)48)"] public axiom c0 : U32
/-- ASCII `'+'` (43). -/
@[extern c inline "((uint32_t)43)"] public axiom cPlus : U32
/-- ASCII `'/'` (47). -/
@[extern c inline "((uint32_t)47)"] public axiom cSlash : U32
/-- ASCII `'='` (61). -/
@[extern c inline "((uint32_t)61)"] public axiom cPad : U32
/-- ASCII `'Z'` (90). -/
@[extern c inline "((uint32_t)90)"] public axiom cZ : U32
/-- ASCII `'z'` (122). -/
@[extern c inline "((uint32_t)122)"] public axiom cz : U32
/-- ASCII `'9'` (57). -/
@[extern c inline "((uint32_t)57)"] public axiom c9 : U32
/-- 26 (letter block). -/
@[extern c inline "((uint32_t)26)"] public axiom twentySix : U32
/-- 52 (digit base index). -/
@[extern c inline "((uint32_t)52)"] public axiom fiftyTwo : U32
/-- 62 (`+` index). -/
@[extern c inline "((uint32_t)62)"] public axiom sixtyTwo : U32
/-- 63 (`/` index). -/
@[extern c inline "((uint32_t)63)"] public axiom sixtyThree : U32
/-- 6-bit mask (63). -/
@[extern c inline "((uint32_t)63)"] public axiom mask6 : U32
/-- Low 2 bits mask (3). -/
@[extern c inline "((uint32_t)3)"] public axiom mask2 : U32
/-- Low 4 bits mask (15). -/
@[extern c inline "((uint32_t)15)"] public axiom mask4 : U32
/-- Byte mask (`0xFF` = 255). -/
@[extern c inline "((uint32_t)255)"] public axiom mask8 : U32
/-- Shift 2. -/
@[extern c inline "((uint32_t)2)"] public axiom twoU32 : U32
/-- Shift 4. -/
@[extern c inline "((uint32_t)4)"] public axiom fourU32 : U32
/-- Shift 6. -/
@[extern c inline "((uint32_t)6)"] public axiom sixU32 : U32
/-- Shift 8. -/
@[extern c inline "((uint32_t)8)"] public axiom eightU32 : U32
/-- Shift 12. -/
@[extern c inline "((uint32_t)12)"] public axiom twelveU32 : U32
/-- Shift 16. -/
@[extern c inline "((uint32_t)16)"] public axiom sixteenU32 : U32
/-- Shift 18. -/
@[extern c inline "((uint32_t)18)"] public axiom eighteenU32 : U32
/-- Two as `USize`. -/
@[extern c inline "((size_t)2)"] public axiom twoUSize : USize
/-- Three as `USize`. -/
@[extern c inline "((size_t)3)"] public axiom threeUSize : USize
/-- Four as `USize`. -/
@[extern c inline "((size_t)4)"] public axiom fourUSize : USize
/-- Unsigned divide. Caller must keep divisor ≠ 0. -/
@[extern c inline "((size_t)((size_t)(#1) / (size_t)(#2)))"]
public axiom USize.div : USize → USize → USize
/-- Unsigned multiply. -/
@[extern c inline "((size_t)((size_t)(#1) * (size_t)(#2)))"]
public axiom USize.mul : USize → USize → USize
/-- Unsigned modulo. Caller must keep divisor ≠ 0. -/
@[extern c inline "((size_t)((size_t)(#1) % (size_t)(#2)))"]
public axiom USize.mod : USize → USize → USize
/-- Widen `U32` → `USize`. -/
@[extern c inline "((size_t)(uint32_t)(#1))"]
public axiom USize.ofU32 : U32 → USize
/-- Narrow `U32` → `U8` (low byte). -/
@[extern c inline "((uint8_t)(uint32_t)(#1))"]
public axiom U8.ofU32 : U32 → U8
/-- Invalid alphabet sentinel (`255`). -/
@[extern c inline "((uint32_t)255)"] public axiom invAlpha : U32

/-- `+` or `/` for indices 62/63. Uses `v` in both arms (no ground closed char). -/
public unsafe def encDigitSym (v : U32) : U8 :=
  bifU8 (U32.beq v sixtyTwo)
    (U8.ofU32 (U32.add cPlus (U32.sub v v)))
    (U8.ofU32 (U32.add cSlash (U32.sub v v)))

/-- Numeric / symbol half of encDigit (`v ≥ 52`). -/
public unsafe def encDigitNum (v : U32) : U8 :=
  bifU8 (U32.blt v sixtyTwo)
    (U8.ofU32 (U32.add c0 (U32.sub v fiftyTwo)))
    (encDigitSym v)

/-- Lower half of encDigit (`v ≥ 26`). -/
public unsafe def encDigitLo (v : U32) : U8 :=
  bifU8 (U32.blt v fiftyTwo)
    (U8.ofU32 (U32.add ca (U32.sub v twentySix)))
    (encDigitNum v)

/-- Map 6-bit value `0..63` → standard base64 ASCII. Caller keeps `v ≤ 63`. -/
public unsafe def encDigit (v : U32) : U8 :=
  bifU8 (U32.blt v twentySix)
    (U8.ofU32 (U32.add cA v))
    (encDigitLo v)

/-- Decode path for lowercase / invalid above `'Z'`. -/
public unsafe def decDigitLower (c : U32) : U32 :=
  bifU32 (U32.blt c ca) invAlpha
    (bifU32 (U32.blt cz c) invAlpha
      (U32.add twentySix (U32.sub c ca)))

/-- Decode path for `c < 'A'`. -/
public unsafe def decDigitLo (c : U32) : U32 :=
  bifU32 (U32.beq c cPlus) sixtyTwo
    (bifU32 (U32.beq c cSlash) sixtyThree
      (bifU32 (U32.blt c c0) invAlpha
        (bifU32 (U32.blt c9 c) invAlpha
          (U32.add fiftyTwo (U32.sub c c0)))))

/-- Decode path for `c ≥ 'A'`. -/
public unsafe def decDigitHi (c : U32) : U32 :=
  bifU32 (U32.blt cZ c) (decDigitLower c) (U32.sub c cA)

/-- Map standard base64 ASCII → 6-bit value, or `invAlpha` if not in alphabet. -/
public unsafe def decDigit (c : U32) : U32 :=
  bifU32 (U32.blt c cA) (decDigitLo c) (decDigitHi c)

/-- Output length for encoding `n` bytes: `4 * ceil(n / 3)`. -/
public def encNeed (n : USize) : USize :=
  USize.mul (USize.div (USize.add n twoUSize) threeUSize) fourUSize

/-- Write 4 encoded chars for a 3-byte (or partial) group. `rem` is `1..3` live bytes. -/
public unsafe def encBlock (out : USize) (o : USize) (b0 : U32) (b1 : U32) (b2 : U32)
    (rem : USize) : U32 :=
  let d0 := U32.land (U32.shiftRight b0 twoU32) mask6
  let d1 := U32.land (U32.lor (U32.shiftLeft (U32.land b0 mask2) fourU32)
    (U32.shiftRight b1 fourU32)) mask6
  let d2 := U32.land (U32.lor (U32.shiftLeft (U32.land b1 mask4) twoU32)
    (U32.shiftRight b2 sixU32)) mask6
  let d3 := U32.land b2 mask6
  let s0 := U8.store (USize.add out o) (encDigit d0)
  bifU32 (isOk s0)
    (let s1 := U8.store (USize.add out (USize.add o USize.one)) (encDigit d1)
     bifU32 (isOk s1)
       (bifU32 (USize.blt rem twoUSize)
         (let pad := U8.ofU32 (U32.add cPad (U32.sub b0 b0))
          let s2 := U8.store (USize.add out (USize.add o twoUSize)) pad
          bifU32 (isOk s2)
            (U8.store (USize.add out (USize.add o threeUSize)) pad)
            s2)
         (let s2 := U8.store (USize.add out (USize.add o twoUSize)) (encDigit d2)
          bifU32 (isOk s2)
            (bifU32 (USize.blt rem threeUSize)
              (U8.store (USize.add out (USize.add o threeUSize))
                (U8.ofU32 (U32.add cPad (U32.sub b1 b1))))
              (U8.store (USize.add out (USize.add o threeUSize)) (encDigit d3)))
            s2))
       s1)
    s0

/-- Encode loop: groups of up to 3 input bytes. Returns `0` ok. -/
public unsafe def encodeGo (src : USize) (n : USize) (out : USize) (i : USize) (o : USize) : U32 :=
  bifU32 (USize.blt i n)
    (let rem := USize.sub n i
     let b0 := U32.ofU8 (U8.load (USize.add src i))
     let b1 :=
       bifU32 (USize.blt USize.one rem)
         (U32.ofU8 (U8.load (USize.add src (USize.add i USize.one))))
         U32.zero
     let b2 :=
       bifU32 (USize.blt twoUSize rem)
         (U32.ofU8 (U8.load (USize.add src (USize.add i twoUSize))))
         U32.zero
     let take := bifUSize (USize.blt rem threeUSize) rem threeUSize
     let st := encBlock out o b0 b1 b2 take
     bifU32 (isOk st)
       (encodeGo src n out (USize.add i take) (USize.add o fourUSize))
       st)
    ok

/-- Status of base64 encode: `0` ok, `3` if `cap < encNeed n`. -/
public unsafe def encodeStatus (src : USize) (n : USize) (out : USize) (cap : USize) : U32 :=
  let need := encNeed n
  bifU32 (USize.blt cap need) errBounds
    (encodeGo src n out USize.zero USize.zero)

/-- Encode `n` bytes at `src` into `out`/`cap`. Write length, or `USize.neg1` if too small.

**LP64 miss sentinel.** Store status is dataflow-used. -/
public unsafe def encode (src : USize) (n : USize) (out : USize) (cap : USize) : USize :=
  let need := encNeed n
  bifUSize (USize.blt cap need) USize.neg1
    (let st := encodeGo src n out USize.zero USize.zero
     bifUSize (isOk st) need USize.neg1)

/-- Decoded length for base64 length `n` with trailing pad count `pads` (`0..2`).

Requires `n % 4 == 0` (caller). Shape helper. -/
public def decNeedPads (n : USize) (pads : USize) : USize :=
  bifUSize (USize.beq n USize.zero) USize.zero
    (USize.sub (USize.mul (USize.div n fourUSize) threeUSize) pads)

/-- Count trailing `=` pads in last quartet (`0..2`). -/
public unsafe def countPads (src : USize) (n : USize) : USize :=
  bifUSize (USize.beq n USize.zero) USize.zero
    (let last := USize.sub n USize.one
     bifUSize (U32.beq (U32.ofU8 (U8.load (USize.add src last))) cPad)
       (let prev := USize.sub last USize.one
        bifUSize (U32.beq (U32.ofU8 (U8.load (USize.add src prev))) cPad)
          twoUSize
          USize.one)
       USize.zero)

/-- Output length for decoding `n` base64 bytes, or `USize.neg1` if `n` not multiple of 4. -/
public unsafe def decNeed (src : USize) (n : USize) : USize :=
  bifUSize (USize.beq n USize.zero) USize.zero
    (bifUSize (USize.beq (USize.mod n fourUSize) USize.zero)
      (decNeedPads n (countPads src n))
      USize.neg1)

/-- Decode one quartet into up to 3 bytes. `outBytes` is `1..3`. -/
public unsafe def decBlock (out : USize) (o : USize) (a : U32) (b : U32) (c : U32) (d : U32)
    (outBytes : USize) : U32 :=
  let triple := U32.lor (U32.lor (U32.lor (U32.shiftLeft a eighteenU32)
    (U32.shiftLeft b twelveU32)) (U32.shiftLeft c sixU32)) d
  let b0 := U32.land (U32.shiftRight triple sixteenU32) mask8
  let s0 := U8.store (USize.add out o) (U8.ofU32 b0)
  bifU32 (isOk s0)
    (bifU32 (USize.blt outBytes twoUSize) ok
      (let b1 := U32.land (U32.shiftRight triple eightU32) mask8
       let s1 := U8.store (USize.add out (USize.add o USize.one)) (U8.ofU32 b1)
       bifU32 (isOk s1)
         (bifU32 (USize.blt outBytes threeUSize) ok
           (let b2 := U32.land triple mask8
            U8.store (USize.add out (USize.add o twoUSize)) (U8.ofU32 b2)))
         s1))
    s0

/-- Decode loop status. Returns `0` ok, `1` bad alphabet/pad. -/
public unsafe def decodeGo (src : USize) (n : USize) (out : USize) (i : USize) (o : USize)
    (pads : USize) : U32 :=
  bifU32 (USize.blt i n)
    (let next := USize.add i fourUSize
     let isLast := bifU32 (USize.beq next n) U32.one U32.zero
     let c0 := U32.ofU8 (U8.load (USize.add src i))
     let c1 := U32.ofU8 (U8.load (USize.add src (USize.add i USize.one)))
     let c2 := U32.ofU8 (U8.load (USize.add src (USize.add i twoUSize)))
     let c3 := U32.ofU8 (U8.load (USize.add src (USize.add i threeUSize)))
     let a := decDigit c0
     let b := decDigit c1
     bifU32 (U32.beq a invAlpha) err
       (bifU32 (U32.beq b invAlpha) err
         (bifU32 (U32.beq isLast U32.one)
           (bifU32 (U32.beq c2 cPad)
             (bifU32 (U32.beq c3 cPad)
               (let st := decBlock out o a b U32.zero U32.zero USize.one
                bifU32 (isOk st) (decodeGo src n out next (USize.add o USize.one) pads) st)
               err)
             (let cv := decDigit c2
              bifU32 (U32.beq cv invAlpha) err
                (bifU32 (U32.beq c3 cPad)
                  (let st := decBlock out o a b cv U32.zero twoUSize
                   bifU32 (isOk st) (decodeGo src n out next (USize.add o twoUSize) pads) st)
                  (let d := decDigit c3
                   bifU32 (U32.beq d invAlpha) err
                     (let st := decBlock out o a b cv d threeUSize
                      bifU32 (isOk st)
                        (decodeGo src n out next (USize.add o threeUSize) pads)
                        st)))))
           (let cv := decDigit c2
            let d := decDigit c3
            bifU32 (U32.beq cv invAlpha) err
              (bifU32 (U32.beq d invAlpha) err
                (let st := decBlock out o a b cv d threeUSize
                 bifU32 (isOk st)
                   (decodeGo src n out next (USize.add o threeUSize) pads)
                   st))))))
    ok

/-- Status of base64 decode: `0` ok, `1` bad input, `3` buffer too small / bad length. -/
public unsafe def decodeStatus (src : USize) (n : USize) (out : USize) (cap : USize) : U32 :=
  bifU32 (USize.beq n USize.zero) ok
    (bifU32 (USize.beq (USize.mod n fourUSize) USize.zero)
      (let pads := countPads src n
       let need := decNeedPads n pads
       bifU32 (USize.blt cap need) errBounds
         (decodeGo src n out USize.zero USize.zero pads))
      errBounds)

/-- Decode base64 at `src`/`n` into `out`/`cap`. Write length, or `USize.neg1` on failure.

**LP64 miss sentinel.** -/
public unsafe def decode (src : USize) (n : USize) (out : USize) (cap : USize) : USize :=
  bifUSize (USize.beq n USize.zero) USize.zero
    (bifUSize (USize.beq (USize.mod n fourUSize) USize.zero)
      (let pads := countPads src n
       let need := decNeedPads n pads
       bifUSize (USize.blt cap need) USize.neg1
         (let st := decodeGo src n out USize.zero USize.zero pads
          bifUSize (isOk st) need USize.neg1))
      USize.neg1)

end Systems.Base64
