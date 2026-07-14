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
# Systems.Pop3 (Systems Lean)

POP3-**shaped** first-line `+OK` or `-ERR` reply (or command) scan over dual caller
`addr`/`len` byte views — not a full POP3 stack, not multi-line list/retr body,
not AUTH/TLS session product.

First-line shapes (RFC 1939-shaped; ASCII; line ends with `\n` or `\r\n`):

```
REPLY OK:  +OK [text]
REPLY ERR: -ERR [text]
COMMAND:   METHOD [SP args]
```

Minimum fence is **3** bytes (shaped lower bound for a tiny `+OK` / `UID`-class line).

Ops:

* **validate** / **parse** — `0` if `n ≥ 3`, else `1` (too short); when long enough,
  probes first byte and folds it with `land 0` so dual-param `addr` is live
* **isOk** — `1` if first three bytes are `+OK`, else `0` (or short)
* **isErr** — `1` if first four bytes are `-ERR`, else `0` (or short)
* **isReply** — `1` if `isOk` or `isErr`, else `0`
* **methodLen** — length of first token until SP when **not** a reply (or `0`)
* **textOff** — start of optional text after `+OK` SP, `-ERR` SP, or method SP (or miss)
* **hasText** — `1` if `textOff` is present, else `0`

Honesty:

* **First-line +OK or -ERR / method + optional text offsets only** — no multi-line
  LIST/RETR body product, no maildrop state machine, not a POP3 client/server.
* **validate status is length-class only** (`ok`/`err`); the first-byte probe never
  changes the status value (`land` with zero) but keeps `addr` on the EmitC result path
  when `n ≥ 3`. Reply/marker legality is not enforced by validate.
* **loadAt dual-param honesty:** every load index is under `i < n` after fences.
  `loadAt` is **not** bounds-parameterized.

## Intentional TCB (Pop3-local)

Minimum length, ASCII markers (`+OK` or `-ERR`/SP/LF/CR), and field offsets are
freestanding `@[extern]` axioms kept **here**. Name-pinned on ComplianceCorpus
(`path name=Ident`). Byte loads reuse `Scalars`/`Bytes`; compare reuses `Numerics`.
-/

namespace Systems.Pop3

open Systems.Scalars
open Systems.Bytes
open Systems.Status
open Systems.Numerics

/-- POP3 first-line shaped minimum length (3). -/
@[extern c inline "((size_t)3)"] public axiom minLen : USize
/-- Length needed for `-ERR` marker (4). -/
@[extern c inline "((size_t)4)"] public axiom errLen : USize
/-- ASCII `'+'` (43). -/
@[extern c inline "((uint32_t)43)"] public axiom cPlus : U32
/-- ASCII `'O'` (79). -/
@[extern c inline "((uint32_t)79)"] public axiom cO : U32
/-- ASCII `'K'` (75). -/
@[extern c inline "((uint32_t)75)"] public axiom cK : U32
/-- ASCII `'-'` (45). -/
@[extern c inline "((uint32_t)45)"] public axiom cDash : U32
/-- ASCII `'E'` (69). -/
@[extern c inline "((uint32_t)69)"] public axiom cE : U32
/-- ASCII `'R'` (82). -/
@[extern c inline "((uint32_t)82)"] public axiom cR : U32
/-- ASCII space (32). -/
@[extern c inline "((uint32_t)32)"] public axiom cSp : U32
/-- ASCII LF (10). -/
@[extern c inline "((uint32_t)10)"] public axiom cLf : U32
/-- ASCII CR (13). -/
@[extern c inline "((uint32_t)13)"] public axiom cCr : U32
/-- Offset of second marker byte (1). -/
@[extern c inline "((size_t)1)"] public axiom off1 : USize
/-- Offset of third marker byte (2). -/
@[extern c inline "((size_t)2)"] public axiom off2 : USize
/-- Offset of fourth marker byte / optional OK text start (3). -/
@[extern c inline "((size_t)3)"] public axiom off3 : USize
/-- Offset of optional ERR text after `-ERR` (4). -/
@[extern c inline "((size_t)4)"] public axiom off4 : USize
/-- Offset of optional ERR text after separator (5). -/
@[extern c inline "((size_t)5)"] public axiom off5 : USize

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

