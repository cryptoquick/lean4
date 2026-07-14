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
# Systems.Socks5 (Systems Lean)

SOCKS5-**shaped** greeting / request min-header parse over dual caller `addr`/`len`
byte views — not a full SOCKS5 proxy, not auth method negotiation body walk, not
connect/bind/udp-associate product.

Wire layouts (RFC 1928-shaped):

**Greeting** (minimum **2** bytes):

| Offset | Size | Field |
|--------|------|-------|
| 0 | 1 | VER (5) |
| 1 | 1 | NMETHODS |

**Request** (minimum **4** header bytes before address):

| Offset | Size | Field |
|--------|------|-------|
| 0 | 1 | VER |
| 1 | 1 | CMD |
| 2 | 1 | RSV |
| 3 | 1 | ATYP |

Ops:

* **validate** / **parse** — `0` if `n ≥ 2`, else `1` (too short); when long enough,
  probes first byte and folds it with `land 0` so dual-param `addr` is live
* **version** — byte0 as `U32`, or `0` if short (`n < 2`)
* **nmethods** — byte1 as `U32`, or `0` if short
* **reqValidate** — `0` if `n ≥ 4`, else `1` (request min fence)
* **cmd** / **rsv** / **atyp** — request fields when `n ≥ 4`, else `0`

Honesty:

* **Min greeting / request offsets only** — no METHODS body walk, no auth subnegotiation,
  no address/port product, no reply packing, not a SOCKS5 client/server.
* **validate status is length-class only** (`ok`/`err`); the first-byte probe never
  changes the status value (`land` with zero) but keeps `addr` on the EmitC result path
  when `n ≥ 2`. Version/`VER=5` legality is not enforced by validate.
* **loadAt dual-param honesty:** every load index is under `i < n` after fences.
  `loadAt` is **not** bounds-parameterized.

## Intentional TCB (Socks5-local)

Greeting/request minimum lengths and field offsets are freestanding `@[extern]`
axioms kept **here**. Name-pinned on ComplianceCorpus (`path name=Ident`). Byte
loads reuse `Scalars`/`Bytes`.
-/

namespace Systems.Socks5

open Systems.Scalars
open Systems.Bytes
open Systems.Status
open Systems.Numerics

/-- SOCKS5 greeting minimum length (VER + NMETHODS = 2). -/
@[extern c inline "((size_t)2)"] public axiom greetLen : USize
/-- SOCKS5 request minimum length (VER + CMD + RSV + ATYP = 4). -/
@[extern c inline "((size_t)4)"] public axiom reqLen : USize
/-- Offset of NMETHODS / CMD (1). -/
@[extern c inline "((size_t)1)"] public axiom off1 : USize
/-- Offset of RSV (2). -/
@[extern c inline "((size_t)2)"] public axiom off2 : USize
/-- Offset of ATYP (3). -/
@[extern c inline "((size_t)3)"] public axiom off3 : USize

/-- Load byte at index as `U32`. Caller ensures `i < n`. -/
public unsafe def loadAt (addr : USize) (i : USize) : U32 :=
  U32.ofU8 (U8.load (USize.add addr i))

/-- `0` if `n ≥ 2` (greeting min), else `1`.

When `n ≥ 2`, loads first byte and folds it with `U32.land _ U32.zero` so dual-param
`addr` stays on the EmitC result path. Status remains length-class only (probe never
contributes a nonzero bit). Does not require `VER == 5`. -/
public unsafe def validate (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n greetLen) err
    (U32.land (loadAt addr USize.zero) U32.zero)

/-- Alias of `validate`. -/
public unsafe def parse (addr : USize) (n : USize) : U32 :=
  validate addr n

/-- Greeting / request VER (byte0), or `0` if `n < 2`. -/
public unsafe def version (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n greetLen) U32.zero
    (loadAt addr USize.zero)

/-- Greeting NMETHODS (byte1), or `0` if `n < 2`. -/
public unsafe def nmethods (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n greetLen) U32.zero
    (loadAt addr off1)

/-- `0` if `n ≥ 4` (request min), else `1`.

When long enough, first-byte probe `land 0` keeps `addr` live; status is length-class. -/
public unsafe def reqValidate (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n reqLen) err
    (U32.land (loadAt addr USize.zero) U32.zero)

/-- Request CMD (byte1), or `0` if `n < 4`. -/
public unsafe def cmd (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n reqLen) U32.zero
    (loadAt addr off1)

/-- Request RSV (byte2), or `0` if `n < 4`. -/
public unsafe def rsv (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n reqLen) U32.zero
    (loadAt addr off2)

/-- Request ATYP (byte3), or `0` if `n < 4`. -/
public unsafe def atyp (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n reqLen) U32.zero
    (loadAt addr off3)

end Systems.Socks5
