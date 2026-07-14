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
# Systems.Ipsec (Systems Lean)

IPsec-**shaped** min ESP/AH-style header field parse over dual caller `addr`/`len`
byte views — not a full IPsec stack, not SAD/SPD product, not ESP/AH crypto, not
IKEv2 product.

Wire layout (RFC 4302 AH-shaped fixed skeleton + ESP SPI/seq peer fields; minimum
**12** header bytes, network byte order):

| Offset | Size | Field |
|--------|------|-------|
| 0 | 1 | next header (protocol id of payload) |
| 1 | 1 | payload length (AH 32-bit words − 2 style; raw) |
| 2–3 | 2 | reserved (not exposed) |
| 4–7 | 4 | SPI (security parameters index, BE) |
| 8–11 | 4 | sequence number (BE) |

**Distinct from `Gre` / `Ip`:** Gre is min-**4** flags/version/protocol;
Ip is min-**20** IPv4 version/ihl/total/protocol/src/dst. This module targets the
IPsec AH fixed-header skeleton (next-header + SPI + seq) with ESP-peer SPI/seq
semantics. **Not full IPsec crypto/SAD** (no AEAD, no anti-replay window product,
no tunnel/transport state machine, no IKEv2).

Ops:

* **validate** / **parse** — `0` if `n ≥ 12`, else `1` (too short); when long enough,
  probes first byte and folds it with `land 0` so dual-param `addr` is live
* **nextHeader** — byte0 as `U32`, or `0` if short
* **payloadLen** — byte1 as `U32`, or `0` if short
* **spi** — big-endian `U32` at offsets 4–7 as `USize`, or miss if short
* **seq** — big-endian `U32` at offsets 8–11 as `USize`, or miss if short

Honesty:

* **Min-12 IPsec AH-shaped header offsets only** — no ICV walk, no ESP trailer
  next-header product, **not full IPsec crypto/SAD**. Distinct exports
  (`lean_fs_ipsec_*`) from Gre (`lean_fs_gre_*`) / Ip (`lean_fs_ip_*`).
* **validate status is length-class only** (`ok`/`err`); the first-byte probe never
  changes the status value (`land` with zero) but keeps `addr` on the EmitC result path
  when `n ≥ 12`. SPI/seq legality is not enforced.
* **loadAt dual-param honesty:** every load index is under `i < n` after the min-12
  fence. `loadAt` is **not** bounds-parameterized.

## Intentional TCB (Ipsec-local)

Header length, field offsets, and BE shift amounts are freestanding `@[extern]`
axioms kept **here**. Name-pinned on ComplianceCorpus (`path name=Ident`).
Byte loads reuse `Scalars`/`Bytes`; shift/or reuse `Numerics`.
-/

namespace Systems.Ipsec

open Systems.Scalars
open Systems.Bytes
open Systems.Status
open Systems.Numerics

/-- Minimum IPsec AH-shaped header length (12). -/
@[extern c inline "((size_t)12)"] public axiom headerLen : USize
/-- Shift amount 8 for big-endian packing. -/
@[extern c inline "((uint32_t)8)"] public axiom eightU32 : U32
/-- Shift amount 16 for mid bytes. -/
@[extern c inline "((uint32_t)16)"] public axiom sixteenU32 : U32
/-- Shift amount 24 for high byte. -/
@[extern c inline "((uint32_t)24)"] public axiom twentyFourU32 : U32
/-- Offset of payload-length byte (1). -/
@[extern c inline "((size_t)1)"] public axiom offPayLen : USize
/-- Offset of SPI byte0 (4). -/
@[extern c inline "((size_t)4)"] public axiom offSpi0 : USize
/-- Offset of SPI byte1 (5). -/
@[extern c inline "((size_t)5)"] public axiom offSpi1 : USize
/-- Offset of SPI byte2 (6). -/
@[extern c inline "((size_t)6)"] public axiom offSpi2 : USize
/-- Offset of SPI byte3 (7). -/
@[extern c inline "((size_t)7)"] public axiom offSpi3 : USize
/-- Offset of sequence byte0 (8). -/
@[extern c inline "((size_t)8)"] public axiom offSeq0 : USize
/-- Offset of sequence byte1 (9). -/
@[extern c inline "((size_t)9)"] public axiom offSeq1 : USize
/-- Offset of sequence byte2 (10). -/
@[extern c inline "((size_t)10)"] public axiom offSeq2 : USize
/-- Offset of sequence byte3 (11). -/
@[extern c inline "((size_t)11)"] public axiom offSeq3 : USize
/-- Widen `U32` → `USize`. -/
@[extern c inline "((size_t)(uint32_t)(#1))"]
public axiom USize.ofU32 : U32 → USize

/-- Load byte at index as `U32`. Caller ensures `i < n`. -/
public unsafe def loadAt (addr : USize) (i : USize) : U32 :=
  U32.ofU8 (U8.load (USize.add addr i))

/-- Big-endian `U32` at four explicit offsets. Caller ensures all indices in range. -/
public unsafe def loadU32BE (addr : USize) (b0 : USize) (b1 : USize) (b2 : USize)
    (b3 : USize) : U32 :=
  U32.lor (U32.lor (U32.shiftLeft (loadAt addr b0) twentyFourU32)
      (U32.shiftLeft (loadAt addr b1) sixteenU32))
    (U32.lor (U32.shiftLeft (loadAt addr b2) eightU32)
      (loadAt addr b3))

/-- `0` if `n ≥ 12`, else `1`.

When `n ≥ 12`, loads first byte and folds it with `U32.land _ U32.zero` so dual-param
`addr` stays on the EmitC result path. Status remains length-class only (probe never
contributes a nonzero bit). Does not inspect body past the min fence. Not full IPsec
crypto/SAD. -/
public unsafe def validate (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) err
    (U32.land (loadAt addr USize.zero) U32.zero)

/-- Alias of `validate`. -/
public unsafe def parse (addr : USize) (n : USize) : U32 :=
  validate addr n

/-- Next header (byte0 protocol id), or `0` if `n < 12`. -/
public unsafe def nextHeader (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (loadAt addr USize.zero)

/-- Payload length (byte1, AH-shaped raw), or `0` if `n < 12`. -/
public unsafe def payloadLen (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (loadAt addr offPayLen)

/-- SPI (bytes 4–7 BE) as `USize`, or miss if short. **LP64**. -/
public unsafe def spi (addr : USize) (n : USize) : USize :=
  bifUSize (USize.blt n headerLen) USize.neg1
    (USize.ofU32 (loadU32BE addr offSpi0 offSpi1 offSpi2 offSpi3))

/-- Sequence number (bytes 8–11 BE) as `USize`, or miss if short. **LP64**. -/
public unsafe def seq (addr : USize) (n : USize) : USize :=
  bifUSize (USize.blt n headerLen) USize.neg1
    (USize.ofU32 (loadU32BE addr offSeq0 offSeq1 offSeq2 offSeq3))

end Systems.Ipsec
