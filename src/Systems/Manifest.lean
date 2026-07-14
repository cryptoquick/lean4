/-
Copyright (c) 2026 Hunter Beast. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Hunter Beast
-/
module
prelude
public import Systems.Scalars
public import Systems.Bytes
public import Systems.Status

/-!
# Systems.Manifest (Systems Lean)

lake-manifest / lockfile-**shaped** JSON-ish key/value scan over dual caller `addr`/`len`
byte views — package `name` / `url` / `rev` / `version` field finds as byte-span helpers.
**Not** full `lake-manifest.json`, **not** arbitrary JSON, **not** TomlConfig
(lakefile config), **not** Json (generic structural JSON scan).

Recognized shapes (ASCII bytes):

* **JSON-ish keys** — `"key"` substrings; first match wins (global scan, no DOM)
* **string values** — after key, skip whitespace/`:`/whitespace, then `"…"` value span
  (simple escape: `\\` skips next byte; no full JSON string product)
* **brace/bracket/quote balance** — validate walks depth with a fixed cap

Ops:

* **validate** / **scan** — structural balance-ish; `0` ok, `1` invalid, `3` depth bound
* **findKey** / **valueOff** / **valueLen** / **hasKey** — `"key"` + string value span
* **packageNameOff** / **packageNameLen** — first `"name"` string value (quotes stripped)
* **hasUrl** / **hasRev** / **hasVersion** — presence of shaped key substrings

Honesty:

* **Lockfile-shaped for Slake update/lock** — not full Lake manifest schema, not
  multi-package array indexing, not write/update API.
* Keys are raw quoted substrings (`"name"`), not JSONPath. Nested objects share one
  global first-match namespace (subset honesty).
* Miss sentinel is `USize.neg1` (**LP64 harness**).
* Local scan (does **not** compose `Json` / `TomlConfig` APIs).

## Intentional TCB (Manifest-local)

Structural ASCII markers + fixed key magic bytes + depth default are freestanding
`@[extern]` axioms kept **here**. Name-pinned on ComplianceCorpus (`path name=Ident`).
-/

namespace Systems.Manifest

open Systems.Scalars
open Systems.Bytes
open Systems.Status

/-- ASCII `'"'` (34). -/
@[extern c inline "((uint32_t)34)"] public axiom cQuote : U32
/-- ASCII `':'` (58). -/
@[extern c inline "((uint32_t)58)"] public axiom cColon : U32
/-- ASCII `'{'` (123). -/
@[extern c inline "((uint32_t)123)"] public axiom cLBrace : U32
/-- ASCII `'}'` (125). -/
@[extern c inline "((uint32_t)125)"] public axiom cRBrace : U32
/-- ASCII `'['` (91). -/
@[extern c inline "((uint32_t)91)"] public axiom cLBrack : U32
/-- ASCII `']'` (93). -/
@[extern c inline "((uint32_t)93)"] public axiom cRBrack : U32
/-- ASCII `'\\'` (92). -/
@[extern c inline "((uint32_t)92)"] public axiom cBSlash : U32
/-- ASCII space (32). -/
@[extern c inline "((uint32_t)32)"] public axiom cSp : U32
/-- ASCII tab (9). -/
@[extern c inline "((uint32_t)9)"] public axiom cTab : U32
/-- ASCII LF (10). -/
@[extern c inline "((uint32_t)10)"] public axiom cLf : U32
/-- ASCII CR (13). -/
@[extern c inline "((uint32_t)13)"] public axiom cCr : U32
/-- Default max nesting depth (32). -/
@[extern c inline "((size_t)32)"] public axiom maxDepthDefault : USize
/-- Status code 3 (depth bound). -/
@[extern c inline "((uint32_t)3)"] public axiom errDepth : U32
/-- Two as `USize`. -/
@[extern c inline "((size_t)2)"] public axiom twoUSize : USize

