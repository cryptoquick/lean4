/-
Copyright (c) 2026 Lean FRO, LLC. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Hunter Beast
-/
module

prelude
public import Lean.Meta.Basic
public import Lean.Meta.InferType
public import Lean.Compiler.Multiplicity
public import Lean.Compiler.Options
public import Lean.Compiler.Freestanding

/-!
# QTT elaborator-facing checks (opt-in)

Runs only when `compiler.freestanding` or `compiler.qtt` is set.
Classic Lean elaborator paths are unaffected when both are false.

This module provides **Idris-class** helpers for binder multiplicity and
0-quantity residual policy that elaborators and tests can call.

**Use/split** of linear values at elaboration time is `QTT.UseCheck.checkQttUses`
(wired from `Elab.PreDefinition` under `isQttMode`). LCNF `AffineCheck` remains
the freestanding path-sensitive enforcer (regions, UAF, extract).

## Binder multiplicities (R1)

**Lookup** always returns 0/1/ω:
* Pure: `getBinderMult` / `getBinderMultOfType` (attrs, `Prop`/`lcErased`/sorts, mdata)
* Meta: `multOfLocalType` / `getLocalBinderMult` (adds `isProp` → 0 for Prop-valued types)

**Explicit mdata** (`annotateMult`) is attached by QTT introduce helpers
(`withQttLocalDecl`, `withQttLetDecl`, `forallTelescopeQtt`). Production elaborator
paths still use plain `withLocalDecl`; defaults alone define mult until those helpers
(or freestanding wiring) are used. LCNF drops most mdata — AffineCheck uses
attrs + `lcErased` + surviving mdata via `getBinderMultOfType`.
-/

namespace Lean.Compiler.QTT

open Meta

/-- Whether QTT rules apply in the current Meta/Core options. -/
public def qttEnabled : MetaM Bool := do
  let env ← getEnv
  let opts ← getOptions
  pure (isQttMode env opts)

/--
Multiplicity of a binder type (Meta-aware policy).

1. Explicit `qtt.mult` mdata  
2. Else `isProp type` → **0** (proofs have no runtime residual)  
3. Else pure `binderMultiplicity` (attrs / Prop const / `lcErased` / sorts / ω)

This is the **single Meta policy**. Pure `getBinderMult` omits step 2; after
`withQttLocalDecl` writes mdata, pure and Meta agree.
-/
public def multOfLocalType (type : Expr) : MetaM Multiplicity := do
  if let some m := multAnnotation? type then
    return m
  if (← isProp type) then
    return Multiplicity.zero
  let env ← getEnv
  pure (binderMultiplicity env type)

/--
Lookup multiplicity of a live local via Meta policy (`multOfLocalType` on the decl type).

Equivalent pure path: `getBinderMult env lctx fvar` after QTT introduce has written mdata.
-/
public def getLocalBinderMult (fvarId : FVarId) : MetaM Multiplicity := do
  let lctx ← getLCtx
  match lctx.find? fvarId with
  | none => pure Multiplicity.omega
  | some decl => multOfLocalType decl.type

/-- Fail if a value of multiplicity 0 is used in a runtime/export position. -/
public def checkNotErasedRuntime (type : Expr) (what : MessageData) : MetaM Unit := do
  unless (← qttEnabled) do return
  let m ← multOfLocalType type
  if m.isErased then
    throwError m!"freestanding QTT: erased (multiplicity 0) value cannot be used at runtime ({what})"

/-- Fail if a linear (1) resource type is treated as freely copyable (documentation helper). -/
public def checkLinearNotUnrestricted (type : Expr) (what : MessageData) : MetaM Unit := do
  unless (← qttEnabled) do return
  let m ← multOfLocalType type
  if m.isLinear then
    pure ()  -- linear is expected for resources
  else if m.isErased then
    throwError m!"freestanding QTT: unexpected erased type where linear resource expected ({what})"
  else
    pure ()

/--
Ensure binder type has explicit mult (Meta-aware: propositions → 0).
If already annotated, leave unchanged.
-/
public def ensureExplicitMultM (type : Expr) : MetaM Expr := do
  if (multAnnotation? type).isSome then
    return type
  let m ← multOfLocalType type
  pure (annotateMult m type)

