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
# Systems.Dhcp (Systems Lean)

DHCP/BOOTP-**shaped** header field parse over dual caller `addr`/`len` byte views —
not a full DHCP client/server, not option TLV decode, not lease state machine.

Wire layout (RFC 2131 / BOOTP-shaped; minimum **236** fixed header bytes, network
byte order). When `n ≥ 240`, bytes 236–239 may carry the DHCP magic cookie
`0x63 0x82 0x53 0x63` before options:

| Offset | Size | Field |
|--------|------|-------|
| 0 | 1 | op (1=BOOTREQUEST, 2=BOOTREPLY) |
| 1 | 1 | htype |
| 2 | 1 | hlen |
| 3 | 1 | hops |
| 4 | 4 | xid (big-endian transaction id) |
| 236 | 4 | magic cookie (DHCP options present) |

Ops:

* **validate** / **parse** — `0` if `n ≥ 236`, else `1` (too short); when long enough,
  probes `op` (byte 0) and folds it into status with `land 0` so dual-param `addr` is live
* **op** / **htype** / **hlen** / **hops** — single-byte fields as `U32` (0 if invalid)
* **xid** — big-endian `U32` transaction id (0 if invalid)
* **hasMagicCookie** — `1` if `n ≥ 240` and cookie bytes match, else `0`

Honesty:

* **Header offsets only** — no option parse, no DHCPDISCOVER/OFFER product, no UDP/IP
  envelope, no lease binding, no BOOTP vendor extensions product.
* **validate status is length-class only** (`ok`/`err`); the op-byte probe never changes
  the status value (`land` with zero) but keeps `addr` on the EmitC result path when
  `n ≥ 236`.
* **loadAt dual-param honesty:** every load index is under `i < n` after the min-236
  fence. `loadAt` is **not** bounds-parameterized.

## Intentional TCB (Dhcp-local)

Header size, field offsets, magic-cookie bytes, and big-endian shift amounts are
freestanding `@[extern]` axioms kept **here**. Name-pinned on ComplianceCorpus
(`path name=Ident`). Byte loads reuse `Scalars`/`Bytes`; shift/or reuse `Numerics`.
-/

namespace Systems.Dhcp

open Systems.Scalars
open Systems.Bytes
open Systems.Status
open Systems.Numerics

/-- Minimum BOOTP/DHCP fixed header length (236). -/
@[extern c inline "((size_t)236)"] public axiom headerLen : USize
/-- Length including magic cookie (240). -/
@[extern c inline "((size_t)240)"] public axiom cookieLen : USize
/-- Offset of htype (1). -/
@[extern c inline "((size_t)1)"] public axiom offHtype : USize
/-- Offset of hlen (2). -/
@[extern c inline "((size_t)2)"] public axiom offHlen : USize
/-- Offset of hops (3). -/
@[extern c inline "((size_t)3)"] public axiom offHops : USize
/-- Offset of xid high byte (4). -/
@[extern c inline "((size_t)4)"] public axiom offXid0 : USize
/-- Offset of xid byte 1 (5). -/
@[extern c inline "((size_t)5)"] public axiom offXid1 : USize
/-- Offset of xid byte 2 (6). -/
@[extern c inline "((size_t)6)"] public axiom offXid2 : USize
/-- Offset of xid low byte (7). -/
@[extern c inline "((size_t)7)"] public axiom offXid3 : USize
/-- Offset of magic cookie byte 0 (236). -/
@[extern c inline "((size_t)236)"] public axiom offCookie0 : USize
/-- Offset of magic cookie byte 1 (237). -/
@[extern c inline "((size_t)237)"] public axiom offCookie1 : USize
/-- Offset of magic cookie byte 2 (238). -/
@[extern c inline "((size_t)238)"] public axiom offCookie2 : USize
/-- Offset of magic cookie byte 3 (239). -/
@[extern c inline "((size_t)239)"] public axiom offCookie3 : USize
/-- Magic cookie byte 0 (`0x63` = 99). -/
@[extern c inline "((uint32_t)99)"] public axiom cookie0 : U32
/-- Magic cookie byte 1 (`0x82` = 130). -/
@[extern c inline "((uint32_t)130)"] public axiom cookie1 : U32
/-- Magic cookie byte 2 (`0x53` = 83). -/
@[extern c inline "((uint32_t)83)"] public axiom cookie2 : U32
/-- Magic cookie byte 3 (`0x63` = 99). -/
@[extern c inline "((uint32_t)99)"] public axiom cookie3 : U32
/-- Shift amount 8 for big-endian assemble. -/
@[extern c inline "((uint32_t)8)"] public axiom eightU32 : U32
/-- Shift amount 16 for big-endian assemble. -/
@[extern c inline "((uint32_t)16)"] public axiom sixteenU32 : U32
/-- Shift amount 24 for big-endian assemble. -/
@[extern c inline "((uint32_t)24)"] public axiom twentyFourU32 : U32

/-- Load byte at index as `U32`. Caller ensures `i < n`. -/
public unsafe def loadAt (addr : USize) (i : USize) : U32 :=
  U32.ofU8 (U8.load (USize.add addr i))

/-- Big-endian `U32` at xid offsets. Caller ensures indices in range. -/
public unsafe def loadXidBE (addr : USize) : U32 :=
  let b0 := loadAt addr offXid0
  let b1 := loadAt addr offXid1
  let b2 := loadAt addr offXid2
  let b3 := loadAt addr offXid3
  U32.lor (U32.lor (U32.shiftLeft b0 twentyFourU32) (U32.shiftLeft b1 sixteenU32))
    (U32.lor (U32.shiftLeft b2 eightU32) b3)

/-- `0` if `n ≥ 236`, else `1`.

When `n ≥ 236`, loads `op` (byte 0) and folds it with `U32.land _ U32.zero` so dual-param
`addr` stays on the EmitC result path. Status remains length-class only (probe never
contributes a nonzero bit). Does not inspect payload past the min-length fence. -/
public unsafe def validate (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) err
    (U32.land (loadAt addr USize.zero) U32.zero)

/-- Alias of `validate`. -/
public unsafe def parse (addr : USize) (n : USize) : U32 :=
  validate addr n

/-- Message op (byte 0), or `0` if `n < 236`. -/
public unsafe def op (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero (loadAt addr USize.zero)

/-- Hardware type (byte 1), or `0` if `n < 236`. -/
public unsafe def htype (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero (loadAt addr offHtype)

/-- Hardware address length (byte 2), or `0` if `n < 236`. -/
public unsafe def hlen (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero (loadAt addr offHlen)

/-- Hops (byte 3), or `0` if `n < 236`. -/
public unsafe def hops (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero (loadAt addr offHops)

/-- Transaction id (bytes 4–7 BE), or `0` if `n < 236`. -/
public unsafe def xid (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero (loadXidBE addr)

/-- `1` if `n ≥ 240` and magic cookie matches DHCP options marker, else `0`. -/
public unsafe def hasMagicCookie (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n cookieLen) U32.zero
    (bifU32 (U32.beq (loadAt addr offCookie0) cookie0)
      (bifU32 (U32.beq (loadAt addr offCookie1) cookie1)
        (bifU32 (U32.beq (loadAt addr offCookie2) cookie2)
          (bifU32 (U32.beq (loadAt addr offCookie3) cookie3) U32.one U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)

end Systems.Dhcp
