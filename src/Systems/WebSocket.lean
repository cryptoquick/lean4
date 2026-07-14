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
# Systems.WebSocket (Systems Lean)

WebSocket-**shaped** min-2 frame header parse over dual caller `addr`/`len` byte
views — not a full WebSocket stack, not masking-key/payload product, not TLS/HTTP
upgrade handshake (RFC 6455-shaped).

Wire layout (minimum **2** header bytes when payload length is 7-bit form):

| Offset | Size | Field |
|--------|------|-------|
| 0 | 1 | FIN(1) \| RSV(3) \| opcode(4) |
| 1 | 1 | MASK(1) \| payload len (7 bits) |

Ops:

* **validate** / **parse** — `0` if `n ≥ 2`, else `1` (too short); when long enough,
  probes first byte and folds it with `land 0` so dual-param `addr` is live
* **fin** — high bit of byte0 (`1` if set), or `0` if short
* **opcode** — low nibble of byte0 (`0..15`), or `0` if short
* **masked** — high bit of byte1 (`1` if set), or `0` if short
* **payloadLen7** — low 7 bits of byte1 as `USize` when `< 126`, else miss; also miss if short
* **isControl** — `1` if opcode ≥ 8, else `0` (or short)

Honesty:

* **Min-2 header offsets only** — no extended 16/64-bit payload length, no masking
  key, no payload walk, no fragmentation reassembly, no close status, not a
  WebSocket client/server or HTTP upgrade product.
* **validate status is length-class only** (`ok`/`err`); the first-byte probe never
  changes the status value (`land` with zero) but keeps `addr` on the EmitC result path
  when `n ≥ 2`. Opcode/RSV legality is not enforced.
* **loadAt dual-param honesty:** every load index is under `i < n` after the min-2
  fence. `loadAt` is **not** bounds-parameterized.

## Intentional TCB (WebSocket-local)

Header length, masks/shifts, field offsets, control-opcode floor, and `USize.ofU32`
are freestanding `@[extern]` axioms kept **here**. Name-pinned on ComplianceCorpus
(`path name=Ident`). Byte loads reuse `Scalars`/`Bytes`; shift/and reuse `Numerics`.
-/

namespace Systems.WebSocket

open Systems.Scalars
open Systems.Bytes
open Systems.Status
open Systems.Numerics

/-- WebSocket frame header minimum length (2). -/
@[extern c inline "((size_t)2)"] public axiom headerLen : USize
/-- FIN / MASK high-bit mask (`0x80` = 128). -/
@[extern c inline "((uint32_t)128)"] public axiom maskHi : U32
/-- Opcode nibble mask (`0x0F` = 15). -/
@[extern c inline "((uint32_t)15)"] public axiom maskOpcode : U32
/-- 7-bit payload-length mask (`0x7F` = 127). -/
@[extern c inline "((uint32_t)127)"] public axiom maskLen7 : U32
/-- Exclusive ceiling for 7-bit payload form (`126`). -/
@[extern c inline "((uint32_t)126)"] public axiom len7Ceil : U32
/-- Control-frame opcode floor (`8`). -/
@[extern c inline "((uint32_t)8)"] public axiom controlFloor : U32
/-- Offset of second header byte (1). -/
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
contributes a nonzero bit). Does not inspect extended length / masking key / payload. -/
public unsafe def validate (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) err
    (U32.land (loadAt addr USize.zero) U32.zero)

/-- Alias of `validate`. -/
public unsafe def parse (addr : USize) (n : USize) : U32 :=
  validate addr n

/-- FIN bit of byte0 (`1` if set), or `0` if `n < 2`. -/
public unsafe def fin (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (bifU32 (U32.beq (U32.land (loadAt addr USize.zero) maskHi) U32.zero)
      U32.zero U32.one)

/-- Opcode (low nibble of byte0), or `0` if `n < 2`. -/
public unsafe def opcode (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (U32.land (loadAt addr USize.zero) maskOpcode)

/-- MASK bit of byte1 (`1` if set), or `0` if `n < 2`. -/
public unsafe def masked (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (bifU32 (U32.beq (U32.land (loadAt addr off1) maskHi) U32.zero)
      U32.zero U32.one)

/-- Payload length (low 7 bits of byte1) when 7-bit form (`< 126`), else miss.

Returns `USize.ofU32 len7` when `n ≥ 2` and `len7 < 126`; else `USize.neg1`
(**LP64 miss**). Extended 16/64-bit length forms are intentionally omitted. -/
public unsafe def payloadLen7 (addr : USize) (n : USize) : USize :=
  bifUSize (USize.blt n headerLen) USize.neg1
    (let b := U32.land (loadAt addr off1) maskLen7
     bifUSize (U32.blt b len7Ceil) (USize.ofU32 b) USize.neg1)

/-- `1` if opcode ≥ 8 (control-frame shaped), else `0` (or short). -/
public unsafe def isControl (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (bifU32 (U32.blt (U32.land (loadAt addr USize.zero) maskOpcode) controlFloor)
      U32.zero U32.one)

end Systems.WebSocket
