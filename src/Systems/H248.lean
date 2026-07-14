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
public import Systems.Numerics

/-!
# Systems.H248 (Systems Lean)

H.248 / Megaco-**shaped** first-line version / mid / method scan over dual caller
`addr`/`len` byte views — not a full H.248 stack, not transaction/context state, not
ASN.1 binary encoding product, not SDP/body product.

Choice: **text-shaped first-line** (RFC 3525 / H.248.1 text encoding family) rather than
binary ASN.1 MEGACO headers. Binary header layout is encoding-variant and not a single
fixed min common header like SIGTRAN UA peers; text `MEGACO/x` / short-form `!/x` is the
fail-closed dual-param peer class that stays residual-clean with Sip/Smtp/Nntp.

First-line shapes (ASCII; line ends with `\n` or `\r\n`):

```
LONG:  MEGACO/version SP [mid] SP METHOD ...
SHORT: !/version SP [mid] SP METHOD ...
```

Minimum fence is **4** bytes (shaped lower bound for a tiny `!/1\n`-class line).

Ops:

* **validate** / **parse** — `0` if `n ≥ 4`, else `1` (too short); when long enough,
  probes first byte and folds it with `land 0` so dual-param `addr` is live
* **hasVersion** — `1` if line starts with `MEGACO/` or `!/`, else `0` (or short)
* **version** — single major digit after the version slash as `U32` when present, else `0`
* **length** — first-line byte length until CR/LF (or `n` if no line end) as `U32` when
  long enough, else `0` (layout only; not a wire length field)
* **methodLen** — length of first token until SP (or `0` if short / no SP)
* **midOff** — offset of first `'['` mid token when present, else miss

Honesty:

* **First-line version/mid/method offsets only** — no transaction body walk, no
  context/termination descriptors, not an H.248/Megaco client/server, not binary ASN.1.
* **validate status is length-class only** (`ok`/`err`); the first-byte probe never
  changes the status value (`land` with zero) but keeps `addr` on the EmitC result path
  when `n ≥ 4`. Version/`MEGACO/` legality is **not** enforced by validate.
* **loadAt dual-param honesty:** every load index is under `i < n` after fences.
  `loadAt` is **not** bounds-parameterized.

## Intentional TCB (H248-local)

Minimum length, ASCII markers, version-token widths, and field offsets are freestanding
`@[extern]` axioms kept **here**. Name-pinned on ComplianceCorpus (`path name=Ident`).
Byte loads reuse `Scalars`/`Bytes`.
-/

namespace Systems.H248

open Systems.Scalars
open Systems.Bytes
open Systems.Status
open Systems.Numerics

