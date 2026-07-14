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
public import Systems.Ascii
public import Systems.Numerics

/-!
# Systems.Jwt (Systems Lean)

JWT-**shaped** compact-serialization scan over dual caller `addr`/`len` byte views —
not JWS/JWE crypto verify, not JOSE header decode, not base64url **decode** product.

Recognized shape (RFC 7519 compact-shaped ASCII):

```
header.payload.signature
```

* **parts** — non-empty spans of base64url alphabet (`A–Z a–z 0–9 - _`) with optional
  trailing `=` padding bytes, separated by exactly one `'.'` between parts
* Classic compact JWS uses **three** parts (header, payload, signature); this module
  counts any number of well-formed parts and exposes `isThreeParts` for the common case

Ops:

* **validate** / **scan** — structural part scan; `0` ok, `1` invalid
* **partCount** — number of base64url-shaped parts (0 if invalid)
* **partOff** / **partLen** — span of part at 0-based index, or miss / 0
* **isThreeParts** — `1` if validates and `partCount == 3`, else `0`

Honesty:

* **Shaped scan only** — no HMAC/ECDSA/RSA verify, no JSON header parse, no claim
  validation, no JWE multi-part variants as a product API, no base64url decode.
* Padding/`=` runs are accepted but not length-mod-4 validated.
* Not claimed: full RFC 7515/7519/7518 JOSE parity.
* Miss sentinel is `USize.neg1` (**LP64 harness**).
* **loadAt dual-param honesty:** ops take caller `(addr, n)`; every `loadAt` index is
  produced only after an `i < n` guard. `loadAt` itself is **not** bounds-parameterized.

## Intentional TCB (Jwt-local)

Structural separators and base64url markers are freestanding `@[extern]` axioms kept
**here**. Name-pinned on ComplianceCorpus (`path name=Ident`). Classifiers reuse
`Ascii` for alnum body bytes.
-/

namespace Systems.Jwt

open Systems.Scalars
open Systems.Bytes
open Systems.Status
open Systems.Ascii
open Systems.Numerics

/-- ASCII `'.'` (46). -/
@[extern c inline "((uint32_t)46)"] public axiom cDot : U32
/-- ASCII `'-'` (45). -/
@[extern c inline "((uint32_t)45)"] public axiom cMinus : U32
/-- ASCII `'_'` (95). -/
@[extern c inline "((uint32_t)95)"] public axiom cUnder : U32
/-- ASCII `'='` (61). -/
@[extern c inline "((uint32_t)61)"] public axiom cPad : U32
/-- Three as `USize` (classic compact JWS part count). -/
@[extern c inline "((size_t)3)"] public axiom threeUSize : USize

/-- Load byte at index as `U32`. Caller ensures `i < n`. -/
public unsafe def loadAt (addr : USize) (i : USize) : U32 :=
  U32.ofU8 (U8.load (USize.add addr i))

/-- `1` if `c` is base64url alphabet (no pad). -/
public unsafe def isB64UrlBody (c : U32) : U32 :=
  bifU32 (U32.beq (isAlnum c) U32.one) U32.one
    (bifU32 (U32.beq c cMinus) U32.one
      (bifU32 (U32.beq c cUnder) U32.one U32.zero))

/-- `1` if `c` is base64url body or pad. -/
public unsafe def isB64Url (c : U32) : U32 :=
  bifU32 (U32.beq (isB64UrlBody c) U32.one) U32.one
    (bifU32 (U32.beq c cPad) U32.one U32.zero)

/-- Optional pad run; returns index just past pads (must stop at end or `'.'`). -/
public unsafe def scanPartPad (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let c := loadAt addr i
     bifUSize (U32.beq c cDot) i
       (bifUSize (U32.beq c cPad)
         (scanPartPad addr (USize.add i USize.one) n)
         USize.neg1))
    i

/-- Continue part after first body byte: more body, then optional pads, then end/dot. -/
public unsafe def scanPartBody (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let c := loadAt addr i
     bifUSize (U32.beq c cDot) i
       (bifUSize (U32.beq (isB64UrlBody c) U32.one)
         (scanPartBody addr (USize.add i USize.one) n)
         (bifUSize (U32.beq c cPad)
           (scanPartPad addr (USize.add i USize.one) n)
           USize.neg1)))
    i

