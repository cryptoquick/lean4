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
# Systems.Ntp (Systems Lean)

NTP-**shaped** header field parse over dual caller `addr`/`len` byte views — not a
full NTP client/server, not SNTP, not authentication, not clock discipline.

Wire layout (RFC 5905-shaped; minimum **48** classic header bytes, network byte order):

| Offset | Size | Field |
|--------|------|-------|
| 0 | 1 | LI (2 bits) \| VN (3 bits) \| Mode (3 bits) |
| 1 | 1 | stratum |
| 2 | 1 | poll |
| 3 | 1 | precision |
| 4 | 4 | root delay (optional offset helper) |
| 8 | 4 | root dispersion (optional offset helper) |

Ops:

* **validate** / **parse** — `0` if `n ≥ 48`, else `1` (too short); when long enough,
  probes first byte and folds it into status with `land 0` so dual-param `addr` is live
* **li** / **version** / **mode** — first-byte bitfields as `U32` (0 if invalid length)
* **stratum** / **poll** / **precision** — single-byte fields as `U32` (0 if invalid)
* **rootDelayOff** / **rootDispOff** — fixed wire offsets as `USize` (always; layout helpers)

Honesty:

* **Header offsets only** — no leap-second product, no transmit/receive timestamp API,
  no MD5/SHA auth extension, no UDP transport, no clock filter / discipline.
* First-byte bit layout is classic LI/VN/Mode (not NTPv5 redesign).
* **validate status is length-class only** (`ok`/`err`); the first-byte probe never changes
  the status value (`land` with zero) but keeps `addr` on the EmitC result path when `n ≥ 48`.
* **loadAt dual-param honesty:** every load index is under `i < n` after the min-48
  fence. `loadAt` is **not** bounds-parameterized.

## Intentional TCB (Ntp-local)

Header size, first-byte masks/shifts, and field offsets are freestanding `@[extern]`
axioms kept **here**. Name-pinned on ComplianceCorpus (`path name=Ident`). Byte loads
reuse `Scalars`/`Bytes`; shift/and reuse `Numerics`.
-/

namespace Systems.Ntp

open Systems.Scalars
open Systems.Bytes
open Systems.Status
open Systems.Numerics

/-- Minimum classic NTP header length (48). -/
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
/-- Offset of stratum (1). -/
@[extern c inline "((size_t)1)"] public axiom offStratum : USize
/-- Offset of poll (2). -/
@[extern c inline "((size_t)2)"] public axiom offPoll : USize
/-- Offset of precision (3). -/
@[extern c inline "((size_t)3)"] public axiom offPrecision : USize
/-- Offset of root delay (4). -/
@[extern c inline "((size_t)4)"] public axiom offRootDelay : USize
/-- Offset of root dispersion (8). -/
@[extern c inline "((size_t)8)"] public axiom offRootDisp : USize

/-- Load byte at index as `U32`. Caller ensures `i < n`. -/
public unsafe def loadAt (addr : USize) (i : USize) : U32 :=
  U32.ofU8 (U8.load (USize.add addr i))

/-- `0` if `n ≥ 48`, else `1`.

When `n ≥ 48`, loads first byte and folds it with `U32.land _ U32.zero` so dual-param
`addr` stays on the EmitC result path. Status remains length-class only (probe never
contributes a nonzero bit). Does not inspect payload past the min-length fence. -/
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

/-- Stratum (byte 1), or `0` if `n < 48`. -/
public unsafe def stratum (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero (loadAt addr offStratum)

/-- Poll (byte 2), or `0` if `n < 48`. -/
public unsafe def poll (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero (loadAt addr offPoll)

/-- Precision (byte 3 as unsigned), or `0` if `n < 48`. -/
public unsafe def precision (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero (loadAt addr offPrecision)

/-- Wire offset of root delay field (always 4; layout helper).

`_n` is unused (keeps a function ABI under EmitC; not dual-param live data). -/
@[inline] public def rootDelayOff (_n : USize) : USize := offRootDelay

/-- Wire offset of root dispersion field (always 8; layout helper).

`_n` is unused (keeps a function ABI under EmitC; not dual-param live data). -/
@[inline] public def rootDispOff (_n : USize) : USize := offRootDisp

end Systems.Ntp
