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
# Systems.Edn (Systems Lean)

EDN-**shaped** balanced bracket/brace/paren scan over dual caller `addr`/`len` byte
views — not a full Clojure EDN reader, not tagged literals, not string/character
product, not transit.

Recognized shapes (ASCII bytes):

* **whitespace** — `Ascii.isSpace` plus comma (`,`) as EDN-shaped soft separator
* **atom** — one or more non-space non-delimiter bytes (keywords like `:k`, symbols,
  bare numbers as byte runs — no numeric value product)
* **list** — `(` … `)` with nested forms
* **vector** — `[` … `]`
* **map** — `{` … `}`

Ops:

* **validate** / **scan** — structural balance with matching open/close kinds;
  `0` ok, `1` invalid (incl. depth budget)
* **maxDepth** — maximum open nesting observed (miss if invalid / over budget)
* **atomCount** — number of atoms (keywords and bare atoms)

Honesty:

* **Structural scan only** — no `#inst` / `#uuid` tags, no string escapes, no
  character literals, no namespaced maps (`#:ns{}`), no reader macros, no Clojure
  evaluation.
* Full input must parse as a **sequence of top-level forms** with depth ending at 0
  (empty input is ok). Matching open/close kinds are enforced via nested scan
  (not a general EDN grammar).
* Fixed **depth budget** (`maxDepthDefault` = 64): nesting deeper than 64 is invalid
  (wrap/CPU fence; not a full reader stack).
* Miss on invalid depth paths is `USize.neg1` (**LP64 harness**).
* **loadAt dual-param honesty:** ops take caller `(addr, n)`; every `loadAt` index is
  produced only after an `i < n` / `j < n` guard. `loadAt` itself is **not**
  bounds-parameterized — caller `n` is the sole length bound for all loads.

## Intentional TCB (Edn-local)

Structural ASCII markers and the depth default are freestanding `@[extern]` axioms kept
**here**. Name-pinned on ComplianceCorpus (`path name=Ident`). Whitespace reuses `Ascii`.
-/

namespace Systems.Edn

open Systems.Scalars
open Systems.Bytes
open Systems.Status
open Systems.Ascii

/-- ASCII `'('` (40). -/
@[extern c inline "((uint32_t)40)"] public axiom cLParen : U32
/-- ASCII `')'` (41). -/
@[extern c inline "((uint32_t)41)"] public axiom cRParen : U32
/-- ASCII `'['` (91). -/
@[extern c inline "((uint32_t)91)"] public axiom cLBrack : U32
/-- ASCII `']'` (93). -/
@[extern c inline "((uint32_t)93)"] public axiom cRBrack : U32
/-- ASCII `'{'` (123). -/
@[extern c inline "((uint32_t)123)"] public axiom cLBrace : U32
/-- ASCII `'}'` (125). -/
@[extern c inline "((uint32_t)125)"] public axiom cRBrace : U32
/-- ASCII `','` (44) — EDN-shaped soft whitespace. -/
@[extern c inline "((uint32_t)44)"] public axiom cComma : U32
/-- Default max open nesting depth (64). -/
@[extern c inline "((size_t)64)"] public axiom maxDepthDefault : USize

/-- Load byte at index as `U32`.

Caller ensures `i < n` for the dual-param range that owns `addr` — this helper does not
take `n` (dual-param honesty: bounds live at the scan entrypoints). -/
public unsafe def loadAt (addr : USize) (i : USize) : U32 :=
  U32.ofU8 (U8.load (USize.add addr i))

/-- `1` if `c` is space-class or EDN soft separator `,`. -/
public unsafe def isWs (c : U32) : U32 :=
  bifU32 (U32.beq (isSpace c) U32.one) U32.one
    (bifU32 (U32.beq c cComma) U32.one U32.zero)

/-- Matching closer for open delimiter, or `0` if not an open. -/
public unsafe def matchingClose (c : U32) : U32 :=
  bifU32 (U32.beq c cLParen) cRParen
    (bifU32 (U32.beq c cLBrack) cRBrack
      (bifU32 (U32.beq c cLBrace) cRBrace U32.zero))

/-- `1` if `c` is any open delimiter. -/
public unsafe def isOpen (c : U32) : U32 :=
  bifU32 (U32.beq (matchingClose c) U32.zero) U32.zero U32.one

/-- `1` if `c` is any close delimiter. -/
public unsafe def isClose (c : U32) : U32 :=
  bifU32 (U32.beq c cRParen) U32.one
    (bifU32 (U32.beq c cRBrack) U32.one
      (bifU32 (U32.beq c cRBrace) U32.one U32.zero))

/-- `1` if `c` may appear in an atom (keyword/symbol/number-shaped run). -/
public unsafe def isAtomByte (c : U32) : U32 :=
  bifU32 (U32.beq (isWs c) U32.one) U32.zero
    (bifU32 (U32.beq (isOpen c) U32.one) U32.zero
      (bifU32 (U32.beq (isClose c) U32.one) U32.zero U32.one))

