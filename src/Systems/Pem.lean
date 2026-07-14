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
# Systems.Pem (Systems Lean)

PEM-**shaped** armor block scan over dual caller `addr`/`len` byte views — not full
OpenSSL PEM, not X.509 decode, not PKCS#8 parse, not TLS cert chains.

Recognized shape (RFC 7468-shaped ASCII armor):

* **BEGIN banner** — `-----BEGIN ` + non-empty label + `-----` then line end
* **body** — zero or more lines of standard base64 alphabet (`A–Z a–z 0–9 + / =`)
  and optional blank lines (body lines are counted; padding/`=` not fully validated)
* **END banner** — `-----END ` + **same** label + `-----` then line end
* Multiple complete blocks may be concatenated (optional blank lines between).

Ops:

* **validate** / **scan** — structural block scan; `0` ok, `1` invalid
* **isPem** — `1` if validates, else `0`
* **blockCount** — number of complete armor blocks (0 if invalid)
* **labelOff** / **labelLen** — first block's label span, or miss / 0
* **findLabel** — label-start offset of first block whose label matches a key span, or miss
* **bodyLineCount** — non-empty base64-shaped body lines across all blocks (0 if invalid)

Honesty:

* **Shaped armor only** — no DER/BER decode, no certificate path building, no private-key
  semantics, no Proc-Type/DEK-Info headers, no OpenSSL legacy pre-RFC-7468 variants.
* Labels are exact byte match (case-sensitive). Empty labels rejected.
* Not claimed: full RFC 7468 / OpenSSL / LibreSSL PEM parity.
* Miss sentinel is `USize.neg1` (**LP64 harness**).
* **loadAt dual-param honesty:** ops take caller `(addr, n)`; every `loadAt` index is
  produced only after an `i < n` guard. `loadAt` itself is **not** bounds-parameterized.

## Intentional TCB (Pem-local)

Structural ASCII markers and banner widths are freestanding `@[extern]` axioms kept
**here**. Name-pinned on ComplianceCorpus (`path name=Ident`). Classifiers reuse
`Ascii` for alnum body bytes.
-/

namespace Systems.Pem

open Systems.Scalars
open Systems.Bytes
open Systems.Status
open Systems.Ascii
open Systems.Numerics

/-- ASCII `'-'` (45). -/
@[extern c inline "((uint32_t)45)"] public axiom cDash : U32
/-- ASCII space (32). -/
@[extern c inline "((uint32_t)32)"] public axiom cSp : U32
/-- ASCII LF (10). -/
@[extern c inline "((uint32_t)10)"] public axiom cLf : U32
/-- ASCII CR (13). -/
@[extern c inline "((uint32_t)13)"] public axiom cCr : U32
/-- ASCII `'B'` (66). -/
@[extern c inline "((uint32_t)66)"] public axiom cB : U32
/-- ASCII `'E'` (69). -/
@[extern c inline "((uint32_t)69)"] public axiom cE : U32
/-- ASCII `'G'` (71). -/
@[extern c inline "((uint32_t)71)"] public axiom cG : U32
/-- ASCII `'I'` (73). -/
@[extern c inline "((uint32_t)73)"] public axiom cI : U32
/-- ASCII `'N'` (78). -/
@[extern c inline "((uint32_t)78)"] public axiom cN : U32
/-- ASCII `'D'` (68). -/
@[extern c inline "((uint32_t)68)"] public axiom cD : U32
/-- ASCII `'+'` (43). -/
@[extern c inline "((uint32_t)43)"] public axiom cPlus : U32
/-- ASCII `'/'` (47). -/
@[extern c inline "((uint32_t)47)"] public axiom cSlash : U32
/-- ASCII `'='` (61). -/
@[extern c inline "((uint32_t)61)"] public axiom cPad : U32
/-- Two as `USize`. -/
@[extern c inline "((size_t)2)"] public axiom twoUSize : USize
/-- Three as `USize`. -/
@[extern c inline "((size_t)3)"] public axiom threeUSize : USize
/-- Five as `USize` (dash run length). -/
@[extern c inline "((size_t)5)"] public axiom fiveUSize : USize
/-- Six as `USize` (offset of space after `BEGIN` / past five dashes + `B`). -/
@[extern c inline "((size_t)6)"] public axiom sixUSize : USize
/-- Seven as `USize`. -/
@[extern c inline "((size_t)7)"] public axiom sevenUSize : USize
/-- Eight as `USize`. -/
@[extern c inline "((size_t)8)"] public axiom eightUSize : USize
/-- Nine as `USize` (`-----END ` length). -/
@[extern c inline "((size_t)9)"] public axiom nineUSize : USize
/-- Ten as `USize`. -/
@[extern c inline "((size_t)10)"] public axiom tenUSize : USize
/-- Eleven as `USize` (`-----BEGIN ` length). -/
@[extern c inline "((size_t)11)"] public axiom elevenUSize : USize

