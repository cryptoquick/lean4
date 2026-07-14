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
# Systems.Hash (Systems Lean)

Lightweight non-cryptographic hashes for freestanding embeds (checksums, hash-lite tables).

* FNV-1a 32-bit over dual `addr`/`len`
* `U32` mix / finalizer helpers

Not a crypto library. No managed strings — byte ranges only.
Freestanding inline patterns use **decimal** constants only (no `0x` hex — identifier scan).
-/

namespace Systems.Hash

open Systems.Scalars
open Systems.Numerics

/-- FNV offset basis (`2166136261`). -/
@[extern c inline "((uint32_t)2166136261u)"] public axiom fnvOffsetBasis : U32

/-- FNV prime (`16777619`). -/
@[extern c inline "((uint32_t)16777619u)"] public axiom fnvPrime : U32

/-- Shift constants for finalizer. -/
@[extern c inline "((uint32_t)16)"] public axiom k16 : U32
@[extern c inline "((uint32_t)13)"] public axiom k13 : U32
/-- `0x85ebca6b` as decimal (freestanding forbid hex idents in inline patterns). -/
@[extern c inline "((uint32_t)2246822519u)"] public axiom mixC1 : U32
/-- `0xc2b2ae35` as decimal. -/
@[extern c inline "((uint32_t)3266489910u)"] public axiom mixC2 : U32

/-- One FNV-1a step: `(hash ^ byte) * prime`. -/
public def fnv1aStep (h : U32) (b : U8) : U32 :=
  U32.mul (U32.xor h (U32.ofU8 b)) fnvPrime

/-- FNV-1a over `[addr, addr+n)` with running index `i` and accumulator `h`. -/
public unsafe def fnv1aGo (addr : USize) (i : USize) (n : USize) (h : U32) : U32 :=
  bifU32 (USize.blt i n)
    (fnv1aGo addr (USize.add i USize.one) n (fnv1aStep h (U8.load (USize.add addr i))))
    h

/-- FNV-1a 32-bit hash of `n` bytes at `addr`. -/
public unsafe def fnv1a (addr : USize) (n : USize) : U32 :=
  fnv1aGo addr USize.zero n fnvOffsetBasis

/-- Murmur-inspired finalizer on a `U32` word (not crypto). -/
public def finalizeU32 (x : U32) : U32 :=
  let x := U32.xor x (U32.shiftRight x k16)
  let x := U32.mul x mixC1
  let x := U32.xor x (U32.shiftRight x k13)
  let x := U32.mul x mixC2
  U32.xor x (U32.shiftRight x k16)

/-- Hash a byte range then finalize. -/
public unsafe def hashBytes (addr : USize) (n : USize) : U32 :=
  finalizeU32 (fnv1a addr n)

end Systems.Hash
