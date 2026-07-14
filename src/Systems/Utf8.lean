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
# Systems.Utf8 (Systems Lean)

UTF-8 **scan/validate** over dual caller `addr`/`len` byte views — scan-**shaped**, not a
full Unicode library (no NFC/NFD, no graphemes, no encode-all-planes product API).

Ops:

* **firstLen** — length `1..4` of the codepoint starting at `addr` with remaining `n`, or
  `0` if empty/invalid lead / truncated / overlong / surrogate / out-of-range
* **validate** — status `0` if the full range is well-formed UTF-8, else `1`
* **count** — codepoint count as `USize`, or `USize.neg1` if invalid (**LP64 miss**)

Honesty:

* **Shaped scan only** — fail closed on overlong encodings, UTF-16 surrogates, bytes
  beyond `U+10FFFF`, truncated sequences, and invalid lead/cont bytes.
* Not claimed: normalization, case fold, grapheme clusters, encode API, or locale.
* Prefer pure Lean; byte thresholds are local freestanding constants (name-pinned).

## Intentional TCB (Utf8-local)

UTF-8 range thresholds and `USize.ofU32` / small widths are freestanding `@[extern]` axioms
kept **here**. Name-pinned on ComplianceCorpus (`path name=Ident`).
-/

namespace Systems.Utf8

open Systems.Scalars
open Systems.Bytes
open Systems.Numerics
open Systems.Status

/-- ASCII / 1-byte max lead (`0x7F` = 127). -/
@[extern c inline "((uint32_t)127)"] public axiom b7f : U32
/-- Cont-byte high bits class: `0xC0` (192). -/
@[extern c inline "((uint32_t)192)"] public axiom bC0 : U32
/-- Cont-byte expected top bits: `0x80` (128). -/
@[extern c inline "((uint32_t)128)"] public axiom b80 : U32
/-- 2-byte lead min non-overlong: `0xC2` (194). -/
@[extern c inline "((uint32_t)194)"] public axiom bC2 : U32
/-- 2-byte lead max: `0xDF` (223). -/
@[extern c inline "((uint32_t)223)"] public axiom bDF : U32
/-- 3-byte lead min: `0xE0` (224). -/
@[extern c inline "((uint32_t)224)"] public axiom bE0 : U32
/-- 3-byte lead max: `0xEF` (239). -/
@[extern c inline "((uint32_t)239)"] public axiom bEF : U32
/-- 4-byte lead min: `0xF0` (240). -/
@[extern c inline "((uint32_t)240)"] public axiom bF0 : U32
/-- 4-byte lead max in-range: `0xF4` (244). -/
@[extern c inline "((uint32_t)244)"] public axiom bF4 : U32
/-- Cont min for `E0` (no overlong): `0xA0` (160). -/
@[extern c inline "((uint32_t)160)"] public axiom bA0 : U32
/-- Cont max for `ED` (no surrogates): `0x9F` (159). -/
@[extern c inline "((uint32_t)159)"] public axiom b9F : U32
/-- Cont min for `F0` (no overlong): `0x90` (144). -/
@[extern c inline "((uint32_t)144)"] public axiom b90 : U32
/-- Cont max for `F4`: `0x8F` (143). -/
@[extern c inline "((uint32_t)143)"] public axiom b8F : U32
/-- Lead `0xED` (237) — surrogate half. -/
@[extern c inline "((uint32_t)237)"] public axiom bED : U32
/-- Widen `U32` → `USize`. -/
@[extern c inline "((size_t)(uint32_t)(#1))"]
public axiom USize.ofU32 : U32 → USize
/-- Two as `USize`. -/
@[extern c inline "((size_t)2)"] public axiom twoUSize : USize
/-- Three as `USize`. -/
@[extern c inline "((size_t)3)"] public axiom threeUSize : USize
/-- Four as `USize`. -/
@[extern c inline "((size_t)4)"] public axiom fourUSize : USize

/-- `1` if `c` is a UTF-8 continuation byte (`10xxxxxx`), else `0`. -/
public def isCont (c : U32) : U32 :=
  bifU32 (U32.beq (U32.land c bC0) b80) U32.one U32.zero

/-- 2-byte sequence length when lead is `C2..DF`, else `0`. -/
public unsafe def len2 (addr : USize) (n : USize) : USize :=
  bifUSize (USize.blt n twoUSize) USize.zero
    (let b1 := U32.ofU8 (U8.load (USize.add addr USize.one))
     bifUSize (U32.beq (isCont b1) U32.one) twoUSize USize.zero)

