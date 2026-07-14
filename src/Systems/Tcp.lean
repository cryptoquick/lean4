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
# Systems.Tcp (Systems Lean)

TCP-**shaped** header field parse over dual caller `addr`/`len` byte views — not a
full TCP stack, not sockets, not options/SACK product, not checksum verify/compute.

Wire layout (RFC 793-shaped; minimum **20** header bytes, network byte order):

| Offset | Size | Field |
|--------|------|-------|
| 0 | 2 | source port (BE) |
| 2 | 2 | destination port (BE) |
| 4 | 4 | sequence number (BE) |
| 8 | 4 | acknowledgment number (BE) |
| 12 | 1 | data offset (high nibble; header length in 32-bit words) |
| 13 | 1 | flags (FIN/SYN/RST/PSH/ACK/URG layout bits) |
| 14 | 2 | window (BE) |
| 16 | 2 | checksum (not exposed; layout only) |
| 18 | 2 | urgent pointer (not exposed) |

Ops:

* **validate** / **parse** — `0` if `n ≥ 20`, else `1` (too short); when long enough,
  probes first byte and folds it with `land 0` so dual-param `addr` is live
* **srcPort** — big-endian `U16` at offset 0 as `U32` (0 if short)
* **dstPort** — big-endian `U16` at offset 2 as `U32` (0 if short)
* **seq** — big-endian `U32` at offset 4 (0 if short)
* **ack** — big-endian `U32` at offset 8 (0 if short)
* **dataOff** — high nibble of byte 12 (`0..15`), or `0` if short
* **flags** — byte 13 as `U32` (0 if short)
* **window** — big-endian `U16` at offset 14 as `U32` (0 if short)

Honesty:

* **Header offsets only** — no TCP options past data-offset, no state machine, no
  reassembly, no socket API, no checksum algorithm / verification, no pseudo-header.
* Data offset is reported raw; callers that need `dataOff * 4` bytes of header do that
  themselves.
* **validate status is length-class only** (`ok`/`err`); the first-byte probe never
  changes the status value (`land` with zero) but keeps `addr` on the EmitC result path
  when `n ≥ 20`.
* **loadAt dual-param honesty:** every load index is under `i < n` after the min-20
  fence. `loadAt` is **not** bounds-parameterized.

## Intentional TCB (Tcp-local)

Header size, field offsets, nibble masks/shifts, and big-endian shift amounts are
freestanding `@[extern]` axioms kept **here**. Name-pinned on ComplianceCorpus
(`path name=Ident`). Byte loads reuse `Scalars`/`Bytes`; shift/or/and reuse `Numerics`.
-/

namespace Systems.Tcp

open Systems.Scalars
open Systems.Bytes
open Systems.Status
open Systems.Numerics

