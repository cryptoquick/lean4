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
# Systems.Ldap (Systems Lean)

LDAP-**shaped** BER/TLV message minimum header parse over dual caller `addr`/`len`
byte views — not a full LDAP stack, not multi-PDU session product, not SASL/TLS
bind product.

Minimum LDAPMessage shape (RFC 4511 BER-shaped; SEQUENCE + messageID INTEGER +
protocolOp CHOICE tag; short-form lengths; **6** bytes for a 1-byte messageID):

| Offset | Size | Field |
|--------|------|-------|
| 0 | 1 | SEQUENCE tag (`0x30`) |
| 1 | 1 | sequence length (short form if `< 128`) |
| 2 | 1 | messageID INTEGER tag (`0x02`) |
| 3 | 1 | messageID length (shaped: `1`) |
| 4 | 1 | messageID value (1-byte INTEGER) |
| 5 | 1 | protocolOp CHOICE tag (e.g. BindRequest `0x60`) |

Ops:

* **validate** / **parse** — `0` if `n ≥ 6`, else `1` (too short); when long enough,
  probes first byte and folds it with `land 0` so dual-param `addr` is live
* **isSequence** — `1` if tag byte is `0x30`, else `0` (or short)
* **lengthSmall** — sequence short-form length as `USize`, or miss
* **messageId** — 1-byte INTEGER messageID as `U32` when short-form shape ok, else `0`
* **protocolOpTag** — protocolOp tag byte as `U32` when short-form shape ok, else `0`
* **isBindRequest** — `1` if short-form shape and protocolOp is BindRequest (`0x60`), else `0`
* **isSearchRequest** — `1` if short-form shape and protocolOp is SearchRequest (`0x63`), else `0`

Honesty:

* **First-PDU SEQUENCE + short-form length + 1-byte messageID + protocolOp tag only** —
  no multi-byte INTEGER, no long-form BER length, no nested Attribute walk, not an LDAP
  client/server. Long-form length (`byte1 ≥ 0x80`) fail-closes `hasMessageId` /
  `messageId` / `protocolOpTag` / `isBindRequest` / `isSearchRequest` (helpers miss);
  `validate` stays length-class only.
* **validate status is length-class only** (`ok`/`err`); the first-byte probe never
  changes the status value (`land` with zero) but keeps `addr` on the EmitC result path
  when `n ≥ 6`. SEQUENCE/tag legality is not enforced by validate.
* **loadAt dual-param honesty:** every load index is under `i < n` after the min-6
  fence. `loadAt` is **not** bounds-parameterized.

## Intentional TCB (Ldap-local)

Minimum length, SEQUENCE/INTEGER/Bind/Search tags, short-form length ceiling, field
offsets, and `USize.ofU32` are freestanding `@[extern]` axioms kept **here**. Name-pinned
on ComplianceCorpus (`path name=Ident`). Byte loads reuse `Scalars`/`Bytes`; and reuse
`Numerics`.
-/

namespace Systems.Ldap

open Systems.Scalars
open Systems.Bytes
open Systems.Status
open Systems.Numerics

/-- LDAPMessage shaped minimum length (SEQUENCE + short len + INTEGER TLV + protocolOp tag = 6). -/
@[extern c inline "((size_t)6)"] public axiom minLen : USize
/-- SEQUENCE universal constructed tag (`0x30` = 48). -/
@[extern c inline "((uint32_t)48)"] public axiom tagSequence : U32
/-- INTEGER universal tag (`0x02` = 2). -/
@[extern c inline "((uint32_t)2)"] public axiom tagInteger : U32
/-- BindRequest application constructed tag (`0x60` = 96). -/
@[extern c inline "((uint32_t)96)"] public axiom tagBind : U32
/-- SearchRequest application constructed tag (`0x63` = 99). -/
@[extern c inline "((uint32_t)99)"] public axiom tagSearch : U32
/-- Short-form length exclusive ceiling (`0x80` = 128). -/
@[extern c inline "((uint32_t)128)"] public axiom varintCeil : U32
/-- Expected 1-byte INTEGER length for messageID (1). -/
@[extern c inline "((uint32_t)1)"] public axiom oneU32 : U32
/-- Offset of sequence length byte (1). -/
@[extern c inline "((size_t)1)"] public axiom off1 : USize
/-- Offset of messageID INTEGER tag (2). -/
@[extern c inline "((size_t)2)"] public axiom offMsgTag : USize
/-- Offset of messageID length (3). -/
@[extern c inline "((size_t)3)"] public axiom offMsgLen : USize
/-- Offset of messageID value (4). -/
@[extern c inline "((size_t)4)"] public axiom offMsgId : USize
/-- Offset of protocolOp tag (5). -/
@[extern c inline "((size_t)5)"] public axiom offOp : USize
/-- Widen `U32` → `USize`. -/
@[extern c inline "((size_t)(uint32_t)(#1))"]
public axiom USize.ofU32 : U32 → USize

