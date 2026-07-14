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
# Systems.Ogg (Systems Lean)

Ogg-**shaped** page capture-pattern / header field scan over dual caller `addr`/`len`
byte views — not a full Ogg demux, not packet reassembly, not checksum verify product.

Page prefix (RFC 3533-shaped; capture pattern `"OggS"`; minimum **27** bytes for an
empty segment table — fixed header through `page_segments`, no segment table bytes):

| Offset | Size | Field |
|--------|------|-------|
| 0–3 | 4 | capture pattern `"OggS"` |
| 4 | 1 | stream structure version |
| 5 | 1 | header type flag |
| 6–13 | 8 | absolute granule position (LE; low half exposed) |
| 14–17 | 4 | stream serial number (LE) |
| 18–21 | 4 | page sequence number (LE) |
| 22–25 | 4 | page checksum (LE) |
| 26 | 1 | page_segments (`nseg`) |

Ops:

* **validate** / **scan** — `0` if `n ≥ 27`, else `1` (too short); when long enough,
  probes first byte and folds it with `land 0` so dual-param `addr` is live
* **hasMagic** — `1` if first 4 bytes are `"OggS"`, else `0` (or short)
* **version** / **headerType** / **nSegments** — single-byte fields (`0` if short)
* **granuleLo** / **serial** / **seq** / **checksum** — LE `U32` fields as `USize`
  (`miss` if short)

Honesty:

* **Capture pattern + fixed page header only** — no segment table walk, no packet
  lacing, no CRC verify, not a demuxer / muxer product.
* **validate status is length-class only** (`ok`/`err`); the first-byte probe never
  changes the status value (`land` with zero) but keeps `addr` on the EmitC result path
  when `n ≥ 27`. Magic match is **not** required by validate.
* **loadAt dual-param honesty:** every load index is under `i < n` after the min-27
  fence. `loadAt` is **not** bounds-parameterized.

## Intentional TCB (Ogg-local)

Min length, capture-pattern bytes, per-byte field offsets, LE shift amounts, and
`USize.ofU32` are freestanding `@[extern]` axioms kept **here**. Name-pinned on
ComplianceCorpus (`path name=Ident`). Byte loads reuse `Scalars`/`Bytes`; shift/or
reuse `Numerics`.
-/

namespace Systems.Ogg

open Systems.Scalars
open Systems.Bytes
open Systems.Status
open Systems.Numerics

/-- Minimum Ogg page header length with empty segment table (27). -/
@[extern c inline "((size_t)27)"] public axiom headerLen : USize
/-- Capture `'O'` (79). -/
@[extern c inline "((uint32_t)79)"] public axiom magic0 : U32
/-- Capture `'g'` (103). -/
@[extern c inline "((uint32_t)103)"] public axiom magic1 : U32
/-- Capture `'g'` (103). -/
@[extern c inline "((uint32_t)103)"] public axiom magic2 : U32
/-- Capture `'S'` (83). -/
@[extern c inline "((uint32_t)83)"] public axiom magic3 : U32
/-- Offset of second magic byte (1). -/
@[extern c inline "((size_t)1)"] public axiom off1 : USize
/-- Offset of third magic byte (2). -/
@[extern c inline "((size_t)2)"] public axiom off2 : USize
/-- Offset of fourth magic byte (3). -/
@[extern c inline "((size_t)3)"] public axiom off3 : USize
/-- Offset of version (4). -/
@[extern c inline "((size_t)4)"] public axiom offVersion : USize
/-- Offset of header type (5). -/
@[extern c inline "((size_t)5)"] public axiom offHeaderType : USize
/-- Offset of granule low LE byte0 (6). -/
@[extern c inline "((size_t)6)"] public axiom offGranule0 : USize
/-- Offset of granule low LE byte1 (7). -/
@[extern c inline "((size_t)7)"] public axiom offGranule1 : USize
/-- Offset of granule low LE byte2 (8). -/
@[extern c inline "((size_t)8)"] public axiom offGranule2 : USize
/-- Offset of granule low LE byte3 (9). -/
@[extern c inline "((size_t)9)"] public axiom offGranule3 : USize
/-- Offset of serial LE byte0 (14). -/
@[extern c inline "((size_t)14)"] public axiom offSerial0 : USize
/-- Offset of serial LE byte1 (15). -/
@[extern c inline "((size_t)15)"] public axiom offSerial1 : USize
/-- Offset of serial LE byte2 (16). -/
@[extern c inline "((size_t)16)"] public axiom offSerial2 : USize
/-- Offset of serial LE byte3 (17). -/
@[extern c inline "((size_t)17)"] public axiom offSerial3 : USize
/-- Offset of sequence LE byte0 (18). -/
@[extern c inline "((size_t)18)"] public axiom offSeq0 : USize
/-- Offset of sequence LE byte1 (19). -/
@[extern c inline "((size_t)19)"] public axiom offSeq1 : USize
/-- Offset of sequence LE byte2 (20). -/
@[extern c inline "((size_t)20)"] public axiom offSeq2 : USize
/-- Offset of sequence LE byte3 (21). -/
@[extern c inline "((size_t)21)"] public axiom offSeq3 : USize
/-- Offset of checksum LE byte0 (22). -/
@[extern c inline "((size_t)22)"] public axiom offCsum0 : USize
/-- Offset of checksum LE byte1 (23). -/
@[extern c inline "((size_t)23)"] public axiom offCsum1 : USize
/-- Offset of checksum LE byte2 (24). -/
@[extern c inline "((size_t)24)"] public axiom offCsum2 : USize
/-- Offset of checksum LE byte3 (25). -/
@[extern c inline "((size_t)25)"] public axiom offCsum3 : USize
/-- Offset of page_segments (26). -/
@[extern c inline "((size_t)26)"] public axiom offNseg : USize
/-- Shift amount 8 for little-endian packing. -/
@[extern c inline "((uint32_t)8)"] public axiom eightU32 : U32
/-- Shift amount 16 for little-endian mid bytes. -/
@[extern c inline "((uint32_t)16)"] public axiom sixteenU32 : U32
/-- Shift amount 24 for little-endian high byte. -/
@[extern c inline "((uint32_t)24)"] public axiom twentyFourU32 : U32
/-- Four as `USize` (magic width fence). -/
@[extern c inline "((size_t)4)"] public axiom fourUSize : USize
/-- Widen `U32` → `USize`. -/
@[extern c inline "((size_t)(uint32_t)(#1))"]
public axiom USize.ofU32 : U32 → USize

