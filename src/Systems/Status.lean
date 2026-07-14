/-
Copyright (c) 2026 Lean FRO, LLC. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Hunter Beast
-/
module
prelude
public import Systems.Scalars

/-!
# Systems.Status (Systems Lean)

Result / Option-style **dual-value patterns without Init** (R7 first wave).

Freestanding forbids multi-field product *values* on the extract path, so there is no
`Option α` / `Except ε α` / `Result` inductive carrying two fields. Instead:

* **Status codes** are freestanding `U32` (`0` = ok; nonzero = class of failure).
* **Optional lengths / indices** use existing sentinels (`USize.neg1` / `neg2` / `neg3`)
  as in `Sys` log/arena APIs.
* Branching uses freestanding `Bool` + `bifU32` / `bifUSize` (no Init `ite`/`match`).

Host proofs that need full `Option`/`Except` stay on classic Init (dual-path).
-/

namespace Systems.Status

open Systems.Scalars

/-- Ok status (`0`). Alias of `U32.zero` for documentation. -/
@[inline] public def ok : U32 := U32.zero

/-- Generic failure (`1`). -/
@[inline] public def err : U32 := U32.one

/-- IO / open failure (`2`). -/
@[inline] public def errIo : U32 := U32.two

/-- Bounds / buffer-too-small (`3`). -/
@[inline] public def errBounds : U32 := U32.three

/-- True when status is ok (`0`). -/
@[inline] public def isOk (s : U32) : Bool :=
  U32.beq s U32.zero

/-- True when status is nonzero. -/
@[inline] public def isErr (s : U32) : Bool :=
  bifBool (isOk s) Bool.false Bool.true

/-- If `s` is ok, return `t`, else `e` (`U32` arms). -/
@[macro_inline, expose] public def ifOkU32 (s : U32) (t e : U32) : U32 :=
  bifU32 (isOk s) t e

/-- If `s` is ok, return `t`, else `e` (`USize` arms). -/
@[macro_inline, expose] public def ifOkUSize (s : U32) (t e : USize) : USize :=
  bifUSize (isOk s) t e

/-- Map ok → `U32.zero`, any error → `U32.one` (normalize status classes). -/
@[inline] public def normalize (s : U32) : U32 :=
  bifU32 (isOk s) U32.zero U32.one

/-- Sequential composition: if `s1` is ok return `s2`, else keep `s1` (first failure). -/
public def andThen (s1 s2 : U32) : U32 :=
  bifU32 (isOk s1) s2 s1

/-- Prefer success: if `s1` is ok return `s1`, else return `s2`. -/
public def orElse (s1 s2 : U32) : U32 :=
  bifU32 (isOk s1) s1 s2

/-- Optional index: true when `i` is not the not-found sentinel. -/
@[inline] public def isSomeUSize (i : USize) : Bool :=
  bifBool (USize.beq i USize.neg1) Bool.false Bool.true

/-- Optional index: true when `i == USize.neg1`. -/
@[inline] public def isNoneUSize (i : USize) : Bool :=
  USize.beq i USize.neg1

/-- `some`-style: return `v` if `found`, else not-found sentinel. -/
@[macro_inline, expose] public def someOrNeg1 (found : Bool) (v : USize) : USize :=
  bifUSize found v USize.neg1

/-- Combine status with optional length: on error return `errSentinel`, else `len`.

Typical dual-value pattern without products: caller gets one `USize` that is either a
length/value or a documented sentinel (`neg2` IO, `neg3` bounds, …). -/
public def valueOr (s : U32) (len : USize) (errSentinel : USize) : USize :=
  bifUSize (isOk s) len errSentinel

end Systems.Status