/-- H.248/Megaco first-line shaped minimum length (4). -/
@[extern c inline "((size_t)4)"] public axiom minLen : USize
/-- Long-form `MEGACO/` width (7). -/
@[extern c inline "((size_t)7)"] public axiom megacoSlashLen : USize
/-- Short-form `!/` width (2). -/
@[extern c inline "((size_t)2)"] public axiom bangSlashLen : USize
/-- ASCII space (32). -/
@[extern c inline "((uint32_t)32)"] public axiom cSp : U32
/-- ASCII LF (10). -/
@[extern c inline "((uint32_t)10)"] public axiom cLf : U32
/-- ASCII CR (13). -/
@[extern c inline "((uint32_t)13)"] public axiom cCr : U32
/-- ASCII `'!'` (33). -/
@[extern c inline "((uint32_t)33)"] public axiom cBang : U32
/-- ASCII `'/'` (47). -/
@[extern c inline "((uint32_t)47)"] public axiom cSlash : U32
/-- ASCII `'['` (91). -/
@[extern c inline "((uint32_t)91)"] public axiom cLbrack : U32
/-- ASCII `'M'` (77). -/
@[extern c inline "((uint32_t)77)"] public axiom cM : U32
/-- ASCII `'E'` (69). -/
@[extern c inline "((uint32_t)69)"] public axiom cE : U32
/-- ASCII `'G'` (71). -/
@[extern c inline "((uint32_t)71)"] public axiom cG : U32
/-- ASCII `'A'` (65). -/
@[extern c inline "((uint32_t)65)"] public axiom cA : U32
/-- ASCII `'C'` (67). -/
@[extern c inline "((uint32_t)67)"] public axiom cC : U32
/-- ASCII `'O'` (79). -/
@[extern c inline "((uint32_t)79)"] public axiom cO : U32
/-- ASCII `'0'` (48). -/
@[extern c inline "((uint32_t)48)"] public axiom cZero : U32
/-- ASCII `'9'` (57). -/
@[extern c inline "((uint32_t)57)"] public axiom cNine : U32
/-- Offset of second byte (1). -/
@[extern c inline "((size_t)1)"] public axiom off1 : USize
/-- Offset of third byte (2). -/
@[extern c inline "((size_t)2)"] public axiom off2 : USize
/-- Offset of fourth byte (3). -/
@[extern c inline "((size_t)3)"] public axiom off3 : USize
/-- Offset of fifth byte (4). -/
@[extern c inline "((size_t)4)"] public axiom off4 : USize
/-- Offset of sixth byte (5). -/
@[extern c inline "((size_t)5)"] public axiom off5 : USize
/-- Offset of seventh byte / slash in `MEGACO/` (6). -/
@[extern c inline "((size_t)6)"] public axiom off6 : USize
/-- Offset of major digit after `MEGACO/` (7). -/
@[extern c inline "((size_t)7)"] public axiom offVerLong : USize
/-- Offset of major digit after `!/` (2). -/
@[extern c inline "((size_t)2)"] public axiom offVerShort : USize
/-- Length needed for long-form major digit (`8` = `MEGACO/` + digit). -/
@[extern c inline "((size_t)8)"] public axiom verLongLen : USize
/-- Length needed for short-form major digit (`3` = `!/` + digit). -/
@[extern c inline "((size_t)3)"] public axiom verShortLen : USize
/-- Narrow `USize` → `U32` (first-line length class; LP64 low 32). -/
@[extern c inline "((uint32_t)(size_t)(#1))"]
public axiom U32.ofUSize : USize → U32

/-- Load byte at index as `U32`. Caller ensures `i < n`. -/
public unsafe def loadAt (addr : USize) (i : USize) : U32 :=
  U32.ofU8 (U8.load (USize.add addr i))

/-- `1` if `c` is LF or CR. -/
public unsafe def isLineEnd (c : U32) : U32 :=
  bifU32 (U32.beq c cLf) U32.one
    (bifU32 (U32.beq c cCr) U32.one U32.zero)

/-- `1` if `c` is ASCII digit `'0'..'9'`. -/
public unsafe def isDigit (c : U32) : U32 :=
  bifU32 (U32.blt c cZero) U32.zero
    (bifU32 (U32.blt cNine c) U32.zero U32.one)

/-- First SP, line-end, or `'['` in `[i, n)`, or `n` if none. -/
public unsafe def findTokEnd (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let c := loadAt addr i
     bifUSize (U32.beq c cSp) i
       (bifUSize (U32.beq (isLineEnd c) U32.one) i
         (bifUSize (U32.beq c cLbrack) i
           (findTokEnd addr (USize.add i USize.one) n))))
    n

