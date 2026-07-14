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
# Systems.Flac (Systems Lean)

FLAC-**shaped** stream marker + optional STREAMINFO metadata-block header scan over
dual caller `addr`/`len` byte views — not a full FLAC decoder/codec, not subframe
product, not CRC/MD5 verify.

Stream prefix (RFC 9639-shaped; magic `"fLaC"`; minimum **4** magic bytes; optional
4-byte metadata block header at offset 4 when `n ≥ 8`):

| Offset | Size | Field |
|--------|------|-------|
| 0–3 | 4 | stream marker `"fLaC"` |
| 4 | 1 | last-meta flag (bit7) + block type (bits6–0); STREAMINFO type = 0 |
| 5–7 | 3 | block data length BE 24-bit (when present) |

Ops:

* **validate** / **scan** — `0` if `n ≥ 4`, else `1` (too short); when long enough,
  probes first byte and folds it with `land 0` so dual-param `addr` is live
* **hasMagic** — `1` if first 4 bytes are `"fLaC"`, else `0` (or short)
* **magicBe** — first 4 bytes as BE `U32` → `USize`, or miss if short
* **isStreamInfo** — `1` if block type bits are `0` when `n ≥ 5`, else `0`
* **isLastMeta** — `1` if last-meta flag set when `n ≥ 5`, else `0`
* **blockType** — type bits of header byte when `n ≥ 5`, else `0`
* **blockDataLen** — 24-bit BE length at offs 5–7 as `USize` when `n ≥ 8`, else miss
* **fieldBeAt** — BE `U32` at `off` as `USize` when `off + 4 ≤ n`, else miss

Honesty:

* **Magic + first metadata block header shape only** — no STREAMINFO body decode,
  no multi-block walk, no residual/subframe product, not a FLAC codec.
* **validate status is length-class only** (`ok`/`err`); the first-byte probe never
  changes the status value (`land` with zero) but keeps `addr` on the EmitC result path
  when `n ≥ 4`. Magic match is **not** required by validate.
* **loadAt dual-param honesty:** every load index is under `i < n` after fences.
  `loadAt` is **not** bounds-parameterized.

## Intentional TCB (Flac-local)

Magic bytes, min lengths, BE shift amounts, per-byte offsets, type/last masks, and
`USize.ofU32` are freestanding `@[extern]` axioms kept **here**. Name-pinned on
ComplianceCorpus (`path name=Ident`). Byte loads reuse `Scalars`/`Bytes`; shift/or/and
reuse `Numerics`.
-/

namespace Systems.Flac

open Systems.Scalars
open Systems.Bytes
open Systems.Status
open Systems.Numerics

/-- FLAC magic minimum length (4). -/
@[extern c inline "((size_t)4)"] public axiom magicLen : USize
/-- Length needed for full first metadata block header after magic (`8` shaped). -/
@[extern c inline "((size_t)8)"] public axiom blockHdrLen : USize
/-- Length needed for header type byte at offset 4 (`5` shaped). -/
@[extern c inline "((size_t)5)"] public axiom typeLen : USize
/-- Magic byte0 `'f'` (102). -/
@[extern c inline "((uint32_t)102)"] public axiom magic0 : U32
/-- Magic byte1 `'L'` (76). -/
@[extern c inline "((uint32_t)76)"] public axiom magic1 : U32
/-- Magic byte2 `'a'` (97). -/
@[extern c inline "((uint32_t)97)"] public axiom magic2 : U32
/-- Magic byte3 `'C'` (67). -/
@[extern c inline "((uint32_t)67)"] public axiom magic3 : U32
/-- Shift amount 8 for big-endian packing. -/
@[extern c inline "((uint32_t)8)"] public axiom eightU32 : U32
/-- Shift amount 16 for big-endian mid bytes. -/
@[extern c inline "((uint32_t)16)"] public axiom sixteenU32 : U32
/-- Shift amount 24 for big-endian high byte. -/
@[extern c inline "((uint32_t)24)"] public axiom twentyFourU32 : U32
/-- Offset of second magic byte (1). -/
@[extern c inline "((size_t)1)"] public axiom off1 : USize
/-- Offset of third magic byte (2). -/
@[extern c inline "((size_t)2)"] public axiom off2 : USize
/-- Offset of fourth magic byte (3). -/
@[extern c inline "((size_t)3)"] public axiom off3 : USize
/-- Offset of metadata block header type/last byte (4). -/
@[extern c inline "((size_t)4)"] public axiom offType : USize
/-- Offset of block-length BE byte0 (5). -/
@[extern c inline "((size_t)5)"] public axiom offLen0 : USize
/-- Offset of block-length BE byte1 (6). -/
@[extern c inline "((size_t)6)"] public axiom offLen1 : USize
/-- Offset of block-length BE byte2 (7). -/
@[extern c inline "((size_t)7)"] public axiom offLen2 : USize
/-- Four as `USize` (BE field width). -/
@[extern c inline "((size_t)4)"] public axiom fourUSize : USize
/-- Last-metadata-block flag mask (`0x80` = 128). -/
@[extern c inline "((uint32_t)128)"] public axiom maskLast : U32
/-- Block-type mask (`0x7F` = 127). -/
@[extern c inline "((uint32_t)127)"] public axiom maskType : U32
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

