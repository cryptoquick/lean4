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
# Systems.Yaml (Systems Lean)

YAML-**shaped** line / indent scan over dual caller `addr`/`len` byte views — not full
YAML 1.2, not a typed document graph, not malloc-backed maps of keys.

Recognized line shapes (ASCII bytes; `\n` / `\r\n` line ends):

* **blank** — empty after optional indent (spaces only)
* **comment** — first non-space byte is `#`
* **list item** — after indent: `-` then space then optional value bytes
* **key: value** — after indent: non-empty key, `:`, optional spaces, optional value

Ops:

* **validate** / **scan** — structural scan; `0` ok, `1` invalid
* **maxIndent** — maximum leading-space indent observed on non-blank lines
* **keyCount** — number of well-formed `key:` lines
* **listCount** — number of well-formed `- ` list lines
* **findKey** — byte offset of matching key start, or miss
* **valueOff** / **valueLen** — value span for a key offset from `findKey`
* **hasKey** — presence helper

Honesty:

* **Shaped scan only** — no multi-document `---`, no anchors/aliases, no flow
  collections (`{}`/`[]` product API), no multi-line scalars, no typed tags, no
  block chomping, no tab-indent (tabs after indent start are raw value bytes only;
  leading tabs on a line are rejected as invalid).
* Not claimed: full YAML 1.2, UTF-8 keys, or case-folding.
* Miss sentinel is `USize.neg1` (**LP64 harness**).

## Intentional TCB (Yaml-local)

Structural ASCII markers are freestanding `@[extern]` axioms kept **here**.
Name-pinned on ComplianceCorpus (`path name=Ident`).
-/

namespace Systems.Yaml

open Systems.Scalars
open Systems.Bytes
open Systems.Status

/-- ASCII `'#'` (35). -/
@[extern c inline "((uint32_t)35)"] public axiom cHash : U32
/-- ASCII `'-'` (45). -/
@[extern c inline "((uint32_t)45)"] public axiom cMinus : U32
/-- ASCII `':'` (58). -/
@[extern c inline "((uint32_t)58)"] public axiom cColon : U32
/-- ASCII space (32). -/
@[extern c inline "((uint32_t)32)"] public axiom cSp : U32
/-- ASCII tab (9). -/
@[extern c inline "((uint32_t)9)"] public axiom cTab : U32
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

/-- Index just past the line ending at `le` (consumes optional CR LF pair). -/
public unsafe def afterLineEnd (addr : USize) (le : USize) (n : USize) : USize :=
  bifUSize (USize.beq le n) n
    (bifUSize (U32.beq (loadAt addr le) cCr)
      (let j := USize.add le USize.one
       bifUSize (USize.blt j n)
         (bifUSize (U32.beq (loadAt addr j) cLf) (USize.add j USize.one) j)
         j)
      (USize.add le USize.one))

/-- Count leading spaces from `i` to `hi`. Returns end index (first non-space or `hi`).

Rejects leading tabs: if a tab appears before a non-space, returns miss. -/
public unsafe def skipIndentGo (addr : USize) (i : USize) (hi : USize) : USize :=
  bifUSize (USize.blt i hi)
    (let c := loadAt addr i
     bifUSize (U32.beq c cSp) (skipIndentGo addr (USize.add i USize.one) hi)
       (bifUSize (U32.beq c cTab) USize.neg1 i))
    i

/-- Leading-space indent count for line `[line, le)`, or miss on tab indent. -/
public unsafe def indentOf (addr : USize) (line : USize) (le : USize) : USize :=
  let i0 := skipIndentGo addr line le
  bifUSize (USize.beq i0 USize.neg1) USize.neg1
    (USize.sub i0 line)

/-- First `:` index in `[lo, hi)`, or miss. -/
public unsafe def findColon (addr : USize) (lo : USize) (hi : USize) : USize :=
  bifUSize (USize.blt lo hi)
    (bifUSize (U32.beq (loadAt addr lo) cColon) lo
      (findColon addr (USize.add lo USize.one) hi))
    USize.neg1