/-- First CR/LF in `[0, n)`, or `n` if none. -/
public unsafe def findLineEnd (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (bifUSize (U32.beq (isLineEnd (loadAt addr i)) U32.one) i
      (findLineEnd addr (USize.add i USize.one) n))
    n

/-- First `'['` in `[i, n)`, or `n` if none (stops at line-end). -/
public unsafe def findLbrack (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let c := loadAt addr i
     bifUSize (U32.beq c cLbrack) i
       (bifUSize (U32.beq (isLineEnd c) U32.one) n
         (findLbrack addr (USize.add i USize.one) n)))
    n

/-- `1` if first bytes are `MEGACO/` (needs `n ≥ 7`). -/
public unsafe def isMegacoSlash (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n megacoSlashLen) U32.zero
    (bifU32 (U32.beq (loadAt addr USize.zero) cM)
      (bifU32 (U32.beq (loadAt addr off1) cE)
        (bifU32 (U32.beq (loadAt addr off2) cG)
          (bifU32 (U32.beq (loadAt addr off3) cA)
            (bifU32 (U32.beq (loadAt addr off4) cC)
              (bifU32 (U32.beq (loadAt addr off5) cO)
                (bifU32 (U32.beq (loadAt addr off6) cSlash) U32.one U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)

/-- `1` if first two bytes are `!/` (needs `n ≥ 2`). -/
public unsafe def isBangSlash (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n bangSlashLen) U32.zero
    (bifU32 (U32.beq (loadAt addr USize.zero) cBang)
      (bifU32 (U32.beq (loadAt addr off1) cSlash) U32.one U32.zero)
      U32.zero)

/-- `0` if `n ≥ 4`, else `1`.

When `n ≥ 4`, loads first byte and folds it with `U32.land _ U32.zero` so dual-param
`addr` stays on the EmitC result path. Status remains length-class only (probe never
contributes a nonzero bit). Does not require `MEGACO/` / `!/` match. -/
public unsafe def validate (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n minLen) err
    (U32.land (loadAt addr USize.zero) U32.zero)

/-- Alias of `validate`. -/
public unsafe def parse (addr : USize) (n : USize) : U32 :=
  validate addr n

/-- `1` if line starts with `MEGACO/` or `!/`, else `0`. -/
public unsafe def hasVersion (addr : USize) (n : USize) : U32 :=
  bifU32 (U32.beq (isMegacoSlash addr n) U32.one) U32.one
    (bifU32 (U32.beq (isBangSlash addr n) U32.one) U32.one U32.zero)

/-- Major version digit after the version slash when present and digit-shaped, else `0`.

Long form uses offs 7 (`MEGACO/x`); short form uses offs 2 (`!/x`).
Length fences are name-pinned (`verLongLen` / `verShortLen`) — no closed-term `USize.add`. -/
public unsafe def version (addr : USize) (n : USize) : U32 :=
  bifU32 (U32.beq (isMegacoSlash addr n) U32.one)
    (bifU32 (USize.blt n verLongLen) U32.zero
      (let d := loadAt addr offVerLong
       bifU32 (U32.beq (isDigit d) U32.one) (U32.sub d cZero) U32.zero))
    (bifU32 (U32.beq (isBangSlash addr n) U32.one)
      (bifU32 (USize.blt n verShortLen) U32.zero
        (let d := loadAt addr offVerShort
         bifU32 (U32.beq (isDigit d) U32.one) (U32.sub d cZero) U32.zero))
      U32.zero)

/-- First-line byte length until CR/LF, or `n` if no line end (`0` if short).

Layout-only first-line span — not a binary wire length field. -/
public unsafe def length (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n minLen) U32.zero
    (let e := findLineEnd addr USize.zero n
     U32.ofUSize e)

/-- Length of first token until SP / `'['` / line-end, or `0` if short / empty. -/
public unsafe def methodLen (addr : USize) (n : USize) : USize :=
  bifUSize (USize.blt n minLen) USize.zero
    (let e := findTokEnd addr USize.zero n
     bifUSize (USize.blt USize.zero e)
       (bifUSize (USize.blt e n)
         (bifUSize (U32.beq (loadAt addr e) cSp) e
           (bifUSize (U32.beq (loadAt addr e) cLbrack) e
             (bifUSize (U32.beq (isLineEnd (loadAt addr e)) U32.one) e USize.zero)))
         e)
       USize.zero)

/-- Offset of first `'['` mid token on the first line, or miss. **LP64**. -/
public unsafe def midOff (addr : USize) (n : USize) : USize :=
  bifUSize (USize.blt n minLen) USize.neg1
    (let i := findLbrack addr USize.zero n
     bifUSize (USize.blt i n) i USize.neg1)

end Systems.H248
