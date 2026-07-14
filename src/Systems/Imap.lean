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
# Systems.Imap (Systems Lean)

IMAP-**shaped** first-line tagged reply/command scan over dual caller `addr`/`len`
byte views — not a full IMAP stack, not multi-line literal/body product, not
AUTH/TLS session product.

First-line shapes (RFC 3501-shaped; ASCII; line ends with `\n` or `\r\n`):

```
UNTAGGED: * SP STATUS [SP text]
TAGGED:   tag SP STATUS [SP text]
COMMAND:  tag SP METHOD [SP args]
```

Status tokens shaped as `OK` / `NO` / `BAD` (ASCII). Minimum fence is **4** bytes
(shaped lower bound for a tiny `a OK` / `* OK`-class line).

Ops:

* **validate** / **parse** — `0` if `n ≥ 4`, else `1` (too short); when long enough,
  probes first byte and folds it with `land 0` so dual-param `addr` is live
* **isUntagged** — `1` if first byte is `*` followed by SP, else `0` (or short)
* **tagLen** — length of first token until SP when not untagged (or `0`)
* **isOk** / **isNo** / **isBad** — status token after first SP matches
* **isReply** — `1` if status is `OK`/`NO`/`BAD`, else `0`
* **textOff** — start of optional text after status/method SP (or miss)
* **hasText** — `1` if `textOff` is present, else `0`

Honesty:

* **First-line tag/status + optional text offsets only** — no multi-line literal body,
  no mailbox state machine, not an IMAP client/server.
* **validate status is length-class only** (`ok`/`err`); the first-byte probe never
  changes the status value (`land` with zero) but keeps `addr` on the EmitC result path
  when `n ≥ 4`. Tag/status legality is not enforced by validate.
* **loadAt dual-param honesty:** every load index is under `i < n` after fences.
  `loadAt` is **not** bounds-parameterized.

## Intentional TCB (Imap-local)

Minimum length, ASCII markers (`*`/`OK`/`NO`/`BAD`/SP/LF/CR), and field offsets are
freestanding `@[extern]` axioms kept **here**. Name-pinned on ComplianceCorpus
(`path name=Ident`). Byte loads reuse `Scalars`/`Bytes`; compare reuses `Numerics`.
-/

namespace Systems.Imap

open Systems.Scalars
open Systems.Bytes
open Systems.Status
open Systems.Numerics

/-- IMAP first-line shaped minimum length (4). -/
@[extern c inline "((size_t)4)"] public axiom minLen : USize
/-- ASCII `'*'` (42). -/
@[extern c inline "((uint32_t)42)"] public axiom cStar : U32
/-- ASCII space (32). -/
@[extern c inline "((uint32_t)32)"] public axiom cSp : U32
/-- ASCII LF (10). -/
@[extern c inline "((uint32_t)10)"] public axiom cLf : U32
/-- ASCII CR (13). -/
@[extern c inline "((uint32_t)13)"] public axiom cCr : U32
/-- ASCII `'O'` (79). -/
@[extern c inline "((uint32_t)79)"] public axiom cO : U32
/-- ASCII `'K'` (75). -/
@[extern c inline "((uint32_t)75)"] public axiom cK : U32
/-- ASCII `'N'` (78). -/
@[extern c inline "((uint32_t)78)"] public axiom cN : U32
/-- ASCII `'B'` (66). -/
@[extern c inline "((uint32_t)66)"] public axiom cB : U32
/-- ASCII `'A'` (65). -/
@[extern c inline "((uint32_t)65)"] public axiom cA : U32
/-- ASCII `'D'` (68). -/
@[extern c inline "((uint32_t)68)"] public axiom cD : U32
/-- Offset of second byte (1). -/
@[extern c inline "((size_t)1)"] public axiom off1 : USize
/-- Offset of third byte (2). -/
@[extern c inline "((size_t)2)"] public axiom off2 : USize
/-- Two as `USize` (OK/NO width). -/
@[extern c inline "((size_t)2)"] public axiom twoUSize : USize
/-- Three as `USize` (BAD width). -/
@[extern c inline "((size_t)3)"] public axiom threeUSize : USize