/-- Package key `name` length (4). -/
@[extern c inline "((size_t)4)"] public axiom nameKeyLen : USize
/-- `name[0]` = `'n'` (110). -/
@[extern c inline "((uint32_t)110)"] public axiom name0 : U32
/-- `name[1]` = `'a'` (97). -/
@[extern c inline "((uint32_t)97)"] public axiom name1 : U32
/-- `name[2]` = `'m'` (109). -/
@[extern c inline "((uint32_t)109)"] public axiom name2 : U32
/-- `name[3]` = `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom name3 : U32

/-- Key `url` length (3). -/
@[extern c inline "((size_t)3)"] public axiom urlKeyLen : USize
/-- `'u'` (117). -/
@[extern c inline "((uint32_t)117)"] public axiom url0 : U32
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom url1 : U32
/-- `'l'` (108). -/
@[extern c inline "((uint32_t)108)"] public axiom url2 : U32

/-- Key `rev` length (3). -/
@[extern c inline "((size_t)3)"] public axiom revKeyLen : USize
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom rev0 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom rev1 : U32
/-- `'v'` (118). -/
@[extern c inline "((uint32_t)118)"] public axiom rev2 : U32

/-- Key `version` length (7). -/
@[extern c inline "((size_t)7)"] public axiom versionKeyLen : USize
/-- `'v'` (118). -/
@[extern c inline "((uint32_t)118)"] public axiom ver0 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom ver1 : U32
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom ver2 : U32
/-- `'s'` (115). -/
@[extern c inline "((uint32_t)115)"] public axiom ver3 : U32
/-- `'i'` (105). -/
@[extern c inline "((uint32_t)105)"] public axiom ver4 : U32
/-- `'o'` (111). -/
@[extern c inline "((uint32_t)111)"] public axiom ver5 : U32
/-- `'n'` (110). -/
@[extern c inline "((uint32_t)110)"] public axiom ver6 : U32

/-- Relative byte offsets. -/
@[extern c inline "((size_t)1)"] public axiom off1 : USize
@[extern c inline "((size_t)2)"] public axiom off2 : USize
@[extern c inline "((size_t)3)"] public axiom off3 : USize
@[extern c inline "((size_t)4)"] public axiom off4 : USize
@[extern c inline "((size_t)5)"] public axiom off5 : USize
@[extern c inline "((size_t)6)"] public axiom off6 : USize

/-- Load byte at index as `U32`. Caller ensures bounds. -/
public unsafe def loadAt (addr : USize) (i : USize) : U32 :=
  U32.ofU8 (U8.load (USize.add addr i))

/-- `1` if space/tab/LF/CR. -/
public unsafe def isWs (c : U32) : U32 :=
  bifU32 (U32.beq c cSp) U32.one
    (bifU32 (U32.beq c cTab) U32.one
      (bifU32 (U32.beq c cLf) U32.one
        (bifU32 (U32.beq c cCr) U32.one U32.zero)))

/-- Skip whitespace starting at `i`. -/
public unsafe def skipWs (addr : USize) (n : USize) (i : USize) : USize :=
  bifUSize (USize.blt i n)
    (bifUSize (U32.beq (isWs (loadAt addr i)) U32.one)
      (skipWs addr n (USize.add i USize.one))
      i)
    i

/-- `1` if spans `[a,a+len)` and `[b,b+len)` are equal. -/
public unsafe def spanEqGo (a : USize) (b : USize) (i : USize) (len : USize) : U32 :=
  bifU32 (USize.blt i len)
    (bifU32 (U8.beq (U8.load (USize.add a i)) (U8.load (USize.add b i)))
      (spanEqGo a b (USize.add i USize.one) len)
      U32.zero)
    U32.one

/-- `1` if equal length-`len` spans match. -/
public unsafe def spanEq (a : USize) (b : USize) (len : USize) : U32 :=
  spanEqGo a b USize.zero len

/-- Index after a JSON-ish string body starting past opening quote; miss on error. -/
public unsafe def scanStringGo (addr : USize) (n : USize) (i : USize) : USize :=
  bifUSize (USize.blt i n)
    (let c := loadAt addr i
     bifUSize (U32.beq c cQuote) (USize.add i USize.one)
       (bifUSize (U32.beq c cBSlash)
         (bifUSize (USize.blt (USize.add i USize.one) n)
           (scanStringGo addr n (USize.add i twoUSize))
           USize.neg1)
         (scanStringGo addr n (USize.add i USize.one))))
    USize.neg1

/-- Structural balance walk. depthAcc starts at 0; returns status. -/
public unsafe def validateGo (addr : USize) (n : USize) (i : USize) (depth : USize)
    (maxD : USize) (inStr : U32) : U32 :=
  bifU32 (USize.blt i n)
    (let c := loadAt addr i
     bifU32 (U32.beq inStr U32.one)
       (bifU32 (U32.beq c cBSlash)
         (bifU32 (USize.blt (USize.add i USize.one) n)
           (validateGo addr n (USize.add i twoUSize) depth maxD U32.one)
           err)
         (bifU32 (U32.beq c cQuote)
           (validateGo addr n (USize.add i USize.one) depth maxD U32.zero)
           (validateGo addr n (USize.add i USize.one) depth maxD U32.one)))
       (bifU32 (U32.beq c cQuote)
         (validateGo addr n (USize.add i USize.one) depth maxD U32.one)
         (bifU32 (U32.beq c cLBrace)
           (let d1 := USize.add depth USize.one
            bifU32 (USize.blt maxD d1) errDepth
              (validateGo addr n (USize.add i USize.one) d1 maxD U32.zero))
           (bifU32 (U32.beq c cLBrack)
             (let d1 := USize.add depth USize.one
              bifU32 (USize.blt maxD d1) errDepth
                (validateGo addr n (USize.add i USize.one) d1 maxD U32.zero))
             (bifU32 (U32.beq c cRBrace)
               (bifU32 (USize.beq depth USize.zero) err
                 (validateGo addr n (USize.add i USize.one) (USize.sub depth USize.one)
                   maxD U32.zero))
               (bifU32 (U32.beq c cRBrack)
                 (bifU32 (USize.beq depth USize.zero) err
                   (validateGo addr n (USize.add i USize.one) (USize.sub depth USize.one)
                     maxD U32.zero))
                 (validateGo addr n (USize.add i USize.one) depth maxD U32.zero)))))))
    (bifU32 (U32.beq inStr U32.one) err
      (bifU32 (USize.beq depth USize.zero) ok err))

/-- Structural validate: `0` ok, `1` invalid, `3` depth. Empty input is ok. -/
public unsafe def validate (addr : USize) (n : USize) : U32 :=
  validateGo addr n USize.zero USize.zero maxDepthDefault U32.zero

/-- Alias of `validate`. -/
public unsafe def scan (addr : USize) (n : USize) : U32 :=
  validate addr n

/-- Find `"key"` (quotes included in match) starting at `i`. Returns offset of opening
quote of the key, or miss. Skips string bodies so values are not mistaken for keys. -/
public unsafe def findKeyGo (addr : USize) (i : USize) (n : USize)
    (keyAddr : USize) (keyLen : USize) : USize :=
  bifUSize (USize.blt i n)
    (let c := loadAt addr i
     bifUSize (U32.beq c cQuote)
       (let body := USize.add i USize.one
        let after := scanStringGo addr n body
        bifUSize (USize.beq after USize.neg1) USize.neg1
          (let blen := USize.sub (USize.sub after USize.one) body
           bifUSize (USize.beq blen keyLen)
             (bifUSize (U32.beq (spanEq (USize.add addr body) keyAddr keyLen) U32.one)
               i
               (findKeyGo addr after n keyAddr keyLen))
             (findKeyGo addr after n keyAddr keyLen)))
       (findKeyGo addr (USize.add i USize.one) n keyAddr keyLen))
    USize.neg1

/-- Offset of first matching `"key"` opening quote, or miss. **LP64.** -/
public unsafe def findKey (addr : USize) (n : USize)
    (keyAddr : USize) (keyLen : USize) : USize :=
  bifUSize (USize.beq keyLen USize.zero) USize.neg1
    (findKeyGo addr USize.zero n keyAddr keyLen)

/-- Value byte offset (start of string content after opening `"`) for a key from
`findKey`, or miss if not a string value. -/
public unsafe def valueOff (addr : USize) (n : USize) (keyOff : USize) : USize :=
  bifUSize (USize.blt keyOff n)
    (let afterKey := scanStringGo addr n (USize.add keyOff USize.one)
     bifUSize (USize.beq afterKey USize.neg1) USize.neg1
       (let i0 := skipWs addr n afterKey
        bifUSize (USize.blt i0 n)
          (bifUSize (U32.beq (loadAt addr i0) cColon)
            (let i1 := skipWs addr n (USize.add i0 USize.one)
             bifUSize (USize.blt i1 n)
               (bifUSize (U32.beq (loadAt addr i1) cQuote)
                 (USize.add i1 USize.one)
                 USize.neg1)
               USize.neg1)
            USize.neg1)
          USize.neg1))
    USize.neg1

