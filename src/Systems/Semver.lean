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
# Systems.Semver (Systems Lean)

SemVer-**shaped** ASCII scan over dual caller `addr`/`len` byte views — not full
SemVer 2.0 precedence, not version-range matching, not a package registry client.

Recognized shape:

```
MAJOR.MINOR.PATCH[-prerelease][+build]
```

* **MAJOR / MINOR / PATCH** — one or more ASCII digits each, separated by `'.'`
* Optional **pre-release** (`-…`) and/or **build** (`+…`) suffixes are accepted with
  **truncated honesty**: non-empty remainder after the marker, no precedence graph

Ops:

* **validate** / **scan** — structural form; `0` ok, `1` invalid
* **major** / **minor** / **patch** — decimal `U32` if the component fits, else `0`
  (also `0` if the view is not a valid SemVer-shaped string)
* **majorOff** / **minorOff** / **patchOff** — component start offsets, or miss
* **majorLen** / **minorLen** / **patchLen** — digit-run lengths, or `0` if invalid

Honesty:

* **Shaped scan only** — no SemVer 2.0 pre-release/build identifier grammar product,
  no core/pre/build precedence compare, no caret/tilde range engines.
* Leading zeros in numeric components are accepted (not rejected as full SemVer would).
* **loadAt dual-param honesty:** every load index is under `i < n` after length fences.
  `loadAt` itself is **not** bounds-parameterized. Index walk uses live `i`.

## Intentional TCB (Semver-local)

Structural separators (`.` `-` `+`), digit constants, and U32 overflow ceilings are
freestanding `@[extern]` axioms kept **here**. Name-pinned on ComplianceCorpus
(`path name=Ident`). Classifiers reuse `Ascii.isDigit`.
-/

namespace Systems.Semver

open Systems.Scalars
open Systems.Bytes
open Systems.Status
open Systems.Ascii
open Systems.Numerics

/-- ASCII `'.'` (46). -/
@[extern c inline "((uint32_t)46)"] public axiom cDot : U32
/-- ASCII `'-'` (45). -/
@[extern c inline "((uint32_t)45)"] public axiom cMinus : U32
/-- ASCII `'+'` (43). -/
@[extern c inline "((uint32_t)43)"] public axiom cPlus : U32
/-- ASCII `'0'` (48). -/
@[extern c inline "((uint32_t)48)"] public axiom c0 : U32
/-- Ten (decimal radix). -/
@[extern c inline "((uint32_t)10)"] public axiom tenU32 : U32
/-- `UINT32_MAX / 10` (429496729). -/
@[extern c inline "((uint32_t)429496729)"] public axiom u32MaxDiv10 : U32
/-- `UINT32_MAX % 10` (5). -/
@[extern c inline "((uint32_t)5)"] public axiom u32MaxMod10 : U32

/-- Load byte at index as `U32`. Caller ensures `i < n`. -/
public unsafe def loadAt (addr : USize) (i : USize) : U32 :=
  U32.ofU8 (U8.load (USize.add addr i))

/-- Digit value of ASCII `c` (`c - '0'`); caller must ensure `isDigit c`. -/
@[inline] public def digitVal (c : U32) : U32 :=
  U32.sub c c0

/-- `1` if multiplying `acc` by 10 and adding `d` would overflow `U32`. -/
public def u32WouldOverflow (acc : U32) (d : U32) : U32 :=
  bifU32 (U32.blt u32MaxDiv10 acc) U32.one
    (bifU32 (U32.beq acc u32MaxDiv10)
      (bifU32 (U32.blt u32MaxMod10 d) U32.one U32.zero)
      U32.zero)

/-- Continue digit run from `i` (may be end). Returns end index after digits. -/
public unsafe def scanDigitsGo (addr : USize) (n : USize) (i : USize) : USize :=
  bifUSize (USize.blt i n)
    (bifUSize (U32.beq (isDigit (loadAt addr i)) U32.one)
      (scanDigitsGo addr n (USize.add i USize.one))
      i)
    i

/-- Advance past a non-empty digit run starting at `i`. Returns end index, or miss. -/
public unsafe def scanDigits (addr : USize) (n : USize) (i : USize) : USize :=
  bifUSize (USize.blt i n)
    (bifUSize (U32.beq (isDigit (loadAt addr i)) U32.one)
      (scanDigitsGo addr n (USize.add i USize.one))
      USize.neg1)
    USize.neg1

/-- After core `MAJOR.MINOR.PATCH` ending at `i`: accept end or non-empty `-`/`+` suffix. -/
public unsafe def validateSuffix (addr : USize) (n : USize) (i : USize) : U32 :=
  bifU32 (USize.beq i n) ok
    (let c := loadAt addr i
     bifU32 (U32.beq c cMinus)
       (bifU32 (USize.blt (USize.add i USize.one) n) ok err)
       (bifU32 (U32.beq c cPlus)
         (bifU32 (USize.blt (USize.add i USize.one) n) ok err)
         err))

