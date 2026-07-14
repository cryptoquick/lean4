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
# Systems.Radius (Systems Lean)

RADIUS-**shaped** minimum header parse over dual caller `addr`/`len` byte views —
not a full RADIUS stack, not attribute TLV walk, not EAP/accounting session product.

Wire layout (RFC 2865-shaped; minimum **20** header bytes, network byte order):

| Offset | Size | Field |
|--------|------|-------|
| 0 | 1 | Code |
| 1 | 1 | Identifier |
| 2–3 | 2 | Length (BE) |
| 4–19 | 16 | Authenticator |

Ops:

* **validate** / **parse** — `0` if `n ≥ 20`, else `1` (too short); when long enough,
  probes first byte and folds it with `land 0` so dual-param `addr` is live
* **code** / **identifier** — single-byte fields (`0` if short)
* **length** — big-endian `U16` at offs 2–3 as `U32` (`0` if short)
* **authBe0** — first 4 authenticator bytes (offs 4–7) as BE `U32` → `USize`, or miss
* **isAccessRequest** / **isAccessAccept** / **isAccessReject** — code class helpers

Honesty:

* **Min-20 header fields only** — no attribute Type/Length/Value walk, no shared-secret
  HMAC verify, no RADIUS dictionary, not a RADIUS client/server.
* **validate status is length-class only** (`ok`/`err`); the first-byte probe never
  changes the status value (`land` with zero) but keeps `addr` on the EmitC result path
  when `n ≥ 20`. Code/length legality is **not** enforced by validate.
* **loadAt dual-param honesty:** every load index is under `i < n` after the min-20
  fence. `loadAt` is **not** bounds-parameterized.

## Intentional TCB (Radius-local)

Header size, code class constants, BE shift amounts, field offsets, and `USize.ofU32`
are freestanding `@[extern]` axioms kept **here**. Name-pinned on ComplianceCorpus
(`path name=Ident`). Byte loads reuse `Scalars`/`Bytes`; shift/or reuse `Numerics`.
-/

namespace Systems.Radius

open Systems.Scalars
open Systems.Bytes
open Systems.Status
open Systems.Numerics

/-- Minimum RADIUS header length (20). -/
@[extern c inline "((size_t)20)"] public axiom headerLen : USize
/-- Access-Request code (1). -/
@[extern c inline "((uint32_t)1)"] public axiom codeAccessRequest : U32
/-- Access-Accept code (2). -/
@[extern c inline "((uint32_t)2)"] public axiom codeAccessAccept : U32
/-- Access-Reject code (3). -/
@[extern c inline "((uint32_t)3)"] public axiom codeAccessReject : U32
/-- Shift amount 8 for BE packing. -/
@[extern c inline "((uint32_t)8)"] public axiom eightU32 : U32
/-- Shift amount 16 for mid bytes. -/
@[extern c inline "((uint32_t)16)"] public axiom sixteenU32 : U32
/-- Shift amount 24 for high byte. -/
@[extern c inline "((uint32_t)24)"] public axiom twentyFourU32 : U32
/-- Offset of Identifier (1). -/
@[extern c inline "((size_t)1)"] public axiom offId : USize
/-- Offset of Length high byte (2). -/
@[extern c inline "((size_t)2)"] public axiom offLenHi : USize
/-- Offset of Length low byte (3). -/
@[extern c inline "((size_t)3)"] public axiom offLenLo : USize
/-- Offset of Authenticator byte0 (4). -/
@[extern c inline "((size_t)4)"] public axiom offAuth0 : USize
/-- Offset of Authenticator byte1 (5). -/
@[extern c inline "((size_t)5)"] public axiom offAuth1 : USize
/-- Offset of Authenticator byte2 (6). -/
@[extern c inline "((size_t)6)"] public axiom offAuth2 : USize
/-- Offset of Authenticator byte3 (7). -/
@[extern c inline "((size_t)7)"] public axiom offAuth3 : USize
/-- Widen `U32` → `USize`. -/
@[extern c inline "((size_t)(uint32_t)(#1))"]
public axiom USize.ofU32 : U32 → USize

/-- Load byte at index as `U32`. Caller ensures `i < n`. -/
public unsafe def loadAt (addr : USize) (i : USize) : U32 :=
  U32.ofU8 (U8.load (USize.add addr i))

/-- Big-endian `U16` at `hiOff`/`loOff` as `U32`. Caller ensures both indices in range. -/
public unsafe def loadU16BE (addr : USize) (hiOff : USize) (loOff : USize) : U32 :=
  U32.lor (U32.shiftLeft (loadAt addr hiOff) eightU32) (loadAt addr loOff)

/-- Big-endian `U32` at four explicit offsets. Caller ensures all indices in range. -/
public unsafe def loadU32BE (addr : USize) (b0 : USize) (b1 : USize) (b2 : USize)
    (b3 : USize) : U32 :=
  U32.lor (U32.lor (U32.shiftLeft (loadAt addr b0) twentyFourU32)
      (U32.shiftLeft (loadAt addr b1) sixteenU32))
    (U32.lor (U32.shiftLeft (loadAt addr b2) eightU32)
      (loadAt addr b3))

/-- `0` if `n ≥ 20`, else `1`.

When `n ≥ 20`, loads first byte and folds it with `U32.land _ U32.zero` so dual-param
`addr` stays on the EmitC result path. Status remains length-class only (probe never
contributes a nonzero bit). Does not require Code/Length/Authenticator match. -/
public unsafe def validate (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) err
    (U32.land (loadAt addr USize.zero) U32.zero)

/-- Alias of `validate`. -/
public unsafe def parse (addr : USize) (n : USize) : U32 :=
  validate addr n

/-- Code byte, or `0` if `n < 20`. -/
public unsafe def code (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (loadAt addr USize.zero)

/-- Identifier byte, or `0` if `n < 20`. -/
public unsafe def identifier (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (loadAt addr offId)

/-- Length field (bytes 2–3 BE) as `U32`, or `0` if `n < 20`. -/
public unsafe def length (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (loadU16BE addr offLenHi offLenLo)

/-- First 4 authenticator bytes (offs 4–7) as BE `U32` → `USize`, or miss if short. **LP64**. -/
public unsafe def authBe0 (addr : USize) (n : USize) : USize :=
  bifUSize (USize.blt n headerLen) USize.neg1
    (USize.ofU32 (loadU32BE addr offAuth0 offAuth1 offAuth2 offAuth3))

/-- `1` if Code is Access-Request (1) when `n ≥ 20`, else `0`. -/
public unsafe def isAccessRequest (addr : USize) (n : USize) : U32 :=
  bifU32 (U32.beq (code addr n) codeAccessRequest) U32.one U32.zero

/-- `1` if Code is Access-Accept (2) when `n ≥ 20`, else `0`. -/
public unsafe def isAccessAccept (addr : USize) (n : USize) : U32 :=
  bifU32 (U32.beq (code addr n) codeAccessAccept) U32.one U32.zero

/-- `1` if Code is Access-Reject (3) when `n ≥ 20`, else `0`. -/
public unsafe def isAccessReject (addr : USize) (n : USize) : U32 :=
  bifU32 (U32.beq (code addr n) codeAccessReject) U32.one U32.zero

end Systems.Radius
