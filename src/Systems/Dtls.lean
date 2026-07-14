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
# Systems.Dtls (Systems Lean)

DTLS-**shaped** min-13 record header parse over dual caller `addr`/`len` byte
views — not a full DTLS stack, not handshake/crypto product, not TLS 1.x record
product, not SRTP/RTP media.

Wire layout (RFC 6347-shaped; minimum **13** header bytes, network byte order):

| Offset | Size | Field |
|--------|------|-------|
| 0 | 1 | content type |
| 1–2 | 2 | version (BE; e.g. DTLS 1.2 = `0xFEFD`) |
| 3–4 | 2 | epoch (BE) |
| 5–10 | 6 | sequence number (BE; this port exposes high 4 + low 2) |
| 11–12 | 2 | length (BE) |

**Distinct from `Tls`:** TLS is min-**5** content type / version / length only
(`lean_fs_tls_*`) — no epoch or sequence on the record header skeleton. DTLS is
min-**13** with epoch + 48-bit sequence between version and length.

**Distinct from `Rtp` / `Srtp` / `Srtcp`:** RTP/SRTP are min-12
media headers (`lean_fs_rtp_*` / `lean_fs_srtp_*`); SRTCP is min-4 control
(`lean_fs_srtcp_*`). DTLS adds epoch + 48-bit sequence on a TLS-family content
type/version/length skeleton. **Not full DTLS handshake/crypto** (no
ClientHello walk, no AEAD, no cookie, no flight reassembly).

Ops:

* **validate** / **parse** — `0` if `n ≥ 13`, else `1` (too short); when long enough,
  probes first byte and folds it with `land 0` so dual-param `addr` is live
* **contentType** — byte0 as `U32`, or `0` if short
* **version** — big-endian `U16` at offsets 1–2 as `U32`, or `0` if short
* **epoch** — big-endian `U16` at offsets 3–4 as `U32`, or `0` if short
* **seqHi** — big-endian `U32` at offsets 5–8 (high 32 of 48-bit seq), or `0` if short
* **seqLo** — big-endian `U16` at offsets 9–10 (low 16 of 48-bit seq), or `0` if short
* **length** — big-endian `U16` at offsets 11–12 as `U32`, or `0` if short

Honesty:

* **Min-13 DTLS record header offsets only** — no handshake message parse, no
  fragment reassembly, **not full DTLS crypto**. Distinct from `Tls` min-5 peer,
  RTP/SRTP min-12, and SRTCP min-4 peers.
* **validate status is length-class only** (`ok`/`err`); the first-byte probe never
  changes the status value (`land` with zero) but keeps `addr` on the EmitC result path
  when `n ≥ 13`. Content-type/version legality is not enforced.
* **loadAt dual-param honesty:** every load index is under `i < n` after the min-13
  fence. `loadAt` is **not** bounds-parameterized.

## Intentional TCB (Dtls-local)

Header length, BE shift amount, and field offsets are freestanding `@[extern]`
axioms kept **here**. Name-pinned on ComplianceCorpus (`path name=Ident`).
Byte loads reuse `Scalars`/`Bytes`; shift/or reuse `Numerics`.
-/

namespace Systems.Dtls

open Systems.Scalars
open Systems.Bytes
open Systems.Status
open Systems.Numerics

