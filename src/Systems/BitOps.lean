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
# Systems.BitOps (Systems Lean)

Bit manipulation helpers for freestanding systems code: masks, population-style
loops, test/set/clear bit, and byte swap for `U32`.

No `Init` / `BitVec` RC — unboxed freestanding scalars only.
-/

namespace Systems.BitOps

open Systems.Scalars
open Systems.Numerics

/-- `1u << b` with `b` used as shift amount (caller keeps `b < 32` for defined shifts). -/
@[inline] public def U32.bit (b : U32) : U32 :=
  U32.shiftLeft U32.one b

/-- Test whether bit `b` of `x` is set (`0`/`1` as `U32`). -/
public def U32.testBit (x b : U32) : U32 :=
  bifU32 (U32.beq (U32.land x (U32.bit b)) U32.zero) U32.zero U32.one

/-- Set bit `b` of `x`. -/
@[inline] public def U32.setBit (x b : U32) : U32 :=
  U32.lor x (U32.bit b)

/-- Clear bit `b` of `x`. -/
@[inline] public def U32.clearBit (x b : U32) : U32 :=
  U32.land x (U32.lnot (U32.bit b))

/-- Toggle bit `b` of `x`. -/
@[inline] public def U32.flipBit (x b : U32) : U32 :=
  U32.lor (U32.land x (U32.lnot (U32.bit b)))
    (U32.land (U32.lnot x) (U32.bit b))

/-- Mask with low `k` bits set (`k = 0 → 0`, `k ≥ 32 → all ones` via saturating style).

For `k ∈ 1..31`: `(1 << k) - 1`. For `k = 0`: `0`. For `k ≥ 32`: `0xFFFFFFFF`. -/
public def U32.lowMask (k : U32) : U32 :=
  bifU32 (U32.beq k U32.zero) U32.zero
    (bifU32 (U32.blt k U32.k32)
      (U32.sub (U32.shiftLeft U32.one k) U32.one)
      U32.neg1)

/-- Count set bits in `x` (Kernighan-style loop; self-TCO). `i` is remaining word. -/
public unsafe def U32.popcountGo (i : U32) (acc : U32) : U32 :=
  bifU32 (U32.beq i U32.zero) acc
    (U32.popcountGo (U32.land i (U32.sub i U32.one)) (U32.add acc U32.one))

/-- Population count of `x`. -/
public unsafe def U32.popcount (x : U32) : U32 :=
  U32.popcountGo x U32.zero

/-- Byte-swap `U32` (endian convert). Decimal masks only (no hex in freestanding inlines). -/
@[extern c inline "\
((uint32_t)(\
  ((((uint32_t)(#1)) & 255u) << 24) |\
  ((((uint32_t)(#1)) & 65280u) << 8) |\
  ((((uint32_t)(#1)) & 16711680u) >> 8) |\
  ((((uint32_t)(#1)) & 4278190080u) >> 24)))"]
public axiom U32.bswap : U32 → U32

end Systems.BitOps
