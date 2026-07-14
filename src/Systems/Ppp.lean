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
# Systems.Ppp (Systems Lean)

PPP-**shaped** minimum header field parse over dual caller `addr`/`len` byte
views — not a full PPP control plane, not LCP/IPCP negotiation, not HDLC framing
product, not L2TP/PPTP/L2F.

Wire layout (RFC 1661-ish PPP address/control/protocol; network byte order):

| Offset | Size | Field |
|--------|------|-------|
| 0 | 1 | **address** (often `0xFF` all-stations) |
| 1 | 1 | **control** (often `0x03` UI) |
| 2–3 | 2 | **protocol** (BE U16; e.g. `0x0021` IPv4, `0xc021` LCP) |

**Minimum length:** **4** bytes.

**Distinct from `L2tp` / `L2f` / `Pptp` / `Gre`:** L2tp is min-**6/8**
tunnel/session; L2f is min-**4** with U8 protocol @2; Pptp is min-**8** cookie;
Gre is min-**4** flags/version/protocol with different flag packing. This module
targets classic PPP address/control + BE protocol skeleton. **Not full PPP**.

Ops:

* **validate** / **parse** — `0` if `n ≥ 4`, else `1`; probes first byte with
  `land 0` so dual-param `addr` is live
* **address** / **control** — bytes 0/1 as `U32`, or `0` if short
* **protocol** — BE U16 at offset 2 as `U32`, or `0` if short
* **hasAllStations** — `1` if address is `0xFF` and `n ≥ 4`, else `0`
* **hasUiControl** — `1` if control is `0x03` and `n ≥ 4`, else `0`

Honesty:

* **Min-header offsets only** — no FCS, no escaping, no LCP options, not full PPP.
* **validate status is length-class only**; address/control legality are not enforced.
* **loadAt dual-param honesty:** every load index is under `i < n` after the min fence.

## Intentional TCB (Ppp-local)

Header size, field offsets, masks/shifts are freestanding `@[extern]` axioms kept
**here**. Name-pinned on ComplianceCorpus (`path name=Ident`).
-/

namespace Systems.Ppp

open Systems.Scalars
open Systems.Bytes
open Systems.Status
open Systems.Numerics

/-- Minimum PPP header length (4). -/
@[extern c inline "((size_t)4)"] public axiom headerMin : USize
/-- All-stations address `0xFF` (255). -/
@[extern c inline "((uint32_t)255)"] public axiom addrAllStations : U32
/-- Unnumbered-info control `0x03` (3). -/
@[extern c inline "((uint32_t)3)"] public axiom ctrlUi : U32
/-- Shift amount 8 for BE protocol pack. -/
@[extern c inline "((uint32_t)8)"] public axiom eightU32 : U32
/-- Offset of control byte (1). -/
@[extern c inline "((size_t)1)"] public axiom offCtrl : USize
/-- Offset of protocol high byte (2). -/
@[extern c inline "((size_t)2)"] public axiom offProtoHi : USize
/-- Offset of protocol low byte (3). -/
@[extern c inline "((size_t)3)"] public axiom offProtoLo : USize

/-- Load byte at index as `U32`. Caller ensures `i < n`. -/
public unsafe def loadAt (addr : USize) (i : USize) : U32 :=
  U32.ofU8 (U8.load (USize.add addr i))

/-- `0` if `n ≥ 4`, else `1`.

When `n ≥ 4`, loads first byte and folds it with `U32.land _ U32.zero` so dual-param
`addr` stays on the EmitC result path. Status remains length-class only. Not full PPP. -/
public unsafe def validate (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerMin) err
    (U32.land (loadAt addr USize.zero) U32.zero)

/-- Alias of `validate`. -/
public unsafe def parse (addr : USize) (n : USize) : U32 :=
  validate addr n

/-- Address byte (byte0), or `0` if `n < 4`. -/
public unsafe def address (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerMin) U32.zero
    (loadAt addr USize.zero)

/-- Control byte (byte1), or `0` if `n < 4`. -/
public unsafe def control (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerMin) U32.zero
    (loadAt addr offCtrl)

/-- Protocol type (BE U16 at offsets 2–3) as `U32`, or `0` if `n < 4`. -/
public unsafe def protocol (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerMin) U32.zero
    (U32.lor (U32.shiftLeft (loadAt addr offProtoHi) eightU32)
      (loadAt addr offProtoLo))

/-- `1` if address is all-stations `0xFF` and `n ≥ 4`, else `0`. -/
public unsafe def hasAllStations (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerMin) U32.zero
    (bifU32 (U32.beq (loadAt addr USize.zero) addrAllStations) U32.one U32.zero)

/-- `1` if control is UI `0x03` and `n ≥ 4`, else `0`. -/
public unsafe def hasUiControl (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerMin) U32.zero
    (bifU32 (U32.beq (loadAt addr offCtrl) ctrlUi) U32.one U32.zero)

end Systems.Ppp
