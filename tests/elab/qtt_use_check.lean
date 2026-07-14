module

import Lean

/-!
# QTT elaborator use/split checker (R2)

Positive linear pipeline; negative double-use / silent drop / 0-qty runtime leak;
`@[fs_borrow]` does not consume; real `if` / `match` / `cond` / parametric `casesOn`;
fail-closed multi-arm CF (rec/recOn/brecOn/ndrec/ndrec_symm/noConfusion/HEq.rec·recOn/Acc.rec·recOn/WF.fix·fixF/Quot.lift·ind·liftOn/Literal.strVal·natVal.elim/Name.str·num.elim sparse); letE double-use;
classic Lean is a no-op. Exercises the production PreDefinition hook under `compiler.qtt`.

Computable PreDefinition defs exercise **both** elab `checkQttUses` and LCNF `AffineCheck`
(local-fun capture consume + cases split) under `compiler.qtt`.
-/

open Lean
open Lean.Compiler (Multiplicity)
open Lean.Compiler
open Lean.Meta
open Lean.Compiler.QTT

/-- Minimal linear resource for attr → 1. -/
@[linear]
inductive QttUseTok : Type where
  | mk : QttUseTok

def check (label : String) (ok : Bool) : IO Unit := do
  if !ok then throw <| .userError s!"FAIL: {label}"
  IO.println s!"OK: {label}"

/-- Expect `checkQttUses` (or similar) to throw a freestanding QTT error.
Optional `needle` further requires a substring in the error (e.g. path-disagreement). -/
def expectFail (label : String) (x : MetaM Unit) (needle : String := "") : MetaM Unit := do
  let failed ←
    try
      x
      pure false
    catch e =>
      let msg ← e.toMessageData.toString
      if msg.contains "freestanding QTT" then
        if needle.isEmpty || msg.contains needle then
          pure true
        else
          throwError m!"FAIL: {label}: QTT error missing needle `{needle}`: {msg}"
      else
        throw e
  check label failed

