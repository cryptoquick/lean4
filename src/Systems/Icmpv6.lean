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
# Systems.Icmpv6 (Systems Lean)

ICMPv6-**shaped** header field parse over dual caller `addr`/`len` byte views — not a
full ICMPv6 stack, not Neighbor Discovery product, not IPv6 encapsulation, not checksum
verify.

Wire layout (RFC 4443-shaped; minimum **8** header bytes, network byte order):

| Offset | Size | Field |
|--------|------|-------|
| 0 | 1 | type |
| 1 | 1 | code |
| 2 | 2 | checksum (big-endian) |
| 4 | 2 | identifier (echo-shaped; big-endian) |
| 6 | 2 | sequence (echo-shaped; big-endian) |

Ops:

* **validate** / **parse** — `0` if `n ≥ 8`, else `1` (too short); when long enough,
  probes type (byte 0) and folds it into status with `land 0` so dual-param `addr` is live
* **type** / **code** — single-byte fields as `U32` (0 if invalid length)
* **checksum** / **id** / **seq** — big-endian `U16` fields as `U32` (0 if invalid)

Honesty:

* **Header offsets only** — no ICMPv6 type dispatch product, no ND/RA/NS suite, no
  echo reply generation, no checksum algorithm / verification, no IPv6 envelope, no raw
  sockets.
* Identifier/sequence are exposed as echo-shaped fields for all types (other message
  layouts reuse those bytes differently on the wire — not modeled here).
* **validate status is length-class only** (`ok`/`err`); the type-byte probe never changes
  the status value (`land` with zero) but keeps `addr` on the EmitC result path when `n ≥ 8`.
* **loadAt dual-param honesty:** every load index is under `i < n` after the min-8
  fence. `loadAt` is **not** bounds-parameterized.

## Intentional TCB (Icmpv6-local)

Header size constant and big-endian shift amount are freestanding `@[extern]` axioms
kept **here**. Name-pinned on ComplianceCorpus (`path name=Ident`). Byte loads reuse
`Scalars`/`Bytes`; shift/or reuse `Numerics`.
-/

namespace Systems.Icmpv6

open Systems.Scalars
open Systems.Bytes
open Systems.Status
open Systems.Numerics

/-- Minimum ICMPv6 header length (8). -/
@[extern c inline "((size_t)8)"] public axiom headerLen : USize
/-- Shift amount 8 for big-endian `U16` high byte. -/
@[extern c inline "((uint32_t)8)"] public axiom eightU32 : U32
/-- Offset of code (1). -/
@[extern c inline "((size_t)1)"] public axiom offCode : USize
/-- Offset of checksum high byte (2). -/
@[extern c inline "((size_t)2)"] public axiom offChecksum : USize
/-- Offset of checksum low byte (3). -/
@[extern c inline "((size_t)3)"] public axiom offChecksumLo : USize
/-- Offset of identifier high byte (4). -/
@[extern c inline "((size_t)4)"] public axiom offId : USize
/-- Offset of identifier low byte (5). -/
@[extern c inline "((size_t)5)"] public axiom offIdLo : USize
/-- Offset of sequence high byte (6). -/
@[extern c inline "((size_t)6)"] public axiom offSeq : USize
/-- Offset of sequence low byte (7). -/
@[extern c inline "((size_t)7)"] public axiom offSeqLo : USize

/-- Load byte at index as `U32`. Caller ensures `i < n`. -/
public unsafe def loadAt (addr : USize) (i : USize) : U32 :=
  U32.ofU8 (U8.load (USize.add addr i))

/-- Big-endian `U16` at `hiOff`/`loOff` as `U32`. Caller ensures both indices in range. -/
public unsafe def loadU16BE (addr : USize) (hiOff : USize) (loOff : USize) : U32 :=
  U32.lor (U32.shiftLeft (loadAt addr hiOff) eightU32) (loadAt addr loOff)

/-- `0` if `n ≥ 8`, else `1`.

When `n ≥ 8`, loads type (byte 0) and folds it with `U32.land _ U32.zero` so dual-param
`addr` stays on the EmitC result path. Status remains length-class only (probe never
contributes a nonzero bit). Does not inspect payload past the min-length fence. -/
public unsafe def validate (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) err
    (U32.land (loadAt addr USize.zero) U32.zero)

/-- Alias of `validate`. -/
public unsafe def parse (addr : USize) (n : USize) : U32 :=
  validate addr n

/-- ICMPv6 type (byte 0), or `0` if `n < 8`. -/
public unsafe def type (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero (loadAt addr USize.zero)

/-- ICMPv6 code (byte 1), or `0` if `n < 8`. -/
public unsafe def code (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero (loadAt addr offCode)

/-- ICMPv6 checksum (bytes 2–3 BE), or `0` if `n < 8`. -/
public unsafe def checksum (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (loadU16BE addr offChecksum offChecksumLo)

/-- Echo-shaped identifier (bytes 4–5 BE), or `0` if `n < 8`. -/
public unsafe def id (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero (loadU16BE addr offId offIdLo)

/-- Echo-shaped sequence (bytes 6–7 BE), or `0` if `n < 8`. -/
public unsafe def seq (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero (loadU16BE addr offSeq offSeqLo)

end Systems.Icmpv6
