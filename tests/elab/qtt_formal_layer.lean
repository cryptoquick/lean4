module
public meta import Lean.Compiler.Multiplicity
public meta import Lean.Compiler.QTT.Theorems
public meta import Lean.Compiler.QTT.FreeSafety
public meta import Lean.Compiler.LCNF.MemSafetyCert
public meta import Lean.Compiler.LCNF.CompCertCert

/-!
# QTT / free-safety / cert formal layer markers (R4)

Imports formal markers and checks mult algebra, free-safety policy, and cert claim-line
inventories at runtime. Private definitional theorems live in `Multiplicity.Theorems` and
cert `Theorems` namespaces (same module as the defs). Host-facing free-safety package:
`Lean.Compiler.QTT.FreeSafety`. This is **not** a CompCert-class verified compilation claim.
-/

open Lean.Compiler (Multiplicity)
open Lean.Compiler.LCNF

#check Multiplicity.Theorems.algebraChecked
#check Multiplicity.Theorems.freeSafetyChecked
#check Multiplicity.Theorems.productResidualMultPolicyChecked
#check Lean.Compiler.QTT.Theorems.multAlgebraChecked
#check Lean.Compiler.QTT.Theorems.algebraChecked
#check Lean.Compiler.QTT.Theorems.productResidualMultPolicyChecked
#check Lean.Compiler.QTT.FreeSafety.freeSafetyChecked
#check Lean.Compiler.QTT.FreeSafety.freeSafetyFormalLayerChecked
#check Lean.Compiler.QTT.FreeSafety.productResidualMultPolicyChecked
#check MemSafetyCert.Theorems.claimInventoryChecked
#check CompCertCert.Theorems.claimInventoryChecked

def check (label : String) (ok : Bool) : IO Unit := do
  if !ok then throw <| .userError s!"FAIL: {label}"
  IO.println s!"OK: {label}"

