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
# Systems.HashMap (Systems Lean)

Fixed-capacity **hash-map-shaped ordered U32 map** over caller-owned key/value slots —
not a concurrent hash map, not open-addressing resize/heap product (see `Map` for tag-based
open addressing), and not `Std.HashMap`.

Layout (caller-owned):

* `keys` — `cap` host-endian `U32` slots (`cap * 4` bytes), **4-byte aligned**
* `vals` — `cap` host-endian `U32` slots, **4-byte aligned**
* `n` / occupancy — dual `USize` owned by the **caller** (not stored by this module)
* **Caller contract:** `n ≤ cap` at every call; `insert` returns `errBounds` if `n > cap`
* Invariant: `keys[0..n)` is sorted **strictly increasing** (unique keys; set/map)

Simplified “hash map”: this port keeps a **single dense ordered leaf** (binary
lower-bound + shift insert/remove) with hash-map-shaped API names. Open addressing,
tombstones, load-factor policy, and concurrent structures are intentionally omitted
for residual-clean dual-param freestanding (sibling of `Map` tags/OA and of
`BTreeMap` / `SkipListMap` dense leaves).

Ops:

* **lowerBound** — first index `i` with `keys[i] ≥ key`, or `n` if all smaller
* **contains** — presence of `key`
* **get** — value for `key` as `USize`, or miss
* **getAt** — value at index as `USize`, or miss
* **insert** — insert/overwrite `key → val` when `n < cap` (or key already present)
* **remove** — remove `key` when present
* **isEmpty** / **isFull** / **len** / **capacity** — occupancy helpers

No malloc. Store status is dataflow-used so EmitC cannot DCE slot writes.

## Portability / ABI

* **Alignment:** `U32.load` / `U32.store` require 4-byte-aligned `keys`/`vals`.
* **Capacity contract:** `n ≤ cap`; `u32Slot` uses `USize.mul i 4` without overflow checks.
  `insert` fences `n > cap` and full (`n ≥ cap` for a new key) with `errBounds` (3).
* **LP64 product harness:** `get`/`getAt` miss uses `USize.neg1`. On ILP32 that collides
  with storing `UINT32_MAX` — treat as **LP64-only** (Map `get` class).
* **Not claimed:** open-addressing hash, concurrent maps, resize heap, or `Std.HashMap`
  parity. For tag-based open addressing see `Map`.

## Intentional TCB (HashMap-local)

`U32.load`/`store`, `USize.ofU32`/`mul`/`half` are freestanding `@[extern]` axioms
kept **here**. Name-pinned on ComplianceCorpus (`path name=Ident`).
-/

namespace Systems.HashMap

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

/-- `1` if `n ≥ cap` (full), else `0`. `cap == 0` is treated as full. -/
@[inline] public def isFull (cap : USize) (n : USize) : U32 :=
  bifU32 (USize.beq cap USize.zero) U32.one
    (bifU32 (USize.blt n cap) U32.zero U32.one)

/-- Binary lower-bound on `[lo, hi)`: first index with key `≥ key`, or `hi`. -/
public unsafe def lowerBoundGo (keys : USize) (lo : USize) (hi : USize) (key : U32) : USize :=
  bifUSize (USize.blt lo hi)
    (let mid := USize.add lo (USize.half (USize.sub hi lo))
     let v := U32.load (u32Slot keys mid)
     bifUSize (U32.blt v key)
       (lowerBoundGo keys (USize.add mid USize.one) hi key)
       (lowerBoundGo keys lo mid key))
    lo

/-- First index `i` in `[0, n)` with `keys[i] ≥ key`, or `n` if all smaller. -/
public unsafe def lowerBound (keys : USize) (n : USize) (key : U32) : USize :=
  lowerBoundGo keys USize.zero n key

/-- `1` if `key` is present in ordered `[0, n)`, else `0`. -/
public unsafe def contains (keys : USize) (n : USize) (key : U32) : U32 :=
  let i := lowerBound keys n key
  bifU32 (USize.blt i n)
    (bifU32 (U32.beq (U32.load (u32Slot keys i)) key) U32.one U32.zero)
    U32.zero

/-- Value for `key` as `USize`, or `USize.neg1` if absent. **LP64 only**. -/
public unsafe def get (keys : USize) (vals : USize) (n : USize) (key : U32) : USize :=
  let i := lowerBound keys n key
  bifUSize (USize.blt i n)
    (bifUSize (U32.beq (U32.load (u32Slot keys i)) key)
      (USize.ofU32 (U32.load (u32Slot vals i)))
      USize.neg1)
    USize.neg1