/-- Value length (string content) for a key from `findKey`, or `0` on failure. -/
public unsafe def valueLen (addr : USize) (n : USize) (keyOff : USize) : USize :=
  let vo := valueOff addr n keyOff
  bifUSize (USize.beq vo USize.neg1) USize.zero
    (let after := scanStringGo addr n vo
     bifUSize (USize.beq after USize.neg1) USize.zero
       (USize.sub (USize.sub after USize.one) vo))

/-- `1` if a matching key exists, else `0`. -/
public unsafe def hasKey (addr : USize) (n : USize)
    (keyAddr : USize) (keyLen : USize) : U32 :=
  bifU32 (USize.beq (findKey addr n keyAddr keyLen) USize.neg1) U32.zero U32.one

/-- `1` if span equals fixed package key `name`. -/
public unsafe def isNameKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len nameKeyLen)
    (bifU32 (U32.beq (loadAt addr off) name0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) name1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) name2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) name3)
            U32.one U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first `"name"` key opening-quote offset via fixed magic, or miss. -/
public unsafe def findNameKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let c := loadAt addr i
     bifUSize (U32.beq c cQuote)
       (let body := USize.add i USize.one
        let after := scanStringGo addr n body
        bifUSize (USize.beq after USize.neg1) USize.neg1
          (let blen := USize.sub (USize.sub after USize.one) body
           bifUSize (U32.beq (isNameKey addr body blen) U32.one)
             i
             (findNameKeyGo addr after n)))
       (findNameKeyGo addr (USize.add i USize.one) n))
    USize.neg1

