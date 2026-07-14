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
# Systems.Lz4 (Systems Lean)

LZ4-**shaped** frame magic / optional flags / block-size scan over dual caller
`addr`/`len` byte views — not a full LZ4 codec, not frame block walk, not
dictionary or content checksum product.

Frame prefix (LZ4 frame-shaped; minimum **4** magic bytes LE `0x184D2204`):

| Offset | Size | Field |
|--------|------|-------|
| 0–3 | 4 | magic number LE (`04 22 4D 18`) |
| 4 | 1 | FLG (when present; n≥7 shaped) |

Ops:

* **validate** / **scan** — `0` if `n ≥ 4`, else `1` (too short); when long enough,
  probes first byte and folds it with `land 0` so dual-param `addr` is live
* **hasMagic** — `1` if first 4 LE bytes match frame magic, else `0` (or short)
* **frameFlags** — byte at offset 4 when `n ≥ 7`, else `0`
* **blockSizeAt** — LE `U32` at `off` as `USize` when `off + 4 ≤ n`, else miss

Honesty:

* **Magic / flags / raw LE size only** — no block decompress, no frame descriptor
  HC, no content-size, no end-mark walk, not the LZ4 block or stream codec product.
* **validate status is length-class only** (`ok`/`err`); the first-byte probe never
  changes the status value (`land` with zero) but keeps `addr` on the EmitC result path
  when `n ≥ 4`. Magic match is **not** required by validate.
* **loadAt dual-param honesty:** every load index is under `i < n` after fences.
  `loadAt` is **not** bounds-parameterized.

## Intentional TCB (Lz4-local)

Magic bytes, min lengths, LE shift amounts, byte offsets, and `USize.ofU32` are
freestanding `@[extern]` axioms kept **here**. Name-pinned on ComplianceCorpus
(`path name=Ident`). Byte loads reuse `Scalars`/`Bytes`; shift/or reuse `Numerics`.
-/

namespace Systems.Lz4

open Systems.Scalars
open Systems.Bytes
open Systems.Status
open Systems.Numerics

/-- LZ4 frame magic minimum length (4). -/
@[extern c inline "((size_t)4)"] public axiom magicLen : USize
/-- Length needed for optional FLG at offset 4 (`7` shaped). -/
@[extern c inline "((size_t)7)"] public axiom flagsLen : USize
/-- Magic LE byte0 (`0x04` = 4). -/
@[extern c inline "((uint32_t)4)"] public axiom magic0 : U32
/-- Magic LE byte1 (`0x22` = 34). -/
@[extern c inline "((uint32_t)34)"] public axiom magic1 : U32
/-- Magic LE byte2 (`0x4D` = 77). -/
@[extern c inline "((uint32_t)77)"] public axiom magic2 : U32
/-- Magic LE byte3 (`0x18` = 24). -/
@[extern c inline "((uint32_t)24)"] public axiom magic3 : U32
/-- Shift amount 8 for little-endian packing. -/
@[extern c inline "((uint32_t)8)"] public axiom eightU32 : U32
/-- Shift amount 16 for little-endian mid bytes. -/
@[extern c inline "((uint32_t)16)"] public axiom sixteenU32 : U32
/-- Shift amount 24 for little-endian high byte. -/
@[extern c inline "((uint32_t)24)"] public axiom twentyFourU32 : U32
/-- Offset of second LE byte (1). -/
@[extern c inline "((size_t)1)"] public axiom off1 : USize
/-- Offset of third LE byte (2). -/
@[extern c inline "((size_t)2)"] public axiom off2 : USize
/-- Offset of fourth LE byte (3). -/
@[extern c inline "((size_t)3)"] public axiom off3 : USize
/-- Offset of FLG byte (4). -/
@[extern c inline "((size_t)4)"] public axiom offFlags : USize
/-- Four as `USize` (block size width). -/
@[extern c inline "((size_t)4)"] public axiom fourUSize : USize
/-- Widen `U32` → `USize`. -/
@[extern c inline "((size_t)(uint32_t)(#1))"]
public axiom USize.ofU32 : U32 → USize

/-- Load byte at index as `U32`. Caller ensures `i < n`. -/
public unsafe def loadAt (addr : USize) (i : USize) : U32 :=
  U32.ofU8 (U8.load (USize.add addr i))

/-- Little-endian `U32` at four consecutive offsets. Caller ensures all indices in range. -/
public unsafe def loadU32LE (addr : USize) (b0 : USize) (b1 : USize) (b2 : USize)
    (b3 : USize) : U32 :=
  U32.lor (U32.lor (loadAt addr b0)
      (U32.shiftLeft (loadAt addr b1) eightU32))
    (U32.lor (U32.shiftLeft (loadAt addr b2) sixteenU32)
      (U32.shiftLeft (loadAt addr b3) twentyFourU32))

/-- `0` if `n ≥ 4`, else `1`.

When `n ≥ 4`, loads first byte and folds it with `U32.land _ U32.zero` so dual-param
`addr` stays on the EmitC result path. Status remains length-class only (probe never
contributes a nonzero bit). Does not require magic match. -/
public unsafe def validate (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n magicLen) err
    (U32.land (loadAt addr USize.zero) U32.zero)

/-- Alias of `validate`. -/
public unsafe def scan (addr : USize) (n : USize) : U32 :=
  validate addr n

/-- `1` if first 4 bytes match LZ4 frame magic LE `0x184D2204`, else `0` (or short). -/
public unsafe def hasMagic (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n magicLen) U32.zero
    (bifU32 (U32.beq (loadAt addr USize.zero) magic0)
      (bifU32 (U32.beq (loadAt addr off1) magic1)
        (bifU32 (U32.beq (loadAt addr off2) magic2)
          (bifU32 (U32.beq (loadAt addr off3) magic3) U32.one U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)

/-- FLG byte at offset 4 when `n ≥ 7`, else `0`. -/
public unsafe def frameFlags (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n flagsLen) U32.zero
    (loadAt addr offFlags)

/-- LE block size at `off` as `USize` when `off + 4 ≤ n`, else miss (**LP64**).

Does not interpret compressed/uncompressed high bits of the LZ4 block size field. -/
public unsafe def blockSizeAt (addr : USize) (n : USize) (off : USize) : USize :=
  bifUSize (USize.blt n (USize.add off fourUSize)) USize.neg1
    (USize.ofU32 (loadU32LE addr off (USize.add off off1) (USize.add off off2)
      (USize.add off off3)))

end Systems.Lz4
