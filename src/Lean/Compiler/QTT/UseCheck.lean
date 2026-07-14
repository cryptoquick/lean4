/-
Copyright (c) 2026 Lean FRO, LLC. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Hunter Beast
-/
module

prelude
public import Lean.Meta.Basic
public import Lean.Meta.InferType
public import Lean.Meta.Match.MatcherInfo
public import Lean.Util.CollectFVars
public import Lean.AuxRecursor
public import Lean.Compiler.AffineAttr
public import Lean.Compiler.Multiplicity
public import Lean.Compiler.QTT.ElabCheck

/-!
# QTT elaborator use/split checker (Idris-class, opt-in)

`checkQttUses` walks an elaborated term under Meta and enforces quantitative use rules
when `compiler.freestanding` or `compiler.qtt` is on (`qttEnabled` / `isQttMode`):

| Qty | Rule at runtime |
|-----|-----------------|
| **0** | Erased — must not appear in a runtime position |
| **1** | Linear — consume **exactly once** (double-use and silent drop are errors) |
| **ω** | Unrestricted — free copy / drop |

**Application:** each runtime argument consumes uses in its subterm. Binder multiplicity
from `multOfLocalType` marks **erased** arg positions (no runtime consume). Callees tagged
`@[fs_borrow]` **borrow** linear args (use without consume) — borrow ≠ move.

**Control-flow split (recognized allowlist only):**

| Form | Shared prefix | Alternatives |
|------|---------------|--------------|
| `ite` / `dite` | type + condition + `Decidable` (3 args) | then, else |
| `cond` | type + Bool scrutinee (2 args) | then, else |
| freestanding `bif*` | Bool scrutinee (1 arg) | then, else |
| `I.casesOn` | params + motive + indices + major (`InductiveVal`) | constructor minors |
| matchers (`Match.MatcherInfo`) | params + motive + discrs | arms (`getFirstAltPos` / `numAlts`) |

Paths must agree on **outer** linear remainders (merge only fvars from the pre-split
state). Binders introduced inside λ/let/arms are popped before returning to the parent.

**Fail-closed product surface:** only the allowlist above is path-merged. Other multi-arm
control shapes are **rejected with an error** — never silently sequential-consumed:

* raw `.rec` (`isRecCore`)
* any non-`casesOn` aux recursor (`isAuxRecursor` ∧ ¬`isCasesOn`): `.recOn`, `.brecOn`,
  `Eq.ndrec` / `Eq.ndrecOn` / `Eq.ndrec_symm`, …
* sparse casesOn / constructor eliminators (`isSparseCasesOn`)
* `noConfusion` eliminators (`isNoConfusion`)
* named non-allowlist eliminators: `WellFounded.fix` / `WellFounded.fixF`,
  `Quot.lift` / `Quot.ind` / `Quot.liftOn`

This is **intentionally conservative**: even pure-ω eliminators such as `Nat.rec` /
`Eq.rec` / `Eq.ndrec` / `Nat.recOn` fail under QTT so residual multi-arm CF cannot
miscount linears. Prefer `ite`/`cond`/`bif*`/`casesOn`/matchers. Elaborated `match` that
becomes a registered matcher is split as above. LCNF `AffineCheck` remains the freestanding
path-sensitive enforcer for regions / UAF; freestanding product code should stick to
`bif*` / recognized `if`/`match`/`casesOn` so both layers agree. Classic Lean
(`compiler.qtt` and `compiler.freestanding` false) is a total no-op.

**Silent drop:** rejected for linear binders when remaining is still `1` at end of scope
(and for free linear fvars after a whole-term check).

**Metavariable / hole honesty:** `.mvar` occurrences are treated as non-consuming leaves
(same as literals/consts). Unassigned holes therefore **do not** discharge linear
resources — surrounding linears still fail silent-drop at scope exit (fail-closed for
incomplete terms). Assigned mvars are not forced-substituted here; prefer fully elaborated
values (as `Elab.PreDefinition` supplies) so consume sites are concrete fvars/apps.

**Classic Lean:** both options false → `checkQttUses` is a total no-op.

Wired from declaration elaboration (`Elab.PreDefinition`) under `isQttMode` so the check is
not test-only.

