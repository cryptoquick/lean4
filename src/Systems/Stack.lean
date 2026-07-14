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
# Systems.Stack (Systems Lean)

Fixed-capacity **stack** over raw memory — not a managed collection and not growable
`Array` / `List` / RC storage.

Layout (caller-owned):

* `slots` — `cap` host-endian `U32` slots (`cap * 4` bytes), **4-byte aligned**
* `n` / occupancy — dual `USize` owned by the **caller** (not stored by this module)

Ops:

* **push** at index `n` when `n < cap`
* **pop** / **peek** top element when non-empty
* **isEmpty** / **isFull** / **count** / **cap** — occupancy helpers

No malloc. No freestanding multi-field product returns. Status codes follow
`Systems.Status` (`0` ok, `3` bounds/full/empty-as-bounds where noted).

## Portability / ABI

* **Alignment:** `U32.load` / `U32.store` are host-endian word accesses; unaligned `slots`
  bases are ISO C undefined behavior. Pass 4-byte-aligned buffers (e.g. `uint32_t[]`).
* **Capacity contract:** `u32Slot` uses `USize.mul i 4` without overflow checks (Vector
  parity). Keep `cap` small enough that `cap * 4` fits in `size_t`. Adversarial huge
  `cap` can wrap offsets — not a product harness claim.
* **LP64 product harness:** `pop` / `peek` miss use `USize.neg1` (`(size_t)-1`). On ILP32
  that collides with storing `UINT32_MAX` — treat as **LP64-only** (Map `get` class).
* **Not claimed:** growable stacks, concurrency, or managed storage.

## Intentional TCB (Stack-local)

`U32.load`/`store`, `USize.ofU32`/`mul` are freestanding `@[extern]` axioms kept
**here** (Vector/Queue parity). Name-pinned on ComplianceCorpus (`path name=Ident`).
-/

namespace Systems.Stack

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

/-- Unsigned multiply. -/
@[extern c inline "((size_t)((size_t)(#1) * (size_t)(#2)))"]
public axiom USize.mul : USize → USize → USize

/-- Address of `U32` slot `i` in a contiguous word array at `base` (base 4-byte aligned). -/
@[inline] public def u32Slot (base : USize) (i : USize) : USize :=
  USize.add base (USize.mul i USize.four)

/-- Pass-through occupancy count. -/
@[inline] public def count (n : USize) : USize := n

/-- Capacity (pass-through of caller-owned `cap`). -/
@[inline] public def cap (c : USize) : USize := c

/-- `1` if `n == 0`, else `0`. -/
@[inline] public def isEmpty (n : USize) : U32 :=
  bifU32 (USize.beq n USize.zero) U32.one U32.zero

/-- `1` if `n == cap` (full), else `0`. `cap == 0` is treated as full. -/
@[inline] public def isFull (cap : USize) (n : USize) : U32 :=
  bifU32 (USize.beq cap USize.zero) U32.one
    (bifU32 (USize.beq n cap) U32.one U32.zero)

/-- Push `val` at index `n`. `0` ok; `errBounds` if full / `cap == 0`.

Does **not** update caller length — on success the caller must use `n + 1`.
Store status is dataflow-used so EmitC cannot DCE the slot write. -/
public unsafe def push (slots : USize) (cap : USize) (n : USize) (val : U32) : U32 :=
  bifU32 (USize.beq cap USize.zero) errBounds
    (bifU32 (USize.beq n cap) errBounds
      (let st := U32.store (u32Slot slots n) val
       bifU32 (isOk st) ok st))

/-- Pop top value as `USize` (`0..UINT32_MAX`), or `USize.neg1` if empty.

Does **not** update caller `n` — on success use `n - 1`.
**LP64 only** for the miss sentinel (see module docs). -/
public unsafe def pop (slots : USize) (n : USize) : USize :=
  bifUSize (USize.beq n USize.zero) USize.neg1
    (USize.ofU32 (U32.load (u32Slot slots (USize.sub n USize.one))))

/-- Peek top without removing. Same return shape as `pop`. -/
public unsafe def peek (slots : USize) (n : USize) : USize :=
  pop slots n

end Systems.Stack
