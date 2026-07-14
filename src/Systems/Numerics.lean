/-
Copyright (c) 2026 Lean FRO, LLC. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Hunter Beast
-/
module
prelude
public import Systems.Scalars

/-!
# Systems.Numerics (Systems Lean)

Fixed-width numeric utilities for freestanding embeds (R7 first wave).

Extends `Systems.Scalars` with bitwise ops, shifts, min/max, saturating
add/sub, clamp, and defined rotate left/right — without `Init` or multi-field
products. All values are freestanding unboxed scalars (`U16`/`U32`/`U64`/`USize`).

**Not claimed:** full Init `UInt*` API parity, checked multiply, or signed ops.
-/

namespace Systems.Numerics

open Systems.Scalars

/-! ## U16 -/

@[extern c inline "#1 + #2"] public axiom U16.add : U16 → U16 → U16
@[extern c inline "#1 - #2"] public axiom U16.sub : U16 → U16 → U16
@[extern c inline "#1 * #2"] public axiom U16.mul : U16 → U16 → U16
@[extern c inline "((uint16_t)(#1) & (uint16_t)(#2))"] public axiom U16.land : U16 → U16 → U16
@[extern c inline "((uint16_t)(#1) | (uint16_t)(#2))"] public axiom U16.lor : U16 → U16 → U16
@[extern c inline "((uint16_t)(#1) ^ (uint16_t)(#2))"] public axiom U16.xor : U16 → U16 → U16
@[extern c inline "0"] public axiom U16.zero : U16
@[extern c inline "1"] public axiom U16.one : U16
@[extern c inline "((uint16_t)(#1))"] public axiom U16.ofU8 : U8 → U16
@[extern c inline "((uint32_t)(uint16_t)(#1))"] public axiom U32.ofU16 : U16 → U32

/-! ## U32 bitwise / shifts -/

@[extern c inline "((uint32_t)(#1) & (uint32_t)(#2))"] public axiom U32.land : U32 → U32 → U32
@[extern c inline "((uint32_t)(#1) | (uint32_t)(#2))"] public axiom U32.lor : U32 → U32 → U32
/-- Left shift; shift amount is freestanding `U32` (C promotes as needed). -/
@[extern c inline "((uint32_t)(#1) << (unsigned)(#2))"] public axiom U32.shiftLeft : U32 → U32 → U32
/-- Logical right shift. -/
@[extern c inline "((uint32_t)(#1) >> (unsigned)(#2))"] public axiom U32.shiftRight : U32 → U32 → U32
/-- Bitwise not. -/
@[extern c inline "((uint32_t)~(uint32_t)(#1))"] public axiom U32.lnot : U32 → U32
/-- All-bits-one `uint32_t`. -/
@[extern c inline "((uint32_t)-1)"] public axiom U32.neg1 : U32
/-- Constant 32 for rotate helpers. -/
@[extern c inline "32"] public axiom U32.k32 : U32
/-- 5-bit mask (`0x1f`) for defined `uint32_t` rotate shift amounts. -/
@[extern c inline "((uint32_t)31)"] public axiom U32.k31mask : U32
/-- Unsigned `<` as raw `uint8_t` 0/1. -/
@[extern c inline "(uint8_t)((uint32_t)(#1) < (uint32_t)(#2))"] public axiom U32.bltU8 : U32 → U32 → U8

@[inline] public def U32.blt (a b : U32) : Bool :=
  Bool.ofU8 (U32.bltU8 a b)

/-! ## U64 extras -/

@[extern c inline "((uint64_t)(#1) & (uint64_t)(#2))"] public axiom U64.land : U64 → U64 → U64
@[extern c inline "((uint64_t)(#1) | (uint64_t)(#2))"] public axiom U64.lor : U64 → U64 → U64
@[extern c inline "((uint64_t)(#1) ^ (uint64_t)(#2))"] public axiom U64.xor : U64 → U64 → U64
/-- Bitwise not. -/
@[extern c inline "((uint64_t)~(uint64_t)(#1))"] public axiom U64.lnot : U64 → U64
@[extern c inline "((uint64_t)(#1) << (unsigned)(#2))"] public axiom U64.shiftLeft : U64 → U64 → U64
@[extern c inline "((uint64_t)(#1) >> (unsigned)(#2))"] public axiom U64.shiftRight : U64 → U64 → U64
@[extern c inline "0"] public axiom U64.zero : U64
@[extern c inline "1"] public axiom U64.one : U64
@[extern c inline "((uint64_t)-1)"] public axiom U64.neg1 : U64
/-- Constant 64 for rotate helpers. -/
@[extern c inline "64"] public axiom U64.k64 : U64
/-- 6-bit mask (`0x3f`) for defined `uint64_t` rotate shift amounts. -/
@[extern c inline "((uint64_t)63)"] public axiom U64.k63mask : U64
@[extern c inline "(uint8_t)((uint64_t)(#1) == (uint64_t)(#2))"] public axiom U64.beqU8 : U64 → U64 → U8
/-- Unsigned `<` as raw `uint8_t` 0/1. -/
@[extern c inline "(uint8_t)((uint64_t)(#1) < (uint64_t)(#2))"] public axiom U64.bltU8 : U64 → U64 → U8

@[inline] public def U64.beq (a b : U64) : Bool :=
  Bool.ofU8 (U64.beqU8 a b)

@[inline] public def U64.blt (a b : U64) : Bool :=
  Bool.ofU8 (U64.bltU8 a b)

