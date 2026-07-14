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
# Systems.Sua (Systems Lean)

SUA-**shaped** minimum common header parse over dual caller `addr`/`len` byte views —
not a full SS7/SIGTRAN stack, not SCCP User Adaptation state product, not payload walk.
Distinct from `M3ua` (M3UA MTP3 User Adaptation): this is SCCP User Adaptation
common-header layout only (RFC 3868-shaped version/reserved/class/type/length).

Wire layout (RFC 3868-shaped; minimum **8** common-header bytes, network byte order):

| Offset | Size | Field |
|--------|------|-------|
| 0 | 1 | Version |
| 1 | 1 | Reserved |
| 2 | 1 | Message Class |
| 3 | 1 | Message Type |
| 4–7 | 4 | Message Length (BE) |

Ops:

* **validate** / **parse** — `0` if `n ≥ 8`, else `1` (too short); when long enough,
  probes first byte and folds it with `land 0` so dual-param `addr` is live
* **version** / **reserved** / **msgClass** / **msgType** — single-byte fields (`0` if short)
* **length** — big-endian `U32` message length at offset 4 (`0` if short)
* **fieldBeAt** — BE `U32` at `off` as `USize` when `off + 4 ≤ n`, else miss

Honesty:

* **Min-8 common header fields only** — no parameter TLVs, no routing key, no
  ASP/AS state machine, not an SUA client/server, not SCCP user data product.
* **validate status is length-class only** (`ok`/`err`); the first-byte probe never
  changes the status value (`land` with zero) but keeps `addr` on the EmitC result path
  when `n ≥ 8`. Version/class/type legality is **not** enforced by validate.
* **loadAt dual-param honesty:** every load index is under `i < n` after the min-8
  fence. `loadAt` is **not** bounds-parameterized.

## Intentional TCB (Sua-local)

Header size, field offsets, big-endian shift amounts, and `USize.ofU32` are
freestanding `@[extern]` axioms kept **here**. Name-pinned on ComplianceCorpus
(`path name=Ident`). Byte loads reuse `Scalars`/`Bytes`; shift/or reuse `Numerics`.
-/

namespace Systems.Sua

open Systems.Scalars
open Systems.Bytes
open Systems.Status
open Systems.Numerics

/-- Minimum SUA common header length (8). -/
@[extern c inline "((size_t)8)"] public axiom headerLen : USize
/-- Shift amount 8 for big-endian byte packing. -/
@[extern c inline "((uint32_t)8)"] public axiom eightU32 : U32
/-- Shift amount 16 for big-endian `U32` mid bytes. -/
@[extern c inline "((uint32_t)16)"] public axiom sixteenU32 : U32
/-- Shift amount 24 for big-endian `U32` high byte. -/
@[extern c inline "((uint32_t)24)"] public axiom twentyFourU32 : U32
/-- Offset of Version (0). -/
@[extern c inline "((size_t)0)"] public axiom offVer : USize
/-- Offset of Reserved (1). -/
@[extern c inline "((size_t)1)"] public axiom offRes : USize
/-- Offset of Message Class (2). -/
@[extern c inline "((size_t)2)"] public axiom offClass : USize
/-- Offset of Message Type (3). -/
@[extern c inline "((size_t)3)"] public axiom offType : USize
/-- Offset of Message Length high byte (4). -/
@[extern c inline "((size_t)4)"] public axiom offLen0 : USize
/-- Offset of Message Length byte 1 (5). -/
@[extern c inline "((size_t)5)"] public axiom offLen1 : USize
/-- Offset of Message Length byte 2 (6). -/
@[extern c inline "((size_t)6)"] public axiom offLen2 : USize
/-- Offset of Message Length low byte (7). -/
@[extern c inline "((size_t)7)"] public axiom offLen3 : USize
/-- Four as `USize` (BE field width for fieldBeAt). -/
@[extern c inline "((size_t)4)"] public axiom fourUSize : USize
/-- Widen `U32` → `USize`. -/
@[extern c inline "((size_t)(uint32_t)(#1))"]
public axiom USize.ofU32 : U32 → USize

/-- Load byte at index as `U32`. Caller ensures `i < n`. -/
public unsafe def loadAt (addr : USize) (i : USize) : U32 :=
  U32.ofU8 (U8.load (USize.add addr i))

/-- Big-endian `U32` at four consecutive offsets. Caller ensures all indices in range. -/
public unsafe def loadU32BE (addr : USize) (b0 : USize) (b1 : USize) (b2 : USize)
    (b3 : USize) : U32 :=
  U32.lor (U32.lor (U32.shiftLeft (loadAt addr b0) twentyFourU32)
      (U32.shiftLeft (loadAt addr b1) sixteenU32))
    (U32.lor (U32.shiftLeft (loadAt addr b2) eightU32) (loadAt addr b3))

/-- `0` if `n ≥ 8`, else `1`.

When `n ≥ 8`, loads first byte and folds it with `U32.land _ U32.zero` so dual-param
`addr` stays on the EmitC result path. Status remains length-class only (probe never
contributes a nonzero bit). Does not inspect parameters past the min-length fence. -/
public unsafe def validate (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) err
    (U32.land (loadAt addr USize.zero) U32.zero)

/-- Alias of `validate`. -/
public unsafe def parse (addr : USize) (n : USize) : U32 :=
  validate addr n

/-- Version (byte 0), or `0` if `n < 8`. -/
public unsafe def version (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (loadAt addr offVer)

/-- Reserved (byte 1), or `0` if `n < 8`. -/
public unsafe def reserved (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (loadAt addr offRes)

/-- Message Class (byte 2), or `0` if `n < 8`. -/
public unsafe def msgClass (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (loadAt addr offClass)

/-- Message Type (byte 3), or `0` if `n < 8`. -/
public unsafe def msgType (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (loadAt addr offType)

/-- Message Length (bytes 4–7 BE), or `0` if `n < 8`. Layout only. -/
public unsafe def length (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (loadU32BE addr offLen0 offLen1 offLen2 offLen3)

/-- BE field `U32` at `off` as `USize` when `off + 4 ≤ n`, else miss (**LP64**).

Shaped for raw BE dwords in/after the SUA common header. -/
public unsafe def fieldBeAt (addr : USize) (n : USize) (off : USize) : USize :=
  bifUSize (USize.blt n (USize.add off fourUSize)) USize.neg1
    (USize.ofU32 (loadU32BE addr off (USize.add off offRes) (USize.add off offClass)
      (USize.add off offType)))

end Systems.Sua
