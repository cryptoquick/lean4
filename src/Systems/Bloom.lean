/-
Copyright (c) 2026 Lean FRO, LLC. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Hunter Beast
-/
module
prelude
public import Systems.Scalars
public import Systems.Bytes
public import Systems.Numerics
public import Systems.Hash
public import Systems.Status

/-!
# Systems.Bloom (Systems Lean)

Fixed-capacity **Bloom filter** over a caller-owned array of `U64` words — bloom-**shaped**,
not a crypto hash filter, not a general probabilistic database, not malloc-backed.

Layout (caller-owned):

* `words` — `nWords` host-endian `U64` slots (`nWords * 8` bytes), **8-byte aligned**
* bit capacity `nBits = nWords * 64` (requires `nWords > 0` for add/query)

Ops (k = 2 independent bit positions from non-crypto hashes):

* **nBits** — `nWords * 64`
* **clear** — zero all words (store status dataflow-used)
* **addU32** / **mayContainU32** — insert / query a `U32` key (via `finalizeU32`)
* **addBytes** / **mayContainBytes** — insert / query a byte span (`hashBytes` + mix)

Honesty:

* **Caller buffer only** — never malloc/free; does not own `words`.
* **Not cryptographic** — uses `Systems.Hash` FNV-1a / Murmur-ish finalizer; not a MAC,
  not collision-resistant, not suitable for adversarial filtering.
* False positives are expected; false negatives for keys that were successfully added
  should not occur when the same `nWords` buffer is reused without clear.
* Not claimed: optimal k/m sizing, deletion, counting bloom, or concurrent updates.
* Store status is dataflow-used so EmitC cannot DCE word writes (`never_extract`).

## Intentional TCB (Bloom-local)

`U64.load`/`store`, `USize` arithmetic, and small width constants are freestanding
`@[extern]` axioms kept **here**. Name-pinned on ComplianceCorpus (`path name=Ident`).
-/

namespace Systems.Bloom

open Systems.Scalars
open Systems.Bytes
open Systems.Numerics
open Systems.Hash
open Systems.Status

/-- Host-endian `uint64_t` load (`addr` must be 8-byte aligned). -/
@[extern c inline "(*((const uint64_t*)(#1)))"]
public axiom U64.load : USize → U64

/-- Host-endian `uint64_t` store; returns `0` (`addr` must be aligned). -/
@[never_extract, extern c inline "(*((uint64_t*)(#1)) = (uint64_t)(#2), (uint32_t)0)"]
public axiom U64.store : USize → U64 → U32

/-- Widen `U32` → `USize`. -/
@[extern c inline "((size_t)(uint32_t)(#1))"]
public axiom USize.ofU32 : U32 → USize

/-- Widen `USize` → `U64` (bit index in word is small). -/
@[extern c inline "((uint64_t)(size_t)(#1))"]
public axiom U64.ofUSize : USize → U64

/-- Unsigned modulo (`a % b`). Caller must keep `b ≠ 0`. -/
@[extern c inline "((size_t)((size_t)(#1) % (size_t)(#2)))"]
public axiom USize.mod : USize → USize → USize

/-- Unsigned divide. -/
@[extern c inline "((size_t)((size_t)(#1) / (size_t)(#2)))"]
public axiom USize.div : USize → USize → USize

/-- Unsigned multiply. -/
@[extern c inline "((size_t)((size_t)(#1) * (size_t)(#2)))"]
public axiom USize.mul : USize → USize → USize

/-- Sixty-four as `USize` (bits per word). -/
@[extern c inline "((size_t)64)"] public axiom sixtyFourUSize : USize

/-- Second-hash mix constant (`0x9e3779b9` golden ratio as decimal). -/
@[extern c inline "((uint32_t)2654435769u)"] public axiom mixGolden : U32

/-- Address of `U64` slot `i` in a contiguous word array at `base` (8-byte aligned). -/
@[inline] public def u64Slot (base : USize) (i : USize) : USize :=
  USize.add base (USize.mul i USize.eight)

