/-
Copyright (c) 2026 Lean FRO, LLC. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Hunter Beast
-/
module
prelude
public import Systems.Scalars
public import Systems.Numerics

/-!
# Systems.Ascii (Systems Lean)

ASCII **ctype-shaped** classifiers and case maps over freestanding `U8`/`U32` code units —
not locale `ctype.h`, not Unicode, not full `Init.Data.Char`.

Ops (return `1`/`0` as `U32` unless noted):

* **isDigit** / **isAlpha** / **isAlnum** / **isSpace** / **isHex**
* **toLower** / **toUpper** — identity outside the mapped ASCII letter ranges

Honesty:

* Ranges are **7-bit ASCII** only (`0..127` semantics for letters/digits/space/hex).
  Values `≥ 128` (e.g. `0xFF`) are **not** alpha/digit/hex/space.
* Not claimed: locale, Unicode categories, wide char, or C `isprint`/`ispunct` full set.

Prefer pure Lean (`U32.blt` / `U32.beq` / bif) over per-classifier axioms. Decimal
constants only in freestanding inlines.
-/

namespace Systems.Ascii

open Systems.Scalars
open Systems.Numerics

/-- ASCII `'0'` (48). -/
@[extern c inline "((uint32_t)48)"] public axiom c0 : U32
/-- ASCII `'9'` (57). -/
@[extern c inline "((uint32_t)57)"] public axiom c9 : U32
/-- ASCII `'A'` (65). -/
@[extern c inline "((uint32_t)65)"] public axiom cA : U32
/-- ASCII `'F'` (70). -/
@[extern c inline "((uint32_t)70)"] public axiom cF : U32
/-- ASCII `'Z'` (90). -/
@[extern c inline "((uint32_t)90)"] public axiom cZ : U32
/-- ASCII `'a'` (97). -/
@[extern c inline "((uint32_t)97)"] public axiom ca : U32
/-- ASCII `'f'` (102). -/
@[extern c inline "((uint32_t)102)"] public axiom cf : U32
/-- ASCII `'z'` (122). -/
@[extern c inline "((uint32_t)122)"] public axiom cz : U32
/-- ASCII space (32). -/
@[extern c inline "((uint32_t)32)"] public axiom cSpace : U32
/-- ASCII HT (9). -/
@[extern c inline "((uint32_t)9)"] public axiom cTab : U32
/-- ASCII LF (10). -/
@[extern c inline "((uint32_t)10)"] public axiom cLf : U32
/-- ASCII VT (11). -/
@[extern c inline "((uint32_t)11)"] public axiom cVt : U32
/-- ASCII FF (12). -/
@[extern c inline "((uint32_t)12)"] public axiom cFf : U32
/-- ASCII CR (13). -/
@[extern c inline "((uint32_t)13)"] public axiom cCr : U32
/-- Case fold delta `'a' - 'A'` (32). -/
@[extern c inline "((uint32_t)32)"] public axiom caseDelta : U32

/-- Widen `U32` → `USize` for U8 case-map narrow (local; Map parity). -/
@[extern c inline "((size_t)(uint32_t)(#1))"]
public axiom USize.ofU32 : U32 → USize

/-- `1` if `c` is `'0'..'9'`, else `0`. -/
public def isDigit (c : U32) : U32 :=
  bifU32 (U32.blt c c0) U32.zero
    (bifU32 (U32.blt c9 c) U32.zero U32.one)

/-- `1` if `c` is `'A'..'Z'`, else `0`. -/
public def isUpper (c : U32) : U32 :=
  bifU32 (U32.blt c cA) U32.zero
    (bifU32 (U32.blt cZ c) U32.zero U32.one)

/-- `1` if `c` is `'a'..'z'`, else `0`. -/
public def isLower (c : U32) : U32 :=
  bifU32 (U32.blt c ca) U32.zero
    (bifU32 (U32.blt cz c) U32.zero U32.one)

/-- `1` if `c` is `'A'..'Z'` or `'a'..'z'`, else `0`. -/
public def isAlpha (c : U32) : U32 :=
  bifU32 (U32.beq (isUpper c) U32.one) U32.one (isLower c)

/-- `1` if digit or alpha, else `0`. -/
public def isAlnum (c : U32) : U32 :=
  bifU32 (U32.beq (isDigit c) U32.one) U32.one (isAlpha c)

/-- `1` if ASCII space class: space, HT, LF, VT, FF, CR. -/
public def isSpace (c : U32) : U32 :=
  bifU32 (U32.beq c cSpace) U32.one
    (bifU32 (U32.beq c cTab) U32.one
      (bifU32 (U32.beq c cLf) U32.one
        (bifU32 (U32.beq c cVt) U32.one
          (bifU32 (U32.beq c cFf) U32.one
            (bifU32 (U32.beq c cCr) U32.one U32.zero)))))

/-- `1` if `'0'..'9'` / `'A'..'F'` / `'a'..'f'`, else `0`. -/
public def isHex (c : U32) : U32 :=
  bifU32 (U32.beq (isDigit c) U32.one) U32.one
    (bifU32 (U32.blt c cA) U32.zero
      (bifU32 (U32.blt cF c)
        (bifU32 (U32.blt c ca) U32.zero
          (bifU32 (U32.blt cf c) U32.zero U32.one))
        U32.one))

/-- Map `'A'..'Z'` → lower; identity otherwise. -/
public def toLower (c : U32) : U32 :=
  bifU32 (U32.beq (isUpper c) U32.one) (U32.add c caseDelta) c

/-- Map `'a'..'z'` → upper; identity otherwise. -/
public def toUpper (c : U32) : U32 :=
  bifU32 (U32.beq (isLower c) U32.one) (U32.sub c caseDelta) c

/-! ## U8 wrappers (promote via `U32.ofU8`) -/

@[inline] public def isDigitU8 (c : U8) : U32 := isDigit (U32.ofU8 c)
@[inline] public def isAlphaU8 (c : U8) : U32 := isAlpha (U32.ofU8 c)
@[inline] public def isAlnumU8 (c : U8) : U32 := isAlnum (U32.ofU8 c)
@[inline] public def isSpaceU8 (c : U8) : U32 := isSpace (U32.ofU8 c)
@[inline] public def isHexU8 (c : U8) : U32 := isHex (U32.ofU8 c)

/-- Lowercase map returning low 8 bits as `U8` (identity outside mapped range). -/
public def toLowerU8 (c : U8) : U8 :=
  U8.ofUSize (USize.ofU32 (toLower (U32.ofU8 c)))

/-- Uppercase map returning low 8 bits as `U8`. -/
public def toUpperU8 (c : U8) : U8 :=
  U8.ofUSize (USize.ofU32 (toUpper (U32.ofU8 c)))

end Systems.Ascii
