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
# Systems.Avro (Systems Lean)

Avro-**shaped** binary scan over dual caller `addr`/`len` byte views — not a full
Avro schema/codec, not block/object container, not schema resolution.

Shaped first-byte families (Apache Avro binary encoding; residual-clean subset):

| Marker | Meaning (shaped) |
|--------|------------------|
| `0x00` / `0x01` | boolean false / true (also null/int zero edge cases) |
| `0x00..0x7F` | single-byte zigzag varint (int/long/string length prefix) |
| `≥ 0x80` | multi-byte continuation (not decoded) |

Ops:

* **validate** / **scan** — `0` if `n ≥ 1`, else `1` (empty); when long enough, probes
  the first byte and folds it with `land 0` so dual-param `addr` stays live
* **marker** — first byte as `U32` (0 if empty)
* **boolSmall** — if first byte is `0` or `1`, return that value as `USize`; else miss
* **zigzagNonnegSmall** — if first byte is a single-byte non-negative zigzag
  (`b < 128` and even), return `b >> 1` as `USize` (covers non-neg int and string
  length-prefix); else miss
* **varintSmall** — if first byte is a single-byte varint (`b < 128`), return that
  raw value as `USize`; else miss

Honesty:

* **Shaped first-byte / small zigzag scan only** — no multi-byte varint product, no
  schema graph, no record/union/map walk, no block/object container, no full
  encode/decode, not Avro IDL.
* **validate status is length-class only** (`ok`/`err`); the first-byte probe never
  changes the status value (`land` with zero) but keeps `addr` on the EmitC result path
  when `n ≥ 1`.
* **loadAt dual-param honesty:** every load index is under `i < n` after length fences.
  `loadAt` is **not** bounds-parameterized.

## Intentional TCB (Avro-local)

Single-byte varint ceiling, bool ceiling, one-bit shift/mask, and `USize.ofU32` are
freestanding `@[extern]` axioms kept **here**. Name-pinned on ComplianceCorpus
(`path name=Ident`). Byte loads reuse `Scalars`/`Bytes`; shift/and reuse `Numerics`.
-/

namespace Systems.Avro

open Systems.Scalars
open Systems.Bytes
open Systems.Status
open Systems.Numerics

/-- Single-byte varint exclusive ceiling (`0x80` = 128). -/
@[extern c inline "((uint32_t)128)"] public axiom varintCeil : U32
/-- Boolean exclusive ceiling (`0x02` = 2): markers `0`/`1` only. -/
@[extern c inline "((uint32_t)2)"] public axiom boolCeil : U32
/-- Shift amount 1 for zigzag half / parity. -/
@[extern c inline "((uint32_t)1)"] public axiom oneU32 : U32
/-- Parity mask (`0x01`). -/
@[extern c inline "((uint32_t)1)"] public axiom maskParity : U32
/-- Widen `U32` → `USize`. -/
@[extern c inline "((size_t)(uint32_t)(#1))"]
public axiom USize.ofU32 : U32 → USize

/-- Load byte at index as `U32`. Caller ensures `i < n`. -/
public unsafe def loadAt (addr : USize) (i : USize) : U32 :=
  U32.ofU8 (U8.load (USize.add addr i))

/-- `0` if `n ≥ 1`, else `1`.

When `n ≥ 1`, loads first byte and folds it with `U32.land _ U32.zero` so dual-param
`addr` stays on the EmitC result path. Status remains length-class only (probe never
contributes a nonzero bit). Does not decode multi-byte varints or schema graphs. -/
public unsafe def validate (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq n USize.zero) err
    (U32.land (loadAt addr USize.zero) U32.zero)

/-- Alias of `validate`. -/
public unsafe def scan (addr : USize) (n : USize) : U32 :=
  validate addr n

/-- First-byte marker as `U32`, or `0` if empty. -/
public unsafe def marker (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq n USize.zero) U32.zero (loadAt addr USize.zero)

/-- Boolean small decode: first byte `0` or `1` as `USize`.

Returns the value, or `USize.neg1` if empty / not a single-byte boolean. **LP64 miss**. -/
public unsafe def boolSmall (addr : USize) (n : USize) : USize :=
  bifUSize (USize.beq n USize.zero) USize.neg1
    (let b := loadAt addr USize.zero
     bifUSize (U32.blt b boolCeil) (USize.ofU32 b) USize.neg1)

/-- Non-negative zigzag small decode (single-byte even varint → `b >> 1`).

Avro int/long/string-length zigzag: non-negative values encode as even bytes. Returns
the decoded magnitude as `USize`, or `USize.neg1` if empty / multi-byte / odd (negative
shaped). **LP64 miss**. -/
public unsafe def zigzagNonnegSmall (addr : USize) (n : USize) : USize :=
  bifUSize (USize.beq n USize.zero) USize.neg1
    (let b := loadAt addr USize.zero
     bifUSize (U32.blt b varintCeil)
       (bifUSize (U32.beq (U32.land b maskParity) U32.zero)
         (USize.ofU32 (U32.shiftRight b oneU32))
         USize.neg1)
       USize.neg1)

/-- Single-byte varint raw value at the first byte as `USize`.

Returns the value (`0..127`), or `USize.neg1` if empty / multi-byte continuation.
**LP64 miss**. -/
public unsafe def varintSmall (addr : USize) (n : USize) : USize :=
  bifUSize (USize.beq n USize.zero) USize.neg1
    (let b := loadAt addr USize.zero
     bifUSize (U32.blt b varintCeil) (USize.ofU32 b) USize.neg1)

end Systems.Avro
