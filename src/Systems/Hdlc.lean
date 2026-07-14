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
# Systems.Hdlc (Systems Lean)

HDLC-**shaped** minimum frame header field parse over dual caller `addr`/`len` byte
views — not a full HDLC control plane, not PPP LCP, not SLIP, not L2TP/L2F product.

Wire layout (ISO/IEC 13239-ish opening flag + address/control; network byte order):

| Offset | Size | Field |
|--------|------|-------|
| 0 | 1 | **flag** (opening `0x7E`) |
| 1 | 1 | **address** (often `0xFF` all-stations) |
| 2 | 1 | **control** (UI often `0x03`) |
| 3 | 1 | first information / residual byte (not walked) |

**Minimum length:** **4** bytes.

**Distinct from `Ppp` / `L2f` / `L2tp` / `Pptp`:** Ppp is min-**4**
address/control/**BE U16 protocol** without opening flag; L2f is flags/version/U8-protocol;
L2tp is min-**6/8** tunnel/session; Pptp is min-**8** cookie. This module targets classic
HDLC opening-flag + address/control skeleton. **Not full HDLC** (no FCS, no bit/byte
stuffing, no SABME/UA state machine).

Ops:

* **validate** / **parse** — `0` if `n ≥ 4`, else `1`; probes first byte with
  `land 0` so dual-param `addr` is live
* **flag** / **address** / **control** — bytes 0/1/2 as `U32`, or `0` if short
* **hasOpenFlag** — `1` if flag is `0x7E` and `n ≥ 4`, else `0`
* **hasAllStations** — `1` if address is `0xFF` and `n ≥ 4`, else `0`
* **hasUiControl** — `1` if control is `0x03` and `n ≥ 4`, else `0`

Honesty:

* **Min-header offsets only** — no FCS verify, no escape decode, not full HDLC.
* **validate status is length-class only**; flag/address/control legality are not enforced.
* **loadAt dual-param honesty:** every load index is under `i < n` after the min fence.

## Intentional TCB (Hdlc-local)

Header size, field offsets, masks/constants are freestanding `@[extern]` axioms kept
**here**. Name-pinned on ComplianceCorpus (`path name=Ident`).
-/

namespace Systems.Hdlc

open Systems.Scalars
open Systems.Bytes
open Systems.Status
open Systems.Numerics

/-- Minimum HDLC-shaped header length (4). -/
@[extern c inline "((size_t)4)"] public axiom headerMin : USize
/-- Opening flag `0x7E` (126). -/
@[extern c inline "((uint32_t)126)"] public axiom flagOpen : U32
/-- All-stations address `0xFF` (255). -/
@[extern c inline "((uint32_t)255)"] public axiom addrAllStations : U32
/-- Unnumbered-info control `0x03` (3). -/
@[extern c inline "((uint32_t)3)"] public axiom ctrlUi : U32
/-- Offset of address byte (1). -/
@[extern c inline "((size_t)1)"] public axiom offAddr : USize
/-- Offset of control byte (2). -/
@[extern c inline "((size_t)2)"] public axiom offCtrl : USize
/-- Offset of first info / residual byte (3). -/
@[extern c inline "((size_t)3)"] public axiom offInfo : USize

/-- Load byte at index as `U32`. Caller ensures `i < n`. -/
public unsafe def loadAt (addr : USize) (i : USize) : U32 :=
  U32.ofU8 (U8.load (USize.add addr i))

/-- `0` if `n ≥ 4`, else `1`.

When `n ≥ 4`, loads first byte and folds it with `U32.land _ U32.zero` so dual-param
`addr` stays on the EmitC result path. Status remains length-class only. Not full HDLC. -/
public unsafe def validate (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerMin) err
    (U32.land (loadAt addr USize.zero) U32.zero)

/-- Alias of `validate`. -/
public unsafe def parse (addr : USize) (n : USize) : U32 :=
  validate addr n

/-- Opening flag byte (byte0), or `0` if `n < 4`. -/
public unsafe def flag (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerMin) U32.zero
    (loadAt addr USize.zero)

/-- Address byte (byte1), or `0` if `n < 4`. -/
public unsafe def address (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerMin) U32.zero
    (loadAt addr offAddr)

/-- Control byte (byte2), or `0` if `n < 4`. -/
public unsafe def control (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerMin) U32.zero
    (loadAt addr offCtrl)

/-- First info/residual byte (byte3), or `0` if `n < 4`. -/
public unsafe def info0 (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerMin) U32.zero
    (loadAt addr offInfo)

/-- `1` if opening flag is `0x7E` and `n ≥ 4`, else `0`. -/
public unsafe def hasOpenFlag (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerMin) U32.zero
    (bifU32 (U32.beq (loadAt addr USize.zero) flagOpen) U32.one U32.zero)

/-- `1` if address is all-stations `0xFF` and `n ≥ 4`, else `0`. -/
public unsafe def hasAllStations (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerMin) U32.zero
    (bifU32 (U32.beq (loadAt addr offAddr) addrAllStations) U32.one U32.zero)

/-- `1` if control is UI `0x03` and `n ≥ 4`, else `0`. -/
public unsafe def hasUiControl (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerMin) U32.zero
    (bifU32 (U32.beq (loadAt addr offCtrl) ctrlUi) U32.one U32.zero)

end Systems.Hdlc
