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
# Systems.Cbor (Systems Lean)

CBOR-**shaped** major-type scan over dual caller `addr`/`len` byte views — not a full
RFC 8949 codec, not indefinite-length product, not nested value decode.

Initial byte layout (RFC 8949 §3):

| Bits | Field |
|------|-------|
| 7–5 | major type (`0..7`) |
| 4–0 | additional information (`0..31`) |

Ops:

* **validate** / **scan** — `0` if `n ≥ 1`, else `1` (empty); when long enough, probes
  the first byte and folds it with `land 0` so dual-param `addr` stays live
* **majorType** — major type at `off` as `USize` (`0..7`), or miss if `off ≥ n`
* **additionalInfo** — low 5 bits at `off` as `U32` (0 if `off ≥ n`)
* **uintSmall** — if the first byte is major type 0 with additional info `< 24`,
  return that small unsigned value as `USize`; else miss

Honesty:

* **Shaped first-byte scan only** — no multi-byte argument decode (24/25/26/27), no
  indefinite-length (`addi == 31`) product, no nested array/map walk, no tag graph,
  no float/simple decode beyond exposing major type 7.
* **validate status is length-class only** (`ok`/`err`); the first-byte probe never
  changes the status value (`land` with zero) but keeps `addr` on the EmitC result path
  when `n ≥ 1`.
* **loadAt dual-param honesty:** every load index is under `i < n` after length fences.
  `loadAt` is **not** bounds-parameterized.

## Intentional TCB (Cbor-local)

Major-type shift, additional-info mask, small-uint ceiling, and `USize.ofU32` are
freestanding `@[extern]` axioms kept **here**. Name-pinned on ComplianceCorpus
(`path name=Ident`). Byte loads reuse `Scalars`/`Bytes`; shift/and reuse `Numerics`.
-/

namespace Systems.Cbor

open Systems.Scalars
open Systems.Bytes
open Systems.Status
open Systems.Numerics

/-- Shift amount 5: major type = high 3 bits of initial byte. -/
@[extern c inline "((uint32_t)5)"] public axiom fiveU32 : U32
/-- Additional-information mask (`0x1F` = 31). -/
@[extern c inline "((uint32_t)31)"] public axiom maskAddi : U32
/-- Small unsigned ceiling: additional info values `0..23` are the value itself. -/
@[extern c inline "((uint32_t)24)"] public axiom smallCeil : U32
/-- Major type 0 (unsigned integer). -/
@[extern c inline "((uint32_t)0)"] public axiom majorUint : U32
/-- Widen `U32` → `USize`. -/
@[extern c inline "((size_t)(uint32_t)(#1))"]
public axiom USize.ofU32 : U32 → USize

/-- Load byte at index as `U32`. Caller ensures `i < n`. -/
public unsafe def loadAt (addr : USize) (i : USize) : U32 :=
  U32.ofU8 (U8.load (USize.add addr i))

/-- Major type of initial byte (`b >> 5`). -/
@[inline] public def majorOf (b : U32) : U32 :=
  U32.shiftRight b fiveU32

/-- Additional information of initial byte (`b & 0x1F`). -/
@[inline] public def addiOf (b : U32) : U32 :=
  U32.land b maskAddi

/-- `0` if `n ≥ 1`, else `1`.

When `n ≥ 1`, loads first byte and folds it with `U32.land _ U32.zero` so dual-param
`addr` stays on the EmitC result path. Status remains length-class only (probe never
contributes a nonzero bit). Does not decode multi-byte arguments or nested items. -/
public unsafe def validate (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq n USize.zero) err
    (U32.land (loadAt addr USize.zero) U32.zero)

/-- Alias of `validate`. -/
public unsafe def scan (addr : USize) (n : USize) : U32 :=
  validate addr n

/-- Major type at `off` as `USize` (`0..7`), or `USize.neg1` if `off ≥ n`. **LP64 miss**. -/
public unsafe def majorType (addr : USize) (n : USize) (off : USize) : USize :=
  bifUSize (USize.blt off n)
    (USize.ofU32 (majorOf (loadAt addr off)))
    USize.neg1

/-- Additional information (low 5 bits) at `off`, or `0` if `off ≥ n`. -/
public unsafe def additionalInfo (addr : USize) (n : USize) (off : USize) : U32 :=
  bifU32 (USize.blt off n) (addiOf (loadAt addr off)) U32.zero

/-- Small unsigned integer (major type 0, additional info `< 24`) at the first byte.

Returns the value as `USize`, or `USize.neg1` if empty / not type-0 small. **LP64 miss**. -/
public unsafe def uintSmall (addr : USize) (n : USize) : USize :=
  bifUSize (USize.beq n USize.zero) USize.neg1
    (let b := loadAt addr USize.zero
     let mt := majorOf b
     let ai := addiOf b
     bifUSize (U32.beq mt majorUint)
       (bifUSize (U32.blt ai smallCeil) (USize.ofU32 ai) USize.neg1)
       USize.neg1)

end Systems.Cbor
