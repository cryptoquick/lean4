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
# Systems.SctpCommon (Systems Lean)

SCTP **common-header-shaped** field parse over dual caller `addr`/`len` byte views —
distinct module from `Sctp` with the same RFC 4960 common-header layout honesty.
Not a full SCTP stack, not sockets, not chunk product, not checksum verify/compute.

Wire layout (RFC 4960-shaped; minimum **12** common-header bytes, network byte order):

| Offset | Size | Field |
|--------|------|-------|
| 0 | 2 | source port (BE) |
| 2 | 2 | destination port (BE) |
| 4 | 4 | verification tag (BE) |
| 8 | 4 | checksum (BE; layout only — CRC32c not verified) |

Ops:

* **validate** / **parse** — `0` if `n ≥ 12`, else `1` (too short); when long enough,
  probes first byte and folds it with `land 0` so dual-param `addr` is live
* **srcPort** — big-endian `U16` at offset 0 as `U32` (0 if short)
* **dstPort** — big-endian `U16` at offset 2 as `U32` (0 if short)
* **vtag** — big-endian `U32` verification tag at offset 4 (0 if short)
* **checksum** — big-endian `U32` at offset 8 (0 if short)
* **fieldBeAt** — BE `U32` at `off` as `USize` when `off + 4 ≤ n`, else miss

Honesty:

* **Common header offsets only** — no DATA/INIT/SACK/… chunk product, no association
  state machine, no socket API, no CRC32c algorithm / verification, no multi-homing.
* **validate status is length-class only** (`ok`/`err`); the first-byte probe never
  changes the status value (`land` with zero) but keeps `addr` on the EmitC result path
  when `n ≥ 12`.
* **loadAt dual-param honesty:** every load index is under `i < n` after the min-12
  fence. `loadAt` is **not** bounds-parameterized.
* **Distinct from `Sctp`:** same wire layout honesty, separate freestanding TU and
  export surface (`lean_fs_sctpcommon_*`).

## Intentional TCB (SctpCommon-local)

Header size, field offsets, big-endian shift amounts, and `USize.ofU32` are
freestanding `@[extern]` axioms kept **here**. Name-pinned on ComplianceCorpus
(`path name=Ident`). Byte loads reuse `Scalars`/`Bytes`; shift/or reuse `Numerics`.
-/

namespace Systems.SctpCommon

open Systems.Scalars
open Systems.Bytes
open Systems.Status
open Systems.Numerics

/-- Minimum SCTP common header length (12). -/
@[extern c inline "((size_t)12)"] public axiom headerLen : USize
/-- Shift amount 8 for big-endian byte packing. -/
@[extern c inline "((uint32_t)8)"] public axiom eightU32 : U32
/-- Shift amount 16 for big-endian `U32` mid bytes. -/
@[extern c inline "((uint32_t)16)"] public axiom sixteenU32 : U32
/-- Shift amount 24 for big-endian `U32` high byte. -/
@[extern c inline "((uint32_t)24)"] public axiom twentyFourU32 : U32
/-- Offset of source-port high byte (0). -/
@[extern c inline "((size_t)0)"] public axiom offSrc : USize
/-- Offset of source-port low byte (1). -/
@[extern c inline "((size_t)1)"] public axiom offSrcLo : USize
/-- Offset of dest-port high byte (2). -/
@[extern c inline "((size_t)2)"] public axiom offDst : USize
/-- Offset of dest-port low byte (3). -/
@[extern c inline "((size_t)3)"] public axiom offDstLo : USize
/-- Offset of verification-tag high byte (4). -/
@[extern c inline "((size_t)4)"] public axiom offVtag : USize
/-- Offset of verification-tag byte 1 (5). -/
@[extern c inline "((size_t)5)"] public axiom offVtag1 : USize
/-- Offset of verification-tag byte 2 (6). -/
@[extern c inline "((size_t)6)"] public axiom offVtag2 : USize
/-- Offset of verification-tag low byte (7). -/
@[extern c inline "((size_t)7)"] public axiom offVtag3 : USize
/-- Offset of checksum high byte (8). -/
@[extern c inline "((size_t)8)"] public axiom offCsum : USize
/-- Offset of checksum byte 1 (9). -/
@[extern c inline "((size_t)9)"] public axiom offCsum1 : USize
/-- Offset of checksum byte 2 (10). -/
@[extern c inline "((size_t)10)"] public axiom offCsum2 : USize
/-- Offset of checksum low byte (11). -/
@[extern c inline "((size_t)11)"] public axiom offCsum3 : USize
/-- Four as `USize` (BE field width for fieldBeAt). -/
@[extern c inline "((size_t)4)"] public axiom fourUSize : USize
/-- Widen `U32` → `USize`. -/
@[extern c inline "((size_t)(uint32_t)(#1))"]
public axiom USize.ofU32 : U32 → USize

