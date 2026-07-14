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
# Systems.TomlQuery (Systems Lean)

TOML-**shaped** key lookup / query scan over dual caller `addr`/`len` byte views —
not full TOML 1.0, not a typed value graph, not table-scoped path queries, not
malloc-backed maps of keys.

Recognized line shapes (ASCII bytes; `\n` / `\r\n` line ends):

* **blank** — empty line (optional trailing `\r`)
* **comment** — line whose first non-space byte is `#`
* **table** — `[name]` with non-empty `name` (no `]` inside name); optional leading spaces
* **key = value** — first `=` splits key from value; optional spaces around `=`;
  key must be non-empty after optional leading spaces; value may be empty

Ops (query-focused surface):

* **validate** / **scan** — structural scan; `0` ok, `1` invalid
* **findKey** — byte offset of matching key start on a `key = value` line, or miss
* **valueOff** / **valueLen** — value span for a key offset from `findKey`
* **hasKey** — presence helper

Honesty:

* **Key query scan only** — no dotted keys as structured paths, no multi-line strings,
  no arrays-of-tables (`[[…]]` is rejected), no typed values, no inline tables/arrays,
  no quote rules beyond raw value bytes after `=`, no write/update API, no table
  scoping for key lookup (first global match wins, like Toml.findKey).
* Not claimed: full TOML 1.0 document model, TOML datetime/float tables, UTF-8 keys,
  or case-folding.
* Miss sentinel is `USize.neg1` (**LP64 harness**).

## Intentional TCB (TomlQuery-local)

Structural ASCII markers are freestanding `@[extern]` axioms kept **here**.
Name-pinned on ComplianceCorpus (`path name=Ident`).
-/

namespace Systems.TomlQuery

open Systems.Scalars
open Systems.Bytes
open Systems.Status

/-- ASCII `'['` (91). -/
@[extern c inline "((uint32_t)91)"] public axiom cLBrack : U32
/-- ASCII `']'` (93). -/
@[extern c inline "((uint32_t)93)"] public axiom cRBrack : U32
/-- ASCII `'='` (61). -/
@[extern c inline "((uint32_t)61)"] public axiom cEq : U32
/-- ASCII `'#'` (35). -/
@[extern c inline "((uint32_t)35)"] public axiom cHash : U32
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

/-- `1` if `c` is space or tab. -/
public unsafe def isWs (c : U32) : U32 :=
  bifU32 (U32.beq c cSp) U32.one
    (bifU32 (U32.beq c cTab) U32.one U32.zero)

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

/-- Skip leading spaces/tabs in `[i, hi)`. -/
public unsafe def skipWs (addr : USize) (i : USize) (hi : USize) : USize :=
  bifUSize (USize.blt i hi)
    (bifUSize (U32.beq (isWs (loadAt addr i)) U32.one)
      (skipWs addr (USize.add i USize.one) hi) i)
    i

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

/-- Trim trailing spaces/tabs from exclusive end `hi` down to `lo`. Returns new end. -/
public unsafe def rtrimWs (addr : USize) (lo : USize) (hi : USize) : USize :=
  bifUSize (USize.blt lo hi)
    (let p := USize.sub hi USize.one
     bifUSize (U32.beq (isWs (loadAt addr p)) U32.one)
       (rtrimWs addr lo p) hi)
    hi

/-- Status of one line `[line, le)`: `0` ok, `1` invalid. -/
public unsafe def lineOk (addr : USize) (line : USize) (le : USize) : U32 :=
  let i0 := skipWs addr line le
  bifU32 (USize.beq i0 le) ok
    (let c0 := loadAt addr i0
     bifU32 (U32.beq c0 cHash) ok
       (bifU32 (U32.beq c0 cLBrack)
         -- reject `[[array]]` and require trailing `]` then only trailing ws
         (let nameStart := USize.add i0 USize.one
          bifU32 (USize.blt nameStart le)
            (bifU32 (U32.beq (loadAt addr nameStart) cLBrack) err
              (let rb := findRBrack addr nameStart le
               bifU32 (USize.beq rb USize.neg1) err
                 (bifU32 (USize.beq rb nameStart) err
                   (let after := skipWs addr (USize.add rb USize.one) le
                    bifU32 (USize.beq after le) ok err))))
            err)
         (let eq := findEq addr i0 le
          bifU32 (USize.beq eq USize.neg1) err
            (let keyEnd := rtrimWs addr i0 eq
             bifU32 (USize.beq keyEnd i0) err ok))))

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

/-- Alias of `validate` (scan = structural scan only). -/
public unsafe def scan (addr : USize) (n : USize) : U32 :=
  validate addr n

/-- Find `key = value` line with key equal to `[keyAddr, keyLen)`. Returns key offset. -/
public unsafe def findKeyGo (addr : USize) (i : USize) (n : USize)
    (keyAddr : USize) (keyLen : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findKeyGo addr (afterLineEnd addr le n) n keyAddr keyLen)
          (bifUSize (U32.beq c0 cLBrack)
            (findKeyGo addr (afterLineEnd addr le n) n keyAddr keyLen)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findKeyGo addr (afterLineEnd addr le n) n keyAddr keyLen)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (USize.beq kn keyLen)
                  (bifUSize (U32.beq (spanEq (USize.add addr i0) keyAddr keyLen) U32.one)
                    i0
                    (findKeyGo addr (afterLineEnd addr le n) n keyAddr keyLen))
                  (findKeyGo addr (afterLineEnd addr le n) n keyAddr keyLen)))))
       (findKeyGo addr (afterLineEnd addr le n) n keyAddr keyLen))
    USize.neg1

/-- Offset of first matching key on a `key = value` line, or miss. **LP64 miss.**

Skips comments and table headers. First match wins (no table scoping). -/
public unsafe def findKey (addr : USize) (n : USize)
    (keyAddr : USize) (keyLen : USize) : USize :=
  bifUSize (USize.beq keyLen USize.zero) USize.neg1
    (findKeyGo addr USize.zero n keyAddr keyLen)

/-- Value byte offset for a key start from `findKey`, or miss if no `=`.

Skips spaces after `=`. -/
public unsafe def valueOff (addr : USize) (n : USize) (keyOff : USize) : USize :=
  bifUSize (USize.blt keyOff n)
    (let le := findLineEnd addr keyOff n
     let eq := findEq addr keyOff le
     bifUSize (USize.beq eq USize.neg1) USize.neg1
       (skipWs addr (USize.add eq USize.one) le))
    USize.neg1

/-- Value length for a key start from `findKey`, or `0` on failure.

Trailing spaces before EOL are trimmed. -/
public unsafe def valueLen (addr : USize) (n : USize) (keyOff : USize) : USize :=
  bifUSize (USize.blt keyOff n)
    (let le := findLineEnd addr keyOff n
     let eq := findEq addr keyOff le
     bifUSize (USize.beq eq USize.neg1) USize.zero
       (let vo := skipWs addr (USize.add eq USize.one) le
        let ve := rtrimWs addr vo le
        bifUSize (USize.blt ve vo) USize.zero (USize.sub ve vo)))
    USize.zero

/-- `1` if a matching key exists, else `0`. -/
public unsafe def hasKey (addr : USize) (n : USize)
    (keyAddr : USize) (keyLen : USize) : U32 :=
  bifU32 (USize.beq (findKey addr n keyAddr keyLen) USize.neg1) U32.zero U32.one

end Systems.TomlQuery
