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
# Systems.Diameter (Systems Lean)

Diameter-**shaped** minimum header parse over dual caller `addr`/`len` byte views —
not a full Diameter stack, not AVP walk, not CER/CEA session product.

Wire layout (RFC 6733-shaped; minimum **20** header bytes, network byte order):

| Offset | Size | Field |
|--------|------|-------|
| 0 | 1 | Version |
| 1–3 | 3 | Message Length (24-bit BE) |
| 4 | 1 | Command Flags |
| 5–7 | 3 | Command-Code (24-bit BE) |
| 8–11 | 4 | Application-ID (BE) |
| 12–15 | 4 | Hop-by-Hop Identifier (BE; when read) |
| 16–19 | 4 | End-to-End Identifier (BE; when read) |

Ops:

* **validate** / **parse** — `0` if `n ≥ 20`, else `1` (too short); when long enough,
  probes first byte and folds it with `land 0` so dual-param `addr` is live
* **version** / **flags** — single-byte fields (`0` if short)
* **length** — 24-bit BE message length as `U32` (`0` if short)
* **commandCode** — 24-bit BE command code as `U32` (`0` if short)
* **appId** — Application-ID BE `U32` → `USize`, or miss if short
* **isRequest** — `1` if R flag (`0x80`) set when long enough, else `0`

Honesty:

* **Min-20 header fields only** — no AVP Type/Length/Value walk, no security AVPs,
  not a Diameter client/server.
* **validate status is length-class only** (`ok`/`err`); the first-byte probe never
  changes the status value (`land` with zero) but keeps `addr` on the EmitC result path
  when `n ≥ 20`. Version/flags/code legality is **not** enforced by validate.
* **loadAt dual-param honesty:** every load index is under `i < n` after the min-20
  fence. `loadAt` is **not** bounds-parameterized.

## Intentional TCB (Diameter-local)

Header size, flag mask, BE shift amounts, field offsets, and `USize.ofU32`
are freestanding `@[extern]` axioms kept **here**. Name-pinned on ComplianceCorpus
(`path name=Ident`). Byte loads reuse `Scalars`/`Bytes`; shift/or reuse `Numerics`.
-/

namespace Systems.Diameter

open Systems.Scalars
open Systems.Bytes
open Systems.Status
open Systems.Numerics

/-- Minimum Diameter header length (20). -/
@[extern c inline "((size_t)20)"] public axiom headerLen : USize
/-- Request (R) command flag mask (`0x80` = 128). -/
@[extern c inline "((uint32_t)128)"] public axiom flagRequest : U32
/-- Shift amount 8 for BE packing. -/
@[extern c inline "((uint32_t)8)"] public axiom eightU32 : U32
/-- Shift amount 16 for mid/high of 24-bit fields. -/
@[extern c inline "((uint32_t)16)"] public axiom sixteenU32 : U32
/-- Shift amount 24 for high byte of 32-bit BE. -/
@[extern c inline "((uint32_t)24)"] public axiom twentyFourU32 : U32
/-- Offset of Message Length high byte (1). -/
@[extern c inline "((size_t)1)"] public axiom offLen0 : USize
/-- Offset of Message Length mid byte (2). -/
@[extern c inline "((size_t)2)"] public axiom offLen1 : USize
/-- Offset of Message Length low byte (3). -/
@[extern c inline "((size_t)3)"] public axiom offLen2 : USize
/-- Offset of Command Flags (4). -/
@[extern c inline "((size_t)4)"] public axiom offFlags : USize
/-- Offset of Command-Code high byte (5). -/
@[extern c inline "((size_t)5)"] public axiom offCmd0 : USize
/-- Offset of Command-Code mid byte (6). -/
@[extern c inline "((size_t)6)"] public axiom offCmd1 : USize
/-- Offset of Command-Code low byte (7). -/
@[extern c inline "((size_t)7)"] public axiom offCmd2 : USize
/-- Offset of Application-ID byte0 (8). -/
@[extern c inline "((size_t)8)"] public axiom offApp0 : USize
/-- Offset of Application-ID byte1 (9). -/
@[extern c inline "((size_t)9)"] public axiom offApp1 : USize
/-- Offset of Application-ID byte2 (10). -/
@[extern c inline "((size_t)10)"] public axiom offApp2 : USize
/-- Offset of Application-ID byte3 (11). -/
@[extern c inline "((size_t)11)"] public axiom offApp3 : USize
/-- Widen `U32` → `USize`. -/
@[extern c inline "((size_t)(uint32_t)(#1))"]
public axiom USize.ofU32 : U32 → USize

/-- Load byte at index as `U32`. Caller ensures `i < n`. -/
public unsafe def loadAt (addr : USize) (i : USize) : U32 :=
  U32.ofU8 (U8.load (USize.add addr i))

/-- Big-endian 24-bit value at three explicit offsets as `U32`. Caller ensures in range. -/
public unsafe def loadU24BE (addr : USize) (b0 : USize) (b1 : USize) (b2 : USize) : U32 :=
  U32.lor (U32.lor (U32.shiftLeft (loadAt addr b0) sixteenU32)
      (U32.shiftLeft (loadAt addr b1) eightU32))
    (loadAt addr b2)

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
contributes a nonzero bit). Does not require Version/Flags/Code match. -/
public unsafe def validate (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) err
    (U32.land (loadAt addr USize.zero) U32.zero)

/-- Alias of `validate`. -/
public unsafe def parse (addr : USize) (n : USize) : U32 :=
  validate addr n

/-- Version byte, or `0` if `n < 20`. -/
public unsafe def version (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (loadAt addr USize.zero)

/-- Message Length (bytes 1–3 BE 24-bit) as `U32`, or `0` if `n < 20`. -/
public unsafe def length (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (loadU24BE addr offLen0 offLen1 offLen2)

/-- Command Flags byte, or `0` if `n < 20`. -/
public unsafe def flags (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (loadAt addr offFlags)

/-- Command-Code (bytes 5–7 BE 24-bit) as `U32`, or `0` if `n < 20`. -/
public unsafe def commandCode (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (loadU24BE addr offCmd0 offCmd1 offCmd2)

/-- Application-ID (bytes 8–11 BE) as `USize`, or miss if short. **LP64**. -/
public unsafe def appId (addr : USize) (n : USize) : USize :=
  bifUSize (USize.blt n headerLen) USize.neg1
    (USize.ofU32 (loadU32BE addr offApp0 offApp1 offApp2 offApp3))

/-- `1` if R (Request) flag is set when `n ≥ 20`, else `0`. -/
public unsafe def isRequest (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (bifU32 (U32.beq (U32.land (flags addr n) flagRequest) flagRequest) U32.one U32.zero)

end Systems.Diameter
