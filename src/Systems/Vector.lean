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
# Systems.Vector (Systems Lean)

Fixed-capacity **vector** over raw memory — not `Std.Vector`, not a growable managed
`Array` / `List` / RC storage, and not an open-ended slice product.

Layout (caller-owned):

* `slots` — `cap` host-endian `U32` slots (`cap * 4` bytes), **4-byte aligned**
* `n` / length — dual `USize` owned by the **caller** (not stored by this module)

Ops:

* **len** / **cap** — pass-through documentation of dual params
* **push** at index `n` when `n < cap`
* **pop** last element when non-empty
* **get** / **set** by index with bounds status
* **clear** is caller-side (`n := 0`); this module only documents occupancy helpers

No malloc. No freestanding multi-field product returns. Status codes follow
`Systems.Status` (`0` ok, `3` bounds/full/empty-as-bounds where noted).

## Portability / ABI

* **Alignment:** `U32.load` / `U32.store` are host-endian word accesses; unaligned `slots`
  bases are ISO C undefined behavior. Pass 4-byte-aligned buffers (e.g. `uint32_t[]`).
* **Capacity contract:** `u32Slot` uses `USize.mul i 4` without overflow checks (Map
  parity). Keep `cap` small enough that `cap * 4` fits in `size_t`. Adversarial huge
  `cap` can wrap offsets — not a product harness claim.
* **LP64 product harness:** `pop` / `get` miss use `USize.neg1` (`(size_t)-1`). On ILP32
  that collides with storing `UINT32_MAX` — treat as **LP64-only** (Map `get` class).
* **Not claimed:** growable vectors, concurrency, slices as products, or managed storage.

## Intentional TCB (Vector-local)

`U32.load`/`store`, `USize.ofU32`/`mul` are freestanding `@[extern]` axioms kept
**here** (Queue/Map parity). Name-pinned on ComplianceCorpus (`path name=Ident`).
-/

namespace Systems.Vector

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

/-- Push `val` at index `n`. `0` ok; `errBounds` if full / `cap == 0`.

Does **not** update caller length — on success the caller must use `n + 1`.
Store status is dataflow-used so EmitC cannot DCE the slot write. -/
public unsafe def push (slots : USize) (cap : USize) (n : USize) (val : U32) : U32 :=
  bifU32 (USize.beq cap USize.zero) errBounds
    (bifU32 (USize.beq n cap) errBounds
      (let st := U32.store (u32Slot slots n) val
       bifU32 (isOk st) ok st))

/-- Pop last value as `USize` (`0..UINT32_MAX`), or `USize.neg1` if empty.

Does **not** update caller `n` — on success use `n - 1`.
**LP64 only** for the miss sentinel (see module docs). -/
public unsafe def pop (slots : USize) (n : USize) : USize :=
  bifUSize (USize.beq n USize.zero) USize.neg1
    (USize.ofU32 (U32.load (u32Slot slots (USize.sub n USize.one))))

/-- Bounds-safe get: value as `USize`, or `USize.neg1` if `i ≥ n`. **LP64 only**. -/
public unsafe def get (slots : USize) (n : USize) (i : USize) : USize :=
  bifUSize (USize.blt i n)
    (USize.ofU32 (U32.load (u32Slot slots i)))
    USize.neg1

/-- Bounds-safe set: `0` ok, `errBounds` if `i ≥ n`.

Store status is dataflow-used so EmitC cannot DCE the write. -/
public unsafe def set (slots : USize) (n : USize) (i : USize) (val : U32) : U32 :=
  bifU32 (USize.blt i n)
    (let st := U32.store (u32Slot slots i) val
     bifU32 (isOk st) ok st)
    errBounds

/-- Clear is occupancy-only on the dual-param surface: returns `ok`.

Caller must set `n := 0`. Slot bytes are left unchanged (no bulk zero — use
`Mem.memZero` if scrubbing is required). `never_extract` keeps the status on the
control-flow path when sequenced by consumers. -/
@[never_extract]
public def clear (_slots : USize) (_cap : USize) : U32 :=
  ok

end Systems.Vector