**Formal algebra:** free-safety policy lemmas (`useOnce` exact-once, 0-qty erase) live in
`Multiplicity.Theorems` / host `QTT.FreeSafety` — UseCheck **enforces** them operationally;
it does not restate the definitional proofs.
-/

namespace Lean.Compiler.QTT

open Meta

/-- Configuration for `checkQttUses`. -/
public structure QttUseConfig where
  /--
  Treat the outermost lambda telescope as `@[fs_borrow]` parameters: linear params may be
  used without being consumed and may remain at exit (returned to caller). Nested lambdas
  and lets are still owned.
  -/
  borrowTopParams : Bool := false
  deriving Inhabited

/-- Ownership / remaining multiplicity while walking a term. -/
structure QttUseState where
  /-- Remaining multiplicity for each tracked fvar. -/
  qty : FVarIdMap Multiplicity := {}
  /-- Introduced at multiplicity 1 (linear). -/
  linear : FVarIdSet := {}
  /-- Introduced at multiplicity 0 (erased). -/
  erased : FVarIdSet := {}
  /-- Borrowed linear params (`@[fs_borrow]` top telescope). -/
  borrowed : FVarIdSet := {}
  deriving Inhabited

/-- Recognized control-flow splitter layout. -/
structure SplitterLayout where
  /-- Index of first alternative argument (0-based). -/
  firstAlt : Nat
  /-- Number of alternative arms; `none` means “all remaining args”. -/
  numAlts? : Option Nat := none
  deriving Inhabited

private def fvarUserName (fvarId : FVarId) : MetaM Name := do
  match (← getLCtx).find? fvarId with
  | some d => pure d.userName
  | none => pure fvarId.name

private def throwQtt (msg : MessageData) : MetaM α :=
  throwError m!"freestanding QTT: {msg}"

/--
Layout of a recognized control-flow splitter, if any.

* `ite`/`dite`: `{α} → (c : Prop) → [Decidable c] → then → else` → alts start at **3**
* `cond`: `{α} → Bool → α → α` → alts start at **2**
* freestanding `bif*`: `Bool → τ → τ → τ` → alts start at **1**
* `I.casesOn`: params + motive + indices + major, then minors (`InductiveVal`)
* matchers: `MatcherInfo.getFirstAltPos` / `numAlts`
-/
private def splitterLayout? (fn : Name) : MetaM (Option SplitterLayout) := do
  let env ← getEnv
  match fn with
  -- Full elaborator apps include the Decidable instance at index 2.
  | ``ite | ``dite => return some { firstAlt := 3, numAlts? := some 2 }
  | ``cond => return some { firstAlt := 2, numAlts? := some 2 }
  | .str _ "bifU32" | .str _ "bifU64" | .str _ "bifUSize" | .str _ "bifBool" | .str _ "bifU8"
  | .str _ "bifArena" | .str _ "bifMMap" =>
    return some { firstAlt := 1, numAlts? := some 2 }
  | _ =>
    if let some minfo := getMatcherInfoCore? env fn then
      return some {
        firstAlt := Match.MatcherInfo.getFirstAltPos minfo
        numAlts? := some (Match.MatcherInfo.numAlts minfo)
      }
    else if isCasesOnRecursor env fn then
      match env.find? fn.getPrefix with
      | some (.inductInfo iv) =>
        -- params + motive + indices + major, then constructor minors
        let firstAlt := iv.numParams + 1 + iv.numIndices + 1
        return some { firstAlt, numAlts? := some iv.numCtors }
      | _ => return none
    else
      return none

/--
True when `fn` is multi-arm eliminator-like control flow that is **not** on the
recognized splitter allowlist. Used to fail closed instead of sequential consume.

Broader than suffix-only `recOn`/`brecOn`: any non-`casesOn` aux recursor (incl.
`Eq.ndrec*`), sparse casesOn, noConfusion, and named WF/Quot eliminators.
-/
private def isUnrecognizedMultiArm (fn : Name) : MetaM Bool := do
  let env ← getEnv
  if (← splitterLayout? fn).isSome then
    return false
  -- Raw recursor (Nat.rec, Eq.rec, Acc.rec, …).
  if isRecCore env fn then return true
  -- Any aux recursor that is not casesOn: recOn, brecOn, Eq.ndrec / ndrecOn / ndrec_symm, …
  -- (subsumes isRecOnRecursor / isBRecOnRecursor; catches ndrec which those miss).
  if isAuxRecursor env fn && !isCasesOnRecursor env fn then return true
  if isSparseCasesOn env fn then return true
  if isNoConfusion env fn then return true
  match fn with
  | ``WellFounded.fix | ``WellFounded.fixF
  | ``Quot.lift | ``Quot.ind | ``Quot.liftOn => return true
  | _ => return false

