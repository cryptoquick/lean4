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
# Systems.Gre (Systems Lean)

GRE-**shaped** header field parse over dual caller `addr`/`len` byte views — not a
full GRE tunnel stack, not key/sequence option product, not encapsulation.

Wire layout (RFC 2784-shaped; minimum **4** header bytes, network byte order):

| Offset | Size | Field |
|--------|------|-------|
| 0 | 1 | flags high nibble (`C|R|K|S` packing) + reserved high bits |
| 1 | 1 | reserved + **version** (low 3 bits) |
| 2 | 2 | protocol type (BE) |

Ops:

* **validate** / **parse** — `0` if `n ≥ 4`, else `1` (too short); when long enough,
  probes first byte and folds it into status with `land 0` so dual-param `addr` is live
* **flags** — high nibble of byte 0 (`0..15`), or `0` if short
* **version** — low 3 bits of byte 1 (`0..7`), or `0` if short
* **protocol** — big-endian `U16` at offset 2 as `U32` (0 if short)

Honesty:

* **Header offsets only** — no GRE key/sequence/checksum optional-field product, no
  tunnel state machine, no IPv4/IPv6 encapsulation, no routing header.
* **validate status is length-class only** (`ok`/`err`); the first-byte probe never
  changes the status value (`land` with zero) but keeps `addr` on the EmitC result path
  when `n ≥ 4`.
* **loadAt dual-param honesty:** every load index is under `i < n` after the min-4
  fence. `loadAt` is **not** bounds-parameterized.

## Intentional TCB (Gre-local)

Header size, field offsets, masks/shifts, and big-endian shift amount are freestanding
`@[extern]` axioms kept **here**. Name-pinned on ComplianceCorpus (`path name=Ident`).
Byte loads reuse `Scalars`/`Bytes`; shift/or reuse `Numerics`.
-/

namespace Systems.Gre

open Systems.Scalars
open Systems.Bytes
open Systems.Status
open Systems.Numerics

/-- Minimum GRE header length (4). -/
@[extern c inline "((size_t)4)"] public axiom headerLen : USize
/-- Shift amount 8 for big-endian `U16` high byte. -/
@[extern c inline "((uint32_t)8)"] public axiom eightU32 : U32
/-- Shift amount 4 for flags high nibble. -/
@[extern c inline "((uint32_t)4)"] public axiom fourU32 : U32
/-- High-nibble mask (`0xF0` = 240). -/
@[extern c inline "((uint32_t)240)"] public axiom maskFlagsHi : U32
/-- Version mask: low 3 bits (`0x07` = 7). -/
@[extern c inline "((uint32_t)7)"] public axiom maskVer : U32
/-- Offset of version byte (1). -/
@[extern c inline "((size_t)1)"] public axiom offVer : USize
/-- Offset of protocol type high byte (2). -/
@[extern c inline "((size_t)2)"] public axiom offProto : USize
/-- Offset of protocol type low byte (3). -/
@[extern c inline "((size_t)3)"] public axiom offProtoLo : USize

/-- Load byte at index as `U32`. Caller ensures `i < n`. -/
public unsafe def loadAt (addr : USize) (i : USize) : U32 :=
  U32.ofU8 (U8.load (USize.add addr i))

/-- Big-endian `U16` at `hiOff`/`loOff` as `U32`. Caller ensures both indices in range. -/
public unsafe def loadU16BE (addr : USize) (hiOff : USize) (loOff : USize) : U32 :=
  U32.lor (U32.shiftLeft (loadAt addr hiOff) eightU32) (loadAt addr loOff)

/-- `0` if `n ≥ 4`, else `1`.

When `n ≥ 4`, loads first byte and folds it with `U32.land _ U32.zero` so dual-param
`addr` stays on the EmitC result path. Status remains length-class only (probe never
contributes a nonzero bit). Does not inspect payload past the min-length fence. -/
public unsafe def validate (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) err
    (U32.land (loadAt addr USize.zero) U32.zero)

/-- Alias of `validate`. -/
public unsafe def parse (addr : USize) (n : USize) : U32 :=
  validate addr n

/-- Flags high nibble of byte 0 (`0..15`), or `0` if `n < 4`. -/
public unsafe def flags (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (U32.shiftRight (U32.land (loadAt addr USize.zero) maskFlagsHi) fourU32)

/-- GRE version (low 3 bits of byte 1), or `0` if `n < 4`. -/
public unsafe def version (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (U32.land (loadAt addr offVer) maskVer)

/-- Protocol type (bytes 2–3 BE), or `0` if `n < 4`. -/
public unsafe def protocol (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (loadU16BE addr offProto offProtoLo)

end Systems.Gre
