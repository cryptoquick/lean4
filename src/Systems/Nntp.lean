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
# Systems.Nntp (Systems Lean)

NNTP-**shaped** first-line reply / command scan over dual caller `addr`/`len` byte
views — not a full NNTP stack, not multi-line article/body product, not AUTH/TLS
session product.

First-line shapes (RFC 3977-shaped; ASCII; line ends with `\n` or `\r\n`):

```
REPLY:   ddd [SP] [text]
COMMAND: METHOD [SP args]
```

Minimum fence is **4** bytes (shaped lower bound for a tiny `200\n` / `GROUP`-class line).

Ops:

* **validate** / **parse** — `0` if `n ≥ 4`, else `1` (too short); when long enough,
  probes first byte and folds it with `land 0` so dual-param `addr` is live
* **isReply** — `1` if first three bytes are ASCII digits, else `0` (or short)
* **code** — three-digit reply code as `U32` when `isReply`, else `0`
* **methodLen** — length of first token until SP when **not** a reply (or `0`)
* **textOff** — start of optional text after code separator / method SP (or miss)
* **hasText** — `1` if `textOff` is present, else `0`

Honesty:

* **First-line method/code + optional text offsets only** — no multi-line article
  body product, no newsgroup state machine, not an NNTP client/server.
* **validate status is length-class only** (`ok`/`err`); the first-byte probe never
  changes the status value (`land` with zero) but keeps `addr` on the EmitC result path
  when `n ≥ 4`. Reply/code legality is not enforced by validate.
* **loadAt dual-param honesty:** every load index is under `i < n` after fences.
  `loadAt` is **not** bounds-parameterized.

## Intentional TCB (Nntp-local)

Minimum length, ASCII markers, digit range, decimal bases, and field offsets are
freestanding `@[extern]` axioms kept **here**. Name-pinned on ComplianceCorpus
(`path name=Ident`). Byte loads reuse `Scalars`/`Bytes`; arithmetic reuses `Numerics`.
-/

namespace Systems.Nntp

open Systems.Scalars
open Systems.Bytes
open Systems.Status
open Systems.Numerics

/-- NNTP first-line shaped minimum length (4). -/
@[extern c inline "((size_t)4)"] public axiom minLen : USize
/-- ASCII space (32). -/
@[extern c inline "((uint32_t)32)"] public axiom cSp : U32
/-- ASCII LF (10). -/
@[extern c inline "((uint32_t)10)"] public axiom cLf : U32
/-- ASCII CR (13). -/
@[extern c inline "((uint32_t)13)"] public axiom cCr : U32
/-- ASCII `'0'` (48). -/
@[extern c inline "((uint32_t)48)"] public axiom cZero : U32
/-- ASCII `'9'` (57). -/
@[extern c inline "((uint32_t)57)"] public axiom cNine : U32
/-- Decimal ten. -/
@[extern c inline "((uint32_t)10)"] public axiom tenU32 : U32
/-- Decimal hundred. -/
@[extern c inline "((uint32_t)100)"] public axiom hundredU32 : U32
/-- Offset of second digit / second method byte (1). -/
@[extern c inline "((size_t)1)"] public axiom off1 : USize
/-- Offset of third digit (2). -/
@[extern c inline "((size_t)2)"] public axiom off2 : USize
/-- Offset of separator after three-digit code (3). -/
@[extern c inline "((size_t)3)"] public axiom off3 : USize
/-- Offset of optional reply text after separator (4). -/
@[extern c inline "((size_t)4)"] public axiom offText : USize
/-- Three as `USize` (reply code width). -/
@[extern c inline "((size_t)3)"] public axiom threeUSize : USize

/-- Load byte at index as `U32`. Caller ensures `i < n`. -/
public unsafe def loadAt (addr : USize) (i : USize) : U32 :=
  U32.ofU8 (U8.load (USize.add addr i))

/-- `1` if `c` is ASCII digit `'0'..'9'`. -/
public unsafe def isDigit (c : U32) : U32 :=
  bifU32 (U32.blt c cZero) U32.zero
    (bifU32 (U32.blt cNine c) U32.zero U32.one)

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
contributes a nonzero bit). Does not require reply digits or method shape. -/
public unsafe def validate (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n minLen) err
    (U32.land (loadAt addr USize.zero) U32.zero)

/-- Alias of `validate`. -/
public unsafe def parse (addr : USize) (n : USize) : U32 :=
  validate addr n

/-- `1` if first three bytes are ASCII digits (needs `n ≥ 3`), else `0`. -/
public unsafe def isReply (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n threeUSize) U32.zero
    (bifU32 (U32.beq (isDigit (loadAt addr USize.zero)) U32.one)
      (bifU32 (U32.beq (isDigit (loadAt addr off1)) U32.one)
        (bifU32 (U32.beq (isDigit (loadAt addr off2)) U32.one) U32.one U32.zero)
        U32.zero)
      U32.zero)

/-- Three-digit reply code when `isReply`, else `0`. -/
public unsafe def code (addr : USize) (n : USize) : U32 :=
  bifU32 (U32.beq (isReply addr n) U32.one)
    (let d0 := U32.sub (loadAt addr USize.zero) cZero
     let d1 := U32.sub (loadAt addr off1) cZero
     let d2 := U32.sub (loadAt addr off2) cZero
     U32.add (U32.add (U32.mul d0 hundredU32) (U32.mul d1 tenU32)) d2)
    U32.zero

/-- Length of METHOD token until first SP when not a reply, else `0`.

Returns `0` if short, reply-shaped, no SP, or empty method. -/
public unsafe def methodLen (addr : USize) (n : USize) : USize :=
  bifUSize (USize.blt n minLen) USize.zero
    (bifUSize (U32.beq (isReply addr n) U32.one) USize.zero
      (let sp := findSpOrEnd addr USize.zero n
       bifUSize (USize.blt sp n)
         (bifUSize (U32.beq (loadAt addr sp) cSp) sp USize.zero)
         USize.zero))

/-- Start of optional text: after `NNN ` for replies, or after method SP.

Miss (`neg1`) when short / no separator / no trailing content. **LP64**. -/
public unsafe def textOff (addr : USize) (n : USize) : USize :=
  bifUSize (USize.blt n minLen) USize.neg1
    (bifUSize (U32.beq (isReply addr n) U32.one)
      (bifUSize (USize.blt off3 n)
        (let sep := loadAt addr off3
         bifUSize (U32.beq sep cSp)
           (bifUSize (USize.blt offText n)
             (bifUSize (U32.beq (isLineEnd (loadAt addr offText)) U32.one) USize.neg1 offText)
             USize.neg1)
           USize.neg1)
        USize.neg1)
      (let ml := methodLen addr n
       bifUSize (USize.beq ml USize.zero) USize.neg1
         (let sp := ml
          bifUSize (USize.blt sp n)
            (bifUSize (U32.beq (loadAt addr sp) cSp)
              (let to := USize.add sp USize.one
               bifUSize (USize.blt to n)
                 (bifUSize (U32.beq (isLineEnd (loadAt addr to)) U32.one) USize.neg1 to)
                 USize.neg1)
              USize.neg1)
            USize.neg1)))

/-- `1` if optional text is present after method/code separator, else `0`. -/
public unsafe def hasText (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (textOff addr n) USize.neg1) U32.zero U32.one

end Systems.Nntp