#eval show IO Unit from do
  check "Multiplicity.Theorems.algebraChecked" Multiplicity.Theorems.algebraChecked
  check "Multiplicity.Theorems.freeSafetyChecked" Multiplicity.Theorems.freeSafetyChecked
  check "Multiplicity.Theorems.productResidualMultPolicyChecked"
    Multiplicity.Theorems.productResidualMultPolicyChecked
  check "QTT.Theorems.multAlgebraChecked" Lean.Compiler.QTT.Theorems.multAlgebraChecked
  check "QTT.Theorems.algebraChecked" Lean.Compiler.QTT.Theorems.algebraChecked
  check "QTT.Theorems.freeSafetyChecked" Lean.Compiler.QTT.Theorems.freeSafetyChecked
  check "QTT.Theorems.productResidualMultPolicyChecked"
    Lean.Compiler.QTT.Theorems.productResidualMultPolicyChecked
  check "QTT.FreeSafety.freeSafetyChecked" Lean.Compiler.QTT.FreeSafety.freeSafetyChecked
  check "QTT.FreeSafety.freeSafetyFormalLayerChecked"
    Lean.Compiler.QTT.FreeSafety.freeSafetyFormalLayerChecked
  check "QTT.FreeSafety.productResidualMultPolicyChecked"
    Lean.Compiler.QTT.FreeSafety.productResidualMultPolicyChecked
  check "QTT.FreeSafety.linearExactOncePolicy" Lean.Compiler.QTT.FreeSafety.linearExactOncePolicy
  check "QTT.FreeSafety.zeroQtyErasedPolicy" Lean.Compiler.QTT.FreeSafety.zeroQtyErasedPolicy
  check "QTT.FreeSafety.zeroQtyNonRuntimePolicy"
    Lean.Compiler.QTT.FreeSafety.zeroQtyNonRuntimePolicy
  check "QTT.FreeSafety.zeroMulAnnihilatesPolicy"
    Lean.Compiler.QTT.FreeSafety.zeroMulAnnihilatesPolicy
  check "QTT.FreeSafety.omegaUnrestrictedPolicy" Lean.Compiler.QTT.FreeSafety.omegaUnrestrictedPolicy
  check "QTT.FreeSafety.affineResourceLinearPolicy"
    Lean.Compiler.QTT.FreeSafety.affineResourceLinearPolicy
  check "QTT.FreeSafety.partitionOwnershipLinearPolicy"
    Lean.Compiler.QTT.FreeSafety.partitionOwnershipLinearPolicy
  -- Independent affine vs partition: second-use vs post-consume not-linear + requireLinear
  check "affine emphasizes second-use none"
    ((Multiplicity.useOnce .one).bind Multiplicity.useOnce == none &&
     Lean.Compiler.QTT.FreeSafety.affineResourceLinearPolicy)
  check "partition emphasizes requireLinear + post-consume not linear"
    (Multiplicity.requireLinear .one &&
     (Multiplicity.useOnce .one).map Multiplicity.isLinear == some false &&
     Lean.Compiler.QTT.FreeSafety.partitionOwnershipLinearPolicy)
  check "QTT.FreeSafety.memsafeFreeSafetyClaimsPresent"
    Lean.Compiler.QTT.FreeSafety.memsafeFreeSafetyClaimsPresent
  check "QTT.FreeSafety.productFreeSafetyPolicies"
    Lean.Compiler.QTT.FreeSafety.productFreeSafetyPolicies
  check "QTT.FreeSafety.omegaRepeatedUseStable"
    Lean.Compiler.QTT.FreeSafety.omegaRepeatedUseStable
  check "QTT.FreeSafety.linearExactOnceChain"
    Lean.Compiler.QTT.FreeSafety.linearExactOnceChain
  check "add 1+1=ω" (Multiplicity.add .one .one == .omega)
  check "mul 0*1=0" (Multiplicity.mul .zero .one == .zero)
  check "mul 0*ω=0" (Multiplicity.mul .zero .omega == .zero)
  check "mul 1*ω=ω" (Multiplicity.mul .one .omega == .omega)
  check "add 0+1=1" (Multiplicity.add .zero .one == .one)
  check "add 1+0=1" (Multiplicity.add .one .zero == .one)
  check "mul ω*ω=ω" (Multiplicity.mul .omega .omega == .omega)
  check "add comm 1+ω" (Multiplicity.add .one .omega == Multiplicity.add .omega .one)
  check "mul comm 0*ω" (Multiplicity.mul .zero .omega == Multiplicity.mul .omega .zero)
  check "add assoc 1+1+1"
    (Multiplicity.add (Multiplicity.add .one .one) .one ==
      Multiplicity.add .one (Multiplicity.add .one .one))
  check "mul assoc 1*ω*ω"
    (Multiplicity.mul (Multiplicity.mul .one .omega) .omega ==
      Multiplicity.mul .one (Multiplicity.mul .omega .omega))
  check "left distrib 1*(1+1)"
    (Multiplicity.mul .one (Multiplicity.add .one .one) ==
      Multiplicity.add (Multiplicity.mul .one .one) (Multiplicity.mul .one .one))
  check "left distrib ω*(1+1)"
    (Multiplicity.mul .omega (Multiplicity.add .one .one) ==
      Multiplicity.add (Multiplicity.mul .omega .one) (Multiplicity.mul .omega .one))
  check "right distrib (1+1)*1"
    (Multiplicity.mul (Multiplicity.add .one .one) .one ==
      Multiplicity.add (Multiplicity.mul .one .one) (Multiplicity.mul .one .one))
  check "le refl ω" (Multiplicity.le .omega .omega)
  check "not le 1≤0" (!Multiplicity.le .one .zero)
  check "not le ω≤1" (!Multiplicity.le .omega .one)
  check "not le ω≤0" (!Multiplicity.le .omega .zero)
  check "le chain 0≤1≤ω"
    (Multiplicity.le .zero .one && Multiplicity.le .one .omega && Multiplicity.le .zero .omega)
  check "requireLinear one" (Multiplicity.requireLinear .one)
  check "isLinear one" (Multiplicity.isLinear .one)
  check "isErased zero" (Multiplicity.isErased .zero)
  check "isUnrestricted ω" (Multiplicity.isUnrestricted .omega)
  check "le 0≤1≤ω" (Multiplicity.le .zero .one && Multiplicity.le .one .omega)
  check "mayDiscard one=false" (!Multiplicity.mayDiscard .one)
  check "mayDiscard omega=true" (Multiplicity.mayDiscard .omega)
  check "mayDiscard zero=true" (Multiplicity.mayDiscard .zero)
  check "isRuntime zero=false" (!Multiplicity.isRuntime .zero)
  check "useOnce one=some zero" (Multiplicity.useOnce .one == some .zero)
  check "useOnce zero=none" (Multiplicity.useOnce .zero == none)
  check "linear second use impossible"
    ((Multiplicity.useOnce .one).bind Multiplicity.useOnce == none)
  check "isErased one=false" (!Multiplicity.isErased .one)
  check "isErased omega=false" (!Multiplicity.isErased .omega)
  check "isLinear zero=false" (!Multiplicity.isLinear .zero)
  check "isLinear omega=false" (!Multiplicity.isLinear .omega)
  check "isRuntime omega" (Multiplicity.isRuntime .omega)
  check "requireLinear omega" (Multiplicity.requireLinear .omega)
  check "requireLinear zero=false" (!Multiplicity.requireLinear .zero)
  check "lt 0<1" (Multiplicity.lt .zero .one)
  check "lt 1<ω" (Multiplicity.lt .one .omega)
  check "not lt 1<1" (!Multiplicity.lt .one .one)
  check "mul 1*0=0" (Multiplicity.mul .one .zero == .zero)
  check "mul ω*0=0" (Multiplicity.mul .omega .zero == .zero)
  check "add 0+0=0" (Multiplicity.add .zero .zero == .zero)
  -- Full 3×3 add table (definitional surface used by free-safety / split algebra)
  check "add table 0/1/ω"
    (Multiplicity.add .zero .zero == .zero &&
     Multiplicity.add .zero .one == .one &&
     Multiplicity.add .zero .omega == .omega &&
     Multiplicity.add .one .zero == .one &&
     Multiplicity.add .one .one == .omega &&
     Multiplicity.add .one .omega == .omega &&
     Multiplicity.add .omega .zero == .omega &&
     Multiplicity.add .omega .one == .omega &&
     Multiplicity.add .omega .omega == .omega)
  check "mul table 0/1/ω"
    (Multiplicity.mul .zero .zero == .zero &&
     Multiplicity.mul .zero .one == .zero &&
     Multiplicity.mul .zero .omega == .zero &&
     Multiplicity.mul .one .zero == .zero &&
     Multiplicity.mul .one .one == .one &&
     Multiplicity.mul .one .omega == .omega &&
     Multiplicity.mul .omega .zero == .zero &&
     Multiplicity.mul .omega .one == .omega &&
     Multiplicity.mul .omega .omega == .omega)
  check "add comm 0+1" (Multiplicity.add .zero .one == Multiplicity.add .one .zero)
  check "mul comm 0+1" (Multiplicity.mul .zero .one == Multiplicity.mul .one .zero)
  check "zero mul annihilates"
    (Multiplicity.mul .zero .zero == .zero &&
     Multiplicity.mul .zero .one == .zero &&
     Multiplicity.mul .zero .omega == .zero &&
     Multiplicity.mul .one .zero == .zero &&
     Multiplicity.mul .omega .zero == .zero)
  check "mul 0*0=0" (Multiplicity.mul .zero .zero == .zero)
  check "omega repeated useOnce stable"
    ((Multiplicity.useOnce .omega).bind Multiplicity.useOnce == some .omega)
  check "multToNat 0/1/ω" (
    Lean.Compiler.multToNat .zero == 0 &&
    Lean.Compiler.multToNat .one == 1 &&
    Lean.Compiler.multToNat .omega == 2)
  check "multFromNat? 0/1/2/3" (
    Lean.Compiler.multFromNat? 0 == some Multiplicity.zero &&
    Lean.Compiler.multFromNat? 1 == some Multiplicity.one &&
    Lean.Compiler.multFromNat? 2 == some Multiplicity.omega &&
    Lean.Compiler.multFromNat? 3 == none)
  check "memsafe claim inventory marker" MemSafetyCert.Theorems.claimInventoryChecked
  check "compcert claim inventory marker" CompCertCert.Theorems.claimInventoryChecked
  check "memsafe requires qtt_zero_quantity_erased"
    (MemSafetyCert.claimLines.any (fun s => s == "claim=qtt_zero_quantity_erased"))
  check "memsafe requires qtt_linear_resources_exact_once"
    (MemSafetyCert.claimLines.any (fun s => s == "claim=qtt_linear_resources_exact_once"))
  check "memsafe requires qtt_omega_unrestricted_scalars"
    (MemSafetyCert.claimLines.any (fun s => s == "claim=qtt_omega_unrestricted_scalars"))
  check "compcert requires memsafe prerequisite claim"
    (CompCertCert.claimLines.any (fun s => s == "claim=valid_freestanding_memsafe_cert_prerequisite"))
  check "compcert requires qtt_zero_quantity_erased"
    (CompCertCert.claimLines.any (fun s => s == "claim=qtt_zero_quantity_erased"))
  IO.println "qtt_formal_layer: all markers ok"
