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
public import Systems.Ascii

/-!
# Systems.Hex (Systems Lean)

ASCII hex encode/decode over dual caller buffers — hex-**shaped**, not crypto, not a full
hexdump / `xxd` / locale hex, not signed / `0x` prefix scanning.

Ops:

* **encU8** / **encU32** / **encU64** — fixed-width lowercase hex into caller `addr`/`cap`
  (`2` / `8` / `16` digits); write length or miss sentinel if buffer too small
* **encU8Status** / **encU32Status** / **encU64Status** — status only (`0` ok, `3` bounds)
* **parseU32** / **parseU64** — parse hex digit view → value, or miss sentinel
* **parseU32Status** / **parseU64Status** — status only (`0` ok, `1` empty/bad digit, `3` overflow)

Honesty:

* **ASCII hex only** (`0-9` / `A-F` / `a-f`); lowercase on encode.
* Not claimed: crypto, `0x` prefixes, whitespace, full hexdump layout, or multi-field products.
* Miss sentinel for length/value APIs is `USize.neg1` / `U64.neg1` (**LP64 harness** for
  `USize`). Pair with status when needed.
* Store status is dataflow-used so EmitC cannot DCE digit writes.

## Intentional TCB (Hex-local)

Hex digit bases, nibble mask/shift, widths, and widen/narrow helpers are freestanding
`@[extern]` axioms kept **here** (Fmt/Parse parity). Name-pinned on
ComplianceCorpus (`path name=Ident`). Classifiers reuse `Systems.Ascii.isHex` / `isDigit`.
-/

namespace Systems.Hex

open Systems.Scalars
open Systems.Bytes
open Systems.Numerics
open Systems.Status
open Systems.Ascii

/-- ASCII `'0'` (48). -/
@[extern c inline "((uint32_t)48)"] public axiom c0 : U32
/-- ASCII `'A'` (65). -/
@[extern c inline "((uint32_t)65)"] public axiom cA : U32
/-- ASCII `'a'` (97). -/
@[extern c inline "((uint32_t)97)"] public axiom ca : U32
/-- Ten (decimal digit ceiling for nibble→ASCII). -/
@[extern c inline "((uint32_t)10)"] public axiom tenU32 : U32
/-- Nibble mask `0xF` (15). -/
@[extern c inline "((uint32_t)15)"] public axiom nibbleMaskU32 : U32
/-- Nibble shift amount (4). -/
@[extern c inline "((uint32_t)4)"] public axiom fourU32 : U32
/-- Nibble mask as `U64`. -/
@[extern c inline "((uint64_t)15)"] public axiom nibbleMaskU64 : U64
/-- Nibble shift as `U64`. -/
@[extern c inline "((uint64_t)4)"] public axiom fourU64 : U64
/-- Fixed encode width for `U8` (2). -/
@[extern c inline "((size_t)2)"] public axiom widthU8 : USize
/-- Fixed encode width for `U32` (8). -/
@[extern c inline "((size_t)8)"] public axiom widthU32 : USize
/-- Fixed encode width for `U64` (16). -/
@[extern c inline "((size_t)16)"] public axiom widthU64 : USize
/-- `UINT32_MAX / 16` (268435455) for overflow check. -/
@[extern c inline "((uint32_t)268435455)"] public axiom u32MaxDiv16 : U32
/-- `UINT64_MAX / 16` (1152921504606846975). -/
@[extern c inline "((uint64_t)1152921504606846975ULL)"] public axiom u64MaxDiv16 : U64
/-- Widen `U32` → `USize`. -/
@[extern c inline "((size_t)(uint32_t)(#1))"]
public axiom USize.ofU32 : U32 → USize
/-- Widen `U32` → `U64`. -/
@[extern c inline "((uint64_t)(uint32_t)(#1))"]
public axiom U64.ofU32 : U32 → U64
/-- Narrow low 32 bits of `U64` (nibble values `0..15` on product paths). -/
@[extern c inline "((uint32_t)(uint64_t)(#1))"]
public axiom U32.ofU64 : U64 → U32
/-- Narrow `U32` nibble/digit → `U8` (low byte). -/
@[extern c inline "((uint8_t)(uint32_t)(#1))"]
public axiom U8.ofU32 : U32 → U8

