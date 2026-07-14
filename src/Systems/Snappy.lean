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
# Systems.Snappy (Systems Lean)

Snappy-**shaped** stream/frame magic / chunk type / length scan over dual caller
`addr`/`len` byte views — not a full Snappy codec, not framed chunk walk, not
raw-block decompress product.

Framed stream prefix (Snappy framing-shaped; minimum **4** chunk-header bytes):

| Offset | Size | Field |
|--------|------|-------|
| 0 | 1 | chunk type (`0xff` = stream identifier) |
| 1–3 | 3 | chunk data length LE (24-bit) |
| 4–9 | 6 | stream magic `"sNaPpY"` when type/`len` identify the stream chunk |

Ops:

* **validate** / **scan** — `0` if `n ≥ 4`, else `1` (too short); when long enough,
  probes first byte and folds it with `land 0` so dual-param `addr` is live
* **hasMagic** — `1` if type `0xff`, 24-bit LE length `6`, and data `"sNaPpY"`, else `0`
* **chunkType** — byte0 when `n ≥ 4`, else `0`
* **chunkLen** — 24-bit LE length at offsets 1–3 as `USize` when `n ≥ 4`, else miss

Honesty:

* **Magic / type / raw LE size only** — no compressed-chunk decompress, no CRC check,
  no multi-chunk walk, not the Snappy raw block or framing codec product.
* **validate status is length-class only** (`ok`/`err`); the first-byte probe never
  changes the status value (`land` with zero) but keeps `addr` on the EmitC result path
  when `n ≥ 4`. Magic match is **not** required by validate.
* **loadAt dual-param honesty:** every load index is under `i < n` after fences.
  `loadAt` is **not** bounds-parameterized.

## Intentional TCB (Snappy-local)

Magic bytes, min lengths, LE shift amounts, byte offsets, and `USize.ofU32` are
freestanding `@[extern]` axioms kept **here**. Name-pinned on ComplianceCorpus
(`path name=Ident`). Byte loads reuse `Scalars`/`Bytes`; shift/or reuse `Numerics`.
-/

namespace Systems.Snappy

open Systems.Scalars
open Systems.Bytes
open Systems.Status
open Systems.Numerics

/-- Chunk header minimum length (type + 3-byte LE len = 4). -/
@[extern c inline "((size_t)4)"] public axiom headerLen : USize
/-- Stream-identifier total length (header + `"sNaPpY"` = 10). -/
@[extern c inline "((size_t)10)"] public axiom streamIdLen : USize
/-- Stream identifier chunk type (`0xff` = 255). -/
@[extern c inline "((uint32_t)255)"] public axiom typeStreamId : U32
/-- Expected stream-id payload length (`6`). -/
@[extern c inline "((uint32_t)6)"] public axiom magicPayloadLen : U32
/-- Magic byte0 `'s'` (115). -/
@[extern c inline "((uint32_t)115)"] public axiom magic0 : U32
/-- Magic byte1 `'N'` (78). -/
@[extern c inline "((uint32_t)78)"] public axiom magic1 : U32
/-- Magic byte2 `'a'` (97). -/
@[extern c inline "((uint32_t)97)"] public axiom magic2 : U32
/-- Magic byte3 `'P'` (80). -/
@[extern c inline "((uint32_t)80)"] public axiom magic3 : U32
/-- Magic byte4 `'p'` (112). -/
@[extern c inline "((uint32_t)112)"] public axiom magic4 : U32
/-- Magic byte5 `'Y'` (89). -/
@[extern c inline "((uint32_t)89)"] public axiom magic5 : U32
/-- Shift amount 8 for little-endian packing. -/
@[extern c inline "((uint32_t)8)"] public axiom eightU32 : U32
/-- Shift amount 16 for little-endian mid bytes. -/
@[extern c inline "((uint32_t)16)"] public axiom sixteenU32 : U32
/-- Offset of second header byte (1). -/
@[extern c inline "((size_t)1)"] public axiom off1 : USize
/-- Offset of third header byte (2). -/
@[extern c inline "((size_t)2)"] public axiom off2 : USize
/-- Offset of fourth header byte (3). -/
@[extern c inline "((size_t)3)"] public axiom off3 : USize
/-- Offset of magic byte0 / payload start (4). -/
@[extern c inline "((size_t)4)"] public axiom off4 : USize
/-- Offset of magic byte1 (5). -/
@[extern c inline "((size_t)5)"] public axiom off5 : USize
/-- Offset of magic byte2 (6). -/
@[extern c inline "((size_t)6)"] public axiom off6 : USize
/-- Offset of magic byte3 (7). -/
@[extern c inline "((size_t)7)"] public axiom off7 : USize
/-- Offset of magic byte4 (8). -/
@[extern c inline "((size_t)8)"] public axiom off8 : USize
/-- Offset of magic byte5 (9). -/
@[extern c inline "((size_t)9)"] public axiom off9 : USize
/-- Widen `U32` → `USize`. -/
@[extern c inline "((size_t)(uint32_t)(#1))"]
public axiom USize.ofU32 : U32 → USize

/-- Load byte at index as `U32`. Caller ensures `i < n`. -/
public unsafe def loadAt (addr : USize) (i : USize) : U32 :=
  U32.ofU8 (U8.load (USize.add addr i))

/-- 24-bit little-endian length at three consecutive offsets. Caller ensures range. -/
public unsafe def loadU24LE (addr : USize) (b0 : USize) (b1 : USize) (b2 : USize) : U32 :=
  U32.lor (loadAt addr b0)
    (U32.lor (U32.shiftLeft (loadAt addr b1) eightU32)
      (U32.shiftLeft (loadAt addr b2) sixteenU32))

/-- `0` if `n ≥ 4`, else `1`.

When `n ≥ 4`, loads first byte and folds it with `U32.land _ U32.zero` so dual-param
`addr` stays on the EmitC result path. Status remains length-class only (probe never
contributes a nonzero bit). Does not require magic match. -/
public unsafe def validate (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) err
    (U32.land (loadAt addr USize.zero) U32.zero)

/-- Alias of `validate`. -/
public unsafe def scan (addr : USize) (n : USize) : U32 :=
  validate addr n

/-- `1` if framed stream-id chunk matches type/`len`/`"sNaPpY"`, else `0` (or short). -/
public unsafe def hasMagic (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n streamIdLen) U32.zero
    (bifU32 (U32.beq (loadAt addr USize.zero) typeStreamId)
      (bifU32 (U32.beq (loadU24LE addr off1 off2 off3) magicPayloadLen)
        (bifU32 (U32.beq (loadAt addr off4) magic0)
          (bifU32 (U32.beq (loadAt addr off5) magic1)
            (bifU32 (U32.beq (loadAt addr off6) magic2)
              (bifU32 (U32.beq (loadAt addr off7) magic3)
                (bifU32 (U32.beq (loadAt addr off8) magic4)
                  (bifU32 (U32.beq (loadAt addr off9) magic5) U32.one U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)

/-- Chunk type (byte0) when `n ≥ 4`, else `0`. -/
public unsafe def chunkType (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (loadAt addr USize.zero)

/-- 24-bit LE chunk data length as `USize` when `n ≥ 4`, else miss (**LP64**). -/
public unsafe def chunkLen (addr : USize) (n : USize) : USize :=
  bifUSize (USize.blt n headerLen) USize.neg1
    (USize.ofU32 (loadU24LE addr off1 off2 off3))

end Systems.Snappy
