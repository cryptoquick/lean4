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

/-!
# Systems.Xml (Systems Lean)

XML-**shaped** well-formedness scan over dual caller `addr`/`len` byte views — not full
XML 1.0/1.1, not a DOM, not malloc-backed trees.

Recognized shapes (ASCII-oriented bytes):

* **text** — bytes outside tags (may include spaces; `<`/`>` only inside tags)
* **open tag** — `<name…>` (name starts immediately after `<`; no nested `<`)
* **close tag** — `</name…>`
* **empty tag** — `<name…/>` (optional spaces before `/`)
* **comment** — `<!-- … -->` (no `--` nesting rules beyond finding `-->`)

Ops:

* **validate** / **scan** — structural well-formedness; `0` ok, `1` invalid
* **maxDepth** — maximum open-tag nesting observed (comments/empty do not nest)
* **openCount** — number of open tags (not counting empty/self-closing)
* **elemCount** — open + empty element starts

Honesty:

* **Tag balance only** — depth ends at 0; open/close counts match. **Name matching
  between open and close is not verified** (no stack of names without caller buffer).
* Not claimed: full XML/DOM, namespaces, CDATA, processing instructions, DTD,
  entity expansion, attribute parsing product API, or UTF-8 name rules.
* Attributes may appear as raw bytes between name and `>` / `/>` (not validated).
* Miss/error paths use status `1`; depths are `USize` counts.

## Intentional TCB (Xml-local)

Structural ASCII markers are freestanding `@[extern]` axioms kept **here**.
Name-pinned on ComplianceCorpus (`path name=Ident`).
-/

namespace Systems.Xml

open Systems.Scalars
open Systems.Bytes
open Systems.Status

/-- ASCII `'<'` (60). -/
@[extern c inline "((uint32_t)60)"] public axiom cLt : U32
/-- ASCII `'>'` (62). -/
@[extern c inline "((uint32_t)62)"] public axiom cGt : U32
/-- ASCII `'/'` (47). -/
@[extern c inline "((uint32_t)47)"] public axiom cSlash : U32
/-- ASCII `'!'` (33). -/
@[extern c inline "((uint32_t)33)"] public axiom cBang : U32
/-- ASCII `'-'` (45). -/
@[extern c inline "((uint32_t)45)"] public axiom cMinus : U32
/-- Three as `USize` (comment open `!--` width after `<`). -/
@[extern c inline "((size_t)3)"] public axiom threeUSize : USize
/-- Two as `USize`. -/
@[extern c inline "((size_t)2)"] public axiom twoUSize : USize

/-- Load byte at index as `U32`. Caller ensures bounds. -/
public unsafe def loadAt (addr : USize) (i : USize) (n : USize) : U32 :=
  bifU32 (USize.blt i n) (U32.ofU8 (U8.load (USize.add addr i))) U32.zero

