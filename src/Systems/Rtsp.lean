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
# Systems.Rtsp (Systems Lean)

RTSP-**shaped** first-line method / URI / version scan over dual caller `addr`/`len`
byte views — not a full RTSP stack, not SDP/body walk, not session state product.

Request-line shape (RFC 2326-shaped; ASCII; line ends with `\n` or `\r\n`):

```
METHOD SP Request-URI SP RTSP/x.y
```

Minimum fence is **8** bytes (shaped lower bound for a tiny `M U R/1.0`-class line).

Ops:

* **validate** / **parse** — `0` if `n ≥ 8`, else `1` (too short); when long enough,
  probes first byte and folds it with `land 0` so dual-param `addr` is live
* **methodLen** — length of first token until SP (or `0` if short / no SP)
* **uriOff** / **uriLen** — second token span (zeros if missing)
* **hasVersion** — `1` if third token starts with `RTSP/`, else `0`
* **versionOff** — offset of third token when `hasVersion`, else miss

Honesty:

* **First-line method/URI/version offsets only** — no header walk, no transport,
  no interleaved binary, no DESCRIBE/SETUP state machine, not an RTSP client/server.
* **validate status is length-class only** (`ok`/`err`); the first-byte probe never
  changes the status value (`land` with zero) but keeps `addr` on the EmitC result path
  when `n ≥ 8`. Version/`RTSP/` legality is not enforced by validate.
* **loadAt dual-param honesty:** every load index is under `i < n` after fences.
  `loadAt` is **not** bounds-parameterized.

## Intentional TCB (Rtsp-local)

Minimum length, ASCII markers, and field offsets are freestanding `@[extern]`
axioms kept **here**. Name-pinned on ComplianceCorpus (`path name=Ident`). Byte
loads reuse `Scalars`/`Bytes`.
-/

namespace Systems.Rtsp

open Systems.Scalars
open Systems.Bytes
open Systems.Status
open Systems.Numerics

/-- RTSP request-line shaped minimum length (8). -/
@[extern c inline "((size_t)8)"] public axiom minLen : USize
/-- ASCII space (32). -/
@[extern c inline "((uint32_t)32)"] public axiom cSp : U32
/-- ASCII LF (10). -/
@[extern c inline "((uint32_t)10)"] public axiom cLf : U32
/-- ASCII CR (13). -/
@[extern c inline "((uint32_t)13)"] public axiom cCr : U32
/-- ASCII `'R'` (82). -/
@[extern c inline "((uint32_t)82)"] public axiom cR : U32
/-- ASCII `'T'` (84). -/
@[extern c inline "((uint32_t)84)"] public axiom cT : U32
/-- ASCII `'S'` (83). -/
@[extern c inline "((uint32_t)83)"] public axiom cS : U32
/-- ASCII `'P'` (80). -/
@[extern c inline "((uint32_t)80)"] public axiom cP : U32
/-- ASCII `'/'` (47). -/
@[extern c inline "((uint32_t)47)"] public axiom cSlash : U32
/-- Offset of second `RTSP/` byte (1). -/
@[extern c inline "((size_t)1)"] public axiom off1 : USize
/-- Offset of third `RTSP/` byte (2). -/
@[extern c inline "((size_t)2)"] public axiom off2 : USize
/-- Offset of fourth `RTSP/` byte (3). -/
@[extern c inline "((size_t)3)"] public axiom off3 : USize
/-- Offset of `'/'` in `RTSP/` (4). -/
@[extern c inline "((size_t)4)"] public axiom off4 : USize
/-- Five as `USize` (`RTSP/` width). -/
@[extern c inline "((size_t)5)"] public axiom fiveUSize : USize

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

/-- `1` if bytes at `i` start `RTSP/` (needs `i + 5 ≤ n`, i.e. width `fiveUSize`). -/
public unsafe def isRtspSlash (addr : USize) (i : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n (USize.add i fiveUSize)) U32.zero
    (bifU32 (U32.beq (loadAt addr i) cR)
      (bifU32 (U32.beq (loadAt addr (USize.add i off1)) cT)
        (bifU32 (U32.beq (loadAt addr (USize.add i off2)) cS)
          (bifU32 (U32.beq (loadAt addr (USize.add i off3)) cP)
            (bifU32 (U32.beq (loadAt addr (USize.add i off4)) cSlash) U32.one U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)

/-- `0` if `n ≥ 8`, else `1`.

When `n ≥ 8`, loads first byte and folds it with `U32.land _ U32.zero` so dual-param
`addr` stays on the EmitC result path. Status remains length-class only (probe never
contributes a nonzero bit). Does not require `RTSP/` match. -/
public unsafe def validate (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n minLen) err
    (U32.land (loadAt addr USize.zero) U32.zero)

/-- Alias of `validate`. -/
public unsafe def parse (addr : USize) (n : USize) : U32 :=
  validate addr n

/-- Length of METHOD token (bytes until first SP), or `0` if short / no SP. -/
public unsafe def methodLen (addr : USize) (n : USize) : USize :=
  bifUSize (USize.blt n minLen) USize.zero
    (let sp := findSpOrEnd addr USize.zero n
     bifUSize (USize.blt sp n)
       (bifUSize (U32.beq (loadAt addr sp) cSp) sp USize.zero)
       USize.zero)

/-- URI start offset (after first SP), or `0` if missing. -/
public unsafe def uriOff (addr : USize) (n : USize) : USize :=
  bifUSize (USize.blt n minLen) USize.zero
    (let sp := findSpOrEnd addr USize.zero n
     bifUSize (USize.blt sp n)
       (bifUSize (U32.beq (loadAt addr sp) cSp) (USize.add sp USize.one) USize.zero)
       USize.zero)

/-- URI token length (until next SP / line-end), or `0` if missing. -/
public unsafe def uriLen (addr : USize) (n : USize) : USize :=
  bifUSize (USize.blt n minLen) USize.zero
    (let uo := uriOff addr n
     bifUSize (USize.beq uo USize.zero) USize.zero
       (let hi := findSpOrEnd addr uo n
        bifUSize (USize.blt uo hi) (USize.sub hi uo) USize.zero))

/-- Start of third token (after URI SP), or miss. -/
public unsafe def versionOff (addr : USize) (n : USize) : USize :=
  bifUSize (USize.blt n minLen) USize.neg1
    (let uo := uriOff addr n
     bifUSize (USize.beq uo USize.zero) USize.neg1
       (let ul := uriLen addr n
        bifUSize (USize.beq ul USize.zero) USize.neg1
          (let sp2 := USize.add uo ul
           bifUSize (USize.blt sp2 n)
             (bifUSize (U32.beq (loadAt addr sp2) cSp)
               (let vo := USize.add sp2 USize.one
                bifUSize (U32.beq (isRtspSlash addr vo n) U32.one) vo USize.neg1)
               USize.neg1)
             USize.neg1)))

/-- `1` if third token starts with `RTSP/`, else `0`. -/
public unsafe def hasVersion (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (versionOff addr n) USize.neg1) U32.zero U32.one

end Systems.Rtsp
