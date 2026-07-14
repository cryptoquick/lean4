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
# Systems.L2tp (Systems Lean)

L2TP-**shaped** minimum header field parse over dual caller `addr`/`len` byte
views — not a full L2TP control plane, not data-session product, not AVP
decode, not PPP encapsulation.

Wire layout (RFC 2661-ish L2TP header; network byte order):

| Offset | Size | Field (L bit clear — data min) |
|--------|------|--------------------------------|
| 0 | 1 | flags high (`T|L|x|x|S|x|O|P`) |
| 1 | 1 | reserved + **version** (low 4 bits; Ver=2 for L2TPv2) |
| 2–3 | 2 | **tunnel id** (BE) when L=0; **length** (BE) when L=1 |
| 4–5 | 2 | **session id** (BE) when L=0; **tunnel id** when L=1 |
| 6–7 | 2 | **session id** (BE) when L=1 |

**Minimum length:**

* **6** bytes when Length bit L is **clear** (flags/ver + tunnel + session) —
  typical data-message skeleton.
* **8** bytes when Length bit L is **set** (flags/ver + length + tunnel + session).

`validate` / `parse` fence only the absolute min (**6**). Callers that need L=1
field layout must ensure `n ≥ 8` before reading tunnel/session (those accessors
return miss / zero when short for the selected layout).

**Distinct from `Gre` / `Ipsec`:** Gre is min-**4** flags/version/protocol;
Ipsec is min-**12** next-header/SPI/seq. This module targets L2TP tunnel/session
ids after the flags/version word. **Not full L2TP control plane** (no AVPs, no
SCCRQ/SCCRP, no Ns/Nr sequence product, no offset pad walk).

Ops:

* **validate** / **parse** — `0` if `n ≥ 6`, else `1` (too short); when long enough,
  probes first byte and folds it with `land 0` so dual-param `addr` is live
* **flags** — byte0 as `U32`, or `0` if short
* **version** — low 4 bits of byte1 (`0..15`), or `0` if short
* **hasLength** — `1` if L bit set in flags and `n ≥ 6`, else `0`
* **length** — BE U16 at offset 2 when L set and `n ≥ 8`, else `0` (L clear or short)
* **tunnelId** — BE U16 as `USize` at L-adaptive offset, or miss if short for layout
* **sessionId** — BE U16 as `USize` at L-adaptive offset, or miss if short for layout

Honesty:

* **Min-header offsets only** — no control AVP walk, no sequence/offset option
  product, **not full L2TP control plane**. Distinct exports (`lean_fs_l2tp_*`)
  from Gre (`lean_fs_gre_*`) / Ipsec (`lean_fs_ipsec_*`).
* **validate status is length-class only** (`ok`/`err` for `n ≥ 6`); the first-byte
  probe never changes the status value (`land` with zero) but keeps `addr` on the
  EmitC result path. Version==2 and T-bit legality are not enforced.
* **L-bit honesty:** tunnel/session offsets depend on the Length flag. L=0 uses
  the min-6 layout; L=1 needs min-8. `length` is `0` when L is clear.
* **loadAt dual-param honesty:** every load index is under `i < n` after the layout
  fence. `loadAt` is **not** bounds-parameterized.

## Intentional TCB (L2tp-local)

Header sizes, field offsets, masks/shifts, and big-endian shift amount are
freestanding `@[extern]` axioms kept **here**. Name-pinned on ComplianceCorpus
(`path name=Ident`). Byte loads reuse `Scalars`/`Bytes`; shift/or reuse `Numerics`.
-/

namespace Systems.L2tp

open Systems.Scalars
open Systems.Bytes
open Systems.Status
open Systems.Numerics

