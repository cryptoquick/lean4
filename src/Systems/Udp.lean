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
# Systems.Udp (Systems Lean)

UDP-**shaped** header field parse over dual caller `addr`/`len` byte views — not a
full UDP stack, not sockets, not checksum verify/compute, not payload demux.

Wire layout (RFC 768-shaped; minimum **8** header bytes, network byte order):

| Offset | Size | Field |
|--------|------|-------|
| 0 | 2 | source port (BE) |
| 2 | 2 | destination port (BE) |
| 4 | 2 | length (BE; header + data) |
| 6 | 2 | checksum (BE; layout only) |

Ops:

* **validate** / **parse** — `0` if `n ≥ 8`, else `1` (too short); when long enough,
  probes first byte and folds it with `land 0` so dual-param `addr` is live
* **srcPort** — big-endian `U16` at offset 0 as `U32` (0 if short)
* **dstPort** — big-endian `U16` at offset 2 as `U32` (0 if short)
* **length** — big-endian `U16` at offset 4 as `U32` (0 if short)
* **checksum** — big-endian `U16` at offset 6 as `U32` (0 if short)

Honesty:

* **Header offsets only** — no checksum algorithm / verification, no socket API,
  no demultiplex by port, no IPv4/IPv6 pseudo-header, no fragmentation.
* **validate status is length-class only** (`ok`/`err`); the first-byte probe never
  changes the status value (`land` with zero) but keeps `addr` on the EmitC result path
  when `n ≥ 8`.
* **loadAt dual-param honesty:** every load index is under `i < n` after the min-8
  fence. `loadAt` is **not** bounds-parameterized.

## Intentional TCB (Udp-local)

Header size, field offsets, and big-endian shift amount are freestanding
`@[extern]` axioms kept **here**. Name-pinned on ComplianceCorpus (`path name=Ident`).
Byte loads reuse `Scalars`/`Bytes`; shift/or reuse `Numerics`.
-/

namespace Systems.Udp

open Systems.Scalars
open Systems.Bytes
open Systems.Status
open Systems.Numerics

/-- Minimum UDP header length (8). -/
@[extern c inline "((size_t)8)"] public axiom headerLen : USize
/-- Shift amount 8 for big-endian `U16` high byte. -/
@[extern c inline "((uint32_t)8)"] public axiom eightU32 : U32
/-- Offset of source-port high byte (0). -/
@[extern c inline "((size_t)0)"] public axiom offSrc : USize
/-- Offset of source-port low byte (1). -/
@[extern c inline "((size_t)1)"] public axiom offSrcLo : USize
/-- Offset of dest-port high byte (2). -/
@[extern c inline "((size_t)2)"] public axiom offDst : USize
/-- Offset of dest-port low byte (3). -/
@[extern c inline "((size_t)3)"] public axiom offDstLo : USize
/-- Offset of length high byte (4). -/
@[extern c inline "((size_t)4)"] public axiom offLen : USize
/-- Offset of length low byte (5). -/
@[extern c inline "((size_t)5)"] public axiom offLenLo : USize
/-- Offset of checksum high byte (6). -/
@[extern c inline "((size_t)6)"] public axiom offCsum : USize
/-- Offset of checksum low byte (7). -/
@[extern c inline "((size_t)7)"] public axiom offCsumLo : USize

/-- Load byte at index as `U32`. Caller ensures `i < n`. -/
public unsafe def loadAt (addr : USize) (i : USize) : U32 :=
  U32.ofU8 (U8.load (USize.add addr i))

/-- Big-endian `U16` at `hiOff`/`loOff` as `U32`. Caller ensures both indices in range. -/
public unsafe def loadU16BE (addr : USize) (hiOff : USize) (loOff : USize) : U32 :=
  U32.lor (U32.shiftLeft (loadAt addr hiOff) eightU32) (loadAt addr loOff)

/-- `0` if `n ≥ 8`, else `1`.

When `n ≥ 8`, loads first byte and folds it with `U32.land _ U32.zero` so dual-param
`addr` stays on the EmitC result path. Status remains length-class only (probe never
contributes a nonzero bit). Does not inspect payload past the min-length fence. -/
public unsafe def validate (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) err
    (U32.land (loadAt addr USize.zero) U32.zero)

/-- Alias of `validate`. -/
public unsafe def parse (addr : USize) (n : USize) : U32 :=
  validate addr n

/-- Source port (bytes 0–1 BE), or `0` if `n < 8`. -/
public unsafe def srcPort (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (loadU16BE addr offSrc offSrcLo)

/-- Destination port (bytes 2–3 BE), or `0` if `n < 8`. -/
public unsafe def dstPort (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (loadU16BE addr offDst offDstLo)

/-- UDP length field (bytes 4–5 BE), or `0` if `n < 8`. -/
public unsafe def length (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (loadU16BE addr offLen offLenLo)

/-- Checksum field (bytes 6–7 BE), or `0` if `n < 8`. Layout only — not verified. -/
public unsafe def checksum (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (loadU16BE addr offCsum offCsumLo)

end Systems.Udp
