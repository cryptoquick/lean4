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
# Systems.Sexp (Systems Lean)

S-expression-**shaped** balanced-paren scan over dual caller `addr`/`len` byte views —
not a full Common Lisp / Scheme reader, not reader macros, not packages.

Recognized shapes (ASCII bytes):

* **whitespace** — `Ascii.isSpace` (space / HT / LF / VT / FF / CR)
* **atom** — one or more non-space non-paren bytes (no string quotes / escapes product)
* **list** — `(` … `)` with nested lists/atoms and free whitespace

Ops:

* **validate** / **scan** — structural balance; `0` ok, `1` invalid (incl. depth budget)
* **maxDepth** — maximum open-paren nesting observed (miss if invalid / over budget)
* **atomCount** — number of atoms
* **listCount** — number of `(` list opens (empty `()` counts as one list)

Honesty:

* **Paren balance + atom scan only** — no dotted pairs, no quote/quasiquote, no
  numbers-as-values product, no symbol intern, no `#|` comments or `;` line comments.
* Full input must parse as a **sequence of top-level sexps** with depth ending at 0
  (empty input is ok).
* Fixed **depth budget** (`maxDepthDefault` = 64): open-paren nesting deeper than 64 is
  invalid (wrap/CPU fence; not a full reader stack).
* Miss on invalid depth paths is `USize.neg1` (**LP64 harness**).
* **loadAt dual-param honesty:** ops take caller `(addr, n)`; every `loadAt` index is
  produced only after an `i < n` / `j < n` guard. `loadAt` itself is **not**
  bounds-parameterized (unlike Xml/Csv `loadAt addr i n`) — caller `n` is the
  sole length bound for all loads.

## Intentional TCB (Sexp-local)

Structural ASCII markers and the depth default are freestanding `@[extern]` axioms kept
**here**. Name-pinned on ComplianceCorpus (`path name=Ident`). Whitespace reuses `Ascii`.
-/

namespace Systems.Sexp

open Systems.Scalars
open Systems.Bytes
open Systems.Status
open Systems.Ascii

/-- ASCII `'('` (40). -/
@[extern c inline "((uint32_t)40)"] public axiom cLParen : U32
/-- ASCII `')'` (41). -/
@[extern c inline "((uint32_t)41)"] public axiom cRParen : U32
/-- Default max open-paren nesting depth (64). -/
@[extern c inline "((size_t)64)"] public axiom maxDepthDefault : USize

/-- Load byte at index as `U32`.

Caller ensures `i < n` for the dual-param range that owns `addr` — this helper does not
take `n` (dual-param honesty: bounds live at the scan entrypoints). -/
public unsafe def loadAt (addr : USize) (i : USize) : U32 :=
  U32.ofU8 (U8.load (USize.add addr i))

/-- `1` if `c` is space-class. -/
public unsafe def isWs (c : U32) : U32 :=
  isSpace c

/-- `1` if `c` starts/ends structure (paren). -/
public unsafe def isParen (c : U32) : U32 :=
  bifU32 (U32.beq c cLParen) U32.one
    (bifU32 (U32.beq c cRParen) U32.one U32.zero)

/-- `1` if `c` may appear in an atom. -/
public unsafe def isAtomByte (c : U32) : U32 :=
  bifU32 (U32.beq (isWs c) U32.one) U32.zero
    (bifU32 (U32.beq (isParen c) U32.one) U32.zero U32.one)

/-- Skip whitespace from `i`. -/
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

/-- Validate loop with current paren depth (rejects depth `> maxDepthDefault`). -/
public unsafe def validateGo (addr : USize) (i : USize) (n : USize) (depth : USize) : U32 :=
  let j := skipWs addr i n
  bifU32 (USize.blt j n)
    (let c := loadAt addr j
     bifU32 (U32.beq c cLParen)
       (bifU32 (USize.blt depth maxDepthDefault)
         (validateGo addr (USize.add j USize.one) n (USize.add depth USize.one))
         err)
       (bifU32 (U32.beq c cRParen)
         (bifU32 (USize.beq depth USize.zero) err
           (validateGo addr (USize.add j USize.one) n (USize.sub depth USize.one)))
         (bifU32 (U32.beq (isAtomByte c) U32.one)
           (validateGo addr (scanAtom addr j n) n depth)
           err)))
    (bifU32 (USize.beq depth USize.zero) ok err)

