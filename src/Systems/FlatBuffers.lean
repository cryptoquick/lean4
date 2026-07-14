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
# Systems.FlatBuffers (Systems Lean)

FlatBuffers-**shaped** first-byte / root-table offset scan over dual caller `addr`/`len`
byte views — not a full FlatBuffers codec, not schema reflection, not object API.

Minimum file layout (FlatBuffers-shaped; **4** bytes for root `uoffset_t`):

| Offset | Size | Field |
|--------|------|-------|
| 0–3 | 4 | root table uoffset (LE `uoffset_t`) |
| root | 4 | root table soffset to vtable (LE `soffset_t`, raw U32-shaped) |

Ops:

* **validate** / **scan** — `0` if `n ≥ 4`, else `1` (too short); when long enough,
  probes first byte and folds it with `land 0` so dual-param `addr` is live
* **rootUOffset** — LE `U32` of the first 4 bytes, or `0` if short
* **rootInBounds** — `1` if `n ≥ 4` and `rootUOffset < n` (as `USize`), else `0`
* **vtableOffsetAt** — if `n ≥ 4` and `root + 4 ≤ n`, load soffset at `root` as raw
  LE `U32` widened to `USize`; else miss (`USize.neg1`)

Honesty:

* **Shaped root-offset / soffset scan only** — no vtable field decode, no nested
  table/string/vector product, no builder/encode, no schema reflection, not the
  FlatBuffers object API or verifier product.
* **validate status is length-class only** (`ok`/`err`); the first-byte probe never
  changes the status value (`land` with zero) but keeps `addr` on the EmitC result path
  when `n ≥ 4`.
* **loadAt dual-param honesty:** every load index is under `i < n` after the min-4
  fence (and root+4 fence for soffset). `loadAt` is **not** bounds-parameterized.
* **vtableOffsetAt** returns the raw LE bit pattern of `soffset_t` as `USize`; it does
  not interpret signed negative vtable distances.

## Intentional TCB (FlatBuffers-local)

Header minimum, LE shift amounts, byte offsets, and `USize.ofU32` are freestanding
`@[extern]` axioms kept **here**. Name-pinned on ComplianceCorpus (`path name=Ident`).
Byte loads reuse `Scalars`/`Bytes`; shift/or/and reuse `Numerics`.
-/

namespace Systems.FlatBuffers

open Systems.Scalars
open Systems.Bytes
open Systems.Status
open Systems.Numerics

/-- FlatBuffers root `uoffset_t` minimum length (4). -/
@[extern c inline "((size_t)4)"] public axiom headerMin : USize
/-- Shift amount 8 for little-endian byte packing. -/
@[extern c inline "((uint32_t)8)"] public axiom eightU32 : U32
/-- Shift amount 16 for little-endian mid bytes. -/
@[extern c inline "((uint32_t)16)"] public axiom sixteenU32 : U32
/-- Shift amount 24 for little-endian high byte. -/
@[extern c inline "((uint32_t)24)"] public axiom twentyFourU32 : U32
/-- Offset of second LE byte (1). -/
@[extern c inline "((size_t)1)"] public axiom off1 : USize
/-- Offset of third LE byte (2). -/
@[extern c inline "((size_t)2)"] public axiom off2 : USize
/-- Offset of fourth LE byte (3). -/
@[extern c inline "((size_t)3)"] public axiom off3 : USize
/-- Widen `U32` → `USize`. -/
@[extern c inline "((size_t)(uint32_t)(#1))"]
public axiom USize.ofU32 : U32 → USize

/-- Load byte at index as `U32`. Caller ensures `i < n`. -/
public unsafe def loadAt (addr : USize) (i : USize) : U32 :=
  U32.ofU8 (U8.load (USize.add addr i))

/-- Little-endian `U32` at four consecutive offsets. Caller ensures all indices in range. -/
public unsafe def loadU32LE (addr : USize) (b0 : USize) (b1 : USize) (b2 : USize)
    (b3 : USize) : U32 :=
  U32.lor (U32.lor (loadAt addr b0)
      (U32.shiftLeft (loadAt addr b1) eightU32))
    (U32.lor (U32.shiftLeft (loadAt addr b2) sixteenU32)
      (U32.shiftLeft (loadAt addr b3) twentyFourU32))

/-- `0` if `n ≥ 4`, else `1`.

When `n ≥ 4`, loads first byte and folds it with `U32.land _ U32.zero` so dual-param
`addr` stays on the EmitC result path. Status remains length-class only (probe never
contributes a nonzero bit). Does not decode root table or vtable bodies. -/
public unsafe def validate (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerMin) err
    (U32.land (loadAt addr USize.zero) U32.zero)

/-- Alias of `validate`. -/
public unsafe def scan (addr : USize) (n : USize) : U32 :=
  validate addr n

/-- Root table `uoffset_t` (first 4 LE bytes), or `0` if `n < 4`. -/
public unsafe def rootUOffset (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerMin) U32.zero
    (loadU32LE addr USize.zero off1 off2 off3)

/-- `1` if `n ≥ 4` and root uoffset is strictly inside the buffer (`root < n`), else `0`. -/
public unsafe def rootInBounds (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerMin) U32.zero
    (bifU32 (USize.blt (USize.ofU32 (loadU32LE addr USize.zero off1 off2 off3)) n)
      U32.one U32.zero)

/-- Root-table soffset raw bits as `USize`, or miss.

Requires `n ≥ 4` and `root + 4 ≤ n` so four bytes at the root table are in range.
Returns the LE bit pattern of `soffset_t` widened via `USize.ofU32` (**not** signed
magnitude). **LP64 miss** (`USize.neg1`) when fences fail. -/
public unsafe def vtableOffsetAt (addr : USize) (n : USize) : USize :=
  bifUSize (USize.blt n headerMin) USize.neg1
    (let root := USize.ofU32 (loadU32LE addr USize.zero off1 off2 off3)
     bifUSize (USize.blt n (USize.add root headerMin)) USize.neg1
       (USize.ofU32 (loadU32LE addr root (USize.add root off1) (USize.add root off2)
         (USize.add root off3))))

end Systems.FlatBuffers