/-- Bit capacity: `nWords * 64`. -/
public unsafe def nBits (nWords : USize) : USize :=
  USize.mul nWords sixtyFourUSize

/-- Clear word `i` and continue. Store status dataflow-used. -/
public unsafe def clearGo (words : USize) (nWords : USize) (i : USize) : U32 :=
  bifU32 (USize.blt i nWords)
    (let st := U64.store (u64Slot words i) U64.zero
     bifU32 (isOk st) (clearGo words nWords (USize.add i USize.one)) st)
    ok

/-- Zero all `nWords` filter words. `0` ok. -/
public unsafe def clear (words : USize) (nWords : USize) : U32 :=
  clearGo words nWords USize.zero

/-- Primary hash position: `h % nBits` as `USize` (`nBits ≠ 0`). -/
public unsafe def pos1 (h : U32) (nBits : USize) : USize :=
  USize.mod (USize.ofU32 h) nBits

/-- Secondary hash: `finalizeU32 (h xor mixGolden) % nBits`. -/
public unsafe def pos2 (h : U32) (nBits : USize) : USize :=
  USize.mod (USize.ofU32 (finalizeU32 (U32.xor h mixGolden))) nBits

/-- Set bit at absolute index `bit` (`bit < nBits`). Store status dataflow-used. -/
public unsafe def setBit (words : USize) (bit : USize) : U32 :=
  let wIdx := USize.div bit sixtyFourUSize
  let bInW := USize.mod bit sixtyFourUSize
  let slot := u64Slot words wIdx
  let old := U64.load slot
  let neu := U64.lor old (U64.shiftLeft U64.one (U64.ofUSize bInW))
  let st := U64.store slot neu
  bifU32 (isOk st) ok st

/-- `1` if bit at `bit` is set, else `0`. -/
public unsafe def testBit (words : USize) (bit : USize) : U32 :=
  let wIdx := USize.div bit sixtyFourUSize
  let bInW := USize.mod bit sixtyFourUSize
  let w := U64.load (u64Slot words wIdx)
  bifU32 (U64.beq (U64.land w (U64.shiftLeft U64.one (U64.ofUSize bInW))) U64.zero)
    U32.zero U32.one

/-- Insert key hash `h` into the filter. `0` ok, `3` if `nWords == 0`. -/
public unsafe def addHash (words : USize) (nWords : USize) (h : U32) : U32 :=
  bifU32 (USize.beq nWords USize.zero) errBounds
    (let nb := nBits nWords
     let st1 := setBit words (pos1 h nb)
     bifU32 (isOk st1) (setBit words (pos2 h nb)) st1)

/-- `1` if filter may contain hash `h`, `0` if definitely not; `3` if empty filter. -/
public unsafe def mayContainHash (words : USize) (nWords : USize) (h : U32) : U32 :=
  bifU32 (USize.beq nWords USize.zero) errBounds
    (let nb := nBits nWords
     bifU32 (U32.beq (testBit words (pos1 h nb)) U32.one)
       (bifU32 (U32.beq (testBit words (pos2 h nb)) U32.one) U32.one U32.zero)
       U32.zero)

/-- Insert `U32` key (non-crypto finalize). `0` ok, `3` if `nWords == 0`. -/
public unsafe def addU32 (words : USize) (nWords : USize) (key : U32) : U32 :=
  addHash words nWords (finalizeU32 key)

/-- Query `U32` key: `1` maybe, `0` no, `3` empty filter. -/
public unsafe def mayContainU32 (words : USize) (nWords : USize) (key : U32) : U32 :=
  mayContainHash words nWords (finalizeU32 key)

/-- Insert bytes at `addr`/`len`. `0` ok, `3` if `nWords == 0`. -/
public unsafe def addBytes (words : USize) (nWords : USize) (addr : USize) (len : USize) : U32 :=
  addHash words nWords (hashBytes addr len)

/-- Query bytes: `1` maybe, `0` no, `3` empty filter. -/
public unsafe def mayContainBytes (words : USize) (nWords : USize)
    (addr : USize) (len : USize) : U32 :=
  mayContainHash words nWords (hashBytes addr len)

end Systems.Bloom
