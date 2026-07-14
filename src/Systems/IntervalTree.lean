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
# Systems.IntervalTree (Systems Lean)

Fixed-capacity **ordered U32 interval map** over caller-owned `lo`/`hi` slots —
interval-**shaped** dense ordered intervals, not a concurrent interval tree, not a
full stabbing-query database, not segment tree / fenwick product.

Layout (caller-owned):

* `los` — `cap` host-endian `U32` slots (`cap * 4` bytes), **4-byte aligned**
* `his` — `cap` host-endian `U32` slots, **4-byte aligned**
* `n` / occupancy — dual `USize` owned by the **caller** (not stored by this module)
* **Caller contract:** `n ≤ cap` at every call; `insert` returns `errBounds` if `n > cap`
* Invariant: intervals in `[0, n)` are ordered by **strictly increasing** `lo`
  (unique left endpoints; set/map of intervals)

Simplified “tree”: this port keeps a **single dense ordered leaf** (binary lower-bound
on `lo` + shift insert) with interval-shaped API names. Tree nodes, augments, and
concurrent stabbing structures are intentionally omitted for residual-clean dual-param
freestanding.

Ops:

* **insert** — insert `[lo, hi]` when `lo ≤ hi`, `n < cap` (unique `lo`)
* **contains** — `1` if some stored interval covers point `p` (`lo ≤ p ≤ hi`)
* **overlaps** — `1` if some stored interval overlaps query `[qlo, qhi]` (closed)
* **isEmpty** / **isFull** / **count** / **cap** — occupancy helpers

No malloc. Store status is dataflow-used so EmitC cannot DCE slot writes.

## Portability / ABI

* **Alignment:** `U32.load` / `U32.store` require 4-byte-aligned `los`/`his`.
* **Capacity contract:** `n ≤ cap`; `u32Slot` uses `USize.mul i 4` without overflow checks.
  `insert` fences `n > cap` and full (`n ≥ cap`) with `errBounds` (3) before any slot access.
* **Interval contract:** `lo ≤ hi` required; else `err` (1). Duplicate `lo` → `err`.
* **Not claimed:** concurrent interval trees, multi-overlap reporters, open/half-open
  product APIs, or `Std` interval-map parity.

## Intentional TCB (IntervalTree-local)

`U32.load`/`store`, `USize.ofU32`/`mul`/`half` are freestanding `@[extern]` axioms
kept **here**. Name-pinned on ComplianceCorpus (`path name=Ident`).
-/

namespace Systems.IntervalTree

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

/-- Pass-through occupancy count. -/
public def count (n : USize) : USize := n

/-- Capacity (pass-through of caller-owned `cap`). -/
public def cap (c : USize) : USize := c

/-- `1` if `n == 0`, else `0`. -/
public def isEmpty (n : USize) : U32 :=
  bifU32 (USize.beq n USize.zero) U32.one U32.zero

/-- `1` if `n ≥ cap` (full), else `0`. `cap == 0` is treated as full. -/
public def isFull (cap : USize) (n : USize) : U32 :=
  bifU32 (USize.beq cap USize.zero) U32.one
    (bifU32 (USize.blt n cap) U32.zero U32.one)

/-- Binary lower-bound on `[lo, hi)`: first index with `los[i] ≥ key`, or `hi`. -/
public unsafe def lowerBoundGo (los : USize) (lo : USize) (hi : USize) (key : U32) : USize :=
  bifUSize (USize.blt lo hi)
    (let mid := USize.add lo (USize.half (USize.sub hi lo))
     let v := U32.load (u32Slot los mid)
     bifUSize (U32.blt v key)
       (lowerBoundGo los (USize.add mid USize.one) hi key)
       (lowerBoundGo los lo mid key))
    lo

/-- First index `i` in `[0, n)` with `los[i] ≥ key`, or `n` if all smaller. -/
public unsafe def lowerBound (los : USize) (n : USize) (key : U32) : USize :=
  lowerBoundGo los USize.zero n key

/-- Shift interval elements `[from, n)` one slot right (needs free slot at `n`).

