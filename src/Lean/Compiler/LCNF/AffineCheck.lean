/-
Copyright (c) 2026 Lean FRO, LLC. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Hunter Beast
-/
module

prelude
public import Lean.Compiler.LCNF.PassManager
public import Lean.Compiler.AffineAttr
public import Lean.Compiler.Multiplicity
public import Lean.Compiler.Options
public import Lean.Compiler.Freestanding

/-!
# Freestanding quantitative / linear resource checker (QTT + N2 / S2 / S3 / S5)

**QTT multiplicities** (Idris 2–class, freestanding extract):

* **0** — erased; no runtime residual in product C  
* **1** — linear (`@[affine]` / `@[linear]` resources): use **exactly once**  
* **ω** — unrestricted (scalars / pure data)

Move-only ownership for multiplicity-**1** types in freestanding modules:

* each live affine value may be **used once** (move);
* `@[fs_borrow]` callees borrow affine args (no move) — not RC `@&` (K15);
* silent discard of an affine value without consume/return is an error;
* enclosing `@[fs_borrow]` decls: affine params are **borrowed** (cannot move/close; may remain at exit);
* non-`fs_borrow` decls: affine params are **owned** (must close/return — no ownership sinks);
* projection of affine values is rejected (no `fd.raw` escape hatch).

**S3/S5 region stamps (N3):** each affine value carries a region id and each region has a **root type**
(the type that created it: `Arena`, `Fd`, `MallocBuf`, `MMap`, …). `Arena.alloc` transfers the region;
`@[fs_borrow]` results whose type **differs** from the borrowed arg (`lastPtr` → `BytePtr`) derive
the stamp — **unless** the callee is also `@[fs_fresh_region]` (`sysMmap` → independent `MMap`).
**Same-type** `@[fs_borrow]` affine results (e.g. `peek : Arena → Arena`) are a hard
error (dual ownership / double-free). Region kill runs only when the **root type** is consumed by
a free/close-style call — free of a derived stamp alone does not kill the arena.

Runs when freestanding emit or `compiler.qtt` is active (`isQttMode`).
Phase: **base** (before mono trivial-structure unboxing erases affine type names).

**Match / local fun:** LCNF lowers `match`/`bif` to a capturing `fun` applied once per
`cases` arm. Free linear captures of that fun are consumed at each call site (`funCaptures`),
so once-per-arm use of an outer linear agrees with elaborator `QTT.UseCheck`.
-/

namespace Lean.Compiler.LCNF

/-- Ownership state for one control-flow path. -/
structure AffineState where
  /-- Affine fvars still owned (not yet moved). -/
  owned : FVarIdSet := {}
  /-- All affine fvars introduced on this path (owned or already moved). -/
  known : FVarIdSet := {}
  /-- Affine parameters of a `@[fs_borrow]` enclosing decl: cannot be moved; may remain at exit. -/
  borrowedParams : FVarIdSet := {}
  /-- Region stamp for each known affine fvar (owners and derived buffers share a stamp). -/
  regionOf : FVarIdMap Nat := {}
  /-- Affine type constructor name for each known affine fvar (for alloc transfer). -/
  typeOf : FVarIdMap Name := {}
  /-- Root type name that created each region (only free of this type kills the region). -/
  rootTypeOfRegion : Std.TreeMap Nat Name (compare · ·) := {}
  /-- Regions invalidated by free/close of the region root. -/
  deadRegions : Std.TreeSet Nat (compare · ·) := {}
  /-- Next fresh region id. -/
  nextRegion : Nat := 0
  /-- Region to stamp onto the next introduced affine let (transfer or derive). -/
  stampNext? : Option Nat := none
  /-- QTT multiplicity remaining for each tracked fvar (`1` while owned; `0` after consume). -/
  qtyOf : FVarIdMap Compiler.Multiplicity := {}
  /--
  Local `fun` / `jp` binders: free **outer** linear fvars mentioned in the body.
  Match lowers to a capturing lambda applied once per arm; each application must
  consume those captures (like inlining the body at the call site). Without this,
  `return x` inside the lambda is invisible to the outer path and AffineCheck
  false-reports silent drop of `x` after the arm returns a fresh result.
  -/
  funCaptures : FVarIdMap FVarIdSet := {}
  deriving Inhabited