/-- Structural validate: `0` ok, `1` invalid (syntax or depth budget). Empty input is ok. -/
public unsafe def validate (addr : USize) (n : USize) : U32 :=
  validateGo addr USize.zero n USize.zero

/-- Alias of `validate`. -/
public unsafe def scan (addr : USize) (n : USize) : U32 :=
  validate addr n

/-- Max depth loop. Miss on invalid / over budget. -/
public unsafe def maxDepthGo (addr : USize) (i : USize) (n : USize)
    (depth : USize) (maxD : USize) : USize :=
  let j := skipWs addr i n
  bifUSize (USize.blt j n)
    (let c := loadAt addr j
     bifUSize (U32.beq c cLParen)
       (bifUSize (USize.blt depth maxDepthDefault)
         (let d2 := USize.add depth USize.one
          let m2 := bifUSize (USize.blt maxD d2) d2 maxD
          maxDepthGo addr (USize.add j USize.one) n d2 m2)
         USize.neg1)
       (bifUSize (U32.beq c cRParen)
         (bifUSize (USize.beq depth USize.zero) USize.neg1
           (maxDepthGo addr (USize.add j USize.one) n (USize.sub depth USize.one) maxD))
         (bifUSize (U32.beq (isAtomByte c) U32.one)
           (maxDepthGo addr (scanAtom addr j n) n depth maxD)
           USize.neg1)))
    (bifUSize (USize.beq depth USize.zero) maxD USize.neg1)

/-- Maximum open-paren nesting, or miss on invalid / over budget. **LP64 miss.** -/
public unsafe def maxDepth (addr : USize) (n : USize) : USize :=
  maxDepthGo addr USize.zero n USize.zero USize.zero

/-- Count atoms while tracking depth. Miss on invalid / over budget. -/
public unsafe def atomCountGo (addr : USize) (i : USize) (n : USize)
    (depth : USize) (acc : USize) : USize :=
  let j := skipWs addr i n
  bifUSize (USize.blt j n)
    (let c := loadAt addr j
     bifUSize (U32.beq c cLParen)
       (bifUSize (USize.blt depth maxDepthDefault)
         (atomCountGo addr (USize.add j USize.one) n (USize.add depth USize.one) acc)
         USize.neg1)
       (bifUSize (U32.beq c cRParen)
         (bifUSize (USize.beq depth USize.zero) USize.neg1
           (atomCountGo addr (USize.add j USize.one) n (USize.sub depth USize.one) acc))
         (bifUSize (U32.beq (isAtomByte c) U32.one)
           (atomCountGo addr (scanAtom addr j n) n depth (USize.add acc USize.one))
           USize.neg1)))
    (bifUSize (USize.beq depth USize.zero) acc USize.neg1)

/-- Number of atoms, or miss on invalid. **LP64 miss.** -/
public unsafe def atomCount (addr : USize) (n : USize) : USize :=
  atomCountGo addr USize.zero n USize.zero USize.zero

/-- Count list opens `(` while tracking depth. Miss on invalid / over budget. -/
public unsafe def listCountGo (addr : USize) (i : USize) (n : USize)
    (depth : USize) (acc : USize) : USize :=
  let j := skipWs addr i n
  bifUSize (USize.blt j n)
    (let c := loadAt addr j
     bifUSize (U32.beq c cLParen)
       (bifUSize (USize.blt depth maxDepthDefault)
         (listCountGo addr (USize.add j USize.one) n (USize.add depth USize.one)
           (USize.add acc USize.one))
         USize.neg1)
       (bifUSize (U32.beq c cRParen)
         (bifUSize (USize.beq depth USize.zero) USize.neg1
           (listCountGo addr (USize.add j USize.one) n (USize.sub depth USize.one) acc))
         (bifUSize (U32.beq (isAtomByte c) U32.one)
           (listCountGo addr (scanAtom addr j n) n depth acc)
           USize.neg1)))
    (bifUSize (USize.beq depth USize.zero) acc USize.neg1)

/-- Number of list opens, or miss on invalid. **LP64 miss.** -/
public unsafe def listCount (addr : USize) (n : USize) : USize :=
  listCountGo addr USize.zero n USize.zero USize.zero

end Systems.Sexp
