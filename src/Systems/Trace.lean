/-
Copyright (c) 2026 Hunter Beast. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Hunter Beast
-/
module
prelude
public import Systems.Scalars
public import Systems.Numerics
public import Systems.Hash
public import Systems.Status

/-!
# Systems.Trace (Systems Lean)

Fixed-capacity **rebuild-skip / hash-mix shaped** ordered unique `U32` hash set
over caller-owned key slots — Slake **trace-shaped** surface for "is this input
hash already traced" (not Lake `BuildTrace` monadic IO, not crypto).

Layout (caller-owned):

* `keys` — `cap` host-endian `U32` slots (`cap * 4` bytes), **4-byte aligned**
* `n` / occupancy — dual `USize` owned by the **caller** (not stored by this module)
* **Caller contract:** `n ≤ cap` at every call; `insert` / `mixPut` return `errBounds` if `n > cap`
* Invariant: `keys[0..n)` is sorted **strictly increasing** (unique hashes; set)

Ops:

* **init** / **clear** — occupancy-only reset helpers (caller sets `n := 0`)
* **lowerBound** / **contains** / **get** / **traceAt** — ordered lookup
* **insert** / **put** — insert a precomputed `U32` hash (idempotent if present)
* **mixPut** — `Systems.Hash.hashBytes` over dual `addr`/`len`, then insert
* **remove** — drop a hash when present
* **isEmpty** / **isFull** / **len** / **capacity** — occupancy helpers

No malloc. Store status is dataflow-used so EmitC cannot DCE slot writes.

## Portability / ABI

* **Alignment:** `U32.load` / `U32.store` require 4-byte-aligned `keys`.
* **Capacity contract:** `n ≤ cap`; `u32Slot` uses `USize.mul i 4` without overflow checks.
  `insert` / `put` / `mixPut` fence `n > cap` and full (`n ≥ cap` for a new key) with
  `errBounds` (3) **before any slot access** on every path (including idempotent-present
  keys when occupancy is already over capacity).
* **LP64 product harness:** `get`/`traceAt` miss uses `USize.neg1`. On ILP32 that collides
  with storing `UINT32_MAX` — treat as **LP64-only** (Map `get` class).
* **Not claimed:** Lake `BuildTrace` monadic IO, content-addressed store, or crypto hashes.

Honesty:

* **Rebuild-skip shaped only** — not Lake `BuildTrace`, not content-addressed store IO,
  not cryptographic hashing, not multi-field product returns.
* Hash mix is freestanding FNV-1a + finalize from `Systems.Hash` (decimal-only constants).
* **LP64 product harness:** `get`/`traceAt` miss uses `USize.neg1`.

## Intentional TCB (Trace-local)

`U32.load`/`store`, `USize.ofU32`/`mul`/`half` are freestanding `@[extern]` axioms
kept **here**. Name-pinned on ComplianceCorpus (`path name=Ident`). Hash constants
live in `Systems.Hash` (already pinned).
-/

namespace Systems.Trace

open Systems.Scalars
open Systems.Numerics
open Systems.Hash
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

/-- Init is occupancy-only: returns `ok`. Caller must set `n := 0`. -/
@[never_extract]
public def init (_keys : USize) (_cap : USize) : U32 :=
  ok

/-- Clear is occupancy-only: returns `ok`. Caller must set `n := 0`. -/
@[never_extract]
public def clear (_keys : USize) (_cap : USize) : U32 :=
  ok

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

/-- Bounds-safe get by index: hash as `USize`, or miss if `i ≥ n`. **LP64 only**. -/
public unsafe def get (keys : USize) (n : USize) (i : USize) : USize :=
  bifUSize (USize.blt i n)
    (USize.ofU32 (U32.load (u32Slot keys i)))
    USize.neg1

/-- Trace entry at index as `USize`, or miss if `i ≥ n`. **LP64 only**.

Trace-shaped name for ordered dense leaf slot access (twin of `get`). -/
public unsafe def traceAt (keys : USize) (n : USize) (i : USize) : USize :=
  bifUSize (USize.blt i n)
    (USize.ofU32 (U32.load (u32Slot keys i)))
    USize.neg1

/-- Shift key elements `[from_, n)` one slot right (needs free slot at `n`).

Store status dataflow-used. -/
public unsafe def shiftRightGo (keys : USize) (j : USize) (from_ : USize) : U32 :=
  bifU32 (USize.blt from_ j)
    (let src := USize.sub j USize.one
     let k := U32.load (u32Slot keys src)
     let st := U32.store (u32Slot keys j) k
     bifU32 (isOk st) (shiftRightGo keys src from_) st)
    ok

/-- Insert precomputed hash `key`. `0` ok; `3` if full / `cap == 0` / `n > cap`.

Fences `n > cap` and `cap == 0` **before any slot access** on all paths (including when
`key` would be a no-op present insert). If `key` already present **and** `n ≤ cap`,
returns `0` without growing `n` (idempotent). Does **not** update caller length — on
growth success the caller must use `n + 1`. -/
public unsafe def insert (keys : USize) (cap : USize) (n : USize) (key : U32) : U32 :=
  bifU32 (USize.blt cap n) errBounds
    (bifU32 (USize.beq cap USize.zero) errBounds
      (let pos := lowerBound keys n key
       bifU32 (USize.blt pos n)
         (bifU32 (U32.beq (U32.load (u32Slot keys pos)) key)
           ok
           (bifU32 (USize.blt n cap)
             (let st1 := shiftRightGo keys n pos
              bifU32 (isOk st1)
                (let st2 := U32.store (u32Slot keys pos) key
                 bifU32 (isOk st2) ok st2)
                st1)
             errBounds))
         (bifU32 (USize.blt n cap)
           (let st := U32.store (u32Slot keys n) key
            bifU32 (isOk st) ok st)
           errBounds)))

/-- Alias of `insert` (trace put of a precomputed hash). -/
public unsafe def put (keys : USize) (cap : USize) (n : USize) (key : U32) : U32 :=
  insert keys cap n key

/-- Hash dual `addr`/`len` with `Systems.Hash.hashBytes`, then `insert`.

Rebuild-skip shaped mix-put: record content fingerprint so later lookups can skip
rework when the same hash is already present. Not crypto. -/
public unsafe def mixPut (keys : USize) (cap : USize) (n : USize)
    (addr : USize) (len : USize) : U32 :=
  insert keys cap n (hashBytes addr len)

/-- Shift key elements `(from_, n)` one slot left (drop index `from_`).

Store status dataflow-used. -/
public unsafe def shiftLeftGo (keys : USize) (j : USize) (n : USize) : U32 :=
  let next := USize.add j USize.one
  bifU32 (USize.blt next n)
    (let k := U32.load (u32Slot keys next)
     let st := U32.store (u32Slot keys j) k
     bifU32 (isOk st) (shiftLeftGo keys next n) st)
    ok

/-- Remove `key`. `0` ok; `1` if absent.

Does **not** update caller length — on success the caller must use `n - 1`. -/
public unsafe def remove (keys : USize) (n : USize) (key : U32) : U32 :=
  bifU32 (USize.beq n USize.zero) err
    (let pos := lowerBound keys n key
     bifU32 (USize.blt pos n)
       (bifU32 (U32.beq (U32.load (u32Slot keys pos)) key)
         (shiftLeftGo keys pos n)
         err)
       err)

end Systems.Trace