/-- Map nibble `0..15` → lowercase ASCII hex digit. Caller keeps `d ≤ 15`. -/
public def nibbleToAscii (d : U32) : U8 :=
  bifU8 (U32.blt d tenU32)
    (U8.ofU32 (U32.add c0 d))
    (U8.ofU32 (U32.add ca (U32.sub d tenU32)))

/-- Digit value of ASCII hex `c` (`0..15`); caller must ensure `isHex c`. -/
public def hexVal (c : U32) : U32 :=
  bifU32 (U32.beq (isDigit c) U32.one) (U32.sub c c0)
    (bifU32 (U32.blt c ca)
      (U32.add tenU32 (U32.sub c cA))
      (U32.add tenU32 (U32.sub c ca)))

/-- Write low nibbles of `v` right-aligned into `[addr, addr+pos)` (pos exclusive end).

Store status is dataflow-used. -/
public unsafe def encU32WriteGo (addr : USize) (pos : USize) (v : U32) : U32 :=
  bifU32 (USize.beq pos USize.zero) ok
    (let d := U32.land v nibbleMaskU32
     let ch := nibbleToAscii d
     let st := U8.store (USize.add addr (USize.sub pos USize.one)) ch
     bifU32 (isOk st)
       (encU32WriteGo addr (USize.sub pos USize.one) (U32.shiftRight v fourU32))
       st)

/-- Write low nibbles of `v` (U64) right-aligned into `[addr, addr+pos)`. -/
public unsafe def encU64WriteGo (addr : USize) (pos : USize) (v : U64) : U32 :=
  bifU32 (USize.beq pos USize.zero) ok
    (let d := U32.ofU64 (U64.land v nibbleMaskU64)
     let ch := nibbleToAscii d
     let st := U8.store (USize.add addr (USize.sub pos USize.one)) ch
     bifU32 (isOk st)
       (encU64WriteGo addr (USize.sub pos USize.one) (U64.shiftRight v fourU64))
       st)

/-- Status of fixed-width `U8` hex encode: `0` ok, `3` if `cap < 2`. -/
public unsafe def encU8Status (addr : USize) (cap : USize) (v : U8) : U32 :=
  bifU32 (USize.blt cap widthU8) errBounds
    (encU32WriteGo addr widthU8 (U32.ofU8 v))

/-- Fixed-width hex of `U8` (`2` digits): write length, or `USize.neg1` if too small. -/
public unsafe def encU8 (addr : USize) (cap : USize) (v : U8) : USize :=
  bifUSize (USize.blt cap widthU8) USize.neg1
    (let st := encU32WriteGo addr widthU8 (U32.ofU8 v)
     bifUSize (isOk st) widthU8 USize.neg1)

/-- Status of fixed-width `U32` hex encode: `0` ok, `3` if `cap < 8`. -/
public unsafe def encU32Status (addr : USize) (cap : USize) (v : U32) : U32 :=
  bifU32 (USize.blt cap widthU32) errBounds
    (encU32WriteGo addr widthU32 v)

/-- Fixed-width hex of `U32` (`8` digits): write length, or `USize.neg1` if too small. -/
public unsafe def encU32 (addr : USize) (cap : USize) (v : U32) : USize :=
  bifUSize (USize.blt cap widthU32) USize.neg1
    (let st := encU32WriteGo addr widthU32 v
     bifUSize (isOk st) widthU32 USize.neg1)

/-- Status of fixed-width `U64` hex encode: `0` ok, `3` if `cap < 16`. -/
public unsafe def encU64Status (addr : USize) (cap : USize) (v : U64) : U32 :=
  bifU32 (USize.blt cap widthU64) errBounds
    (encU64WriteGo addr widthU64 v)

/-- Fixed-width hex of `U64` (`16` digits): write length, or `USize.neg1` if too small. -/
public unsafe def encU64 (addr : USize) (cap : USize) (v : U64) : USize :=
  bifUSize (USize.blt cap widthU64) USize.neg1
    (let st := encU64WriteGo addr widthU64 v
     bifUSize (isOk st) widthU64 USize.neg1)

/-- `1` if multiplying `acc` by 16 and adding `d` would overflow `U32`. -/
public def u32WouldOverflow (acc : U32) (d : U32) : U32 :=
  bifU32 (U32.blt u32MaxDiv16 acc) U32.one
    (bifU32 (U32.beq acc u32MaxDiv16)
      (bifU32 (U32.blt nibbleMaskU32 d) U32.one U32.zero)
      U32.zero)

