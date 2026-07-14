/-
Copyright (c) 2026 Lean FRO, LLC. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Hunter Beast
-/
module
prelude
public import Systems.Scalars
public import Systems.Bytes
public import Systems.Numerics
public import Systems.Status
public import Systems.Ascii

/-!
# Systems.Json (Systems Lean)

JSON **scan/validate** over dual caller `addr`/`len` byte views — scan-**shaped**, not a
full JSON library (no DOM, no numbers-as-values product, no arbitrary-depth malloc stack).

Ops:

* **skipWs** — advance past ASCII space class
* **scan** — index after one complete value, or `USize.neg1` on error (**LP64 miss**)
* **validate** / **validateDepth** — status `0` if the full range is one JSON value
  (plus trailing whitespace), else `1` (syntax) or `3` (depth bound)

Honesty:

* **Shaped structural scan only** — objects/arrays/strings/numbers/`true`/`false`/`null`.
* Fixed **depth limit** (default 32 via `maxDepthDefault`); no heap alloc / recursive malloc.
* Not claimed: full RFC 8259 edge cases, UTF-8 string content validation, big-int numbers,
  streaming DOM, or pretty-print.
* Prefer pure Lean + `U8.load`; constants are local freestanding axioms (name-pinned).

## Intentional TCB (Json-local)

Structural character constants, depth default, and `USize.ofU32` / small widths are
freestanding `@[extern]` axioms kept **here**. Name-pinned on ComplianceCorpus
(`path name=Ident`). Classifiers reuse `Systems.Ascii.isSpace` / `isDigit`.
-/

namespace Systems.Json

open Systems.Scalars
open Systems.Bytes
open Systems.Numerics
open Systems.Status
open Systems.Ascii

/-- ASCII `'{'` (123). -/
@[extern c inline "((uint32_t)123)"] public axiom cLBrace : U32
/-- ASCII `'}'` (125). -/
@[extern c inline "((uint32_t)125)"] public axiom cRBrace : U32
/-- ASCII `'['` (91). -/
@[extern c inline "((uint32_t)91)"] public axiom cLBrack : U32
/-- ASCII `']'` (93). -/
@[extern c inline "((uint32_t)93)"] public axiom cRBrack : U32
/-- ASCII `':'` (58). -/
@[extern c inline "((uint32_t)58)"] public axiom cColon : U32
/-- ASCII `','` (44). -/
@[extern c inline "((uint32_t)44)"] public axiom cComma : U32
/-- ASCII `'"'` (34). -/
@[extern c inline "((uint32_t)34)"] public axiom cQuote : U32
/-- ASCII `'\\'` (92). -/
@[extern c inline "((uint32_t)92)"] public axiom cBSlash : U32
/-- ASCII `'-'` (45). -/
@[extern c inline "((uint32_t)45)"] public axiom cMinus : U32
/-- ASCII `'+'` (43). -/
@[extern c inline "((uint32_t)43)"] public axiom cPlus : U32
/-- ASCII `'.'` (46). -/
@[extern c inline "((uint32_t)46)"] public axiom cDot : U32
/-- ASCII `'0'` (48). -/
@[extern c inline "((uint32_t)48)"] public axiom c0 : U32
/-- ASCII `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom ce : U32
/-- ASCII `'E'` (69). -/
@[extern c inline "((uint32_t)69)"] public axiom cE : U32
/-- ASCII `'t'` (116). -/
@[extern c inline "((uint32_t)116)"] public axiom ct : U32
/-- ASCII `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom cr : U32
/-- ASCII `'u'` (117). -/
@[extern c inline "((uint32_t)117)"] public axiom cu : U32
/-- ASCII `'f'` (102). -/
@[extern c inline "((uint32_t)102)"] public axiom cf : U32
/-- ASCII `'a'` (97). -/
@[extern c inline "((uint32_t)97)"] public axiom ca : U32
/-- ASCII `'l'` (108). -/
@[extern c inline "((uint32_t)108)"] public axiom cl : U32
/-- ASCII `'s'` (115). -/
@[extern c inline "((uint32_t)115)"] public axiom cs : U32
/-- ASCII `'n'` (110). -/
@[extern c inline "((uint32_t)110)"] public axiom cn : U32
/-- Control-char ceiling (`0x20` = 32): string bytes must be `≥ 0x20` unless escaped. -/
@[extern c inline "((uint32_t)32)"] public axiom b20 : U32
/-- Default max nesting depth (32). -/
@[extern c inline "((size_t)32)"] public axiom maxDepthDefault : USize
/-- Two as `USize`. -/
@[extern c inline "((size_t)2)"] public axiom twoUSize : USize
/-- Three as `USize`. -/
@[extern c inline "((size_t)3)"] public axiom threeUSize : USize
/-- Four as `USize`. -/
@[extern c inline "((size_t)4)"] public axiom fourUSize : USize
/-- Widen `U32` → `USize`. -/
@[extern c inline "((size_t)(uint32_t)(#1))"]
public axiom USize.ofU32 : U32 → USize