private def introduce (s : QttUseState) (fvarId : FVarId) (type : Expr) (borrowed : Bool) :
    MetaM QttUseState := do
  let m ← multOfLocalType type
  match m with
  | .zero =>
    pure { s with
      qty := s.qty.insert fvarId .zero
      erased := s.erased.insert fvarId }
  | .one =>
    pure { s with
      qty := s.qty.insert fvarId .one
      linear := s.linear.insert fvarId
      borrowed := if borrowed then s.borrowed.insert fvarId else s.borrowed }
  | .omega =>
    pure { s with qty := s.qty.insert fvarId .omega }

/-- Drop a binder from tracking when leaving its scope (so merge never sees alt-locals). -/
private def forget (s : QttUseState) (fvarId : FVarId) : QttUseState :=
  { s with
    qty := s.qty.erase fvarId
    linear := s.linear.erase fvarId
    erased := s.erased.erase fvarId
    borrowed := s.borrowed.erase fvarId }

/-- Runtime consume of one use of `fvarId` (move for linear; free for ω). -/
private def consume (s : QttUseState) (fvarId : FVarId) (what : MessageData) :
    MetaM QttUseState := do
  let name ← fvarUserName fvarId
  if s.borrowed.contains fvarId then
    -- Borrowed params: free use without consume (borrow ≠ move).
    pure s
  else
    match s.qty.get? fvarId with
    | none => pure s
    | some .omega => pure s
    | some .one =>
      pure { s with qty := s.qty.insert fvarId .zero }
    | some .zero =>
      if s.erased.contains fvarId then
        throwQtt m!"cannot use erased (multiplicity 0) value `{name}` at runtime ({what}); \
          erased values have no runtime residual"
      else if s.linear.contains fvarId then
        throwQtt m!"double use of linear (multiplicity 1) value `{name}` ({what}); \
          linear resources must be used exactly once"
      else
        pure s

/-- Ensure a borrowed arg is still available; do not consume linear. -/
private def ensureBorrow (s : QttUseState) (fvarId : FVarId) (what : MessageData) :
    MetaM Unit := do
  let name ← fvarUserName fvarId
  match s.qty.get? fvarId with
  | some .zero =>
    if s.erased.contains fvarId then
      throwQtt m!"cannot use erased (multiplicity 0) value `{name}` at runtime ({what}); \
        erased values have no runtime residual"
    else if s.linear.contains fvarId then
      throwQtt m!"use-after-consume of linear (multiplicity 1) value `{name}` ({what}); \
        cannot borrow after move"
    else
      pure ()
  | _ => pure ()

private def checkNotDropped (s : QttUseState) (fvarId : FVarId) : MetaM Unit := do
  if s.borrowed.contains fvarId then return
  unless s.linear.contains fvarId do return
  match s.qty.get? fvarId with
  | some .one =>
    let name ← fvarUserName fvarId
    throwQtt m!"silent drop of linear (multiplicity 1) value `{name}`; \
      must be consumed exactly once (move / free / return)"
  | _ => pure ()

/-- Seed tracking for free variables already present in the local context. -/
private def seedFromLCtx (e : Expr) (s : QttUseState) : MetaM QttUseState := do
  let used := collectFVars {} e
  let lctx ← getLCtx
  let mut s := s
  for fvarId in used.fvarIds do
    if (s.qty.get? fvarId).isSome then
      pure ()
    else if let some decl := lctx.find? fvarId then
      s ← introduce s fvarId decl.type (borrowed := false)
  pure s