/-- `0` if the view is SemVer-shaped `MAJOR.MINOR.PATCH` with optional truncated suffix. -/
public unsafe def validate (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq n USize.zero) err
    (let mEnd := scanDigits addr n USize.zero
     bifU32 (USize.beq mEnd USize.neg1) err
       (bifU32 (USize.blt mEnd n)
         (bifU32 (U32.beq (loadAt addr mEnd) cDot)
           (let iMin := USize.add mEnd USize.one
            let nEnd := scanDigits addr n iMin
            bifU32 (USize.beq nEnd USize.neg1) err
              (bifU32 (USize.blt nEnd n)
                (bifU32 (U32.beq (loadAt addr nEnd) cDot)
                  (let iPat := USize.add nEnd USize.one
                   let pEnd := scanDigits addr n iPat
                   bifU32 (USize.beq pEnd USize.neg1) err
                     (validateSuffix addr n pEnd))
                  err)
                err))
           err)
         err))

/-- Alias of `validate`. -/
public unsafe def scan (addr : USize) (n : USize) : U32 :=
  validate addr n

/-- Parse decimal digits in `[lo, hi)` as `U32`, or `0` on empty/overflow. -/
public unsafe def parseU32SpanGo (addr : USize) (lo : USize) (hi : USize) (acc : U32)
    (seen : U32) : U32 :=
  bifU32 (USize.blt lo hi)
    (let c := loadAt addr lo
     bifU32 (U32.beq (isDigit c) U32.one)
       (let d := digitVal c
        bifU32 (U32.beq (u32WouldOverflow acc d) U32.one) U32.zero
          (parseU32SpanGo addr (USize.add lo USize.one) hi
            (U32.add (U32.mul acc tenU32) d) U32.one))
       U32.zero)
    (bifU32 (U32.beq seen U32.one) acc U32.zero)

/-- MAJOR as `U32`, or `0` if invalid form / overflow. -/
public unsafe def major (addr : USize) (n : USize) : U32 :=
  bifU32 (U32.beq (validate addr n) U32.zero)
    (let mEnd := scanDigits addr n USize.zero
     parseU32SpanGo addr USize.zero mEnd U32.zero U32.zero)
    U32.zero

/-- MINOR as `U32`, or `0` if invalid form / overflow. -/
public unsafe def minor (addr : USize) (n : USize) : U32 :=
  bifU32 (U32.beq (validate addr n) U32.zero)
    (let mEnd := scanDigits addr n USize.zero
     let iMin := USize.add mEnd USize.one
     let nEnd := scanDigits addr n iMin
     parseU32SpanGo addr iMin nEnd U32.zero U32.zero)
    U32.zero

/-- PATCH as `U32`, or `0` if invalid form / overflow. -/
public unsafe def patch (addr : USize) (n : USize) : U32 :=
  bifU32 (U32.beq (validate addr n) U32.zero)
    (let mEnd := scanDigits addr n USize.zero
     let iMin := USize.add mEnd USize.one
     let nEnd := scanDigits addr n iMin
     let iPat := USize.add nEnd USize.one
     let pEnd := scanDigits addr n iPat
     parseU32SpanGo addr iPat pEnd U32.zero U32.zero)
    U32.zero

/-- MAJOR start offset (`0` when valid), or miss if invalid. **LP64 miss** = `neg1`. -/
public unsafe def majorOff (addr : USize) (n : USize) : USize :=
  bifUSize (U32.beq (validate addr n) U32.zero) USize.zero USize.neg1

/-- MAJOR digit-run length, or `0` if invalid. -/
public unsafe def majorLen (addr : USize) (n : USize) : USize :=
  bifUSize (U32.beq (validate addr n) U32.zero)
    (scanDigits addr n USize.zero)
    USize.zero

/-- MINOR start offset, or miss if invalid. -/
public unsafe def minorOff (addr : USize) (n : USize) : USize :=
  bifUSize (U32.beq (validate addr n) U32.zero)
    (USize.add (scanDigits addr n USize.zero) USize.one)
    USize.neg1

/-- MINOR digit-run length, or `0` if invalid. -/
public unsafe def minorLen (addr : USize) (n : USize) : USize :=
  bifUSize (U32.beq (validate addr n) U32.zero)
    (let mEnd := scanDigits addr n USize.zero
     let iMin := USize.add mEnd USize.one
     let nEnd := scanDigits addr n iMin
     USize.sub nEnd iMin)
    USize.zero

/-- PATCH start offset, or miss if invalid. -/
public unsafe def patchOff (addr : USize) (n : USize) : USize :=
  bifUSize (U32.beq (validate addr n) U32.zero)
    (let mEnd := scanDigits addr n USize.zero
     let iMin := USize.add mEnd USize.one
     let nEnd := scanDigits addr n iMin
     USize.add nEnd USize.one)
    USize.neg1

/-- PATCH digit-run length, or `0` if invalid. -/
public unsafe def patchLen (addr : USize) (n : USize) : USize :=
  bifUSize (U32.beq (validate addr n) U32.zero)
    (let mEnd := scanDigits addr n USize.zero
     let iMin := USize.add mEnd USize.one
     let nEnd := scanDigits addr n iMin
     let iPat := USize.add nEnd USize.one
     let pEnd := scanDigits addr n iPat
     USize.sub pEnd iPat)
    USize.zero

end Systems.Semver