/-- Skip ASCII space class starting at `i`. Returns first non-space index (or `n`). -/
public unsafe def skipWs (addr : USize) (n : USize) (i : USize) : USize :=
  bifUSize (USize.blt i n)
    (bifUSize (U32.beq (isSpace (U32.ofU8 (U8.load (USize.add addr i)))) U32.one)
      (skipWs addr n (USize.add i USize.one))
      i)
    i

/-- Load byte at `i` as `U32` when `i < n`; caller must ensure bounds. -/
public unsafe def loadAt (addr : USize) (i : USize) : U32 :=
  U32.ofU8 (U8.load (USize.add addr i))

/-- Scan string body after opening quote; returns index after closing quote, or miss. -/
public unsafe def scanStringGo (addr : USize) (n : USize) (i : USize) : USize :=
  bifUSize (USize.blt i n)
    (let c := loadAt addr i
     bifUSize (U32.beq c cQuote) (USize.add i USize.one)
       (bifUSize (U32.beq c cBSlash)
         (bifUSize (USize.blt (USize.add i USize.one) n)
           (scanStringGo addr n (USize.add i twoUSize))
           USize.neg1)
         (bifUSize (U32.blt c b20) USize.neg1
           (scanStringGo addr n (USize.add i USize.one)))))
    USize.neg1

/-- Scan string starting at `i` (must be `"`); returns index after string, or miss. -/
public unsafe def scanString (addr : USize) (n : USize) (i : USize) : USize :=
  bifUSize (USize.blt i n)
    (bifUSize (U32.beq (loadAt addr i) cQuote)
      (scanStringGo addr n (USize.add i USize.one))
      USize.neg1)
    USize.neg1

/-- Scan one-or-more digits starting at `i`; returns end index, or miss if none. -/
public unsafe def scanDigits (addr : USize) (n : USize) (i : USize) (seen : U32) : USize :=
  bifUSize (USize.blt i n)
    (bifUSize (U32.beq (isDigit (loadAt addr i)) U32.one)
      (scanDigits addr n (USize.add i USize.one) U32.one)
      (bifUSize (U32.beq seen U32.one) i USize.neg1))
    (bifUSize (U32.beq seen U32.one) i USize.neg1)

/-- Optional fraction `.` + digits. -/
public unsafe def scanFrac (addr : USize) (n : USize) (i : USize) : USize :=
  bifUSize (USize.blt i n)
    (bifUSize (U32.beq (loadAt addr i) cDot)
      (scanDigits addr n (USize.add i USize.one) U32.zero)
      i)
    i

/-- Optional exponent `e`/`E` + optional sign + digits. -/
public unsafe def scanExp (addr : USize) (n : USize) (i : USize) : USize :=
  bifUSize (USize.blt i n)
    (let c := loadAt addr i
     bifUSize (U32.beq c ce)
       (let j := USize.add i USize.one
        bifUSize (USize.blt j n)
          (let s := loadAt addr j
           bifUSize (U32.beq s cPlus)
             (scanDigits addr n (USize.add j USize.one) U32.zero)
             (bifUSize (U32.beq s cMinus)
               (scanDigits addr n (USize.add j USize.one) U32.zero)
               (scanDigits addr n j U32.zero)))
          USize.neg1)
       (bifUSize (U32.beq c cE)
         (let j := USize.add i USize.one
          bifUSize (USize.blt j n)
            (let s := loadAt addr j
             bifUSize (U32.beq s cPlus)
               (scanDigits addr n (USize.add j USize.one) U32.zero)
               (bifUSize (U32.beq s cMinus)
                 (scanDigits addr n (USize.add j USize.one) U32.zero)
                 (scanDigits addr n j U32.zero)))
            USize.neg1)
         i))
    i

