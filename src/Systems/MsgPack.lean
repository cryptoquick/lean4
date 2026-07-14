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
# Systems.MsgPack (Systems Lean)

MessagePack-**shaped** first-byte family scan over dual caller `addr`/`len` byte views —
not a full MessagePack codec, not nested container walk, not all extension types.

First-byte families (MessagePack marker layout; shaped, not full type graph):

| Family | Marker range | Meaning |
|--------|--------------|---------|
| 0 | `0x00..0x7F` | positive fixint (value = byte) |
| 1 | `0x80..0x8F` | fixmap (`n = b & 0x0F`) |
| 2 | `0x90..0x9F` | fixarray (`n = b & 0x0F`) |
| 3 | `0xA0..0xBF` | fixstr (`n = b & 0x1F`) |
| 4 | `0xC0..0xDF` | mid markers (nil/bool/bin/ext/float/int/str/array/map) |
| 5 | `0xE0..0xFF` | negative fixint |

Ops:

* **validate** / **scan** — `0` if `n ≥ 1`, else `1` (empty); when long enough, probes
  the first byte and folds it with `land 0` so dual-param `addr` stays live
* **family** — first-byte family as `USize` (`0..5`), or miss if empty
* **marker** — first byte as `U32` (0 if empty)
* **posIntSmall** — if first byte is positive fixint (`0x00..0x7F`), return that value
  as `USize`; else miss

Honesty:

* **Shaped first-byte scan only** — no multi-byte length decode, no nested map/array walk,
  no extension type product, no timestamp/ext decode, no full MessagePack encode/decode.
* Bin markers (`0xC4..0xC6`) sit in family 4 (mid) with other control markers.
* **validate status is length-class only** (`ok`/`err`); the first-byte probe never
  changes the status value (`land` with zero) but keeps `addr` on the EmitC result path
  when `n ≥ 1`.
* **loadAt dual-param honesty:** every load index is under `i < n` after length fences.
  `loadAt` is **not** bounds-parameterized.

## Intentional TCB (MsgPack-local)

Family range ceilings and `USize.ofU32` are freestanding `@[extern]` axioms kept **here**.
Name-pinned on ComplianceCorpus (`path name=Ident`). Byte loads reuse `Scalars`/`Bytes`;
compare/branch reuse `Numerics`/`Status`.
-/

namespace Systems.MsgPack

open Systems.Scalars
open Systems.Bytes
open Systems.Status
open Systems.Numerics

/-- Positive-fixint exclusive ceiling (`0x80` = 128). -/
@[extern c inline "((uint32_t)128)"] public axiom ceilPosFix : U32
/-- Fixmap exclusive ceiling (`0x90` = 144). -/
@[extern c inline "((uint32_t)144)"] public axiom ceilFixMap : U32
/-- Fixarray exclusive ceiling (`0xA0` = 160). -/
@[extern c inline "((uint32_t)160)"] public axiom ceilFixArray : U32
/-- Fixstr exclusive ceiling (`0xC0` = 192). -/
@[extern c inline "((uint32_t)192)"] public axiom ceilFixStr : U32
/-- Mid-marker exclusive ceiling (`0xE0` = 224). -/
@[extern c inline "((uint32_t)224)"] public axiom ceilMid : U32
/-- Family code constants as `USize` (return path for `family`). -/
@[extern c inline "((size_t)0)"] public axiom famPosFix : USize
@[extern c inline "((size_t)1)"] public axiom famFixMap : USize
@[extern c inline "((size_t)2)"] public axiom famFixArray : USize
@[extern c inline "((size_t)3)"] public axiom famFixStr : USize
@[extern c inline "((size_t)4)"] public axiom famMid : USize
@[extern c inline "((size_t)5)"] public axiom famNegFix : USize
/-- Widen `U32` → `USize`. -/
@[extern c inline "((size_t)(uint32_t)(#1))"]
public axiom USize.ofU32 : U32 → USize

/-- Load byte at index as `U32`. Caller ensures `i < n`. -/
public unsafe def loadAt (addr : USize) (i : USize) : U32 :=
  U32.ofU8 (U8.load (USize.add addr i))

/-- `0` if `n ≥ 1`, else `1`.

When `n ≥ 1`, loads first byte and folds it with `U32.land _ U32.zero` so dual-param
`addr` stays on the EmitC result path. Status remains length-class only (probe never
contributes a nonzero bit). Does not decode multi-byte lengths or nested items. -/
public unsafe def validate (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq n USize.zero) err
    (U32.land (loadAt addr USize.zero) U32.zero)

/-- Alias of `validate`. -/
public unsafe def scan (addr : USize) (n : USize) : U32 :=
  validate addr n

/-- First-byte family as `USize` (`0..5`), or `USize.neg1` if empty. **LP64 miss**.

Classification is dual-param/live-load only (no pure closed family decision tree). -/
public unsafe def family (addr : USize) (n : USize) : USize :=
  bifUSize (USize.beq n USize.zero) USize.neg1
    (let b := loadAt addr USize.zero
     bifUSize (U32.blt b ceilPosFix) famPosFix
       (bifUSize (U32.blt b ceilFixMap) famFixMap
         (bifUSize (U32.blt b ceilFixArray) famFixArray
           (bifUSize (U32.blt b ceilFixStr) famFixStr
             (bifUSize (U32.blt b ceilMid) famMid famNegFix)))))

/-- First-byte marker as `U32`, or `0` if empty. -/
public unsafe def marker (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq n USize.zero) U32.zero (loadAt addr USize.zero)

/-- Positive fixint value (`0x00..0x7F`) at the first byte as `USize`.

Returns the value, or `USize.neg1` if empty / not positive fixint. **LP64 miss**. -/
public unsafe def posIntSmall (addr : USize) (n : USize) : USize :=
  bifUSize (USize.beq n USize.zero) USize.neg1
    (let b := loadAt addr USize.zero
     bifUSize (U32.blt b ceilPosFix) (USize.ofU32 b) USize.neg1)

end Systems.MsgPack
