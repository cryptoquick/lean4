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
# Systems.Matroska (Systems Lean)

Matroska/EBML-**shaped** header magic + element ID/size class scan over dual caller
`addr`/`len` byte views — not a full Matroska demux, not codec/track product,
not cluster/block walk, not DocType string product.

EBML prefix (RFC 8794-shaped; EBML element ID magic BE `0x1A45DFA3`; minimum **4**
magic bytes; optional size VINT class at offset 4 when `n ≥ 5`):

| Offset | Size | Field |
|--------|------|-------|
| 0–3 | 4 | EBML element ID BE (`1A 45 DF A3`) |
| 4 | 1 | first byte of EBML size VINT (when present) |

Ops:

* **validate** / **scan** — `0` if `n ≥ 4`, else `1` (too short); when long enough,
  probes first byte and folds it with `land 0` so dual-param `addr` is live
* **hasMagic** — `1` if first 4 BE bytes match EBML magic, else `0` (or short)
* **magicBe** — first 4 bytes as BE `U32` → `USize`, or miss if short
* **idClass** — VINT width class of byte0 (`1..4`), or `0` if short / unsupported
* **sizeClass** — VINT width class of byte at offset 4 when `n ≥ 5`, else `0`
* **fieldBeAt** — BE `U32` at `off` as `USize` when `off + 4 ≤ n`, else miss

Honesty:

* **Magic + ID/size VINT class only** — no nested element walk, no DocType string
  match, no cluster/block demux, not a Matroska product.
* **validate status is length-class only** (`ok`/`err`); the first-byte probe never
  changes the status value (`land` with zero) but keeps `addr` on the EmitC result path
  when `n ≥ 4`. Magic match is **not** required by validate.
* **loadAt dual-param honesty:** every load index is under `i < n` after fences.
  `loadAt` is **not** bounds-parameterized.

## Intentional TCB (Matroska-local)

Magic bytes, min lengths, BE shift amounts, per-byte offsets, VINT class masks, and
`USize.ofU32` are freestanding `@[extern]` axioms kept **here**. Name-pinned on
ComplianceCorpus (`path name=Ident`). Byte loads reuse `Scalars`/`Bytes`; shift/or/and
reuse `Numerics`.
-/

namespace Systems.Matroska

open Systems.Scalars
open Systems.Bytes
open Systems.Status
open Systems.Numerics

/-- EBML magic minimum length (4). -/
@[extern c inline "((size_t)4)"] public axiom magicLen : USize
/-- Length needed for size VINT first byte at offset 4 (`5` shaped). -/
@[extern c inline "((size_t)5)"] public axiom sizeClassLen : USize
/-- Magic BE byte0 (`0x1A` = 26). -/
@[extern c inline "((uint32_t)26)"] public axiom magic0 : U32
/-- Magic BE byte1 (`0x45` = 69). -/
@[extern c inline "((uint32_t)69)"] public axiom magic1 : U32
/-- Magic BE byte2 (`0xDF` = 223). -/
@[extern c inline "((uint32_t)223)"] public axiom magic2 : U32
/-- Magic BE byte3 (`0xA3` = 163). -/
@[extern c inline "((uint32_t)163)"] public axiom magic3 : U32
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
/-- Offset of first size-VINT byte (4). -/
@[extern c inline "((size_t)4)"] public axiom offSize : USize
/-- Four as `USize` (BE field width). -/
@[extern c inline "((size_t)4)"] public axiom fourUSize : USize
/-- VINT class-1 mask (`0x80` = 128). -/
@[extern c inline "((uint32_t)128)"] public axiom maskC1 : U32
/-- VINT class-2 mask (`0x40` = 64). -/
@[extern c inline "((uint32_t)64)"] public axiom maskC2 : U32
/-- VINT class-3 mask (`0x20` = 32). -/
@[extern c inline "((uint32_t)32)"] public axiom maskC3 : U32
/-- VINT class-4 mask (`0x10` = 16). -/
@[extern c inline "((uint32_t)16)"] public axiom maskC4 : U32
/-- Class width 1. -/
@[extern c inline "((uint32_t)1)"] public axiom class1 : U32
/-- Class width 2. -/
@[extern c inline "((uint32_t)2)"] public axiom class2 : U32
/-- Class width 3. -/
@[extern c inline "((uint32_t)3)"] public axiom class3 : U32
/-- Class width 4. -/
@[extern c inline "((uint32_t)4)"] public axiom class4 : U32
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

/-- EBML/VINT width class of leading byte: `1..4`, or `0` if unsupported. -/
public unsafe def vintClass (b : U32) : U32 :=
  bifU32 (U32.beq (U32.land b maskC1) U32.zero)
    (bifU32 (U32.beq (U32.land b maskC2) U32.zero)
      (bifU32 (U32.beq (U32.land b maskC3) U32.zero)
        (bifU32 (U32.beq (U32.land b maskC4) U32.zero) U32.zero class4)
        class3)
      class2)
    class1

/-- `0` if `n ≥ 4`, else `1`.

When `n ≥ 4`, loads first byte and folds it with `U32.land _ U32.zero` so dual-param
`addr` stays on the EmitC result path. Status remains length-class only (probe never
contributes a nonzero bit). Does not require EBML magic match. -/
public unsafe def validate (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n magicLen) err
    (U32.land (loadAt addr USize.zero) U32.zero)

/-- Alias of `validate`. -/
public unsafe def scan (addr : USize) (n : USize) : U32 :=
  validate addr n

/-- `1` if first 4 bytes match EBML magic BE `0x1A45DFA3`, else `0` (or short). -/
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

/-- VINT width class of element ID first byte (`1..4`), or `0` if short / unsupported. -/
public unsafe def idClass (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n magicLen) U32.zero
    (vintClass (loadAt addr USize.zero))

/-- VINT width class of size byte at offset 4 when `n ≥ 5`, else `0`. -/
public unsafe def sizeClass (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n sizeClassLen) U32.zero
    (vintClass (loadAt addr offSize))

/-- BE field `U32` at `off` as `USize` when `off + 4 ≤ n`, else miss (**LP64**).

Shaped for raw BE dwords after the magic; does not decode VINT payload values. -/
public unsafe def fieldBeAt (addr : USize) (n : USize) (off : USize) : USize :=
  bifUSize (USize.blt n (USize.add off fourUSize)) USize.neg1
    (USize.ofU32 (loadU32BE addr off (USize.add off off1) (USize.add off off2)
      (USize.add off off3)))

end Systems.Matroska
