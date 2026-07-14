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
# Systems.RingBuf (Systems Lean)

Fixed-capacity **byte ring buffer** over raw memory — ring-**shaped**, not a managed
queue / `Array` / RC ring. Sibling of `Queue` for `U8` payloads.

Layout (caller-owned):

* `slots` — `cap` contiguous `U8` bytes
* `head` / `count` — dual `USize` indices owned by the **caller** (not stored by this module)

Ops:

* **Push** at `(head + count) % cap` when not full
* **Pop** / **peek** at `head` when not empty
* After a successful pop, caller advances head with `nextHead cap head`
* After a successful push, caller increments `count`

No malloc. No freestanding multi-field product returns. Status codes follow
`Systems.Status` (`0` ok, `3` bounds/full/empty-as-bounds where noted).

## Portability / ABI

* **Capacity:** `cap == 0` is refused (no `% 0` UB); treated as full/empty-fail.
* **LP64 product harness:** `pop` / `peek` miss use `USize.neg1` (`(size_t)-1`). On ILP32
  that collides with storing `0xFF` only if widened incorrectly — values are `0..255` as
  `USize`, so miss remains distinct on both widths for byte payloads.
* **Not claimed:** growable rings, concurrency, or managed storage.

## Intentional TCB (RingBuf-local)

`USize.mod` is a freestanding `@[extern]` axiom kept **here** (Queue parity).
Byte load/store reuses `Systems.Scalars` / `Systems.Bytes`. Name-pinned on
ComplianceCorpus (`path name=Ident`).
-/

namespace Systems.RingBuf

open Systems.Scalars
open Systems.Bytes
open Systems.Status

/-- Unsigned modulo (`a % b`). Caller must keep `b ≠ 0`. -/
@[extern c inline "((size_t)((size_t)(#1) % (size_t)(#2)))"]
public axiom USize.mod : USize → USize → USize

/-- Pass-through occupancy count. -/
@[inline] public def count (n : USize) : USize := n

/-- `1` if `count == 0`, else `0`. -/
@[inline] public def isEmpty (n : USize) : U32 :=
  bifU32 (USize.beq n USize.zero) U32.one U32.zero

/-- `1` if `n == cap` (full), else `0`. `cap == 0` is treated as full. -/
@[inline] public def isFull (cap : USize) (n : USize) : U32 :=
  bifU32 (USize.beq cap USize.zero) U32.one
    (bifU32 (USize.beq n cap) U32.one U32.zero)

/-- Next head after a successful pop: `(head + 1) % cap`. `cap == 0 → 0` (no `% 0`). -/
public unsafe def nextHead (cap : USize) (head : USize) : USize :=
  bifUSize (USize.beq cap USize.zero) USize.zero
    (USize.mod (USize.add head USize.one) cap)

/-- Push `val` at the tail slot. `0` ok; `errBounds` if `cap == 0` or full.

Does **not** update caller occupancy — on success the caller must use `n + 1`.
Store status is dataflow-used so EmitC cannot DCE the slot write. -/
public unsafe def push (slots : USize) (cap : USize) (head : USize) (n : USize)
    (val : U8) : U32 :=
  bifU32 (USize.beq cap USize.zero) errBounds
    (bifU32 (USize.beq n cap) errBounds
      (let i := USize.mod (USize.add head n) cap
       let st := U8.store (USize.add slots i) val
       bifU32 (isOk st) ok st))

/-- Pop front byte as `USize` (`0..255`), or `USize.neg1` if empty / `cap == 0`.

Does **not** update caller `head`/`n` — on success use `nextHead` and `n - 1`. -/
public unsafe def pop (slots : USize) (cap : USize) (head : USize) (n : USize) : USize :=
  bifUSize (USize.beq cap USize.zero) USize.neg1
    (bifUSize (USize.beq n USize.zero) USize.neg1
      (USize.ofU8 (U8.load (USize.add slots head))))

/-- Peek front without removing. Same return shape as `pop`. -/
public unsafe def peek (slots : USize) (cap : USize) (head : USize) (n : USize) : USize :=
  pop slots cap head n

end Systems.RingBuf
