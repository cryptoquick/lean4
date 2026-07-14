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
# Systems.Asn1 (Systems Lean)

ASN.1 DER-**shaped** first-tag TLV scan over dual caller `addr`/`len` byte views —
not a full ASN.1/DER codec, not BER indefinite form, not OID/string value product.

Minimum TLV prefix (DER-shaped; **2** bytes for tag + short-form length):

| Offset | Size | Field |
|--------|------|-------|
| 0 | 1 | tag (class/number + constructed bit5) |
| 1 | 1 | length (short form if `< 128`) |

Ops:

* **validate** / **scan** — `0` if `n ≥ 2`, else `1` (too short); when long enough,
  probes first byte and folds it with `land 0` so dual-param `addr` is live
* **tag** — tag byte as `U32`, or `0` if short
* **isConstructed** — `1` if bit5 of tag is set (`0x20`), else `0` (or short)
* **lengthSmall** — byte1 as `USize` when short form (`< 128`), else miss (`USize.neg1`);
  also miss if short buffer
* **contentStart** — `2` when `n ≥ 2` and short-form length ok, else miss

Honesty:

* **First-tag short-form TLV only** — no multi-byte length (long form), no indefinite
  BER, no nested walk, no OID/UTCTime/BIT STRING value decode, not a full DER
  codec or X.509 product.
* **validate status is length-class only** (`ok`/`err`); the first-byte probe never
  changes the status value (`land` with zero) but keeps `addr` on the EmitC result path
  when `n ≥ 2`. Tag class/number legality is not enforced.
* **loadAt dual-param honesty:** every load index is under `i < n` after the min-2
  fence. `loadAt` is **not** bounds-parameterized.

## Intentional TCB (Asn1-local)

Minimum length, constructed-bit mask, single-byte length ceiling, length offset, and
`USize.ofU32` are freestanding `@[extern]` axioms kept **here**. Name-pinned on
ComplianceCorpus (`path name=Ident`). Byte loads reuse `Scalars`/`Bytes`; and reuse
`Numerics`.
-/

namespace Systems.Asn1

open Systems.Scalars
open Systems.Bytes
open Systems.Status
open Systems.Numerics

/-- ASN.1 DER TLV minimum length (tag + short length = 2). -/
@[extern c inline "((size_t)2)"] public axiom minLen : USize
/-- Constructed bit mask on tag (`0x20` = 32; bit5). -/
@[extern c inline "((uint32_t)32)"] public axiom maskConstructed : U32
/-- Short-form length exclusive ceiling (`0x80` = 128). -/
@[extern c inline "((uint32_t)128)"] public axiom varintCeil : U32
/-- Offset of length byte (1). -/
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
contributes a nonzero bit). Does not decode long-form length or nested content. -/
public unsafe def validate (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n minLen) err
    (U32.land (loadAt addr USize.zero) U32.zero)

/-- Alias of `validate`. -/
public unsafe def scan (addr : USize) (n : USize) : U32 :=
  validate addr n

/-- Tag byte as `U32`, or `0` if `n < 2`. -/
public unsafe def tag (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n minLen) U32.zero
    (loadAt addr USize.zero)

/-- `1` if tag constructed bit5 is set, else `0` (or short). -/
public unsafe def isConstructed (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n minLen) U32.zero
    (bifU32 (U32.beq (U32.land (loadAt addr USize.zero) maskConstructed) U32.zero)
      U32.zero U32.one)

/-- Length (byte1) when short form (`< 128`), else miss.

Returns `USize.ofU32 byte1` when `n ≥ 2` and `byte1 < 128`; else `USize.neg1`
(**LP64 miss**). Multi-byte DER long-form length is intentionally omitted. -/
public unsafe def lengthSmall (addr : USize) (n : USize) : USize :=
  bifUSize (USize.blt n minLen) USize.neg1
    (let b := loadAt addr off1
     bifUSize (U32.blt b varintCeil) (USize.ofU32 b) USize.neg1)

/-- Content start offset (`2`) when short-form length ok, else miss.

Requires `n ≥ 2` and `byte1 < 128`. Returns `minLen` (`2`); **LP64 miss** otherwise.
Does not check that `2 + length ≤ n`. -/
public unsafe def contentStart (addr : USize) (n : USize) : USize :=
  bifUSize (USize.blt n minLen) USize.neg1
    (let b := loadAt addr off1
     bifUSize (U32.blt b varintCeil) minLen USize.neg1)

end Systems.Asn1
