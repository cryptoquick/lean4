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
# Systems.Ini (Systems Lean)

INI-**shaped** section / key scan over dual caller `addr`/`len` byte views — not full
`ConfigParser`, not TOML/JSON, not malloc-backed maps of keys.

Recognized line shapes (ASCII bytes; `\n` / `\r\n` line ends):

* **blank** — empty line (optional trailing `\r`)
* **comment** — line whose first byte is `';` or `#`
* **section** — `[name]` with non-empty `name` (no `]` inside name)
* **key=value** — first `=` splits non-empty key from value (value may be empty)

Ops:

* **validate** — structural scan; `0` ok, `1` invalid
* **sectionCount** — number of well-formed `[section]` lines
* **findSection** — byte offset of matching `[`, or miss
* **findKey** — byte offset of matching key on a `key=value` line, or miss
* **valueOff** / **valueLen** — value span for a key offset from `findKey`

Honesty:

* **Shaped scan only** — no interpolation, no nested sections, no multiline values,
  no quote rules, no duplicate-key policy, no write/update API.
* Not claimed: full Python `configparser`, Windows INI semantics, UTF-8 names, or
  case-folding. Leading spaces on keys/sections are significant (not stripped).
* Miss sentinel is `USize.neg1` (**LP64 harness**).

## Intentional TCB (Ini-local)

Structural ASCII markers are freestanding `@[extern]` axioms kept **here**.
Name-pinned on ComplianceCorpus (`path name=Ident`).
-/

namespace Systems.Ini

open Systems.Scalars
open Systems.Bytes
open Systems.Status

/-- ASCII `'['` (91). -/
@[extern c inline "((uint32_t)91)"] public axiom cLBrack : U32
/-- ASCII `']'` (93). -/
@[extern c inline "((uint32_t)93)"] public axiom cRBrack : U32
/-- ASCII `'='` (61). -/
@[extern c inline "((uint32_t)61)"] public axiom cEq : U32
/-- ASCII `';'` (59). -/
@[extern c inline "((uint32_t)59)"] public axiom cSemi : U32
/-- ASCII `'#'` (35). -/
@[extern c inline "((uint32_t)35)"] public axiom cHash : U32
/-- ASCII LF (10). -/
@[extern c inline "((uint32_t)10)"] public axiom cLf : U32
/-- ASCII CR (13). -/
@[extern c inline "((uint32_t)13)"] public axiom cCr : U32

/-- Load byte at index as `U32`. Caller ensures bounds. -/
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

/-- Index just past the line ending at `le` (consumes optional CR LF pair).

`le` is either `n` or the index of CR/LF. -/
public unsafe def afterLineEnd (addr : USize) (le : USize) (n : USize) : USize :=
  bifUSize (USize.beq le n) n
    (bifUSize (U32.beq (loadAt addr le) cCr)
      (let j := USize.add le USize.one
       bifUSize (USize.blt j n)
         (bifUSize (U32.beq (loadAt addr j) cLf) (USize.add j USize.one) j)
         j)
      (USize.add le USize.one))

/-- `1` if spans `[a,a+n)` and `[b,b+n)` are equal. -/
public unsafe def spanEqGo (a : USize) (b : USize) (i : USize) (n : USize) : U32 :=
  bifU32 (USize.blt i n)
    (bifU32 (U8.beq (U8.load (USize.add a i)) (U8.load (USize.add b i)))
      (spanEqGo a b (USize.add i USize.one) n)
      U32.zero)
    U32.one

/-- `1` if equal length-`n` spans match. -/
public unsafe def spanEq (a : USize) (b : USize) (n : USize) : U32 :=
  spanEqGo a b USize.zero n

/-- First `=` index in `[lo, hi)`, or `USize.neg1`. **LP64 miss.** -/
public unsafe def findEq (addr : USize) (lo : USize) (hi : USize) : USize :=
  bifUSize (USize.blt lo hi)
    (bifUSize (U32.beq (loadAt addr lo) cEq) lo
      (findEq addr (USize.add lo USize.one) hi))
    USize.neg1

