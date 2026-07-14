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
# Systems.ArenaPool (Systems Lean)

Fixed-capacity **bump allocator** over a **caller-owned** byte buffer — arena-**shaped**,
not `Systems.Sys.Arena` (no `malloc` header), not a general heap, not free-list reuse.

Layout (caller-owned):

* `base` / `cap` — payload buffer dual view
* `used` — bump offset in `[0, cap]` (pure dual params **or** host `size_t` slot)

Ops:

* **remaining** — `cap - used` when `used ≤ cap`, else `0`
* **canAlloc** — status `0` if `nbytes` fits without overflow
* **allocAddr** / **allocEnd** — pure bump (no store): allocation address / new used
* **reset** / **storeUsed** / **loadUsed** — optional `size_t` slot for live used
* **alloc** — load used from slot, bump, store new used; returns addr or miss

Honesty:

* **Caller buffer only** — never malloc/free; does not own `base`.
* No individual free / coalescing / alignment padding product API (caller may pad `nbytes`).
* Not claimed: thread safety, provenance, or overflow-hardening on adversarial
  `base + used` huge inputs (product harness uses small buffers).
* Store status is dataflow-used so EmitC cannot DCE used-slot writes (`never_extract`).

## Intentional TCB (ArenaPool-local)

`USize.load` / `USize.store` for the optional used slot are freestanding `@[extern]`
axioms kept **here**. Name-pinned on ComplianceCorpus (`path name=Ident`).
-/

namespace Systems.ArenaPool

open Systems.Scalars
open Systems.Bytes
open Systems.Status

/-- Host-endian `size_t` load (`addr` must be `sizeof(size_t)`-aligned). -/
@[extern c inline "(*((const size_t*)(#1)))"]
public axiom USize.load : USize → USize

/-- Host-endian `size_t` store; returns `0` (`addr` must be aligned). -/
@[never_extract, extern c inline "(*((size_t*)(#1)) = (size_t)(#2), (uint32_t)0)"]
public axiom USize.store : USize → USize → U32

/-- Bytes remaining: `cap - used` if `used ≤ cap`, else `0`. -/
public unsafe def remaining (cap : USize) (used : USize) : USize :=
  bifUSize (USize.blt cap used) USize.zero (USize.sub cap used)

/-- Status `0` if `used + nbytes ≤ cap` without unsigned add overflow; else `errBounds`. -/
public unsafe def canAlloc (cap : USize) (used : USize) (nbytes : USize) : U32 :=
  bifU32 (USize.uaddWouldOverflow used nbytes) errBounds
    (bifU32 (USize.blt cap (USize.add used nbytes)) errBounds ok)

/-- Pure bump end offset after allocating `nbytes`, or `USize.neg1` if it does not fit.

**LP64 miss sentinel.** Does not write memory. -/
public unsafe def allocEnd (cap : USize) (used : USize) (nbytes : USize) : USize :=
  bifUSize (isOk (canAlloc cap used nbytes)) (USize.add used nbytes) USize.neg1

/-- Pure allocation address `base + used` when it fits, else `USize.neg1`.

Does not write memory. Pair with `allocEnd` for the new bump. -/
public unsafe def allocAddr (base : USize) (cap : USize) (used : USize) (nbytes : USize) : USize :=
  bifUSize (isOk (canAlloc cap used nbytes)) (USize.add base used) USize.neg1

/-- Load used counter from a caller `size_t` slot. -/
public unsafe def loadUsed (usedSlot : USize) : USize :=
  USize.load usedSlot

/-- Store used counter. Status dataflow-used (`never_extract` store). -/
public unsafe def storeUsed (usedSlot : USize) (used : USize) : U32 :=
  let st := USize.store usedSlot used
  bifU32 (isOk st) ok st

/-- Reset used slot to `0`. Store status dataflow-used. -/
public unsafe def reset (usedSlot : USize) : U32 :=
  storeUsed usedSlot USize.zero

/-- Bump-allocate from slot-backed used: store new used, return payload addr or miss.

`0`-sized alloc succeeds at the current bump (no growth) when `used ≤ cap`.
Store status is dataflow-used. **LP64 miss.** -/
public unsafe def alloc (base : USize) (cap : USize) (usedSlot : USize) (nbytes : USize) : USize :=
  let used := USize.load usedSlot
  bifUSize (isOk (canAlloc cap used nbytes))
    (let next := USize.add used nbytes
     let st := USize.store usedSlot next
     bifUSize (isOk st) (USize.add base used) USize.neg1)
    USize.neg1

/-- Status form of slot alloc: `0` ok, `3` bounds; updates used on success. -/
public unsafe def allocStatus (base : USize) (cap : USize) (usedSlot : USize)
    (nbytes : USize) : U32 :=
  let used := USize.load usedSlot
  bifU32 (isOk (canAlloc cap used nbytes))
    (let next := USize.add used nbytes
     -- Touch `base` in the dataflow so EmitC cannot treat the bump as pure dead.
     let _addr := USize.add base used
     let st := USize.store usedSlot (USize.add next (USize.sub _addr _addr))
     bifU32 (isOk st) ok st)
    errBounds

end Systems.ArenaPool
