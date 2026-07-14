/-
Copyright (c) 2026 Hunter Beast. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Hunter Beast
-/
module
prelude
public import Systems.Scalars
public import Systems.Bytes
public import Systems.Numerics
public import Systems.Status

/-!
# Systems.DepGraph (Systems Lean)

Fixed-capacity **dependency DAG** of `U32` node ids over caller-owned slots —
build-order-**shaped** (Kahn topo + cycle detect), not a general graph library /
dynamic alloc / weighted edges / concurrent scheduler.

Layout (caller-owned):

* `adj` — `nodeCap * maxDeg` host-endian `U32` neighbor slots (**4-byte aligned**).
  Edge `src → dst` means **`src` must precede `dst`** (prerequisite → dependent).
* `degs` — `nodeCap` host-endian `U32` out-degree counters (**4-byte aligned**)
* `indeg` — `nodeCap` working indegree slots for Kahn (**4-byte aligned**)
* `queue` — `nodeCap` `U32` Kahn queue slots
* `out` — `nodeCap` `U32` topo-order output slots

Ops:

* **init** — zero all out-degrees (required before use)
* **addEdge** — directed edge `src → dst` when degree room remains
* **degree** / **neighbor** — query adjacency (out-neighbors of `src`)
* **topo** — Kahn topological order into `out`; `0` ok (all `nodeCap` nodes ordered),
  `1` cycle (partial `out` undefined for unprocessed), `3` bounds

No malloc. No freestanding multi-field product returns. Status codes follow
`Systems.Status` (`0` ok, `1` cycle/generic fail, `3` bounds/full).

Distinct from `Graph`: Graph is BFS reachability over the same adj shape;
DepGraph is **Kahn topo / cycle** for Slake build ordering.

## Portability / ABI

* **Alignment:** `U32.load` / `U32.store` require 4-byte-aligned bases.
* **Capacity contract:** slot address math uses `USize.mul` without overflow checks
  (Graph parity). Keep `nodeCap * maxDeg * 4` in `size_t`.
* **LP64 product harness:** `neighbor` / `degree` / `outAt` miss uses `USize.neg1`.
* **Not claimed:** reverse-edge auto twin, priority scheduling, incremental invalidation.

## Intentional TCB (DepGraph-local)

`U32.load`/`store`, `USize.ofU32`/`mul` are freestanding `@[extern]` axioms kept **here**
(Graph parity). Name-pinned on ComplianceCorpus (`path name=Ident`).
Store status is dataflow-used so EmitC cannot DCE slot writes (`never_extract` stores).
-/

namespace Systems.DepGraph

open Systems.Scalars
open Systems.Bytes
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

/-- Narrow `USize` → `U32` (node id / queue seed; caller keeps ids in `uint32_t` range). -/
@[extern c inline "((uint32_t)(size_t)(#1))"]
public axiom U32.ofUSize : USize → U32

/-- Address of `U32` slot `i` in a contiguous word array at `base` (base 4-byte aligned).

Uses `i` in the dataflow so freestanding emit does not lift a ground `base+0` closed term. -/
public def u32Slot (base : USize) (i : USize) : USize :=
  USize.add base (USize.mul i USize.four)

/-- Flat adj index for neighbor `j` of node `u`: `u * maxDeg + j`. -/
public def adjIndex (u : USize) (maxDeg : USize) (j : USize) : USize :=
  USize.add (USize.mul u maxDeg) j

/-- Zero degrees loop. Store status dataflow-used. -/
public unsafe def initGo (degs : USize) (nodeCap : USize) (i : USize) : U32 :=
  bifU32 (USize.blt i nodeCap)
    (let st := U32.store (u32Slot degs i) U32.zero
     bifU32 (isOk st) (initGo degs nodeCap (USize.add i USize.one)) st)
    ok

/-- Zero all out-degree counters for `nodeCap` nodes.

`nodeCap == 0` is a no-op success (empty graph). -/
public unsafe def init (degs : USize) (nodeCap : USize) : U32 :=
  initGo degs nodeCap USize.zero

/-- Directed edge `src → dst` (src precedes dst) when room under `maxDeg`.