/-- Load byte at index as `U32`. Caller ensures `i < n`. -/
public unsafe def loadAt (addr : USize) (i : USize) : U32 :=
  U32.ofU8 (U8.load (USize.add addr i))

/-- `1` if `c` is LF or CR. -/
public unsafe def isLineEnd (c : U32) : U32 :=
  bifU32 (U32.beq c cLf) U32.one
    (bifU32 (U32.beq c cCr) U32.one U32.zero)

/-- First SP or line-end in `[i, n)`, or `n` if none. -/
public unsafe def findSpOrEnd (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let c := loadAt addr i
     bifUSize (U32.beq c cSp) i
       (bifUSize (U32.beq (isLineEnd c) U32.one) i
         (findSpOrEnd addr (USize.add i USize.one) n)))
    n

/-- `0` if `n ≥ 4`, else `1`.

When `n ≥ 4`, loads first byte and folds it with `U32.land _ U32.zero` so dual-param
`addr` stays on the EmitC result path. Status remains length-class only (probe never
contributes a nonzero bit). Does not require tag/status shape. -/
public unsafe def validate (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n minLen) err
    (U32.land (loadAt addr USize.zero) U32.zero)

/-- Alias of `validate`. -/
public unsafe def parse (addr : USize) (n : USize) : U32 :=
  validate addr n

/-- `1` if first two bytes are `* ` (needs `n ≥ 2`), else `0`. -/
public unsafe def isUntagged (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n twoUSize) U32.zero
    (bifU32 (U32.beq (loadAt addr USize.zero) cStar)
      (bifU32 (U32.beq (loadAt addr off1) cSp) U32.one U32.zero)
      U32.zero)

/-- Length of tag token until first SP when not untagged, else `0`.

Returns `0` if short, untagged, no SP, or empty tag. -/
public unsafe def tagLen (addr : USize) (n : USize) : USize :=
  bifUSize (USize.blt n minLen) USize.zero
    (bifUSize (U32.beq (isUntagged addr n) U32.one) USize.zero
      (let sp := findSpOrEnd addr USize.zero n
       bifUSize (USize.blt sp n)
         (bifUSize (U32.beq (loadAt addr sp) cSp) sp USize.zero)
         USize.zero))

/-- Offset of status/method token after first SP, or miss. **LP64**. -/
public unsafe def statusOff (addr : USize) (n : USize) : USize :=
  bifUSize (USize.blt n minLen) USize.neg1
    (bifUSize (U32.beq (isUntagged addr n) U32.one)
      (bifUSize (USize.blt twoUSize n) twoUSize USize.neg1)
      (let tl := tagLen addr n
       bifUSize (USize.beq tl USize.zero) USize.neg1
         (let so := USize.add tl USize.one
          bifUSize (USize.blt so n) so USize.neg1)))

/-- `1` if status token at `so` is `OK` (needs two bytes). -/
public unsafe def statusIsOk (addr : USize) (n : USize) (so : USize) : U32 :=
  let tokEnd := USize.add so twoUSize
  bifU32 (USize.blt n tokEnd) U32.zero
    (bifU32 (U32.beq (loadAt addr so) cO)
      (bifU32 (U32.beq (loadAt addr (USize.add so off1)) cK)
        (bifU32 (USize.blt tokEnd n)
          (let c := loadAt addr tokEnd
           bifU32 (U32.beq c cSp) U32.one
             (bifU32 (U32.beq (isLineEnd c) U32.one) U32.one U32.zero))
          U32.one)
        U32.zero)
      U32.zero)

/-- `1` if status token at `so` is `NO` (needs two bytes). -/
public unsafe def statusIsNo (addr : USize) (n : USize) (so : USize) : U32 :=
  let tokEnd := USize.add so twoUSize
  bifU32 (USize.blt n tokEnd) U32.zero
    (bifU32 (U32.beq (loadAt addr so) cN)
      (bifU32 (U32.beq (loadAt addr (USize.add so off1)) cO)
        (bifU32 (USize.blt tokEnd n)
          (let c := loadAt addr tokEnd
           bifU32 (U32.beq c cSp) U32.one
             (bifU32 (U32.beq (isLineEnd c) U32.one) U32.one U32.zero))
          U32.one)
        U32.zero)
      U32.zero)

