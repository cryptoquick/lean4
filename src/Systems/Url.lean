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

/-!
# Systems.Url (Systems Lean)

URL-**shaped** parse of scheme / host / path **offsets** over dual caller `addr`/`len`
byte views — not a full URI RFC parser, not IDNA, not query/fragment product API.

Recognized shape (ASCII bytes):

```
scheme "://" host [path…]
```

* **scheme** — one or more `isAlpha` then optional `isAlnum` / `+` / `-` / `.`, ending at `:`
* **authority marker** — exact `://` after scheme
* **host** — bytes until first `/` or end (may be empty → invalid for `validate`)
* **path** — remaining bytes from first `/` (or empty if none)

Ops:

* **schemeLen** — length of scheme prefix, or `0` if no well-formed scheme `:`
* **hasAuthority** — `1` if `scheme://` is present
* **hostOff** / **hostLen** — host span after `://` (zeros if no authority)
* **pathOff** / **pathLen** — path span (zeros if no authority)
* **validate** — `0` if `scheme://` + non-empty host; else `1`

Honesty:

* **Shaped offsets only** — no URL encode/decode, no IPv6 brackets special-case beyond
  raw host bytes, no userinfo/`@`, no port split product, no query/fragment fields.
* Not claimed: full RFC 3986/9110, Unicode hostnames, relative-ref resolution, or
  scheme allowlists.
* Empty input and missing `://` fail `validate`.

## Intentional TCB (Url-local)

Structural chars (`:` `/` `+` `-` `.`) are freestanding `@[extern]` axioms kept **here**.
Name-pinned on ComplianceCorpus (`path name=Ident`). Classifiers reuse `Ascii`.
-/

namespace Systems.Url

open Systems.Scalars
open Systems.Bytes
open Systems.Status
open Systems.Ascii

/-- ASCII `':'` (58). -/
@[extern c inline "((uint32_t)58)"] public axiom cColon : U32
/-- ASCII `'/'` (47). -/
@[extern c inline "((uint32_t)47)"] public axiom cSlash : U32
/-- ASCII `'+'` (43). -/
@[extern c inline "((uint32_t)43)"] public axiom cPlus : U32
/-- ASCII `'-'` (45). -/
@[extern c inline "((uint32_t)45)"] public axiom cMinus : U32
/-- ASCII `'.'` (46). -/
@[extern c inline "((uint32_t)46)"] public axiom cDot : U32
/-- Three as `USize`. -/
@[extern c inline "((size_t)3)"] public axiom threeUSize : USize

/-- Load byte at index as `U32`. Caller ensures bounds. -/
public unsafe def loadAt (addr : USize) (i : USize) : U32 :=
  U32.ofU8 (U8.load (USize.add addr i))

/-- `1` if `c` is allowed in scheme after the first alpha (`alnum` / `+` / `-` / `.`). -/
public unsafe def isSchemeCont (c : U32) : U32 :=
  bifU32 (U32.beq (isAlnum c) U32.one) U32.one
    (bifU32 (U32.beq c cPlus) U32.one
      (bifU32 (U32.beq c cMinus) U32.one
        (bifU32 (U32.beq c cDot) U32.one U32.zero)))

/-- Scan scheme body after first alpha until `:` or invalid. Returns index of `:`, or miss. -/
public unsafe def schemeColonGo (addr : USize) (n : USize) (i : USize) : USize :=
  bifUSize (USize.blt i n)
    (let c := loadAt addr i
     bifUSize (U32.beq c cColon) i
       (bifUSize (U32.beq (isSchemeCont c) U32.one)
         (schemeColonGo addr n (USize.add i USize.one))
         USize.neg1))
    USize.neg1

/-- Length of scheme (bytes before `:`), or `0` if no well-formed scheme.

Requires first byte alpha and a following `:` (scheme may be one letter: `a:`). -/
public unsafe def schemeLen (addr : USize) (n : USize) : USize :=
  bifUSize (USize.blt USize.zero n)
    (bifUSize (U32.beq (isAlpha (loadAt addr USize.zero)) U32.one)
      (let colon := schemeColonGo addr n USize.one
       bifUSize (USize.beq colon USize.neg1) USize.zero colon)
      USize.zero)
    USize.zero

/-- `1` if `scheme://` is present (scheme non-empty and two slashes after `:`). -/
public unsafe def hasAuthority (addr : USize) (n : USize) : U32 :=
  let sl := schemeLen addr n
  bifU32 (USize.beq sl USize.zero) U32.zero
    (let afterColon := USize.add sl USize.one
     bifU32 (USize.blt (USize.add afterColon USize.one) n)
       (bifU32 (U32.beq (loadAt addr afterColon) cSlash)
         (bifU32 (U32.beq (loadAt addr (USize.add afterColon USize.one)) cSlash)
           U32.one U32.zero)
         U32.zero)
       U32.zero)

/-- Byte offset of host (`schemeLen + 3` when authority present), else `0`. -/
public unsafe def hostOff (addr : USize) (n : USize) : USize :=
  bifUSize (U32.beq (hasAuthority addr n) U32.one)
    (USize.add (schemeLen addr n) threeUSize)
    USize.zero

/-- Scan for first `/` in `[i, n)`; returns its index, or `n` if none. -/
public unsafe def findSlashGo (addr : USize) (n : USize) (i : USize) : USize :=
  bifUSize (USize.blt i n)
    (bifUSize (U32.beq (loadAt addr i) cSlash) i
      (findSlashGo addr n (USize.add i USize.one)))
    n

/-- Host length (bytes until `/` or end). `0` if no authority. -/
public unsafe def hostLen (addr : USize) (n : USize) : USize :=
  bifUSize (U32.beq (hasAuthority addr n) U32.one)
    (let ho := hostOff addr n
     let slash := findSlashGo addr n ho
     bifUSize (USize.blt slash ho) USize.zero (USize.sub slash ho))
    USize.zero

/-- Path offset (first `/` after host, or `n` if no path slash). `0` if no authority. -/
public unsafe def pathOff (addr : USize) (n : USize) : USize :=
  bifUSize (U32.beq (hasAuthority addr n) U32.one)
    (let ho := hostOff addr n
     findSlashGo addr n ho)
    USize.zero

/-- Path length from `pathOff` to end. `0` if no authority or no `/` after host. -/
public unsafe def pathLen (addr : USize) (n : USize) : USize :=
  bifUSize (U32.beq (hasAuthority addr n) U32.one)
    (let po := pathOff addr n
     bifUSize (USize.blt n po) USize.zero
       (bifUSize (USize.beq po n) USize.zero (USize.sub n po)))
    USize.zero

/-- Status `0` if `scheme://` with non-empty host; else `1`. -/
public unsafe def validate (addr : USize) (n : USize) : U32 :=
  bifU32 (U32.beq (hasAuthority addr n) U32.one)
    (bifU32 (USize.blt USize.zero (hostLen addr n)) ok err)
    err

end Systems.Url
