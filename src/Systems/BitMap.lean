/-
Copyright (c) 2026 Lean FRO, LLC. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Hunter Beast
-/
module
prelude
public import Systems.Scalars
public import Systems.Numerics
public import Systems.Status

/-!
# Systems.BitMap (Systems Lean)

Fixed-capacity **multi-word U32 bitmap** over caller-owned word slots — multi-word
twin of single-word `BitSet`. Not a growable infinite bit vector, not concurrent,
not managed storage.

Layout (caller-owned):

* `words` — `cap` host-endian `U32` slots (`cap * 4` bytes), **4-byte aligned**
* bit capacity `nBits = cap * 32` (requires `cap > 0` for set/clear/test of live bits)

Ops:

* **nBits** — `cap * 32`
* **clearAll** — zero all words (store status dataflow-used)
* **set** / **clear** / **test** — mutate/query absolute bit index (`bit < nBits`)
* **isEmpty** — `1` if every word is zero, else `0` (`cap == 0` → empty)
* **wordAt** — word at index as `USize`, or miss if `i ≥ cap`

Honesty:

* **Caller buffer only** — never malloc/free; does not own `words`.
* **U32 words only** — 32 bits per slot (not U64 `BitSet`/`Bloom` words).
* Out-of-range bit indices for set/clear return `errBounds` (3); test returns `0`.
* Not claimed: infinite bits, popcount API, concurrent bitmaps, or Init `BitSet` parity.
* Store status is dataflow-used so EmitC cannot DCE word writes (`never_extract`).

## Intentional TCB (BitMap-local)

`U32.load`/`store`, `USize` arithmetic, and 32-bit width constants are freestanding
`@[extern]` axioms kept **here**. Name-pinned on ComplianceCorpus (`path name=Ident`).
-/

namespace Systems.BitMap

open Systems.Scalars
open Systems.Numerics
open Systems.Status

/-- Host-endian `uint32_t` load (`addr` must be 4-byte aligned). -/
@[extern c inline "(*((const uint32_t*)(#1)))"]
public axiom U32.load : USize → U32

/-- Host-endian `uint32_t` store; returns `0` (`addr` must be 4-byte aligned). -/
@[never_extract, extern c inline "(*((uint32_t*)(#1)) = (uint32_t)(#2), (uint32_t)0)"]
public axiom U32.store : USize → U32 → U32

/-- Widen `U32` → `USize`. -/
@[extern c inline "((size_t)(uint32_t)(#1))"]
public axiom USize.ofU32 : U32 → USize

/-- Narrow `USize` → `U32` (bit-in-word index is small). -/
@[extern c inline "((uint32_t)(size_t)(#1))"]
public axiom U32.ofUSize : USize → U32

/-- Unsigned modulo (`a % b`). Caller must keep `b ≠ 0`. -/
@[extern c inline "((size_t)((size_t)(#1) % (size_t)(#2)))"]
public axiom USize.mod : USize → USize → USize

/-- Unsigned divide. -/
@[extern c inline "((size_t)((size_t)(#1) / (size_t)(#2)))"]
public axiom USize.div : USize → USize → USize

/-- Unsigned multiply. -/
@[extern c inline "((size_t)((size_t)(#1) * (size_t)(#2)))"]
public axiom USize.mul : USize → USize → USize

/-- Thirty-two as `USize` (bits per word). -/
@[extern c inline "((size_t)32)"] public axiom thirtyTwoUSize : USize

/-- Address of `U32` slot `i` in a contiguous word array at `base`. -/
public def u32Slot (base : USize) (i : USize) : USize :=
  USize.add base (USize.mul i USize.four)

/-- Bit capacity: `cap * 32`. -/
public unsafe def nBits (cap : USize) : USize :=
  USize.mul cap thirtyTwoUSize

/-- Clear word `i` and continue. Store status dataflow-used. -/
public unsafe def clearAllGo (words : USize) (cap : USize) (i : USize) : U32 :=
  bifU32 (USize.blt i cap)
    (let st := U32.store (u32Slot words i) U32.zero
     bifU32 (isOk st) (clearAllGo words cap (USize.add i USize.one)) st)
    ok

/-- Zero all `cap` bitmap words. `0` ok. -/
public unsafe def clearAll (words : USize) (cap : USize) : U32 :=
  clearAllGo words cap USize.zero

/-- `1` if every word in `[0, cap)` is zero, else `0`. Empty cap is empty. -/
public unsafe def isEmptyGo (words : USize) (cap : USize) (i : USize) : U32 :=
  bifU32 (USize.blt i cap)
    (bifU32 (U32.beq (U32.load (u32Slot words i)) U32.zero)
      (isEmptyGo words cap (USize.add i USize.one))
      U32.zero)
    U32.one

/-- `1` if no bits set across `cap` words, else `0`. -/
public unsafe def isEmpty (words : USize) (cap : USize) : U32 :=
  isEmptyGo words cap USize.zero

/-- Word at index as `USize`, or miss if `i ≥ cap`. **LP64 only**. -/
public unsafe def wordAt (words : USize) (cap : USize) (i : USize) : USize :=
  bifUSize (USize.blt i cap)
    (USize.ofU32 (U32.load (u32Slot words i)))
    USize.neg1

/-- Set absolute bit `bit` when `bit < cap*32`. `0` ok; `3` if out of range / empty. -/
public unsafe def set (words : USize) (cap : USize) (bit : USize) : U32 :=
  bifU32 (USize.beq cap USize.zero) errBounds
    (let nb := nBits cap
     bifU32 (USize.blt bit nb)
       (let wIdx := USize.div bit thirtyTwoUSize
        let bInW := USize.mod bit thirtyTwoUSize
        let slot := u32Slot words wIdx
        let old := U32.load slot
        let neu := U32.lor old (U32.shiftLeft U32.one (U32.ofUSize bInW))
        let st := U32.store slot neu
        bifU32 (isOk st) ok st)
       errBounds)

/-- Clear absolute bit `bit` when `bit < cap*32`. `0` ok; `3` if out of range / empty. -/
public unsafe def clear (words : USize) (cap : USize) (bit : USize) : U32 :=
  bifU32 (USize.beq cap USize.zero) errBounds
    (let nb := nBits cap
     bifU32 (USize.blt bit nb)
       (let wIdx := USize.div bit thirtyTwoUSize
        let bInW := USize.mod bit thirtyTwoUSize
        let slot := u32Slot words wIdx
        let old := U32.load slot
        let mask := U32.shiftLeft U32.one (U32.ofUSize bInW)
        let neu := U32.land old (U32.lnot mask)
        let st := U32.store slot neu
        bifU32 (isOk st) ok st)
       errBounds)

/-- `1` if absolute bit `bit` is set, else `0` (also `0` if out of range / empty). -/
public unsafe def test (words : USize) (cap : USize) (bit : USize) : U32 :=
  bifU32 (USize.beq cap USize.zero) U32.zero
    (let nb := nBits cap
     bifU32 (USize.blt bit nb)
       (let wIdx := USize.div bit thirtyTwoUSize
        let bInW := USize.mod bit thirtyTwoUSize
        let w := U32.load (u32Slot words wIdx)
        bifU32 (U32.beq (U32.land w (U32.shiftLeft U32.one (U32.ofUSize bInW))) U32.zero)
          U32.zero U32.one)
       U32.zero)

end Systems.BitMap