/-- Skip spaces in `[i, hi)`. -/
public unsafe def skipSp (addr : USize) (i : USize) (hi : USize) : USize :=
  bifUSize (USize.blt i hi)
    (bifUSize (U32.beq (loadAt addr i) cSp)
      (skipSp addr (USize.add i USize.one) hi) i)
    i

/-- Trim trailing spaces from exclusive end `hi` down to `lo`. -/
public unsafe def rtrimSp (addr : USize) (lo : USize) (hi : USize) : USize :=
  bifUSize (USize.blt lo hi)
    (let p := USize.sub hi USize.one
     bifUSize (U32.beq (loadAt addr p) cSp) (rtrimSp addr lo p) hi)
    hi

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

/-- Status of one line `[line, le)`: `0` ok, `1` invalid. -/
public unsafe def lineOk (addr : USize) (line : USize) (le : USize) : U32 :=
  let i0 := skipIndentGo addr line le
  bifU32 (USize.beq i0 USize.neg1) err
    (bifU32 (USize.beq i0 le) ok
      (let c0 := loadAt addr i0
       bifU32 (U32.beq c0 cHash) ok
         (bifU32 (U32.beq c0 cMinus)
           -- list: require `-` then space (or EOL after `-` alone is invalid)
           (let after := USize.add i0 USize.one
            bifU32 (USize.blt after le)
              (bifU32 (U32.beq (loadAt addr after) cSp) ok err)
              err)
           -- key: value — first `:` splits non-empty key from value
           (let col := findColon addr i0 le
            bifU32 (USize.beq col USize.neg1) err
              (bifU32 (USize.beq col i0) err ok)))))

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

/-- Alias of `validate` (scan = structural line/indent scan). -/
public unsafe def scan (addr : USize) (n : USize) : U32 :=
  validate addr n

/-- Max indent loop. Miss if any line invalid (tab indent). -/
public unsafe def maxIndentGo (addr : USize) (i : USize) (n : USize) (acc : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let ind := indentOf addr i le
     bifUSize (USize.beq ind USize.neg1) USize.neg1
       (let i0 := USize.add i ind
        bifUSize (USize.beq i0 le)
          (maxIndentGo addr (afterLineEnd addr le n) n acc)
          (let m2 := bifUSize (USize.blt acc ind) ind acc
           maxIndentGo addr (afterLineEnd addr le n) n m2)))
    acc

/-- Maximum leading-space indent on non-blank lines, or miss on invalid. **LP64 miss.** -/
public unsafe def maxIndent (addr : USize) (n : USize) : USize :=
  bifUSize (U32.beq (validate addr n) ok)
    (maxIndentGo addr USize.zero n USize.zero)
    USize.neg1

/-- Count `key:` lines from `i`. -/
public unsafe def keyCountGo (addr : USize) (i : USize) (n : USize) (acc : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipIndentGo addr i le
     bifUSize (USize.beq i0 USize.neg1)
       (keyCountGo addr (afterLineEnd addr le n) n acc)
       (bifUSize (USize.blt i0 le)
         (let c0 := loadAt addr i0
          bifUSize (U32.beq c0 cHash)
            (keyCountGo addr (afterLineEnd addr le n) n acc)
            (bifUSize (U32.beq c0 cMinus)
              (keyCountGo addr (afterLineEnd addr le n) n acc)
              (let col := findColon addr i0 le
               bifUSize (USize.beq col USize.neg1)
                 (keyCountGo addr (afterLineEnd addr le n) n acc)
                 (bifUSize (USize.beq col i0)
                   (keyCountGo addr (afterLineEnd addr le n) n acc)
                   (keyCountGo addr (afterLineEnd addr le n) n (USize.add acc USize.one))))))
         (keyCountGo addr (afterLineEnd addr le n) n acc)))
    acc

/-- Number of well-formed `key:` lines. -/
public unsafe def keyCount (addr : USize) (n : USize) : USize :=
  keyCountGo addr USize.zero n USize.zero

