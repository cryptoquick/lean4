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
# Systems.Tls (Systems Lean)

TLS-**shaped** min-5 record header parse over dual caller `addr`/`len` byte
views — not a full TLS stack, not handshake/crypto product, not DTLS record
product, not SRTP/RTP media.

Wire layout (RFC 5246 / TLS 1.2-shaped; minimum **5** header bytes, network
byte order):

| Offset | Size | Field |
|--------|------|-------|
| 0 | 1 | content type |
| 1–2 | 2 | version (BE; e.g. TLS 1.2 = `0x0303`) |
| 3–4 | 2 | length (BE) |

**Distinct from `Dtls`:** DTLS is min-**13** with epoch + 48-bit sequence
between version and length (`lean_fs_dtls_*`). TLS has no epoch/seq on the
record header skeleton — content type / version / length only. **Not full TLS
handshake/crypto** (no ClientHello walk, no AEAD, no certificate, no alert
body walk).

Ops:

* **validate** / **parse** — `0` if `n ≥ 5`, else `1` (too short); when long enough,
  probes first byte and folds it with `land 0` so dual-param `addr` is live
* **contentType** — byte0 as `U32`, or `0` if short
* **version** — big-endian `U16` at offsets 1–2 as `U32`, or `0` if short
* **length** — big-endian `U16` at offsets 3–4 as `U32`, or `0` if short

Honesty:

* **Min-5 TLS record header offsets only** — no handshake message parse, no
  record body walk, **not full TLS crypto**. Distinct from DTLS min-13 peer.
* **validate status is length-class only** (`ok`/`err`); the first-byte probe never
  changes the status value (`land` with zero) but keeps `addr` on the EmitC result path
  when `n ≥ 5`. Content-type/version legality is not enforced.
* **loadAt dual-param honesty:** every load index is under `i < n` after the min-5
  fence. `loadAt` is **not** bounds-parameterized.

## Intentional TCB (Tls-local)

Header length, BE shift amount, and field offsets are freestanding `@[extern]`
axioms kept **here**. Name-pinned on ComplianceCorpus (`path name=Ident`).
Byte loads reuse `Scalars`/`Bytes`; shift/or reuse `Numerics`.
-/

namespace Systems.Tls

open Systems.Scalars
open Systems.Bytes
open Systems.Status
open Systems.Numerics

/-- TLS record header minimum length (5). -/
@[extern c inline "((size_t)5)"] public axiom headerLen : USize
/-- Shift amount 8 for big-endian packing. -/
@[extern c inline "((uint32_t)8)"] public axiom eightU32 : U32
/-- Offset of version high byte (1). -/
@[extern c inline "((size_t)1)"] public axiom offVer : USize
/-- Offset of version low byte (2). -/
@[extern c inline "((size_t)2)"] public axiom offVerLo : USize
/-- Offset of length high byte (3). -/
@[extern c inline "((size_t)3)"] public axiom offLen : USize
/-- Offset of length low byte (4). -/
@[extern c inline "((size_t)4)"] public axiom offLenLo : USize

/-- Load byte at index as `U32`. Caller ensures `i < n`. -/
public unsafe def loadAt (addr : USize) (i : USize) : U32 :=
  U32.ofU8 (U8.load (USize.add addr i))

/-- Big-endian `U16` at `hiOff`/`loOff` as `U32`. Caller ensures both indices in range. -/
public unsafe def loadU16BE (addr : USize) (hiOff : USize) (loOff : USize) : U32 :=
  U32.lor (U32.shiftLeft (loadAt addr hiOff) eightU32) (loadAt addr loOff)

/-- `0` if `n ≥ 5`, else `1`.

When `n ≥ 5`, loads first byte and folds it with `U32.land _ U32.zero` so dual-param
`addr` stays on the EmitC result path. Status remains length-class only (probe never
contributes a nonzero bit). Does not inspect body past the min fence. Not full TLS
handshake/crypto. -/
public unsafe def validate (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) err
    (U32.land (loadAt addr USize.zero) U32.zero)

/-- Alias of `validate`. -/
public unsafe def parse (addr : USize) (n : USize) : U32 :=
  validate addr n

/-- Content type (byte0), or `0` if `n < 5`. -/
public unsafe def contentType (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (loadAt addr USize.zero)

/-- Version (bytes 1–2 BE) as `U32`, or `0` if `n < 5`.

TLS 1.0 = `0x0301`, TLS 1.2 = `0x0303` shaped; legality not enforced. -/
public unsafe def version (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (loadU16BE addr offVer offVerLo)

/-- Length (bytes 3–4 BE) as `U32`, or `0` if `n < 5`.

Fragment length in bytes; not payload walk product. -/
public unsafe def length (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (loadU16BE addr offLen offLenLo)

end Systems.Tls
