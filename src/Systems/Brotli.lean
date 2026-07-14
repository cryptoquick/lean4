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
# Systems.Brotli (Systems Lean)

Brotli-**shaped** stream / window-bits header scan over dual caller `addr`/`len`
byte views — not a full Brotli codec, not meta-block decompress, not Huffman
table or distance product.

Stream prefix (RFC 7932-shaped; LSB-first WBITS in the first byte; minimum **1**
byte; second byte is meta-block prefix when present):

| Offset | Size | Field |
|--------|------|-------|
| 0 | 1 | WBITS encoding (LSB-first; simple 1-byte forms) |
| 1 | 1 | first meta-block prefix byte (when `n ≥ 2` shaped) |

Simple WBITS forms encoded entirely in byte0 (LSB first):

* bit0 `0` → window bits `16`
* bit0 `1` and bits1–3 = `nnn` ∈ 1..7 → window bits `17 + nnn` (18..24)

The large-window `1`+`000`+extra form is treated as **not** simple magic (no WBITS=17 in the simple 1-byte set).

Ops:

* **validate** / **scan** — `0` if `n ≥ 1`, else `1` (too short); when long enough,
  probes first byte and folds it with `land 0` so dual-param `addr` is live
* **hasMagic** — `1` if byte0 encodes a simple WBITS form, else `0` (or short)
* **windowBits** — decoded WBITS when simple form, else `0`
* **metaPrefix** — byte at offset 1 when `n ≥ 2`, else `0`

Honesty:

* **Window-bits / first meta-prefix only** — no meta-block walk, no Huffman decode,
  no distance rings, not the Brotli stream codec product.
* **validate status is length-class only** (`ok`/`err`); the first-byte probe never
  changes the status value (`land` with zero) but keeps `addr` on the EmitC result path
  when `n ≥ 1`. Simple WBITS magic is **not** required by validate.
* **loadAt dual-param honesty:** every load index is under `i < n` after fences.
  `loadAt` is **not** bounds-parameterized.

## Intentional TCB (Brotli-local)

Min lengths, WBITS masks/shifts, base constants, and field offsets are freestanding
`@[extern]` axioms kept **here**. Name-pinned on ComplianceCorpus (`path name=Ident`).
Byte loads reuse `Scalars`/`Bytes`; shift/and reuse `Numerics`.
-/

namespace Systems.Brotli

open Systems.Scalars
open Systems.Bytes
open Systems.Status
open Systems.Numerics

/-- Stream header minimum length (1). -/
@[extern c inline "((size_t)1)"] public axiom headerLen : USize
/-- Length needed for meta-block prefix at offset 1 (`2` shaped). -/
@[extern c inline "((size_t)2)"] public axiom metaLen : USize
/-- LSB mask for first WBITS bit (`0x01` = 1). -/
@[extern c inline "((uint32_t)1)"] public axiom maskLsb : U32
/-- Mask for bits1–3 of first byte (`0x0E` = 14). -/
@[extern c inline "((uint32_t)14)"] public axiom maskWnnn : U32
/-- Shift amount 1 for nnn field. -/
@[extern c inline "((uint32_t)1)"] public axiom oneU32 : U32
/-- Window bits when first bit is 0 (`16`). -/
@[extern c inline "((uint32_t)16)"] public axiom wbits16 : U32
/-- Base for simple `1nnn` form (`17`). -/
@[extern c inline "((uint32_t)17)"] public axiom wbits17 : U32
/-- Offset of meta-block prefix byte (1). -/
@[extern c inline "((size_t)1)"] public axiom offMeta : USize

/-- Load byte at index as `U32`. Caller ensures `i < n`. -/
public unsafe def loadAt (addr : USize) (i : USize) : U32 :=
  U32.ofU8 (U8.load (USize.add addr i))

/-- `0` if `n ≥ 1`, else `1`.

When `n ≥ 1`, loads first byte and folds it with `U32.land _ U32.zero` so dual-param
`addr` stays on the EmitC result path. Status remains length-class only (probe never
contributes a nonzero bit). Does not require simple WBITS magic. -/
public unsafe def validate (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) err
    (U32.land (loadAt addr USize.zero) U32.zero)

/-- Alias of `validate`. -/
public unsafe def scan (addr : USize) (n : USize) : U32 :=
  validate addr n

/-- `1` if byte0 is a simple 1-byte WBITS encoding, else `0` (or short).

Simple forms: LSB `0` (WBITS=16), or LSB `1` with bits1–3 = `nnn` ∈ 1..7
(WBITS=`17+nnn` → 18..24). The large-window `1`+`000` form returns `0` (no WBITS=17
in the simple 1-byte set). -/
public unsafe def hasMagic (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (let b := loadAt addr USize.zero
     bifU32 (U32.beq (U32.land b maskLsb) U32.zero) U32.one
       (bifU32 (U32.beq (U32.land b maskWnnn) U32.zero) U32.zero U32.one))

/-- Decoded window bits for simple forms, else `0` (or short / large-window). -/
public unsafe def windowBits (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (let b := loadAt addr USize.zero
     bifU32 (U32.beq (U32.land b maskLsb) U32.zero) wbits16
       (let nnn := U32.shiftRight (U32.land b maskWnnn) oneU32
        bifU32 (U32.beq nnn U32.zero) U32.zero
          (U32.add wbits17 nnn)))

/-- Meta-block prefix byte at offset 1 when `n ≥ 2`, else `0`. -/
public unsafe def metaPrefix (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n metaLen) U32.zero
    (loadAt addr offMeta)

end Systems.Brotli
