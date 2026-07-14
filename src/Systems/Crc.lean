/-
Copyright (c) 2026 Lean FRO, LLC. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Hunter Beast
-/
module
prelude
public import Systems.Scalars
public import Systems.Numerics

/-!
# Systems.Crc (Systems Lean)

CRC-32-**shaped** checksum over dual `addr`/`len` byte ranges — **not** a crypto
library and not a streaming/incremental CRC API.

* IEEE / ISO HDLC reflected polynomial `0xEDB88320` (decimal `3988292384`)
* Init and final XOR with all-ones (`U32.neg1`)
* Bit-by-bit fold (no 256-entry table) for residual-free freestanding embeds

Companion to `Systems.Hash` (FNV-1a). Use for framing / integrity lite checks,
not authentication.

Decimal constants only in freestanding inlines (no `0x` hex idents).
-/

namespace Systems.Crc

open Systems.Scalars
open Systems.Numerics

/-- Reflected CRC-32 polynomial (`0xEDB88320`). -/
@[extern c inline "((uint32_t)3988292384u)"] public axiom polyRefl : U32

/-- Eight (bit steps per byte). -/
@[extern c inline "((uint32_t)8)"] public axiom k8 : U32

/-- One FNV-style bit of CRC: if LSB set, `(crc >> 1) ^ poly`, else `crc >> 1`. -/
public def stepBit (crc : U32) : U32 :=
  bifU32 (U32.beq (U32.land crc U32.one) U32.zero)
    (U32.shiftRight crc U32.one)
    (U32.xor (U32.shiftRight crc U32.one) polyRefl)

/-- Eight reflected bit steps for one input byte already mixed into `crc`. -/
public unsafe def stepBitsGo (crc : U32) (bitsLeft : U32) : U32 :=
  bifU32 (U32.beq bitsLeft U32.zero) crc
    (stepBitsGo (stepBit crc) (U32.sub bitsLeft U32.one))

/-- Mix one byte into a running reflected CRC-32 state (no final XOR). -/
public unsafe def stepByte (crc : U32) (b : U8) : U32 :=
  stepBitsGo (U32.xor crc (U32.ofU8 b)) k8

/-- Fold bytes `[addr, addr+n)` into running CRC state `crc` (self-TCO). -/
public unsafe def crc32Go (addr : USize) (i : USize) (n : USize) (crc : U32) : U32 :=
  bifU32 (USize.blt i n)
    (crc32Go addr (USize.add i USize.one) n
      (stepByte crc (U8.load (USize.add addr i))))
    crc

/-- CRC-32 of `n` bytes at `addr` (init/final all-ones). Empty range → `0`.

Not cryptographic. Not incremental API (pass whole range). Residual-free bit algorithm. -/
public unsafe def crc32 (addr : USize) (n : USize) : U32 :=
  U32.xor (crc32Go addr USize.zero n U32.neg1) U32.neg1

end Systems.Crc
