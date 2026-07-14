/-
Copyright (c) 2026 Hunter Beast. All rights reserved.
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
# Systems.Mgcp (Systems Lean)

MGCP-**shaped** first-line command / response scan over dual caller `addr`/`len` byte
views — not a full MGCP stack, not softswitch/endpoint state, not SDP/body product.

First-line shapes (RFC 3435-shaped; ASCII; line ends with `\n` or `\r\n`):

```
COMMAND:  VERB SP txnId SP endpoint SP MGCP/x.y
RESPONSE: ddd SP txnId [SP text]
```

Text-protocol peer of Sip / Smtp / H248 (method/verb + transaction id or
response code + version). Distinct exports `lean_fs_mgcp_*` — not Megaco short-form
`T=`/`P=` tokens (that is Megaco).

Minimum fence is **4** bytes (shaped lower bound for a tiny `200\n` / `NTFY`-class line).

Ops:

* **validate** / **parse** — `0` if `n ≥ 4`, else `1` (too short); when long enough,
  probes first byte and folds it with `land 0` so dual-param `addr` is live
* **isResponse** — `1` if first three bytes are ASCII digits, else `0` (or short)
* **code** — three-digit response code as `U32` when `isResponse`, else `0`
* **method** — length of first VERB token until SP when **not** a response (or `0`)
* **txnId** — decimal transaction id after the first token SP as `U32` when present
* **hasVersion** — `1` if a `MGCP/` token appears on the first line, else `0`
* **versionOff** — offset of first `MGCP/` when present, else miss

Honesty:

* **First-line method/code + txn + version offsets only** — no multi-line package
  parameter walk, no endpoint state machine, not an MGCP call agent / gateway.
* **validate status is length-class only** (`ok`/`err`); the first-byte probe never
  changes the status value (`land` with zero) but keeps `addr` on the EmitC result path
  when `n ≥ 4`. Verb/code/`MGCP/` legality is **not** enforced by validate.
* **loadAt dual-param honesty:** every load index is under `i < n` after fences.
  `loadAt` is **not** bounds-parameterized.

## Intentional TCB (Mgcp-local)

Minimum length, ASCII markers, digit range, decimal bases, version-token width, and
field offsets are freestanding `@[extern]` axioms kept **here**. Name-pinned on
ComplianceCorpus (`path name=Ident`). Byte loads reuse `Scalars`/`Bytes`.
-/

namespace Systems.Mgcp

open Systems.Scalars
open Systems.Bytes
open Systems.Status
open Systems.Numerics

/-- MGCP first-line shaped minimum length (4). -/
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
/-- ASCII `'M'` (77). -/
@[extern c inline "((uint32_t)77)"] public axiom cM : U32
/-- ASCII `'G'` (71). -/
@[extern c inline "((uint32_t)71)"] public axiom cG : U32
/-- ASCII `'C'` (67). -/
@[extern c inline "((uint32_t)67)"] public axiom cC : U32
/-- ASCII `'P'` (80). -/
@[extern c inline "((uint32_t)80)"] public axiom cP : U32
/-- ASCII `'/'` (47). -/
@[extern c inline "((uint32_t)47)"] public axiom cSlash : U32
/-- Decimal ten. -/
@[extern c inline "((uint32_t)10)"] public axiom tenU32 : U32
/-- Decimal hundred. -/
@[extern c inline "((uint32_t)100)"] public axiom hundredU32 : U32
/-- Offset of second digit / second method byte (1). -/
@[extern c inline "((size_t)1)"] public axiom off1 : USize
/-- Offset of third digit (2). -/
@[extern c inline "((size_t)2)"] public axiom off2 : USize
/-- Offset of `'G'` relative to `MGCP/` start (1). -/
@[extern c inline "((size_t)1)"] public axiom offMg : USize
/-- Offset of `'C'` relative to `MGCP/` start (2). -/
@[extern c inline "((size_t)2)"] public axiom offMc : USize
/-- Offset of `'P'` relative to `MGCP/` start (3). -/
@[extern c inline "((size_t)3)"] public axiom offMp : USize
/-- Offset of `'/'` relative to `MGCP/` start (4). -/
@[extern c inline "((size_t)4)"] public axiom offMs : USize
/-- Five as `USize` (`MGCP/` width). -/
@[extern c inline "((size_t)5)"] public axiom fiveUSize : USize
/-- Three as `USize` (response code width). -/
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

/-- First non-digit / non-start in decimal run; accumulate value as `U32`. -/
public unsafe def parseDec (addr : USize) (i : USize) (n : USize) (acc : U32) : U32 :=
  bifU32 (USize.blt i n)
    (let c := loadAt addr i
     bifU32 (U32.beq (isDigit c) U32.one)
       (parseDec addr (USize.add i USize.one) n
         (U32.add (U32.mul acc tenU32) (U32.sub c cZero)))
       acc)
    acc

