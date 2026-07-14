/-
Copyright (c) 2026 Lean FRO, LLC. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Hunter Beast
-/
module
prelude
public import Systems.Scalars
public import Systems.Numerics
public import Systems.BitVec

/-!
# Systems.BitSet (Systems Lean)

Fixed **64-bit bit set** over a single freestanding `U64` word — the bitset
algorithm on one machine word. Not an infinite / growable multi-word bit vector
and not managed storage. Word width is an implementation detail of this product
module (documented here; not encoded in the module name).

Ops (word is pure `U64`; no heap):

* **empty** — zero word
* **set** / **clear** / **test** bit `i` (`i` masked to 6 bits, same class as `BitVec.bit`)
* **count** — population count of the word (`BitVec.popcount` over width 64)
* **isEmpty** — `1` if word is zero, else `0`
* **land** / **lor** / **lxor** — bitwise and/or/xor of two words

Honesty:

* **64 bits only** — not infinite bits, not multi-word growable storage, not Init library collections.
* Bit index is masked to `0..63` (defined ISO C shifts); out-of-range raw indices wrap
  into that range rather than failing closed.
* Prefer pure Lean; reuses `Systems.BitVec` / `Systems.Numerics` (no module-local axioms).
* **C ABI:** product exports stay `lean_fs_bitset_*` (stable short name; not renamed).
-/

namespace Systems.BitSet

open Systems.Scalars
open Systems.Numerics
open Systems.BitVec

/-- Empty bitset (all clear). -/
@[inline] public def empty : U64 :=
  U64.zero

/-- `1` if `w` has no bits set, else `0`. -/
@[inline] public def isEmpty (w : U64) : U32 :=
  bifU32 (U64.beq w U64.zero) U32.one U32.zero

/-- Test bit `i` of `w` (`0`/`1` as `U32`; index masked to 6 bits). -/
public def test (w : U64) (i : U64) : U32 :=
  bifU32 (U64.beq (testBit w i) U64.zero) U32.zero U32.one

/-- Set bit `i` of `w` (index masked to 6 bits). -/
@[inline] public def set (w : U64) (i : U64) : U64 :=
  setBit w i

/-- Clear bit `i` of `w` (index masked to 6 bits). -/
@[inline] public def clear (w : U64) (i : U64) : U64 :=
  clearBit w i

/-- Population count of all 64 bits of `w`. -/
public unsafe def count (w : U64) : U64 :=
  popcount w U64.k64

/-- Bitwise and of two bitset words. -/
@[inline] public def land (a b : U64) : U64 :=
  U64.land a b

/-- Bitwise or of two bitset words. -/
@[inline] public def lor (a b : U64) : U64 :=
  U64.lor a b

/-- Bitwise xor of two bitset words. -/
@[inline] public def lxor (a b : U64) : U64 :=
  U64.xor a b

end Systems.BitSet
