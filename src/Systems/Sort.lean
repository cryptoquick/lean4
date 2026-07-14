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
# Systems.Sort (Systems Lean)

Fixed-capacity **in-place insertion sort** over a caller-owned `U32` buffer —
sort-**shaped**, not a full stdlib sort library (`Array.sort`, introsort, …).

Layout (caller-owned):

* `slots` — `n` host-endian `U32` words (`n * 4` bytes), **4-byte aligned**
* `n` — element count (sorts the prefix `[0, n)`)

Ops:

* **sortU32** — ascending unsigned insertion sort; returns `Systems.Status.ok`
* **isSortedU32** — `1` if non-decreasing, else `0` (empty/singleton count as sorted)

No malloc. No freestanding multi-field product returns.

## Portability / ABI

* **Alignment:** word load/store require 4-byte-aligned `slots`.
* **Capacity contract:** `u32Slot` uses `USize.mul i 4` without overflow checks (Map
  parity). Keep `n` small enough that `n * 4` fits in `size_t`.
* **Not claimed:** generic comparators, stable multi-key sorts, descending-only API,
  parallel sort, or asymptotic guarantees beyond textbook insertion sort (`O(n²)`).

## Intentional TCB (Sort-local)

`U32.load`/`store`, `USize.mul` are freestanding `@[extern]` axioms kept **here**
(Map parity). Name-pinned on ComplianceCorpus (`path name=Ident`).
-/

namespace Systems.Sort

open Systems.Scalars
open Systems.Numerics
open Systems.Status

/-- Host-endian `uint32_t` load (`addr` must be 4-byte aligned). -/
@[extern c inline "(*((const uint32_t*)(#1)))"]
public axiom U32.load : USize → U32

/-- Host-endian `uint32_t` store; returns `0` (`addr` must be 4-byte aligned). -/
@[never_extract, extern c inline "(*((uint32_t*)(#1)) = (uint32_t)(#2), (uint32_t)0)"]
public axiom U32.store : USize → U32 → U32

/-- Unsigned multiply. -/
@[extern c inline "((size_t)((size_t)(#1) * (size_t)(#2)))"]
public axiom USize.mul : USize → USize → USize

/-- Address of `U32` slot `i` in a contiguous word array at `base`. -/
@[inline] public def u32Slot (base : USize) (i : USize) : USize :=
  USize.add base (USize.mul i USize.four)

/-- Inner shift: while `j > 0` and `slots[j-1] > key`, move `slots[j-1]` to `j`, then write `key` at `j`.

Store status is dataflow-used so EmitC cannot DCE writes. -/
public unsafe def insertShiftGo (slots : USize) (j : USize) (key : U32) : U32 :=
  -- Use param `j` (not literal `USize.zero`) for the hole index so freestanding
  -- EmitC never extracts `mul zero four` as a closed ground term.
  bifU32 (USize.beq j USize.zero)
    (let st0 := U32.store (u32Slot slots j) key
     bifU32 (isOk st0) ok st0)
    (let jprev := USize.sub j USize.one
     let prev := U32.load (u32Slot slots jprev)
     bifU32 (U32.blt key prev)
       (let st1 := U32.store (u32Slot slots j) prev
        bifU32 (isOk st1)
          (insertShiftGo slots jprev key)
          st1)
       (let st2 := U32.store (u32Slot slots j) key
        bifU32 (isOk st2) ok st2))

/-- Outer insertion-sort loop: for `i = 1 .. n-1`, insert `slots[i]` into sorted prefix. -/
public unsafe def sortGo (slots : USize) (i : USize) (n : USize) : U32 :=
  bifU32 (USize.blt i n)
    (let key := U32.load (u32Slot slots i)
     let st := insertShiftGo slots i key
     bifU32 (isOk st)
       (sortGo slots (USize.add i USize.one) n)
       st)
    ok

/-- In-place ascending insertion sort of `n` `U32` words at `slots`.

`n == 0` / `n == 1` are no-ops returning `ok`. -/
@[never_extract]
public unsafe def sortU32 (slots : USize) (n : USize) : U32 :=
  bifU32 (USize.beq n USize.zero) ok
    (bifU32 (USize.beq n USize.one) ok
      (sortGo slots USize.one n))

/-- Sorted check helper: walk `i` while `slots[i-1] ≤ slots[i]`. -/
public unsafe def isSortedGo (slots : USize) (i : USize) (n : USize) : U32 :=
  bifU32 (USize.blt i n)
    (let a := U32.load (u32Slot slots (USize.sub i USize.one))
     let b := U32.load (u32Slot slots i)
     bifU32 (U32.blt b a) U32.zero
       (isSortedGo slots (USize.add i USize.one) n))
    U32.one

/-- `1` if `[0, n)` is non-decreasing (unsigned), else `0`. Empty/singleton → `1`. -/
public unsafe def isSortedU32 (slots : USize) (n : USize) : U32 :=
  bifU32 (USize.beq n USize.zero) U32.one
    (bifU32 (USize.beq n USize.one) U32.one
      (isSortedGo slots USize.one n))

end Systems.Sort
