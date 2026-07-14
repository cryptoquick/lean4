module

import Lean

/-!
# QTT binder multiplicities (R1)

Tests default multiplicities, `annotateMult` round-trip, telescope mult lists,
`getBinderMult` / elaborator introduce helpers, LCNF-facing pure policy
(`lcErased` → 0, resource attrs → 1), and classic-mode no-op.
-/

open Lean
open Lean.Compiler (Multiplicity)
open Lean.Compiler
open Lean.Meta
open Lean.Compiler.QTT

/-- Minimal linear resource for attr → 1. -/
@[linear]
inductive QttLinTok : Type where
  | mk : QttLinTok

/-- Abbreviation that reduces to a further forall (dependent prop domain). -/
abbrev QttFoo (n : Nat) : Type := (h : n = n) → Nat

def check (label : String) (ok : Bool) : IO Unit := do
  if !ok then throw <| .userError s!"FAIL: {label}"
  IO.println s!"OK: {label}"

#eval show MetaM Unit from do
  let env ← getEnv
  let opts ← getOptions
  check "classic mode isQttMode false by default" (!isQttMode env opts)

  let natTy := mkConst ``Nat
  let propTy := mkConst `Prop
  let sort0 := mkSort levelZero
  let erasedTy := mkConst `lcErased
  let linTy := mkConst ``QttLinTok
  check "default Nat → ω" (binderMultiplicity env natTy == .omega)
  check "default Prop const → 0" (binderMultiplicity env propTy == .zero)
  check "default sort → 0" (binderMultiplicity env sort0 == .zero)
  check "lcErased → 0" (binderMultiplicity env erasedTy == .zero)
  check "getBinderMultOfType lcErased → 0" (getBinderMultOfType env erasedTy == .zero)
  check "@[linear] resource → 1" (binderMultiplicity env linTy == .one)
  check "getBinderMultOfType linear → 1" (getBinderMultOfType env linTy == .one)

  let annotated1 := annotateMult .one natTy
  let annotated0 := annotateMult .zero natTy
  let annotatedW := annotateMult .omega natTy
  check "annotateMult 1 round-trip" (multAnnotation? annotated1 == some .one)
  check "annotateMult 0 round-trip" (multAnnotation? annotated0 == some .zero)
  check "annotateMult ω round-trip" (multAnnotation? annotatedW == some .omega)
  check "binderMult prefers mdata over type default" (binderMultiplicity env annotated1 == .one)
  check "getBinderMultOfType honors annotateMult .one on Nat"
    (getBinderMultOfType env annotated1 == .one)
  check "getBinderMultOfType honors annotateMult .zero on linear resource"
    (getBinderMultOfType env (annotateMult .zero linTy) == .zero)
  check "ensureExplicitMult adds mdata" (multAnnotation? (ensureExplicitMult env natTy) == some .omega)
  check "ensureExplicitMult preserves existing"
    (multAnnotation? (ensureExplicitMult env annotated1) == some .one)
  check "getBinderMultOfType = binderMultiplicity"
    (getBinderMultOfType env natTy == binderMultiplicity env natTy)

  let ty :=
    mkForall `n .default (mkConst ``Nat) <|
    mkForall `p .default (mkConst `Prop) (mkConst ``Nat)
  let ms ← binderMultsOfTelescope ty
  check "telescope [ω, 0] for Nat → Prop → Nat" (ms == [.omega, .zero])
  let tyAnn := annotateTelescopeBinderMults env ty
  let ms2 ← binderMultsOfTelescope tyAnn
  check "annotateTelescope preserves mults" (ms2 == [.omega, .zero])
  match tyAnn with
  | .forallE _ d _ _ =>
    check "telescope domain has explicit mult" (multAnnotation? d).isSome
  | _ => throwError "expected forall"

  withLocalDeclD `x (mkConst ``Nat) fun x => do
    let m ← getLocalBinderMult x.fvarId!
    check "getLocalBinderMult Nat → ω (classic)" (m == .omega)
    -- classic withLocalDecl under default: mult still defined via defaults
    let env ← getEnv
    let lctx ← getLCtx
    check "getBinderMult classic local Nat → ω" (getBinderMult env lctx x.fvarId! == .omega)

  -- Unannotated Prop-valued True: Meta → 0; pure may be ω without mdata
  withLocalDeclD `h0 (mkConst ``True) fun h => do
    let m ← getLocalBinderMult h.fvarId!
    check "Meta getLocalBinderMult unannotated True → 0" (m == .zero)
    let env ← getEnv
    let lctx ← getLCtx
    let pureM := getBinderMult env lctx h.fvarId!
    check "pure getBinderMult unannotated True is ω (no isProp)" (pureM == .omega)

  withOptions (fun o => compiler.qtt.set o true) do
    let env ← getEnv
    let opts ← getOptions
    check "isQttMode under compiler.qtt" (isQttMode env opts)
    withQttLocalDecl `y .default (mkConst ``Nat) fun y => do
      let lctx ← getLCtx
      let decl := lctx.get! y.fvarId!
      check "withQttLocalDecl annotates type" (multAnnotation? decl.type).isSome
      let m ← getLocalBinderMult y.fvarId!
      check "getLocalBinderMult after QTT intro → ω" (m == .omega)
      check "getBinderMult matches after mdata" (getBinderMult env lctx y.fvarId! == .omega)
    withQttLocalDecl `z .default (annotateMult .one (mkConst ``Nat)) fun z => do
      let m ← getLocalBinderMult z.fvarId!
      check "explicit mult 1 on local" (m == .one)
      let env ← getEnv
      let lctx ← getLCtx
      check "getBinderMult explicit 1" (getBinderMult env lctx z.fvarId! == .one)
    withQttLocalDecl `r .default (mkConst ``QttLinTok) fun r => do
      let m ← getLocalBinderMult r.fvarId!
      check "QTT intro linear resource → 1" (m == .one)
    withQttLetDecl `w (mkConst ``Nat) (mkNatLit 0) fun w => do
      let lctx ← getLCtx
      let decl := lctx.get! w.fvarId!
      check "withQttLetDecl annotates type" (multAnnotation? decl.type).isSome
    let erasedM := annotateMult .zero (mkConst ``Nat)
    let rejected ←
      try
        checkNotErasedRuntime erasedM "test export"
        pure false
      catch _ =>
        pure true
    check "0-qty rejected at runtime under QTT" rejected
    withQttLocalDecl `h .default (mkConst ``True) fun h => do
      let m ← getLocalBinderMult h.fvarId!
      check "Prop-valued binder → 0" (m == .zero)
      let env ← getEnv
      let lctx ← getLCtx
      check "pure matches Meta after QTT mdata on True" (getBinderMult env lctx h.fvarId! == .zero)

    -- Dependent prop domain via forallTelescopeQtt
    let depTy :=
      mkForall `n .default (mkConst ``Nat) <|
      mkForall `h .default
        (mkApp3 (mkConst ``Eq [levelOne]) (mkConst ``Nat) (mkBVar 0) (mkBVar 0))
        (mkConst ``Nat)
    forallTelescopeQtt depTy fun xs _ => do
      check "forallTelescopeQtt dependent arity" (xs.size == 2)
      let m0 ← getLocalBinderMult xs[0]!.fvarId!
      let m1 ← getLocalBinderMult xs[1]!.fvarId!
      check "forallTelescopeQtt Nat → ω" (m0 == .omega)
      check "forallTelescopeQtt (n=n) → 0" (m1 == .zero)
      let decl1 := (← getLCtx).get! xs[1]!.fvarId!
      check "dependent prop domain has explicit mult" (multAnnotation? decl1.type).isSome

    let msDep ← binderMultsOfTelescopeExplicit depTy
    check "binderMultsOfTelescopeExplicit dependent [ω, 0]" (msDep == [.omega, .zero])

    -- Reducing telescope: `Nat → QttFoo n` unfolds to `Nat → (h : n = n) → Nat`
    let redTy :=
      mkForall `n .default (mkConst ``Nat) <|
      mkApp (mkConst ``QttFoo) (mkBVar 0)
    forallTelescopeQtt redTy fun xs _ => do
      check "forallTelescopeQtt reducing arity" (xs.size == 2)
      let m0 ← getLocalBinderMult xs[0]!.fvarId!
      let m1 ← getLocalBinderMult xs[1]!.fvarId!
      check "forallTelescopeQtt reducing Nat → ω" (m0 == .omega)
      check "forallTelescopeQtt reducing (n=n) → 0" (m1 == .zero)

  -- freestanding option also enables isQttMode
  withOptions (fun o => compiler.freestanding.set o true) do
    let env ← getEnv
    let opts ← getOptions
    check "isQttMode under compiler.freestanding" (isQttMode env opts)
    withQttLocalDecl `f .default (mkConst ``Nat) fun f => do
      let decl := (← getLCtx).get! f.fvarId!
      check "withQttLocalDecl under freestanding annotates" (multAnnotation? decl.type).isSome

  let env ← getEnv
  let opts ← getOptions
  check "still classic outside withOptions" (!isQttMode env opts)
  checkNotErasedRuntime (annotateMult .zero (mkConst ``Nat)) "should not throw"
  check "classic: checkNotErasedRuntime no-op" true

  -- classic withLocalDecl under compiler.qtt: mult defined via defaults without helper
  withOptions (fun o => compiler.qtt.set o true) do
    withLocalDeclD `plain (mkConst ``Nat) fun x => do
      let m ← getLocalBinderMult x.fvarId!
      check "plain withLocalDecl under QTT still has mult via defaults" (m == .omega)

  IO.println "qtt_binder_mult: all cases passed"
