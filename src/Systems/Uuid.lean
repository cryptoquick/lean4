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
# Systems.Uuid (Systems Lean)

UUID-**shaped** ASCII scan over dual caller `addr`/`len` byte views — not a UUID
generator, not binary 16-byte GUID encode/decode, not full RFC 4122 variant graph.

Recognized shape (canonical 8-4-4-4-12 hyphenated hex, **36** ASCII bytes):

```
xxxxxxxx-xxxx-Mxxx-Nxxx-xxxxxxxxxxxx
```

* Hex digits are `0-9` / `A-F` / `a-f` (via `Ascii.isHex`)
* Hyphens at fixed offsets `8`, `13`, `18`, `23`
* Optional field helpers: **version** nibble `M` (index 14), **variant** nibble `N` (index 19)

Ops:

* **validate** / **scan** — structural 36-char form; `0` ok, `1` invalid
* **version** — hex value of version nibble (`0..15`), or `0` if invalid
* **variant** — hex value of variant nibble (`0..15`), or `0` if invalid

Honesty:

* **Shaped scan only** — no random/time-based generation, no binary UUID product,
  no namespace DNS/URL/OID variants as a product API, no RFC all-variants dispatch.
* Version/variant are **nibble values** from the canonical text form (not bit-field
  product APIs, not nil/max UUID special-cases beyond hex acceptance).
* **loadAt dual-param honesty:** every load index is under `i < n` after length fence.
  `loadAt` itself is **not** bounds-parameterized. Index walk uses live `i` (no ground
  `USize.add` of two closed constants — freestanding emit class).

## Intentional TCB (Uuid-local)

Canonical length, hyphen code, hyphen offsets, version/variant char indices, and
hex nibble helpers are freestanding `@[extern]` axioms kept **here**. Name-pinned on
ComplianceCorpus (`path name=Ident`). Classifiers reuse `Ascii.isHex` / `isDigit`.
-/

namespace Systems.Uuid

open Systems.Scalars
open Systems.Bytes
open Systems.Status
open Systems.Ascii
open Systems.Numerics

/-- Canonical hyphenated UUID length (36). -/
@[extern c inline "((size_t)36)"] public axiom uuidLen : USize
/-- ASCII `'-'` (45). -/
@[extern c inline "((uint32_t)45)"] public axiom cHyphen : U32
/-- ASCII `'0'` (48) for hex nibble value. -/
@[extern c inline "((uint32_t)48)"] public axiom c0 : U32
/-- ASCII `'A'` (65). -/
@[extern c inline "((uint32_t)65)"] public axiom cA : U32
/-- ASCII `'a'` (97). -/
@[extern c inline "((uint32_t)97)"] public axiom ca : U32
/-- Ten (decimal ceiling for hex letter). -/
@[extern c inline "((uint32_t)10)"] public axiom tenU32 : U32
/-- Hyphen offset 8. -/
@[extern c inline "((size_t)8)"] public axiom offHyphen0 : USize
/-- Hyphen offset 13. -/
@[extern c inline "((size_t)13)"] public axiom offHyphen1 : USize
/-- Hyphen offset 18. -/
@[extern c inline "((size_t)18)"] public axiom offHyphen2 : USize
/-- Hyphen offset 23. -/
@[extern c inline "((size_t)23)"] public axiom offHyphen3 : USize
/-- Version nibble character index (14). -/
@[extern c inline "((size_t)14)"] public axiom offVersion : USize
/-- Variant nibble character index (19). -/
@[extern c inline "((size_t)19)"] public axiom offVariant : USize

/-- Load byte at index as `U32`. Caller ensures `i < n`. -/
public unsafe def loadAt (addr : USize) (i : USize) : U32 :=
  U32.ofU8 (U8.load (USize.add addr i))

/-- Hex digit value `0..15` for ASCII hex `c`. Caller must ensure `isHex c`. -/
public def hexVal (c : U32) : U32 :=
  bifU32 (U32.beq (isDigit c) U32.one) (U32.sub c c0)
    (bifU32 (U32.blt c ca)
      (U32.add tenU32 (U32.sub c cA))
      (U32.add tenU32 (U32.sub c ca)))

/-- `1` if index `i` is a fixed hyphen slot. -/
public def isHyphenPos (i : USize) : U32 :=
  bifU32 (USize.beq i offHyphen0) U32.one
    (bifU32 (USize.beq i offHyphen1) U32.one
      (bifU32 (USize.beq i offHyphen2) U32.one
        (bifU32 (USize.beq i offHyphen3) U32.one U32.zero)))

/-- Walk indices `[i, n)` requiring hyphen-or-hex shape. `0` ok, `1` bad. -/
public unsafe def validateGo (addr : USize) (i : USize) (n : USize) : U32 :=
  bifU32 (USize.blt i n)
    (let c := loadAt addr i
     bifU32 (U32.beq (isHyphenPos i) U32.one)
       (bifU32 (U32.beq c cHyphen)
         (validateGo addr (USize.add i USize.one) n)
         err)
       (bifU32 (U32.beq (isHex c) U32.one)
         (validateGo addr (USize.add i USize.one) n)
         err))
    ok

/-- `0` if the view is a canonical 36-char hyphenated UUID, else `1`.

Requires exact length 36; hyphen positions and hex body only. Does not require a
specific version or variant class. -/
public unsafe def validate (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq n uuidLen)
    (validateGo addr USize.zero n)
    err

/-- Alias of `validate`. -/
public unsafe def scan (addr : USize) (n : USize) : U32 :=
  validate addr n

/-- Version nibble (`0..15`) from index 14, or `0` if invalid form. -/
public unsafe def version (addr : USize) (n : USize) : U32 :=
  bifU32 (U32.beq (validate addr n) U32.zero)
    (hexVal (loadAt addr offVersion))
    U32.zero

/-- Variant nibble (`0..15`) from index 19, or `0` if invalid form. -/
public unsafe def variant (addr : USize) (n : USize) : U32 :=
  bifU32 (U32.beq (validate addr n) U32.zero)
    (hexVal (loadAt addr offVariant))
    U32.zero

end Systems.Uuid
