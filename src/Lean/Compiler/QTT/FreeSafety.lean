/-
Copyright (c) 2026 Lean FRO, LLC. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Hunter Beast
-/
module

prelude
public import Lean.Compiler.Multiplicity
public import Lean.Compiler.LCNF.MemSafetyCert

/-!
# Free-safety formal layer (host-facing)

Host-facing formal surface (definitional markers only; no unfinished proof tactics) for
freestanding free-safety claims used by ComplianceCorpus / proof receipts:

| Claim string (MemSafetyCert) | Multiplicity policy (definitional, same-module) |
|------------------------------|--------------------------------------------------|
| `qtt_linear_resources_exact_once` | linear: no silent drop; `useOnce` once → 0; second use impossible |
| `qtt_zero_quantity_erased` | 0-qty: `isErased`, not `isRuntime`, `useOnce = none` |
| `qtt_omega_unrestricted_scalars` | ω: may discard; use leaves ω |

Host free-safety **multiplicity algebra** policies (computable; definitional witnesses in
`Multiplicity.Theorems`). These are Mult policy predicates — **not** the product
`residual_nm` / `residual_ir` emission gates (separate `systems-validate` nm/IR greps):

* `zeroQtyNonRuntimePolicy` — mult-0 policy: erased / non-runtime / not useOnce-able
* `zeroMulAnnihilatesPolicy` — `0 * q = q * 0 = 0` (incl. `0*0`)
* `affineResourceLinearPolicy` — linear exact-once + no silent discard (Chan / Fd-like model)
* `partitionOwnershipLinearPolicy` — L/R partition **caller-contract** linear policy
  (exact-once + requireLinear + post-consume not linear; **not** points-to / separation)

Joint host marker: `freeSafetyFormalLayerChecked` = definitional Mult markers ∧ claim inventory
∧ `productFreeSafetyPolicies` (greppable host bundle once) ∧ host-only extras
(`omegaRepeatedUseStable`, `linearExactOnceChain`, `memsafeFreeSafetyClaimsPresent`).
Individuals remain public for greppability but are **not** re-conjunct'd next to the bundle.

Definitional free-safety lemmas live co-located with algebra in `Multiplicity.Theorems`
(module system: private `rfl` lemmas must see function bodies). Claim-line inventory
lemmas live in `MemSafetyCert.Theorems`. This module **re-exports markers** and exposes
computable host-facing policy predicates so import sites / elab tests get a single package.

**Honest residual:** this does **not** prove elaborator `UseCheck` or LCNF `AffineCheck`
completeness over all Lean surface syntax, nor ISO C memory safety of emitted product C,
nor points-to separation for partitioned ownership, nor residual_nm/residual_ir freedom
by itself. Those remain checker/cert/dogfood / separate validate gates
(see `doc/dev/systems-lean.md`).
-/

namespace Lean.Compiler.QTT.FreeSafety

/-- Mult-algebra free-safety marker (`Multiplicity.Theorems.freeSafetyChecked`). -/
public def freeSafetyChecked : Bool := Multiplicity.Theorems.freeSafetyChecked

/-- Mult algebra marker (tables/assoc/distrib/le only; free-safety is separate). -/
public def algebraChecked : Bool := Multiplicity.Theorems.algebraChecked

/--
Free-safety mult algebra policy marker
(`Multiplicity.Theorems.productResidualMultPolicyChecked`). Mult-0 / linear / ω policy
only — emission residual_nm / residual_ir are separate product gates.
-/
public def productResidualMultPolicyChecked : Bool :=
  Multiplicity.Theorems.productResidualMultPolicyChecked

/-- MemSafetyCert claim-line inventory marker (includes free-safety claim strings). -/
public def memsafeClaimInventoryChecked : Bool :=
  LCNF.MemSafetyCert.Theorems.claimInventoryChecked

/--
Pure policy predicates (computable). Elab / host smoke evaluates these;
definitional proofs of the same facts live in `Multiplicity.Theorems` (same module as algebra).
-/
public def linearExactOncePolicy : Bool :=
  (!Multiplicity.mayDiscard .one) &&
  (Multiplicity.useOnce .one == some .zero) &&
  ((Multiplicity.useOnce .one).bind Multiplicity.useOnce == none) &&
  Multiplicity.isLinear .one &&
  Multiplicity.requireLinear .one

public def zeroQtyErasedPolicy : Bool :=
  Multiplicity.isErased .zero &&
  (!Multiplicity.isRuntime .zero) &&
  (Multiplicity.useOnce .zero == none)

/--
Strengthened mult-0 policy: erased ∧ non-runtime ∧ no `useOnce` ∧ not linear ∧ not requireLinear.
Alias extension of `zeroQtyErasedPolicy` (Mult policy; not residual_nm/ir).
-/
public def zeroQtyNonRuntimePolicy : Bool :=
  zeroQtyErasedPolicy &&
  Multiplicity.mayDiscard .zero &&
  (!Multiplicity.isLinear .zero) &&
  (!Multiplicity.requireLinear .zero)