/-- Load byte at index as `U32`. Caller ensures `i < n`. -/
public unsafe def loadAt (addr : USize) (i : USize) : U32 :=
  U32.ofU8 (U8.load (USize.add addr i))

/-- `0` if `n ≥ 6`, else `1`.

When `n ≥ 6`, loads first byte and folds it with `U32.land _ U32.zero` so dual-param
`addr` stays on the EmitC result path. Status remains length-class only (probe never
contributes a nonzero bit). Does not require SEQUENCE/INTEGER/protocolOp match. -/
public unsafe def validate (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n minLen) err
    (U32.land (loadAt addr USize.zero) U32.zero)

/-- Alias of `validate`. -/
public unsafe def parse (addr : USize) (n : USize) : U32 :=
  validate addr n

/-- `1` if outer tag is SEQUENCE (`0x30`) when `n ≥ 6`, else `0`. -/
public unsafe def isSequence (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n minLen) U32.zero
    (bifU32 (U32.beq (loadAt addr USize.zero) tagSequence) U32.one U32.zero)

/-- Sequence short-form length (byte1) when `< 128`, else miss.

Returns `USize.ofU32 byte1` when `n ≥ 6` and `byte1 < 128`; else `USize.neg1`
(**LP64 miss**). Multi-byte BER long-form length is intentionally omitted. -/
public unsafe def lengthSmall (addr : USize) (n : USize) : USize :=
  bifUSize (USize.blt n minLen) USize.neg1
    (let b := loadAt addr off1
     bifUSize (U32.blt b varintCeil) (USize.ofU32 b) USize.neg1)

/-- `1` if short-form SEQUENCE length + INTEGER tag + length-1 shape when `n ≥ 6`, else `0`.

Fail-closed on long-form BER length (`byte1 ≥ 0x80`): fixed offsets would misread
messageID/protocolOp, so helpers miss rather than claim a false short-form shape. -/
public unsafe def hasMessageId (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n minLen) U32.zero
    (bifU32 (U32.blt (loadAt addr off1) varintCeil)
      (bifU32 (U32.beq (loadAt addr offMsgTag) tagInteger)
        (bifU32 (U32.beq (loadAt addr offMsgLen) oneU32) U32.one U32.zero)
        U32.zero)
      U32.zero)

/-- 1-byte messageID value when INTEGER length-1 shape ok, else `0`. -/
public unsafe def messageId (addr : USize) (n : USize) : U32 :=
  bifU32 (U32.beq (hasMessageId addr n) U32.one)
    (loadAt addr offMsgId)
    U32.zero

/-- protocolOp CHOICE tag when messageID shape ok, else `0`. -/
public unsafe def protocolOpTag (addr : USize) (n : USize) : U32 :=
  bifU32 (U32.beq (hasMessageId addr n) U32.one)
    (loadAt addr offOp)
    U32.zero

/-- `1` if protocolOp is BindRequest (`0x60`), else `0`. -/
public unsafe def isBindRequest (addr : USize) (n : USize) : U32 :=
  bifU32 (U32.beq (protocolOpTag addr n) tagBind) U32.one U32.zero

/-- `1` if protocolOp is SearchRequest (`0x63`), else `0`. -/
public unsafe def isSearchRequest (addr : USize) (n : USize) : U32 :=
  bifU32 (U32.beq (protocolOpTag addr n) tagSearch) U32.one U32.zero

end Systems.Ldap
