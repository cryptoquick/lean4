/-
Copyright (c) 2026 Lean FRO, LLC. All rights reserved.
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
# Systems.Graph (Systems Lean)

Fixed-capacity **adjacency-list graph** of `U32` node ids over caller-owned slots —
graph-**shaped**, not a general graph library / dynamic alloc / weighted edges.

Layout (caller-owned):

* `adj` — `nodeCap * maxDeg` host-endian `U32` neighbor slots (**4-byte aligned**)
* `degs` — `nodeCap` host-endian `U32` degree counters (**4-byte aligned**)
* `marks` — optional `nodeCap` `U8` visit marks for BFS (`0` unvisited, `1` visited)
* `queue` — optional `nodeCap` `U32` BFS queue slots

Ops:

* **init** — zero all degrees (required before use)
* **addEdge** — append directed edge `u → v` when degree room remains
* **degree** / **neighbor** — query adjacency
* **visitClear** / **mark** / **isMarked** — visit marks over caller `U8` buffer
* **bfs** — mark all nodes reachable from `start` (directed); status only

No malloc. No freestanding multi-field product returns. Status codes follow
`Systems.Status` (`0` ok, `1` absent/bad, `3` bounds/full).

## Portability / ABI

* **Alignment:** `U32.load` / `U32.store` are host-endian word accesses; unaligned bases
  are ISO C undefined behavior. Pass 4-byte-aligned buffers (e.g. `uint32_t[]`).
* **Capacity contract:** slot address math uses `USize.mul` without overflow checks
  (Vector parity). Keep `nodeCap * maxDeg * 4` in `size_t`.
* **LP64 product harness:** `neighbor` / `degree` miss use `USize.neg1` where noted.
* **Not claimed:** undirected auto-twin edges, weights, dynamic grow, concurrency.

## Intentional TCB (Graph-local)

`U32.load`/`store`, `USize.ofU32`/`mul` are freestanding `@[extern]` axioms kept **here**
(Vector/Tree parity). Name-pinned on ComplianceCorpus (`path name=Ident`).
Store status is dataflow-used so EmitC cannot DCE slot writes (`never_extract` stores).
-/

namespace Systems.Graph

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

/-- Occupied / visited mark byte (`1`). -/
@[extern c inline "1"] public axiom U8.one : U8

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

/-- Zero all degree counters for `nodeCap` nodes. `0` ok; `3` if `nodeCap == 0` treated ok empty.

`nodeCap == 0` is a no-op success (empty graph). -/
public unsafe def init (degs : USize) (nodeCap : USize) : U32 :=
  initGo degs nodeCap USize.zero

/-- Directed edge `u → v` when room under `maxDeg`. `0` ok; `3` bounds/full/`maxDeg==0`.

Does **not** add the reverse edge. Store status is dataflow-used. -/
public unsafe def addEdge (adj : USize) (degs : USize) (nodeCap : USize) (maxDeg : USize)
    (u : U32) (v : U32) : U32 :=
  bifU32 (USize.beq nodeCap USize.zero) errBounds
    (bifU32 (USize.beq maxDeg USize.zero) errBounds
      (let uu := USize.ofU32 u
       let vv := USize.ofU32 v
       bifU32 (USize.blt uu nodeCap)
         (bifU32 (USize.blt vv nodeCap)
           (let d := U32.load (u32Slot degs uu)
            let dSz := USize.ofU32 d
            bifU32 (USize.blt dSz maxDeg)
              (let st := U32.store (u32Slot adj (adjIndex uu maxDeg dSz)) v
               bifU32 (isOk st)
                 (let st2 := U32.store (u32Slot degs uu) (U32.add d U32.one)
                  bifU32 (isOk st2) ok st2)
                 st)
              errBounds)
           errBounds)
         errBounds))

/-- Degree of node `u` as `USize`, or `USize.neg1` if `u ≥ nodeCap`. **LP64 miss.** -/
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

/-- Clear visit marks (`0`) for `nodeCap` nodes. Store status dataflow-used. -/
public unsafe def visitClearGo (marks : USize) (nodeCap : USize) (i : USize) : U32 :=
  bifU32 (USize.blt i nodeCap)
    (let st := U8.store (USize.add marks i) U8.zero
     bifU32 (isOk st) (visitClearGo marks nodeCap (USize.add i USize.one)) st)
    ok

/-- Zero visit marks buffer of length `nodeCap`. -/
public unsafe def visitClear (marks : USize) (nodeCap : USize) : U32 :=
  visitClearGo marks nodeCap USize.zero