/-- Skip whitespace/commas from `i`. -/
public unsafe def skipWs (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (bifUSize (U32.beq (isWs (loadAt addr i)) U32.one)
      (skipWs addr (USize.add i USize.one) n) i)
    i

/-- End index of atom starting at `i` (caller ensures atom byte at `i`). -/
public unsafe def scanAtom (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (bifUSize (U32.beq (isAtomByte (loadAt addr i)) U32.one)
      (scanAtom addr (USize.add i USize.one) n) i)
    i

/-- Validate forms until matching `expectClose` (`0` = top-level EOF).

Returns next index after successful close (or `n` at top-level EOF), or
`USize.neg1` on error. **LP64 miss** encoding. -/
public unsafe def validateGo (addr : USize) (i : USize) (n : USize)
    (depth : USize) (expectClose : U32) : USize :=
  let j := skipWs addr i n
  bifUSize (USize.blt j n)
    (let c := loadAt addr j
     bifUSize (U32.beq expectClose U32.zero)
       -- top-level: reject bare close; open → nested; atom → continue
       (bifUSize (U32.beq (isClose c) U32.one) USize.neg1
         (bifUSize (U32.beq (isOpen c) U32.one)
           (bifUSize (USize.blt depth maxDepthDefault)
             (let inner := validateGo addr (USize.add j USize.one) n
                   (USize.add depth USize.one) (matchingClose c)
              bifUSize (USize.beq inner USize.neg1) USize.neg1
                (validateGo addr inner n depth U32.zero))
             USize.neg1)
           (bifUSize (U32.beq (isAtomByte c) U32.one)
             (validateGo addr (scanAtom addr j n) n depth U32.zero)
             USize.neg1)))
       -- inside collection: matching close ends; wrong close errs; open/atom continue
       (bifUSize (U32.beq c expectClose)
         (USize.add j USize.one)
         (bifUSize (U32.beq (isClose c) U32.one) USize.neg1
           (bifUSize (U32.beq (isOpen c) U32.one)
             (bifUSize (USize.blt depth maxDepthDefault)
               (let inner := validateGo addr (USize.add j USize.one) n
                     (USize.add depth USize.one) (matchingClose c)
                bifUSize (USize.beq inner USize.neg1) USize.neg1
                  (validateGo addr inner n depth expectClose))
               USize.neg1)
             (bifUSize (U32.beq (isAtomByte c) U32.one)
               (validateGo addr (scanAtom addr j n) n depth expectClose)
               USize.neg1)))))
    (bifUSize (U32.beq expectClose U32.zero) j USize.neg1)

/-- Structural validate: `0` ok, `1` invalid (syntax or depth budget). Empty input is ok. -/
public unsafe def validate (addr : USize) (n : USize) : U32 :=
  let r := validateGo addr USize.zero n USize.zero U32.zero
  bifU32 (USize.beq r USize.neg1) err ok

/-- Alias of `validate`. -/
public unsafe def scan (addr : USize) (n : USize) : U32 :=
  validate addr n

/-- Depth walk after validate already succeeded (balance/match already checked).

Still observes nesting; returns max open nesting. -/
public unsafe def maxDepthSimple (addr : USize) (i : USize) (n : USize)
    (depth : USize) (maxD : USize) : USize :=
  let j := skipWs addr i n
  bifUSize (USize.blt j n)
    (let c := loadAt addr j
     bifUSize (U32.beq (isOpen c) U32.one)
       (let d2 := USize.add depth USize.one
        let m2 := bifUSize (USize.blt maxD d2) d2 maxD
        maxDepthSimple addr (USize.add j USize.one) n d2 m2)
       (bifUSize (U32.beq (isClose c) U32.one)
         (maxDepthSimple addr (USize.add j USize.one) n (USize.sub depth USize.one) maxD)
         (bifUSize (U32.beq (isAtomByte c) U32.one)
           (maxDepthSimple addr (scanAtom addr j n) n depth maxD)
           maxD)))
    maxD

/-- Maximum open nesting, or miss on invalid / over budget. **LP64 miss.** -/
public unsafe def maxDepth (addr : USize) (n : USize) : USize :=
  bifUSize (U32.beq (validate addr n) ok)
    (maxDepthSimple addr USize.zero n USize.zero USize.zero)
    USize.neg1

/-- Atom count walk (validate already succeeded). -/
public unsafe def atomCountSimple (addr : USize) (i : USize) (n : USize) (acc : USize) : USize :=
  let j := skipWs addr i n
  bifUSize (USize.blt j n)
    (let c := loadAt addr j
     bifUSize (U32.beq (isOpen c) U32.one)
       (atomCountSimple addr (USize.add j USize.one) n acc)
       (bifUSize (U32.beq (isClose c) U32.one)
         (atomCountSimple addr (USize.add j USize.one) n acc)
         (bifUSize (U32.beq (isAtomByte c) U32.one)
           (atomCountSimple addr (scanAtom addr j n) n (USize.add acc USize.one))
           acc)))
    acc

/-- Number of atoms, or miss on invalid. **LP64 miss.** -/
public unsafe def atomCount (addr : USize) (n : USize) : USize :=
  bifUSize (U32.beq (validate addr n) ok)
    (atomCountSimple addr USize.zero n USize.zero)
    USize.neg1

end Systems.Edn