/-- Load byte at index as `U32`. Caller ensures `i < n`. -/
public unsafe def loadAt (addr : USize) (i : USize) : U32 :=
  U32.ofU8 (U8.load (USize.add addr i))

/-- `1` if `c` is LF or CR. -/
public unsafe def isLineEnd (c : U32) : U32 :=
  bifU32 (U32.beq c cLf) U32.one
    (bifU32 (U32.beq c cCr) U32.one U32.zero)

/-- Index of first line-end byte in `[i, n)`, or `n` if none. -/
public unsafe def findLineEnd (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (bifUSize (U32.beq (isLineEnd (loadAt addr i)) U32.one) i
      (findLineEnd addr (USize.add i USize.one) n))
    n

/-- Index just past the line ending at `le` (consumes optional CR LF pair). -/
public unsafe def afterLineEnd (addr : USize) (le : USize) (n : USize) : USize :=
  bifUSize (USize.beq le n) n
    (bifUSize (U32.beq (loadAt addr le) cCr)
      (let j := USize.add le USize.one
       bifUSize (USize.blt j n)
         (bifUSize (U32.beq (loadAt addr j) cLf) (USize.add j USize.one) j)
         j)
      (USize.add le USize.one))

/-- `1` if five dashes start at `i` and `i+4 < n`. -/
public unsafe def matchFiveDash (addr : USize) (i : USize) (n : USize) : U32 :=
  bifU32 (USize.blt (USize.add i USize.four) n)
    (bifU32 (U32.beq (loadAt addr i) cDash)
      (bifU32 (U32.beq (loadAt addr (USize.add i USize.one)) cDash)
        (bifU32 (U32.beq (loadAt addr (USize.add i twoUSize)) cDash)
          (bifU32 (U32.beq (loadAt addr (USize.add i threeUSize)) cDash)
            (bifU32 (U32.beq (loadAt addr (USize.add i USize.four)) cDash) U32.one U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- `1` if `-----BEGIN ` starts at `i`. -/
public unsafe def matchBegin (addr : USize) (i : USize) (n : USize) : U32 :=
  bifU32 (USize.blt (USize.add i tenUSize) n)
    (bifU32 (U32.beq (matchFiveDash addr i n) U32.one)
      (bifU32 (U32.beq (loadAt addr (USize.add i fiveUSize)) cB)
        (bifU32 (U32.beq (loadAt addr (USize.add i sixUSize)) cE)
          (bifU32 (U32.beq (loadAt addr (USize.add i sevenUSize)) cG)
            (bifU32 (U32.beq (loadAt addr (USize.add i eightUSize)) cI)
              (bifU32 (U32.beq (loadAt addr (USize.add i nineUSize)) cN)
                (bifU32 (U32.beq (loadAt addr (USize.add i tenUSize)) cSp) U32.one U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- `1` if `-----END ` starts at `i`. -/
public unsafe def matchEnd (addr : USize) (i : USize) (n : USize) : U32 :=
  bifU32 (USize.blt (USize.add i eightUSize) n)
    (bifU32 (U32.beq (matchFiveDash addr i n) U32.one)
      (bifU32 (U32.beq (loadAt addr (USize.add i fiveUSize)) cE)
        (bifU32 (U32.beq (loadAt addr (USize.add i sixUSize)) cN)
          (bifU32 (U32.beq (loadAt addr (USize.add i sevenUSize)) cD)
            (bifU32 (U32.beq (loadAt addr (USize.add i eightUSize)) cSp) U32.one U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- First index `j` in `[i, hi)` where five dashes start, or miss. -/
public unsafe def findFiveDash (addr : USize) (i : USize) (hi : USize) (n : USize) : USize :=
  bifUSize (USize.blt i hi)
    (bifUSize (U32.beq (matchFiveDash addr i n) U32.one) i
      (findFiveDash addr (USize.add i USize.one) hi n))
    USize.neg1

/-- `1` if spans of length `len` at absolute `a` and `b` match. -/
public unsafe def spanEqGo (a : USize) (b : USize) (i : USize) (len : USize) : U32 :=
  bifU32 (USize.blt i len)
    (bifU32 (U8.beq (U8.load (USize.add a i)) (U8.load (USize.add b i)))
      (spanEqGo a b (USize.add i USize.one) len)
      U32.zero)
    U32.one

/-- `1` if equal length-`len` spans match. -/
public unsafe def spanEq (a : USize) (b : USize) (len : USize) : U32 :=
  spanEqGo a b USize.zero len

/-- `1` if `c` is standard base64 alphabet or pad. -/
public unsafe def isB64 (c : U32) : U32 :=
  bifU32 (U32.beq (isAlnum c) U32.one) U32.one
    (bifU32 (U32.beq c cPlus) U32.one
      (bifU32 (U32.beq c cSlash) U32.one
        (bifU32 (U32.beq c cPad) U32.one U32.zero)))

/-- `1` if body line `[lo, hi)` is all base64-shaped bytes (blank ⇒ ok). -/
public unsafe def bodyLineOkGo (addr : USize) (i : USize) (hi : USize) : U32 :=
  bifU32 (USize.blt i hi)
    (bifU32 (U32.beq (isB64 (loadAt addr i)) U32.one)
      (bodyLineOkGo addr (USize.add i USize.one) hi)
      U32.zero)
    U32.one

/-- Skip spaces in `[j, hi)`. -/
public unsafe def skipSp (addr : USize) (j : USize) (hi : USize) : USize :=
  bifUSize (USize.blt j hi)
    (bifUSize (U32.beq (loadAt addr j) cSp)
      (skipSp addr (USize.add j USize.one) hi) j)
    j

/-- Skip blank / space-only lines from `i`. -/
public unsafe def skipBlanks (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     bifUSize (USize.beq i le)
       (skipBlanks addr (afterLineEnd addr le n) n)
       (let j := skipSp addr i le
        bifUSize (USize.beq j le)
          (skipBlanks addr (afterLineEnd addr le n) n)
          i))
    i

/-- Label start for BEGIN banner at `i`, or miss. -/
public unsafe def labelOffAt (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (U32.beq (matchBegin addr i n) U32.one)
    (let lab0 := USize.add i elevenUSize
     let le := findLineEnd addr lab0 n
     let dash := findFiveDash addr lab0 le n
     bifUSize (USize.beq dash USize.neg1) USize.neg1
       (bifUSize (USize.beq dash lab0) USize.neg1 lab0))
    USize.neg1

/-- Label length for BEGIN banner at `i`, or `0`. -/
public unsafe def labelLenAt (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (U32.beq (matchBegin addr i n) U32.one)
    (let lab0 := USize.add i elevenUSize
     let le := findLineEnd addr lab0 n
     let dash := findFiveDash addr lab0 le n
     bifUSize (USize.beq dash USize.neg1) USize.zero
       (bifUSize (USize.beq dash lab0) USize.zero (USize.sub dash lab0)))
    USize.zero

/-- Parse BEGIN banner at `i`: index past banner line end, or miss. -/
public unsafe def parseBeginPast (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (U32.beq (matchBegin addr i n) U32.one)
    (let lab0 := USize.add i elevenUSize
     let le := findLineEnd addr lab0 n
     let dash := findFiveDash addr lab0 le n
     bifUSize (USize.beq dash USize.neg1) USize.neg1
       (bifUSize (USize.beq dash lab0) USize.neg1
         (let afterDash := USize.add dash fiveUSize
          bifUSize (USize.beq afterDash le)
            (afterLineEnd addr le n)
            USize.neg1)))
    USize.neg1

/-- Parse END banner at `i` matching label at absolute `labAbs` length `labLen`. -/
public unsafe def parseEndPast (addr : USize) (i : USize) (n : USize)
    (labAbs : USize) (labLen : USize) : USize :=
  bifUSize (U32.beq (matchEnd addr i n) U32.one)
    (let lab0 := USize.add i nineUSize
     let endLab := USize.add lab0 labLen
     bifUSize (USize.blt (USize.add endLab USize.four) n)
       (bifUSize (U32.beq (spanEq labAbs (USize.add addr lab0) labLen) U32.one)
         (bifUSize (U32.beq (matchFiveDash addr endLab n) U32.one)
           (let afterDash := USize.add endLab fiveUSize
            let le := findLineEnd addr afterDash n
            bifUSize (USize.beq afterDash le)
              (afterLineEnd addr le n)
              USize.neg1)
           USize.neg1)
         USize.neg1)
       USize.neg1)
    USize.neg1

/-- Scan body from `i` until matching END; returns past-end index or miss. -/
public unsafe def scanBodyToEnd (addr : USize) (i : USize) (n : USize)
    (labAbs : USize) (labLen : USize) : USize :=
  bifUSize (USize.blt i n)
    (bifUSize (U32.beq (matchEnd addr i n) U32.one)
      (parseEndPast addr i n labAbs labLen)
      (let le := findLineEnd addr i n
       bifUSize (U32.beq (bodyLineOkGo addr i le) U32.one)
         (scanBodyToEnd addr (afterLineEnd addr le n) n labAbs labLen)
         USize.neg1))
    USize.neg1

/-- Count non-empty body lines from `i` until END (assumes well-formed body). -/
public unsafe def countBodyLinesGo (addr : USize) (i : USize) (n : USize) (acc : USize) : USize :=
  bifUSize (USize.blt i n)
    (bifUSize (U32.beq (matchEnd addr i n) U32.one) acc
      (let le := findLineEnd addr i n
       bifUSize (USize.blt i le)
         (countBodyLinesGo addr (afterLineEnd addr le n) n (USize.add acc USize.one))
         (countBodyLinesGo addr (afterLineEnd addr le n) n acc)))
    acc

/-- Parse one complete PEM block starting at `i`. Returns index past block, or miss. -/
public unsafe def parseBlockPast (addr : USize) (i : USize) (n : USize) : USize :=
  let pastBeg := parseBeginPast addr i n
  bifUSize (USize.beq pastBeg USize.neg1) USize.neg1
    (let lab := labelOffAt addr i n
     let labLen := labelLenAt addr i n
     bifUSize (USize.beq lab USize.neg1) USize.neg1
       (scanBodyToEnd addr pastBeg n (USize.add addr lab) labLen))

/-- Validate from `i`: require complete blocks to end (at least one). -/
public unsafe def validateGo (addr : USize) (i : USize) (n : USize) (got : U32) : U32 :=
  let j := skipBlanks addr i n
  bifU32 (USize.blt j n)
    (let past := parseBlockPast addr j n
     bifU32 (USize.beq past USize.neg1) err
       (validateGo addr past n U32.one))
    (bifU32 (U32.beq got U32.one) ok err)

/-- Structural validate: `0` ok (one or more complete blocks), `1` invalid. Empty → err. -/
public unsafe def validate (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq n USize.zero) err
    (validateGo addr USize.zero n U32.zero)

/-- Alias of `validate`. -/
public unsafe def scan (addr : USize) (n : USize) : U32 :=
  validate addr n

/-- `1` if validates as PEM armor, else `0`. -/
public unsafe def isPem (addr : USize) (n : USize) : U32 :=
  bifU32 (U32.beq (validate addr n) ok) U32.one U32.zero

/-- Count complete blocks from `i` (assumes input validates). -/
public unsafe def blockCountGo (addr : USize) (i : USize) (n : USize) (acc : USize) : USize :=
  let j := skipBlanks addr i n
  bifUSize (USize.blt j n)
    (let past := parseBlockPast addr j n
     bifUSize (USize.beq past USize.neg1) acc
       (blockCountGo addr past n (USize.add acc USize.one)))
    acc

/-- Number of complete armor blocks, or `0` if invalid. -/
public unsafe def blockCount (addr : USize) (n : USize) : USize :=
  bifUSize (U32.beq (validate addr n) ok)
    (blockCountGo addr USize.zero n USize.zero)
    USize.zero

/-- Byte offset of the first block's label, or miss. **LP64 miss.** -/
public unsafe def labelOff (addr : USize) (n : USize) : USize :=
  bifUSize (U32.beq (validate addr n) ok)
    (let j := skipBlanks addr USize.zero n
     labelOffAt addr j n)
    USize.neg1

/-- Length of the first block's label, or `0` if invalid. -/
public unsafe def labelLen (addr : USize) (n : USize) : USize :=
  bifUSize (U32.beq (validate addr n) ok)
    (let j := skipBlanks addr USize.zero n
     labelLenAt addr j n)
    USize.zero

/-- Find first block whose label matches absolute `[key, keyLen)`. Label-start off or miss. -/
public unsafe def findLabelGo (addr : USize) (i : USize) (n : USize)
    (key : USize) (keyLen : USize) : USize :=
  let j := skipBlanks addr i n
  bifUSize (USize.blt j n)
    (let lab := labelOffAt addr j n
     let labLen := labelLenAt addr j n
     bifUSize (USize.beq lab USize.neg1) USize.neg1
       (bifUSize (USize.beq labLen keyLen)
         (bifUSize (U32.beq (spanEq (USize.add addr lab) key keyLen) U32.one) lab
           (let past := parseBlockPast addr j n
            bifUSize (USize.beq past USize.neg1) USize.neg1
              (findLabelGo addr past n key keyLen)))
         (let past := parseBlockPast addr j n
          bifUSize (USize.beq past USize.neg1) USize.neg1
            (findLabelGo addr past n key keyLen))))
    USize.neg1

/-- Label-start offset of first matching block, or miss. **LP64 miss.** -/
public unsafe def findLabel (addr : USize) (n : USize) (key : USize) (keyLen : USize) : USize :=
  bifUSize (U32.beq (validate addr n) ok)
    (findLabelGo addr USize.zero n key keyLen)
    USize.neg1

/-- Count non-empty body lines across all blocks (assumes validates). -/
public unsafe def bodyLineCountGo (addr : USize) (i : USize) (n : USize) (acc : USize) : USize :=
  let j := skipBlanks addr i n
  bifUSize (USize.blt j n)
    (let pastBeg := parseBeginPast addr j n
     bifUSize (USize.beq pastBeg USize.neg1) acc
       (let lines := countBodyLinesGo addr pastBeg n USize.zero
        let past := parseBlockPast addr j n
        bifUSize (USize.beq past USize.neg1) acc
          (bodyLineCountGo addr past n (USize.add acc lines))))
    acc

/-- Non-empty base64-shaped body lines, or `0` if invalid. -/
public unsafe def bodyLineCount (addr : USize) (n : USize) : USize :=
  bifUSize (U32.beq (validate addr n) ok)
    (bodyLineCountGo addr USize.zero n USize.zero)
    USize.zero

end Systems.Pem