/--
Annotate binder type when QTT is on (Meta-aware defaults including Prop → 0).
Classic Lean: identity.
-/
public def annotateBinderTypeIfQttM (type : Expr) : MetaM Expr := do
  if (← qttEnabled) then ensureExplicitMultM type else pure type

/--
Introduce a local binder, annotating its type with an explicit multiplicity when QTT is on.
Classic Lean (`qttEnabled = false`): identical to `withLocalDecl`.
-/
public def withQttLocalDecl (name : Name) (bi : BinderInfo) (type : Expr) (k : Expr → MetaM α)
    (kind : LocalDeclKind := .default) : MetaM α := do
  let type ← annotateBinderTypeIfQttM type
  withLocalDecl name bi type k kind

/--
Introduce a let binder with explicit multiplicity on the type when QTT is on.
Classic Lean: identical to `withLetDecl`.
-/
public def withQttLetDecl (name : Name) (type : Expr) (value : Expr) (k : Expr → MetaM α)
    (nondep : Bool := false) (kind : LocalDeclKind := .default) : MetaM α := do
  let type ← annotateBinderTypeIfQttM type
  withLetDecl name type value k nondep kind

/--
`forallTelescope` under QTT: each domain is annotated with Meta-aware mult under a real lctx.

**Instantiate-as-you-go:** after each binder, recurse on `b.instantiate1 x` so remainders are
closed under the current local context. `whnf` only runs on closed terms (safe for dependent
and reducing telescopes, e.g. abbreviations that expand to further foralls). Outside QTT mode:
plain `forallTelescope`.
-/
public partial def forallTelescopeQtt (type : Expr) (k : Array Expr → Expr → MetaM α) : MetaM α := do
  if !(← qttEnabled) then
    forallTelescope type k
  else
    let rec go (type : Expr) (fvars : Array Expr) : MetaM α := do
      -- `type` is closed w.r.t. this telescope's binders (instantiate-as-you-go).
      let type ← whnf type
      match type with
      | .forallE n d b bi =>
        let d ← ensureExplicitMultM d
        withLocalDecl n bi d fun x =>
          go (b.instantiate1 x) (fvars.push x)
      | _ =>
        k fvars type
    go type #[]

/-- Summarize binder multiplicities for a telescope (pure policy on domains). -/
public def binderMultsOfTelescope (type : Expr) : MetaM (List Multiplicity) := do
  let env ← getEnv
  let rec go (e : Expr) (acc : List Multiplicity) : List Multiplicity :=
    match e with
    | .forallE _ d b _ => go b (acc ++ [binderMultiplicity env d])
    | .mdata _ b => go b acc
    | _ => acc
  pure (go type [])

/-- Meta-aware telescope walk; same instantiate-as-you-go / closed-term `whnf` as `forallTelescopeQtt`. -/
private partial def binderMultsOfTelescopeMeta (type : Expr) : MetaM (List Multiplicity) := do
  let rec go (type : Expr) (acc : List Multiplicity) : MetaM (List Multiplicity) := do
    let type ← whnf type
    match type with
    | .forallE n d b bi =>
      let m ← multOfLocalType d
      withLocalDecl n bi d fun x =>
        go (b.instantiate1 x) (acc ++ [m])
    | _ => pure acc
  go type []

/--
Meta-aware telescope mult list: introduce binders under a real lctx, use `multOfLocalType`
per domain (Prop-valued → 0; mdata when present). Under QTT, domains get explicit mdata.
-/
public def binderMultsOfTelescopeExplicit (type : Expr) : MetaM (List Multiplicity) := do
  if !(← qttEnabled) then
    binderMultsOfTelescopeMeta type
  else
    forallTelescopeQtt type fun xs _ => do
      xs.foldlM (init := ([] : List Multiplicity)) fun acc x => do
        let m ← getLocalBinderMult x.fvarId!
        pure (acc ++ [m])

/--
Register an explicit multiplicity on a type for binder introduction (tests / elab hooks).
Always uses `annotateMult` (does not consult QTT mode). Prefer `withQttLocalDecl` for mode-gated intro.
-/
public def annotateLocalType (m : Multiplicity) (type : Expr) : Expr :=
  annotateMult m type

end Lean.Compiler.QTT
