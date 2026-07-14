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
# Systems.Regex (Systems Lean)

Regex-**shaped** pattern scan over dual caller `addr`/`len` byte views — not full PCRE,
not POSIX ERE/BRE, not capture groups / lookaround / backrefs.

Supported pattern atoms (byte-oriented):

* **literal** — any byte other than `.` `*` `\` matches itself
* **`.`** — any single byte
* **`\\`** — escape: next pattern byte is a literal (including `\.` `\*` `\\`)
* **`*`** — postfix quantifier on the preceding atom (zero or more; greedy + backtrack)

Ops:

* **matchAt** — match pattern against text starting at index `ti`; end index or miss
* **scan** — match from text start; end index of match or `USize.neg1`
* **fullMatch** / **validate** — status `0` if pattern matches the **entire** text
* **find** — first start offset where a match exists, or miss

Honesty:

* **Shaped scan only** — no malloc, no capture buffers, no UTF-8 awareness.
* Not claimed: full PCRE/JS/Python regex, character classes beyond escaped literals,
  anchors `^`/`$`, alternation `|`, `{n,m}`, or linear-time guarantees on adversarial
  patterns (classic NFA backtrack shape).
* Miss sentinel is `USize.neg1` (**LP64 harness**).

## Intentional TCB (Regex-local)

Pattern specials (`.` `*` `\`) are freestanding `@[extern]` axioms kept **here**.
Name-pinned on ComplianceCorpus (`path name=Ident`).
-/

namespace Systems.Regex

open Systems.Scalars
open Systems.Bytes
open Systems.Status

/-- ASCII `'.'` (46). -/
@[extern c inline "((uint32_t)46)"] public axiom cDot : U32
/-- ASCII `'*'` (42). -/
@[extern c inline "((uint32_t)42)"] public axiom cStar : U32
/-- ASCII `'\\'` (92). -/
@[extern c inline "((uint32_t)92)"] public axiom cBSlash : U32
/-- Two as `USize`. -/
@[extern c inline "((size_t)2)"] public axiom twoUSize : USize

/-- Load pattern/text byte at index as `U32`. Caller ensures bounds. -/
public unsafe def loadAt (addr : USize) (i : USize) : U32 :=
  U32.ofU8 (U8.load (USize.add addr i))

/-- Parse one atom at `pi`: returns next pattern index after the atom, or miss.

Atom is either `\\X` (two bytes) or a single non-`*` byte. Does not consume postfix `*`. -/
public unsafe def atomEnd (pat : USize) (pn : USize) (pi : USize) : USize :=
  bifUSize (USize.blt pi pn)
    (let c := loadAt pat pi
     bifUSize (U32.beq c cStar) USize.neg1
       (bifUSize (U32.beq c cBSlash)
         (bifUSize (USize.blt (USize.add pi USize.one) pn)
           (USize.add pi twoUSize)
           USize.neg1)
         (USize.add pi USize.one)))
    USize.neg1

/-- `1` if atom at `pi` matches text byte at `ti` (both in range for atom/text as needed).

Caller ensures `ti < tn` and atom is well-formed (`atomEnd` succeeded). -/
public unsafe def atomMatches (pat : USize) (pi : USize) (text : USize) (ti : USize) : U32 :=
  let c := loadAt pat pi
  bifU32 (U32.beq c cBSlash)
    (bifU32 (U8.beq (U8.load (USize.add pat (USize.add pi USize.one)))
      (U8.load (USize.add text ti))) U32.one U32.zero)
    (bifU32 (U32.beq c cDot) U32.one
      (bifU32 (U8.beq (U8.load (USize.add pat pi)) (U8.load (USize.add text ti)))
        U32.one U32.zero))

/-- Match `pat[pi..pn)` against `text[ti..tn)`. Returns end text index, or miss.

Handles postfix `*` with greedy-then-backtrack recursion (self-TCO style via single def). -/
public unsafe def matchGo (pat : USize) (pn : USize) (pi : USize)
    (text : USize) (tn : USize) (ti : USize) : USize :=
  bifUSize (USize.blt pi pn)
    (let aEnd := atomEnd pat pn pi
     bifUSize (USize.beq aEnd USize.neg1) USize.neg1
       (let hasStar :=
         bifU32 (USize.blt aEnd pn)
           (bifU32 (U32.beq (loadAt pat aEnd) cStar) U32.one U32.zero)
           U32.zero
        bifUSize (U32.beq hasStar U32.one)
          (let rest := USize.add aEnd USize.one
           -- Prefer consuming one more atom when possible; on failure try rest at `ti`.
           bifUSize (USize.blt ti tn)
             (bifUSize (U32.beq (atomMatches pat pi text ti) U32.one)
               (let more := matchGo pat pn pi text tn (USize.add ti USize.one)
                bifUSize (USize.beq more USize.neg1)
                  (matchGo pat pn rest text tn ti)
                  more)
               (matchGo pat pn rest text tn ti))
             (matchGo pat pn rest text tn ti))
          (bifUSize (USize.blt ti tn)
            (bifUSize (U32.beq (atomMatches pat pi text ti) U32.one)
              (matchGo pat pn aEnd text tn (USize.add ti USize.one))
              USize.neg1)
            USize.neg1)))
    ti

/-- Match pattern against text starting at `ti`. End index or `USize.neg1`. **LP64 miss.** -/
public unsafe def matchAt (pat : USize) (pn : USize) (text : USize) (tn : USize)
    (ti : USize) : USize :=
  bifUSize (USize.blt tn ti) USize.neg1
    (matchGo pat pn USize.zero text tn ti)

/-- Scan from text start: end index of a match of the pattern as a **prefix**, or miss.

Does **not** require consuming the whole text (pair with `fullMatch` for that). -/
public unsafe def scan (pat : USize) (pn : USize) (text : USize) (tn : USize) : USize :=
  matchGo pat pn USize.zero text tn USize.zero

/-- Status `0` if pattern matches the entire text, else `1`. Empty pattern matches empty only. -/
public unsafe def fullMatch (pat : USize) (pn : USize) (text : USize) (tn : USize) : U32 :=
  let stop := matchGo pat pn USize.zero text tn USize.zero
  bifU32 (USize.beq stop USize.neg1) err
    (bifU32 (USize.beq stop tn) ok err)

/-- Alias of `fullMatch` (validate-shaped name). -/
public unsafe def validate (pat : USize) (pn : USize) (text : USize) (tn : USize) : U32 :=
  fullMatch pat pn text tn

/-- First start offset in text where `matchAt` succeeds, or `USize.neg1`. **LP64 miss.** -/
public unsafe def findGo (pat : USize) (pn : USize) (text : USize) (tn : USize)
    (ti : USize) : USize :=
  bifUSize (USize.blt ti tn)
    (let stop := matchGo pat pn USize.zero text tn ti
     bifUSize (USize.beq stop USize.neg1)
       (findGo pat pn text tn (USize.add ti USize.one))
       ti)
    (bifUSize (USize.beq tn ti)
      (let stop := matchGo pat pn USize.zero text tn ti
       bifUSize (USize.beq stop USize.neg1) USize.neg1 ti)
      USize.neg1)

/-- First start offset of a substring match, or miss (also tries empty match at `tn`). -/
public unsafe def find (pat : USize) (pn : USize) (text : USize) (tn : USize) : USize :=
  findGo pat pn text tn USize.zero

end Systems.Regex