`j` starts at `n` and walks down; while `from < j`, copy `j-1 → j`.
Store status dataflow-used. -/
public unsafe def shiftRightGo (los : USize) (his : USize) (j : USize) (from_ : USize) : U32 :=
  bifU32 (USize.blt from_ j)
    (let src := USize.sub j USize.one
     let l := U32.load (u32Slot los src)
     let h := U32.load (u32Slot his src)
     let st1 := U32.store (u32Slot los j) l
     bifU32 (isOk st1)
       (let st2 := U32.store (u32Slot his j) h
        bifU32 (isOk st2) (shiftRightGo los his src from_) st2)
       st1)
    ok

/-- Insert closed interval `[lo, hi]`. `0` ok; `3` full/`cap==0`/`n>cap`; `1` if `lo>hi`
or duplicate `lo`.

Does **not** update caller length — on success the caller must use `n + 1`.
Caller contract: `n ≤ cap` (fenced: `n > cap` → `errBounds` before any slot access).
Store status is dataflow-used. -/
public unsafe def insert (los : USize) (his : USize) (cap : USize) (n : USize)
    (lo : U32) (hi : U32) : U32 :=
  bifU32 (USize.blt cap n) errBounds
    (bifU32 (USize.beq cap USize.zero) errBounds
      (bifU32 (U32.blt hi lo) err
        (bifU32 (USize.beq n cap) errBounds
          (let pos := lowerBound los n lo
           bifU32 (USize.blt pos n)
             (bifU32 (U32.beq (U32.load (u32Slot los pos)) lo) err
               (let st1 := shiftRightGo los his n pos
                bifU32 (isOk st1)
                  (let st2 := U32.store (u32Slot los pos) lo
                   bifU32 (isOk st2)
                     (let st3 := U32.store (u32Slot his pos) hi
                      bifU32 (isOk st3) ok st3)
                     st2)
                  st1))
             (let st1 := U32.store (u32Slot los n) lo
              bifU32 (isOk st1)
                (let st2 := U32.store (u32Slot his n) hi
                 bifU32 (isOk st2) ok st2)
                st1)))))

/-- Scan whether any interval in `[i, n)` covers point `p` (`lo ≤ p ≤ hi`). -/
public unsafe def containsGo (los : USize) (his : USize) (i : USize) (n : USize)
    (p : U32) : U32 :=
  bifU32 (USize.blt i n)
    (let l := U32.load (u32Slot los i)
     let h := U32.load (u32Slot his i)
     bifU32 (U32.blt p l)
       (containsGo los his (USize.add i USize.one) n p)
       (bifU32 (U32.blt h p)
         (containsGo los his (USize.add i USize.one) n p)
         U32.one))
    U32.zero

/-- `1` if some stored interval covers `p`, else `0`. -/
public unsafe def contains (los : USize) (his : USize) (n : USize) (p : U32) : U32 :=
  containsGo los his USize.zero n p

/-- `1` if closed intervals `[a_lo, a_hi]` and `[b_lo, b_hi]` overlap. -/
public def intervalsOverlap (aLo : U32) (aHi : U32) (bLo : U32) (bHi : U32) : U32 :=
  bifU32 (U32.blt aHi bLo) U32.zero
    (bifU32 (U32.blt bHi aLo) U32.zero U32.one)

/-- Scan whether any interval in `[i, n)` overlaps query `[qlo, qhi]`. -/
public unsafe def overlapsGo (los : USize) (his : USize) (i : USize) (n : USize)
    (qlo : U32) (qhi : U32) : U32 :=
  bifU32 (USize.blt i n)
    (let l := U32.load (u32Slot los i)
     let h := U32.load (u32Slot his i)
     bifU32 (U32.beq (intervalsOverlap l h qlo qhi) U32.one) U32.one
       (overlapsGo los his (USize.add i USize.one) n qlo qhi))
    U32.zero

/-- `1` if some stored interval overlaps closed query `[qlo, qhi]`, else `0`.

If `qlo > qhi`, returns `0` (empty query). -/
public unsafe def overlaps (los : USize) (his : USize) (n : USize)
    (qlo : U32) (qhi : U32) : U32 :=
  bifU32 (U32.blt qhi qlo) U32.zero
    (overlapsGo los his USize.zero n qlo qhi)

end Systems.IntervalTree