/-- Mark node `u` visited (`1`). `0` ok, `3` if out of range. -/
public unsafe def mark (marks : USize) (nodeCap : USize) (u : U32) : U32 :=
  let uu := USize.ofU32 u
  bifU32 (USize.blt uu nodeCap)
    (U8.store (USize.add marks uu) U8.one)
    errBounds

/-- `1` if mark at `u` is set, `0` if clear; `USize.neg1` as status via... returns U32:

`1` marked, `0` unmarked, `3` out of range. -/
public unsafe def isMarked (marks : USize) (nodeCap : USize) (u : U32) : U32 :=
  let uu := USize.ofU32 u
  bifU32 (USize.blt uu nodeCap)
    (bifU32 (U8.beq (U8.load (USize.add marks uu)) U8.one) U32.one U32.zero)
    errBounds

/-- Enqueue `val` at queue index `tail` when `tail < nodeCap`. Returns new tail or miss. -/
public unsafe def qPush (queue : USize) (nodeCap : USize) (tail : USize) (val : U32) : USize :=
  bifUSize (USize.blt tail nodeCap)
    (let st := U32.store (u32Slot queue tail) val
     bifUSize (isOk st) (USize.add tail USize.one) USize.neg1)
    USize.neg1

/-- Expand neighbors of `u` into the BFS queue; returns new tail or miss. -/
public unsafe def bfsExpand (adj : USize) (degs : USize) (marks : USize) (queue : USize)
    (nodeCap : USize) (maxDeg : USize) (u : U32) (j : USize) (tail : USize) : USize :=
  let d := USize.ofU32 (U32.load (u32Slot degs (USize.ofU32 u)))
  bifUSize (USize.blt j d)
    (let nb := U32.load (u32Slot adj (adjIndex (USize.ofU32 u) maxDeg j))
     let nbu := USize.ofU32 nb
     bifUSize (USize.blt nbu nodeCap)
       (bifUSize (U8.beq (U8.load (USize.add marks nbu)) U8.one)
         (bfsExpand adj degs marks queue nodeCap maxDeg u (USize.add j USize.one) tail)
         (let st := U8.store (USize.add marks nbu) U8.one
          bifUSize (isOk st)
            (let t2 := qPush queue nodeCap tail nb
             bifUSize (USize.beq t2 USize.neg1) USize.neg1
               (bfsExpand adj degs marks queue nodeCap maxDeg u (USize.add j USize.one) t2))
            USize.neg1))
       USize.neg1)
    tail

/-- BFS loop over queue `[head, tail)`. Returns `0` ok, `1` expand fail, `3` bad start. -/
public unsafe def bfsGo (adj : USize) (degs : USize) (marks : USize) (queue : USize)
    (nodeCap : USize) (maxDeg : USize) (head : USize) (tail : USize) : U32 :=
  bifU32 (USize.blt head tail)
    (let u := U32.load (u32Slot queue head)
     let t2 := bfsExpand adj degs marks queue nodeCap maxDeg u USize.zero tail
     bifU32 (USize.beq t2 USize.neg1) err
       (bfsGo adj degs marks queue nodeCap maxDeg (USize.add head USize.one) t2))
    ok

/-- Directed BFS from `start`: clear marks, mark reachable set. `0` ok, `3` bounds.

Caller provides `marks` (`U8[nodeCap]`) and `queue` (`U32[nodeCap]`).
`maxDeg == 0` or `nodeCap == 0` → `errBounds`. Store statuses dataflow-used. -/
public unsafe def bfs (adj : USize) (degs : USize) (marks : USize) (queue : USize)
    (nodeCap : USize) (maxDeg : USize) (start : U32) : U32 :=
  bifU32 (USize.beq nodeCap USize.zero) errBounds
    (bifU32 (USize.beq maxDeg USize.zero) errBounds
      (let s := USize.ofU32 start
       bifU32 (USize.blt s nodeCap)
         (let st0 := visitClear marks nodeCap
          bifU32 (isOk st0)
            (let st1 := U8.store (USize.add marks s) U8.one
             bifU32 (isOk st1)
               (let t0 := qPush queue nodeCap USize.zero start
                bifU32 (USize.beq t0 USize.neg1) errBounds
                  (bfsGo adj degs marks queue nodeCap maxDeg USize.zero t0))
               st1)
            st0)
         errBounds))

end Systems.Graph
