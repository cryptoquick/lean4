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
# Systems.Rtp (Systems Lean)

RTP-**shaped** min-12 common header parse over dual caller `addr`/`len` byte views —
not a full RTP stack, not payload demux, not RTCP compound product, not SRTP crypto.

Wire layout (RFC 3550-shaped; minimum **12** header bytes, network byte order):

| Offset | Size | Field |
|--------|------|-------|
| 0 | 1 | V(2) \| P(1) \| X(1) \| CC(4) |
| 1 | 1 | M(1) \| PT(7) |
| 2–3 | 2 | sequence number (BE) |
| 4–7 | 4 | timestamp (BE) |
| 8–11 | 4 | SSRC (BE) |

**Distinct from `Rtcp`:** RTCP uses min-4 V/P/RC/PT/length; RTP uses min-12
V/P/X/CC/M/PT/seq/timestamp/SSRC. Distinct exports (`lean_fs_rtp_*` vs `lean_fs_rtcp_*`).

Ops:

* **validate** / **parse** — `0` if `n ≥ 12`, else `1` (too short); when long enough,
  probes first byte and folds it with `land 0` so dual-param `addr` is live
* **version** — high 2 bits of byte0 (`0..3`), or `0` if short
* **padding** — bit 5 of byte0 (`1` if set), or `0` if short
* **extension** — bit 4 of byte0 (`1` if set), or `0` if short
* **cc** — low 4 bits of byte0 (`0..15` CSRC count shaped), or `0` if short
* **marker** — high bit of byte1 (`1` if set), or `0` if short
* **pt** — low 7 bits of byte1, or `0` if short
* **seq** — big-endian `U16` at offsets 2–3 as `U32`, or `0` if short
* **timestamp** — big-endian `U32` at offsets 4–7 as `USize`, or miss if short
* **ssrc** — big-endian `U32` at offsets 8–11 as `USize`, or miss if short

Honesty:

* **Min-12 RTP header offsets only** — no CSRC list walk, no extension header product,
  no payload type registry, not an RTP session. Distinct from RTCP SR/RR compound.
* **validate status is length-class only** (`ok`/`err`); the first-byte probe never
  changes the status value (`land` with zero) but keeps `addr` on the EmitC result path
  when `n ≥ 12`. Version/PT legality is not enforced.
* **loadAt dual-param honesty:** every load index is under `i < n` after the min-12
  fence. `loadAt` is **not** bounds-parameterized.

## Intentional TCB (Rtp-local)

Header length, masks/shifts, field offsets, BE shift amounts, and `USize.ofU32` are
freestanding `@[extern]` axioms kept **here**. Name-pinned on ComplianceCorpus
(`path name=Ident`). Byte loads reuse `Scalars`/`Bytes`; shift/or/and reuse `Numerics`.
-/

namespace Systems.Rtp

open Systems.Scalars
open Systems.Bytes
open Systems.Status
open Systems.Numerics

/-- RTP common header minimum length (12). -/
@[extern c inline "((size_t)12)"] public axiom headerLen : USize
/-- Shift amount 6 for version high 2 bits. -/
@[extern c inline "((uint32_t)6)"] public axiom sixU32 : U32
/-- Shift amount 8 for big-endian packing. -/
@[extern c inline "((uint32_t)8)"] public axiom eightU32 : U32
/-- Shift amount 16 for mid bytes. -/
@[extern c inline "((uint32_t)16)"] public axiom sixteenU32 : U32
/-- Shift amount 24 for high byte. -/
@[extern c inline "((uint32_t)24)"] public axiom twentyFourU32 : U32
/-- Version 2-bit mask (`0x03` = 3). -/
@[extern c inline "((uint32_t)3)"] public axiom mask2 : U32
/-- Padding bit mask (`0x20` = 32). -/
@[extern c inline "((uint32_t)32)"] public axiom maskPad : U32
/-- Extension bit mask (`0x10` = 16). -/
@[extern c inline "((uint32_t)16)"] public axiom maskExt : U32
/-- CSRC count mask (`0x0F` = 15). -/
@[extern c inline "((uint32_t)15)"] public axiom maskCc : U32
/-- Marker bit mask on byte1 (`0x80` = 128). -/
@[extern c inline "((uint32_t)128)"] public axiom maskMarker : U32
/-- Payload type mask (`0x7F` = 127). -/
@[extern c inline "((uint32_t)127)"] public axiom maskPt : U32
/-- Offset of M/PT byte (1). -/
@[extern c inline "((size_t)1)"] public axiom offPt : USize
/-- Offset of sequence high byte (2). -/
@[extern c inline "((size_t)2)"] public axiom offSeq : USize
/-- Offset of sequence low byte (3). -/
@[extern c inline "((size_t)3)"] public axiom offSeqLo : USize
/-- Offset of timestamp byte0 (4). -/
@[extern c inline "((size_t)4)"] public axiom offTs0 : USize
/-- Offset of timestamp byte1 (5). -/
@[extern c inline "((size_t)5)"] public axiom offTs1 : USize
/-- Offset of timestamp byte2 (6). -/
@[extern c inline "((size_t)6)"] public axiom offTs2 : USize
/-- Offset of timestamp byte3 (7). -/
@[extern c inline "((size_t)7)"] public axiom offTs3 : USize
/-- Offset of SSRC byte0 (8). -/
@[extern c inline "((size_t)8)"] public axiom offSsrc0 : USize
/-- Offset of SSRC byte1 (9). -/
@[extern c inline "((size_t)9)"] public axiom offSsrc1 : USize
/-- Offset of SSRC byte2 (10). -/
@[extern c inline "((size_t)10)"] public axiom offSsrc2 : USize
/-- Offset of SSRC byte3 (11). -/
@[extern c inline "((size_t)11)"] public axiom offSsrc3 : USize
/-- Widen `U32` → `USize`. -/
@[extern c inline "((size_t)(uint32_t)(#1))"]
public axiom USize.ofU32 : U32 → USize

