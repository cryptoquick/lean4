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
# Systems.SkipList (Systems Lean)

Fixed-capacity **skiplist-shaped ordered multiset** of `U32` over caller-owned slots —
not a concurrent skip list, not a general map, not malloc-backed nodes.

Layout (caller-owned):

* `slots` — `cap` host-endian `U32` slots (`cap * 4` bytes), **4-byte aligned**
* `n` / occupancy — dual `USize` owned by the **caller** (not stored by this module)
* Invariant: `slots[0..n)` is sorted **non-decreasing** (multiset order)

Simplified “levels”: this port keeps a **single dense level** (ordered vector with
binary lower-bound + shift insert/remove). Multi-level forward pointers and random
height promotion are intentionally omitted for residual-clean dual-param freestanding.

Ops:

* **lowerBound** — first index `i` with `slots[i] ≥ key`, or `n` if all smaller
* **contains** / **countKey** — presence / multiplicity of `key`
* **insert** — insert `key` keeping order when `n < cap` (multiset; dups allowed)
* **remove** — remove one occurrence of `key` when present
* **get** / **isEmpty** / **isFull** / **len** / **cap** — occupancy helpers

No malloc. Store status is dataflow-used so EmitC cannot DCE slot writes.

## Portability / ABI

* **Alignment:** `U32.load` / `U32.store` require 4-byte-aligned `slots`.
* **Capacity contract:** `u32Slot` uses `USize.mul i 4` without overflow checks.
* **LP64 product harness:** `get` miss uses `USize.neg1`. On ILP32 that collides with
  storing `UINT32_MAX` — treat as **LP64-only** (Map `get` class).
* **Not claimed:** concurrent skiplist, probabilistic levels, node pointers, or
  `Std.TreeMap` / `Std.HashMap` parity.

## Intentional TCB (SkipList-local)

`U32.load`/`store`, `USize.ofU32`/`mul`/`half` are freestanding `@[extern]` axioms
kept **here**. Name-pinned on ComplianceCorpus (`path name=Ident`).
-/

namespace Systems.SkipList

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

/-- Unsigned multiply. -/
@[extern c inline "((size_t)((size_t)(#1) * (size_t)(#2)))"]
public axiom USize.mul : USize → USize → USize

/-- Unsigned half: `x / 2`. -/
@[extern c inline "((size_t)((size_t)(#1) / (size_t)2))"]
public axiom USize.half : USize → USize

/-- Address of `U32` slot `i` in a contiguous word array at `base`. -/
public def u32Slot (base : USize) (i : USize) : USize :=
  USize.add base (USize.mul i USize.four)

/-- Current length (pass-through of caller-owned `n`). -/
@[inline] public def len (n : USize) : USize := n

/-- Capacity (pass-through of caller-owned `cap`). -/
@[inline] public def capacity (cap : USize) : USize := cap

/-- `1` if `n == 0`, else `0`. -/
@[inline] public def isEmpty (n : USize) : U32 :=
  bifU32 (USize.beq n USize.zero) U32.one U32.zero

/-- `1` if `n == cap` (full), else `0`. `cap == 0` is treated as full. -/
@[inline] public def isFull (cap : USize) (n : USize) : U32 :=
  bifU32 (USize.beq cap USize.zero) U32.one
    (bifU32 (USize.beq n cap) U32.one U32.zero)

/-- Binary lower-bound on `[lo, hi)`: first index with value `≥ key`, or `hi`. -/
public unsafe def lowerBoundGo (slots : USize) (lo : USize) (hi : USize) (key : U32) : USize :=
  bifUSize (USize.blt lo hi)
    (let mid := USize.add lo (USize.half (USize.sub hi lo))
     let v := U32.load (u32Slot slots mid)
     bifUSize (U32.blt v key)
       (lowerBoundGo slots (USize.add mid USize.one) hi key)
       (lowerBoundGo slots lo mid key))
    lo

/-- First index `i` in `[0, n)` with `slots[i] ≥ key`, or `n` if all smaller. -/
public unsafe def lowerBound (slots : USize) (n : USize) (key : U32) : USize :=
  lowerBoundGo slots USize.zero n key

