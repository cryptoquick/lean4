/-
Copyright (c) 2026 Lean FRO, LLC. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Hunter Beast
-/
module
prelude
public import Systems.Scalars
public import Systems.Bytes
public import Systems.Status

/-!
# Systems.MemRegion (Systems Lean)

Dual `base`/`len` **memory region view** — region-**shaped** helpers, not OS `mmap`,
not an allocator, and not managed `ByteArray`.

Ops:

* **contains** — `1` if byte offset `off` is in `[0, len)`
* **subregion** — bounds status + base/len pure returns (ByteSpan subspan class)
* **loadU8** / **storeU8** — bounds-checked byte access
* **loadU32** / **storeU32** — bounds-checked host-endian word access (`off + 4 ≤ len`)
* **overlaps** — optional half-open range overlap test

Honesty:

* **Caller-owned** bytes only; this module never malloc/mmap/munmap.
* Not claimed: provenance, page protection, concurrency, or `addr + len` overflow on
  adversarial huge inputs (product harness uses small buffers).
* `U32` accessors require `base + off` **4-byte aligned** (ISO C UB otherwise).

No freestanding multi-field product returns. Status codes follow `Systems.Status`.
-/

namespace Systems.MemRegion

open Systems.Scalars
open Systems.Bytes
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

/-- Pass-through length. -/
@[inline] public def len (n : USize) : USize := n

/-- `1` if `off < n` (byte offset inside the region), else `0`. -/
@[inline] public def contains (n : USize) (off : USize) : U32 :=
  bifU32 (USize.blt off n) U32.one U32.zero

/-- Subregion bounds: `0` ok when `off ≤ n` and `subLen ≤ n - off`, else `errBounds`. -/
public unsafe def subregionOk (n : USize) (off : USize) (subLen : USize) : U32 :=
  bifU32 (USize.blt n off) errBounds
    (bifU32 (USize.blt (USize.sub n off) subLen) errBounds ok)

/-- Subregion base: `base + off` when in bounds, else `USize.neg1`. -/
public unsafe def subregionAddr (base : USize) (n : USize) (off : USize) (subLen : USize) : USize :=
  bifUSize (isOk (subregionOk n off subLen))
    (USize.add base off)
    USize.neg1

/-- Subregion length when in bounds, else `0`. -/
public unsafe def subregionLen (n : USize) (off : USize) (subLen : USize) : USize :=
  bifUSize (isOk (subregionOk n off subLen)) subLen USize.zero

/-- Bounds-safe byte load: value `0..255` as `USize`, or `USize.neg1` if `off ≥ n`.

**LP64 only** for the miss sentinel. -/
public unsafe def loadU8 (base : USize) (n : USize) (off : USize) : USize :=
  bifUSize (USize.blt off n)
    (USize.ofU8 (U8.load (USize.add base off)))
    USize.neg1

/-- Bounds-safe byte store: `0` ok, `errBounds` if `off ≥ n`.

Store status is dataflow-used so EmitC cannot DCE the write. -/
public unsafe def storeU8 (base : USize) (n : USize) (off : USize) (v : U8) : U32 :=
  bifU32 (USize.blt off n)
    (let st := U8.store (USize.add base off) v
     bifU32 (isOk st) ok st)
    errBounds

/-- Bounds-safe `U32` load at byte offset `off` when `off + 4 ≤ n`.

Miss → `USize.neg1` (**LP64 only**). Requires 4-byte-aligned `base + off`. -/
public unsafe def loadU32 (base : USize) (n : USize) (off : USize) : USize :=
  bifUSize (USize.blt n (USize.add off USize.four)) USize.neg1
    (USize.ofU32 (U32.load (USize.add base off)))

/-- Bounds-safe `U32` store at byte offset `off` when `off + 4 ≤ n`.

`0` ok, `errBounds` if out of range. Store status is dataflow-used. -/
public unsafe def storeU32 (base : USize) (n : USize) (off : USize) (v : U32) : U32 :=
  bifU32 (USize.blt n (USize.add off USize.four)) errBounds
    (let st := U32.store (USize.add base off) v
     bifU32 (isOk st) ok st)

/-- Half-open range overlap: `1` if `[a, a+na)` intersects `[b, b+nb)`, else `0`.

Empty ranges (`na == 0` or `nb == 0`) never overlap. Overflow of `a+na` / `b+nb` on
adversarial huge inputs is not a product harness claim. -/
public unsafe def overlaps (a : USize) (na : USize) (b : USize) (nb : USize) : U32 :=
  bifU32 (USize.beq na USize.zero) U32.zero
    (bifU32 (USize.beq nb USize.zero) U32.zero
      (bifU32 (USize.blt a (USize.add b nb))
        (bifU32 (USize.blt b (USize.add a na)) U32.one U32.zero)
        U32.zero))

end Systems.MemRegion