`0` ok; `3` bounds/full/`maxDeg==0`. Store status is dataflow-used. -/
public unsafe def addEdge (adj : USize) (degs : USize) (nodeCap : USize) (maxDeg : USize)
    (src : U32) (dst : U32) : U32 :=
  bifU32 (USize.beq nodeCap USize.zero) errBounds
    (bifU32 (USize.beq maxDeg USize.zero) errBounds
      (let su := USize.ofU32 src
       let du := USize.ofU32 dst
       bifU32 (USize.blt su nodeCap)
         (bifU32 (USize.blt du nodeCap)
           (let d := U32.load (u32Slot degs su)
            let dSz := USize.ofU32 d
            bifU32 (USize.blt dSz maxDeg)
              (let st := U32.store (u32Slot adj (adjIndex su maxDeg dSz)) dst
               bifU32 (isOk st)
                 (let st2 := U32.store (u32Slot degs su) (U32.add d U32.one)
                  bifU32 (isOk st2) ok st2)
                 st)
              errBounds)
           errBounds)
         errBounds))

/-- Out-degree of node `u` as `USize`, or `USize.neg1` if `u ≥ nodeCap`. **LP64 miss.** -/
public unsafe def degree (degs : USize) (nodeCap : USize) (u : U32) : USize :=
  let uu := USize.ofU32 u
  bifUSize (USize.blt uu nodeCap)
    (USize.ofU32 (U32.load (u32Slot degs uu)))
    USize.neg1

/-- Neighbor `j` of `u` as `USize`, or `USize.neg1` if out of range. **LP64 miss.** -/
public unsafe def neighbor (adj : USize) (degs : USize) (nodeCap : USize) (maxDeg : USize)
    (u : U32) (j : USize) : USize :=
  let uu := USize.ofU32 u
  bifUSize (USize.blt uu nodeCap)
    (let d := USize.ofU32 (U32.load (u32Slot degs uu))
     bifUSize (USize.blt j d)
       (bifUSize (USize.blt j maxDeg)
         (USize.ofU32 (U32.load (u32Slot adj (adjIndex uu maxDeg j))))
         USize.neg1)
       USize.neg1)
    USize.neg1

/-- Topo output slot `i` as `USize`, or miss. **LP64 miss.** -/
public unsafe def outAt (out : USize) (nodeCap : USize) (i : USize) : USize :=
  bifUSize (USize.blt i nodeCap)
    (USize.ofU32 (U32.load (u32Slot out i)))
    USize.neg1

/-- Zero indegree slots. -/
public unsafe def indegClearGo (indeg : USize) (nodeCap : USize) (i : USize) : U32 :=
  bifU32 (USize.blt i nodeCap)
    (let st := U32.store (u32Slot indeg i) U32.zero
     bifU32 (isOk st) (indegClearGo indeg nodeCap (USize.add i USize.one)) st)
    ok

/-- For each out-neighbor `v` of `u`, increment `indeg[v]`. Returns status. -/
public unsafe def indegAddNeighbors (adj : USize) (degs : USize) (indeg : USize)
    (nodeCap : USize) (maxDeg : USize) (u : USize) (j : USize) : U32 :=
  let d := USize.ofU32 (U32.load (u32Slot degs u))
  bifU32 (USize.blt j d)
    (let v := U32.load (u32Slot adj (adjIndex u maxDeg j))
     let vu := USize.ofU32 v
     bifU32 (USize.blt vu nodeCap)
       (let cur := U32.load (u32Slot indeg vu)
        let st := U32.store (u32Slot indeg vu) (U32.add cur U32.one)
        bifU32 (isOk st)
          (indegAddNeighbors adj degs indeg nodeCap maxDeg u (USize.add j USize.one))
          st)
       errBounds)
    ok

/-- Fill indegrees from adjacency: scan all nodes' out-edges. -/
public unsafe def indegFillGo (adj : USize) (degs : USize) (indeg : USize)
    (nodeCap : USize) (maxDeg : USize) (u : USize) : U32 :=
  bifU32 (USize.blt u nodeCap)
    (let st := indegAddNeighbors adj degs indeg nodeCap maxDeg u USize.zero
     bifU32 (isOk st)
       (indegFillGo adj degs indeg nodeCap maxDeg (USize.add u USize.one))
       st)
    ok

/-- Enqueue `val` at `tail` when room; returns new tail or miss. -/
public unsafe def qPush (queue : USize) (nodeCap : USize) (tail : USize) (val : U32) : USize :=
  bifUSize (USize.blt tail nodeCap)
    (let st := U32.store (u32Slot queue tail) val
     bifUSize (isOk st) (USize.add tail USize.one) USize.neg1)
    USize.neg1

