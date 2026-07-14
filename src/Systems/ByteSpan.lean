/-
Copyright (c) 2026 Lean FRO, LLC. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Hunter Beast
-/
module
prelude
public import Systems.Scalars
public import Systems.Bytes
public import Systems.Hash
public import Systems.Status

/-!
# Systems.ByteSpan (Systems Lean)

ByteArray-**shaped** dual `addr`/`len` helpers — **not** managed `ByteArray` / RC arrays.

Beyond `Bytes`/`Mem` bulk ops: bounds-gated `getU8`/`setU8`, memcmp-like `eq`,
prefix equality, FNV-1a `hash32` (reuses `Systems.Hash`), and **subspan** views
(`subspanOk` / `subspanAddr` / `subspanLen`) over dual `addr`/`len` (no product return).

No `Init`. No multi-field freestanding products. Decimal only in freestanding inlines.
-/

namespace Systems.ByteSpan

open Systems.Scalars
open Systems.Bytes
open Systems.Hash
open Systems.Status

/-- Bounds-safe load: if `i < n`, return the byte as `USize` (`0..255`); else `USize.neg1`. -/
public unsafe def getU8 (addr : USize) (n : USize) (i : USize) : USize :=
  bifUSize (USize.blt i n)
    (USize.ofU8 (U8.load (USize.add addr i)))
    USize.neg1

/-- Bounds-safe store: if `i < n`, write `v` and return `ok` (`0`); else `errBounds` (`3`). -/
public unsafe def setU8 (addr : USize) (n : USize) (i : USize) (v : U8) : U32 :=
  bifU32 (USize.blt i n)
    (U8.store (USize.add addr i) v)
    errBounds

/-- Equality scan over `[0, n)` starting at index `i` (self-TCO).

Returns `0` if all remaining bytes match, `1` if any differ. -/
public unsafe def eqGo (a : USize) (b : USize) (i : USize) (n : USize) : U32 :=
  bifU32 (USize.blt i n)
    (bifU32 (U8.beq (U8.load (USize.add a i)) (U8.load (USize.add b i)))
      (eqGo a b (USize.add i USize.one) n)
      U32.one)
    U32.zero

/-- Full-range equality: `0` equal, `1` differ (memcmp-like equality, not ordering). -/
public unsafe def eq (a : USize) (b : USize) (n : USize) : U32 :=
  eqGo a b USize.zero n

/-- Prefix equality of length `k`: both ranges must have `k ≤` length (`na`/`nb`).

Returns `0` if the first `k` bytes match, `1` if any differ or `k` exceeds either length. -/
public unsafe def prefixEq (a : USize) (na : USize) (b : USize) (nb : USize) (k : USize) : U32 :=
  bifU32 (USize.blt na k) U32.one
    (bifU32 (USize.blt nb k) U32.one (eqGo a b USize.zero k))

/-- FNV-1a 32-bit hash of `n` bytes at `addr` (delegates to `Hash.fnv1a`). -/
public unsafe def hash32 (addr : USize) (n : USize) : U32 :=
  fnv1a addr n

/-- FNV-1a then murmur-style finalizer (`Hash.hashBytes`). -/
public unsafe def hash32Finalize (addr : USize) (n : USize) : U32 :=
  hashBytes addr n

/-! ## Subspan (slice-of-span; dual pure `USize` returns + status)

A subspan of `[addr, addr+n)` at offset `off` with length `len` is well-formed when
`off ≤ n` and `len ≤ n - off` (unsigned; no `off + len` wrap). Status is separate from
addr/len so freestanding EmitC never needs multi-field product returns.
-/

/-- Bounds check for a subspan: `0` ok, `3` (`errBounds`) if out of range. -/
public unsafe def subspanOk (n : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.blt n off) errBounds
    (bifU32 (USize.blt (USize.sub n off) len) errBounds ok)

/-- Subspan base address: `addr + off` when in bounds, else `USize.neg1`.

Does **not** claim pointer provenance beyond the caller's dual `addr`/`len` contract.
Overflow of `addr + off` on adversarial huge inputs is not a product harness claim. -/
public unsafe def subspanAddr (addr : USize) (n : USize) (off : USize) (len : USize) : USize :=
  bifUSize (isOk (subspanOk n off len))
    (USize.add addr off)
    USize.neg1

/-- Subspan length: `len` when in bounds, else `0` (pair with `subspanOk` / `subspanAddr`). -/
public unsafe def subspanLen (n : USize) (off : USize) (len : USize) : USize :=
  bifUSize (isOk (subspanOk n off len)) len USize.zero

end Systems.ByteSpan