#eval show MetaM Unit from do
  let env ← getEnv
  let opts ← getOptions
  check "classic isQttMode false" (!isQttMode env opts)

  -- Classic: double-use of annotated linear is ignored
  withLocalDeclD `x (annotateMult .one (mkConst ``Nat)) fun x => do
    let f :=
      mkLambda `a .default (mkConst ``Nat) <|
      mkLambda `b .default (mkConst ``Nat) (mkConst ``Nat.zero)
    let e := mkApp2 f x x
    checkQttUses e
    check "classic checkQttUses no-op on double-use" true

  withOptions (fun o => compiler.qtt.set o true) do
    let env ← getEnv
    let opts ← getOptions
    check "isQttMode under compiler.qtt" (isQttMode env opts)

    -- Positive: linear used once
    withQttLocalDecl `x .default (annotateMult .one (mkConst ``Nat)) fun x => do
      checkQttUses x
      check "linear used once (identity) OK" true

    -- Positive: ω free copy
    withQttLocalDecl `n .default (mkConst ``Nat) fun n => do
      let f :=
        mkLambda `a .default (mkConst ``Nat) <|
        mkLambda `b .default (mkConst ``Nat) (mkBVar 1)
      checkQttUses (mkApp2 f n n)
      check "ω free copy OK" true

    -- Positive: closed linear pipeline fun x => x
    let idLin :=
      mkLambda `x .default (annotateMult .one (mkConst ``Nat)) (mkBVar 0)
    checkQttUses idLin
    check "closed linear id OK" true

    -- Negative: double-use of mult-1
    withQttLocalDecl `x .default (annotateMult .one (mkConst ``Nat)) fun x => do
      let f :=
        mkLambda `a .default (mkConst ``Nat) <|
        mkLambda `b .default (mkConst ``Nat) (mkConst ``Nat.zero)
      expectFail "double-use of linear rejected" (checkQttUses (mkApp2 f x x))

    -- Negative: silent drop of mult-1
    let dropLin :=
      mkLambda `x .default (annotateMult .one (mkConst ``Nat)) (mkConst ``Nat.zero)
    expectFail "silent drop of linear rejected" (checkQttUses dropLin)

    -- Negative: 0-qty at runtime
    withQttLocalDecl `e .default (annotateMult .zero (mkConst ``Nat)) fun e => do
      expectFail "0-qty runtime use rejected" (checkQttUses e)

    -- Positive: erased ambient unused
    withQttLocalDecl `h .default (mkConst ``True) fun h => do
      let e := mkLambda `x .default (mkConst ``Nat) (mkBVar 0)
      checkQttUses e
      check "unused erased ambient OK (not in term)" true

    -- Full `ite` (implicit α; explicit: c, [Decidable], then, else) — alts after index 3
    withQttLocalDecl `x .default (annotateMult .one (mkConst ``Nat)) fun x => do
      let e ← mkAppM ``ite #[mkConst ``True, x, x]
      check s!"full ite arg count={e.getAppNumArgs}" (e.getAppNumArgs ≥ 5)
      checkQttUses e
      check "full ite (with Decidable) both arms OK" true

    -- Path disagreement on full ite
    withQttLocalDecl `x .default (annotateMult .one (mkConst ``Nat)) fun x => do
      let e ← mkAppM ``ite #[mkConst ``True, x, mkNatLit 0]
      expectFail "full ite path disagreement rejected" (checkQttUses e)

    -- Distinct linear pure-fvar arms must not silently drop the non-selected resource
    withQttLocalDecl `x .default (annotateMult .one (mkConst ``Nat)) fun x => do
      withQttLocalDecl `y .default (annotateMult .one (mkConst ``Nat)) fun y => do
        let e ← mkAppM ``ite #[mkConst ``True, x, y]
        expectFail "full ite distinct linear pure-fvar arms rejected" (checkQttUses e)
          (needle := "control-flow paths disagree")

    -- `cond` (implicit α; explicit: Bool, then, else) — alts after index 2 in full app
    withQttLocalDecl `x .default (annotateMult .one (mkConst ``Nat)) fun x => do
      let e ← mkAppM ``cond #[mkConst ``Bool.true, x, x]
      checkQttUses e
      check "cond both arms OK" true

    withQttLocalDecl `x .default (annotateMult .one (mkConst ``Nat)) fun x => do
      withQttLocalDecl `y .default (annotateMult .one (mkConst ``Nat)) fun y => do
        let e ← mkAppM ``cond #[mkConst ``Bool.true, x, y]
        expectFail "cond distinct linear pure-fvar arms rejected" (checkQttUses e)
          (needle := "control-flow paths disagree")

    -- Bool.casesOn (parameter-free: motive, major, falseAlt, trueAlt)
    withQttLocalDecl `x .default (annotateMult .one (mkConst ``Nat)) fun x => do
      let motive := mkLambda `b .default (mkConst ``Bool) (mkConst ``Nat)
      let e := mkAppN (mkConst ``Bool.casesOn [Level.one])
        #[motive, mkConst ``Bool.true, x, x]
      checkQttUses e
      check "Bool.casesOn both arms OK" true

    withQttLocalDecl `x .default (annotateMult .one (mkConst ``Nat)) fun x => do
      withQttLocalDecl `y .default (annotateMult .one (mkConst ``Nat)) fun y => do
        let motive := mkLambda `b .default (mkConst ``Bool) (mkConst ``Nat)
        let e := mkAppN (mkConst ``Bool.casesOn [Level.one])
          #[motive, mkConst ``Bool.true, x, y]
        expectFail "Bool.casesOn distinct linear pure-fvar arms rejected" (checkQttUses e)
          (needle := "control-flow paths disagree")

    -- Option.casesOn (parametric: α, motive, major, noneAlt, someAlt) — firstAlt = 3
    withQttLocalDecl `x .default (annotateMult .one (mkConst ``Nat)) fun x => do
      let α := mkConst ``Nat
      let optTy := mkApp (mkConst ``Option [Level.one]) α
      let motive := mkLambda `o .default optTy (mkConst ``Nat)
      let major := mkApp (mkConst ``Option.none [Level.one]) α
      let someAlt := mkLambda `a .default α x
      let e := mkAppN (mkConst ``Option.casesOn [Level.one, Level.one])
        #[α, motive, major, x, someAlt]
      checkQttUses e
      check "Option.casesOn linear both minors OK" true

    -- Linear λ binders inside alts must not leak into merge (Issue 4)
    do
      let alt1 := mkLambda `y .default (annotateMult .one (mkConst ``Nat)) (mkBVar 0)
      let alt2 := mkLambda `z .default (annotateMult .one (mkConst ``Nat)) (mkBVar 0)
      let e ← mkAppM ``ite #[mkConst ``True, alt1, alt2]
      checkQttUses e
      check "ite alts with linear λ binders OK (no merge leak)" true

    -- Fail-closed: raw Nat.rec is multi-arm CF not on the allowlist
    withQttLocalDecl `x .default (annotateMult .one (mkConst ``Nat)) fun x => do
      let motive := mkLambda `n .default (mkConst ``Nat) (mkConst ``Nat)
      let zeroAlt := x
      let succAlt := mkLambda `n .default (mkConst ``Nat) <|
        mkLambda `ih .default (mkConst ``Nat) (mkBVar 0)
      let e := mkAppN (mkConst ``Nat.rec [Level.one])
        #[motive, zeroAlt, succAlt, mkNatLit 0]
      expectFail "unrecognized Nat.rec multi-arm rejected" (checkQttUses e)

    -- Fail-closed: Nat.recOn (aux recursor) is not on the splitter allowlist
    withQttLocalDecl `x .default (annotateMult .one (mkConst ``Nat)) fun x => do
      let motive := mkLambda `n .default (mkConst ``Nat) (mkConst ``Nat)
      let zeroAlt := x
      let succAlt := mkLambda `n .default (mkConst ``Nat) <|
        mkLambda `ih .default (mkConst ``Nat) (mkBVar 0)
      let e := mkAppN (mkConst ``Nat.recOn [Level.one])
        #[mkNatLit 0, motive, zeroAlt, succAlt]
      expectFail "unrecognized Nat.recOn multi-arm rejected" (checkQttUses e)

    -- Fail-closed: Nat.brecOn similarly rejected (conservative; even pure-ω)
    withQttLocalDecl `x .default (annotateMult .one (mkConst ``Nat)) fun x => do
      -- Construct a partial brecOn head app with enough args to be multi-arm-shaped;
      -- checker rejects on const name before needing a well-typed full app.
      let e := mkApp (mkConst ``Nat.brecOn [Level.one]) (mkNatLit 0)
      expectFail "unrecognized Nat.brecOn multi-arm rejected" (checkQttUses e)

    -- Fail-closed: Eq.ndrec is an aux recursor but not casesOn (was sequential-consume hole)
    withQttLocalDecl `x .default (annotateMult .one (mkConst ``Nat)) fun x => do
      let e := mkApp (mkConst ``Eq.ndrec [Level.one, Level.one]) x
      expectFail "unrecognized Eq.ndrec multi-arm rejected" (checkQttUses e)

    -- Fail-closed: Eq.ndrecOn (ndrec* not covered by recOn-suffix matcher alone)
    withQttLocalDecl `x .default (annotateMult .one (mkConst ``Nat)) fun x => do
      let e := mkApp (mkConst ``Eq.ndrecOn [Level.one, Level.one]) x
      expectFail "unrecognized Eq.ndrecOn multi-arm rejected" (checkQttUses e)

    -- Fail-closed: Eq.ndrec_symm (aux recursor sibling; isAuxRecursor ∧ ¬casesOn)
    withQttLocalDecl `x .default (annotateMult .one (mkConst ``Nat)) fun x => do
      let e := mkApp (mkConst ``Eq.ndrec_symm [Level.one, Level.one]) x
      expectFail "unrecognized Eq.ndrec_symm multi-arm rejected" (checkQttUses e)

    -- Fail-closed: Eq.rec (raw recursor)
    withQttLocalDecl `x .default (annotateMult .one (mkConst ``Nat)) fun x => do
      let e := mkApp (mkConst ``Eq.rec [Level.one, Level.one]) x
      expectFail "unrecognized Eq.rec multi-arm rejected" (checkQttUses e)

    -- Fail-closed: Eq.recOn (aux recursor sibling of Eq.rec; not covered by Eq.rec alone)
    withQttLocalDecl `x .default (annotateMult .one (mkConst ``Nat)) fun x => do
      let e := mkApp (mkConst ``Eq.recOn [Level.one, Level.one]) x
      expectFail "unrecognized Eq.recOn multi-arm rejected" (checkQttUses e)

    -- Fail-closed: HEq.rec (raw recursor sibling of Eq.rec; isRecCore, distinct inductive)
    withQttLocalDecl `x .default (annotateMult .one (mkConst ``Nat)) fun x => do
      let e := mkApp (mkConst ``HEq.rec [Level.one, Level.one]) x
      expectFail "unrecognized HEq.rec multi-arm rejected" (checkQttUses e)

    -- Fail-closed: HEq.recOn (aux recursor sibling of HEq.rec; isAuxRecursor ∧ ¬casesOn)
    withQttLocalDecl `x .default (annotateMult .one (mkConst ``Nat)) fun x => do
      let e := mkApp (mkConst ``HEq.recOn [Level.one, Level.one]) x
      expectFail "unrecognized HEq.recOn multi-arm rejected" (checkQttUses e)

    -- Fail-closed: Acc.rec (raw recursor on accessibility; isRecCore; distinct from Nat/Eq/HEq.rec)
    withQttLocalDecl `x .default (annotateMult .one (mkConst ``Nat)) fun x => do
      let e := mkApp (mkConst ``Acc.rec [Level.one, Level.one]) x
      expectFail "unrecognized Acc.rec multi-arm rejected" (checkQttUses e)

    -- Fail-closed: Acc.recOn (aux recursor sibling of Acc.rec; isAuxRecursor ∧ ¬casesOn)
    withQttLocalDecl `x .default (annotateMult .one (mkConst ``Nat)) fun x => do
      let e := mkApp (mkConst ``Acc.recOn [Level.one, Level.one]) x
      expectFail "unrecognized Acc.recOn multi-arm rejected" (checkQttUses e)

    -- Fail-closed: WellFounded.fix (named non-allowlist eliminator; rejects on app head)
    do
      let e := mkApp (mkConst ``WellFounded.fix [Level.one, Level.one]) (mkConst ``True)
      expectFail "unrecognized WellFounded.fix multi-arm rejected" (checkQttUses e)

    -- Fail-closed: WellFounded.fixF (sibling named residual; not covered by fix alone)
    do
      let e := mkApp (mkConst ``WellFounded.fixF [Level.one, Level.one]) (mkConst ``True)
      expectFail "unrecognized WellFounded.fixF multi-arm rejected" (checkQttUses e)

    -- Fail-closed: Quot.lift (named non-allowlist eliminator; rejects on app head)
    do
      let e := mkApp (mkConst ``Quot.lift [Level.one, Level.one]) (mkConst ``True)
      expectFail "unrecognized Quot.lift multi-arm rejected" (checkQttUses e)

    -- Fail-closed: Quot.ind (sibling named residual; not covered by lift alone)
    do
      let e := mkApp (mkConst ``Quot.ind [Level.one]) (mkConst ``True)
      expectFail "unrecognized Quot.ind multi-arm rejected" (checkQttUses e)

    -- Fail-closed: Quot.liftOn (reordered lift sibling; named residual, not covered by lift/ind alone)
    do
      let e := mkApp (mkConst ``Quot.liftOn [Level.one, Level.one]) (mkConst ``True)
      expectFail "unrecognized Quot.liftOn multi-arm rejected" (checkQttUses e)

    -- Fail-closed: Nat.noConfusion (isNoConfusion; not on splitter allowlist)
    withQttLocalDecl `x .default (annotateMult .one (mkConst ``Nat)) fun x => do
      let e := mkApp (mkConst ``Nat.noConfusion [Level.one]) x
      expectFail "unrecognized Nat.noConfusion multi-arm rejected" (checkQttUses e)

    -- Fail-closed: Lean.Literal.strVal.elim (isSparseCasesOn ctor-elim; sparse path not sequential-consumed)
    withQttLocalDecl `x .default (annotateMult .one (mkConst ``Nat)) fun x => do
      let e := mkApp (mkConst ``Lean.Literal.strVal.elim [Level.one]) x
      expectFail "unrecognized Lean.Literal.strVal.elim multi-arm rejected" (checkQttUses e)

    -- Fail-closed: Lean.Literal.natVal.elim (sibling sparse ctor-elim; isSparseCasesOn; not covered by strVal.elim alone)
    withQttLocalDecl `x .default (annotateMult .one (mkConst ``Nat)) fun x => do
      let e := mkApp (mkConst ``Lean.Literal.natVal.elim [Level.one]) x
      expectFail "unrecognized Lean.Literal.natVal.elim multi-arm rejected" (checkQttUses e)

    -- Fail-closed: Lean.Name.str.elim (isSparseCasesOn ctor-elim on Name; sparse path not
    -- sequential-consumed; not covered by Literal.strVal·natVal.elim alone)
    withQttLocalDecl `x .default (annotateMult .one (mkConst ``Nat)) fun x => do
      let e := mkApp (mkConst ``Lean.Name.str.elim [Level.one]) x
      expectFail "unrecognized Lean.Name.str.elim multi-arm rejected" (checkQttUses e)

    -- Fail-closed: Lean.Name.num.elim (sibling sparse ctor-elim of Name.str.elim; isSparseCasesOn;
    -- sparse path not sequential-consumed; not covered by Name.str.elim alone)
    withQttLocalDecl `x .default (annotateMult .one (mkConst ``Nat)) fun x => do
      let e := mkApp (mkConst ``Lean.Name.num.elim [Level.one]) x
      expectFail "unrecognized Lean.Name.num.elim multi-arm rejected" (checkQttUses e)

    -- Full `dite` (same layout as ite: alts after Decidable at index 3)
    -- Shape: {α} → (c) → [Decidable c] → (h : c → α) → (¬c → α)
    withQttLocalDecl `x .default (annotateMult .one (mkConst ``Nat)) fun x => do
      let thenBr := mkLambda `h .default (mkConst ``True) x
      let elseBr := mkLambda `h .default (mkApp (mkConst ``Not) (mkConst ``True)) x
      let e ← mkAppM ``dite #[mkConst ``True, thenBr, elseBr]
      checkQttUses e
      check "full dite both arms OK" true

    withQttLocalDecl `x .default (annotateMult .one (mkConst ``Nat)) fun x => do
      let thenBr := mkLambda `h .default (mkConst ``True) x
      let elseBr := mkLambda `h .default (mkApp (mkConst ``Not) (mkConst ``True)) (mkNatLit 0)
      let e ← mkAppM ``dite #[mkConst ``True, thenBr, elseBr]
      expectFail "full dite path disagreement rejected" (checkQttUses e)

    -- Synthetic freestanding bif* layout (name suffix allowlist; no product import required)
    withQttLocalDecl `x .default (annotateMult .one (mkConst ``Nat)) fun x => do
      let bifFn := Expr.const (Name.mkStr `Fake "bifU32") []
      let e := mkAppN bifFn #[mkConst ``Bool.true, x, x]
      checkQttUses e
      check "synthetic bifU32 both arms OK" true

    withQttLocalDecl `x .default (annotateMult .one (mkConst ``Nat)) fun x => do
      withQttLocalDecl `y .default (annotateMult .one (mkConst ``Nat)) fun y => do
        let bifFn := Expr.const (Name.mkStr `Fake "bifU32") []
        let e := mkAppN bifFn #[mkConst ``Bool.true, x, y]
        expectFail "synthetic bifU32 distinct linear pure-fvar arms rejected" (checkQttUses e)
          (needle := "control-flow paths disagree")

    -- bifU64 (BitVecLite / U64 control-flow) shares the same freestanding splitter layout
    withQttLocalDecl `x .default (annotateMult .one (mkConst ``Nat)) fun x => do
      let bifFn := Expr.const (Name.mkStr `Fake "bifU64") []
      let e := mkAppN bifFn #[mkConst ``Bool.true, x, x]
      checkQttUses e
      check "synthetic bifU64 both arms OK" true

    withQttLocalDecl `x .default (annotateMult .one (mkConst ``Nat)) fun x => do
      withQttLocalDecl `y .default (annotateMult .one (mkConst ``Nat)) fun y => do
        let bifFn := Expr.const (Name.mkStr `Fake "bifU64") []
        let e := mkAppN bifFn #[mkConst ``Bool.true, x, y]
        expectFail "synthetic bifU64 distinct linear pure-fvar arms rejected" (checkQttUses e)
          (needle := "control-flow paths disagree")

    -- bifU8 / bifUSize / bifBool: freestanding scalar splitters (same layout SSoT as UseCheck allowlist)
    withQttLocalDecl `x .default (annotateMult .one (mkConst ``Nat)) fun x => do
      let bifFn := Expr.const (Name.mkStr `Fake "bifU8") []
      let e := mkAppN bifFn #[mkConst ``Bool.true, x, x]
      checkQttUses e
      check "synthetic bifU8 both arms OK" true

    withQttLocalDecl `x .default (annotateMult .one (mkConst ``Nat)) fun x => do
      withQttLocalDecl `y .default (annotateMult .one (mkConst ``Nat)) fun y => do
        let bifFn := Expr.const (Name.mkStr `Fake "bifU8") []
        let e := mkAppN bifFn #[mkConst ``Bool.true, x, y]
        expectFail "synthetic bifU8 distinct linear pure-fvar arms rejected" (checkQttUses e)
          (needle := "control-flow paths disagree")

    withQttLocalDecl `x .default (annotateMult .one (mkConst ``Nat)) fun x => do
      let bifFn := Expr.const (Name.mkStr `Fake "bifUSize") []
      let e := mkAppN bifFn #[mkConst ``Bool.true, x, x]
      checkQttUses e
      check "synthetic bifUSize both arms OK" true

    withQttLocalDecl `x .default (annotateMult .one (mkConst ``Nat)) fun x => do
      withQttLocalDecl `y .default (annotateMult .one (mkConst ``Nat)) fun y => do
        let bifFn := Expr.const (Name.mkStr `Fake "bifUSize") []
        let e := mkAppN bifFn #[mkConst ``Bool.true, x, y]
        expectFail "synthetic bifUSize distinct linear pure-fvar arms rejected" (checkQttUses e)
          (needle := "control-flow paths disagree")

    withQttLocalDecl `x .default (annotateMult .one (mkConst ``Nat)) fun x => do
      let bifFn := Expr.const (Name.mkStr `Fake "bifBool") []
      let e := mkAppN bifFn #[mkConst ``Bool.true, x, x]
      checkQttUses e
      check "synthetic bifBool both arms OK" true

    withQttLocalDecl `x .default (annotateMult .one (mkConst ``Nat)) fun x => do
      withQttLocalDecl `y .default (annotateMult .one (mkConst ``Nat)) fun y => do
        let bifFn := Expr.const (Name.mkStr `Fake "bifBool") []
        let e := mkAppN bifFn #[mkConst ``Bool.true, x, y]
        expectFail "synthetic bifBool distinct linear pure-fvar arms rejected" (checkQttUses e)
          (needle := "control-flow paths disagree")

    -- bifArena / bifMMap: freestanding region splitters (trusted macros product-side; app-form still path-merges)
    withQttLocalDecl `x .default (annotateMult .one (mkConst ``Nat)) fun x => do
      let bifFn := Expr.const (Name.mkStr `Fake "bifArena") []
      let e := mkAppN bifFn #[mkConst ``Bool.true, x, x]
      checkQttUses e
      check "synthetic bifArena both arms OK" true

    withQttLocalDecl `x .default (annotateMult .one (mkConst ``Nat)) fun x => do
      withQttLocalDecl `y .default (annotateMult .one (mkConst ``Nat)) fun y => do
        let bifFn := Expr.const (Name.mkStr `Fake "bifArena") []
        let e := mkAppN bifFn #[mkConst ``Bool.true, x, y]
        expectFail "synthetic bifArena distinct linear pure-fvar arms rejected" (checkQttUses e)
          (needle := "control-flow paths disagree")

    withQttLocalDecl `x .default (annotateMult .one (mkConst ``Nat)) fun x => do
      let bifFn := Expr.const (Name.mkStr `Fake "bifMMap") []
      let e := mkAppN bifFn #[mkConst ``Bool.true, x, x]
      checkQttUses e
      check "synthetic bifMMap both arms OK" true

    withQttLocalDecl `x .default (annotateMult .one (mkConst ``Nat)) fun x => do
      withQttLocalDecl `y .default (annotateMult .one (mkConst ``Nat)) fun y => do
        let bifFn := Expr.const (Name.mkStr `Fake "bifMMap") []
        let e := mkAppN bifFn #[mkConst ``Bool.true, x, y]
        expectFail "synthetic bifMMap distinct linear pure-fvar arms rejected" (checkQttUses e)
          (needle := "control-flow paths disagree")

    -- Match edge: Option.casesOn with distinct linear pure-fvar minors must path-merge fail
    withQttLocalDecl `x .default (annotateMult .one (mkConst ``Nat)) fun x => do
      withQttLocalDecl `y .default (annotateMult .one (mkConst ``Nat)) fun y => do
        let α := mkConst ``Nat
        let optTy := mkApp (mkConst ``Option [Level.one]) α
        let motive := mkLambda `o .default optTy (mkConst ``Nat)
        let major := mkApp (mkConst ``Option.none [Level.one]) α
        -- noneAlt = x, someAlt ignores field and returns y → distinct pure-fvar-shaped remainders
        let someAlt := mkLambda `a .default α y
        let e := mkAppN (mkConst ``Option.casesOn [Level.one, Level.one])
          #[α, motive, major, x, someAlt]
        expectFail "Option.casesOn distinct linear arm remainders rejected" (checkQttUses e)
          (needle := "control-flow paths disagree")

    -- Metavariable hole does not discharge linear (fail-closed silent-drop at scope exit)
    withQttLocalDecl `x .default (annotateMult .one (mkConst ``Nat)) fun x => do
      let m ← mkFreshExprMVar (some (mkConst ``Nat))
      let dropAroundHole :=
        mkLambda `y .default (annotateMult .one (mkConst ``Nat)) m
      expectFail "mvar hole does not discharge linear (silent drop)" (checkQttUses dropAroundHole)

    -- let-bound linear: used once OK; silent drop / double-use rejected (letE path in UseCheck)
    do
      let e := mkLet `y (annotateMult .one (mkConst ``Nat)) (mkNatLit 1) (mkBVar 0)
      checkQttUses e
      check "let-bound linear used once OK" true
    do
      let e := mkLet `y (annotateMult .one (mkConst ``Nat)) (mkNatLit 1) (mkConst ``Nat.zero)
      expectFail "let-bound linear silent drop rejected" (checkQttUses e)
    -- letE body double-consume of the introduced linear (not just top-level lambda params)
    do
      let f :=
        mkLambda `a .default (mkConst ``Nat) <|
        mkLambda `b .default (mkConst ``Nat) (mkConst ``Nat.zero)
      let e :=
        mkLet `y (annotateMult .one (mkConst ``Nat)) (mkNatLit 1) (mkApp2 f (mkBVar 0) (mkBVar 0))
      expectFail "let-bound linear double-use rejected" (checkQttUses e)

    -- `@[fs_borrow]` top telescope (Meta config): linear param may remain unused
    do
      let dropLin :=
        mkLambda `x .default (annotateMult .one (mkConst ``Nat)) (mkConst ``Nat.zero)
      checkQttUses dropLin { borrowTopParams := true }
      check "borrowTopParams allows unused linear param" true
    -- borrowTopParams: multi bare-use of top linear is borrow (not double-consume)
    do
      let f :=
        mkLambda `a .default (mkConst ``Nat) <|
        mkLambda `b .default (mkConst ``Nat) (mkConst ``Nat.zero)
      let e :=
        mkLambda `x .default (annotateMult .one (mkConst ``Nat)) (mkApp2 f (mkBVar 0) (mkBVar 0))
      checkQttUses e { borrowTopParams := true }
      check "borrowTopParams multi-use of linear param OK" true
    -- Owned let under borrowTop still fail-closes silent drop of the let-bound linear
    do
      let e :=
        mkLambda `x .default (annotateMult .one (mkConst ``Nat)) <|
          mkLet `y (annotateMult .one (mkConst ``Nat)) (mkNatLit 1) (mkConst ``Nat.zero)
      expectFail "let-bound linear silent drop under borrowTop rejected"
        (checkQttUses e { borrowTopParams := true })

  -- freestanding option enables the same checker
  withOptions (fun o => compiler.freestanding.set o true) do
    withQttLocalDecl `x .default (annotateMult .one (mkConst ``Nat)) fun x => do
      let f :=
        mkLambda `a .default (mkConst ``Nat) <|
        mkLambda `b .default (mkConst ``Nat) (mkConst ``Nat.zero)
      expectFail "double-use under freestanding rejected" (checkQttUses (mkApp2 f x x))
    -- freestanding also fail-closes Eq.ndrec (same allowlist as compiler.qtt)
    withQttLocalDecl `x .default (annotateMult .one (mkConst ``Nat)) fun x => do
      let e := mkApp (mkConst ``Eq.ndrec [Level.one, Level.one]) x
      expectFail "Eq.ndrec under freestanding rejected" (checkQttUses e)

  check "still classic outside withOptions" (!isQttMode (← getEnv) (← getOptions))
  IO.println "qtt_use_check MetaM: all cases passed"

-- Production PreDefinition + LCNF AffineCheck under compiler.qtt (computable).
set_option compiler.qtt true

def qttUseId (x : QttUseTok) : QttUseTok := x

def qttUseOmega (n : Nat) : Nat := n + n

/-- Real Bool `if` (typically `cond` / cases): linear once per branch; AffineCheck + UseCheck. -/
def qttIf (b : Bool) (x : QttUseTok) : QttUseTok := if b then x else x

/-- Real `match` (matcher → capturing fun + cases): linear once per arm. -/
def qttMatch (b : Bool) (x : QttUseTok) : QttUseTok :=
  match b with
  | true => x
  | false => x

/-- Match with linear field binders in arms (forget before merge). -/
def qttMatchOpt (o : Option QttUseTok) : QttUseTok :=
  match o with
  | none => QttUseTok.mk
  | some x => x

/-- `@[fs_borrow]`: may leave linear param unused (borrowed). -/
@[fs_borrow]
def qttPeek (_x : QttUseTok) : Bool := true

/-- Use after freestanding borrow does not consume. -/
def qttAfterBorrow (x : QttUseTok) : QttUseTok :=
  let _b := qttPeek x
  x

/-- Theorem bodies are not QTT-checked (would silent-drop `x` as a def). -/
theorem qttThmSkip (x : QttUseTok) : True := trivial

/--
error: freestanding QTT: double use of linear (multiplicity 1) value `x` (variable occurrence); linear resources must be used exactly once
-/
#guard_msgs in
def qttUseDouble (x : QttUseTok) (f : QttUseTok → QttUseTok → QttUseTok) : QttUseTok := f x x

/--
error: freestanding QTT: silent drop of linear (multiplicity 1) value `x`; must be consumed exactly once (move / free / return)
-/
#guard_msgs in
def qttUseDrop (x : QttUseTok) : Nat := 0

/--
error: freestanding QTT: control-flow paths disagree on linear (multiplicity 1) uses: [`x` (remaining 0 vs 1 on alternate paths)]; each linear resource must be used exactly once on every path
-/
#guard_msgs in
def qttIfDrop (b : Bool) (x : QttUseTok) : QttUseTok := if b then x else QttUseTok.mk
