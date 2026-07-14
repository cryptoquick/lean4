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
# Systems.Arp (Systems Lean)

ARP-**shaped** header field parse over dual caller `addr`/`len` byte views — not a
full ARP stack, not neighbor cache, not NDP, not packet emission.

Wire layout (RFC 826 Ethernet/IPv4-shaped; minimum **28** bytes, network byte order):

| Offset | Size | Field |
|--------|------|-------|
| 0 | 2 | htype (hardware type, BE) |
| 2 | 2 | ptype (protocol type, BE) |
| 4 | 1 | hlen |
| 5 | 1 | plen |
| 6 | 2 | oper (operation, BE) |
| 8 | 6 | sha (sender hardware; Ethernet-shaped offset) |
| 14 | 4 | spa (sender protocol; IPv4-shaped offset) |
| 18 | 6 | tha (target hardware) |
| 24 | 4 | tpa (target protocol) |

Ops:

* **validate** / **parse** — `0` if `n ≥ 28`, else `1` (too short); when long enough,
  probes first byte and folds it into status with `land 0` so dual-param `addr` is live
* **htype** / **ptype** / **oper** — big-endian `U16` fields as `U32` (0 if short)
* **hlen** / **plen** — single-byte fields as `U32` (0 if short)
* **shaOff** / **spaOff** / **thaOff** / **tpaOff** — fixed Ethernet/IPv4 layout offsets

Honesty:

* **Header offsets only** — no ARP request/reply product, no cache insert, no Ethernet
  frame envelope, no IPv6 ND, no variable hlen/plen address product beyond fixed offsets.
* Fixed address offsets assume classic Ethernet (`hlen=6`) + IPv4 (`plen=4`) packing;
  they are layout helpers, not dynamic parsers of arbitrary hlen/plen.
* **validate status is length-class only** (`ok`/`err`); the first-byte probe never
  changes the status value (`land` with zero) but keeps `addr` on the EmitC result path
  when `n ≥ 28`.
* **loadAt dual-param honesty:** every load index is under `i < n` after the min-28
  fence. `loadAt` is **not** bounds-parameterized.

## Intentional TCB (Arp-local)

Header size, field offsets, and big-endian shift amount are freestanding `@[extern]`
axioms kept **here**. Name-pinned on ComplianceCorpus (`path name=Ident`). Byte loads
reuse `Scalars`/`Bytes`; shift/or reuse `Numerics`.
-/

namespace Systems.Arp

open Systems.Scalars
open Systems.Bytes
open Systems.Status
open Systems.Numerics

/-- Minimum Ethernet/IPv4 ARP packet length (28). -/
@[extern c inline "((size_t)28)"] public axiom headerLen : USize
/-- Shift amount 8 for big-endian `U16` high byte. -/
@[extern c inline "((uint32_t)8)"] public axiom eightU32 : U32
/-- Offset of ptype high byte (2). -/
@[extern c inline "((size_t)2)"] public axiom offPtype : USize
/-- Offset of ptype low byte (3). -/
@[extern c inline "((size_t)3)"] public axiom offPtypeLo : USize
/-- Offset of hlen (4). -/
@[extern c inline "((size_t)4)"] public axiom offHlen : USize
/-- Offset of plen (5). -/
@[extern c inline "((size_t)5)"] public axiom offPlen : USize
/-- Offset of oper high byte (6). -/
@[extern c inline "((size_t)6)"] public axiom offOper : USize
/-- Offset of oper low byte (7). -/
@[extern c inline "((size_t)7)"] public axiom offOperLo : USize
/-- Offset of sender hardware address (8). -/
@[extern c inline "((size_t)8)"] public axiom offSha : USize
/-- Offset of sender protocol address (14). -/
@[extern c inline "((size_t)14)"] public axiom offSpa : USize
/-- Offset of target hardware address (18). -/
@[extern c inline "((size_t)18)"] public axiom offTha : USize
/-- Offset of target protocol address (24). -/
@[extern c inline "((size_t)24)"] public axiom offTpa : USize
/-- Offset of htype low byte (1). -/
@[extern c inline "((size_t)1)"] public axiom offHtypeLo : USize

/-- Load byte at index as `U32`. Caller ensures `i < n`. -/
public unsafe def loadAt (addr : USize) (i : USize) : U32 :=
  U32.ofU8 (U8.load (USize.add addr i))

/-- Big-endian `U16` at `hiOff`/`loOff` as `U32`. Caller ensures both indices in range. -/
public unsafe def loadU16BE (addr : USize) (hiOff : USize) (loOff : USize) : U32 :=
  U32.lor (U32.shiftLeft (loadAt addr hiOff) eightU32) (loadAt addr loOff)

/-- `0` if `n ≥ 28`, else `1`.

When `n ≥ 28`, loads first byte and folds it with `U32.land _ U32.zero` so dual-param
`addr` stays on the EmitC result path. Status remains length-class only (probe never
contributes a nonzero bit). Does not inspect payload past the min-length fence. -/
public unsafe def validate (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) err
    (U32.land (loadAt addr USize.zero) U32.zero)

/-- Alias of `validate`. -/
public unsafe def parse (addr : USize) (n : USize) : U32 :=
  validate addr n

/-- Hardware type (bytes 0–1 BE), or `0` if `n < 28`. -/
public unsafe def htype (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (loadU16BE addr USize.zero offHtypeLo)

/-- Protocol type (bytes 2–3 BE), or `0` if `n < 28`. -/
public unsafe def ptype (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (loadU16BE addr offPtype offPtypeLo)

/-- Hardware address length (byte 4), or `0` if `n < 28`. -/
public unsafe def hlen (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero (loadAt addr offHlen)

/-- Protocol address length (byte 5), or `0` if `n < 28`. -/
public unsafe def plen (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero (loadAt addr offPlen)

/-- Operation (bytes 6–7 BE), or `0` if `n < 28`. -/
public unsafe def oper (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (loadU16BE addr offOper offOperLo)

/-- Wire offset of sender hardware address (always 8; layout helper).

`_n` is unused (keeps a function ABI under EmitC; not dual-param live data). -/
@[inline] public def shaOff (_n : USize) : USize := offSha

/-- Wire offset of sender protocol address (always 14; layout helper). -/
@[inline] public def spaOff (_n : USize) : USize := offSpa

/-- Wire offset of target hardware address (always 18; layout helper). -/
@[inline] public def thaOff (_n : USize) : USize := offTha

/-- Wire offset of target protocol address (always 24; layout helper). -/
@[inline] public def tpaOff (_n : USize) : USize := offTpa

end Systems.Arp
