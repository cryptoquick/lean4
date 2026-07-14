/-
Copyright (c) 2026 Lean FRO, LLC. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Hunter Beast
-/
module
prelude
public import Systems.Scalars

/-!
# Systems.Bytes (Systems Lean)

Byte-oriented memory helpers for freestanding embeds (R7 first wave).

No `Init` import — closed freestanding fragment over `Systems.Scalars` only.
Dual scalar params (`addr`/`len`/`i`) — no multi-field freestanding product values and no
managed `List`/`Array`/`ByteArray`.

Public non-inline helpers (`memCopyGo`, `memFillGo`, …) are freestanding emit roots for
cross-module calls. Use from extract modules via import; consumers link the freestanding
bundle archive.
-/

namespace Systems.Bytes

open Systems.Scalars

/-- Store one byte at address `addr` (`*((uint8_t*)addr) = v`). -/
@[never_extract, extern c inline "(*((uint8_t*)(#1)) = (uint8_t)(#2), (uint32_t)0)"]
public axiom U8.store : USize → U8 → U32

/-- Byte XOR. -/
@[extern c inline "((uint8_t)((uint8_t)(#1) ^ (uint8_t)(#2)))"]
public axiom U8.xor : U8 → U8 → U8

/-- Zero byte constant. -/
@[extern c inline "0"] public axiom U8.zero : U8

/-- Branch on freestanding `Bool` for `U8` results (specialized; no polymorphic `lcAny`). -/
@[macro_inline, expose] public def bifU8 (c : Bool) (t e : U8) : U8 :=
  Bool.casesOn (motive := fun _ => U8) c e t

/-- Copy `n` bytes from `src` to `dst` (self-TCO loop; `i` is the running index).

`unsafe` — freestanding has no WF; terminates when `i` reaches `n`. Overlapping ranges are
not defined (like `memcpy`, not `memmove`). -/
public unsafe def memCopyGo (dst : USize) (src : USize) (i : USize) (n : USize) : U32 :=
  bifU32 (USize.blt i n)
    (let _s := U8.store (USize.add dst i) (U8.load (USize.add src i));
     memCopyGo dst src (USize.add i USize.one) n)
    U32.zero

/-- Fill `n` bytes at `dst` with byte value `v` (self-TCO; index `i`). -/
public unsafe def memFillGo (dst : USize) (i : USize) (n : USize) (v : U8) : U32 :=
  bifU32 (USize.blt i n)
    (let _s := U8.store (USize.add dst i) v;
     memFillGo dst (USize.add i USize.one) n v)
    U32.zero

/-- Find first index of `needle` in `[addr, addr+n)`, or `USize.neg1` if not found. -/
public unsafe def memFindU8Go (addr : USize) (i : USize) (n : USize) (needle : U8) : USize :=
  bifUSize (USize.blt i n)
    (bifUSize (U8.beq (U8.load (USize.add addr i)) needle)
      i
      (memFindU8Go addr (USize.add i USize.one) n needle))
    USize.neg1

/-- XOR-fold `n` bytes starting at `addr` into accumulator `acc` (simple checksum). -/
public unsafe def memXorFoldGo (addr : USize) (i : USize) (n : USize) (acc : U8) : U8 :=
  bifU8 (USize.blt i n)
    (memXorFoldGo addr (USize.add i USize.one) n
      (U8.xor acc (U8.load (USize.add addr i))))
    acc

/-- Convenience: copy full range `[0, n)`. -/
public unsafe def memCopy (dst : USize) (src : USize) (n : USize) : U32 :=
  memCopyGo dst src USize.zero n

/-- Convenience: fill full range `[0, n)`. -/
public unsafe def memFill (dst : USize) (n : USize) (v : U8) : U32 :=
  memFillGo dst USize.zero n v

/-- Convenience: find in full range `[0, n)`. -/
public unsafe def memFindU8 (addr : USize) (n : USize) (needle : U8) : USize :=
  memFindU8Go addr USize.zero n needle

/-- Convenience: XOR-fold full range starting from 0. -/
public unsafe def memXorFold (addr : USize) (n : USize) : U8 :=
  memXorFoldGo addr USize.zero n U8.zero

end Systems.Bytes