/-- Load byte at index as `U32`. Caller ensures `i < n`. -/
public unsafe def loadAt (addr : USize) (i : USize) : U32 :=
  U32.ofU8 (U8.load (USize.add addr i))

/-- Little-endian `U32` at four explicit offsets. Caller ensures all indices in range. -/
public unsafe def loadU32LE (addr : USize) (b0 : USize) (b1 : USize) (b2 : USize)
    (b3 : USize) : U32 :=
  U32.lor (U32.lor (loadAt addr b0)
      (U32.shiftLeft (loadAt addr b1) eightU32))
    (U32.lor (U32.shiftLeft (loadAt addr b2) sixteenU32)
      (U32.shiftLeft (loadAt addr b3) twentyFourU32))

/-- `0` if `n ≥ 27`, else `1`.

When `n ≥ 27`, loads first byte and folds it with `U32.land _ U32.zero` so dual-param
`addr` stays on the EmitC result path. Status remains length-class only (probe never
contributes a nonzero bit). Does not require `"OggS"` match. -/
public unsafe def validate (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) err
    (U32.land (loadAt addr USize.zero) U32.zero)

/-- Alias of `validate`. -/
public unsafe def scan (addr : USize) (n : USize) : U32 :=
  validate addr n

/-- `1` if first 4 bytes are `"OggS"`, else `0` (or short). -/
public unsafe def hasMagic (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n fourUSize) U32.zero
    (bifU32 (U32.beq (loadAt addr USize.zero) magic0)
      (bifU32 (U32.beq (loadAt addr off1) magic1)
        (bifU32 (U32.beq (loadAt addr off2) magic2)
          (bifU32 (U32.beq (loadAt addr off3) magic3) U32.one U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)

/-- Stream structure version (byte 4), or `0` if `n < 27`. -/
public unsafe def version (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero (loadAt addr offVersion)

/-- Header type flag (byte 5), or `0` if `n < 27`. -/
public unsafe def headerType (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero (loadAt addr offHeaderType)

/-- Low 32 bits of granule position (LE bytes 6–9) as `USize`, or miss if short. **LP64**. -/
public unsafe def granuleLo (addr : USize) (n : USize) : USize :=
  bifUSize (USize.blt n headerLen) USize.neg1
    (USize.ofU32 (loadU32LE addr offGranule0 offGranule1 offGranule2 offGranule3))

/-- Stream serial number (LE bytes 14–17) as `USize`, or miss if short. **LP64**. -/
public unsafe def serial (addr : USize) (n : USize) : USize :=
  bifUSize (USize.blt n headerLen) USize.neg1
    (USize.ofU32 (loadU32LE addr offSerial0 offSerial1 offSerial2 offSerial3))

/-- Page sequence number (LE bytes 18–21) as `USize`, or miss if short. **LP64**. -/
public unsafe def seq (addr : USize) (n : USize) : USize :=
  bifUSize (USize.blt n headerLen) USize.neg1
    (USize.ofU32 (loadU32LE addr offSeq0 offSeq1 offSeq2 offSeq3))

/-- Page checksum (LE bytes 22–25) as `USize`, or miss if short. **LP64**. -/
public unsafe def checksum (addr : USize) (n : USize) : USize :=
  bifUSize (USize.blt n headerLen) USize.neg1
    (USize.ofU32 (loadU32LE addr offCsum0 offCsum1 offCsum2 offCsum3))

/-- `page_segments` count (byte 26), or `0` if `n < 27`. -/
public unsafe def nSegments (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero (loadAt addr offNseg)

end Systems.Ogg
