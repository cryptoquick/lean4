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
public import Systems.Numerics

/-!
# Systems.Ip (Systems Lean)

IPv4-**shaped** header field parse over dual caller `addr`/`len` byte views — not a
full IP stack, not IPv6 product, not option/fragment reassembly, not checksum verify.

Wire layout (RFC 791-shaped; minimum **20** header bytes, network byte order):

| Offset | Size | Field |
|--------|------|-------|
| 0 | 1 | version (high nibble) + IHL (low nibble) |
| 1 | 1 | DSCP/ECN (TOS; layout only) |
| 2 | 2 | total length (BE) |
| 4 | 2 | identification (not exposed) |
| 6 | 2 | flags/fragment (not exposed) |
| 8 | 1 | TTL (not exposed) |
| 9 | 1 | protocol |
| 10 | 2 | header checksum (not exposed) |
| 12 | 4 | source address |
| 16 | 4 | destination address |

Ops:

* **validate** / **parse** — `0` if `n ≥ 20`, else `1` (too short); when long enough,
  probes first byte and folds it with `land 0` so dual-param `addr` is live
* **version** — high nibble of byte 0 (`0..15`), or `0` if short
* **ihl** — low nibble of byte 0 (header length in 32-bit words), or `0` if short
* **totalLength** — big-endian `U16` at offset 2 as `U32` (0 if short)
* **protocol** — byte 9 as `U32` (0 if short)
* **srcOff** / **dstOff** — fixed layout offsets (12 / 16)

Honesty:

* **Header offsets only** — no option parsing beyond IHL exposure, no fragment
  reassembly, no routing, no IPv6, no checksum algorithm / verification, no sockets.
* IHL is reported raw; callers that need `IHL * 4` bytes of header do that themselves.
* **validate status is length-class only** (`ok`/`err`); the first-byte probe never
  changes the status value (`land` with zero) but keeps `addr` on the EmitC result path
  when `n ≥ 20`.
* **loadAt dual-param honesty:** every load index is under `i < n` after the min-20
  fence. `loadAt` is **not** bounds-parameterized.

## Intentional TCB (Ip-local)

Header size, field offsets, nibble masks/shifts, and big-endian shift amount are
freestanding `@[extern]` axioms kept **here**. Name-pinned on ComplianceCorpus
(`path name=Ident`). Byte loads reuse `Scalars`/`Bytes`; shift/or/and reuse `Numerics`.
-/

namespace Systems.Ip

open Systems.Scalars
open Systems.Bytes
open Systems.Status
open Systems.Numerics

/-- Minimum IPv4 header length without options (20). -/
@[extern c inline "((size_t)20)"] public axiom headerLen : USize
/-- Shift amount 8 for big-endian `U16` high byte. -/
@[extern c inline "((uint32_t)8)"] public axiom eightU32 : U32
/-- Shift amount 4 for version high nibble. -/
@[extern c inline "((uint32_t)4)"] public axiom fourU32 : U32
/-- High-nibble mask (`0xF0` = 240). -/
@[extern c inline "((uint32_t)240)"] public axiom maskVerHi : U32
/-- Low-nibble mask (`0x0F` = 15). -/
@[extern c inline "((uint32_t)15)"] public axiom maskIhl : U32
/-- Offset of total-length high byte (2). -/
@[extern c inline "((size_t)2)"] public axiom offTotal : USize
/-- Offset of total-length low byte (3). -/
@[extern c inline "((size_t)3)"] public axiom offTotalLo : USize
/-- Offset of protocol (9). -/
@[extern c inline "((size_t)9)"] public axiom offProto : USize
/-- Offset of source address (12). -/
@[extern c inline "((size_t)12)"] public axiom offSrc : USize
/-- Offset of destination address (16). -/
@[extern c inline "((size_t)16)"] public axiom offDst : USize

/-- Load byte at index as `U32`. Caller ensures `i < n`. -/
public unsafe def loadAt (addr : USize) (i : USize) : U32 :=
  U32.ofU8 (U8.load (USize.add addr i))

/-- Big-endian `U16` at `hiOff`/`loOff` as `U32`. Caller ensures both indices in range. -/
public unsafe def loadU16BE (addr : USize) (hiOff : USize) (loOff : USize) : U32 :=
  U32.lor (U32.shiftLeft (loadAt addr hiOff) eightU32) (loadAt addr loOff)

/-- `0` if `n ≥ 20`, else `1`.

When `n ≥ 20`, loads first byte and folds it with `U32.land _ U32.zero` so dual-param
`addr` stays on the EmitC result path. Status remains length-class only (probe never
contributes a nonzero bit). Does not inspect payload past the min-length fence. -/
public unsafe def validate (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) err
    (U32.land (loadAt addr USize.zero) U32.zero)

/-- Alias of `validate`. -/
public unsafe def parse (addr : USize) (n : USize) : U32 :=
  validate addr n

/-- IP version (high nibble of byte 0), or `0` if `n < 20`. -/
public unsafe def version (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (U32.shiftRight (U32.land (loadAt addr USize.zero) maskVerHi) fourU32)

/-- Internet Header Length in 32-bit words (low nibble of byte 0), or `0` if short. -/
public unsafe def ihl (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (U32.land (loadAt addr USize.zero) maskIhl)

/-- Total length (bytes 2–3 BE), or `0` if `n < 20`. -/
public unsafe def totalLength (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (loadU16BE addr offTotal offTotalLo)

/-- Protocol (byte 9), or `0` if `n < 20`. -/
public unsafe def protocol (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero (loadAt addr offProto)

/-- Wire offset of source address (always 12; layout helper).

`_n` is unused (keeps a function ABI under EmitC; not dual-param live data). -/
@[inline] public def srcOff (_n : USize) : USize := offSrc

/-- Wire offset of destination address (always 16; layout helper). -/
@[inline] public def dstOff (_n : USize) : USize := offDst

end Systems.Ip