/-- Seed Kahn queue with all nodes of indegree 0. Returns tail or miss. -/
public unsafe def seedZeroGo (indeg : USize) (queue : USize) (nodeCap : USize)
    (i : USize) (tail : USize) : USize :=
  bifUSize (USize.blt i nodeCap)
    (bifUSize (U32.beq (U32.load (u32Slot indeg i)) U32.zero)
      (let t2 := qPush queue nodeCap tail (U32.ofUSize i)
       bifUSize (USize.beq t2 USize.neg1) USize.neg1
         (seedZeroGo indeg queue nodeCap (USize.add i USize.one) t2))
      (seedZeroGo indeg queue nodeCap (USize.add i USize.one) tail))
    tail

/-- Relax out-neighbors of `u`: decrement indeg; enqueue when zero. Returns new tail or miss. -/
public unsafe def relaxNeighbors (adj : USize) (degs : USize) (indeg : USize) (queue : USize)
    (nodeCap : USize) (maxDeg : USize) (u : U32) (j : USize) (tail : USize) : USize :=
  let uu := USize.ofU32 u
  let d := USize.ofU32 (U32.load (u32Slot degs uu))
  bifUSize (USize.blt j d)
    (let v := U32.load (u32Slot adj (adjIndex uu maxDeg j))
     let vu := USize.ofU32 v
     bifUSize (USize.blt vu nodeCap)
       (let cur := U32.load (u32Slot indeg vu)
        bifUSize (U32.beq cur U32.zero) USize.neg1
          (let next := U32.sub cur U32.one
           let st := U32.store (u32Slot indeg vu) next
           bifUSize (isOk st)
             (bifUSize (U32.beq next U32.zero)
               (let t2 := qPush queue nodeCap tail v
                bifUSize (USize.beq t2 USize.neg1) USize.neg1
                  (relaxNeighbors adj degs indeg queue nodeCap maxDeg u (USize.add j USize.one) t2))
               (relaxNeighbors adj degs indeg queue nodeCap maxDeg u (USize.add j USize.one) tail))
             USize.neg1))
       USize.neg1)
    tail

/-- Kahn loop: process queue, write topo to `out`. Returns processed count as USize, or miss. -/
public unsafe def topoGo (adj : USize) (degs : USize) (indeg : USize) (queue : USize) (out : USize)
    (nodeCap : USize) (maxDeg : USize) (head : USize) (tail : USize) (nOut : USize) : USize :=
  bifUSize (USize.blt head tail)
    (let u := U32.load (u32Slot queue head)
     bifUSize (USize.blt nOut nodeCap)
       (let st := U32.store (u32Slot out nOut) u
        bifUSize (isOk st)
          (let t2 := relaxNeighbors adj degs indeg queue nodeCap maxDeg u USize.zero tail
           bifUSize (USize.beq t2 USize.neg1) USize.neg1
             (topoGo adj degs indeg queue out nodeCap maxDeg
               (USize.add head USize.one) t2 (USize.add nOut USize.one)))
          USize.neg1)
       USize.neg1)
    nOut

/-- Kahn topological order into `out`.

`0` ok — `out[0..nodeCap)` is a valid order of all nodes.
`1` cycle — fewer than `nodeCap` nodes ordered (partial `out` not a full order).
`3` bounds — empty caps or internal store/queue failure.

Caller provides working `indeg` / `queue` buffers of length `nodeCap`. -/
public unsafe def topo (adj : USize) (degs : USize) (indeg : USize) (queue : USize) (out : USize)
    (nodeCap : USize) (maxDeg : USize) : U32 :=
  bifU32 (USize.beq nodeCap USize.zero) errBounds
    (bifU32 (USize.beq maxDeg USize.zero) errBounds
      (let st0 := indegClearGo indeg nodeCap USize.zero
       bifU32 (isOk st0)
         (let st1 := indegFillGo adj degs indeg nodeCap maxDeg USize.zero
          bifU32 (isOk st1)
            (let t0 := seedZeroGo indeg queue nodeCap USize.zero USize.zero
             bifU32 (USize.beq t0 USize.neg1) errBounds
               (let n := topoGo adj degs indeg queue out nodeCap maxDeg USize.zero t0 USize.zero
                bifU32 (USize.beq n USize.neg1) errBounds
                  (bifU32 (USize.beq n nodeCap) ok err)))
            st1)
         st0))

end Systems.DepGraph
