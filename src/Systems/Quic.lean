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
# Systems.Quic (Systems Lean)

QUIC-**shaped** long/short header first-byte + minimum long-header layout parse over
dual caller `addr`/`len` byte views — not a full QUIC stack, not TLS, not frames,
not congestion control.

Minimum long-header layout with empty CIDs (RFC 9000-shaped; **7** bytes):

| Offset | Size | Field |
|--------|------|-------|
| 0 | 1 | first byte: long form bit7=`1`, fixed bit6, type bits 5–4, reserved |
| 1–4 | 4 | version (BE) |
| 5 | 1 | DCID length |
| 6 | 1 | SCID length (when DCID empty / length byte only) |

Ops:

* **validate** / **parse** — `0` if `n ≥ 7`, else `1` (too short); when long enough,
  probes first byte and folds it with `land 0` so dual-param `addr` is live
* **isLongHeader** — bit7 of first byte (`1` if long form), or `0` if short `n`
* **version** — big-endian `U32` at offsets 1–4, or `0` if short
* **dcidLen** / **scidLen** — bytes 5 and 6 as `U32` when `n ≥ 7` and long header,
  else `0`
* **pktType** — for long header, bits 5–4 of first byte as `U32` (`0..3`); else `0`
  if short `n` or short-header form

Honesty:

* **Min long-header offsets only** — no connection-ID body product, no token /
  length / packet-number decode, no short-header spin/key-phase product, no frame
  parse, no crypto/TLS, no path validation, no congestion or loss recovery, not a
  socket API.
* **validate status is length-class only** (`ok`/`err`); the first-byte probe never
  changes the status value (`land` with zero) but keeps `addr` on the EmitC result path
  when `n ≥ 7`. Fixed bit / reserved bits are not enforced.
* **loadAt dual-param honesty:** every load index is under `i < n` after the min-7
  fence. `loadAt` is **not** bounds-parameterized.

## Intentional TCB (Quic-local)

Header size, field offsets, long-form/type masks, BE shift amounts, and type shift are
freestanding `@[extern]` axioms kept **here**. Name-pinned on ComplianceCorpus
(`path name=Ident`). Byte loads reuse `Scalars`/`Bytes`; shift/or/and reuse `Numerics`.
-/

namespace Systems.Quic

open Systems.Scalars
open Systems.Bytes
open Systems.Status
open Systems.Numerics

/-- Minimum long-header length with empty CIDs (7). -/
@[extern c inline "((size_t)7)"] public axiom headerLen : USize
/-- Shift amount 8 for big-endian byte packing. -/
@[extern c inline "((uint32_t)8)"] public axiom eightU32 : U32
/-- Shift amount 16 for big-endian `U32` mid bytes. -/
@[extern c inline "((uint32_t)16)"] public axiom sixteenU32 : U32
/-- Shift amount 24 for big-endian `U32` high byte. -/
@[extern c inline "((uint32_t)24)"] public axiom twentyFourU32 : U32
/-- Shift amount 4 for long-header packet type (bits 5–4). -/
@[extern c inline "((uint32_t)4)"] public axiom fourU32 : U32
/-- Long-form header mask (`0x80` = 128). -/
@[extern c inline "((uint32_t)128)"] public axiom maskLong : U32
/-- Long-header packet-type mask after shift (`0x03` = 3). -/
@[extern c inline "((uint32_t)3)"] public axiom maskType : U32
/-- Offset of version high byte (1). -/
@[extern c inline "((size_t)1)"] public axiom offVer : USize
/-- Offset of version byte 1 (2). -/
@[extern c inline "((size_t)2)"] public axiom offVer1 : USize
/-- Offset of version byte 2 (3). -/
@[extern c inline "((size_t)3)"] public axiom offVer2 : USize
/-- Offset of version low byte (4). -/
@[extern c inline "((size_t)4)"] public axiom offVer3 : USize
/-- Offset of DCID length byte (5). -/
@[extern c inline "((size_t)5)"] public axiom offDcidLen : USize
/-- Offset of SCID length byte (6). -/
@[extern c inline "((size_t)6)"] public axiom offScidLen : USize

/-- Load byte at index as `U32`. Caller ensures `i < n`. -/
public unsafe def loadAt (addr : USize) (i : USize) : U32 :=
  U32.ofU8 (U8.load (USize.add addr i))

/-- Big-endian `U32` at four consecutive offsets. Caller ensures all indices in range. -/
public unsafe def loadU32BE (addr : USize) (b0 : USize) (b1 : USize) (b2 : USize)
    (b3 : USize) : U32 :=
  U32.lor (U32.lor (U32.shiftLeft (loadAt addr b0) twentyFourU32)
      (U32.shiftLeft (loadAt addr b1) sixteenU32))
    (U32.lor (U32.shiftLeft (loadAt addr b2) eightU32) (loadAt addr b3))

/-- `0` if `n ≥ 7`, else `1`.

When `n ≥ 7`, loads first byte and folds it with `U32.land _ U32.zero` so dual-param
`addr` stays on the EmitC result path. Status remains length-class only (probe never
contributes a nonzero bit). Does not inspect CIDs, token, or frames past the min fence. -/
public unsafe def validate (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) err
    (U32.land (loadAt addr USize.zero) U32.zero)

/-- Alias of `validate`. -/
public unsafe def parse (addr : USize) (n : USize) : U32 :=
  validate addr n

/-- Long-form header bit (bit7 of first byte): `1` if long, `0` if short `n` or short form. -/
public unsafe def isLongHeader (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (bifU32 (U32.beq (U32.land (loadAt addr USize.zero) maskLong) U32.zero) U32.zero U32.one)

/-- Version (bytes 1–4 BE), or `0` if `n < 7`. -/
public unsafe def version (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (loadU32BE addr offVer offVer1 offVer2 offVer3)

/-- DCID length (byte 5) when long header and `n ≥ 7`, else `0`. -/
public unsafe def dcidLen (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (bifU32 (U32.beq (U32.land (loadAt addr USize.zero) maskLong) U32.zero) U32.zero
      (loadAt addr offDcidLen))

/-- SCID length (byte 6) when long header and `n ≥ 7`, else `0`. -/
public unsafe def scidLen (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (bifU32 (U32.beq (U32.land (loadAt addr USize.zero) maskLong) U32.zero) U32.zero
      (loadAt addr offScidLen))

/-- Long-header packet type (bits 5–4 of first byte as `0..3`), or `0` if short/`n` short. -/
public unsafe def pktType (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (let b := loadAt addr USize.zero
     bifU32 (U32.beq (U32.land b maskLong) U32.zero) U32.zero
       (U32.land (U32.shiftRight b fourU32) maskType))

end Systems.Quic
