/-
Copyright (c) 2026 Lean FRO, LLC. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Hunter Beast
-/
module
prelude
public import Systems.Scalars
public import Systems.Numerics

/-!
# Systems.BitVec (Systems Lean)

BitVec-**shaped** operations over freestanding `U64` (fixed width 64), without `Init.Data.BitVec`
or managed types. Dual scalar params only (`x` / `w` widths as `U64` where needed).

Not a full BitVec library: no dependent width types, no RC vectors of bits.
Reuses `Numerics` U64 bitwise / compare / `lnot` / full-word rotate (no module-local Lean axioms).

Helpers beyond truncate/test/set/clear/shift: `extractLsb`, `concat`, `getMsb`, width-bounded
`rotateLeftW`/`rotateRightW`, and **shaped** `signExtend` (low-`w` arithmetic extend into U64 —
not Init dependent-width `BitVec.signExtend`).
-/

namespace Systems.BitVec

open Systems.Scalars
open Systems.Numerics

/-- `1u << b` with shift amount masked to 6 bits for defined 64-bit shifts. -/
@[inline] public def bit (b : U64) : U64 :=
  U64.shiftLeft U64.one (U64.land b U64.k63mask)

/-- Low `w` bits set as a mask (`w = 0 → 0`, `w ≥ 64 → all ones`). -/
public def lowMask (w : U64) : U64 :=
  bifU64 (U64.beq w U64.zero) U64.zero
    (bifU64 (U64.blt w U64.k64)
      (U64.sub (U64.shiftLeft U64.one w) U64.one)
      U64.neg1)

/-- Truncate `x` to low `w` bits. -/
@[inline] public def truncate (x w : U64) : U64 :=
  U64.land x (lowMask w)

/-- Freestanding register identity (not Init `BitVec.zeroExtend`).

On product U64, the value is already a full machine word — there is no narrower
dependent-width carrier to pad. Ignores `_w`. Do **not** treat this as Init-style
zero-extension from a smaller bitwidth into a larger one. -/
@[inline] public def zeroExtend (x : U64) (_w : U64) : U64 :=
  x

/-- Extract `len` bits starting at `start` (from LSB), then truncate to `len`. -/
public def extractLsb (x start len : U64) : U64 :=
  truncate (U64.shiftRight x (U64.land start U64.k63mask)) len

/-- Test bit `i` of `x` (`0`/`1` as `U64`). -/
public def testBit (x i : U64) : U64 :=
  bifU64 (U64.beq (U64.land x (bit i)) U64.zero) U64.zero U64.one

/-- Set bit `i` of `x`. -/
@[inline] public def setBit (x i : U64) : U64 :=
  U64.lor x (bit i)

/-- Clear bit `i` of `x`. -/
@[inline] public def clearBit (x i : U64) : U64 :=
  U64.land x (U64.lnot (bit i))

/-- Shift left by `s` (masked) then truncate to width `w`. -/
public def shiftLeftTrunc (x s w : U64) : U64 :=
  truncate (U64.shiftLeft x (U64.land s U64.k63mask)) w

/-- Logical shift right by `s` (masked) then truncate to width `w`. -/
public def shiftRightTrunc (x s w : U64) : U64 :=
  truncate (U64.shiftRight x (U64.land s U64.k63mask)) w

/-- And within width `w`. -/
@[inline] public def landW (x y w : U64) : U64 :=
  truncate (U64.land x y) w

/-- Or within width `w`. -/
@[inline] public def lorW (x y w : U64) : U64 :=
  truncate (U64.lor x y) w

/-- Xor within width `w`. -/
@[inline] public def xorW (x y w : U64) : U64 :=
  truncate (U64.xor x y) w

/-- Concatenate high `wHi` bits of `hi` above low `wLo` bits of `lo`.

`(truncate hi wHi) << wLo | (truncate lo wLo)`, then truncated to `wHi + wLo`
(capped by `lowMask` when the sum is ≥ 64). Shift amount for the high half is
masked to 6 bits (`wLo ≥ 64` yields a defined but not Init-BitVec-faithful layout). -/
public def concat (hi lo wHi wLo : U64) : U64 :=
  let total := U64.add wHi wLo
  let high := U64.shiftLeft (truncate hi wHi) (U64.land wLo U64.k63mask)
  truncate (U64.lor high (truncate lo wLo)) total

/-- MSB of the low `w` bits of `x` (`0`/`1` as `U64`; `w = 0 → 0`). -/
public def getMsb (x w : U64) : U64 :=
  bifU64 (U64.beq w U64.zero) U64.zero
    (testBit x (U64.sub w U64.one))

/-- Reduce `k` modulo `w` (`w ≠ 0`). Self-TCO subtraction loop (no `%` primop). -/
private unsafe def remGo (k w : U64) : U64 :=
  bifU64 (U64.blt k w) k (remGo (U64.sub k w) w)

/-- Rotate left within width `w` by `k` bits (defined ISO C shifts).

`w = 0 → 0`. `w ≥ 64` uses full-word `Numerics.U64.rotateLeft` (k masked to 6 bits there).
Otherwise rotates `truncate x w` by `k mod w` and re-truncates. Not Init dependent-width rotate. -/
public unsafe def rotateLeftW (x k w : U64) : U64 :=
  bifU64 (U64.beq w U64.zero) U64.zero
    (bifU64 (U64.blt w U64.k64)
      (let t := truncate x w
       let r := remGo k w
       bifU64 (U64.beq r U64.zero) t
         (truncate (U64.lor (U64.shiftLeft t r) (U64.shiftRight t (U64.sub w r))) w))
      (U64.rotateLeft x k))

/-- Rotate right within width `w` by `k` bits (defined ISO C shifts).

`w = 0 → 0`. `w ≥ 64` uses full-word `Numerics.U64.rotateRight`. Otherwise
`truncate x w` by `k mod w`. Not Init dependent-width rotate. -/
public unsafe def rotateRightW (x k w : U64) : U64 :=
  bifU64 (U64.beq w U64.zero) U64.zero
    (bifU64 (U64.blt w U64.k64)
      (let t := truncate x w
       let r := remGo k w
       bifU64 (U64.beq r U64.zero) t
         (truncate (U64.lor (U64.shiftRight t r) (U64.shiftLeft t (U64.sub w r))) w))
      (U64.rotateRight x k))

/-- Sign-extend low `w` bits of `x` into a full freestanding `U64`.

When the MSB of the low `w` bits is set, fill bits `[w, 64)` with ones; otherwise
return the zero-extended low half (`truncate x w`). `w = 0 → 0`. `w ≥ 64 → x`
(no narrower carrier). **Shaped** helper — not Init `BitVec.signExtend` with dependent width. -/
public def signExtend (x w : U64) : U64 :=
  bifU64 (U64.beq w U64.zero) U64.zero
    (bifU64 (U64.blt w U64.k64)
      (let t := truncate x w
       bifU64 (U64.beq (testBit t (U64.sub w U64.one)) U64.zero) t
         (U64.lor t (U64.lnot (lowMask w))))
      x)

/-- Population count of low `w` bits of `x` (Kernighan loop; self-TCO). -/
public unsafe def popcountGo (i : U64) (acc : U64) : U64 :=
  bifU64 (U64.beq i U64.zero) acc
    (popcountGo (U64.land i (U64.sub i U64.one)) (U64.add acc U64.one))

/-- Population count of `truncate x w`. -/
public unsafe def popcount (x w : U64) : U64 :=
  popcountGo (truncate x w) U64.zero

end Systems.BitVec