/--
Merge two alternative states. Only fvars from the **pre-split** `base` context are
compared; binders introduced inside arms must already have been `forget`ten.
-/
private def mergeStates (base : QttUseState) (s1 s2 : QttUseState) : MetaM QttUseState := do
  let disagreements ← base.linear.foldlM (init := (#[] : Array MessageData)) fun acc fvarId => do
    let baseR := (base.qty.get? fvarId).getD .one
    let r1 := (s1.qty.get? fvarId).getD baseR
    let r2 := (s2.qty.get? fvarId).getD baseR
    if r1 != r2 then
      let name ← fvarUserName fvarId
      pure (acc.push m!"`{name}` (remaining {r1} vs {r2} on alternate paths)")
    else
      pure acc
  unless disagreements.isEmpty do
    throwQtt m!"control-flow paths disagree on linear (multiplicity 1) uses: {disagreements}; \
      each linear resource must be used exactly once on every path"
  -- Project s1 remainders onto the base domain (alts may have temporary locals already forgotten).
  let qty ← base.qty.foldlM (init := ({} : FVarIdMap Multiplicity)) fun acc fvarId baseR => do
    let r := (s1.qty.get? fvarId).getD baseR
    pure (acc.insert fvarId r)
  pure { base with qty }

mutual

partial def visitRuntime (e : Expr) (s : QttUseState) : MetaM QttUseState := do
  match e with
  | .mdata _ b => visitRuntime b s
  | .fvar fvarId => consume s fvarId "variable occurrence"
  | .lit _ | .const _ _ | .sort _ | .bvar _ | .mvar _ => pure s
  | .proj _ _ st => visitRuntime st s
  | .app .. => visitApp e.getAppFn e.getAppArgs s
  | .lam n d b bi =>
    withLocalDecl n bi d fun x => do
      let s ← introduce s x.fvarId! d (borrowed := false)
      let s ← visitRuntime (b.instantiate1 x) s
      checkNotDropped s x.fvarId!
      pure (forget s x.fvarId!)
  | .letE n t v b _ =>
    let s ← visitRuntime v s
    withLetDecl n t v fun x => do
      let s ← introduce s x.fvarId! t (borrowed := false)
      let s ← visitRuntime (b.instantiate1 x) s
      checkNotDropped s x.fvarId!
      pure (forget s x.fvarId!)
  | .forallE .. =>
    pure s

/-- Visit an application, honoring binder multiplicities, `@[fs_borrow]`, and splitters. -/
partial def visitApp (fn : Expr) (args : Array Expr) (s : QttUseState) : MetaM QttUseState := do
  if let some fnName := fn.constName? then
    if let some layout ← splitterLayout? fnName then
      if layout.firstAlt ≤ args.size then
        return (← visitBranching fn args layout s)
      -- Partial application of a known splitter: treat args sequentially (no false merge).
    else if (← isUnrecognizedMultiArm fnName) then
      -- Fail closed: never sequential-consume multi-arm CF (would miscount linears).
      throwQtt m!"unrecognized multi-arm control-flow `{fnName}`; \
        freestanding QTT only path-merges ite/dite/cond/bif*/casesOn/matchers \
        (not raw rec/recOn/brecOn/ndrec/sparse casesOn/noConfusion/WF.fix/Quot.lift)"
  let env ← getEnv
  let borrowAll :=
    match fn.constName? with
    | some n => isFsBorrowDecl env n
    | none => false
  let s ← visitRuntime fn s
  visitArgs fn args s borrowAll

partial def visitArgs (fn : Expr) (args : Array Expr) (s : QttUseState) (borrowAll : Bool) :
    MetaM QttUseState := do
  let fType ←
    try inferType fn
    catch _ => pure (mkSort Level.zero)
  let mut s := s
  let mut fType := fType
  for arg in args do
    fType ← whnf fType
    match fType with
    | .forallE _ d b _ =>
      let m ← multOfLocalType d
      if m.isErased then
        pure ()
      else if borrowAll then
        s ← visitBorrowArg arg s
      else
        s ← visitRuntime arg s
      fType := b.instantiate1 arg
    | _ =>
      s ← visitRuntime arg s
  pure s

/-- `@[fs_borrow]` arg: bare linear fvar is used without consume; complex args walk nested uses. -/
partial def visitBorrowArg (e : Expr) (s : QttUseState) : MetaM QttUseState := do
  match e.consumeMData with
  | .fvar fvarId =>
    ensureBorrow s fvarId "freestanding borrow (`@[fs_borrow]`; borrow ≠ consume)"
    pure s
  | _ => visitRuntime e s

/-- Shared prefix then split alternatives; merge linear remainders on the pre-split domain.

**Same pure-fvar on every arm:** when all alternatives are the *same* bare fvar
(`if b then x else x` / `cond b x x`), each path returns that one linear once. Path merge
already accepts this; the same-fvar fast path is equivalent (single consume).

**Distinct pure-fvar arms** (`if b then x else y` with linear `x,y`) must **not** be treated
as exclusive select that consumes every arm: the non-selected linear would leak. Those
cases go through normal path merge and are rejected (remainders disagree). Affine exclusive
selectors such as freestanding `bifArena`/`bifMMap` are trusted macros (see PreDefinition
skip) with LCNF AffineCheck owning region ownership. -/
partial def visitBranching (fn : Expr) (args : Array Expr) (layout : SplitterLayout)
    (s : QttUseState) : MetaM QttUseState := do
  let firstAlt := layout.firstAlt
  let shared := args.extract 0 firstAlt
  let numAlts := layout.numAlts?.getD (args.size - firstAlt)
  let altEnd := min args.size (firstAlt + numAlts)
  let alts := args.extract firstAlt altEnd
  let remaining := args.extract altEnd args.size
  let env ← getEnv
  let borrowAll :=
    match fn.constName? with
    | some n => isFsBorrowDecl env n
    | none => false
  let s ← visitArgs fn shared s borrowAll
  let s ←
    if alts.isEmpty then
      pure s
    else
      let pureFvars := alts.filterMap fun a =>
        match a.consumeMData with
        | .fvar f => some f
        | _ => none
      -- Same-fvar-only fast path (all arms the identical fvar). Distinct pure fvars fall
      -- through to path merge (fail on residual disagreement — no silent leak of other arm).
      if pureFvars.size == alts.size && alts.size ≥ 2 then
        match pureFvars[0]? with
        | some f0 =>
          if pureFvars.all (· == f0) then
            consume s f0 "same pure-fvar on every control-flow arm"
          else
            let mut acc? : Option QttUseState := none
            for alt in alts do
              let si ← visitRuntime alt s
              match acc? with
              | none => acc? := some si
              | some acc => acc? := some (← mergeStates s acc si)
            pure (acc?.getD s)
        | none => pure s
      else
        let mut acc? : Option QttUseState := none
        for alt in alts do
          let si ← visitRuntime alt s
          match acc? with
          | none => acc? := some si
          | some acc => acc? := some (← mergeStates s acc si)
        pure (acc?.getD s)
  if remaining.isEmpty then
    pure s
  else
    -- Over-applied splitter (rare): remaining args sequential after join.
    visitArgs fn remaining s borrowAll

/-- Outermost lambda telescope (optional `@[fs_borrow]` params), then body. -/
partial def visitTop (e : Expr) (borrowTop : Bool) (s : QttUseState) : MetaM QttUseState := do
  match e with
  | .mdata _ b => visitTop b borrowTop s
  | .lam n d b bi =>
    withLocalDecl n bi d fun x => do
      let s ← introduce s x.fvarId! d (borrowed := borrowTop)
      let s ← visitTop (b.instantiate1 x) borrowTop s
      checkNotDropped s x.fvarId!
      pure (forget s x.fvarId!)
  | _ =>
    visitRuntime e s

end

/--
Check quantitative uses in elaborated term `e`.

No-op unless `qttEnabled` (`compiler.freestanding` or `compiler.qtt`).
On failure, throws with multiplicity and rule named (Idris-like clarity).
-/
public def checkQttUses (e : Expr) (config : QttUseConfig := {}) : MetaM Unit := do
  unless (← qttEnabled) do return
  let s ← seedFromLCtx e {}
  let s ← visitTop e config.borrowTopParams s
  for fvarId in s.linear do
    checkNotDropped s fvarId

/--
Check a declaration value under QTT mode. `borrowTopParams` should be true when the decl
carries `@[fs_borrow]` (attribute may not yet be in the environment at elab time).
-/
public def checkQttUsesDecl (value : Expr) (borrowTopParams : Bool := false) : MetaM Unit :=
  checkQttUses value { borrowTopParams }

end Lean.Compiler.QTT