private def throwAffine (msg : MessageData) : CompilerM α :=
  throwError m!"freestanding affine: {msg}"

private def throwQTT (msg : MessageData) : CompilerM α :=
  throwError m!"freestanding QTT: {msg}"

/-- Type constructor name for linear/affine resources. -/
private def linearTypeName? (env : Environment) (type : Expr) : Option Name :=
  match affineTypeName? env type with
  | some n => some n
  | none =>
    match type with
    | .const n _ => if Compiler.isLinearType env type then some n else none
    | .app f _ => linearTypeName? env f
    | .mdata _ b => linearTypeName? env b
    | _ => none

private def isRegionDead (s : AffineState) (fvarId : FVarId) : Bool :=
  match s.regionOf.get? fvarId with
  | some r => s.deadRegions.contains r
  | none => false

/-- Drop ownership of every affine fvar stamped with region `r` and mark the region dead. -/
private def killRegion (s : AffineState) (r : Nat) : AffineState :=
  let owned := s.regionOf.foldl (init := s.owned) fun acc f r' =>
    if r' == r then acc.erase f else acc
  { s with
    owned
    deadRegions := s.deadRegions.insert r
    stampNext? := none }

/--
Introduce a binder and set `qtyOf` from `getBinderMultOfType` (attrs / `lcErased` / mdata if present).

* **0** — track erased; runtime use rejected in `move`
* **1** — linear exact-once: always `owned` + `qtyOf.one`; region stamps only when
  `linearTypeName?` finds an affine/linear resource type
* **ω** — unrestricted (`qtyOf.omega` only)

LCNF note: `toLCNFType` strips most mdata; enforcement relies on attrs + `lcErased` → 0.
Explicit `annotateMult` is honored when mdata still remains on the type.
-/
private def introduce (env : Environment) (s : AffineState) (fvarId : FVarId) (type : Expr)
    (borrowedParam : Bool := false) : AffineState :=
  -- Function *values* are unrestricted (ω). `multiplicityOfType` walks `forall` to the
  -- result (so `Unit → Tok` looks like Tok / linear); that must not mark local funs
  -- or match-arm closures as owned linears — only runtime Tok-like payloads.
  let mult :=
    if type.isForall then Compiler.Multiplicity.omega
    else Compiler.getBinderMultOfType env type
  match mult with
  | .zero =>
    { s with
      known := s.known.insert fvarId
      qtyOf := s.qtyOf.insert fvarId .zero
      stampNext? := none }
  | .one =>
    match linearTypeName? env type with
    | some tyName =>
      let isFresh := s.stampNext?.isNone
      let r := s.stampNext?.getD s.nextRegion
      let next := if isFresh then s.nextRegion + 1 else s.nextRegion
      let rootTypeOfRegion :=
        if isFresh then s.rootTypeOfRegion.insert r tyName else s.rootTypeOfRegion
      { s with
        owned := s.owned.insert fvarId
        known := s.known.insert fvarId
        borrowedParams := if borrowedParam then s.borrowedParams.insert fvarId else s.borrowedParams
        regionOf := s.regionOf.insert fvarId r
        typeOf := s.typeOf.insert fvarId tyName
        rootTypeOfRegion
        deadRegions := s.deadRegions
        nextRegion := next
        stampNext? := none
        qtyOf := s.qtyOf.insert fvarId .one }
    | none =>
      -- Linear non-resource (e.g. surviving `annotateMult .one`): exact-once, no region.
      { s with
        owned := s.owned.insert fvarId
        known := s.known.insert fvarId
        borrowedParams := if borrowedParam then s.borrowedParams.insert fvarId else s.borrowedParams
        qtyOf := s.qtyOf.insert fvarId .one
        stampNext? := none }
  | .omega =>
    { s with
      qtyOf := s.qtyOf.insert fvarId .omega
      stampNext? := none }