/-- DTLS record header minimum length (13). -/
@[extern c inline "((size_t)13)"] public axiom headerLen : USize
/-- Shift amount 8 for big-endian packing. -/
@[extern c inline "((uint32_t)8)"] public axiom eightU32 : U32
/-- Shift amount 16 for mid bytes. -/
@[extern c inline "((uint32_t)16)"] public axiom sixteenU32 : U32
/-- Shift amount 24 for high byte. -/
@[extern c inline "((uint32_t)24)"] public axiom twentyFourU32 : U32
/-- Offset of version high byte (1). -/
@[extern c inline "((size_t)1)"] public axiom offVer : USize
/-- Offset of version low byte (2). -/
@[extern c inline "((size_t)2)"] public axiom offVerLo : USize
/-- Offset of epoch high byte (3). -/
@[extern c inline "((size_t)3)"] public axiom offEpoch : USize
/-- Offset of epoch low byte (4). -/
@[extern c inline "((size_t)4)"] public axiom offEpochLo : USize
/-- Offset of sequence high dword byte0 (5). -/
@[extern c inline "((size_t)5)"] public axiom offSeq0 : USize
/-- Offset of sequence high dword byte1 (6). -/
@[extern c inline "((size_t)6)"] public axiom offSeq1 : USize
/-- Offset of sequence high dword byte2 (7). -/
@[extern c inline "((size_t)7)"] public axiom offSeq2 : USize
/-- Offset of sequence high dword byte3 (8). -/
@[extern c inline "((size_t)8)"] public axiom offSeq3 : USize
/-- Offset of sequence low high byte (9). -/
@[extern c inline "((size_t)9)"] public axiom offSeqLo : USize
/-- Offset of sequence low low byte (10). -/
@[extern c inline "((size_t)10)"] public axiom offSeqLo2 : USize
/-- Offset of length high byte (11). -/
@[extern c inline "((size_t)11)"] public axiom offLen : USize
/-- Offset of length low byte (12). -/
@[extern c inline "((size_t)12)"] public axiom offLenLo : USize

/-- Load byte at index as `U32`. Caller ensures `i < n`. -/
public unsafe def loadAt (addr : USize) (i : USize) : U32 :=
  U32.ofU8 (U8.load (USize.add addr i))

/-- Big-endian `U16` at `hiOff`/`loOff` as `U32`. Caller ensures both indices in range. -/
public unsafe def loadU16BE (addr : USize) (hiOff : USize) (loOff : USize) : U32 :=
  U32.lor (U32.shiftLeft (loadAt addr hiOff) eightU32) (loadAt addr loOff)

/-- Big-endian `U32` at four explicit offsets. Caller ensures all indices in range. -/
public unsafe def loadU32BE (addr : USize) (b0 : USize) (b1 : USize) (b2 : USize)
    (b3 : USize) : U32 :=
  U32.lor (U32.lor (U32.shiftLeft (loadAt addr b0) twentyFourU32)
      (U32.shiftLeft (loadAt addr b1) sixteenU32))
    (U32.lor (U32.shiftLeft (loadAt addr b2) eightU32)
      (loadAt addr b3))

/-- `0` if `n ≥ 13`, else `1`.

When `n ≥ 13`, loads first byte and folds it with `U32.land _ U32.zero` so dual-param
`addr` stays on the EmitC result path. Status remains length-class only (probe never
contributes a nonzero bit). Does not inspect body past the min fence. Not full DTLS
handshake/crypto. -/
public unsafe def validate (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) err
    (U32.land (loadAt addr USize.zero) U32.zero)

/-- Alias of `validate`. -/
public unsafe def parse (addr : USize) (n : USize) : U32 :=
  validate addr n

/-- Content type (byte0), or `0` if `n < 13`. -/
public unsafe def contentType (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (loadAt addr USize.zero)

/-- Version (bytes 1–2 BE) as `U32`, or `0` if `n < 13`.

DTLS 1.0 = `0xFEFF`, DTLS 1.2 = `0xFEFD` shaped; legality not enforced. -/
public unsafe def version (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (loadU16BE addr offVer offVerLo)

/-- Epoch (bytes 3–4 BE) as `U32`, or `0` if `n < 13`. -/
public unsafe def epoch (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (loadU16BE addr offEpoch offEpochLo)

/-- Sequence high 32 bits (bytes 5–8 BE), or `0` if `n < 13`.

High half of the RFC 6347 48-bit sequence number. -/
public unsafe def seqHi (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (loadU32BE addr offSeq0 offSeq1 offSeq2 offSeq3)

/-- Sequence low 16 bits (bytes 9–10 BE), or `0` if `n < 13`.

Low half of the RFC 6347 48-bit sequence number. -/
public unsafe def seqLo (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (loadU16BE addr offSeqLo offSeqLo2)

/-- Length (bytes 11–12 BE) as `U32`, or `0` if `n < 13`.

Fragment length in bytes; not payload walk product. -/
public unsafe def length (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (loadU16BE addr offLen offLenLo)

end Systems.Dtls
