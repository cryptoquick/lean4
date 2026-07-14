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
# Systems.Vorbis (Systems Lean)

Vorbis/Ogg-Vorbis-**shaped** identification packet scan over dual caller `addr`/`len`
byte views — not a full Vorbis codec, not Ogg page demux product, not codebook decode.

Identification header prefix (Xiph Vorbis I-shaped; packet type `0x01` then magic
`"vorbis"`; minimum **7** bytes; optional version/channels/sample-rate when longer):

| Offset | Size | Field |
|--------|------|-------|
| 0 | 1 | packet type (`0x01` = identification) |
| 1–6 | 6 | magic `"vorbis"` |
| 7–10 | 4 | vorbis_version LE 32-bit (when `n ≥ 11`) |
| 11 | 1 | audio_channels (when `n ≥ 12`) |
| 12–15 | 4 | audio_sample_rate LE 32-bit (when `n ≥ 16`) |

Ops:

* **validate** / **scan** — `0` if `n ≥ 7`, else `1` (too short); when long enough,
  probes first byte and folds it with `land 0` so dual-param `addr` is live
* **hasMagic** — `1` if type is `0x01` and next 6 bytes are `"vorbis"`, else `0` (or short)
* **magicBe** — magic bytes 1–4 as BE `U32` → `USize`, or miss if short for that window
* **version** / **channelCount** — fields after magic (`0` if short)
* **sampleRate** — 32-bit LE at offs 12–15 as `USize` when `n ≥ 16`, else miss
* **fieldLeAt** — LE `U32` at `off` as `USize` when `off + 4 ≤ n`, else miss

Honesty:

* **Identification packet type + `"vorbis"` magic + optional ID fields only** — no
  comment/setup packets, no Ogg page walk, no codebook/residue product, not a Vorbis
  codec.
* **validate status is length-class only** (`ok`/`err`); the first-byte probe never
  changes the status value (`land` with zero) but keeps `addr` on the EmitC result path
  when `n ≥ 7`. Magic match is **not** required by validate.
* **loadAt dual-param honesty:** every load index is under `i < n` after fences.
  `loadAt` is **not** bounds-parameterized.

## Intentional TCB (Vorbis-local)

Packet type, magic bytes, min lengths, LE/BE shift amounts, per-byte offsets, and
`USize.ofU32` are freestanding `@[extern]` axioms kept **here**. Name-pinned on
ComplianceCorpus (`path name=Ident`). Byte loads reuse `Scalars`/`Bytes`; shift/or
reuse `Numerics`.
-/

namespace Systems.Vorbis

open Systems.Scalars
open Systems.Bytes
open Systems.Status
open Systems.Numerics

