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
# Systems.Tree (Systems Lean)

Fixed-capacity **binary min-heap** of `U32` over caller-owned slots — heap-**shaped**,
not a general `TreeMap` / RB tree / managed collection.

Layout (caller-owned):

* `slots` — `cap` host-endian `U32` slots (`cap * 4` bytes), **4-byte aligned**
* `n` / occupancy — dual `USize` owned by the **caller** (not stored by this module)

Ops:

* **insert** at index `n` then sift-up when `n < cap`
* **peekMin** / **extractMin** when non-empty (extract swaps last into root + sift-down)
* **isEmpty** / **isFull** / **count** / **cap** — occupancy helpers

No malloc. No freestanding multi-field product returns. Status codes follow
`Systems.Status` (`0` ok, `3` bounds/full/empty-as-bounds where noted).

## Portability / ABI

* **Alignment:** `U32.load` / `U32.store` are host-endian word accesses; unaligned `slots`
  bases are ISO C undefined behavior. Pass 4-byte-aligned buffers (e.g. `uint32_t[]`).
* **Capacity contract:** `u32Slot` uses `USize.mul i 4` without overflow checks (Vector
  parity). Keep `cap` small enough that `cap * 4` fits in `size_t`.
* **LP64 product harness:** `peekMin` / `extractMin` miss use `USize.neg1`. On ILP32 that
  collides with storing `UINT32_MAX` — treat as **LP64-only** (Map `get` class).
* **Not claimed:** growable heaps, max-heap, BST/TreeMap, concurrency, or managed storage.

## Intentional TCB (Tree-local)

`U32.load`/`store`, `USize.ofU32`/`mul`/`div`/`two` are freestanding `@[extern]` axioms
kept **here** (Vector/Queue parity). Name-pinned on ComplianceCorpus
(`path name=Ident`). Store status is dataflow-used so EmitC cannot DCE slot writes.
-/

namespace Systems.Tree

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

/-- Unsigned divide. Caller must keep divisor ≠ 0. -/
@[extern c inline "((size_t)((size_t)(#1) / (size_t)(#2)))"]
public axiom USize.div : USize → USize → USize

/-- Two as `USize` (heap child index base). -/
@[extern c inline "((size_t)2)"] public axiom twoUSize : USize

/-- Address of `U32` slot `i` in a contiguous word array at `base` (base 4-byte aligned).

Uses `i` in the dataflow so freestanding emit does not lift a ground `base+0` closed term. -/
public def u32Slot (base : USize) (i : USize) : USize :=
  USize.add base (USize.mul i USize.four)

/-- Pass-through occupancy count. -/
public def count (n : USize) : USize := n

/-- Capacity (pass-through of caller-owned `cap`). -/
public def cap (c : USize) : USize := c

/-- `1` if `n == 0`, else `0`. -/
public def isEmpty (n : USize) : U32 :=
  bifU32 (USize.beq n USize.zero) U32.one U32.zero

/-- `1` if `n == cap` (full), else `0`. `cap == 0` is treated as full. -/
public def isFull (cap : USize) (n : USize) : U32 :=
  bifU32 (USize.beq cap USize.zero) U32.one
    (bifU32 (USize.beq n cap) U32.one U32.zero)

/-- Parent index `(i - 1) / 2` for `i > 0`. -/
public def parent (i : USize) : USize :=
  USize.div (USize.sub i USize.one) twoUSize

/-- Left child `2*i + 1`. -/
public def left (i : USize) : USize :=
  USize.add (USize.mul twoUSize i) USize.one

/-- Right child `2*i + 2`. -/
public def right (i : USize) : USize :=
  USize.add (USize.mul twoUSize i) twoUSize

/-- Swap slots `i` and `j`; store statuses dataflow-used. -/
public unsafe def swap (slots : USize) (i : USize) (j : USize) : U32 :=
  let vi := U32.load (u32Slot slots i)
  let vj := U32.load (u32Slot slots j)
  let s1 := U32.store (u32Slot slots i) vj
  bifU32 (isOk s1)
    (let s2 := U32.store (u32Slot slots j) vi
     bifU32 (isOk s2) ok s2)
    s1

/-- Sift-up from index `i` toward root for min-heap order. -/
public unsafe def siftUp (slots : USize) (i : USize) : U32 :=
  bifU32 (USize.beq i USize.zero) ok
    (let p := parent i
     let vi := U32.load (u32Slot slots i)
     let vp := U32.load (u32Slot slots p)
     bifU32 (U32.blt vi vp)
       (let st := swap slots i p
        bifU32 (isOk st) (siftUp slots p) st)
       ok)

/-- Choose the smaller child index among left `l` and optional right `l+1` when in range. -/
public unsafe def minChild (slots : USize) (n : USize) (l : USize) : USize :=
  let r := USize.add l USize.one
  bifUSize (USize.blt r n)
    (let vl := U32.load (u32Slot slots l)
     let vr := U32.load (u32Slot slots r)
     bifUSize (U32.blt vr vl) r l)
    l

/-- Sift-down from index `i` within heap size `n`. -/
public unsafe def siftDown (slots : USize) (n : USize) (i : USize) : U32 :=
  let l := left i
  bifU32 (USize.blt l n)
    (let c := minChild slots n l
     let vi := U32.load (u32Slot slots i)
     let vc := U32.load (u32Slot slots c)
     bifU32 (U32.blt vc vi)
       (let st := swap slots i c
        bifU32 (isOk st) (siftDown slots n c) st)
       ok)
    ok

/-- Insert `val` at index `n` then sift-up. `0` ok; `errBounds` if full / `cap == 0`.

Does **not** update caller length — on success the caller must use `n + 1`.
Store status is dataflow-used. -/
public unsafe def insert (slots : USize) (cap : USize) (n : USize) (val : U32) : U32 :=
  bifU32 (USize.beq cap USize.zero) errBounds
    (bifU32 (USize.beq n cap) errBounds
      (let st := U32.store (u32Slot slots n) val
       bifU32 (isOk st) (siftUp slots n) st))

/-- Peek minimum as `USize` (`0..UINT32_MAX`), or `USize.neg1` if empty.

Root index is derived from `n` (`n - n`) so freestanding emit keeps a dual-param dataflow
(no ground `slots+0` closed term). **LP64 only** for the miss sentinel. -/
public unsafe def peekMin (slots : USize) (n : USize) : USize :=
  bifUSize (USize.beq n USize.zero) USize.neg1
    (USize.ofU32 (U32.load (u32Slot slots (USize.sub n n))))

/-- Extract minimum as `USize`, or `USize.neg1` if empty.

Does **not** update caller `n` — on success use `n - 1`.
**LP64 only** for the miss sentinel.

`siftDown` status is dataflow-used (Map rehash/`clear` class) so EmitC cannot DCE
the restore of heap order after the last→root store. -/
public unsafe def extractMin (slots : USize) (n : USize) : USize :=
  bifUSize (USize.beq n USize.zero) USize.neg1
    (let root := USize.sub n n
     let min := U32.load (u32Slot slots root)
     bifUSize (USize.beq n USize.one) (USize.ofU32 min)
       (let lastI := USize.sub n USize.one
        let last := U32.load (u32Slot slots lastI)
        let st := U32.store (u32Slot slots root) last
        bifUSize (isOk st)
          (bifUSize (isOk (siftDown slots lastI root))
            (USize.ofU32 min)
            USize.neg1)
          USize.neg1))

end Systems.Tree