/-- `0` if `n ≥ 4`, else `1`.

When `n ≥ 4`, loads first byte and folds it with `U32.land _ U32.zero` so dual-param
`addr` stays on the EmitC result path. Status remains length-class only (probe never
contributes a nonzero bit). Does not require `"fLaC"` match. -/
public unsafe def validate (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n magicLen) err
    (U32.land (loadAt addr USize.zero) U32.zero)

/-- Alias of `validate`. -/
public unsafe def scan (addr : USize) (n : USize) : U32 :=
  validate addr n

/-- `1` if first 4 bytes are `"fLaC"`, else `0` (or short). -/
public unsafe def hasMagic (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n magicLen) U32.zero
    (bifU32 (U32.beq (loadAt addr USize.zero) magic0)
      (bifU32 (U32.beq (loadAt addr off1) magic1)
        (bifU32 (U32.beq (loadAt addr off2) magic2)
          (bifU32 (U32.beq (loadAt addr off3) magic3) U32.one U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)

/-- First 4 bytes as BE `U32` → `USize`, or miss if short. **LP64**. -/
public unsafe def magicBe (addr : USize) (n : USize) : USize :=
  bifUSize (USize.blt n magicLen) USize.neg1
    (USize.ofU32 (loadU32BE addr USize.zero off1 off2 off3))

/-- `1` if metadata block type bits are STREAMINFO (`0`) when `n ≥ 5`, else `0`. -/
public unsafe def isStreamInfo (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n typeLen) U32.zero
    (bifU32 (U32.beq (U32.land (loadAt addr offType) maskType) U32.zero) U32.one U32.zero)

/-- `1` if last-metadata-block flag is set when `n ≥ 5`, else `0`. -/
public unsafe def isLastMeta (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n typeLen) U32.zero
    (bifU32 (U32.beq (U32.land (loadAt addr offType) maskLast) U32.zero) U32.zero U32.one)

/-- Block type bits (0..127) when `n ≥ 5`, else `0`. -/
public unsafe def blockType (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n typeLen) U32.zero
    (U32.land (loadAt addr offType) maskType)

/-- 24-bit BE block data length at offs 5–7 as `USize` when `n ≥ 8`, else miss. **LP64**. -/
public unsafe def blockDataLen (addr : USize) (n : USize) : USize :=
  bifUSize (USize.blt n blockHdrLen) USize.neg1
    (USize.ofU32
      (U32.lor (U32.lor (U32.shiftLeft (loadAt addr offLen0) sixteenU32)
          (U32.shiftLeft (loadAt addr offLen1) eightU32))
        (loadAt addr offLen2)))

/-- BE field `U32` at `off` as `USize` when `off + 4 ≤ n`, else miss (**LP64**).

Shaped for raw BE dwords after the magic; does not decode STREAMINFO body fields. -/
public unsafe def fieldBeAt (addr : USize) (n : USize) (off : USize) : USize :=
  bifUSize (USize.blt n (USize.add off fourUSize)) USize.neg1
    (USize.ofU32 (loadU32BE addr off (USize.add off off1) (USize.add off off2)
      (USize.add off off3)))

end Systems.Flac
