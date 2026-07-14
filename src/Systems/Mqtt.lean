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
# Systems.Mqtt (Systems Lean)

MQTT-**shaped** fixed-header min-2-byte parse over dual caller `addr`/`len` byte
views — not a full MQTT 3.1.1/5.0 stack, not QoS/session state, not TLS.

Fixed header (MQTT-shaped; **2** bytes when remaining length is a single byte):

| Offset | Size | Field |
|--------|------|-------|
| 0 | 1 | type (high 4 bits) \| flags (low 4 bits) |
| 1 | 1 | remaining length (single-byte form if `< 128`) |

Ops:

* **validate** / **parse** — `0` if `n ≥ 2`, else `1` (too short); when long enough,
  probes first byte and folds it with `land 0` so dual-param `addr` is live
* **pktType** — high nibble of byte0 as `U32` (`0..15`), or `0` if short
* **flags** — low nibble of byte0 as `U32`, or `0` if short
* **remainingLenSmall** — byte1 as `USize` when `< 128`, else miss (`USize.neg1`);
  also miss if short

Honesty:

* **Min fixed-header offsets only** — no multi-byte remaining-length varint product,
  no variable header / payload decode, no CONNECT/PUBLISH body, no QoS/session,
  no MQTT 5 properties, not a broker or client stack.
* **validate status is length-class only** (`ok`/`err`); the first-byte probe never
  changes the status value (`land` with zero) but keeps `addr` on the EmitC result path
  when `n ≥ 2`. Packet-type/flags legality is not enforced.
* **loadAt dual-param honesty:** every load index is under `i < n` after the min-2
  fence. `loadAt` is **not** bounds-parameterized.

## Intentional TCB (Mqtt-local)

Header length, nibble shift/mask, single-byte varint ceiling, and field offsets are
freestanding `@[extern]` axioms kept **here**. Name-pinned on ComplianceCorpus
(`path name=Ident`). Byte loads reuse `Scalars`/`Bytes`; shift/and reuse `Numerics`.
-/

namespace Systems.Mqtt

open Systems.Scalars
open Systems.Bytes
open Systems.Status
open Systems.Numerics

/-- MQTT fixed-header minimum length (2). -/
@[extern c inline "((size_t)2)"] public axiom headerLen : USize
/-- Shift amount 4 for packet type high nibble. -/
@[extern c inline "((uint32_t)4)"] public axiom fourU32 : U32
/-- Nibble mask (`0x0F` = 15). -/
@[extern c inline "((uint32_t)15)"] public axiom maskNibble : U32
/-- Single-byte remaining-length exclusive ceiling (`0x80` = 128). -/
@[extern c inline "((uint32_t)128)"] public axiom varintCeil : U32
/-- Offset of remaining-length byte (1). -/
@[extern c inline "((size_t)1)"] public axiom off1 : USize
/-- Widen `U32` → `USize`. -/
@[extern c inline "((size_t)(uint32_t)(#1))"]
public axiom USize.ofU32 : U32 → USize

/-- Load byte at index as `U32`. Caller ensures `i < n`. -/
public unsafe def loadAt (addr : USize) (i : USize) : U32 :=
  U32.ofU8 (U8.load (USize.add addr i))

/-- `0` if `n ≥ 2`, else `1`.

When `n ≥ 2`, loads first byte and folds it with `U32.land _ U32.zero` so dual-param
`addr` stays on the EmitC result path. Status remains length-class only (probe never
contributes a nonzero bit). Does not decode remaining-length multi-byte form or body. -/
public unsafe def validate (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) err
    (U32.land (loadAt addr USize.zero) U32.zero)

/-- Alias of `validate`. -/
public unsafe def parse (addr : USize) (n : USize) : U32 :=
  validate addr n

/-- Packet type (high nibble of byte0), or `0` if `n < 2`. -/
public unsafe def pktType (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (U32.land (U32.shiftRight (loadAt addr USize.zero) fourU32) maskNibble)

/-- Flags (low nibble of byte0), or `0` if `n < 2`. -/
public unsafe def flags (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (U32.land (loadAt addr USize.zero) maskNibble)

/-- Remaining length (byte1) when single-byte form (`< 128`), else miss.

Returns `USize.ofU32 byte1` when `n ≥ 2` and `byte1 < 128`; else `USize.neg1`
(**LP64 miss**). Multi-byte MQTT remaining-length encoding is intentionally omitted. -/
public unsafe def remainingLenSmall (addr : USize) (n : USize) : USize :=
  bifUSize (USize.blt n headerLen) USize.neg1
    (let b := loadAt addr off1
     bifUSize (U32.blt b varintCeil) (USize.ofU32 b) USize.neg1)

end Systems.Mqtt