/-- Count list `- ` lines from `i`. -/
public unsafe def listCountGo (addr : USize) (i : USize) (n : USize) (acc : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipIndentGo addr i le
     bifUSize (USize.beq i0 USize.neg1)
       (listCountGo addr (afterLineEnd addr le n) n acc)
       (bifUSize (USize.blt i0 le)
         (bifUSize (U32.beq (loadAt addr i0) cMinus)
           (let after := USize.add i0 USize.one
            bifUSize (USize.blt after le)
              (bifUSize (U32.beq (loadAt addr after) cSp)
                (listCountGo addr (afterLineEnd addr le n) n (USize.add acc USize.one))
                (listCountGo addr (afterLineEnd addr le n) n acc))
              (listCountGo addr (afterLineEnd addr le n) n acc))
           (listCountGo addr (afterLineEnd addr le n) n acc))
         (listCountGo addr (afterLineEnd addr le n) n acc)))
    acc

/-- Number of well-formed list item lines. -/
public unsafe def listCount (addr : USize) (n : USize) : USize :=
  listCountGo addr USize.zero n USize.zero

/-- Find `key:` line with key equal to `[keyAddr, keyLen)`. Returns key offset. -/
public unsafe def findKeyGo (addr : USize) (i : USize) (n : USize)
    (keyAddr : USize) (keyLen : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipIndentGo addr i le
     bifUSize (USize.beq i0 USize.neg1)
       (findKeyGo addr (afterLineEnd addr le n) n keyAddr keyLen)
       (bifUSize (USize.blt i0 le)
         (let c0 := loadAt addr i0
          bifUSize (U32.beq c0 cHash)
            (findKeyGo addr (afterLineEnd addr le n) n keyAddr keyLen)
            (bifUSize (U32.beq c0 cMinus)
              (findKeyGo addr (afterLineEnd addr le n) n keyAddr keyLen)
              (let col := findColon addr i0 le
               bifUSize (USize.beq col USize.neg1)
                 (findKeyGo addr (afterLineEnd addr le n) n keyAddr keyLen)
                 (let kn := USize.sub col i0
                  bifUSize (USize.beq kn keyLen)
                    (bifUSize (U32.beq (spanEq (USize.add addr i0) keyAddr keyLen) U32.one)
                      i0
                      (findKeyGo addr (afterLineEnd addr le n) n keyAddr keyLen))
                    (findKeyGo addr (afterLineEnd addr le n) n keyAddr keyLen)))))
         (findKeyGo addr (afterLineEnd addr le n) n keyAddr keyLen)))
    USize.neg1

/-- Offset of first matching key on a `key: value` line, or miss. **LP64 miss.** -/
public unsafe def findKey (addr : USize) (n : USize)
    (keyAddr : USize) (keyLen : USize) : USize :=
  bifUSize (USize.beq keyLen USize.zero) USize.neg1
    (findKeyGo addr USize.zero n keyAddr keyLen)

/-- Value byte offset for a key start from `findKey`, or miss if no `:`.

Skips spaces after `:`. -/
public unsafe def valueOff (addr : USize) (n : USize) (keyOff : USize) : USize :=
  bifUSize (USize.blt keyOff n)
    (let le := findLineEnd addr keyOff n
     let col := findColon addr keyOff le
     bifUSize (USize.beq col USize.neg1) USize.neg1
       (skipSp addr (USize.add col USize.one) le))
    USize.neg1

/-- Value length for a key start from `findKey`, or `0` on failure.

Trailing spaces before EOL are trimmed. -/
public unsafe def valueLen (addr : USize) (n : USize) (keyOff : USize) : USize :=
  bifUSize (USize.blt keyOff n)
    (let le := findLineEnd addr keyOff n
     let col := findColon addr keyOff le
     bifUSize (USize.beq col USize.neg1) USize.zero
       (let vo := skipSp addr (USize.add col USize.one) le
        let ve := rtrimSp addr vo le
        bifUSize (USize.blt ve vo) USize.zero (USize.sub ve vo)))
    USize.zero

/-- `1` if a matching key exists, else `0`. -/
public unsafe def hasKey (addr : USize) (n : USize)
    (keyAddr : USize) (keyLen : USize) : U32 :=
  bifU32 (USize.beq (findKey addr n keyAddr keyLen) USize.neg1) U32.zero U32.one

end Systems.Yaml