/-- Scan number at `i`; returns index after number, or miss. -/
public unsafe def scanNumber (addr : USize) (n : USize) (i : USize) : USize :=
  bifUSize (USize.blt i n)
    (let j0 :=
      bifUSize (U32.beq (loadAt addr i) cMinus) (USize.add i USize.one) i
     bifUSize (USize.blt j0 n)
       (bifUSize (U32.beq (isDigit (loadAt addr j0)) U32.one)
         (let j1 := scanDigits addr n j0 U32.zero
          bifUSize (USize.beq j1 USize.neg1) USize.neg1
            (let j2 := scanFrac addr n j1
             bifUSize (USize.beq j2 USize.neg1) USize.neg1
               (scanExp addr n j2)))
         USize.neg1)
       USize.neg1)
    USize.neg1

/-- Match exact 4-byte literal at `i` (e.g. `true` / `null`). -/
public unsafe def match4 (addr : USize) (n : USize) (i : USize)
    (a b c d : U32) : USize :=
  bifUSize (USize.blt (USize.add i threeUSize) n)
    (bifUSize (U32.beq (loadAt addr i) a)
      (bifUSize (U32.beq (loadAt addr (USize.add i USize.one)) b)
        (bifUSize (U32.beq (loadAt addr (USize.add i twoUSize)) c)
          (bifUSize (U32.beq (loadAt addr (USize.add i threeUSize)) d)
            (USize.add i fourUSize)
            USize.neg1)
          USize.neg1)
        USize.neg1)
      USize.neg1)
    USize.neg1

/-- Match exact 5-byte literal `false` at `i`. -/
public unsafe def matchFalse (addr : USize) (n : USize) (i : USize) : USize :=
  bifUSize (USize.blt (USize.add i fourUSize) n)
    (bifUSize (U32.beq (loadAt addr i) cf)
      (bifUSize (U32.beq (loadAt addr (USize.add i USize.one)) ca)
        (bifUSize (U32.beq (loadAt addr (USize.add i twoUSize)) cl)
          (bifUSize (U32.beq (loadAt addr (USize.add i threeUSize)) cs)
            (bifUSize (U32.beq (loadAt addr (USize.add i fourUSize)) ce)
              (USize.add (USize.add i fourUSize) USize.one)
              USize.neg1)
            USize.neg1)
          USize.neg1)
        USize.neg1)
      USize.neg1)
    USize.neg1


/-- Kind: value. -/
@[extern c inline "((uint32_t)0)"] public axiom kValue : U32
/-- Kind: object body (may be empty). -/
@[extern c inline "((uint32_t)1)"] public axiom kObj : U32
/-- Kind: array body (may be empty). -/
@[extern c inline "((uint32_t)2)"] public axiom kArr : U32
/-- Kind: object body after `,` (member required; rejects trailing comma). -/
@[extern c inline "((uint32_t)3)"] public axiom kObjNeed : U32
/-- Kind: array body after `,` (elem required; rejects trailing comma). -/
@[extern c inline "((uint32_t)4)"] public axiom kArrNeed : U32

/-- Recursive JSON scanner state machine (self-recursive only; freestanding has no `mutual`).

