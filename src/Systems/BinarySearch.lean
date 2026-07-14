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
# Systems.BinarySearch (Systems Lean)

Binary search over a **caller-owned sorted** `U32` prefix — search-**shaped**, not a
full search library (`Array.binSearch`, multi-key, lower/upper-bound suite, …).

Layout (caller-owned):

* `slots` — `n` host-endian `U32` words (`n * 4` bytes), **4-byte aligned**
* `n` — element count (searches the prefix `[0, n)`)

Ops:

* **findU32** — index of `key` as `USize`, or `USize.neg1` if absent / empty
* **containsU32** — `1` if present, else `0`

## Honesty / contracts

* **Requires sorted input** (non-decreasing unsigned). Unsorted buffers yield
  unspecified results (not a product harness claim).
* **Not claimed:** lower/upper bound pairs as products, generic comparators,
  parallel search, or floating keys.

## Portability / ABI

* **Alignment:** word load requires 4-byte-aligned `slots`.
* **Capacity contract:** `u32Slot` uses `USize.mul i 4` without overflow checks (Map
  parity). Keep `n` small enough that `n * 4` fits in `size_t`.
* **LP64 product harness:** miss uses `USize.neg1` (`(size_t)-1`). On ILP32 that collides
  with storing `UINT32_MAX` as an index — treat as **LP64-only** (Map `get` class).

## Intentional TCB (BinarySearch-local)

`U32.load`, `USize.mul`, `USize.half` are freestanding `@[extern]` axioms kept **here**
(Map/Sort parity). Name-pinned on ComplianceCorpus (`path name=Ident`).
-/

namespace Systems.BinarySearch

open Systems.Scalars
open Systems.Numerics

/-- Host-endian `uint32_t` load (`addr` must be 4-byte aligned). -/
@[extern c inline "(*((const uint32_t*)(#1)))"]
public axiom U32.load : USize → U32

/-- Unsigned multiply. -/
@[extern c inline "((size_t)((size_t)(#1) * (size_t)(#2)))"]
public axiom USize.mul : USize → USize → USize

/-- Unsigned half: `x / 2` (midpoint helper; no `% 0`). -/
@[extern c inline "((size_t)((size_t)(#1) / (size_t)2))"]
public axiom USize.half : USize → USize

/-- Address of `U32` slot `i` in a contiguous word array at `base`. -/
@[inline] public def u32Slot (base : USize) (i : USize) : USize :=
  USize.add base (USize.mul i USize.four)

/-- Binary search on half-open range `[lo, hi)`.

`mid = lo + (hi - lo) / 2`. Equal → `mid`; `v < key` → search right; else left. -/
public unsafe def findGo (slots : USize) (lo : USize) (hi : USize) (key : U32) : USize :=
  bifUSize (USize.blt lo hi)
    (let mid := USize.add lo (USize.half (USize.sub hi lo))
     -- Use param `mid` (not a ground zero) so freestanding EmitC never extracts
     -- `mul zero four` as a closed ground term.
     let v := U32.load (u32Slot slots mid)
     bifUSize (U32.beq v key) mid
       (bifUSize (U32.blt v key)
         (findGo slots (USize.add mid USize.one) hi key)
         (findGo slots lo mid key)))
    USize.neg1

/-- Index of `key` in sorted `[0, n)`, or `USize.neg1` if missing / `n == 0`.

**Requires** non-decreasing unsigned order on `[0, n)`. **LP64 only** for miss. -/
public unsafe def findU32 (slots : USize) (n : USize) (key : U32) : USize :=
  findGo slots USize.zero n key

/-- `1` if `key` is present in sorted `[0, n)`, else `0`. -/
public unsafe def containsU32 (slots : USize) (n : USize) (key : U32) : U32 :=
  bifU32 (USize.beq (findU32 slots n key) USize.neg1) U32.zero U32.one

end Systems.BinarySearch