/-- First `]` index in `[lo, hi)`, or miss. -/
public unsafe def findRBrack (addr : USize) (lo : USize) (hi : USize) : USize :=
  bifUSize (USize.blt lo hi)
    (bifUSize (U32.beq (loadAt addr lo) cRBrack) lo
      (findRBrack addr (USize.add lo USize.one) hi))
    USize.neg1

/-- Status of one line `[line, le)`: `0` ok, `1` invalid. -/
public unsafe def lineOk (addr : USize) (line : USize) (le : USize) : U32 :=
  bifU32 (USize.beq line le) ok
    (let c0 := loadAt addr line
     bifU32 (U32.beq c0 cSemi) ok
       (bifU32 (U32.beq c0 cHash) ok
         (bifU32 (U32.beq c0 cLBrack)
           (let rb := findRBrack addr (USize.add line USize.one) le
            bifU32 (USize.beq rb USize.neg1) err
              (bifU32 (USize.beq rb (USize.add line USize.one)) err
                (bifU32 (USize.beq (USize.add rb USize.one) le) ok err)))
           (let eq := findEq addr line le
            bifU32 (USize.beq eq USize.neg1) err
              (bifU32 (USize.beq eq line) err ok)))))

/-- Validate loop from line start `i`. -/
public unsafe def validateGo (addr : USize) (i : USize) (n : USize) : U32 :=
  bifU32 (USize.blt i n)
    (let le := findLineEnd addr i n
     bifU32 (U32.beq (lineOk addr i le) ok)
       (validateGo addr (afterLineEnd addr le n) n)
       err)
    ok

/-- Structural validate: `0` ok, `1` invalid. Empty input is ok. -/
public unsafe def validate (addr : USize) (n : USize) : U32 :=
  validateGo addr USize.zero n

/-- Count well-formed section headers from `i`. -/
public unsafe def sectionCountGo (addr : USize) (i : USize) (n : USize) (acc : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     bifUSize (USize.blt i le)
       (bifUSize (U32.beq (loadAt addr i) cLBrack)
         (let rb := findRBrack addr (USize.add i USize.one) le
          bifUSize (USize.beq rb USize.neg1)
            (sectionCountGo addr (afterLineEnd addr le n) n acc)
            (bifUSize (USize.beq rb (USize.add i USize.one))
              (sectionCountGo addr (afterLineEnd addr le n) n acc)
              (bifUSize (USize.beq (USize.add rb USize.one) le)
                (sectionCountGo addr (afterLineEnd addr le n) n (USize.add acc USize.one))
                (sectionCountGo addr (afterLineEnd addr le n) n acc))))
         (sectionCountGo addr (afterLineEnd addr le n) n acc))
       (sectionCountGo addr (afterLineEnd addr le n) n acc))
    acc

/-- Number of well-formed `[section]` lines. -/
public unsafe def sectionCount (addr : USize) (n : USize) : USize :=
  sectionCountGo addr USize.zero n USize.zero

/-- Find section named by `[nameAddr, nameLen)`: offset of `[`, or miss. -/
public unsafe def findSectionGo (addr : USize) (i : USize) (n : USize)
    (nameAddr : USize) (nameLen : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     bifUSize (USize.blt i le)
       (bifUSize (U32.beq (loadAt addr i) cLBrack)
         (let nameStart := USize.add i USize.one
          let rb := findRBrack addr nameStart le
          bifUSize (USize.beq rb USize.neg1)
            (findSectionGo addr (afterLineEnd addr le n) n nameAddr nameLen)
            (bifUSize (USize.beq (USize.add rb USize.one) le)
              (let sn := USize.sub rb nameStart
               bifUSize (USize.beq sn nameLen)
                 (bifUSize (U32.beq (spanEq (USize.add addr nameStart) nameAddr nameLen) U32.one)
                   i
                   (findSectionGo addr (afterLineEnd addr le n) n nameAddr nameLen))
                 (findSectionGo addr (afterLineEnd addr le n) n nameAddr nameLen))
              (findSectionGo addr (afterLineEnd addr le n) n nameAddr nameLen)))
         (findSectionGo addr (afterLineEnd addr le n) n nameAddr nameLen))
       (findSectionGo addr (afterLineEnd addr le n) n nameAddr nameLen))
    USize.neg1