/-- Load byte at index as `U32`. Caller ensures `i < n`. -/
public unsafe def loadAt (addr : USize) (i : USize) : U32 :=
  U32.ofU8 (U8.load (USize.add addr i))

/-- Big-endian `U16` at `hiOff`/`loOff` as `U32`. Caller ensures both indices in range. -/
public unsafe def loadU16BE (addr : USize) (hiOff : USize) (loOff : USize) : U32 :=
  U32.lor (U32.shiftLeft (loadAt addr hiOff) eightU32) (loadAt addr loOff)

/-- Big-endian `U32` at four consecutive offsets. Caller ensures all indices in range. -/
public unsafe def loadU32BE (addr : USize) (b0 : USize) (b1 : USize) (b2 : USize)
    (b3 : USize) : U32 :=
  U32.lor (U32.lor (U32.shiftLeft (loadAt addr b0) twentyFourU32)
      (U32.shiftLeft (loadAt addr b1) sixteenU32))
    (U32.lor (U32.shiftLeft (loadAt addr b2) eightU32) (loadAt addr b3))

/-- `0` if `n ≥ 12`, else `1`.

When `n ≥ 12`, loads first byte and folds it with `U32.land _ U32.zero` so dual-param
`addr` stays on the EmitC result path. Status remains length-class only (probe never
contributes a nonzero bit). Does not inspect chunks past the min-length fence. -/
public unsafe def validate (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) err
    (U32.land (loadAt addr USize.zero) U32.zero)

/-- Alias of `validate`. -/
public unsafe def parse (addr : USize) (n : USize) : U32 :=
  validate addr n

/-- Source port (bytes 0–1 BE), or `0` if `n < 12`. -/
public unsafe def srcPort (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (loadU16BE addr offSrc offSrcLo)

/-- Destination port (bytes 2–3 BE), or `0` if `n < 12`. -/
public unsafe def dstPort (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (loadU16BE addr offDst offDstLo)

/-- Verification tag (bytes 4–7 BE), or `0` if `n < 12`. -/
public unsafe def vtag (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (loadU32BE addr offVtag offVtag1 offVtag2 offVtag3)

/-- Checksum field (bytes 8–11 BE), or `0` if `n < 12`. Layout only — not verified. -/
public unsafe def checksum (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n headerLen) U32.zero
    (loadU32BE addr offCsum offCsum1 offCsum2 offCsum3)

/-- BE field `U32` at `off` as `USize` when `off + 4 ≤ n`, else miss (**LP64**).

Shaped for raw BE dwords in/after the SCTP common header. -/
public unsafe def fieldBeAt (addr : USize) (n : USize) (off : USize) : USize :=
  bifUSize (USize.blt n (USize.add off fourUSize)) USize.neg1
    (USize.ofU32 (loadU32BE addr off (USize.add off offSrcLo) (USize.add off offDst)
      (USize.add off offDstLo)))

end Systems.SctpCommon