/-- `1` if bytes at `i` start `MGCP/` (needs `i + 5 ≤ n`). -/
public unsafe def isMgcpSlash (addr : USize) (i : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n (USize.add i fiveUSize)) U32.zero
    (bifU32 (U32.beq (loadAt addr i) cM)
      (bifU32 (U32.beq (loadAt addr (USize.add i offMg)) cG)
        (bifU32 (U32.beq (loadAt addr (USize.add i offMc)) cC)
          (bifU32 (U32.beq (loadAt addr (USize.add i offMp)) cP)
            (bifU32 (U32.beq (loadAt addr (USize.add i offMs)) cSlash) U32.one U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)

/-- First `MGCP/` offset in `[i, n)`, or `n` if none (stops at line-end). -/
public unsafe def findMgcp (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let c := loadAt addr i
     bifUSize (U32.beq (isLineEnd c) U32.one) n
       (bifUSize (U32.beq (isMgcpSlash addr i n) U32.one) i
         (findMgcp addr (USize.add i USize.one) n)))
    n

/-- `0` if `n ≥ 4`, else `1`.

When `n ≥ 4`, loads first byte and folds it with `U32.land _ U32.zero` so dual-param
`addr` stays on the EmitC result path. Status remains length-class only (probe never
contributes a nonzero bit). Does not require verb/code/`MGCP/` match. -/
public unsafe def validate (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n minLen) err
    (U32.land (loadAt addr USize.zero) U32.zero)

/-- Alias of `validate`. -/
public unsafe def parse (addr : USize) (n : USize) : U32 :=
  validate addr n

/-- `1` if first three bytes are ASCII digits (needs `n ≥ 3`), else `0`. -/
public unsafe def isResponse (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n threeUSize) U32.zero
    (bifU32 (U32.beq (isDigit (loadAt addr USize.zero)) U32.one)
      (bifU32 (U32.beq (isDigit (loadAt addr off1)) U32.one)
        (bifU32 (U32.beq (isDigit (loadAt addr off2)) U32.one) U32.one U32.zero)
        U32.zero)
      U32.zero)

/-- Three-digit response code when `isResponse`, else `0`. -/
public unsafe def code (addr : USize) (n : USize) : U32 :=
  bifU32 (U32.beq (isResponse addr n) U32.one)
    (let d0 := U32.sub (loadAt addr USize.zero) cZero
     let d1 := U32.sub (loadAt addr off1) cZero
     let d2 := U32.sub (loadAt addr off2) cZero
     U32.add (U32.add (U32.mul d0 hundredU32) (U32.mul d1 tenU32)) d2)
    U32.zero

/-- Length of VERB token until first SP when not a response, else `0`.

Protocol-honest method-width export (Sip/Smtp twin). Returns `0` if short,
response-shaped, no SP, or empty verb. -/
public unsafe def method (addr : USize) (n : USize) : USize :=
  bifUSize (USize.blt n minLen) USize.zero
    (bifUSize (U32.beq (isResponse addr n) U32.one) USize.zero
      (let sp := findSpOrEnd addr USize.zero n
       bifUSize (USize.blt sp n)
         (bifUSize (U32.beq (loadAt addr sp) cSp) sp USize.zero)
         USize.zero))

/-- Decimal transaction id after the first token SP when present and digit-shaped, else `0`.

Works for both command (`VERB SP txn …`) and response (`ddd SP txn …`) first-line shapes. -/
public unsafe def txnId (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n minLen) U32.zero
    (let sp := findSpOrEnd addr USize.zero n
     bifU32 (USize.blt sp n)
       (bifU32 (U32.beq (loadAt addr sp) cSp)
         (let j := USize.add sp USize.one
          bifU32 (USize.blt j n)
            (bifU32 (U32.beq (isDigit (loadAt addr j)) U32.one)
              (parseDec addr j n U32.zero)
              U32.zero)
            U32.zero)
         U32.zero)
       U32.zero)

/-- Offset of first `MGCP/` token on the first line, or miss. **LP64**. -/
public unsafe def versionOff (addr : USize) (n : USize) : USize :=
  bifUSize (USize.blt n minLen) USize.neg1
    (let i := findMgcp addr USize.zero n
     bifUSize (USize.blt i n) i USize.neg1)

/-- `1` if a `MGCP/` version token is present on the first line, else `0`. -/
public unsafe def hasVersion (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (versionOff addr n) USize.neg1) U32.zero U32.one

end Systems.Mgcp
