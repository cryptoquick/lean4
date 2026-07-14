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
# Systems.Protobuf (Systems Lean)

Protobuf-**shaped** wire key / small-varint scan over dual caller `addr`/`len` byte
views — not a full protobuf codec, not all wire types, not schema / reflection.

Wire key layout (protobuf-shaped; single-byte key when high bit clear):

| Bits | Field |
|------|-------|
| 2–0 | wire type (`0..7`; common: 0=varint, 1=64-bit, 2=len-delim, 5=32-bit) |
| 7–3 | field number (for single-byte keys: `1..15`) |

Ops:

* **validate** / **scan** — `0` if `n ≥ 1`, else `1` (empty); when long enough, probes
  the first byte and folds it with `land 0` so dual-param `addr` stays live
* **fieldKey** — raw key byte at `off` as `U32` (0 if `off ≥ n`)
* **wireType** — low 3 bits of key at `off` as `U32` (0 if `off ≥ n`)
* **fieldNumber** — if key at `off` is a single-byte varint (`b < 128`), return
  `b >> 3` as `USize`; else miss (empty / multi-byte continuation)
* **varintSmall** — if the first byte is a single-byte varint (`b < 128`), return
  that value as `USize`; else miss

Honesty:

* **Shaped wire key / small-varint scan only** — no multi-byte varint product, no
  length-delimited payload walk, no packed repeated, no zig-zag, no schema /
  message graph, no full encode/decode, not all wire-type payload decoders.
* **validate status is length-class only** (`ok`/`err`); the first-byte probe never
  changes the status value (`land` with zero) but keeps `addr` on the EmitC result path
  when `n ≥ 1`.
* **loadAt dual-param honesty:** every load index is under `i < n` after length fences.
  `loadAt` is **not** bounds-parameterized.

## Intentional TCB (Protobuf-local)

Wire-type mask, field-number shift, single-byte varint ceiling, and `USize.ofU32` are
freestanding `@[extern]` axioms kept **here**. Name-pinned on ComplianceCorpus
(`path name=Ident`). Byte loads reuse `Scalars`/`Bytes`; shift/and reuse `Numerics`.
-/

namespace Systems.Protobuf

open Systems.Scalars
open Systems.Bytes
open Systems.Status
open Systems.Numerics

/-- Wire-type mask (`0x07` = 7). -/
@[extern c inline "((uint32_t)7)"] public axiom maskWire : U32
/-- Field-number shift (3): `field = key >> 3`. -/
@[extern c inline "((uint32_t)3)"] public axiom threeU32 : U32
/-- Single-byte varint exclusive ceiling (`0x80` = 128). -/
@[extern c inline "((uint32_t)128)"] public axiom varintCeil : U32
/-- Widen `U32` → `USize`. -/
@[extern c inline "((size_t)(uint32_t)(#1))"]
public axiom USize.ofU32 : U32 → USize

/-- Load byte at index as `U32`. Caller ensures `i < n`. -/
public unsafe def loadAt (addr : USize) (i : USize) : U32 :=
  U32.ofU8 (U8.load (USize.add addr i))

/-- Wire type of a key byte (`b & 0x07`). -/
@[inline] public def wireOf (b : U32) : U32 :=
  U32.land b maskWire

/-- Field number of a single-byte key (`b >> 3`). -/
@[inline] public def fieldOf (b : U32) : U32 :=
  U32.shiftRight b threeU32

/-- `0` if `n ≥ 1`, else `1`.

When `n ≥ 1`, loads first byte and folds it with `U32.land _ U32.zero` so dual-param
`addr` stays on the EmitC result path. Status remains length-class only (probe never
contributes a nonzero bit). Does not decode multi-byte varints or nested fields. -/
public unsafe def validate (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq n USize.zero) err
    (U32.land (loadAt addr USize.zero) U32.zero)

/-- Alias of `validate`. -/
public unsafe def scan (addr : USize) (n : USize) : U32 :=
  validate addr n

/-- Raw field-key byte at `off` as `U32`, or `0` if `off ≥ n`. -/
public unsafe def fieldKey (addr : USize) (n : USize) (off : USize) : U32 :=
  bifU32 (USize.blt off n) (loadAt addr off) U32.zero

/-- Wire type (low 3 bits) at `off`, or `0` if `off ≥ n`. -/
public unsafe def wireType (addr : USize) (n : USize) (off : USize) : U32 :=
  bifU32 (USize.blt off n) (wireOf (loadAt addr off)) U32.zero

/-- Field number from a single-byte key at `off` as `USize`.

Returns `key >> 3`, or `USize.neg1` if `off ≥ n` / multi-byte continuation (`b ≥ 128`).
**LP64 miss**. -/
public unsafe def fieldNumber (addr : USize) (n : USize) (off : USize) : USize :=
  bifUSize (USize.blt off n)
    (let b := loadAt addr off
     bifUSize (U32.blt b varintCeil) (USize.ofU32 (fieldOf b)) USize.neg1)
    USize.neg1

/-- Single-byte varint value at the first byte as `USize`.

Returns the value (`0..127`), or `USize.neg1` if empty / multi-byte continuation.
**LP64 miss**. -/
public unsafe def varintSmall (addr : USize) (n : USize) : USize :=
  bifUSize (USize.beq n USize.zero) USize.neg1
    (let b := loadAt addr USize.zero
     bifUSize (U32.blt b varintCeil) (USize.ofU32 b) USize.neg1)

end Systems.Protobuf
