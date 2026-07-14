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
# Systems.NtpQuery (Systems Lean)

NTP-**query-shaped** min-48 request/response first-byte + key field parse over dual
caller `addr`/`len` byte views — twin of `Ntp` named for the query path; not a
full NTP client/server, not SNTP, not authentication, not clock discipline.

Wire layout (RFC 5905-shaped classic query/response; minimum **48** header bytes,
network byte order):

| Offset | Size | Field |
|--------|------|-------|
| 0 | 1 | LI (2 bits) \| VN (3 bits) \| Mode (3 bits) |
| 1 | 1 | stratum |
| 24 | 8 | originate timestamp (layout offset helper) |
| 32 | 8 | receive timestamp (layout offset helper) |
| 40 | 8 | transmit timestamp (layout offset helper) |

Classic modes: client query = `3`, server reply = `4`.

Ops:

* **validate** / **parse** — `0` if `n ≥ 48`, else `1` (too short); when long enough,
  probes first byte and folds it with `land 0` so dual-param `addr` is live
* **li** / **version** / **mode** — first-byte bitfields as `U32` (0 if invalid length)
* **isClientQuery** / **isServerReply** — mode match helpers (`1`/`0`)
* **stratum** — single-byte field as `U32` (0 if invalid)
* **originTsOff** / **recvTsOff** / **xmitTsOff** — fixed wire offsets as `USize`

Honesty:

* **Query/response first-byte + key offsets only** — no leap-second product, no
  timestamp arithmetic API, no MD5/SHA auth extension, no UDP transport, no clock
  filter / discipline. Not a drop-in for `Ntp` (query-path twin).
* First-byte bit layout is classic LI/VN/Mode (not NTPv5 redesign).
* **validate status is length-class only** (`ok`/`err`); the first-byte probe never
  changes the status value (`land` with zero) but keeps `addr` on the EmitC result path
  when `n ≥ 48`. Mode legality is not enforced by validate.
* **loadAt dual-param honesty:** every load index is under `i < n` after the min-48
  fence. `loadAt` is **not** bounds-parameterized.

## Intentional TCB (NtpQuery-local)

Header size, first-byte masks/shifts, mode constants, and timestamp offsets are
freestanding `@[extern]` axioms kept **here**. Name-pinned on ComplianceCorpus
(`path name=Ident`). Byte loads reuse `Scalars`/`Bytes`; shift/and reuse `Numerics`.
-/

namespace Systems.NtpQuery

open Systems.Scalars
open Systems.Bytes
open Systems.Status
open Systems.Numerics

/-- Minimum classic NTP query/response header length (48). -/
@[extern c inline "((size_t)48)"] public axiom headerLen : USize
/-- LI mask: high 2 bits (`0xC0` = 192). -/
@[extern c inline "((uint32_t)192)"] public axiom maskLi : U32
/-- VN mask: middle 3 bits (`0x38` = 56). -/
@[extern c inline "((uint32_t)56)"] public axiom maskVn : U32
/-- Mode mask: low 3 bits (`0x07` = 7). -/
@[extern c inline "((uint32_t)7)"] public axiom maskMode : U32
/-- Shift amount 6 for LI field. -/
@[extern c inline "((uint32_t)6)"] public axiom sixU32 : U32
/-- Shift amount 3 for VN field. -/
@[extern c inline "((uint32_t)3)"] public axiom threeU32 : U32
/-- Client query mode (`3`). -/
@[extern c inline "((uint32_t)3)"] public axiom modeClient : U32
/-- Server reply mode (`4`). -/
@[extern c inline "((uint32_t)4)"] public axiom modeServer : U32
/-- Offset of stratum (1). -/
@[extern c inline "((size_t)1)"] public axiom offStratum : USize
/-- Offset of originate timestamp (24). -/
@[extern c inline "((size_t)24)"] public axiom offOriginTs : USize
/-- Offset of receive timestamp (32). -/
@[extern c inline "((size_t)32)"] public axiom offRecvTs : USize
/-- Offset of transmit timestamp (40). -/
@[extern c inline "((size_t)40)"] public axiom offXmitTs : USize

/-- Load byte at index as `U32`. Caller ensures `i < n`. -/
public unsafe def loadAt (addr : USize) (i : USize) : U32 :=
  U32.ofU8 (U8.load (USize.add addr i))

/-- `0` if `n ≥ 48`, else `1`.

When `n ≥ 48`, loads first byte and folds it with `U32.land _ U32.zero` so dual-param
`addr` stays on the EmitC result path. Status remains length-class only (probe never
contributes a nonzero bit). Does not require client/server mode match. -/
public unsafe def validate (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) err
    (U32.land (loadAt addr USize.zero) U32.zero)

/-- Alias of `validate`. -/
public unsafe def parse (addr : USize) (n : USize) : U32 :=
  validate addr n

/-- Leap Indicator (bits 7–6 of byte 0), or `0` if `n < 48`. -/
public unsafe def li (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (U32.shiftRight (U32.land (loadAt addr USize.zero) maskLi) sixU32)

/-- Version number (bits 5–3 of byte 0), or `0` if `n < 48`. -/
public unsafe def version (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (U32.shiftRight (U32.land (loadAt addr USize.zero) maskVn) threeU32)

/-- Mode (bits 2–0 of byte 0), or `0` if `n < 48`. -/
public unsafe def mode (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (U32.land (loadAt addr USize.zero) maskMode)

/-- `1` if mode is client query (`3`), else `0`. -/
public unsafe def isClientQuery (addr : USize) (n : USize) : U32 :=
  bifU32 (U32.beq (mode addr n) modeClient) U32.one U32.zero

/-- `1` if mode is server reply (`4`), else `0`. -/
public unsafe def isServerReply (addr : USize) (n : USize) : U32 :=
  bifU32 (U32.beq (mode addr n) modeServer) U32.one U32.zero

/-- Stratum (byte 1), or `0` if `n < 48`. -/
public unsafe def stratum (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero (loadAt addr offStratum)

/-- Wire offset of originate timestamp (always 24; layout helper).

`_n` is unused (keeps a function ABI under EmitC; not dual-param live data). -/
@[inline] public def originTsOff (_n : USize) : USize := offOriginTs

/-- Wire offset of receive timestamp (always 32; layout helper).

`_n` is unused (keeps a function ABI under EmitC; not dual-param live data). -/
@[inline] public def recvTsOff (_n : USize) : USize := offRecvTs

/-- Wire offset of transmit timestamp (always 40; layout helper).

`_n` is unused (keeps a function ABI under EmitC; not dual-param live data). -/
@[inline] public def xmitTsOff (_n : USize) : USize := offXmitTs

end Systems.NtpQuery
