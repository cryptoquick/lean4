/-
Copyright (c) 2026 Lean FRO, LLC. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Hunter Beast
-/
module
prelude
public import Systems.Scalars
public import Systems.Bytes
public import Systems.Parallelism.Simd

/-!
# Systems.Parallelism.ForkJoin (Three-Layer Cake L2)

**L2 — ownership-partition fork/join.**

* API splits a dual-param range into left/right halves and runs pure work on each.
* **Product default = sequential** (`l2BackendSequential = 0`): left then right
  (no pthread / no Lean `Task` in residual / ccomp product matrix).
* **Caller contract (not type-enforced):** L/R `addr`/`len` pairs must be **disjoint**;
  freestanding has no points-to analysis. `partitionOwnershipAssumed` is a documentation
  marker only. **No shared mutable cell across partitions** (sequential or pthread).
* Honest: this is **not** a verified parallel runtime or memory model; it is a freestanding
  ownership API whose sequential body is residual-free and ccomp-acceptable.
  Greppable product honesty: `CONCURRENT_RUNTIME_ASSUMED_NOT_PROVED=1` /
  `PRODUCT_PARALLELISM_L2_SEQUENTIAL=1` from `script/systems-par-dual-path-check.sh`.

## Dual path (product vs opt-in pthread)

| Path | Symbol | Backend id | Link |
|------|--------|------------|------|
| **Product (default)** | `forkJoinMapAdd` / `lean_fs_par_fork_join` | `l2BackendSequential` → `0` | freestanding.bundle only |
| **Opt-in pthread** | `lean_fs_par_fork_join_pthread` (hand C TU) | `lean_fs_par_l2_backend_pthread` → `1` | + `par_pthread.c` `-pthread` |

Pthread bodies live in `tests/lake/examples/systems/par_pthread.c` (link-time only;
not emitted from Lean freestanding; not on residual_nm / ccomp product matrix). Enabled by
the **compile define** `-DSYSTEMS_LEAN_PAR_PTHREAD=1` on `make check-par-pthread` (not an
environment variable). Default `make check` must not require pthread.
-/

namespace Systems.Parallelism.ForkJoin

open Systems.Scalars
open Systems.Bytes
open Systems.Parallelism.Simd

/-- Midpoint split: `mid = n / 2` (unsigned). -/
@[extern c inline "((size_t)((size_t)(#1) / (size_t)2))"]
public axiom half : USize → USize

/-- Run two pure range kernels **sequentially** (L then R).

**Caller contract:** `lDst`/`lLen` and `rDst`/`rLen` (and matching src halves) must be
**disjoint**; not checked by the type system. `addend` is applied as L1 `mapAddU8` on
each half. Returns `0` on completion. Product default — pthread is opt-in host dogfood. -/
@[never_extract]
public unsafe def runPartitionedMapAdd
    (lDst : USize) (lSrc : USize) (lLen : USize)
    (rDst : USize) (rSrc : USize) (rLen : USize)
    (addend : U8) : U32 :=
  let _l := mapAddU8 lDst lSrc lLen addend
  let _r := mapAddU8 rDst rSrc rLen addend
  U32.zero

/-- Split `[src, src+n)` into halves and map-add into matching dst halves (sequential).

When `n = 0` or `1`, the right partition may be empty (`rLen = 0` is a no-op loop). -/
@[never_extract]
public unsafe def forkJoinMapAdd (dst : USize) (src : USize) (n : USize) (addend : U8) : U32 :=
  let mid := half n
  let rLen := USize.sub n mid
  runPartitionedMapAdd
    dst src mid
    (USize.add dst mid) (USize.add src mid) rLen
    addend

/-- Partitioned fold: XOR-fold left and right ranges, then XOR the two accumulators.

Sequential; pure dual-param ownership. Empty partitions (`len = 0`) are no-ops in `foldXorU8`. -/
public unsafe def forkJoinFoldXor (lAddr : USize) (lLen : USize) (rAddr : USize) (rLen : USize) : U8 :=
  let a := foldXorU8 lAddr lLen
  let b := foldXorU8 rAddr rLen
  U8.xor a b

/-- Backend marker: sequential L2 is the product default (`0` = sequential).

Not a runtime toggle — documents the API contract for extract/host tests. Product
residual-free / ccomp PROVABLY path is sequential only. The opt-in pthread TU reports
`1` via `lean_fs_par_l2_backend_pthread` when linked under
`-DSYSTEMS_LEAN_PAR_PTHREAD=1` / `make check-par-pthread` and must not replace this
export on the product residual matrix. -/
@[extern c inline "((uint32_t)0)"]
public axiom l2BackendSequential : U32

/-- Documentation marker (`1` = caller claims L/R partitions are disjoint).

Not type-enforced and not a dynamic alias analysis. Callers of `runPartitionedMapAdd` /
`forkJoinFoldXor` must uphold disjoint `addr`/`len` pairs and must not share a mutable
cell across L/R workers (sequential or pthread). -/
@[extern c inline "((uint32_t)1)"]
public axiom partitionOwnershipAssumed : U32

/-- Sequential ownership smoke: partition map-add then XOR-fold both halves.

Returns `(foldL xor foldR)` as `U32` (low byte). Still L-then-R sequential; residual-free. -/
@[never_extract]
public unsafe def forkJoinMapThenFold
    (dst : USize) (src : USize) (n : USize) (addend : U8) : U32 :=
  let _m := forkJoinMapAdd dst src n addend
  let mid := half n
  let rLen := USize.sub n mid
  U32.ofU8 (U8.xor (foldXorU8 dst mid) (foldXorU8 (USize.add dst mid) rLen))

end Systems.Parallelism.ForkJoin
