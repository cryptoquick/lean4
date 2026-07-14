/-
Copyright (c) 2026 Lean FRO, LLC. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Hunter Beast
-/
module
prelude
public import Systems.Scalars
public import Systems.Status

/-!
# Systems.Deque (Systems Lean)

Fixed-capacity **double-ended ring deque** over raw memory — not a managed collection,
not `Std.Queue` / growable `Array` / RC ring, and not a priority queue.

Layout (caller-owned):

* `slots` — `cap` host-endian `U32` slots (`cap * 4` bytes), **4-byte aligned**
* `head` / `count` — dual `USize` indices owned by the **caller** (not stored by this module)

Ops:

* **pushBack** at `(head + count) % cap` when not full
* **pushFront** at the slot before `head` when not full
* **popFront** / **peekFront** at `head` when not empty
* **popBack** / **peekBack** at the logical tail when not empty
* After a successful popFront, caller advances head with `nextHead cap head`
* After a successful pushFront, caller sets head to `prevHead cap head`
* After a successful push/pop, caller updates `count` (±1)

No malloc. No freestanding multi-field product returns. Status codes follow
`Systems.Status` (`0` ok, `3` bounds/full/empty-as-bounds where noted).

## Portability / ABI

* **Alignment:** `U32.load` / `U32.store` are host-endian word accesses; unaligned `slots`
  bases are ISO C undefined behavior. Pass 4-byte-aligned buffers (e.g. `uint32_t[]`).
* **Capacity contract:** `u32Slot` uses `USize.mul i 4` without overflow checks (Map
  parity). Keep `cap` small enough that `cap * 4` fits in `size_t`. `cap == 0` is refused
  (no `% 0` UB).
* **LP64 product harness:** pop/peek miss use `USize.neg1` (`(size_t)-1`). On ILP32
  that collides with storing `UINT32_MAX` — treat as **LP64-only** (Map `get` class).
* **Not claimed:** growable deques, concurrency, priority queues, or managed storage.

## Intentional TCB (Deque-local)

`U32.load`/`store`, `USize.ofU32`/`mod`/`mul` are freestanding `@[extern]` axioms kept
**here** (Queue/Map parity). Name-pinned on ComplianceCorpus (`path name=Ident`).
-/

namespace Systems.Deque

open Systems.Scalars
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

/-- Unsigned modulo (`a % b`). Caller must keep `b ≠ 0`. -/
@[extern c inline "((size_t)((size_t)(#1) % (size_t)(#2)))"]
public axiom USize.mod : USize → USize → USize

/-- Unsigned multiply. -/
@[extern c inline "((size_t)((size_t)(#1) * (size_t)(#2)))"]
public axiom USize.mul : USize → USize → USize

/-- Address of `U32` slot `i` in a contiguous word array at `base` (base 4-byte aligned). -/
@[inline] public def u32Slot (base : USize) (i : USize) : USize :=
  USize.add base (USize.mul i USize.four)

/-- Pass-through occupancy count. -/
@[inline] public def count (n : USize) : USize := n

/-- `1` if `count == 0`, else `0`. -/
@[inline] public def isEmpty (n : USize) : U32 :=
  bifU32 (USize.beq n USize.zero) U32.one U32.zero

/-- `1` if `n == cap` (full), else `0`. `cap == 0` is treated as full. -/
@[inline] public def isFull (cap : USize) (n : USize) : U32 :=
  bifU32 (USize.beq cap USize.zero) U32.one
    (bifU32 (USize.beq n cap) U32.one U32.zero)

/-- Next head after a successful popFront: `(head + 1) % cap`. `cap == 0 → 0` (no `% 0`). -/
public unsafe def nextHead (cap : USize) (head : USize) : USize :=
  bifUSize (USize.beq cap USize.zero) USize.zero
    (USize.mod (USize.add head USize.one) cap)

/-- Previous head for a successful pushFront: `head == 0 → cap - 1`, else `head - 1`.

`cap == 0 → 0` (no underflow / `% 0`). -/
public unsafe def prevHead (cap : USize) (head : USize) : USize :=
  bifUSize (USize.beq cap USize.zero) USize.zero
    (bifUSize (USize.beq head USize.zero)
      (USize.sub cap USize.one)
      (USize.sub head USize.one))

/-- Push `val` at the back (tail). `0` ok; `errBounds` if `cap == 0` or full.

Does **not** update caller occupancy — on success the caller must use `n + 1`.
Store status is dataflow-used so EmitC cannot DCE the slot write. -/
public unsafe def pushBack (slots : USize) (cap : USize) (head : USize) (n : USize)
    (val : U32) : U32 :=
  bifU32 (USize.beq cap USize.zero) errBounds
    (bifU32 (USize.beq n cap) errBounds
      (let i := USize.mod (USize.add head n) cap
       let st := U32.store (u32Slot slots i) val
       bifU32 (isOk st) ok st))

/-- Push `val` at the front. `0` ok; `errBounds` if `cap == 0` or full.

Does **not** update caller `head`/`n` — on success use `prevHead` and `n + 1`.
Store status is dataflow-used so EmitC cannot DCE the slot write. -/
public unsafe def pushFront (slots : USize) (cap : USize) (head : USize) (n : USize)
    (val : U32) : U32 :=
  bifU32 (USize.beq cap USize.zero) errBounds
    (bifU32 (USize.beq n cap) errBounds
      (let i := prevHead cap head
       let st := U32.store (u32Slot slots i) val
       bifU32 (isOk st) ok st))

/-- Pop front value as `USize` (`0..UINT32_MAX`), or `USize.neg1` if empty / `cap == 0`.

Does **not** update caller `head`/`n` — on success use `nextHead` and `n - 1`.
**LP64 only** for the miss sentinel (see module docs). -/
public unsafe def popFront (slots : USize) (cap : USize) (head : USize) (n : USize) : USize :=
  bifUSize (USize.beq cap USize.zero) USize.neg1
    (bifUSize (USize.beq n USize.zero) USize.neg1
      (USize.ofU32 (U32.load (u32Slot slots head))))

/-- Peek front without removing. Same return shape as `popFront`. -/
public unsafe def peekFront (slots : USize) (cap : USize) (head : USize) (n : USize) : USize :=
  popFront slots cap head n

/-- Pop back value as `USize`, or `USize.neg1` if empty / `cap == 0`.

Does **not** update caller `n` — on success use `n - 1` (head unchanged).
**LP64 only** for the miss sentinel. -/
public unsafe def popBack (slots : USize) (cap : USize) (head : USize) (n : USize) : USize :=
  bifUSize (USize.beq cap USize.zero) USize.neg1
    (bifUSize (USize.beq n USize.zero) USize.neg1
      (let i := USize.mod (USize.add head (USize.sub n USize.one)) cap
       USize.ofU32 (U32.load (u32Slot slots i))))

/-- Peek back without removing. Same return shape as `popBack`. -/
public unsafe def peekBack (slots : USize) (cap : USize) (head : USize) (n : USize) : USize :=
  popBack slots cap head n

end Systems.Deque