/-- Zero annihilation on both sides: 0*1=0, 0*ω=0, 1*0=0, ω*0=0 (and 0*0=0). -/
public def zeroMulAnnihilatesPolicy : Bool :=
  (Multiplicity.mul .zero .zero == .zero) &&
  (Multiplicity.mul .zero .one == .zero) &&
  (Multiplicity.mul .zero .omega == .zero) &&
  (Multiplicity.mul .one .zero == .zero) &&
  (Multiplicity.mul .omega .zero == .zero)

public def omegaUnrestrictedPolicy : Bool :=
  Multiplicity.mayDiscard .omega &&
  (Multiplicity.useOnce .omega == some .omega) &&
  Multiplicity.isUnrestricted .omega

/--
Affine resource model (Chan / Fd-like): linear exact-once + mayDiscard false.
Host policy marker only — not a resource-type points-to proof.
-/
public def affineResourceLinearPolicy : Bool :=
  Multiplicity.isLinear .one &&
  (!Multiplicity.mayDiscard .one) &&
  (Multiplicity.useOnce .one == some .zero) &&
  ((Multiplicity.useOnce .one).bind Multiplicity.useOnce == none)

/--
Partition ownership (L/R) as **caller-contract linear policy marker**.

Models the L2 partition **caller contract** on freestanding products: linear exact-once,
`requireLinear`, and post-consume residual is not linear. Does **not** prove type-level
points-to or separation-logic ownership transfer; not residual_nm/residual_ir.
Distinguished from `affineResourceLinearPolicy` (emphasizes second-use impossible).
-/
public def partitionOwnershipLinearPolicy : Bool :=
  Multiplicity.isLinear .one &&
  (!Multiplicity.mayDiscard .one) &&
  (Multiplicity.useOnce .one == some .zero) &&
  Multiplicity.requireLinear .one &&
  ((Multiplicity.useOnce .one).map Multiplicity.isLinear == some false)

/-- MemSafetyCert embeds free-safety claim strings (computable scan of `claimLines`). -/
public def memsafeFreeSafetyClaimsPresent : Bool :=
  LCNF.MemSafetyCert.claimLines.any (fun s => s == "claim=qtt_linear_resources_exact_once") &&
  LCNF.MemSafetyCert.claimLines.any (fun s => s == "claim=qtt_zero_quantity_erased") &&
  LCNF.MemSafetyCert.claimLines.any (fun s => s == "claim=qtt_omega_unrestricted_scalars")

/--
Host free-safety policy bundle (greppable individuals also public for elab smoke).

linear exact-once ∧ mult-0 erase ∧ ω unrestricted ∧ annihilate ∧ affine/partition caller-contracts.
Tied to UseCheck / AffineCheck *policy* surface (not a completeness proof of those checkers).
-/
public def productFreeSafetyPolicies : Bool :=
  linearExactOncePolicy && zeroQtyErasedPolicy && omegaUnrestrictedPolicy &&
  zeroQtyNonRuntimePolicy && zeroMulAnnihilatesPolicy &&
  affineResourceLinearPolicy && partitionOwnershipLinearPolicy

/--
ω free-use stability: repeated `useOnce` leaves ω (unrestricted complement of linear exact-once).
-/
public def omegaRepeatedUseStable : Bool :=
  (Multiplicity.useOnce .omega == some .omega) &&
  ((Multiplicity.useOnce .omega).bind Multiplicity.useOnce == some .omega)

/--
Linear exact-once + post-consume not re-usable as linear (UseCheck double-use model).
-/
public def linearExactOnceChain : Bool :=
  (Multiplicity.useOnce .one == some .zero) &&
  ((Multiplicity.useOnce .one).bind Multiplicity.useOnce == none) &&
  ((Multiplicity.useOnce .one).map Multiplicity.isLinear == some false)

/--
Joint formal marker: definitional Mult markers ∧ claim inventory ∧ host policies (once).

**Slimmed conjunction (no triple-count):** definitional stratum once each
(`freeSafetyChecked`, `algebraChecked`, `productResidualMultPolicyChecked`,
`claimInventoryChecked`); host policies via `productFreeSafetyPolicies` **once** (not
also re-listed as individuals); host-only extras (`omegaRepeatedUseStable`,
`linearExactOnceChain`, `memsafeFreeSafetyClaimsPresent`). Individual policy defs remain
public for greppable elab checks.

**Witness style (module-system honest):** Prop-level free-safety lemmas are co-located with
algebra in `Multiplicity.Theorems` (`have _ : Prop := lemma; true`). Cross-module `rfl`
cannot see unexposed function bodies — this joint def does **not** re-prove those lemmas.

Not a free `true`. Residuals: does not prove UseCheck/AffineCheck completeness, ISO C
memory safety of emission, or residual_nm/ir (separate gates).
-/
public def freeSafetyFormalLayerChecked : Bool :=
  Multiplicity.Theorems.freeSafetyChecked &&
    Multiplicity.Theorems.algebraChecked &&
    Multiplicity.Theorems.productResidualMultPolicyChecked &&
    LCNF.MemSafetyCert.Theorems.claimInventoryChecked &&
    productFreeSafetyPolicies &&
    omegaRepeatedUseStable &&
    linearExactOnceChain &&
    memsafeFreeSafetyClaimsPresent

end Lean.Compiler.QTT.FreeSafety
