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
# Systems.Sdp (Systems Lean)

SDP-**shaped** first-line / key-field scan over dual caller `addr`/`len` byte views —
not a full SDP stack, not offer/answer state, not media-path product.

First-line / key-field shapes (RFC 4566-shaped; ASCII; line ends with `\n` or `\r\n`):

```
v=0
o=username sess-id sess-version nettype addrtype addr
m=audio 49170 RTP/AVP 0
```

Text-protocol peer of Sip / Mgcp / Smtp (type letter + value span). Distinct
exports `lean_fs_sdp_*` — not SIP request-line method/URI (`Sip`) and not MGCP
command/response (`Mgcp`).

Minimum fence is **3** bytes (shaped lower bound for a tiny `v=0`-class line).

Ops:

* **validate** / **parse** — `0` if `n ≥ 3`, else `1` (too short); when long enough,
  probes first byte and folds it with `land 0` so dual-param `addr` is live
* **method** — first-line type letter as `U32` when second byte is `=` (protocol-honest
  field-type export), else `0`
* **isVersion** — `1` if first line is `v=…`, else `0`
* **version** — single decimal digit after `v=` when present, else `0`
* **hasOrigin** — `1` if first line is `o=…`, else `0`
* **mediaLen** — length of first media token after `m=` when present, else `0`
* **valueOff** — offset of value after first `=` on the first line, or miss

Honesty:

* **First-line type / version / media token only** — no multi-line attribute walk,
  no ice/dtls fingerprint product, not an SDP offer/answer engine.
* **validate status is length-class only** (`ok`/`err`); the first-byte probe never
  changes the status value (`land` with zero) but keeps `addr` on the EmitC result path
  when `n ≥ 3`. Type letter / `v=` / `m=` legality is **not** enforced by validate.
* **loadAt dual-param honesty:** every load index is under `i < n` after fences.
  `loadAt` is **not** bounds-parameterized.

## Intentional TCB (Sdp-local)

Minimum length, ASCII markers, digit range, and field offsets are freestanding
`@[extern]` axioms kept **here**. Name-pinned on ComplianceCorpus (`path name=Ident`).
Byte loads reuse `Scalars`/`Bytes`.
-/

namespace Systems.Sdp

open Systems.Scalars
open Systems.Bytes
open Systems.Status
open Systems.Numerics

/-- SDP first-line shaped minimum length (3). -/
@[extern c inline "((size_t)3)"] public axiom minLen : USize
/-- ASCII space (32). -/
@[extern c inline "((uint32_t)32)"] public axiom cSp : U32
/-- ASCII LF (10). -/
@[extern c inline "((uint32_t)10)"] public axiom cLf : U32
/-- ASCII CR (13). -/
@[extern c inline "((uint32_t)13)"] public axiom cCr : U32
/-- ASCII `'='` (61). -/
@[extern c inline "((uint32_t)61)"] public axiom cEq : U32
/-- ASCII `'v'` (118). -/
@[extern c inline "((uint32_t)118)"] public axiom cV : U32
/-- ASCII `'o'` (111). -/
@[extern c inline "((uint32_t)111)"] public axiom cO : U32
/-- ASCII `'m'` (109). -/
@[extern c inline "((uint32_t)109)"] public axiom cM : U32
/-- ASCII `'0'` (48). -/
@[extern c inline "((uint32_t)48)"] public axiom cZero : U32
/-- ASCII `'9'` (57). -/
@[extern c inline "((uint32_t)57)"] public axiom cNine : U32
/-- Offset of second byte / `=` (1). -/
@[extern c inline "((size_t)1)"] public axiom off1 : USize
/-- Offset of value start after `X=` (2). -/
@[extern c inline "((size_t)2)"] public axiom off2 : USize
/-- Two as `USize` (`X=` width). -/
@[extern c inline "((size_t)2)"] public axiom twoUSize : USize

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

/-- `1` if first two bytes are `X=` shape (`n ≥ 2` and byte1 is `=`). -/
public unsafe def hasTypeEq (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n twoUSize) U32.zero
    (bifU32 (U32.beq (loadAt addr off1) cEq) U32.one U32.zero)

/-- `0` if `n ≥ 3`, else `1`.

When `n ≥ 3`, loads first byte and folds it with `U32.land _ U32.zero` so dual-param
`addr` stays on the EmitC result path. Status remains length-class only (probe never
contributes a nonzero bit). Does not require `v=` / `o=` / `m=` match. -/
public unsafe def validate (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n minLen) err
    (U32.land (loadAt addr USize.zero) U32.zero)

/-- Alias of `validate`. -/
public unsafe def parse (addr : USize) (n : USize) : U32 :=
  validate addr n

/-- First-line type letter as `U32` when `X=` shape, else `0`.

Protocol-honest field-type export (Sip/Mgcp method twin for SDP type letters
`v`/`o`/`s`/`m`/…). Returns `0` if short or missing `=`. -/
public unsafe def method (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n minLen) U32.zero
    (bifU32 (U32.beq (hasTypeEq addr n) U32.one)
      (loadAt addr USize.zero)
      U32.zero)

/-- `1` if first line is `v=…` (`n ≥ 2`), else `0`. -/
public unsafe def isVersion (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n twoUSize) U32.zero
    (bifU32 (U32.beq (loadAt addr USize.zero) cV)
      (bifU32 (U32.beq (loadAt addr off1) cEq) U32.one U32.zero)
      U32.zero)

/-- Single digit after `v=` when present and digit-shaped, else `0`. -/
public unsafe def version (addr : USize) (n : USize) : U32 :=
  bifU32 (U32.beq (isVersion addr n) U32.one)
    (bifU32 (USize.blt n minLen) U32.zero
      (let c := loadAt addr off2
       bifU32 (U32.beq (isDigit c) U32.one) (U32.sub c cZero) U32.zero))
    U32.zero

/-- `1` if first line is `o=…`, else `0`. -/
public unsafe def hasOrigin (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n twoUSize) U32.zero
    (bifU32 (U32.beq (loadAt addr USize.zero) cO)
      (bifU32 (U32.beq (loadAt addr off1) cEq) U32.one U32.zero)
      U32.zero)

/-- Length of first media token after `m=` when present, else `0`.

`m=audio 49170 …` → length of `audio`. Returns `0` if not `m=`, empty, or no token end. -/
public unsafe def mediaLen (addr : USize) (n : USize) : USize :=
  bifUSize (USize.blt n minLen) USize.zero
    (bifUSize (U32.beq (loadAt addr USize.zero) cM)
      (bifUSize (U32.beq (loadAt addr off1) cEq)
        (let j := off2
         bifUSize (USize.blt j n)
           (let end_ := findSpOrEnd addr j n
            bifUSize (USize.blt j end_) (USize.sub end_ j) USize.zero)
           USize.zero)
        USize.zero)
      USize.zero)

/-- Offset of value after first-line `X=`, or miss if short / no `=`. **LP64**. -/
public unsafe def valueOff (addr : USize) (n : USize) : USize :=
  bifUSize (USize.blt n minLen) USize.neg1
    (bifUSize (U32.beq (hasTypeEq addr n) U32.one) off2 USize.neg1)

end Systems.Sdp
