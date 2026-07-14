/-
Copyright (c) 2026 Hunter Beast. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Hunter Beast
-/
module
prelude
public import Systems.Scalars
public import Systems.Bytes
public import Systems.Status
public import Systems.Numerics

/-!
# Systems.Rtcp (Systems Lean)

RTCP-**shaped** min-4 common header parse over dual caller `addr`/`len` byte views —
not a full RTCP stack, not SR/RR/SDES/BYE compound product, not RTP media.

Wire layout (RFC 3550-shaped; minimum **4** header bytes, network byte order):

| Offset | Size | Field |
|--------|------|-------|
| 0 | 1 | V(2) \| P(1) \| RC(5) |
| 1 | 1 | PT (packet type) |
| 2–3 | 2 | length (BE; 32-bit words minus one, shaped) |

Ops:

* **validate** / **parse** — `0` if `n ≥ 4`, else `1` (too short); when long enough,
  probes first byte and folds it with `land 0` so dual-param `addr` is live
* **version** — high 2 bits of byte0 (`0..3`), or `0` if short
* **padding** — bit 5 of byte0 (`1` if set), or `0` if short
* **rc** — low 5 bits of byte0 (`0..31` reception-report count shaped), or `0` if short
* **pt** — byte1 as `U32`, or `0` if short
* **length** — big-endian `U16` at offsets 2–3 as `U32`, or `0` if short

Honesty:

* **Min header offsets only** — no compound packet walk, no SR/RR block product, no
  SDES items, no BYE reason, no XR, not an RTP/RTCP session.
* **validate status is length-class only** (`ok`/`err`); the first-byte probe never
  changes the status value (`land` with zero) but keeps `addr` on the EmitC result path
  when `n ≥ 4`. Version/PT legality is not enforced.
* **loadAt dual-param honesty:** every load index is under `i < n` after the min-4
  fence. `loadAt` is **not** bounds-parameterized.
* **Distinct exports** (`lean_fs_rtcp_*`) from CoAP/WebSocket/GRE peers.

## Intentional TCB (Rtcp-local)

Header length, masks/shifts, field offsets, and BE shift amount are freestanding
`@[extern]` axioms kept **here**. Name-pinned on ComplianceCorpus (`path name=Ident`).
Byte loads reuse `Scalars`/`Bytes`; shift/or/and reuse `Numerics`.
-/

namespace Systems.Rtcp

open Systems.Scalars
open Systems.Bytes
open Systems.Status
open Systems.Numerics

/-- RTCP common header minimum length (4). -/
@[extern c inline "((size_t)4)"] public axiom headerLen : USize
/-- Shift amount 6 for version high 2 bits. -/
@[extern c inline "((uint32_t)6)"] public axiom sixU32 : U32
/-- Shift amount 8 for big-endian `U16` high byte. -/
@[extern c inline "((uint32_t)8)"] public axiom eightU32 : U32
/-- Version 2-bit mask (`0x03` = 3). -/
@[extern c inline "((uint32_t)3)"] public axiom mask2 : U32
/-- Padding bit mask (`0x20` = 32). -/
@[extern c inline "((uint32_t)32)"] public axiom maskPad : U32
/-- Reception-report count mask (`0x1F` = 31). -/
@[extern c inline "((uint32_t)31)"] public axiom maskRc : U32
/-- Offset of PT byte (1). -/
@[extern c inline "((size_t)1)"] public axiom offPt : USize
/-- Offset of length high byte (2). -/
@[extern c inline "((size_t)2)"] public axiom offLen : USize
/-- Offset of length low byte (3). -/
@[extern c inline "((size_t)3)"] public axiom offLenLo : USize

/-- Load byte at index as `U32`. Caller ensures `i < n`. -/
public unsafe def loadAt (addr : USize) (i : USize) : U32 :=
  U32.ofU8 (U8.load (USize.add addr i))

/-- Big-endian `U16` at `hiOff`/`loOff` as `U32`. Caller ensures both indices in range. -/
public unsafe def loadU16BE (addr : USize) (hiOff : USize) (loOff : USize) : U32 :=
  U32.lor (U32.shiftLeft (loadAt addr hiOff) eightU32) (loadAt addr loOff)

/-- `0` if `n ≥ 4`, else `1`.

When `n ≥ 4`, loads first byte and folds it with `U32.land _ U32.zero` so dual-param
`addr` stays on the EmitC result path. Status remains length-class only (probe never
contributes a nonzero bit). Does not inspect body past the min fence. -/
public unsafe def validate (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) err
    (U32.land (loadAt addr USize.zero) U32.zero)

/-- Alias of `validate`. -/
public unsafe def parse (addr : USize) (n : USize) : U32 :=
  validate addr n

/-- Version (high 2 bits of byte0), or `0` if `n < 4`. -/
public unsafe def version (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (U32.land (U32.shiftRight (loadAt addr USize.zero) sixU32) mask2)

/-- Padding bit of byte0 (`1` if set), or `0` if `n < 4`. -/
public unsafe def padding (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (bifU32 (U32.beq (U32.land (loadAt addr USize.zero) maskPad) U32.zero)
      U32.zero U32.one)

/-- Reception-report count (low 5 bits of byte0), or `0` if `n < 4`. -/
public unsafe def rc (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (U32.land (loadAt addr USize.zero) maskRc)

/-- Packet type (byte1), or `0` if `n < 4`. -/
public unsafe def pt (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (loadAt addr offPt)

/-- Length (bytes 2–3 BE) as `U32`, or `0` if `n < 4`.

RFC 3550-shaped length in 32-bit words minus one; not payload-byte product. -/
public unsafe def length (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (loadU16BE addr offLen offLenLo)

end Systems.Rtcp
