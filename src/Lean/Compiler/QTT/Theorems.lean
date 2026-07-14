/-
Copyright (c) 2026 Lean FRO, LLC. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Hunter Beast
-/
module

prelude
public import Lean.Compiler.Multiplicity

/-!
# QTT formal layer re-exports

Definitional mult-algebra / free-safety theorems live in `Multiplicity.Theorems` (same module
as the algebra, so private `rfl` lemmas see function bodies without `@[expose]`).

This module **only re-exports public Bool markers** for `import Lean.Compiler.QTT.Theorems` /
proof-receipt elab tests. It does **not** restate algebra lemmas, does **not** re-prove them
with cross-module `rfl` (unavailable on unexposed bodies), and does **not** claim residual_nm /
residual_ir product freedom (those are separate `systems-validate` gates).

Strata (honest):
* `algebraChecked` — pure Mult tables / assoc / distrib / le / annihilate / enc-dec
* `freeSafetyChecked` — Mult free-safety policy (linear exact-once, mult-0, ω)
* `productResidualMultPolicyChecked` — greppable free-safety mult package marker (same Mult
  policy story; name is historical/greppable, not residual_nm)
* Host joint package: `Lean.Compiler.QTT.FreeSafety.freeSafetyFormalLayerChecked`
-/

namespace Lean.Compiler.QTT.Theorems

/--
Proof-receipt tag: mult algebra is definitionally checked in `Multiplicity.lean`.
Alias of `Multiplicity.Theorems.algebraChecked` (not a free `true`; not free-safety).
-/
public def multAlgebraChecked : Bool := Multiplicity.Theorems.algebraChecked

/-- Re-export: pure Mult algebra marker (`Multiplicity.Theorems.algebraChecked`). -/
public def algebraChecked : Bool := Multiplicity.Theorems.algebraChecked

/--
Re-export: free-safety Mult policy marker (`Multiplicity.Theorems.freeSafetyChecked`).
Host-facing joint package: `Lean.Compiler.QTT.FreeSafety`. Not residual_nm/ir.
-/
public def freeSafetyChecked : Bool := Multiplicity.Theorems.freeSafetyChecked

/--
Re-export: free-safety mult package marker
(`Multiplicity.Theorems.productResidualMultPolicyChecked`). Mult policy only —
emission residual_nm / residual_ir are separate product gates.
-/
public def productResidualMultPolicyChecked : Bool :=
  Multiplicity.Theorems.productResidualMultPolicyChecked

end Lean.Compiler.QTT.Theorems
