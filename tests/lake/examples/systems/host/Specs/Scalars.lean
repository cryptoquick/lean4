module

public import Systems.Scalars

/-!
# Specs.Scalars — freestanding ↔ host scalar bridge 

Freestanding `U64` / `U32` are **parallel** axiom types (not host `UInt64` / `UInt32`).
This module axiomatizes a semantic bridge to host fixed-width integers and proves
properties of freestanding arithmetic **modulo that bridge** (honest axioms + real
host proofs). Nothing here is compiled with `compiler.freestanding`.

Intentional coupling: this is the only host Specs module that imports freestanding
oleans. Pure models (`Specs.Checksum`, `Specs.Log`) stay freestanding-API-stable.
-/

namespace Specs.Scalars

-- Selective open only: avoid bringing freestanding `Bool` (and other names) into host scope
-- alongside Init (bare `Bool` would silently bind the freestanding type).
open Systems.Scalars (U32 U64 U32.add U32.mul U32.k31 U64.add U64.mul)

/-! ## Axiomatic bridges (semantic model of freestanding scalars)

These axioms state that freestanding scalars behave like host modular integers under
C-style arithmetic — the **intended host model** of the freestanding
`@[extern c inline "#1 + #2"]` (etc.) ops. They are **not** definitional equalities and
not a machine-checked refinement of the C emission (K24 / no C semantics).
-/

/-- Interpret freestanding `U64` as host `UInt64`. -/
public axiom u64ToHost : U64 → UInt64
/-- Reify host `UInt64` as freestanding `U64`. -/
public axiom hostToU64 : UInt64 → U64

public axiom u64_to_from (x : U64) : hostToU64 (u64ToHost x) = x
public axiom u64_from_to (n : UInt64) : u64ToHost (hostToU64 n) = n

/-- Freestanding `U64.add` agrees with host modular addition under the bridge. -/
public axiom u64_add_bridge (x y : U64) :
  u64ToHost (U64.add x y) = u64ToHost x + u64ToHost y

public axiom u64_mul_bridge (x y : U64) :
  u64ToHost (U64.mul x y) = u64ToHost x * u64ToHost y

/-- Interpret freestanding `U32` as host `UInt32`. -/
public axiom u32ToHost : U32 → UInt32
public axiom hostToU32 : UInt32 → U32

public axiom u32_to_from (x : U32) : hostToU32 (u32ToHost x) = x
public axiom u32_from_to (n : UInt32) : u32ToHost (hostToU32 n) = n

public axiom u32_add_bridge (x y : U32) :
  u32ToHost (U32.add x y) = u32ToHost x + u32ToHost y

public axiom u32_mul_bridge (x y : U32) :
  u32ToHost (U32.mul x y) = u32ToHost x * u32ToHost y

public axiom u32_k31_bridge : u32ToHost U32.k31 = 31

/-! ## Proved transport (host lemmas + bridge axioms) -/

/-- Freestanding `U64.add` is commutative under the host interpretation. -/
public theorem u64_add_comm (x y : U64) :
    u64ToHost (U64.add x y) = u64ToHost (U64.add y x) := by
  rw [u64_add_bridge, u64_add_bridge, UInt64.add_comm]

/-- Freestanding `U64.mul` is commutative under the host interpretation. -/
public theorem u64_mul_comm (x y : U64) :
    u64ToHost (U64.mul x y) = u64ToHost (U64.mul y x) := by
  rw [u64_mul_bridge, u64_mul_bridge, UInt64.mul_comm]

/-- Left inverse of the `U64` bridge is injective. -/
public theorem u64ToHost_injective {x y : U64} (h : u64ToHost x = u64ToHost y) : x = y := by
  have := congrArg hostToU64 h
  simpa [u64_to_from] using this

/-- Host round-trip: transport of host addition into freestanding and back. -/
public theorem host_add_roundtrip (a b : UInt64) :
    u64ToHost (U64.add (hostToU64 a) (hostToU64 b)) = a + b := by
  rw [u64_add_bridge, u64_from_to, u64_from_to]

/-- One-step polynomial update on freestanding `U32` (`acc * k31 + byte`).

Host pure fold over `List UInt8` lives in freestanding-free `Specs.Checksum`; this only
relates freestanding scalar ops under the bridge. -/
@[expose] public def checksumStep (acc : U32) (byte : U32) : U32 :=
  U32.add (U32.mul acc U32.k31) byte

/-- Under the bridge, freestanding `checksumStep` is host modular `acc * 31 + byte`. -/
public theorem checksumStep_bridge (acc byte : U32) :
    u32ToHost (checksumStep acc byte) =
      u32ToHost acc * 31 + u32ToHost byte := by
  simp only [checksumStep]
  rw [u32_add_bridge, u32_mul_bridge, u32_k31_bridge]

end Specs.Scalars
