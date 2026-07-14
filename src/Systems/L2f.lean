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
# Systems.L2f (Systems Lean)

L2F-**shaped** minimum header field parse over dual caller `addr`/`len` byte
views — not a full L2F control plane, not L2TP, not GRE, not PPP product.

Wire layout (RFC 2341-ish L2F header; network byte order):

| Offset | Size | Field |
|--------|------|-------|
| 0 | 1 | flags high (`F|K|P|S|…`) |
| 1 | 1 | reserved + **C** bit + **version** (low 3 bits; Ver=1 for L2F) |
| 2 | 1 | **protocol** (U8; PPP=1, …) |
| 3 | 1 | following byte (Sequence high / MID / residual — **not** claimed here) |

**Minimum length:** **4** bytes (flags/ver + protocol + one trailing fixed byte).
Optional sequence / key / client-id / length / offset fields follow when
corresponding flag bits are set — this module does **not** walk those options.
Protocol is the **single** byte at offset 2 (not a BE U16 over 2–3).

**Distinct from `L2tp` / `Gre` / `Pptp`:** L2tp is min-**6/8**
flags/version/tunnel/session (Ver=2); Gre is min-**4** with different flag packing
(high nibble + BE protocol U16); Pptp is min-**8** length/type/cookie. This module
targets Cisco L2F flags/version + U8 protocol skeleton. **Not full L2F** (no option
walk, no management messages, no tunnel state).

Ops:

* **validate** / **parse** — `0` if `n ≥ 4`, else `1`; probes first byte with
  `land 0` so dual-param `addr` is live
* **flags** — byte0 as `U32`, or `0` if short
* **version** — low 3 bits of byte1, or `0` if short
* **protocol** — U8 at offset 2 as `U32`, or `0` if short
* **hasKey** — `1` if K bit set in flags (`0x40`), else `0`
* **hasSeq** — `1` if S bit set in flags (`0x10`), else `0`

Honesty:

* **Min-header offsets only** — no optional-field product, not full L2F. Distinct
  exports (`lean_fs_l2f_*`) from L2tp/Gre/Pptp.
* **Protocol width:** RFC 2341-shaped **U8** at offset 2 (byte 3 is not part of
  protocol; sequence/MID option layout is residual when S/K set).
* **validate status is length-class only**; version==1 and flag legality are not
  enforced.
* **loadAt dual-param honesty:** every load index is under `i < n` after the min
  fence.

## Intentional TCB (L2f-local)

Header size, field offsets, masks are freestanding `@[extern]` axioms kept
**here**. Name-pinned on ComplianceCorpus (`path name=Ident`).
-/

namespace Systems.L2f

open Systems.Scalars
open Systems.Bytes
open Systems.Status
open Systems.Numerics

/-- Minimum L2F header length (4). -/
@[extern c inline "((size_t)4)"] public axiom headerMin : USize
/-- Version mask: low 3 bits (`0x07` = 7). -/
@[extern c inline "((uint32_t)7)"] public axiom maskVer : U32
/-- Key-present flag mask on byte0 (`0x40` = 64). -/
@[extern c inline "((uint32_t)64)"] public axiom maskK : U32
/-- Sequence-present flag mask on byte0 (`0x10` = 16). -/
@[extern c inline "((uint32_t)16)"] public axiom maskS : U32
/-- Offset of version byte (1). -/
@[extern c inline "((size_t)1)"] public axiom offVer : USize
/-- Offset of protocol byte (2). -/
@[extern c inline "((size_t)2)"] public axiom offProto : USize

/-- Load byte at index as `U32`. Caller ensures `i < n`. -/
public unsafe def loadAt (addr : USize) (i : USize) : U32 :=
  U32.ofU8 (U8.load (USize.add addr i))

/-- `0` if `n ≥ 4`, else `1`.

When `n ≥ 4`, loads first byte and folds it with `U32.land _ U32.zero` so dual-param
`addr` stays on the EmitC result path. Status remains length-class only. Not full L2F. -/
public unsafe def validate (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerMin) err
    (U32.land (loadAt addr USize.zero) U32.zero)

/-- Alias of `validate`. -/
public unsafe def parse (addr : USize) (n : USize) : U32 :=
  validate addr n

/-- Flags byte (byte0 `F|K|P|S|…` packing), or `0` if `n < 4`. -/
public unsafe def flags (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerMin) U32.zero
    (loadAt addr USize.zero)

/-- L2F version (low 3 bits of byte1), or `0` if `n < 4`. -/
public unsafe def version (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerMin) U32.zero
    (U32.land (loadAt addr offVer) maskVer)

/-- Protocol type (U8 at offset 2), or `0` if `n < 4`.

RFC 2341-shaped single-byte protocol (not BE U16 over offsets 2–3). -/
public unsafe def protocol (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerMin) U32.zero
    (loadAt addr offProto)

/-- `1` if Key (K) bit is set in flags and `n ≥ 4`, else `0`. -/
public unsafe def hasKey (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerMin) U32.zero
    (bifU32 (U32.beq (U32.land (loadAt addr USize.zero) maskK) U32.zero)
      U32.zero U32.one)

/-- `1` if Sequence (S) bit is set in flags and `n ≥ 4`, else `0`. -/
public unsafe def hasSeq (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerMin) U32.zero
    (bifU32 (U32.beq (U32.land (loadAt addr USize.zero) maskS) U32.zero)
      U32.zero U32.one)

end Systems.L2f
