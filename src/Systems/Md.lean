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
# Systems.Md (Systems Lean)

Markdown-**shaped** line scan over dual caller `addr`/`len` byte views — not full
CommonMark, not GFM tables/HTML, not a document AST, not malloc-backed.

Recognized line shapes (ASCII bytes; `\n` / `\r\n` line ends):

* **blank** — empty after optional leading spaces
* **ATX heading** — 1–6 `#` then space (or EOL), then optional title bytes
* **list item** — after optional spaces: `- ` or `* ` then optional item bytes
* **fenced code** — line whose first non-space bytes are `` ``` `` (toggle open/close)
* **body** — any other line (paragraph / free text)

Inside an open fence, only fence close lines are classified; other bytes are body.

Ops:

* **validate** / **scan** — structural line scan; `0` ok, `1` if a fence is left open
* **headingCount** — number of ATX heading lines (outside fences)
* **listCount** — number of `- `/`* ` list lines (outside fences)
* **maxHeadingLevel** — maximum heading level in `1..6` (0 if none; miss if invalid)
* **findHeading** — line-start byte offset of first heading whose title matches a key span, or miss
* **fenceCount** — number of fence marker lines
* **headingLevelAt** — level of a heading at byte offset (0 if not a heading)

Honesty:

* **Shaped line scan only** — no setext headings, no indented code blocks, no HTML,
  no link/image product API, no emphasis nesting, no reference definitions.
* Fence language tags after `` ``` `` are ignored (marker is the three backticks).
* Not claimed: full CommonMark / GFM / markdown-it parity.
* Miss sentinel is `USize.neg1` (**LP64 harness**).
* **loadAt dual-param honesty:** ops take caller `(addr, n)`; every `loadAt` index is
  produced only after an `i < n` / `j < hi` guard. `loadAt` itself is **not**
  bounds-parameterized — caller `n` is the sole length bound for all loads.

## Intentional TCB (Md-local)

Structural ASCII markers and width constants are freestanding `@[extern]` axioms kept
**here**. Name-pinned on ComplianceCorpus (`path name=Ident`).
-/

namespace Systems.Md

open Systems.Scalars
open Systems.Bytes
open Systems.Status

/-- ASCII `'#'` (35). -/
@[extern c inline "((uint32_t)35)"] public axiom cHash : U32
/-- ASCII `'-'` (45). -/
@[extern c inline "((uint32_t)45)"] public axiom cMinus : U32
/-- ASCII `'*'` (42). -/
@[extern c inline "((uint32_t)42)"] public axiom cStar : U32
/-- ASCII `` ` `` (96). -/
@[extern c inline "((uint32_t)96)"] public axiom cTick : U32
/-- ASCII space (32). -/
@[extern c inline "((uint32_t)32)"] public axiom cSp : U32
/-- ASCII LF (10). -/
@[extern c inline "((uint32_t)10)"] public axiom cLf : U32
/-- ASCII CR (13). -/
@[extern c inline "((uint32_t)13)"] public axiom cCr : U32
/-- Two as `USize` (third fence tick is at `i0 + 2`). -/
@[extern c inline "((size_t)2)"] public axiom twoUSize : USize
/-- Six as `USize` (max ATX heading level). -/
@[extern c inline "((size_t)6)"] public axiom sixUSize : USize

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

/-- `1` if line body `[i0, le)` starts with three backticks. -/
public unsafe def isFence (addr : USize) (i0 : USize) (le : USize) : U32 :=
  bifU32 (USize.blt (USize.add i0 twoUSize) le)
    (bifU32 (U32.beq (loadAt addr i0) cTick)
      (bifU32 (U32.beq (loadAt addr (USize.add i0 USize.one)) cTick)
        (bifU32 (U32.beq (loadAt addr (USize.add i0 twoUSize)) cTick) U32.one U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Count leading `#` in `[i0, le)` capped at 6. Returns count. -/
public unsafe def countHashesGo (addr : USize) (i : USize) (le : USize) (acc : USize) : USize :=
  bifUSize (USize.blt acc sixUSize)
    (bifUSize (USize.blt i le)
      (bifUSize (U32.beq (loadAt addr i) cHash)
        (countHashesGo addr (USize.add i USize.one) le (USize.add acc USize.one))
        acc)
      acc)
    acc

/-- Heading level for line body start `i0` (1–6), or `0` if not ATX heading.