/-- Move (consume) a linear (QTT 1) fvar. Does **not** kill its region (caller decides free vs transfer). -/
private def move (s : AffineState) (fvarId : FVarId) (what : String) : CompilerM AffineState := do
  if s.borrowedParams.contains fvarId then
    throwAffine m!"cannot move freestanding-borrowed parameter `{fvarId.name}` ({what}); \
      `@[fs_borrow]` bodies must not close/consume affine params"
  if isRegionDead s fvarId then
    throwAffine m!"use-after-free of affine value `{fvarId.name}` ({what})"
  match s.qtyOf.get? fvarId with
  | some .zero =>
    throwQTT m!"cannot use erased (multiplicity 0) value `{fvarId.name}` at runtime ({what})"
  | some .one =>
    if s.owned.contains fvarId then
      return { s with
        owned := s.owned.erase fvarId
        qtyOf := s.qtyOf.insert fvarId .zero }
    else if s.known.contains fvarId then
      throwAffine m!"use-after-move of affine value `{fvarId.name}` ({what})"
    else
      return s
  | some .omega =>
    return s
  | none =>
    if s.owned.contains fvarId then
      return { s with owned := s.owned.erase fvarId }
    else if s.known.contains fvarId then
      throwAffine m!"use-after-move of affine value `{fvarId.name}` ({what})"
    else
      return s

/-- Require ownership without consuming (freestanding borrow). -/
private def ensureOwned (s : AffineState) (fvarId : FVarId) (what : String) : CompilerM Unit := do
  if isRegionDead s fvarId then
    throwAffine m!"use-after-free of affine value `{fvarId.name}` ({what})"
  if s.owned.contains fvarId then
    pure ()
  else if s.known.contains fvarId then
    throwAffine m!"use-after-move of affine value `{fvarId.name}` ({what})"
  else
    pure ()

/-- True if moving `ty` should kill region `r` (only the region **root** type free/close). -/
private def shouldKillRegion (s : AffineState) (r : Nat) (ty : Name) : Bool :=
  match s.rootTypeOfRegion.get? r with
  | some root => root == ty
  | none => true -- conservative: unknown root → kill (legacy / params)

/-- Reject `@[fs_borrow]` decls that return the same affine type as a borrowed param.
A fresh region on the result would dual-own the same runtime resource (double-free);
sharing the parent stamp would dual-own under one region. Derived views must use a
**different** affine type (e.g. `Arena.lastPtr` → `BytePtr`). -/
private def checkFsBorrowResultNotSameAffine (env : Environment) (declName : Name)
    (params : Array (Param .pure)) (resultType : Expr) : CompilerM Unit := do
  unless isFsBorrowDecl env declName do
    return
  let some retName := affineTypeName? env resultType | return
  for p in params do
    if let some pName := affineTypeName? env p.type then
      if pName == retName then
        throwAffine m!"`@[fs_borrow]` declaration `{declName}` returns the same affine type \
          `{retName}` as a borrowed parameter (dual ownership / double-free risk); \
          use a distinct derived type (e.g. `BytePtr` from `Arena`) or drop `@[fs_borrow]` and move"

/--
Process args of a call.