/-- Byte offset of first `"name"` string value content, or miss. **LP64.** -/
public unsafe def packageNameOff (addr : USize) (n : USize) : USize :=
  let koff := findNameKeyGo addr USize.zero n
  bifUSize (USize.beq koff USize.neg1) USize.neg1
    (valueOff addr n koff)

/-- Length of first `"name"` string value content, or `0` on miss. -/
public unsafe def packageNameLen (addr : USize) (n : USize) : USize :=
  let koff := findNameKeyGo addr USize.zero n
  bifUSize (USize.beq koff USize.neg1) USize.zero
    (valueLen addr n koff)

/-- Stack scratch for fixed key presence (caller supplies key bytes in smokes).
Local helpers for shaped keys without requiring external key buffers in Lean:

`hasUrl` / `hasRev` / `hasVersion` scan for fixed quoted keys via byte magic. -/
public unsafe def matchUrlKey (addr : USize) (body : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len urlKeyLen)
    (bifU32 (U32.beq (loadAt addr body) url0)
      (bifU32 (U32.beq (loadAt addr (USize.add body off1)) url1)
        (bifU32 (U32.beq (loadAt addr (USize.add body off2)) url2)
          U32.one U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

public unsafe def matchRevKey (addr : USize) (body : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len revKeyLen)
    (bifU32 (U32.beq (loadAt addr body) rev0)
      (bifU32 (U32.beq (loadAt addr (USize.add body off1)) rev1)
        (bifU32 (U32.beq (loadAt addr (USize.add body off2)) rev2)
          U32.one U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

public unsafe def matchVersionKey (addr : USize) (body : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len versionKeyLen)
    (bifU32 (U32.beq (loadAt addr body) ver0)
      (bifU32 (U32.beq (loadAt addr (USize.add body off1)) ver1)
        (bifU32 (U32.beq (loadAt addr (USize.add body off2)) ver2)
          (bifU32 (U32.beq (loadAt addr (USize.add body off3)) ver3)
            (bifU32 (U32.beq (loadAt addr (USize.add body off4)) ver4)
              (bifU32 (U32.beq (loadAt addr (USize.add body off5)) ver5)
                (bifU32 (U32.beq (loadAt addr (USize.add body off6)) ver6)
                  U32.one U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first fixed-magic key; `kind` 0=url, 1=rev, 2=version. Returns key off or miss. -/
public unsafe def findFixedKeyGo (addr : USize) (i : USize) (n : USize) (kind : U32) : USize :=
  bifUSize (USize.blt i n)
    (let c := loadAt addr i
     bifUSize (U32.beq c cQuote)
       (let body := USize.add i USize.one
        let after := scanStringGo addr n body
        bifUSize (USize.beq after USize.neg1) USize.neg1
          (let blen := USize.sub (USize.sub after USize.one) body
           let hit :=
             bifU32 (U32.beq kind U32.zero) (matchUrlKey addr body blen)
               (bifU32 (U32.beq kind U32.one) (matchRevKey addr body blen)
                 (matchVersionKey addr body blen))
           bifUSize (U32.beq hit U32.one) i
             (findFixedKeyGo addr after n kind)))
       (findFixedKeyGo addr (USize.add i USize.one) n kind))
    USize.neg1

/-- `1` if `"url"` key present. -/
public unsafe def hasUrl (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findFixedKeyGo addr USize.zero n U32.zero) USize.neg1)
    U32.zero U32.one

/-- `1` if `"rev"` key present. -/
public unsafe def hasRev (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findFixedKeyGo addr USize.zero n U32.one) USize.neg1)
    U32.zero U32.one

/-- `1` if `"version"` key present. -/
public unsafe def hasVersion (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findFixedKeyGo addr USize.zero n U32.two) USize.neg1)
    U32.zero U32.one

end Systems.Manifest