/-- Absolute minimum L2TP header length (6) — L clear. -/
@[extern c inline "((size_t)6)"] public axiom headerMin : USize
/-- Minimum when Length bit set (8). -/
@[extern c inline "((size_t)8)"] public axiom headerWithLen : USize
/-- Shift amount 8 for big-endian `U16` high byte. -/
@[extern c inline "((uint32_t)8)"] public axiom eightU32 : U32
/-- Length-present flag mask on byte0 (`0x40` = 64). -/
@[extern c inline "((uint32_t)64)"] public axiom maskL : U32
/-- Version mask: low 4 bits (`0x0F` = 15). -/
@[extern c inline "((uint32_t)15)"] public axiom maskVer : U32
/-- Offset of version byte (1). -/
@[extern c inline "((size_t)1)"] public axiom offVer : USize
/-- Offset of length high byte when L set (2). -/
@[extern c inline "((size_t)2)"] public axiom off2 : USize
/-- Offset of length low / tunnel low when L clear (3). -/
@[extern c inline "((size_t)3)"] public axiom off3 : USize
/-- Offset of session high when L clear / tunnel high when L set (4). -/
@[extern c inline "((size_t)4)"] public axiom off4 : USize
/-- Offset of session low when L clear / tunnel low when L set (5). -/
@[extern c inline "((size_t)5)"] public axiom off5 : USize
/-- Offset of session high when L set (6). -/
@[extern c inline "((size_t)6)"] public axiom off6 : USize
/-- Offset of session low when L set (7). -/
@[extern c inline "((size_t)7)"] public axiom off7 : USize
/-- Widen `U32` → `USize`. -/
@[extern c inline "((size_t)(uint32_t)(#1))"]
public axiom USize.ofU32 : U32 → USize

/-- Load byte at index as `U32`. Caller ensures `i < n`. -/
public unsafe def loadAt (addr : USize) (i : USize) : U32 :=
  U32.ofU8 (U8.load (USize.add addr i))

/-- Big-endian `U16` at `hiOff`/`loOff` as `U32`. Caller ensures both indices in range. -/
public unsafe def loadU16BE (addr : USize) (hiOff : USize) (loOff : USize) : U32 :=
  U32.lor (U32.shiftLeft (loadAt addr hiOff) eightU32) (loadAt addr loOff)

/-- `0` if `n ≥ 6`, else `1`.

When `n ≥ 6`, loads first byte and folds it with `U32.land _ U32.zero` so dual-param
`addr` stays on the EmitC result path. Status remains length-class only (probe never
contributes a nonzero bit). Does not inspect body past the min fence. Not full L2TP
control plane. -/
public unsafe def validate (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerMin) err
    (U32.land (loadAt addr USize.zero) U32.zero)

/-- Alias of `validate`. -/
public unsafe def parse (addr : USize) (n : USize) : U32 :=
  validate addr n

/-- Flags byte (byte0 `T|L|x|x|S|x|O|P` packing), or `0` if `n < 6`. -/
public unsafe def flags (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerMin) U32.zero
    (loadAt addr USize.zero)

/-- L2TP version (low 4 bits of byte1), or `0` if `n < 6`. -/
public unsafe def version (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerMin) U32.zero
    (U32.land (loadAt addr offVer) maskVer)

/-- `1` if Length (L) bit is set in flags and `n ≥ 6`, else `0`. -/
public unsafe def hasLength (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerMin) U32.zero
    (bifU32 (U32.beq (U32.land (loadAt addr USize.zero) maskL) U32.zero)
      U32.zero U32.one)

/-- Optional Length field (BE U16 at offset 2) when L set and `n ≥ 8`, else `0`.

When L is clear, returns `0` (field absent). Does not treat absence as error. -/
public unsafe def length (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerMin) U32.zero
    (bifU32 (U32.beq (U32.land (loadAt addr USize.zero) maskL) U32.zero)
      U32.zero
      (bifU32 (USize.blt n headerWithLen) U32.zero
        (loadU16BE addr off2 off3)))

/-- Tunnel id (BE U16) as `USize`, or miss if short for the L-selected layout. **LP64**.

L clear → offsets 2–3 (`n ≥ 6`). L set → offsets 4–5 (`n ≥ 8`). -/
public unsafe def tunnelId (addr : USize) (n : USize) : USize :=
  bifUSize (USize.blt n headerMin) USize.neg1
    (bifUSize (U32.beq (U32.land (loadAt addr USize.zero) maskL) U32.zero)
      (USize.ofU32 (loadU16BE addr off2 off3))
      (bifUSize (USize.blt n headerWithLen) USize.neg1
        (USize.ofU32 (loadU16BE addr off4 off5))))

/-- Session id (BE U16) as `USize`, or miss if short for the L-selected layout. **LP64**.

L clear → offsets 4–5 (`n ≥ 6`). L set → offsets 6–7 (`n ≥ 8`). -/
public unsafe def sessionId (addr : USize) (n : USize) : USize :=
  bifUSize (USize.blt n headerMin) USize.neg1
    (bifUSize (U32.beq (U32.land (loadAt addr USize.zero) maskL) U32.zero)
      (USize.ofU32 (loadU16BE addr off4 off5))
      (bifUSize (USize.blt n headerWithLen) USize.neg1
        (USize.ofU32 (loadU16BE addr off6 off7))))

end Systems.L2tp
