/-
Copyright (c) 2026 Lean FRO, LLC. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Hunter Beast
-/
module
prelude
public import Systems.Scalars
public import Systems.Bytes

/-!
# Systems.Parallelism.Simd (Three-Layer Cake L1)

**L1 — data-parallel map/fold** over dual `addr`/`len` ranges.

* Pure scalar loops (self-TCO → C `if`/`goto`); **no shared mutable state**.
* No Lean `Task` / `IO` / pthread — sequential emit is intentional for the product path.
* Ownership: ranges are raw dual params (ω scalars), not RC arrays.
* **SIMD-shaped, not hardware SIMD:** chunked 4-wide loops process four independent
  bytes per iteration (ILP-friendly, residual-free). This is **not** a claim of
  autovectorization or platform SIMD intrinsics on the **product residual** path
  (`PRODUCT_PARALLELISM_L1_SHAPED_ONLY=1`). Host dogfood HW SIMD lives in
  `tests/lake/examples/systems/par_simd_hw.c` (`make check-par-simd-hw`) and
  must not enter residual_nm / residual_ir / ccomp product matrix.

## Range contract (caller)

`dst` and `src` ranges of length `n` must be **non-overlapping** (memcpy-like), or
identical only when a pure in-place scalar step would be well-defined. Partial
overlap is undefined for map: scalar and chunked-4 bodies may diverge under aliasing
because the 4-wide path loads a window before any store of that window.
-/

namespace Systems.Parallelism.Simd

open Systems.Scalars
open Systems.Bytes

/-- Byte add (wrap). -/
@[extern c inline "((uint8_t)((uint8_t)(#1) + (uint8_t)(#2)))"]
public axiom U8.add : U8 → U8 → U8

/-- Map: for each index `i < n`, `dst[i] = src[i] + addend` (byte-wise wrap).

Requires non-overlapping `dst`/`src` ranges (see module docs).
`@[never_extract]` — stores are effects; must not DCE when status is discarded. -/
@[never_extract]
public unsafe def mapAddU8Go (dst : USize) (src : USize) (i : USize) (n : USize) (addend : U8) : U32 :=
  bifU32 (USize.blt i n)
    (let v := U8.load (USize.add src i)
     let _s := U8.store (USize.add dst i) (U8.add v addend)
     mapAddU8Go dst src (USize.add i USize.one) n addend)
    U32.zero

/-- Convenience: map full `[0, n)`. -/
@[never_extract]
public unsafe def mapAddU8 (dst : USize) (src : USize) (n : USize) (addend : U8) : U32 :=
  mapAddU8Go dst src USize.zero n addend

/-- Chunked 4-wide map: when `n - i ≥ 4`, write four independent bytes then advance by 4;
otherwise fall back to one scalar store. Sequential self-TCO; residual-free.

Shape is SIMD-friendly (independent lane work). **Not** hardware SIMD / intrinsics.
Requires non-overlapping `dst`/`src` (partial overlap may diverge from scalar map). -/
@[never_extract]
public unsafe def mapAddU8Chunk4Go
    (dst : USize) (src : USize) (i : USize) (n : USize) (addend : U8) : U32 :=
  bifU32 (USize.blt i n)
    (bifU32 (USize.blt (USize.sub n i) USize.four)
      -- remaining < 4: scalar remainder
      (let v := U8.load (USize.add src i)
       let _s := U8.store (USize.add dst i) (U8.add v addend)
       mapAddU8Chunk4Go dst src (USize.add i USize.one) n addend)
      -- remaining ≥ 4: four independent loads/stores
      (let i0 := i
       let i1 := USize.add i USize.one
       let i2 := USize.add i1 USize.one
       let i3 := USize.add i2 USize.one
       let v0 := U8.add (U8.load (USize.add src i0)) addend
       let v1 := U8.add (U8.load (USize.add src i1)) addend
       let v2 := U8.add (U8.load (USize.add src i2)) addend
       let v3 := U8.add (U8.load (USize.add src i3)) addend
       let _s0 := U8.store (USize.add dst i0) v0
       let _s1 := U8.store (USize.add dst i1) v1
       let _s2 := U8.store (USize.add dst i2) v2
       let _s3 := U8.store (USize.add dst i3) v3
       mapAddU8Chunk4Go dst src (USize.add i USize.four) n addend))
    U32.zero

/-- Convenience: 4-wide chunked map over full `[0, n)`. -/
@[never_extract]
public unsafe def mapAddU8Chunk4 (dst : USize) (src : USize) (n : USize) (addend : U8) : U32 :=
  mapAddU8Chunk4Go dst src USize.zero n addend

/-- Fold: XOR of all bytes in `[addr, addr+n)` (SIMD-friendly reduction shape). -/
public unsafe def foldXorU8Go (addr : USize) (i : USize) (n : USize) (acc : U8) : U8 :=
  bifU8 (USize.blt i n)
    (foldXorU8Go addr (USize.add i USize.one) n (U8.xor acc (U8.load (USize.add addr i))))
    acc

/-- Convenience: fold full range from zero accumulator. -/
public unsafe def foldXorU8 (addr : USize) (n : USize) : U8 :=
  foldXorU8Go addr USize.zero n U8.zero

/-- Combined map-add + running XOR (single loop; effectful stores kept).

Returns the XOR fold of the **written** bytes as `U32` (low byte). -/
@[never_extract]
public unsafe def mapAddFoldXorGo
    (dst : USize) (src : USize) (i : USize) (n : USize) (addend : U8) (acc : U8) : U8 :=
  bifU8 (USize.blt i n)
    (let v := U8.add (U8.load (USize.add src i)) addend
     let _s := U8.store (USize.add dst i) v
     mapAddFoldXorGo dst src (USize.add i USize.one) n addend (U8.xor acc v))
    acc

/-- Map + fold pipeline smoke: write `src[i]+addend` to `dst[i]`, XOR-fold written bytes. -/
@[never_extract]
public unsafe def mapAddThenFoldXor (dst : USize) (src : USize) (n : USize) (addend : U8) : U32 :=
  U32.ofU8 (mapAddFoldXorGo dst src USize.zero n addend U8.zero)

/-- Chunked map-add then scalar XOR-fold of written bytes.

Same dual-param ABI as `mapAddThenFoldXor`; body uses 4-wide sequential map for the
write phase. Still residual-free; not hardware SIMD. -/
@[never_extract]
public unsafe def mapAddThenFoldXorChunk4
    (dst : USize) (src : USize) (n : USize) (addend : U8) : U32 :=
  let _m := mapAddU8Chunk4 dst src n addend
  U32.ofU8 (foldXorU8 dst n)

end Systems.Parallelism.Simd