/-- Load byte at index as `U32`. Caller ensures `i < n`. -/
public unsafe def loadAt (addr : USize) (i : USize) : U32 :=
  U32.ofU8 (U8.load (USize.add addr i))

/-- Big-endian `U16` at `hiOff`/`loOff` as `U32`. Caller ensures both indices in range. -/
public unsafe def loadU16BE (addr : USize) (hiOff : USize) (loOff : USize) : U32 :=
  U32.lor (U32.shiftLeft (loadAt addr hiOff) eightU32) (loadAt addr loOff)

/-- Big-endian `U32` at four explicit offsets. Caller ensures all indices in range. -/
public unsafe def loadU32BE (addr : USize) (b0 : USize) (b1 : USize) (b2 : USize)
    (b3 : USize) : U32 :=
  U32.lor (U32.lor (U32.shiftLeft (loadAt addr b0) twentyFourU32)
      (U32.shiftLeft (loadAt addr b1) sixteenU32))
    (U32.lor (U32.shiftLeft (loadAt addr b2) eightU32)
      (loadAt addr b3))

/-- `0` if `n ≥ 12`, else `1`.

When `n ≥ 12`, loads first byte and folds it with `U32.land _ U32.zero` so dual-param
`addr` stays on the EmitC result path. Status remains length-class only (probe never
contributes a nonzero bit). Does not inspect CSRC/extension/payload past the min fence. -/
public unsafe def validate (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) err
    (U32.land (loadAt addr USize.zero) U32.zero)

/-- Alias of `validate`. -/
public unsafe def parse (addr : USize) (n : USize) : U32 :=
  validate addr n

/-- Version (high 2 bits of byte0), or `0` if `n < 12`. -/
public unsafe def version (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (U32.land (U32.shiftRight (loadAt addr USize.zero) sixU32) mask2)

/-- Padding bit of byte0 (`1` if set), or `0` if `n < 12`. -/
public unsafe def padding (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (bifU32 (U32.beq (U32.land (loadAt addr USize.zero) maskPad) U32.zero)
      U32.zero U32.one)

/-- Extension bit of byte0 (`1` if set), or `0` if `n < 12`. -/
public unsafe def extension (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (bifU32 (U32.beq (U32.land (loadAt addr USize.zero) maskExt) U32.zero)
      U32.zero U32.one)

/-- CSRC count (low 4 bits of byte0), or `0` if `n < 12`. -/
public unsafe def cc (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (U32.land (loadAt addr USize.zero) maskCc)

/-- Marker bit of byte1 (`1` if set), or `0` if `n < 12`. -/
public unsafe def marker (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (bifU32 (U32.beq (U32.land (loadAt addr offPt) maskMarker) U32.zero)
      U32.zero U32.one)

/-- Payload type (low 7 bits of byte1), or `0` if `n < 12`. -/
public unsafe def pt (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (U32.land (loadAt addr offPt) maskPt)

/-- Sequence number (bytes 2–3 BE) as `U32`, or `0` if `n < 12`. -/
public unsafe def seq (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (loadU16BE addr offSeq offSeqLo)

/-- Timestamp (bytes 4–7 BE) as `USize`, or miss if `n < 12`. **LP64**. -/
public unsafe def timestamp (addr : USize) (n : USize) : USize :=
  bifUSize (USize.blt n headerLen) USize.neg1
    (USize.ofU32 (loadU32BE addr offTs0 offTs1 offTs2 offTs3))

/-- SSRC (bytes 8–11 BE) as `USize`, or miss if `n < 12`. **LP64**. -/
public unsafe def ssrc (addr : USize) (n : USize) : USize :=
  bifUSize (USize.blt n headerLen) USize.neg1
    (USize.ofU32 (loadU32BE addr offSsrc0 offSsrc1 offSsrc2 offSsrc3))

end Systems.Rtp
