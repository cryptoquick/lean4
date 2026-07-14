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
# Systems.Coap (Systems Lean)

CoAP-**shaped** min-4 header parse over dual caller `addr`/`len` byte views — not a
full CoAP stack, not options/payload markers, not DTLS/Observe.

Wire layout (RFC 7252-shaped; minimum **4** header bytes, network byte order):

| Offset | Size | Field |
|--------|------|-------|
| 0 | 1 | Ver(2) \| T(2) \| TKL(4) |
| 1 | 1 | Code |
| 2–3 | 2 | Message ID (BE) |

Ops:

* **validate** / **parse** — `0` if `n ≥ 4`, else `1` (too short); when long enough,
  probes first byte and folds it with `land 0` so dual-param `addr` is live
* **version** — high 2 bits of byte0 (`0..3`), or `0` if short
* **type** — bits 5–4 of byte0 (`0..3` CON/NON/ACK/RST-shaped), or `0` if short
* **tokenLen** — low 4 bits of byte0 (`0..15`), or `0` if short
* **code** — byte1 as `U32`, or `0` if short
* **msgId** — big-endian `U16` at offsets 2–3 as `U32`, or `0` if short

Honesty:

* **Min header offsets only** — no Token body, no Option delta/length product, no
  payload marker `0xFF`, no block-wise, no Observe, no DTLS, not a CoAP client/server.
* **validate status is length-class only** (`ok`/`err`); the first-byte probe never
  changes the status value (`land` with zero) but keeps `addr` on the EmitC result path
  when `n ≥ 4`. Version/`TKL` legality is not enforced.
* **loadAt dual-param honesty:** every load index is under `i < n` after the min-4
  fence. `loadAt` is **not** bounds-parameterized.

## Intentional TCB (Coap-local)

Header length, masks/shifts, field offsets, and BE shift amount are freestanding
`@[extern]` axioms kept **here**. Name-pinned on ComplianceCorpus (`path name=Ident`).
Byte loads reuse `Scalars`/`Bytes`; shift/or/and reuse `Numerics`.
-/

namespace Systems.Coap

open Systems.Scalars
open Systems.Bytes
open Systems.Status
open Systems.Numerics

/-- CoAP header minimum length (4). -/
@[extern c inline "((size_t)4)"] public axiom headerLen : USize
/-- Shift amount 6 for version high 2 bits. -/
@[extern c inline "((uint32_t)6)"] public axiom sixU32 : U32
/-- Shift amount 4 for type bits 5–4. -/
@[extern c inline "((uint32_t)4)"] public axiom fourU32 : U32
/-- Shift amount 8 for big-endian `U16` high byte. -/
@[extern c inline "((uint32_t)8)"] public axiom eightU32 : U32
/-- Version / type 2-bit mask (`0x03` = 3). -/
@[extern c inline "((uint32_t)3)"] public axiom mask2 : U32
/-- Token-length nibble mask (`0x0F` = 15). -/
@[extern c inline "((uint32_t)15)"] public axiom maskTkl : U32
/-- Offset of Code byte (1). -/
@[extern c inline "((size_t)1)"] public axiom offCode : USize
/-- Offset of Message ID high byte (2). -/
@[extern c inline "((size_t)2)"] public axiom offMsgId : USize
/-- Offset of Message ID low byte (3). -/
@[extern c inline "((size_t)3)"] public axiom offMsgIdLo : USize

/-- Load byte at index as `U32`. Caller ensures `i < n`. -/
public unsafe def loadAt (addr : USize) (i : USize) : U32 :=
  U32.ofU8 (U8.load (USize.add addr i))

/-- Big-endian `U16` at `hiOff`/`loOff` as `U32`. Caller ensures both indices in range. -/
public unsafe def loadU16BE (addr : USize) (hiOff : USize) (loOff : USize) : U32 :=
  U32.lor (U32.shiftLeft (loadAt addr hiOff) eightU32) (loadAt addr loOff)

/-- `0` if `n ≥ 4`, else `1`.

When `n ≥ 4`, loads first byte and folds it with `U32.land _ U32.zero` so dual-param
`addr` stays on the EmitC result path. Status remains length-class only (probe never
contributes a nonzero bit). Does not inspect Token/Options/payload past the min fence. -/
public unsafe def validate (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) err
    (U32.land (loadAt addr USize.zero) U32.zero)

/-- Alias of `validate`. -/
public unsafe def parse (addr : USize) (n : USize) : U32 :=
  validate addr n

/-- Version (high 2 bits of byte0), or `0` if `n < 4`. -/
public unsafe def version (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (U32.land (U32.shiftRight (loadAt addr USize.zero) sixU32) mask2)

/-- Type (bits 5–4 of byte0: CON/NON/ACK/RST-shaped), or `0` if `n < 4`. -/
public unsafe def type (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (U32.land (U32.shiftRight (loadAt addr USize.zero) fourU32) mask2)

/-- Token length (low 4 bits of byte0), or `0` if `n < 4`. -/
public unsafe def tokenLen (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (U32.land (loadAt addr USize.zero) maskTkl)

/-- Code (byte1), or `0` if `n < 4`. -/
public unsafe def code (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (loadAt addr offCode)

/-- Message ID (bytes 2–3 BE) as `U32`, or `0` if `n < 4`. -/
public unsafe def msgId (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (loadU16BE addr offMsgId offMsgIdLo)

end Systems.Coap