* `@[fs_borrow]`: borrow affine args; if result type is affine and **≠** any borrowed
  affine arg's type, stamp result with the first borrowed affine arg's region (derive —
  e.g. `Arena.lastPtr` → `BytePtr`), **unless** the callee is also `@[fs_fresh_region]`
  (independent resource — e.g. `sysMmap` → `MMap` does not share `Fd`'s region).
  Returning the **same** affine type as a borrowed arg is a hard error (not a fresh region).
* otherwise: move affine args. If result type is the **same** affine type as a moved arg,
  transfer that region to the result (`Arena.alloc`). Else, if the moved type is the region
  **root**, kill the region (`Arena.free`, `sysClose`, `bufFree`); free of a derived type alone
  does not kill the root's region.
* Named callees only for region transfer/kill (`fn? = some`); jmp/app stay move-only.
-/
private def consumeArgs (env : Environment) (s : AffineState) (fn? : Option Name)
    (args : Array (Arg .pure)) (resultType : Expr) (what : String) : CompilerM AffineState := do
  let borrowAll := match fn? with
    | some fn => isFsBorrowDecl env fn
    | none => false
  let freshRegion := match fn? with
    | some fn => isFsFreshRegionDecl env fn
    | none => false
  let resultTyName? := affineTypeName? env resultType
  let mut s := { s with stampNext? := none }
  let mut transferR? : Option Nat := none
  let mut deriveR? : Option Nat := none
  let mut firstBorrowTy? : Option Name := none
  let mut sameTypeBorrow := false
  let mut toKill : List Nat := []
  for arg in args do
    match arg with
    | .fvar fvarId =>
      if s.known.contains fvarId then
        if borrowAll then
          ensureOwned s fvarId what
          if let some r := s.regionOf.get? fvarId then
            let ty? := s.typeOf.get? fvarId
            if let some ty := ty? then
              if resultTyName? == some ty then
                sameTypeBorrow := true
            if firstBorrowTy?.isNone then
              firstBorrowTy? := ty?
              deriveR? := some r
            else
              pure ()
        else
          let ty? := s.typeOf.get? fvarId
          let r? := s.regionOf.get? fvarId
          s ← move s fvarId what
          -- Region ops only for named freestanding callees (not jmp / local app).
          if fn?.isSome then
            match r?, ty?, resultTyName? with
            | some r, some ty, some rt =>
              if ty == rt then
                transferR? := transferR? <|> some r
              else if shouldKillRegion s r ty then
                toKill := r :: toKill
            | some r, some ty, none =>
              if shouldKillRegion s r ty then
                toKill := r :: toKill
            | some r, none, _ =>
              toKill := r :: toKill
            | _, _, _ => pure ()
    | .erased | .type .. => pure ()
  if borrowAll && sameTypeBorrow then
    let callee := match fn? with | some n => m!"`{n}`" | none => m!"callee"
    throwAffine m!"`@[fs_borrow]` {callee} returns the same affine type as a borrowed argument \
      ({what}; dual ownership / double-free risk); use a distinct derived type \
      (e.g. `BytePtr` from `Arena`) or drop `@[fs_borrow]` and move"
  for r in toKill do
    s := killRegion s r
  let stamp? :=
    if borrowAll then
      if freshRegion then
        -- Independent resource (mmap): result root is its own type; do not share parent region.
        none
      else
        -- Derive only when result is affine and differs from the borrowed arg type.
        match resultTyName?, firstBorrowTy?, deriveR? with
        | some rt, some bt, some r => if rt != bt then some r else none
        | _, _, _ => none
    else
      transferR?
  return { s with stampNext? := stamp? }

/-- Collect free fvars mentioned in a pure `Arg`. -/
private def collectArgFVars (acc : FVarIdSet) : Arg .pure → FVarIdSet
  | .fvar f => acc.insert f
  | .erased | .type .. => acc

/-- Collect free fvars mentioned in a pure `LetValue`. -/
private def collectLetValueFVars (acc : FVarIdSet) : LetValue .pure → FVarIdSet
  | .lit .. | .erased => acc
  | .proj _ _ struct _ => acc.insert struct
  | .const _ _ args _ => args.foldl collectArgFVars acc
  | .fvar f args => args.foldl collectArgFVars (acc.insert f)
  | _ => acc

/-- Collect free fvars mentioned in pure `Code` (bound params/lets still appear; filter later). -/
private partial def collectCodeFVars (acc : FVarIdSet) : Code .pure → FVarIdSet
  | .let decl k => collectCodeFVars (collectLetValueFVars acc decl.value) k
  | .fun decl k _ | .jp decl k =>
    collectCodeFVars (collectCodeFVars acc decl.value) k
  | .jmp f args => args.foldl collectArgFVars (acc.insert f)
  | .cases cs =>
    let acc := acc.insert cs.discr
    cs.alts.foldl (init := acc) fun acc alt =>
      match alt with
      | .alt _ _ k _ => collectCodeFVars acc k
      | .default k => collectCodeFVars acc k
      | .ctorAlt .. => acc
  | .return f => acc.insert f
  | .unreach _ => acc
  | .oset .. | .uset .. | .sset .. | .setTag .. | .inc .. | .dec .. | .del .. => acc

/--
Outer linear fvars free in `decl`'s body (not among its params). Used as call-site captures
for local funs/jps that close over match scrutinee payloads.

`@[fs_borrow]` params of the enclosing decl are **not** captures: TCO join points may free-
close over a borrowed `log`/`Fd`, but jumps must not *move* the borrow (it stays outer for the
whole body). Owned linears free in the body remain move-captures.
-/
private def funCaptureLinears (s : AffineState) (decl : FunDecl .pure) : FVarIdSet :=
  let bound := decl.params.foldl (init := ({} : FVarIdSet)) fun acc p => acc.insert p.fvarId
  let used := collectCodeFVars {} decl.value
  used.foldl (init := ({} : FVarIdSet)) fun acc f =>
    if bound.contains f then acc
    else if s.borrowedParams.contains f then acc
    else if s.owned.contains f || (s.known.contains f && s.qtyOf.get? f == some .one) then
      acc.insert f
    else acc

/-- Move every free linear capture of local fun/jp `f` at a call/jmp site. -/
private def consumeFunCaptures (s : AffineState) (f : FVarId) (what : String) :
    CompilerM AffineState := do
  match s.funCaptures.get? f with
  | none => pure s
  | some caps =>
    let mut s := s
    for c in caps do
      s ← move s c what
    pure s

private def consumeLetValue (env : Environment) (s : AffineState) (v : LetValue .pure)
    (resultType : Expr) : CompilerM AffineState := do
  match v with
  | .lit .. | .erased => return { s with stampNext? := none }
  | .proj _ _ struct _ =>
    if s.known.contains struct then
      -- No `fd.raw` escape: affine resources end only via explicit consumers (close/intoUSize).
      throwAffine m!"cannot project affine value `{struct.name}` \
        (use an explicit consumer such as `close` / `intoUSize`; no field strip of affine handles)"
    else
      return { s with stampNext? := none }
  | .const fn _ args _ =>
    consumeArgs env s (some fn) args resultType s!"call `{fn}`"
  | .fvar fvarId args =>
    if args.isEmpty && s.known.contains fvarId then
      -- Affine rename (`let a := x`): move ownership and **transfer region stamp** so
      -- derived buffers still share the owner's region after LCNF let-floating.
      let r? := s.regionOf.get? fvarId
      let s ← move s fvarId "affine alias"
      return { s with stampNext? := r? }
    else if args.isEmpty then
      -- Non-affine rename (e.g. local fun alias `_alt := _f`): no ownership change.
      return { s with stampNext? := none }
    else
      -- Application of local fun/jp: consume free linear captures, then args.
      let s ← consumeFunCaptures s fvarId "local fun capture (match arm / closure)"
      let s ←
        if s.known.contains fvarId then
          move s fvarId "app fn"
        else pure s
      consumeArgs env s none args resultType "app args"
  | _ => return { s with stampNext? := none }

/-- After introducing a let, copy fun-capture metadata on fun aliases. -/
private def copyFunCapturesOnAlias (s : AffineState) (decl : LetDecl .pure) : AffineState :=
  match decl.value with
  | .fvar f args =>
    if args.isEmpty then
      match s.funCaptures.get? f with
      | some caps => { s with funCaptures := s.funCaptures.insert decl.fvarId caps }
      | none => s
    else s
  | _ => s

/-- Reject silent drop of owned affine values. Borrowed params may remain (returned to caller). -/
private def checkNoSilentDrop (s : AffineState) (where_ : String) : CompilerM Unit := do
  let leftover := s.owned.foldl (init := ([] : List Name)) fun acc fvarId =>
    if s.borrowedParams.contains fvarId then acc else fvarId.name :: acc
  unless leftover.isEmpty do
    throwAffine m!"silent drop of affine value(s) {leftover} at {where_} \
      (must close/free/move/return; no ownership sinks or hidden finalizers)"

mutual

partial def checkCode (env : Environment) (s : AffineState) (code : Code .pure) :
    CompilerM Unit := do
  match code with
  | .let decl k =>
    let s ← consumeLetValue env s decl.value decl.type
    let s := introduce env s decl.fvarId decl.type (borrowedParam := false)
    let s := copyFunCapturesOnAlias s decl
    checkCode env s k
  | .fun decl k _ =>
    -- Body checked for param ownership; free outer linears consumed at each call site.
    checkFunDecl env decl (fsBorrow := false)
    let caps := funCaptureLinears s decl
    let s := { s with funCaptures := s.funCaptures.insert decl.fvarId caps }
    checkCode env s k
  | .jp decl k =>
    checkFunDecl env decl (fsBorrow := false)
    let caps := funCaptureLinears s decl
    let s := { s with funCaptures := s.funCaptures.insert decl.fvarId caps }
    checkCode env s k
  | .jmp fvarId args =>
    -- Join-point jumps: move free captures + affine args (no region kill; params re-bind).
    let s ← consumeFunCaptures s fvarId "join-point capture"
    let s ← consumeArgs env s none args (.const ``Unit []) "join-point jump"
    checkNoSilentDrop s "join-point jump"
  | .cases cs =>
    let s ←
      if s.known.contains cs.discr then
        move s cs.discr "cases discr"
      else pure s
    for alt in cs.alts do
      match alt with
      | .alt _ params k _ =>
        let mut sAlt := s
        for p in params do
          sAlt := introduce env sAlt p.fvarId p.type (borrowedParam := false)
        checkCode env sAlt k
      | .default k =>
        checkCode env s k
      | .ctorAlt .. => unreachable!
  | .return fvarId =>
    let s ←
      if s.borrowedParams.contains fvarId then
        -- End of borrow: return ownership to caller without "moving" a borrow.
        pure { s with owned := s.owned.erase fvarId }
      else if s.known.contains fvarId then
        -- Return transfers ownership to the caller — do not kill the region.
        move s fvarId "return"
      else pure s
    checkNoSilentDrop s "return"
  | .unreach _ =>
    pure ()
  | .oset .. | .uset .. | .sset .. | .setTag .. | .inc .. | .dec .. | .del .. =>
    throwAffine "impure instruction in base-phase affine check (internal)"

partial def checkFunDecl (env : Environment) (decl : FunDecl .pure) (fsBorrow : Bool) :
    CompilerM Unit := do
  -- Local funs are not `@[fs_borrow]` by name; fsBorrow only for top-level enclosing decl params.
  -- Free outer linears are not in this state — owned by the caller, consumed at application
  -- via `funCaptures` (LCNF match-arm sharing pattern).
  let mut s : AffineState := {}
  for p in decl.params do
    s := introduce env s p.fvarId p.type (borrowedParam := fsBorrow)
  checkCode env s decl.value

end

def checkDecl (decl : Decl .pure) : CompilerM Unit := do
  match decl.value with
  | .extern .. =>
    -- Still reject illegal same-type fs_borrow signatures on axioms/externs.
    let env ← getEnv
    checkFsBorrowResultNotSameAffine env decl.name decl.params decl.type.getForallBody
  | .code code =>
    let env ← getEnv
    let fsBorrow := isFsBorrowDecl env decl.name
    -- `decl.type` at base phase is the full function type; body type is the result.
    checkFsBorrowResultNotSameAffine env decl.name decl.params decl.type.getForallBody
    let mut s : AffineState := {}
    for p in decl.params do
      s := introduce env s p.fvarId p.type (borrowedParam := fsBorrow)
    checkCode env s code

/-- LCNF pass: freestanding affine ownership (no-op when not freestanding). -/
public def affineCheckPass : Pass where
  name := `affineCheck
  phase := .base
  run decls := do
    let env ← getEnv
    let opts ← getOptions
    -- Opt-in only: freestanding or compiler.qtt. Classic Lean: no-op.
    unless Compiler.isQttMode env opts do
      return decls
    for decl in decls do
      checkDecl decl
    return decls

builtin_initialize registerTraceClass `Compiler.affineCheck (inherited := true)

end Lean.Compiler.LCNF