/-- Index of first `>` in `[i, n)`, or `USize.neg1`. **LP64 miss.** -/
public unsafe def findGt (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (bifUSize (U32.beq (loadAt addr i n) cGt) i
      (findGt addr (USize.add i USize.one) n))
    USize.neg1

/-- Index of comment end `-->` starting search at `i`, returns index of `>`, or miss. -/
public unsafe def findCommentEnd (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt (USize.add i twoUSize) n)
    (bifUSize (U32.beq (loadAt addr i n) cMinus)
      (bifUSize (U32.beq (loadAt addr (USize.add i USize.one) n) cMinus)
        (bifUSize (U32.beq (loadAt addr (USize.add i twoUSize) n) cGt)
          (USize.add i twoUSize)
          (findCommentEnd addr (USize.add i USize.one) n))
        (findCommentEnd addr (USize.add i USize.one) n))
      (findCommentEnd addr (USize.add i USize.one) n))
    USize.neg1

/-- `1` if tag body `[lo, gt)` ends with self-close `/` (optional spaces not stripped;
last non-`>` byte before `gt` is `/`). `gt` is index of `>`. -/
public unsafe def isEmptyTag (addr : USize) (lo : USize) (gt : USize) : U32 :=
  bifU32 (USize.blt lo gt)
    (bifU32 (U32.beq (loadAt addr (USize.sub gt USize.one) gt) cSlash) U32.one U32.zero)
    U32.zero

/-- `1` if bytes at `i` start `!--` (comment after `<`). Needs `i+2 < n`. -/
public unsafe def isCommentOpen (addr : USize) (i : USize) (n : USize) : U32 :=
  bifU32 (USize.blt (USize.add i twoUSize) n)
    (bifU32 (U32.beq (loadAt addr i n) cBang)
      (bifU32 (U32.beq (loadAt addr (USize.add i USize.one) n) cMinus)
        (bifU32 (U32.beq (loadAt addr (USize.add i twoUSize) n) cMinus) U32.one U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Scan loop: depth tracking. Returns `0` ok / `1` err.

`depth` current open count; `maxD` max depth seen. -/
public unsafe def validateGo (addr : USize) (i : USize) (n : USize)
    (depth : USize) : U32 :=
  bifU32 (USize.blt i n)
    (bifU32 (U32.beq (loadAt addr i n) cLt)
      (let body := USize.add i USize.one
       bifU32 (USize.blt body n)
         (bifU32 (U32.beq (isCommentOpen addr body n) U32.one)
           (let ce := findCommentEnd addr (USize.add body threeUSize) n
            bifU32 (USize.beq ce USize.neg1) err
              (validateGo addr (USize.add ce USize.one) n depth))
           (bifU32 (U32.beq (loadAt addr body n) cSlash)
             -- close tag
             (bifU32 (USize.beq depth USize.zero) err
               (let gt := findGt addr body n
                bifU32 (USize.beq gt USize.neg1) err
                  (validateGo addr (USize.add gt USize.one) n (USize.sub depth USize.one))))
             (let gt := findGt addr body n
              bifU32 (USize.beq gt USize.neg1) err
                (bifU32 (U32.beq (isEmptyTag addr body gt) U32.one)
                  (validateGo addr (USize.add gt USize.one) n depth)
                  (validateGo addr (USize.add gt USize.one) n (USize.add depth USize.one))))))
         err)
      -- bare `>` outside tag is invalid; other text ok
      (bifU32 (U32.beq (loadAt addr i n) cGt) err
        (validateGo addr (USize.add i USize.one) n depth)))
    (bifU32 (USize.beq depth USize.zero) ok err)

/-- Structural validate (tag balance): `0` ok, `1` invalid. Empty input is ok. -/
public unsafe def validate (addr : USize) (n : USize) : U32 :=
  validateGo addr USize.zero n USize.zero

/-- Alias of `validate` (scan = well-formedness only). -/
public unsafe def scan (addr : USize) (n : USize) : U32 :=
  validate addr n

/-- Max depth loop. On error returns `USize.neg1`. -/
public unsafe def maxDepthGo (addr : USize) (i : USize) (n : USize)
    (depth : USize) (maxD : USize) : USize :=
  bifUSize (USize.blt i n)
    (bifUSize (U32.beq (loadAt addr i n) cLt)
      (let body := USize.add i USize.one
       bifUSize (USize.blt body n)
         (bifUSize (U32.beq (isCommentOpen addr body n) U32.one)
           (let ce := findCommentEnd addr (USize.add body threeUSize) n
            bifUSize (USize.beq ce USize.neg1) USize.neg1
              (maxDepthGo addr (USize.add ce USize.one) n depth maxD))
           (bifUSize (U32.beq (loadAt addr body n) cSlash)
             (bifUSize (USize.beq depth USize.zero) USize.neg1
               (let gt := findGt addr body n
                bifUSize (USize.beq gt USize.neg1) USize.neg1
                  (maxDepthGo addr (USize.add gt USize.one) n (USize.sub depth USize.one) maxD)))
             (let gt := findGt addr body n
              bifUSize (USize.beq gt USize.neg1) USize.neg1
                (bifUSize (U32.beq (isEmptyTag addr body gt) U32.one)
                  (maxDepthGo addr (USize.add gt USize.one) n depth maxD)
                  (let d2 := USize.add depth USize.one
                   let m2 := bifUSize (USize.blt maxD d2) d2 maxD
                   maxDepthGo addr (USize.add gt USize.one) n d2 m2)))))
         USize.neg1)
      (bifUSize (U32.beq (loadAt addr i n) cGt) USize.neg1
        (maxDepthGo addr (USize.add i USize.one) n depth maxD)))
    (bifUSize (USize.beq depth USize.zero) maxD USize.neg1)

/-- Maximum open-tag nesting, or miss on invalid. **LP64 miss.** -/
public unsafe def maxDepth (addr : USize) (n : USize) : USize :=
  maxDepthGo addr USize.zero n USize.zero USize.zero

/-- Count open tags (kind 0) from `i`. Miss on invalid. -/
public unsafe def openCountGo (addr : USize) (i : USize) (n : USize)
    (depth : USize) (acc : USize) : USize :=
  bifUSize (USize.blt i n)
    (bifUSize (U32.beq (loadAt addr i n) cLt)
      (let body := USize.add i USize.one
       bifUSize (USize.blt body n)
         (bifUSize (U32.beq (isCommentOpen addr body n) U32.one)
           (let ce := findCommentEnd addr (USize.add body threeUSize) n
            bifUSize (USize.beq ce USize.neg1) USize.neg1
              (openCountGo addr (USize.add ce USize.one) n depth acc))
           (bifUSize (U32.beq (loadAt addr body n) cSlash)
             (bifUSize (USize.beq depth USize.zero) USize.neg1
               (let gt := findGt addr body n
                bifUSize (USize.beq gt USize.neg1) USize.neg1
                  (openCountGo addr (USize.add gt USize.one) n (USize.sub depth USize.one) acc)))
             (let gt := findGt addr body n
              bifUSize (USize.beq gt USize.neg1) USize.neg1
                (bifUSize (U32.beq (isEmptyTag addr body gt) U32.one)
                  (openCountGo addr (USize.add gt USize.one) n depth acc)
                  (openCountGo addr (USize.add gt USize.one) n
                    (USize.add depth USize.one) (USize.add acc USize.one))))))
         USize.neg1)
      (bifUSize (U32.beq (loadAt addr i n) cGt) USize.neg1
        (openCountGo addr (USize.add i USize.one) n depth acc)))
    (bifUSize (USize.beq depth USize.zero) acc USize.neg1)

/-- Number of open (non-empty) tags, or miss on invalid. **LP64 miss.** -/
public unsafe def openCount (addr : USize) (n : USize) : USize :=
  openCountGo addr USize.zero n USize.zero USize.zero

/-- Count element starts (open + empty). Miss on invalid. -/
public unsafe def elemCountGo (addr : USize) (i : USize) (n : USize)
    (depth : USize) (acc : USize) : USize :=
  bifUSize (USize.blt i n)
    (bifUSize (U32.beq (loadAt addr i n) cLt)
      (let body := USize.add i USize.one
       bifUSize (USize.blt body n)
         (bifUSize (U32.beq (isCommentOpen addr body n) U32.one)
           (let ce := findCommentEnd addr (USize.add body threeUSize) n
            bifUSize (USize.beq ce USize.neg1) USize.neg1
              (elemCountGo addr (USize.add ce USize.one) n depth acc))
           (bifUSize (U32.beq (loadAt addr body n) cSlash)
             (bifUSize (USize.beq depth USize.zero) USize.neg1
               (let gt := findGt addr body n
                bifUSize (USize.beq gt USize.neg1) USize.neg1
                  (elemCountGo addr (USize.add gt USize.one) n (USize.sub depth USize.one) acc)))
             (let gt := findGt addr body n
              bifUSize (USize.beq gt USize.neg1) USize.neg1
                (bifUSize (U32.beq (isEmptyTag addr body gt) U32.one)
                  (elemCountGo addr (USize.add gt USize.one) n depth (USize.add acc USize.one))
                  (elemCountGo addr (USize.add gt USize.one) n
                    (USize.add depth USize.one) (USize.add acc USize.one))))))
         USize.neg1)
      (bifUSize (U32.beq (loadAt addr i n) cGt) USize.neg1
        (elemCountGo addr (USize.add i USize.one) n depth acc)))
    (bifUSize (USize.beq depth USize.zero) acc USize.neg1)

/-- Number of element starts (open + empty), or miss on invalid. **LP64 miss.** -/
public unsafe def elemCount (addr : USize) (n : USize) : USize :=
  elemCountGo addr USize.zero n USize.zero USize.zero

end Systems.Xml