`kind`: `kValue` / `kObj` / `kArr` / `kObjNeed` / `kArrNeed`. -/
public unsafe def scanGo (addr : USize) (n : USize) (i : USize) (depth : USize) (kind : U32) : USize :=
  bifUSize (U32.beq kind kValue)
    (let j := skipWs addr n i
     bifUSize (USize.blt j n)
       (let c := loadAt addr j
        bifUSize (U32.beq c cQuote)
          (scanString addr n j)
          (bifUSize (U32.beq c cLBrace)
            (bifUSize (USize.beq depth USize.zero)
              USize.neg1
              (scanGo addr n (USize.add j USize.one) (USize.sub depth USize.one) kObj))
            (bifUSize (U32.beq c cLBrack)
              (bifUSize (USize.beq depth USize.zero)
                USize.neg1
                (scanGo addr n (USize.add j USize.one) (USize.sub depth USize.one) kArr))
              (bifUSize (U32.beq c ct)
                (match4 addr n j ct cr cu ce)
                (bifUSize (U32.beq c cf)
                  (matchFalse addr n j)
                  (bifUSize (U32.beq c cn)
                    (match4 addr n j cn cu cl cl)
                    (bifUSize (U32.beq c cMinus)
                      (scanNumber addr n j)
                      (bifUSize (U32.beq (isDigit c) U32.one)
                        (scanNumber addr n j)
                        USize.neg1))))))))
       USize.neg1)
    (let j := skipWs addr n i
     bifUSize (USize.blt j n)
       (let isObj := bifU32 (U32.beq kind kObj) U32.one
         (bifU32 (U32.beq kind kObjNeed) U32.one U32.zero)
        let endCh := bifU32 (U32.beq isObj U32.one) cRBrace cRBrack
        let allowEmpty := bifU32 (U32.beq kind kObj) U32.one
          (bifU32 (U32.beq kind kArr) U32.one U32.zero)
        bifUSize (U32.beq (loadAt addr j) endCh)
          (bifUSize (U32.beq allowEmpty U32.one) (USize.add j USize.one) USize.neg1)
          (bifUSize (U32.beq isObj U32.one)
            (let i1 := scanString addr n j
             bifUSize (USize.beq i1 USize.neg1)
               USize.neg1
               (let i2 := skipWs addr n i1
                bifUSize (USize.blt i2 n)
                  (bifUSize (U32.beq (loadAt addr i2) cColon)
                    (let i3 := scanGo addr n (USize.add i2 USize.one) depth kValue
                     bifUSize (USize.beq i3 USize.neg1)
                       USize.neg1
                       (let i4 := skipWs addr n i3
                        bifUSize (USize.blt i4 n)
                          (let c := loadAt addr i4
                           bifUSize (U32.beq c cComma)
                             (scanGo addr n (USize.add i4 USize.one) depth kObjNeed)
                             (bifUSize (U32.beq c cRBrace)
                               (USize.add i4 USize.one)
                               USize.neg1))
                          USize.neg1))
                    USize.neg1)
                  USize.neg1))
            (let i1 := scanGo addr n j depth kValue
             bifUSize (USize.beq i1 USize.neg1)
               USize.neg1
               (let i2 := skipWs addr n i1
                bifUSize (USize.blt i2 n)
                  (let c := loadAt addr i2
                   bifUSize (U32.beq c cComma)
                     (scanGo addr n (USize.add i2 USize.one) depth kArrNeed)
                     (bifUSize (U32.beq c cRBrack)
                       (USize.add i2 USize.one)
                       USize.neg1))
                  USize.neg1))))
       USize.neg1)

/-- Index after one JSON value starting at `i` with depth budget, or `USize.neg1`. -/
public unsafe def scanAt (addr : USize) (n : USize) (i : USize) (depth : USize) : USize :=
  scanGo addr n i depth kValue

/-- Index after one JSON value from start of range with default depth, or miss. -/
public unsafe def scan (addr : USize) (n : USize) : USize :=
  scanGo addr n USize.zero maxDepthDefault kValue

/-- Status of full-range validate with explicit depth: `0` ok, `1` invalid. -/
public unsafe def validateDepth (addr : USize) (n : USize) (maxDepth : USize) : U32 :=
  let stop := scanGo addr n USize.zero maxDepth kValue
  bifU32 (USize.beq stop USize.neg1) err
    (let j := skipWs addr n stop
     bifU32 (USize.beq j n) ok err)

/-- Status of full-range validate (default depth 32): `0` ok, `1` invalid. -/
public unsafe def validate (addr : USize) (n : USize) : U32 :=
  validateDepth addr n maxDepthDefault

end Systems.Json