/-- `1` if status token at `so` is `BAD` (needs three bytes). -/
public unsafe def statusIsBad (addr : USize) (n : USize) (so : USize) : U32 :=
  let tokEnd := USize.add so threeUSize
  bifU32 (USize.blt n tokEnd) U32.zero
    (bifU32 (U32.beq (loadAt addr so) cB)
      (bifU32 (U32.beq (loadAt addr (USize.add so off1)) cA)
        (bifU32 (U32.beq (loadAt addr (USize.add so off2)) cD)
          (bifU32 (USize.blt tokEnd n)
            (let c := loadAt addr tokEnd
             bifU32 (U32.beq c cSp) U32.one
               (bifU32 (U32.beq (isLineEnd c) U32.one) U32.one U32.zero))
            U32.one)
          U32.zero)
        U32.zero)
      U32.zero)

/-- `1` if status is `OK`, else `0`. -/
public unsafe def isOk (addr : USize) (n : USize) : U32 :=
  let so := statusOff addr n
  bifU32 (USize.beq so USize.neg1) U32.zero
    (statusIsOk addr n so)

/-- `1` if status is `NO`, else `0`. -/
public unsafe def isNo (addr : USize) (n : USize) : U32 :=
  let so := statusOff addr n
  bifU32 (USize.beq so USize.neg1) U32.zero
    (statusIsNo addr n so)

/-- `1` if status is `BAD`, else `0`. -/
public unsafe def isBad (addr : USize) (n : USize) : U32 :=
  let so := statusOff addr n
  bifU32 (USize.beq so USize.neg1) U32.zero
    (statusIsBad addr n so)

/-- `1` if status is `OK`/`NO`/`BAD`, else `0`. -/
public unsafe def isReply (addr : USize) (n : USize) : U32 :=
  bifU32 (U32.beq (isOk addr n) U32.one) U32.one
    (bifU32 (U32.beq (isNo addr n) U32.one) U32.one
      (bifU32 (U32.beq (isBad addr n) U32.one) U32.one U32.zero))

/-- Status token width when reply-shaped (`2` for OK/NO, `3` for BAD), else `0`. -/
public unsafe def statusLen (addr : USize) (n : USize) : USize :=
  bifUSize (U32.beq (isOk addr n) U32.one) twoUSize
    (bifUSize (U32.beq (isNo addr n) U32.one) twoUSize
      (bifUSize (U32.beq (isBad addr n) U32.one) threeUSize USize.zero))

/-- Start of optional text after status/method separator.

Miss (`neg1`) when short / no separator / no trailing content. **LP64**. -/
public unsafe def textOff (addr : USize) (n : USize) : USize :=
  bifUSize (USize.blt n minLen) USize.neg1
    (let so := statusOff addr n
     bifUSize (USize.beq so USize.neg1) USize.neg1
       (bifUSize (U32.beq (isReply addr n) U32.one)
         (let sl := statusLen addr n
          let sep := USize.add so sl
          bifUSize (USize.blt sep n)
            (bifUSize (U32.beq (loadAt addr sep) cSp)
              (let to := USize.add sep USize.one
               bifUSize (USize.blt to n)
                 (bifUSize (U32.beq (isLineEnd (loadAt addr to)) U32.one) USize.neg1 to)
                 USize.neg1)
              USize.neg1)
            USize.neg1)
         (let sp := findSpOrEnd addr so n
          bifUSize (USize.blt sp n)
            (bifUSize (U32.beq (loadAt addr sp) cSp)
              (let to := USize.add sp USize.one
               bifUSize (USize.blt to n)
                 (bifUSize (U32.beq (isLineEnd (loadAt addr to)) U32.one) USize.neg1 to)
                 USize.neg1)
              USize.neg1)
            USize.neg1)))

/-- `1` if optional text is present after status/method separator, else `0`. -/
public unsafe def hasText (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (textOff addr n) USize.neg1) U32.zero U32.one

end Systems.Imap