/-- `0` if `n ≥ 3`, else `1`.

When `n ≥ 3`, loads first byte and folds it with `U32.land _ U32.zero` so dual-param
`addr` stays on the EmitC result path. Status remains length-class only (probe never
contributes a nonzero bit). Does not require `+OK` or `-ERR` shape. -/
public unsafe def validate (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n minLen) err
    (U32.land (loadAt addr USize.zero) U32.zero)

/-- Alias of `validate`. -/
public unsafe def parse (addr : USize) (n : USize) : U32 :=
  validate addr n

/-- `1` if first three bytes are `+OK` (needs `n ≥ 3`), else `0`. -/
public unsafe def isOk (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n minLen) U32.zero
    (bifU32 (U32.beq (loadAt addr USize.zero) cPlus)
      (bifU32 (U32.beq (loadAt addr off1) cO)
        (bifU32 (U32.beq (loadAt addr off2) cK) U32.one U32.zero)
        U32.zero)
      U32.zero)

/-- `1` if first four bytes are `-ERR` (needs `n ≥ 4`), else `0`. -/
public unsafe def isErr (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n errLen) U32.zero
    (bifU32 (U32.beq (loadAt addr USize.zero) cDash)
      (bifU32 (U32.beq (loadAt addr off1) cE)
        (bifU32 (U32.beq (loadAt addr off2) cR)
          (bifU32 (U32.beq (loadAt addr off3) cR) U32.one U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)

/-- `1` if reply-shaped (`+OK` or `-ERR`), else `0`. -/
public unsafe def isReply (addr : USize) (n : USize) : U32 :=
  bifU32 (U32.beq (isOk addr n) U32.one) U32.one
    (bifU32 (U32.beq (isErr addr n) U32.one) U32.one U32.zero)

/-- Length of METHOD token until first SP when not a reply, else `0`.

Returns `0` if short, reply-shaped, no SP, or empty method. -/
public unsafe def methodLen (addr : USize) (n : USize) : USize :=
  bifUSize (USize.blt n minLen) USize.zero
    (bifUSize (U32.beq (isReply addr n) U32.one) USize.zero
      (let sp := findSpOrEnd addr USize.zero n
       bifUSize (USize.blt sp n)
         (bifUSize (U32.beq (loadAt addr sp) cSp) sp USize.zero)
         USize.zero))

/-- Start of optional text: after `+OK` SP or `-ERR` SP for replies, or after method SP.

Miss (`neg1`) when short / no separator / no trailing content. **LP64**. -/
public unsafe def textOff (addr : USize) (n : USize) : USize :=
  bifUSize (USize.blt n minLen) USize.neg1
    (bifUSize (U32.beq (isOk addr n) U32.one)
      (bifUSize (USize.blt off3 n)
        (let sep := loadAt addr off3
         bifUSize (U32.beq sep cSp)
           (bifUSize (USize.blt off4 n)
             (bifUSize (U32.beq (isLineEnd (loadAt addr off4)) U32.one) USize.neg1 off4)
             USize.neg1)
           USize.neg1)
        USize.neg1)
      (bifUSize (U32.beq (isErr addr n) U32.one)
        (bifUSize (USize.blt off4 n)
          (let sep := loadAt addr off4
           bifUSize (U32.beq sep cSp)
             (bifUSize (USize.blt off5 n)
               (bifUSize (U32.beq (isLineEnd (loadAt addr off5)) U32.one) USize.neg1 off5)
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
              USize.neg1))))

/-- `1` if optional text is present after marker/method separator, else `0`. -/
public unsafe def hasText (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (textOff addr n) USize.neg1) U32.zero U32.one

end Systems.Pop3
