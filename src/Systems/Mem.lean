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
# Systems.Mem (Systems Lean)

Product-critical memory helpers beyond `Bytes`: bounded compare, move-style copy
(overlap-safe when `dst ≤ src` or fully after), and zeroing.

Dual `addr`/`len` only — no managed arrays, no `Init`.

## Null-safe heap discipline

Standalone heap ownership lives in `Systems.Sys` (`MallocBuf` + `bufAlloc`/`bufFree`).
Helpers here stay dual-param so they compose with either arena views or malloc owners:

* Treat address `0` as null (OOM / uninit).
* **Never** load/store through a null `addr` when `len > 0`.
* `free(NULL)` is a no-op in C; product paths must still **consume** affine owners
  (`bufFree` / `chanClose`) so free stays on the wire (`@[never_extract]` + use result).
-/

namespace Systems.Mem

open Systems.Scalars
open Systems.Bytes
open Systems.Status

/-- Null pointer test (`addr == 0`) as freestanding `U8` (1 = null). -/
@[extern c inline "(uint8_t)((size_t)(#1) == (size_t)0)"]
public axiom addrIsNullU8 (addr : USize) : U8

@[inline] public def addrIsNull (addr : USize) : Bool :=
  Bool.ofU8 (addrIsNullU8 addr)

/-- Gate: `true` if a non-zero length would touch a null address. -/
public unsafe def wouldNullTouch (addr : USize) (n : USize) : Bool :=
  bifBool (USize.beq n USize.zero) Bool.false (addrIsNull addr)

/-- Equality-oriented compare (not libc three-way `memcmp`).

Returns `0` if the ranges are equal, `1` if any byte differs (U32 status style).
Does **not** return negative/positive ordering. -/
public unsafe def memCmpGo (a : USize) (b : USize) (i : USize) (n : USize) : U32 :=
  bifU32 (USize.blt i n)
    (bifU32 (U8.beq (U8.load (USize.add a i)) (U8.load (USize.add b i)))
      (memCmpGo a b (USize.add i USize.one) n)
      U32.one)
    U32.zero

/-- Full-range compare: `0` equal, `1` differ.

Null-safe: if either side is null with `n > 0`, returns `1` (differ / error-class) without load. -/
public unsafe def memCmp (a : USize) (b : USize) (n : USize) : U32 :=
  bifU32 (wouldNullTouch a n) U32.one
    (bifU32 (wouldNullTouch b n) U32.one (memCmpGo a b USize.zero n))

/-- Zero `n` bytes at `dst`. Null with `n > 0` → `1`; else fill and `0`. -/
public unsafe def memZero (dst : USize) (n : USize) : U32 :=
  bifU32 (wouldNullTouch dst n) U32.one (memFill dst n U8.zero)

/-- Copy `n` bytes when ranges do not require reverse order (`memcpy` shape).

Overlapping ranges are **not** defined — prefer `memMove` when unsure.
Null-safe: null `dst`/`src` with `n > 0` → `1`. -/
public unsafe def memCpy (dst : USize) (src : USize) (n : USize) : U32 :=
  bifU32 (wouldNullTouch dst n) U32.one
    (bifU32 (wouldNullTouch src n) U32.one (memCopy dst src n))

/-- Overlap-safe move: if `dst > src`, copy high-to-low; else low-to-high. -/
public unsafe def memMoveGoFwd (dst : USize) (src : USize) (i : USize) (n : USize) : U32 :=
  bifU32 (USize.blt i n)
    (let _s := U8.store (USize.add dst i) (U8.load (USize.add src i))
     memMoveGoFwd dst src (USize.add i USize.one) n)
    U32.zero

/-- Reverse-direction copy for `dst > src` overlap. `i` counts remaining. -/
public unsafe def memMoveGoBwd (dst : USize) (src : USize) (i : USize) : U32 :=
  bifU32 (USize.beq i USize.zero) U32.zero
    (let j := USize.sub i USize.one
     let _s := U8.store (USize.add dst j) (U8.load (USize.add src j))
     memMoveGoBwd dst src j)

/-- `memmove`-style: choose direction from unsigned address order.

Null-safe: null endpoint with `n > 0` → `1`. -/
public unsafe def memMove (dst : USize) (src : USize) (n : USize) : U32 :=
  bifU32 (wouldNullTouch dst n) U32.one
    (bifU32 (wouldNullTouch src n) U32.one
      (bifU32 (USize.blt src dst)
        (memMoveGoBwd dst src n)
        (memMoveGoFwd dst src USize.zero n)))

/-- Status-style: compare then return `ok`/`err` (`0`/`1`). -/
public unsafe def memEqStatus (a : USize) (b : USize) (n : USize) : U32 :=
  normalize (memCmp a b n)

end Systems.Mem
