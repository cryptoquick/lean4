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
# Systems.String (Systems Lean)

Byte-string **view** over dual caller `addr`/`len` (`U8` bytes) — freestanding byte-string
view helpers, not Init/`Std` managed `String` / `ByteArray` / RC text.

Ops:

* **len** / **isEmpty** — pass-through occupancy of dual `n`
* **getU8** — bounds-gated byte load (`USize.neg1` miss; LP64 harness)
* **eq** / **prefixEq** — memcmp-like equality (not ordering / collation)
* **viewOk** / **viewAddr** / **viewLen** — subview (slice) of dual `addr`/`len`
* **hash32** — FNV-1a over the view (reuses `Systems.Hash`)

No malloc. No freestanding multi-field product returns.

C ABI keeps the historical short prefix `lean_fs_str_*` (not `lean_fs_string_*`).

## Honesty / non-claims

* **Bytes only** — not Init/`Std` `String`, not UTF-8 decode/validate, not grapheme/locale.
  Callers may treat contents as ASCII when they choose; this module does not check.
* **Not claimed:** mutability helpers beyond dual-param views, owned string builders,
  C-string NUL scan as primary API, or full text processing.
-/

namespace Systems.String

open Systems.Scalars
open Systems.Bytes
open Systems.Hash
open Systems.Status

/-- Current length (pass-through of caller-owned `n`). -/
@[inline] public def len (n : USize) : USize := n

/-- `1` if `n == 0`, else `0`. -/
@[inline] public def isEmpty (n : USize) : U32 :=
  bifU32 (USize.beq n USize.zero) U32.one U32.zero

/-- Bounds-safe load: if `i < n`, return the byte as `USize` (`0..255`); else `USize.neg1`.

**LP64 only** for the miss sentinel (Map `get` class). -/
public unsafe def getU8 (addr : USize) (n : USize) (i : USize) : USize :=
  bifUSize (USize.blt i n)
    (USize.ofU8 (U8.load (USize.add addr i)))
    USize.neg1

/-- Equality scan over `[0, n)` starting at index `i` (self-TCO).

Returns `0` if all remaining bytes match, `1` if any differ. -/
public unsafe def eqGo (a : USize) (b : USize) (i : USize) (n : USize) : U32 :=
  bifU32 (USize.blt i n)
    (bifU32 (U8.beq (U8.load (USize.add a i)) (U8.load (USize.add b i)))
      (eqGo a b (USize.add i USize.one) n)
      U32.one)
    U32.zero

/-- Full-range equality: `0` equal, `1` differ (memcmp-like, not ordering). -/
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

/-! ## Subview (slice-of-view; dual pure `USize` returns + status)

A subview of `[addr, addr+n)` at offset `off` with length `len` is well-formed when
`off ≤ n` and `len ≤ n - off` (unsigned; no `off + len` wrap). Status is separate from
addr/len so freestanding EmitC never needs multi-field product returns.
-/

/-- Bounds check for a subview: `0` ok, `3` (`errBounds`) if out of range. -/
public unsafe def viewOk (n : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.blt n off) errBounds
    (bifU32 (USize.blt (USize.sub n off) len) errBounds ok)

/-- Subview base address: `addr + off` when in bounds, else `USize.neg1`.

Does **not** claim pointer provenance beyond the caller's dual `addr`/`len` contract.
Overflow of `addr + off` on adversarial huge inputs is not a product harness claim. -/
public unsafe def viewAddr (addr : USize) (n : USize) (off : USize) (len : USize) : USize :=
  bifUSize (isOk (viewOk n off len))
    (USize.add addr off)
    USize.neg1

/-- Subview length: `len` when in bounds, else `0` (pair with `viewOk` / `viewAddr`). -/
public unsafe def viewLen (n : USize) (off : USize) (len : USize) : USize :=
  bifUSize (isOk (viewOk n off len)) len USize.zero

end Systems.String