/-- Identification magic minimum length (type + `"vorbis"` = 7). -/
@[extern c inline "((size_t)7)"] public axiom magicLen : USize
/-- Length needed for magic letters offs 1–4 BE window (`5` shaped). -/
@[extern c inline "((size_t)5)"] public axiom magicBeLen : USize
/-- Length needed for version LE32 after magic (`11` shaped). -/
@[extern c inline "((size_t)11)"] public axiom versionLen : USize
/-- Length needed for channel count (`12` shaped). -/
@[extern c inline "((size_t)12)"] public axiom channelLen : USize
/-- Length needed for sample-rate LE32 (`16` shaped). -/
@[extern c inline "((size_t)16)"] public axiom sampleRateLen : USize
/-- Identification packet type (`0x01` = 1). -/
@[extern c inline "((uint32_t)1)"] public axiom packetId : U32
/-- Magic byte1 `'v'` (118) at offset 1. -/
@[extern c inline "((uint32_t)118)"] public axiom magic0 : U32
/-- Magic byte2 `'o'` (111). -/
@[extern c inline "((uint32_t)111)"] public axiom magic1 : U32
/-- Magic byte3 `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom magic2 : U32
/-- Magic byte4 `'b'` (98). -/
@[extern c inline "((uint32_t)98)"] public axiom magic3 : U32
/-- Magic byte5 `'i'` (105). -/
@[extern c inline "((uint32_t)105)"] public axiom magic4 : U32
/-- Magic byte6 `'s'` (115). -/
@[extern c inline "((uint32_t)115)"] public axiom magic5 : U32
/-- Shift amount 8 for endian packing. -/
@[extern c inline "((uint32_t)8)"] public axiom eightU32 : U32
/-- Shift amount 16 for mid bytes. -/
@[extern c inline "((uint32_t)16)"] public axiom sixteenU32 : U32
/-- Shift amount 24 for high byte. -/
@[extern c inline "((uint32_t)24)"] public axiom twentyFourU32 : U32
/-- Offset of first magic letter (1). -/
@[extern c inline "((size_t)1)"] public axiom off1 : USize
/-- Offset of second magic letter (2). -/
@[extern c inline "((size_t)2)"] public axiom off2 : USize
/-- Offset of third magic letter (3). -/
@[extern c inline "((size_t)3)"] public axiom off3 : USize
/-- Offset of fourth magic letter (4). -/
@[extern c inline "((size_t)4)"] public axiom off4 : USize
/-- Offset of fifth magic letter (5). -/
@[extern c inline "((size_t)5)"] public axiom off5 : USize
/-- Offset of sixth magic letter (6). -/
@[extern c inline "((size_t)6)"] public axiom off6 : USize
/-- Offset of version LE byte0 (7). -/
@[extern c inline "((size_t)7)"] public axiom offVer0 : USize
/-- Offset of version LE byte1 (8). -/
@[extern c inline "((size_t)8)"] public axiom offVer1 : USize
/-- Offset of version LE byte2 (9). -/
@[extern c inline "((size_t)9)"] public axiom offVer2 : USize
/-- Offset of version LE byte3 (10). -/
@[extern c inline "((size_t)10)"] public axiom offVer3 : USize
/-- Offset of channel count (11). -/
@[extern c inline "((size_t)11)"] public axiom offChannel : USize
/-- Offset of sample-rate LE byte0 (12). -/
@[extern c inline "((size_t)12)"] public axiom offRate0 : USize
/-- Offset of sample-rate LE byte1 (13). -/
@[extern c inline "((size_t)13)"] public axiom offRate1 : USize
/-- Offset of sample-rate LE byte2 (14). -/
@[extern c inline "((size_t)14)"] public axiom offRate2 : USize
/-- Offset of sample-rate LE byte3 (15). -/
@[extern c inline "((size_t)15)"] public axiom offRate3 : USize
/-- Four as `USize` (LE field width). -/
@[extern c inline "((size_t)4)"] public axiom fourUSize : USize
/-- Widen `U32` → `USize`. -/
@[extern c inline "((size_t)(uint32_t)(#1))"]
public axiom USize.ofU32 : U32 → USize

/-- Load byte at index as `U32`. Caller ensures `i < n`. -/
public unsafe def loadAt (addr : USize) (i : USize) : U32 :=
  U32.ofU8 (U8.load (USize.add addr i))

/-- Big-endian `U32` at four explicit offsets. Caller ensures all indices in range. -/
public unsafe def loadU32BE (addr : USize) (b0 : USize) (b1 : USize) (b2 : USize)
    (b3 : USize) : U32 :=
  U32.lor (U32.lor (U32.shiftLeft (loadAt addr b0) twentyFourU32)
      (U32.shiftLeft (loadAt addr b1) sixteenU32))
    (U32.lor (U32.shiftLeft (loadAt addr b2) eightU32)
      (loadAt addr b3))

/-- Little-endian `U32` at four explicit offsets. Caller ensures all indices in range. -/
public unsafe def loadU32LE (addr : USize) (b0 : USize) (b1 : USize) (b2 : USize)
    (b3 : USize) : U32 :=
  U32.lor (U32.lor (loadAt addr b0)
      (U32.shiftLeft (loadAt addr b1) eightU32))
    (U32.lor (U32.shiftLeft (loadAt addr b2) sixteenU32)
      (U32.shiftLeft (loadAt addr b3) twentyFourU32))

/-- `0` if `n ≥ 7`, else `1`.

When `n ≥ 7`, loads first byte and folds it with `U32.land _ U32.zero` so dual-param
`addr` stays on the EmitC result path. Status remains length-class only (probe never
contributes a nonzero bit). Does not require type/`"vorbis"` match. -/
public unsafe def validate (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n magicLen) err
    (U32.land (loadAt addr USize.zero) U32.zero)

/-- Alias of `validate`. -/
public unsafe def scan (addr : USize) (n : USize) : U32 :=
  validate addr n

/-- `1` if type is identification (`0x01`) and magic is `"vorbis"`, else `0` (or short). -/
public unsafe def hasMagic (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n magicLen) U32.zero
    (bifU32 (U32.beq (loadAt addr USize.zero) packetId)
      (bifU32 (U32.beq (loadAt addr off1) magic0)
        (bifU32 (U32.beq (loadAt addr off2) magic1)
          (bifU32 (U32.beq (loadAt addr off3) magic2)
            (bifU32 (U32.beq (loadAt addr off4) magic3)
              (bifU32 (U32.beq (loadAt addr off5) magic4)
                (bifU32 (U32.beq (loadAt addr off6) magic5) U32.one U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)

/-- Magic letters `"vorb"` (offs 1–4) as BE `U32` → `USize`, or miss if short. **LP64**.

Requires `n ≥ 5` so offs 1–4 are in range (window after type byte). -/
public unsafe def magicBe (addr : USize) (n : USize) : USize :=
  bifUSize (USize.blt n magicBeLen) USize.neg1
    (USize.ofU32 (loadU32BE addr off1 off2 off3 off4))

/-- Vorbis version LE32 when `n ≥ 11`, else miss. **LP64**. -/
public unsafe def version (addr : USize) (n : USize) : USize :=
  bifUSize (USize.blt n versionLen) USize.neg1
    (USize.ofU32 (loadU32LE addr offVer0 offVer1 offVer2 offVer3))

/-- Channel count when `n ≥ 12`, else `0`. -/
public unsafe def channelCount (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n channelLen) U32.zero
    (loadAt addr offChannel)

/-- 32-bit LE sample rate at offs 12–15 as `USize` when `n ≥ 16`, else miss. **LP64**. -/
public unsafe def sampleRate (addr : USize) (n : USize) : USize :=
  bifUSize (USize.blt n sampleRateLen) USize.neg1
    (USize.ofU32 (loadU32LE addr offRate0 offRate1 offRate2 offRate3))

/-- LE field `U32` at `off` as `USize` when `off + 4 ≤ n`, else miss (**LP64**).

Shaped for raw LE dwords in/after the ID header; does not decode remaining Vorbis
identification fields beyond sample rate. -/
public unsafe def fieldLeAt (addr : USize) (n : USize) (off : USize) : USize :=
  bifUSize (USize.blt n (USize.add off fourUSize)) USize.neg1
    (USize.ofU32 (loadU32LE addr off (USize.add off off1) (USize.add off off2)
      (USize.add off off3)))

end Systems.Vorbis