/-! ## Min / max (scalar bif, no products) -/

/-- Unsigned `USize` minimum. -/
@[macro_inline, expose] public def USize.min (a b : USize) : USize :=
  bifUSize (USize.blt a b) a b

/-- Unsigned `USize` maximum. -/
@[macro_inline, expose] public def USize.max (a b : USize) : USize :=
  bifUSize (USize.blt a b) b a

/-- Unsigned `U32` minimum. -/
@[macro_inline, expose] public def U32.min (a b : U32) : U32 :=
  bifU32 (U32.blt a b) a b

/-- Unsigned `U32` maximum. -/
@[macro_inline, expose] public def U32.max (a b : U32) : U32 :=
  bifU32 (U32.blt a b) b a

/-- Unsigned `U64` minimum. -/
@[macro_inline, expose] public def U64.min (a b : U64) : U64 :=
  bifU64 (U64.blt a b) a b

/-- Unsigned `U64` maximum. -/
@[macro_inline, expose] public def U64.max (a b : U64) : U64 :=
  bifU64 (U64.blt a b) b a

/-! ## Saturating arithmetic + clamp + rotate -/

/-- `a + b` saturating at `UINT32_MAX` (no wrap). -/
public def U32.satAdd (a b : U32) : U32 :=
  bifU32 (U32.blt (U32.sub U32.neg1 a) b) U32.neg1 (U32.add a b)

/-- `a - b` saturating at `0` (no wrap-underflow). -/
public def U32.satSub (a b : U32) : U32 :=
  bifU32 (U32.blt a b) U32.zero (U32.sub a b)

/-- Clamp `x` into `[lo, hi]` (unsigned; assumes `lo ≤ hi`). -/
public def U32.clamp (x lo hi : U32) : U32 :=
  U32.min (U32.max x lo) hi

/-- Rotate left by `k` bits with **defined** ISO C11 shift amounts.

Reduction: `r = k & 31` (explicit mask — C does **not** auto-mod shift counts).
When `r = 0`, returns `x` without shifting by 32 (which would be UB for `uint32_t`).
When `r ∈ 1..31`, uses `(x << r) | (x >> (32 - r))` with both shift counts in `1..31`. -/
public def U32.rotateLeft (x k : U32) : U32 :=
  let r := U32.land k U32.k31mask
  bifU32 (U32.beq r U32.zero) x
    (U32.lor (U32.shiftLeft x r) (U32.shiftRight x (U32.sub U32.k32 r)))

/-- Rotate right by `k` bits with **defined** ISO C11 shift amounts.

Reduction: `r = k & 31`. When `r = 0`, returns `x` (no shift-by-32 UB).
When `r ∈ 1..31`, uses `(x >> r) | (x << (32 - r))`. -/
public def U32.rotateRight (x k : U32) : U32 :=
  let r := U32.land k U32.k31mask
  bifU32 (U32.beq r U32.zero) x
    (U32.lor (U32.shiftRight x r) (U32.shiftLeft x (U32.sub U32.k32 r)))

/-- `a + b` saturating at `UINT64_MAX` (no wrap). -/
public def U64.satAdd (a b : U64) : U64 :=
  bifU64 (U64.blt (U64.sub U64.neg1 a) b) U64.neg1 (U64.add a b)

/-- `a - b` saturating at `0` (no wrap-underflow). -/
public def U64.satSub (a b : U64) : U64 :=
  bifU64 (U64.blt a b) U64.zero (U64.sub a b)

/-- Clamp `x` into `[lo, hi]` (unsigned; assumes `lo ≤ hi`). -/
public def U64.clamp (x lo hi : U64) : U64 :=
  U64.min (U64.max x lo) hi

/-- Rotate left by `k` bits with **defined** ISO C11 shift amounts.

Reduction: `r = k & 63`. When `r = 0`, returns `x` without shifting by 64 (UB for `uint64_t`).
When `r ∈ 1..63`, uses `(x << r) | (x >> (64 - r))`. -/
public def U64.rotateLeft (x k : U64) : U64 :=
  let r := U64.land k U64.k63mask
  bifU64 (U64.beq r U64.zero) x
    (U64.lor (U64.shiftLeft x r) (U64.shiftRight x (U64.sub U64.k64 r)))

/-- Rotate right by `k` bits with **defined** ISO C11 shift amounts.

Reduction: `r = k & 63`. When `r = 0`, returns `x` (no shift-by-64 UB).
When `r ∈ 1..63`, uses `(x >> r) | (x << (64 - r))`. -/
public def U64.rotateRight (x k : U64) : U64 :=
  let r := U64.land k U64.k63mask
  bifU64 (U64.beq r U64.zero) x
    (U64.lor (U64.shiftRight x r) (U64.shiftLeft x (U64.sub U64.k64 r)))

/-! ## USize saturating helpers (pointer-sized, LP64 product harness) -/

/-- `a + b` saturating at `SIZE_MAX` (`USize.neg1`; no wrap). -/
public def USize.satAdd (a b : USize) : USize :=
  bifUSize (USize.uaddWouldOverflow a b) USize.neg1 (USize.add a b)

/-- Clamp `x` into `[lo, hi]` (unsigned; assumes `lo ≤ hi`). -/
public def USize.clamp (x lo hi : USize) : USize :=
  USize.min (USize.max x lo) hi

end Systems.Numerics
