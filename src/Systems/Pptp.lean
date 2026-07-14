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
# Systems.Pptp (Systems Lean)

PPTP control-message-**shaped** minimum header field parse over dual caller
`addr`/`len` byte views — not a full PPTP control plane, not GRE data path,
not PPP encapsulation, not call-state machine.

Wire layout (RFC 2637-ish PPTP control message header; network byte order):

| Offset | Size | Field |
|--------|------|-------|
| 0–1 | 2 | **length** (BE U16; total message length) |
| 2–3 | 2 | **message type** (BE U16; 1 = control message) |
| 4–7 | 4 | **magic cookie** (BE U32; `0x1A2B3C4D`) |

**Minimum length:** **8** bytes (fixed skeleton before message-specific body).

**Distinct from `L2tp` / `Gre` / `Ipsec`:** L2tp is min-**6/8**
flags/version/tunnel/session; Gre is min-**4** flags/version/protocol; Ipsec is
min-**12** next-header/SPI/seq. This module targets the PPTP control magic-cookie
header (length + type + cookie). **Not full PPTP** (no Start-Control-Connection,
no Call-Management AVPs, no GRE data channel product).

Ops:

* **validate** / **parse** — `0` if `n ≥ 8`, else `1`; when long enough, probes
  first byte and folds with `land 0` so dual-param `addr` is live
* **length** — BE U16 at offset 0, or `0` if short
* **messageType** — BE U16 at offset 2, or `0` if short
* **magicCookie** — BE U32 at offset 4 as `USize`, or miss if short
* **hasMagic** — `1` if cookie equals `0x1A2B3C4D`, else `0` (or short)

Honesty:

* **Min-header offsets only** — no control-message body walk, no GRE peer product,
  not a PPTP stack. Distinct exports (`lean_fs_pptp_*`) from L2tp/Gre/Ipsec.
* **validate status is length-class only** (`ok`/`err` for `n ≥ 8`); the first-byte
  probe never changes the status value (`land` with zero). Magic match is **not**
  required by validate.
* **loadAt dual-param honesty:** every load index is under `i < n` after the min
  fence. `loadAt` is **not** bounds-parameterized.

## Intentional TCB (Pptp-local)

Header size, field offsets, magic cookie constant, and BE shift amounts are
freestanding `@[extern]` axioms kept **here**. Name-pinned on ComplianceCorpus
(`path name=Ident`). Byte loads reuse `Scalars`/`Bytes`; shift/or reuse `Numerics`.
-/

namespace Systems.Pptp

open Systems.Scalars
open Systems.Bytes
open Systems.Status
open Systems.Numerics

/-- Minimum PPTP control message header length (8). -/
@[extern c inline "((size_t)8)"] public axiom headerMin : USize
/-- Shift amount 8 for big-endian packing. -/
@[extern c inline "((uint32_t)8)"] public axiom eightU32 : U32
/-- Shift amount 16. -/
@[extern c inline "((uint32_t)16)"] public axiom sixteenU32 : U32
/-- Shift amount 24. -/
@[extern c inline "((uint32_t)24)"] public axiom twentyFourU32 : U32
/-- Offset of length low byte (1). -/
@[extern c inline "((size_t)1)"] public axiom off1 : USize
/-- Offset of message-type high byte (2). -/
@[extern c inline "((size_t)2)"] public axiom off2 : USize
/-- Offset of message-type low byte (3). -/
@[extern c inline "((size_t)3)"] public axiom off3 : USize
/-- Offset of magic cookie byte0 (4). -/
@[extern c inline "((size_t)4)"] public axiom off4 : USize
/-- Offset of magic cookie byte1 (5). -/
@[extern c inline "((size_t)5)"] public axiom off5 : USize
/-- Offset of magic cookie byte2 (6). -/
@[extern c inline "((size_t)6)"] public axiom off6 : USize
/-- Offset of magic cookie byte3 (7). -/
@[extern c inline "((size_t)7)"] public axiom off7 : USize
/-- PPTP magic cookie high byte `0x1A` (26). -/
@[extern c inline "((uint32_t)26)"] public axiom magic0 : U32
/-- PPTP magic cookie byte `0x2B` (43). -/
@[extern c inline "((uint32_t)43)"] public axiom magic1 : U32
/-- PPTP magic cookie byte `0x3C` (60). -/
@[extern c inline "((uint32_t)60)"] public axiom magic2 : U32
/-- PPTP magic cookie low byte `0x4D` (77). -/
@[extern c inline "((uint32_t)77)"] public axiom magic3 : U32
/-- Widen `U32` → `USize`. -/
@[extern c inline "((size_t)(uint32_t)(#1))"]
public axiom USize.ofU32 : U32 → USize

/-- Load byte at index as `U32`. Caller ensures `i < n`. -/
public unsafe def loadAt (addr : USize) (i : USize) : U32 :=
  U32.ofU8 (U8.load (USize.add addr i))

/-- Big-endian `U16` at `hiOff`/`loOff` as `U32`. Caller ensures both indices in range. -/
public unsafe def loadU16BE (addr : USize) (hiOff : USize) (loOff : USize) : U32 :=
  U32.lor (U32.shiftLeft (loadAt addr hiOff) eightU32) (loadAt addr loOff)

/-- Big-endian `U32` at four explicit offsets. Caller ensures all indices in range. -/
public unsafe def loadU32BE (addr : USize) (b0 : USize) (b1 : USize) (b2 : USize)
    (b3 : USize) : U32 :=
  U32.lor (U32.lor (U32.shiftLeft (loadAt addr b0) twentyFourU32)
      (U32.shiftLeft (loadAt addr b1) sixteenU32))
    (U32.lor (U32.shiftLeft (loadAt addr b2) eightU32)
      (loadAt addr b3))

/-- `0` if `n ≥ 8`, else `1`.

When `n ≥ 8`, loads first byte and folds it with `U32.land _ U32.zero` so dual-param
`addr` stays on the EmitC result path. Status remains length-class only. Not full PPTP. -/
public unsafe def validate (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerMin) err
    (U32.land (loadAt addr USize.zero) U32.zero)

/-- Alias of `validate`. -/
public unsafe def parse (addr : USize) (n : USize) : U32 :=
  validate addr n

/-- Total message length (BE U16 at offset 0), or `0` if `n < 8`. -/
public unsafe def length (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerMin) U32.zero
    (loadU16BE addr USize.zero off1)

/-- PPTP message type (BE U16 at offset 2), or `0` if `n < 8`. -/
public unsafe def messageType (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerMin) U32.zero
    (loadU16BE addr off2 off3)

/-- Magic cookie (BE U32 at offset 4) as `USize`, or miss if short. **LP64.** -/
public unsafe def magicCookie (addr : USize) (n : USize) : USize :=
  bifUSize (USize.blt n headerMin) USize.neg1
    (USize.ofU32 (loadU32BE addr off4 off5 off6 off7))

/-- `1` if magic cookie is `0x1A2B3C4D`, else `0` (or short). -/
public unsafe def hasMagic (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerMin) U32.zero
    (bifU32 (U32.beq (loadAt addr off4) magic0)
      (bifU32 (U32.beq (loadAt addr off5) magic1)
        (bifU32 (U32.beq (loadAt addr off6) magic2)
          (bifU32 (U32.beq (loadAt addr off7) magic3) U32.one U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)

end Systems.Pptp