/-- 3-byte sequence length when lead is `E0..EF`, else `0` (overlong/surrogate closed). -/
public unsafe def len3 (addr : USize) (n : USize) (b0 : U32) : USize :=
  bifUSize (USize.blt n threeUSize) USize.zero
    (let b1 := U32.ofU8 (U8.load (USize.add addr USize.one))
     let b2 := U32.ofU8 (U8.load (USize.add addr twoUSize))
     bifUSize (U32.beq (isCont b1) U32.one)
       (bifUSize (U32.beq (isCont b2) U32.one)
         (bifUSize (U32.beq b0 bE0)
           (bifUSize (U32.blt b1 bA0) USize.zero threeUSize)
           (bifUSize (U32.beq b0 bED)
             (bifUSize (U32.blt b9F b1) USize.zero threeUSize)
             threeUSize))
         USize.zero)
       USize.zero)

/-- 4-byte sequence length when lead is `F0..F4`, else `0` (overlong/out-of-range closed). -/
public unsafe def len4 (addr : USize) (n : USize) (b0 : U32) : USize :=
  bifUSize (USize.blt n fourUSize) USize.zero
    (let b1 := U32.ofU8 (U8.load (USize.add addr USize.one))
     let b2 := U32.ofU8 (U8.load (USize.add addr twoUSize))
     let b3 := U32.ofU8 (U8.load (USize.add addr threeUSize))
     bifUSize (U32.beq (isCont b1) U32.one)
       (bifUSize (U32.beq (isCont b2) U32.one)
         (bifUSize (U32.beq (isCont b3) U32.one)
           (bifUSize (U32.beq b0 bF0)
             (bifUSize (U32.blt b1 b90) USize.zero fourUSize)
             (bifUSize (U32.beq b0 bF4)
               (bifUSize (U32.blt b8F b1) USize.zero fourUSize)
               fourUSize))
           USize.zero)
         USize.zero)
       USize.zero)

/-- Length of a well-formed sequence at `addr` with `n` bytes available, else `0`. -/
public unsafe def firstLenAt (addr : USize) (n : USize) : USize :=
  bifUSize (USize.beq n USize.zero) USize.zero
    (let b0 := U32.ofU8 (U8.load addr)
     bifUSize (U32.blt b7f b0)
       -- multi-byte lead
       (bifUSize (U32.blt b0 bC2) USize.zero
         (bifUSize (U32.blt bDF b0)
           (bifUSize (U32.blt bEF b0)
             (bifUSize (U32.blt bF4 b0) USize.zero
               -- F0..F4
               (bifUSize (U32.blt b0 bF0) USize.zero (len4 addr n b0)))
             -- E0..EF
             (bifUSize (U32.blt b0 bE0) USize.zero (len3 addr n b0)))
           -- C2..DF
           (len2 addr n)))
       -- 00..7F
       USize.one)

/-- Length of first codepoint at `addr`/`n`, or `0` if invalid/empty. -/
public unsafe def firstLen (addr : USize) (n : USize) : USize :=
  firstLenAt addr n

/-- Validate loop: `0` ok through end, `1` on first invalid sequence. -/
public unsafe def validateGo (addr : USize) (n : USize) (i : USize) : U32 :=
  bifU32 (USize.blt i n)
    (let rem := USize.sub n i
     let len := firstLenAt (USize.add addr i) rem
     bifU32 (USize.beq len USize.zero) err
       (validateGo addr n (USize.add i len)))
    ok

/-- Status of UTF-8 validate over full range: `0` ok, `1` invalid. -/
public unsafe def validate (addr : USize) (n : USize) : U32 :=
  validateGo addr n USize.zero

/-- Count loop: codepoint total, or `USize.neg1` if invalid. -/
public unsafe def countGo (addr : USize) (n : USize) (i : USize) (acc : USize) : USize :=
  bifUSize (USize.blt i n)
    (let rem := USize.sub n i
     let len := firstLenAt (USize.add addr i) rem
     bifUSize (USize.beq len USize.zero) USize.neg1
       (countGo addr n (USize.add i len) (USize.add acc USize.one)))
    acc

/-- Codepoint count, or `USize.neg1` if the range is not well-formed UTF-8. **LP64 miss.** -/
public unsafe def count (addr : USize) (n : USize) : USize :=
  countGo addr n USize.zero USize.zero

end Systems.Utf8
