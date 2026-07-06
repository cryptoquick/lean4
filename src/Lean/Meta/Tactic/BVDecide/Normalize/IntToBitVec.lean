/-
Copyright (c) 2025 Lean FRO, LLC. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Henrik Böving
-/
module

prelude
public import Lean.Meta.Tactic.BVDecide.Normalize.Basic
import Lean.Meta.Sym.Simp.Rewrite
import Lean.Meta.Sym.InstantiateMVarsS
import Lean.Meta.Sym.LitValues

/-!
This module contains the implementation of the pre processing pass for reducing `UIntX`/`IntX` to
`BitVec` and thus allow `bv_decide` to reason about them.

It:
1. runs the `int_toBitVec` simp set
2. If `USize.toBitVec`/`ISize.toBitVec` is used anywhere looks for equations of the form
   `System.Platform.numBits = constant` (or flipped) and uses them to convert the system back to
   fixed width.
-/

namespace Lean.Meta.Tactic.BVDecide
namespace Normalize

/--
Contains information for the `USize`/`ISize` elimination pass.
-/
structure SizeState where
  /--
  Contains terms of the form `USize.toBitVec e` and `ISize.toBitVec e` that we will translate to
  constant width `BitVec`.
  -/
  relevantTerms : Std.HashSet Expr := {}
  /--
  Contains all hypotheses that contain terms from `relevantTerms`
  -/
  relevantHyps : Std.HashSet FVarId := {}

private abbrev M := StateRefT SizeState MetaM

namespace M

@[inline]
private def addSizeTerm (e : Expr) : M Unit := do
  modify fun s => { s with relevantTerms := s.relevantTerms.insert e }

@[inline]
private def addSizeHyp (f : FVarId) : M Unit := do
  modify fun s => { s with relevantHyps := s.relevantHyps.insert f }

end M

public def addIntToBitVecLemmas (goal : MVarId) (methods : Sym.Simp.Methods) :
    Sym.SymM Sym.Simp.Methods := do
  let intToBvThms ← symIntToBitVecExt.getTheorems
  let numBitsEq? ← findNumBitsEq goal
  let discharge : Sym.Simp.Discharger :=
    if let some (width, proof) := numBitsEq? then
      fun prop => do
        let prop ← Sym.instantiateMVarsS prop
        let_expr Eq _ lhs rhs := prop | return .failed
        unless lhs.isConstOf ``System.Platform.numBits do return .failed
        let some val := Sym.getNatValue? rhs | return .failed
        unless width == val do return .failed
        return .solved proof
    else
      Sym.Simp.dischargeNone
  return { methods with pre := methods.pre >> intToBvThms.rewrite (d := discharge) }
where
  /--
  Builds an expression of type: `System.Platform.numBits = const` from the hypotheses in the context
  if possible.
  -/
  findNumBitsEq (goal : MVarId) : MetaM (Option (Nat × Expr)) := do
    goal.withContext do
      for hyp in ← getPropHyps do
        match_expr ← instantiateMVars (← hyp.getType) with
        | Eq eqTyp lhs rhs =>
          if lhs.isConstOf ``System.Platform.numBits then
            let some val ← getNatValue? rhs | return none
            return some (val, mkFVar hyp)
          else if rhs.isConstOf ``System.Platform.numBits then
            let some val ← getNatValue? lhs | return none
            return some (val, mkApp4 (mkConst ``Eq.symm [1]) eqTyp lhs rhs (mkFVar hyp))
        | _ => continue
      return none

public def intToBitVecPass : Pass where
  name := `intToBitVec
  run' := do
    let cfg ← PreProcessM.getConfig
    let goal ← PreProcessM.getGoal

    let config := {
      maxSteps := cfg.maxSteps
    }
    let methods ← addIntToBitVecLemmas goal {}
    goal.withContext do
      PreProcessM.mapHyps fun hyp => do
        let res ← Sym.simp hyp.type methods config
        hyp.applySimpResult res

end Normalize
end Lean.Meta.Tactic.BVDecide