/-- Minimum TCP header length without options (20). -/
@[extern c inline "((size_t)20)"] public axiom headerLen : USize
/-- Shift amount 8 for big-endian byte packing. -/
@[extern c inline "((uint32_t)8)"] public axiom eightU32 : U32
/-- Shift amount 16 for big-endian `U32` mid bytes. -/
@[extern c inline "((uint32_t)16)"] public axiom sixteenU32 : U32
/-- Shift amount 24 for big-endian `U32` high byte. -/
@[extern c inline "((uint32_t)24)"] public axiom twentyFourU32 : U32
/-- Shift amount 4 for data-offset high nibble. -/
@[extern c inline "((uint32_t)4)"] public axiom fourU32 : U32
/-- High-nibble mask (`0xF0` = 240). -/
@[extern c inline "((uint32_t)240)"] public axiom maskDataOffHi : U32
/-- Offset of source-port high byte (0). -/
@[extern c inline "((size_t)0)"] public axiom offSrc : USize
/-- Offset of source-port low byte (1). -/
@[extern c inline "((size_t)1)"] public axiom offSrcLo : USize
/-- Offset of dest-port high byte (2). -/
@[extern c inline "((size_t)2)"] public axiom offDst : USize
/-- Offset of dest-port low byte (3). -/
@[extern c inline "((size_t)3)"] public axiom offDstLo : USize
/-- Offset of sequence number high byte (4). -/
@[extern c inline "((size_t)4)"] public axiom offSeq : USize
/-- Offset of sequence byte 1 (5). -/
@[extern c inline "((size_t)5)"] public axiom offSeq1 : USize
/-- Offset of sequence byte 2 (6). -/
@[extern c inline "((size_t)6)"] public axiom offSeq2 : USize
/-- Offset of sequence low byte (7). -/
@[extern c inline "((size_t)7)"] public axiom offSeq3 : USize
/-- Offset of ack number high byte (8). -/
@[extern c inline "((size_t)8)"] public axiom offAck : USize
/-- Offset of ack byte 1 (9). -/
@[extern c inline "((size_t)9)"] public axiom offAck1 : USize
/-- Offset of ack byte 2 (10). -/
@[extern c inline "((size_t)10)"] public axiom offAck2 : USize
/-- Offset of ack low byte (11). -/
@[extern c inline "((size_t)11)"] public axiom offAck3 : USize
/-- Offset of data-offset / reserved byte (12). -/
@[extern c inline "((size_t)12)"] public axiom offDataOff : USize
/-- Offset of flags byte (13). -/
@[extern c inline "((size_t)13)"] public axiom offFlags : USize
/-- Offset of window high byte (14). -/
@[extern c inline "((size_t)14)"] public axiom offWin : USize
/-- Offset of window low byte (15). -/
@[extern c inline "((size_t)15)"] public axiom offWinLo : USize

/-- Load byte at index as `U32`. Caller ensures `i < n`. -/
public unsafe def loadAt (addr : USize) (i : USize) : U32 :=
  U32.ofU8 (U8.load (USize.add addr i))

/-- Big-endian `U16` at `hiOff`/`loOff` as `U32`. Caller ensures both indices in range. -/
public unsafe def loadU16BE (addr : USize) (hiOff : USize) (loOff : USize) : U32 :=
  U32.lor (U32.shiftLeft (loadAt addr hiOff) eightU32) (loadAt addr loOff)

/-- Big-endian `U32` at four consecutive offsets. Caller ensures all indices in range. -/
public unsafe def loadU32BE (addr : USize) (b0 : USize) (b1 : USize) (b2 : USize)
    (b3 : USize) : U32 :=
  U32.lor (U32.lor (U32.shiftLeft (loadAt addr b0) twentyFourU32)
      (U32.shiftLeft (loadAt addr b1) sixteenU32))
    (U32.lor (U32.shiftLeft (loadAt addr b2) eightU32) (loadAt addr b3))

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

/-- Source port (bytes 0–1 BE), or `0` if `n < 20`. -/
public unsafe def srcPort (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (loadU16BE addr offSrc offSrcLo)

/-- Destination port (bytes 2–3 BE), or `0` if `n < 20`. -/
public unsafe def dstPort (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (loadU16BE addr offDst offDstLo)

/-- Sequence number (bytes 4–7 BE), or `0` if `n < 20`. -/
public unsafe def seq (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (loadU32BE addr offSeq offSeq1 offSeq2 offSeq3)

/-- Acknowledgment number (bytes 8–11 BE), or `0` if `n < 20`. -/
public unsafe def ack (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (loadU32BE addr offAck offAck1 offAck2 offAck3)

/-- Data offset in 32-bit words (high nibble of byte 12), or `0` if short. -/
public unsafe def dataOff (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (U32.shiftRight (U32.land (loadAt addr offDataOff) maskDataOffHi) fourU32)

/-- Flags byte (byte 13), or `0` if `n < 20`. Layout only. -/
public unsafe def flags (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero (loadAt addr offFlags)

/-- Window (bytes 14–15 BE), or `0` if `n < 20`. -/
public unsafe def window (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (loadU16BE addr offWin offWinLo)

end Systems.Tcp