/-- Offset of `[` for first matching section, or `USize.neg1`. **LP64 miss.** -/
public unsafe def findSection (addr : USize) (n : USize)
    (nameAddr : USize) (nameLen : USize) : USize :=
  bifUSize (USize.beq nameLen USize.zero) USize.neg1
    (findSectionGo addr USize.zero n nameAddr nameLen)

/-- Find `key=value` line with key equal to `[keyAddr, keyLen)`. Returns key offset. -/
public unsafe def findKeyGo (addr : USize) (i : USize) (n : USize)
    (keyAddr : USize) (keyLen : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     bifUSize (USize.blt i le)
       (let c0 := loadAt addr i
        bifUSize (U32.beq c0 cSemi)
          (findKeyGo addr (afterLineEnd addr le n) n keyAddr keyLen)
          (bifUSize (U32.beq c0 cHash)
            (findKeyGo addr (afterLineEnd addr le n) n keyAddr keyLen)
            (bifUSize (U32.beq c0 cLBrack)
              (findKeyGo addr (afterLineEnd addr le n) n keyAddr keyLen)
              (let eq := findEq addr i le
               bifUSize (USize.beq eq USize.neg1)
                 (findKeyGo addr (afterLineEnd addr le n) n keyAddr keyLen)
                 (let kn := USize.sub eq i
                  bifUSize (USize.beq kn keyLen)
                    (bifUSize (U32.beq (spanEq (USize.add addr i) keyAddr keyLen) U32.one)
                      i
                      (findKeyGo addr (afterLineEnd addr le n) n keyAddr keyLen))
                    (findKeyGo addr (afterLineEnd addr le n) n keyAddr keyLen))))))
       (findKeyGo addr (afterLineEnd addr le n) n keyAddr keyLen))
    USize.neg1

/-- Offset of first matching key on a `key=value` line, or miss. **LP64 miss.**

Skips comments and section headers. First match wins (no section scoping). -/
public unsafe def findKey (addr : USize) (n : USize)
    (keyAddr : USize) (keyLen : USize) : USize :=
  bifUSize (USize.beq keyLen USize.zero) USize.neg1
    (findKeyGo addr USize.zero n keyAddr keyLen)

/-- Value byte offset for a key start from `findKey`, or miss if no `=`. -/
public unsafe def valueOff (addr : USize) (n : USize) (keyOff : USize) : USize :=
  bifUSize (USize.blt keyOff n)
    (let le := findLineEnd addr keyOff n
     let eq := findEq addr keyOff le
     bifUSize (USize.beq eq USize.neg1) USize.neg1 (USize.add eq USize.one))
    USize.neg1

/-- Value length for a key start from `findKey`, or `0` on failure. -/
public unsafe def valueLen (addr : USize) (n : USize) (keyOff : USize) : USize :=
  bifUSize (USize.blt keyOff n)
    (let le := findLineEnd addr keyOff n
     let eq := findEq addr keyOff le
     bifUSize (USize.beq eq USize.neg1) USize.zero
       (let vo := USize.add eq USize.one
        bifUSize (USize.blt le vo) USize.zero (USize.sub le vo)))
    USize.zero

/-- `1` if a matching section exists, else `0`. -/
public unsafe def hasSection (addr : USize) (n : USize)
    (nameAddr : USize) (nameLen : USize) : U32 :=
  bifU32 (USize.beq (findSection addr n nameAddr nameLen) USize.neg1) U32.zero U32.one

/-- `1` if a matching key exists, else `0`. -/
public unsafe def hasKey (addr : USize) (n : USize)
    (keyAddr : USize) (keyLen : USize) : U32 :=
  bifU32 (USize.beq (findKey addr n keyAddr keyLen) USize.neg1) U32.zero U32.one

end Systems.Ini
