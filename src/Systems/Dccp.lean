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
# Systems.Dccp (Systems Lean)

DCCP-**shaped** generic header field parse over dual caller `addr`/`len` byte views —
not a full DCCP stack, not sockets, not option product, not checksum verify/compute.

Wire layout (RFC 4340-shaped; minimum **12** generic-header bytes when `X=0`, network
byte order; `X=1` extends to 16 with a longer sequence number — not decoded here):

| Offset | Size | Field |
|--------|------|-------|
| 0 | 2 | source port (BE) |
| 2 | 2 | destination port (BE) |
| 4 | 1 | data offset (32-bit words) |
| 5 | 1 | CCVal (high 4) \| CsCov (low 4) |
| 6 | 2 | checksum (BE; layout only — not verified) |
| 8 | 1 | Res (3) \| Type (4) \| X (1) |
| 9–11 | 3 | sequence high / short-seq body (layout only) |

Ops:

* **validate** / **parse** — `0` if `n ≥ 12`, else `1` (too short); when long enough,
  probes first byte and folds it with `land 0` so dual-param `addr` is live
* **srcPort** — big-endian `U16` at offset 0 as `U32` (0 if short)
* **dstPort** — big-endian `U16` at offset 2 as `U32` (0 if short)
* **pktType** — packet type (bits 4–1 of byte 8) as `U32` (0 if short)
* **ccVal** — CCVal (high 4 bits of byte 5) as `U32` (0 if short)
* **xBit** — X bit (bit 0 of byte 8) as `U32` (0 if short)

Honesty:

* **Generic header offsets only** — no DCCP options, no feature negotiation, no
  connection state machine, no socket API, no checksum algorithm / verification, no
  48-bit sequence product when `X=1` (min-12 fence only).
* **validate status is length-class only** (`ok`/`err`); the first-byte probe never
  changes the status value (`land` with zero) but keeps `addr` on the EmitC result path
  when `n ≥ 12`.
* **loadAt dual-param honesty:** every load index is under `i < n` after the min-12
  fence. `loadAt` is **not** bounds-parameterized.

## Intentional TCB (Dccp-local)

Header size, field offsets, big-endian shift amounts, and type/CCVal masks/shifts are
freestanding `@[extern]` axioms kept **here**. Name-pinned on ComplianceCorpus
(`path name=Ident`). Byte loads reuse `Scalars`/`Bytes`; shift/or/and reuse `Numerics`.
-/

namespace Systems.Dccp

open Systems.Scalars
open Systems.Bytes
open Systems.Status
open Systems.Numerics

/-- Minimum DCCP generic header length (12). -/
@[extern c inline "((size_t)12)"] public axiom headerLen : USize
/-- Shift amount 8 for big-endian byte packing. -/
@[extern c inline "((uint32_t)8)"] public axiom eightU32 : U32
/-- Shift amount 1 for type field (Type sits above X). -/
@[extern c inline "((uint32_t)1)"] public axiom oneU32 : U32
/-- Shift amount 4 for CCVal high nibble. -/
@[extern c inline "((uint32_t)4)"] public axiom fourU32 : U32
/-- Packet-type mask (`0x0F` = 15). -/
@[extern c inline "((uint32_t)15)"] public axiom maskType : U32
/-- X-bit / low-nibble mask (`0x01` / used with land for X). -/
@[extern c inline "((uint32_t)1)"] public axiom maskX : U32
/-- CCVal high-nibble mask after shift (`0x0F`). -/
@[extern c inline "((uint32_t)15)"] public axiom maskCcVal : U32
/-- Offset of source-port high byte (0). -/
@[extern c inline "((size_t)0)"] public axiom offSrc : USize
/-- Offset of source-port low byte (1). -/
@[extern c inline "((size_t)1)"] public axiom offSrcLo : USize
/-- Offset of dest-port high byte (2). -/
@[extern c inline "((size_t)2)"] public axiom offDst : USize
/-- Offset of dest-port low byte (3). -/
@[extern c inline "((size_t)3)"] public axiom offDstLo : USize
/-- Offset of CCVal|CsCov byte (5). -/
@[extern c inline "((size_t)5)"] public axiom offCc : USize
/-- Offset of Res|Type|X byte (8). -/
@[extern c inline "((size_t)8)"] public axiom offTypeX : USize

/-- Load byte at index as `U32`. Caller ensures `i < n`. -/
public unsafe def loadAt (addr : USize) (i : USize) : U32 :=
  U32.ofU8 (U8.load (USize.add addr i))

/-- Big-endian `U16` at `hiOff`/`loOff` as `U32`. Caller ensures both indices in range. -/
public unsafe def loadU16BE (addr : USize) (hiOff : USize) (loOff : USize) : U32 :=
  U32.lor (U32.shiftLeft (loadAt addr hiOff) eightU32) (loadAt addr loOff)

/-- `0` if `n ≥ 12`, else `1`.

When `n ≥ 12`, loads first byte and folds it with `U32.land _ U32.zero` so dual-param
`addr` stays on the EmitC result path. Status remains length-class only (probe never
contributes a nonzero bit). Does not inspect options past the min-length fence. -/
public unsafe def validate (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) err
    (U32.land (loadAt addr USize.zero) U32.zero)

/-- Alias of `validate`. -/
public unsafe def parse (addr : USize) (n : USize) : U32 :=
  validate addr n

/-- Source port (bytes 0–1 BE), or `0` if `n < 12`. -/
public unsafe def srcPort (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (loadU16BE addr offSrc offSrcLo)

/-- Destination port (bytes 2–3 BE), or `0` if `n < 12`. -/
public unsafe def dstPort (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (loadU16BE addr offDst offDstLo)

/-- Packet type (bits 4–1 of byte 8), or `0` if `n < 12`. -/
public unsafe def pktType (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (U32.land (U32.shiftRight (loadAt addr offTypeX) oneU32) maskType)

/-- CCVal (high 4 bits of byte 5), or `0` if `n < 12`. -/
public unsafe def ccVal (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (U32.land (U32.shiftRight (loadAt addr offCc) fourU32) maskCcVal)

/-- X bit (bit 0 of byte 8), or `0` if `n < 12`. -/
public unsafe def xBit (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (U32.land (loadAt addr offTypeX) maskX)

end Systems.Dccp