Requires 1–6 hashes then either space or EOL (not a seventh `#`). -/
public unsafe def headingLevel (addr : USize) (i0 : USize) (le : USize) : USize :=
  let h := countHashesGo addr i0 le USize.zero
  bifUSize (USize.beq h USize.zero) USize.zero
    (bifUSize (USize.blt sixUSize h) USize.zero
      (let after := USize.add i0 h
       bifUSize (USize.beq after le) h
         (bifUSize (U32.beq (loadAt addr after) cSp) h
           -- more hashes or non-space → not ATX (e.g. ####### or #foo)
           USize.zero)))

/-- `1` if line body is a list item (`- ` or `* `). -/
public unsafe def isListItem (addr : USize) (i0 : USize) (le : USize) : U32 :=
  bifU32 (USize.blt (USize.add i0 USize.one) le)
    (let c0 := loadAt addr i0
     bifU32 (U32.beq c0 cMinus)
       (bifU32 (U32.beq (loadAt addr (USize.add i0 USize.one)) cSp) U32.one U32.zero)
       (bifU32 (U32.beq c0 cStar)
         (bifU32 (U32.beq (loadAt addr (USize.add i0 USize.one)) cSp) U32.one U32.zero)
         U32.zero))
    U32.zero

/-- Title start for ATX heading at `i0` with level `lvl` (skips `#`s and one space). -/
public unsafe def headingTitleOff (i0 : USize) (lvl : USize) (le : USize) : USize :=
  let afterHash := USize.add i0 lvl
  bifUSize (USize.blt afterHash le)
    -- consumed space after hashes when present
    (USize.add afterHash USize.one)
    afterHash

/-- Validate/scan loop with fence depth (`1` = inside fence). Open fence at end → err. -/
public unsafe def validateGo (addr : USize) (i : USize) (n : USize) (depth : USize) : U32 :=
  bifU32 (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipSp addr i le
     bifU32 (U32.beq (isFence addr i0 le) U32.one)
       (bifU32 (USize.beq depth USize.zero)
         (validateGo addr (afterLineEnd addr le n) n USize.one)
         (validateGo addr (afterLineEnd addr le n) n USize.zero))
       (validateGo addr (afterLineEnd addr le n) n depth))
    (bifU32 (USize.beq depth USize.zero) ok err)

/-- Structural validate: `0` ok, `1` if a fenced block is left open. Empty is ok. -/
public unsafe def validate (addr : USize) (n : USize) : U32 :=
  validateGo addr USize.zero n USize.zero

/-- Alias of `validate`. -/
public unsafe def scan (addr : USize) (n : USize) : U32 :=
  validate addr n

/-- Count ATX headings outside fences. -/
public unsafe def headingCountGo (addr : USize) (i : USize) (n : USize)
    (depth : USize) (acc : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipSp addr i le
     bifUSize (U32.beq (isFence addr i0 le) U32.one)
       (bifUSize (USize.beq depth USize.zero)
         (headingCountGo addr (afterLineEnd addr le n) n USize.one acc)
         (headingCountGo addr (afterLineEnd addr le n) n USize.zero acc))
       (bifUSize (USize.beq depth USize.zero)
         (let lvl := headingLevel addr i0 le
          bifUSize (USize.blt USize.zero lvl)
            (headingCountGo addr (afterLineEnd addr le n) n depth (USize.add acc USize.one))
            (headingCountGo addr (afterLineEnd addr le n) n depth acc))
         (headingCountGo addr (afterLineEnd addr le n) n depth acc)))
    acc

/-- Number of ATX headings (outside fences). -/
public unsafe def headingCount (addr : USize) (n : USize) : USize :=
  headingCountGo addr USize.zero n USize.zero USize.zero

/-- Count list items outside fences. -/
public unsafe def listCountGo (addr : USize) (i : USize) (n : USize)
    (depth : USize) (acc : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipSp addr i le
     bifUSize (U32.beq (isFence addr i0 le) U32.one)
       (bifUSize (USize.beq depth USize.zero)
         (listCountGo addr (afterLineEnd addr le n) n USize.one acc)
         (listCountGo addr (afterLineEnd addr le n) n USize.zero acc))
       (bifUSize (USize.beq depth USize.zero)
         (bifUSize (U32.beq (isListItem addr i0 le) U32.one)
           (listCountGo addr (afterLineEnd addr le n) n depth (USize.add acc USize.one))
           (listCountGo addr (afterLineEnd addr le n) n depth acc))
         (listCountGo addr (afterLineEnd addr le n) n depth acc)))
    acc

/-- Number of list item lines (outside fences). -/
public unsafe def listCount (addr : USize) (n : USize) : USize :=
  listCountGo addr USize.zero n USize.zero USize.zero

/-- Max heading level loop. -/
public unsafe def maxHeadingLevelGo (addr : USize) (i : USize) (n : USize)
    (depth : USize) (acc : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipSp addr i le
     bifUSize (U32.beq (isFence addr i0 le) U32.one)
       (bifUSize (USize.beq depth USize.zero)
         (maxHeadingLevelGo addr (afterLineEnd addr le n) n USize.one acc)
         (maxHeadingLevelGo addr (afterLineEnd addr le n) n USize.zero acc))
       (bifUSize (USize.beq depth USize.zero)
         (let lvl := headingLevel addr i0 le
          let m2 := bifUSize (USize.blt acc lvl) lvl acc
          maxHeadingLevelGo addr (afterLineEnd addr le n) n depth m2)
         (maxHeadingLevelGo addr (afterLineEnd addr le n) n depth acc)))
    acc

/-- Maximum ATX heading level in `0..6`, or miss if a fence is left open. **LP64 miss.** -/
public unsafe def maxHeadingLevel (addr : USize) (n : USize) : USize :=
  bifUSize (U32.beq (validate addr n) ok)
    (maxHeadingLevelGo addr USize.zero n USize.zero USize.zero)
    USize.neg1

/-- Count fence marker lines. -/
public unsafe def fenceCountGo (addr : USize) (i : USize) (n : USize) (acc : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipSp addr i le
     bifUSize (U32.beq (isFence addr i0 le) U32.one)
       (fenceCountGo addr (afterLineEnd addr le n) n (USize.add acc USize.one))
       (fenceCountGo addr (afterLineEnd addr le n) n acc))
    acc

/-- Number of `` ``` `` fence marker lines. -/
public unsafe def fenceCount (addr : USize) (n : USize) : USize :=
  fenceCountGo addr USize.zero n USize.zero

/-- Find heading whose trimmed title equals `[keyAddr, keyLen)`. Returns line start off. -/
public unsafe def findHeadingGo (addr : USize) (i : USize) (n : USize)
    (depth : USize) (keyAddr : USize) (keyLen : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipSp addr i le
     bifUSize (U32.beq (isFence addr i0 le) U32.one)
       (bifUSize (USize.beq depth USize.zero)
         (findHeadingGo addr (afterLineEnd addr le n) n USize.one keyAddr keyLen)
         (findHeadingGo addr (afterLineEnd addr le n) n USize.zero keyAddr keyLen))
       (bifUSize (USize.beq depth USize.zero)
         (let lvl := headingLevel addr i0 le
          bifUSize (USize.blt USize.zero lvl)
            (let t0 := headingTitleOff i0 lvl le
             let t1 := rtrimSp addr t0 le
             bifUSize (USize.beq (USize.sub t1 t0) keyLen)
               (bifUSize (U32.beq (spanEq (USize.add addr t0) keyAddr keyLen) U32.one) i
                 (findHeadingGo addr (afterLineEnd addr le n) n depth keyAddr keyLen))
               (findHeadingGo addr (afterLineEnd addr le n) n depth keyAddr keyLen))
            (findHeadingGo addr (afterLineEnd addr le n) n depth keyAddr keyLen))
         (findHeadingGo addr (afterLineEnd addr le n) n depth keyAddr keyLen)))
    USize.neg1

/-- Line-start byte offset of the first heading whose trimmed title matches the key, or miss.

Matches title text (not the `#` markers); returns the start of that heading line (may include
leading spaces before the `#`s). **LP64 miss.** -/
public unsafe def findHeading (addr : USize) (n : USize) (keyAddr : USize) (keyLen : USize)
    : USize :=
  bifUSize (U32.beq (validate addr n) ok)
    (findHeadingGo addr USize.zero n USize.zero keyAddr keyLen)
    USize.neg1

/-- Heading level at line starting at `lineOff`, or `0` if not a heading / OOB. -/
public unsafe def headingLevelAt (addr : USize) (n : USize) (lineOff : USize) : USize :=
  bifUSize (USize.blt lineOff n)
    (let le := findLineEnd addr lineOff n
     let i0 := skipSp addr lineOff le
     headingLevel addr i0 le)
    USize.zero

end Systems.Md
