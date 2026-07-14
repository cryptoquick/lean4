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
# Systems.Stun (Systems Lean)

STUN-**shaped** min-20 common header parse over dual caller `addr`/`len` byte views —
not a full STUN/ICE stack, not attribute walk, not TURN channel product.

Wire layout (RFC 5389-shaped; minimum **20** header bytes, network byte order):

| Offset | Size | Field |
|--------|------|-------|
| 0–1 | 2 | message type (BE; method/class shaped) |
| 2–3 | 2 | message length (BE; attribute payload bytes) |
| 4–7 | 4 | magic cookie (`0x2112A442` shaped) |
| 8–19 | 12 | transaction id (opaque; first dword readable) |

Ops:

* **validate** / **parse** — `0` if `n ≥ 20`, else `1` (too short); when long enough,
  probes first byte and folds it with `land 0` so dual-param `addr` is live
* **method** — message type BE `U16` as `U32`, or `0` if short
* **length** — message length BE `U16` as `U32`, or `0` if short
* **magicCookie** — cookie BE `U32` → `USize`, or miss if short
* **hasMagic** — `1` if cookie bytes match `0x2112A442`, else `0` (or short)
* **txnId0** — first 4 transaction-id bytes BE as `USize`, or miss if short

Honesty:

* **Min-20 header offsets only** — no STUN attribute TLV walk, no ICE candidate
  gather, no TURN allocate/permission, not a STUN client/server.
* **validate status is length-class only** (`ok`/`err`); the first-byte probe never
  changes the status value (`land` with zero) but keeps `addr` on the EmitC result path
  when `n ≥ 20`. Cookie/method legality is not enforced by validate.
* **loadAt dual-param honesty:** every load index is under `i < n` after the min-20
  fence. `loadAt` is **not** bounds-parameterized.
* **Distinct exports** (`lean_fs_stun_*`) from CoAP/RTCP/Diameter peers.

## Intentional TCB (Stun-local)

Header length, cookie magic bytes, BE shift amounts, field offsets, and `USize.ofU32`
are freestanding `@[extern]` axioms kept **here**. Name-pinned on ComplianceCorpus
(`path name=Ident`). Byte loads reuse `Scalars`/`Bytes`; shift/or reuse `Numerics`.
-/

namespace Systems.Stun

open Systems.Scalars
open Systems.Bytes
open Systems.Status
open Systems.Numerics

/-- STUN common header minimum length (20). -/
@[extern c inline "((size_t)20)"] public axiom headerLen : USize
/-- Shift amount 8 for big-endian packing. -/
@[extern c inline "((uint32_t)8)"] public axiom eightU32 : U32
/-- Shift amount 16 for mid bytes. -/
@[extern c inline "((uint32_t)16)"] public axiom sixteenU32 : U32
/-- Shift amount 24 for high byte. -/
@[extern c inline "((uint32_t)24)"] public axiom twentyFourU32 : U32
/-- Offset of message type low byte (1). -/
@[extern c inline "((size_t)1)"] public axiom offMethodLo : USize
/-- Offset of message length high byte (2). -/
@[extern c inline "((size_t)2)"] public axiom offLen : USize
/-- Offset of message length low byte (3). -/
@[extern c inline "((size_t)3)"] public axiom offLenLo : USize
/-- Offset of magic cookie byte0 (4). -/
@[extern c inline "((size_t)4)"] public axiom offCookie0 : USize
/-- Offset of magic cookie byte1 (5). -/
@[extern c inline "((size_t)5)"] public axiom offCookie1 : USize
/-- Offset of magic cookie byte2 (6). -/
@[extern c inline "((size_t)6)"] public axiom offCookie2 : USize
/-- Offset of magic cookie byte3 (7). -/
@[extern c inline "((size_t)7)"] public axiom offCookie3 : USize
/-- Offset of transaction id byte0 (8). -/
@[extern c inline "((size_t)8)"] public axiom offTxn0 : USize
/-- Offset of transaction id byte1 (9). -/
@[extern c inline "((size_t)9)"] public axiom offTxn1 : USize
/-- Offset of transaction id byte2 (10). -/
@[extern c inline "((size_t)10)"] public axiom offTxn2 : USize
/-- Offset of transaction id byte3 (11). -/
@[extern c inline "((size_t)11)"] public axiom offTxn3 : USize
/-- Cookie byte0 `0x21` (33). -/
@[extern c inline "((uint32_t)33)"] public axiom cookie0 : U32
/-- Cookie byte1 `0x12` (18). -/
@[extern c inline "((uint32_t)18)"] public axiom cookie1 : U32
/-- Cookie byte2 `0xA4` (164). -/
@[extern c inline "((uint32_t)164)"] public axiom cookie2 : U32
/-- Cookie byte3 `0x42` (66). -/
@[extern c inline "((uint32_t)66)"] public axiom cookie3 : U32
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

/-- `0` if `n ≥ 20`, else `1`.

When `n ≥ 20`, loads first byte and folds it with `U32.land _ U32.zero` so dual-param
`addr` stays on the EmitC result path. Status remains length-class only (probe never
contributes a nonzero bit). Does not inspect attributes past the min fence. -/
public unsafe def validate (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) err
    (U32.land (loadAt addr USize.zero) U32.zero)

/-- Alias of `validate`. -/
public unsafe def parse (addr : USize) (n : USize) : U32 :=
  validate addr n

/-- Message type / method (bytes 0–1 BE) as `U32`, or `0` if `n < 20`. -/
public unsafe def method (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (loadU16BE addr USize.zero offMethodLo)

/-- Message length (bytes 2–3 BE) as `U32`, or `0` if `n < 20`.

RFC 5389-shaped attribute payload length in bytes; not full attribute product. -/
public unsafe def length (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (loadU16BE addr offLen offLenLo)

/-- Magic cookie (bytes 4–7 BE) as `USize`, or miss if `n < 20`. **LP64**. -/
public unsafe def magicCookie (addr : USize) (n : USize) : USize :=
  bifUSize (USize.blt n headerLen) USize.neg1
    (USize.ofU32 (loadU32BE addr offCookie0 offCookie1 offCookie2 offCookie3))

/-- `1` if cookie is `0x2112A442`, else `0` (or short). -/
public unsafe def hasMagic (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (bifU32 (U32.beq (loadAt addr offCookie0) cookie0)
      (bifU32 (U32.beq (loadAt addr offCookie1) cookie1)
        (bifU32 (U32.beq (loadAt addr offCookie2) cookie2)
          (bifU32 (U32.beq (loadAt addr offCookie3) cookie3) U32.one U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)

/-- First 4 transaction-id bytes (offs 8–11 BE) as `USize`, or miss if short. **LP64**. -/
public unsafe def txnId0 (addr : USize) (n : USize) : USize :=
  bifUSize (USize.blt n headerLen) USize.neg1
    (USize.ofU32 (loadU32BE addr offTxn0 offTxn1 offTxn2 offTxn3))

end Systems.Stun
