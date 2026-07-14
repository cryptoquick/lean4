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
# Systems.Capnp (Systems Lean)

Cap'n Proto-**shaped** first-word pointer family scan over dual caller `addr`/`len`
byte views — not a full Cap'n Proto codec, not message/segment product, not schema
or capability runtime.

Pointer layout (Cap'n Proto-shaped; one little-endian **64-bit** word minimum). Low 2
bits of the first word are the pointer type:

| Type | Meaning (shaped) |
|------|------------------|
| 0 | struct pointer |
| 1 | list pointer |
| 2 | far pointer |
| 3 | other / capability |

Ops:

* **validate** / **scan** — `0` if `n ≥ 8` (one word), else `1` (too short); when long
  enough, probes first byte and folds it with `land 0` so dual-param `addr` is live
* **ptrType** — low 2 bits of the first byte (LE LSB) as `U32` (`0..3`), or `0` if short
* **isStruct** / **isList** / **isFar** — `1`/`0` helpers from `ptrType` (0 if short)
* **word0Lo** — first 4 LE bytes as `U32` (host-independent pack via shifts), or `0` if short
* **offsetWordsSmall** — for struct pointer type `0`, bits `[2..31]` of the first word
  half as `(loadU32LE >> 2)` as `USize`; else miss (`USize.neg1`)

Honesty:

* **Shaped first-word pointer scan only** — no full 64-bit second-half decode (data /
  pointer counts, list element size, far landing pad), no multi-segment / far chase,
  no schema graph, no capability table, no encode/decode of message bodies, not the
  Cap'n Proto RPC or packing product.
* **validate status is length-class only** (`ok`/`err`); the first-byte probe never
  changes the status value (`land` with zero) but keeps `addr` on the EmitC result path
  when `n ≥ 8`.
* **loadAt dual-param honesty:** every load index is under `i < n` after the min-8
  fence. `loadAt` is **not** bounds-parameterized.
* **offsetWordsSmall** returns an unsigned-shaped magnitude of bits `[2..31]`; it does
  not interpret two's-complement negative offsets.

## Intentional TCB (Capnp-local)

Word length, pointer-type mask, LE shift amounts, and `USize.ofU32` are freestanding
`@[extern]` axioms kept **here**. Name-pinned on ComplianceCorpus (`path name=Ident`).
Byte loads reuse `Scalars`/`Bytes`; shift/or/and reuse `Numerics`.
-/

namespace Systems.Capnp

open Systems.Scalars
open Systems.Bytes
open Systems.Status
open Systems.Numerics

/-- Cap'n Proto pointer word length (8). -/
@[extern c inline "((size_t)8)"] public axiom wordLen : USize
/-- Pointer-type mask (`0x03` = 3). -/
@[extern c inline "((uint32_t)3)"] public axiom maskPtrType : U32
/-- Shift amount 2 for struct offset words (`bits[2..31]`). -/
@[extern c inline "((uint32_t)2)"] public axiom twoU32 : U32
/-- Shift amount 8 for little-endian byte packing. -/
@[extern c inline "((uint32_t)8)"] public axiom eightU32 : U32
/-- Shift amount 16 for little-endian mid bytes. -/
@[extern c inline "((uint32_t)16)"] public axiom sixteenU32 : U32
/-- Shift amount 24 for little-endian high byte. -/
@[extern c inline "((uint32_t)24)"] public axiom twentyFourU32 : U32
/-- Offset of second LE byte of the first word half (1). -/
@[extern c inline "((size_t)1)"] public axiom off1 : USize
/-- Offset of third LE byte of the first word half (2). -/
@[extern c inline "((size_t)2)"] public axiom off2 : USize
/-- Offset of fourth LE byte of the first word half (3). -/
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

/-- Pointer type of the first byte (`b & 0x03`). -/
@[inline] public def typeOf (b : U32) : U32 :=
  U32.land b maskPtrType

/-- `0` if `n ≥ 8`, else `1`.

When `n ≥ 8`, loads first byte and folds it with `U32.land _ U32.zero` so dual-param
`addr` stays on the EmitC result path. Status remains length-class only (probe never
contributes a nonzero bit). Does not decode the second word half or far landings. -/
public unsafe def validate (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n wordLen) err
    (U32.land (loadAt addr USize.zero) U32.zero)

/-- Alias of `validate`. -/
public unsafe def scan (addr : USize) (n : USize) : U32 :=
  validate addr n

/-- Pointer type (low 2 bits of first byte), or `0` if `n < 8`. -/
public unsafe def ptrType (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n wordLen) U32.zero
    (typeOf (loadAt addr USize.zero))

/-- `1` if pointer type is struct (`0`) and `n ≥ 8`, else `0`. -/
public unsafe def isStruct (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n wordLen) U32.zero
    (bifU32 (U32.beq (typeOf (loadAt addr USize.zero)) U32.zero) U32.one U32.zero)

/-- `1` if pointer type is list (`1`) and `n ≥ 8`, else `0`. -/
public unsafe def isList (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n wordLen) U32.zero
    (bifU32 (U32.beq (typeOf (loadAt addr USize.zero)) U32.one) U32.one U32.zero)

/-- `1` if pointer type is far (`2`) and `n ≥ 8`, else `0`. -/
public unsafe def isFar (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n wordLen) U32.zero
    (bifU32 (U32.beq (typeOf (loadAt addr USize.zero)) U32.two) U32.one U32.zero)

/-- First 4 LE bytes of the pointer word as `U32`, or `0` if `n < 8`. -/
public unsafe def word0Lo (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n wordLen) U32.zero
    (loadU32LE addr USize.zero off1 off2 off3)

/-- Struct offset-in-words shaped decode: `(word0Lo >> 2)` as `USize`.

Returns the value when `n ≥ 8` and pointer type is struct (`0`); else `USize.neg1`.
**LP64 miss**. Does not interpret signed negative offsets. -/
public unsafe def offsetWordsSmall (addr : USize) (n : USize) : USize :=
  bifUSize (USize.blt n wordLen) USize.neg1
    (bifUSize (U32.beq (typeOf (loadAt addr USize.zero)) U32.zero)
      (USize.ofU32 (U32.shiftRight (loadU32LE addr USize.zero off1 off2 off3) twoU32))
      USize.neg1)

end Systems.Capnp