/-- `1` if `key` is present in sorted `[0, n)`, else `0`. -/
public unsafe def contains (slots : USize) (n : USize) (key : U32) : U32 :=
  let i := lowerBound slots n key
  bifU32 (USize.blt i n)
    (bifU32 (U32.beq (U32.load (u32Slot slots i)) key) U32.one U32.zero)
    U32.zero

/-- Count multiplicity of `key` from index `i` (must be first match or past). -/
public unsafe def countKeyGo (slots : USize) (i : USize) (n : USize)
    (key : U32) (acc : USize) : USize :=
  bifUSize (USize.blt i n)
    (bifUSize (U32.beq (U32.load (u32Slot slots i)) key)
      (countKeyGo slots (USize.add i USize.one) n key (USize.add acc USize.one))
      acc)
    acc

/-- Number of occurrences of `key` in sorted `[0, n)`. -/
public unsafe def countKey (slots : USize) (n : USize) (key : U32) : USize :=
  let i := lowerBound slots n key
  bifUSize (USize.blt i n)
    (bifUSize (U32.beq (U32.load (u32Slot slots i)) key)
      (countKeyGo slots i n key USize.zero)
      USize.zero)
    USize.zero

/-- Bounds-safe get: value as `USize`, or `USize.neg1` if `i ≥ n`. **LP64 only**. -/
public unsafe def get (slots : USize) (n : USize) (i : USize) : USize :=
  bifUSize (USize.blt i n)
    (USize.ofU32 (U32.load (u32Slot slots i)))
    USize.neg1

/-- Shift elements `[from, n)` one slot right (needs free slot at `n`).

`j` starts at `n` and walks down; while `from < j`, copy `j-1 → j`.
Store status dataflow-used. -/
public unsafe def shiftRightGo (slots : USize) (j : USize) (from_ : USize) : U32 :=
  bifU32 (USize.blt from_ j)
    (let src := USize.sub j USize.one
     let v := U32.load (u32Slot slots src)
     let st := U32.store (u32Slot slots j) v
     bifU32 (isOk st) (shiftRightGo slots src from_) st)
    ok

/-- Insert `key` keeping non-decreasing order. `0` ok; `3` if full / `cap == 0`.

Does **not** update caller length — on success the caller must use `n + 1`.
Duplicates are allowed (multiset). -/
public unsafe def insert (slots : USize) (cap : USize) (n : USize) (key : U32) : U32 :=
  bifU32 (USize.beq cap USize.zero) errBounds
    (bifU32 (USize.beq n cap) errBounds
      (let pos := lowerBound slots n key
       bifU32 (USize.beq pos n)
         (let st := U32.store (u32Slot slots n) key
          bifU32 (isOk st) ok st)
         (let st1 := shiftRightGo slots n pos
          bifU32 (isOk st1)
            (let st2 := U32.store (u32Slot slots pos) key
             bifU32 (isOk st2) ok st2)
            st1)))

/-- Shift elements `(from, n)` one slot left (drop index `from`).

`j` walks from `from` toward `n-1`. Store status dataflow-used. -/
public unsafe def shiftLeftGo (slots : USize) (j : USize) (n : USize) : U32 :=
  let next := USize.add j USize.one
  bifU32 (USize.blt next n)
    (let v := U32.load (u32Slot slots next)
     let st := U32.store (u32Slot slots j) v
     bifU32 (isOk st) (shiftLeftGo slots next n) st)
    ok

/-- Remove one occurrence of `key`. `0` ok; `1` if absent.

Does **not** update caller length — on success the caller must use `n - 1`. -/
public unsafe def remove (slots : USize) (n : USize) (key : U32) : U32 :=
  bifU32 (USize.beq n USize.zero) err
    (let pos := lowerBound slots n key
     bifU32 (USize.blt pos n)
       (bifU32 (U32.beq (U32.load (u32Slot slots pos)) key)
         (shiftLeftGo slots pos n)
         err)
       err)

/-- Clear is occupancy-only: returns `ok`. Caller must set `n := 0`. -/
@[never_extract]
public def clear (_slots : USize) (_cap : USize) : U32 :=
  ok

end Systems.SkipList