/-- `1` if multiplying `acc` by 16 and adding `d` would overflow `U64`. -/
public def u64WouldOverflow (acc : U64) (d : U64) : U32 :=
  bifU32 (U64.blt u64MaxDiv16 acc) U32.one
    (bifU32 (U64.beq acc u64MaxDiv16)
      (bifU32 (U64.blt nibbleMaskU64 d) U32.one U32.zero)
      U32.zero)

/-- Parse loop status for hex `U32`. Returns `0` ok, `1` empty/bad, `3` overflow. -/
public unsafe def parseU32Go (addr : USize) (n : USize) (i : USize) (acc : U32) (seen : U32) : U32 :=
  bifU32 (USize.blt i n)
    (let c := U32.ofU8 (U8.load (USize.add addr i))
     bifU32 (U32.beq (isHex c) U32.one)
       (let d := hexVal c
        bifU32 (U32.beq (u32WouldOverflow acc d) U32.one) errBounds
          (parseU32Go addr n (USize.add i USize.one)
            (U32.add (U32.shiftLeft acc fourU32) d) U32.one))
       err)
    (bifU32 (U32.beq seen U32.one) ok err)

/-- Value-accumulating hex `U32` parse loop. -/
public unsafe def parseU32ValGo (addr : USize) (n : USize) (i : USize) (acc : U32) (seen : U32) : USize :=
  bifUSize (USize.blt i n)
    (let c := U32.ofU8 (U8.load (USize.add addr i))
     bifUSize (U32.beq (isHex c) U32.one)
       (let d := hexVal c
        bifUSize (U32.beq (u32WouldOverflow acc d) U32.one) USize.neg1
          (parseU32ValGo addr n (USize.add i USize.one)
            (U32.add (U32.shiftLeft acc fourU32) d) U32.one))
       USize.neg1)
    (bifUSize (U32.beq seen U32.one) (USize.ofU32 acc) USize.neg1)

/-- Status of hex `U32` parse: `0` ok, `1` empty/bad digit, `3` overflow. -/
public unsafe def parseU32Status (addr : USize) (n : USize) : U32 :=
  parseU32Go addr n USize.zero U32.zero U32.zero

/-- Hex `U32` parse as `USize` value, or `USize.neg1` on failure. **LP64 miss sentinel.** -/
public unsafe def parseU32 (addr : USize) (n : USize) : USize :=
  parseU32ValGo addr n USize.zero U32.zero U32.zero

/-- Parse loop status for hex `U64`. -/
public unsafe def parseU64Go (addr : USize) (n : USize) (i : USize) (acc : U64) (seen : U32) : U32 :=
  bifU32 (USize.blt i n)
    (let c := U32.ofU8 (U8.load (USize.add addr i))
     bifU32 (U32.beq (isHex c) U32.one)
       (let d := U64.ofU32 (hexVal c)
        bifU32 (U32.beq (u64WouldOverflow acc d) U32.one) errBounds
          (parseU64Go addr n (USize.add i USize.one)
            (U64.add (U64.shiftLeft acc fourU64) d) U32.one))
       err)
    (bifU32 (U32.beq seen U32.one) ok err)

/-- Value-accumulating hex `U64` parse loop. -/
public unsafe def parseU64ValGo (addr : USize) (n : USize) (i : USize) (acc : U64) (seen : U32) : U64 :=
  bifU64 (USize.blt i n)
    (let c := U32.ofU8 (U8.load (USize.add addr i))
     bifU64 (U32.beq (isHex c) U32.one)
       (let d := U64.ofU32 (hexVal c)
        bifU64 (U32.beq (u64WouldOverflow acc d) U32.one) U64.neg1
          (parseU64ValGo addr n (USize.add i USize.one)
            (U64.add (U64.shiftLeft acc fourU64) d) U32.one))
       U64.neg1)
    (bifU64 (U32.beq seen U32.one) acc U64.neg1)

/-- Status of hex `U64` parse: `0` ok, `1` empty/bad digit, `3` overflow. -/
public unsafe def parseU64Status (addr : USize) (n : USize) : U32 :=
  parseU64Go addr n USize.zero U64.zero U32.zero

/-- Hex `U64` parse, or `U64.neg1` on failure (pair with status when value may be all-ones). -/
public unsafe def parseU64 (addr : USize) (n : USize) : U64 :=
  parseU64ValGo addr n USize.zero U64.zero U32.zero

end Systems.Hex