/-- Scan a base64url part starting at `i`. Returns index just past the part, or miss.

Requires at least one body byte; optional trailing pads only after body. Stops before
`'.'` or end. Rejects pad-before-body and non-alphabet bytes. -/
public unsafe def scanPart (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (bifUSize (U32.beq (isB64UrlBody (loadAt addr i)) U32.one)
      (scanPartBody addr (USize.add i USize.one) n)
      USize.neg1)
    USize.neg1

/-- Validate from index `i` with `needPart` (`1` = must start a part).

Between parts: require `'.'` then another part. End of input is ok only after a part. -/
public unsafe def validateGo (addr : USize) (i : USize) (n : USize) (needPart : U32) : U32 :=
  bifU32 (U32.beq needPart U32.one)
    (let j := scanPart addr i n
     bifU32 (USize.beq j USize.neg1) err
       (validateGo addr j n U32.zero))
    (bifU32 (USize.blt i n)
      (bifU32 (U32.beq (loadAt addr i) cDot)
        (validateGo addr (USize.add i USize.one) n U32.one)
        err)
      ok)

/-- `0` if the view is a well-formed base64url-dotted compact string with ≥1 part, else `1`.

Empty input is invalid. Does not require three parts (see `isThreeParts`). -/
public unsafe def validate (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq n USize.zero) err
    (validateGo addr USize.zero n U32.one)

/-- Alias of `validate`. -/
public unsafe def scan (addr : USize) (n : USize) : U32 :=
  validate addr n

/-- Count parts from `i` after a successful structural scan of remaining input. -/
public unsafe def partCountGo (addr : USize) (i : USize) (n : USize) (acc : USize) : USize :=
  let j := scanPart addr i n
  bifUSize (USize.beq j USize.neg1) USize.zero
    (let acc1 := USize.add acc USize.one
     bifUSize (USize.blt j n)
       (bifUSize (U32.beq (loadAt addr j) cDot)
         (partCountGo addr (USize.add j USize.one) n acc1)
         USize.zero)
       acc1)

/-- Number of base64url-shaped parts, or `0` if invalid. -/
public unsafe def partCount (addr : USize) (n : USize) : USize :=
  bifUSize (U32.beq (validate addr n) U32.zero)
    (partCountGo addr USize.zero n USize.zero)
    USize.zero

/-- Find start of part index `want` (0-based). Returns off or miss. -/
public unsafe def partOffGo (addr : USize) (i : USize) (n : USize)
    (want : USize) (cur : USize) : USize :=
  bifUSize (USize.beq cur want) i
    (let j := scanPart addr i n
     bifUSize (USize.beq j USize.neg1) USize.neg1
       (bifUSize (USize.blt j n)
         (bifUSize (U32.beq (loadAt addr j) cDot)
           (partOffGo addr (USize.add j USize.one) n want (USize.add cur USize.one))
           USize.neg1)
         USize.neg1))

/-- Byte offset of part `idx`, or miss. **LP64 miss.** Requires valid input. -/
public unsafe def partOff (addr : USize) (n : USize) (idx : USize) : USize :=
  bifUSize (U32.beq (validate addr n) U32.zero)
    (partOffGo addr USize.zero n idx USize.zero)
    USize.neg1

/-- Length of part at `idx`, or `0` on miss/invalid. -/
public unsafe def partLen (addr : USize) (n : USize) (idx : USize) : USize :=
  let off := partOff addr n idx
  bifUSize (USize.beq off USize.neg1) USize.zero
    (let j := scanPart addr off n
     bifUSize (USize.beq j USize.neg1) USize.zero (USize.sub j off))

/-- `1` if validates and has exactly three parts (classic compact JWS shape). -/
public unsafe def isThreeParts (addr : USize) (n : USize) : U32 :=
  bifU32 (U32.beq (validate addr n) U32.zero)
    (bifU32 (USize.beq (partCount addr n) threeUSize) U32.one U32.zero)
    U32.zero

end Systems.Jwt