/-- Bounds-safe get by index: value as `USize`, or miss if `i ≥ n`. **LP64 only**. -/
public unsafe def getAt (vals : USize) (n : USize) (i : USize) : USize :=
  bifUSize (USize.blt i n)
    (USize.ofU32 (U32.load (u32Slot vals i)))
    USize.neg1

/-- Key at index as `USize`, or miss if `i ≥ n`. **LP64 only**. -/
public unsafe def keyAt (keys : USize) (n : USize) (i : USize) : USize :=
  bifUSize (USize.blt i n)
    (USize.ofU32 (U32.load (u32Slot keys i)))
    USize.neg1

/-- Shift key/value elements `[from, n)` one slot right (needs free slot at `n`).

`j` starts at `n` and walks down; while `from < j`, copy `j-1 → j`.
Store status dataflow-used. -/
public unsafe def shiftRightGo (keys : USize) (vals : USize) (j : USize) (from_ : USize) : U32 :=
  bifU32 (USize.blt from_ j)
    (let src := USize.sub j USize.one
     let k := U32.load (u32Slot keys src)
     let v := U32.load (u32Slot vals src)
     let st1 := U32.store (u32Slot keys j) k
     bifU32 (isOk st1)
       (let st2 := U32.store (u32Slot vals j) v
        bifU32 (isOk st2) (shiftRightGo keys vals src from_) st2)
       st1)
    ok

/-- Insert `key → val`. `0` ok; `3` if full / `cap == 0` / `n > cap` for a **new** key.

If `key` already present **and** `n ≤ cap`, overwrites value and returns `0` without growing `n`.
Does **not** update caller length — on growth success the caller must use `n + 1`.
Caller contract: `n ≤ cap` (fenced: `n > cap` → `errBounds` before any slot access). -/
public unsafe def insert (keys : USize) (vals : USize) (cap : USize) (n : USize)
    (key : U32) (val : U32) : U32 :=
  bifU32 (USize.blt cap n) errBounds
    (bifU32 (USize.beq cap USize.zero) errBounds
      (let pos := lowerBound keys n key
       bifU32 (USize.blt pos n)
         (bifU32 (U32.beq (U32.load (u32Slot keys pos)) key)
           (let st := U32.store (u32Slot vals pos) val
            bifU32 (isOk st) ok st)
           (bifU32 (USize.blt n cap)
             (let st1 := shiftRightGo keys vals n pos
              bifU32 (isOk st1)
                (let st2 := U32.store (u32Slot keys pos) key
                 bifU32 (isOk st2)
                   (let st3 := U32.store (u32Slot vals pos) val
                    bifU32 (isOk st3) ok st3)
                   st2)
                st1)
             errBounds))
         (bifU32 (USize.blt n cap)
           (let st1 := U32.store (u32Slot keys n) key
            bifU32 (isOk st1)
              (let st2 := U32.store (u32Slot vals n) val
               bifU32 (isOk st2) ok st2)
              st1)
           errBounds)))

/-- Shift key/value elements `(from, n)` one slot left (drop index `from`).

`j` walks from `from` toward `n-1`. Store status dataflow-used. -/
public unsafe def shiftLeftGo (keys : USize) (vals : USize) (j : USize) (n : USize) : U32 :=
  let next := USize.add j USize.one
  bifU32 (USize.blt next n)
    (let k := U32.load (u32Slot keys next)
     let v := U32.load (u32Slot vals next)
     let st1 := U32.store (u32Slot keys j) k
     bifU32 (isOk st1)
       (let st2 := U32.store (u32Slot vals j) v
        bifU32 (isOk st2) (shiftLeftGo keys vals next n) st2)
       st1)
    ok

/-- Remove `key`. `0` ok; `1` if absent.

Does **not** update caller length — on success the caller must use `n - 1`. -/
public unsafe def remove (keys : USize) (vals : USize) (n : USize) (key : U32) : U32 :=
  bifU32 (USize.beq n USize.zero) err
    (let pos := lowerBound keys n key
     bifU32 (USize.blt pos n)
       (bifU32 (U32.beq (U32.load (u32Slot keys pos)) key)
         (shiftLeftGo keys vals pos n)
         err)
       err)

/-- Clear is occupancy-only: returns `ok`. Caller must set `n := 0`. -/
@[never_extract]
public def clear (_keys : USize) (_vals : USize) (_cap : USize) : U32 :=
  ok

end Systems.HashMap
