/-
Copyright (c) 2026 Lean FRO, LLC. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Hunter Beast
-/
module

prelude
public import Lean.Attributes
public import Lean.MonadEnv
public import Lean.Compiler.Multiplicity

public section

namespace Lean

/--
Marks an inductive or structure as **affine** / QTT-**linear** under freestanding checking.

In Systems Lean freestanding this is **multiplicity 1** (Idris 2 linear): must be consumed
exactly once (move / free / return). Silent drop is rejected. The LCNF quantitative/affine
pass enforces this when `compiler.freestanding` is on. Host modules ignore the tag (K9).

Registers QTT multiplicity **one** on the type (same as `@[linear]` / `@[quantity 1]`).

Distinct from RC borrow `@&` (K15).
-/
@[builtin_doc]
builtin_initialize affineAttr : TagAttribute ←
  registerTagAttribute `affine
    "mark inductive/structure as freestanding linear (QTT 1) resource; must consume exactly once"
    fun declName => do
      let info ← getConstInfo declName
      match info with
      | .inductInfo _ =>
        modifyEnv (Compiler.multiplicityTypeExt.insert · declName Compiler.Multiplicity.one)
      | _ => throwError "Invalid `affine` on `{declName}`: only inductive types / structures \
        may be marked affine (N2 / QTT 1)"

/-- True if `declName` is tagged `@[affine]`. -/
public def isAffineTypeName (env : Environment) (declName : Name) : Bool :=
  affineAttr.hasTag env declName

/--
Marks a declaration so that freestanding affine parameters are **borrowed** (not moved) at
call sites. Distinct from RC `@&` (K15). Typical use: `read` / `write` on an affine `Fd`.

Without this attribute, every affine argument is moved (consumed) by the call — correct for
`close` / `free` / explicit drop.
-/
@[builtin_doc]
builtin_initialize fsBorrowAttr : TagAttribute ←
  registerTagAttribute `fs_borrow
    "freestanding: borrow affine parameters of this decl (not RC @&; see K15)"

/-- True if `declName` is tagged `@[fs_borrow]` (affine args not consumed at calls). -/
public def isFsBorrowDecl (env : Environment) (declName : Name) : Bool :=
  fsBorrowAttr.hasTag env declName

/--
Marks a `@[fs_borrow]` declaration whose **affine result** is an **independent** resource
(fresh region), not a derived view of a borrowed argument.

Default `@[fs_borrow]` + different affine result type **derives** the parent's region
(e.g. `Arena.lastPtr` → `BytePtr`). Use `@[fs_fresh_region]` when the result must outlive
or be independent of the borrowed resource — e.g. `sysMmap` borrows `Fd` but produces
`MMap` that remains valid after `close` (POSIX: mapping outlives the fd).
-/
@[builtin_doc]
builtin_initialize fsFreshRegionAttr : TagAttribute ←
  registerTagAttribute `fs_fresh_region
    "freestanding: @[fs_borrow] affine result gets a fresh region (not derived from borrowed arg)"

/-- True if `declName` is tagged `@[fs_fresh_region]`. -/
public def isFsFreshRegionDecl (env : Environment) (declName : Name) : Bool :=
  fsFreshRegionAttr.hasTag env declName

/-- Return type constructor name if `type` is (headed by) an affine inductive. -/
public def affineTypeName? (env : Environment) (type : Expr) : Option Name :=
  match type with
  | .const n _ => if isAffineTypeName env n then some n else none
  | .app f _ => affineTypeName? env f
  | .mdata _ b => affineTypeName? env b
  | .forallE .. => none
  | _ => none

/-- True if kernel/LCNF type is an affine resource type. -/
public def isAffineType (env : Environment) (type : Expr) : Bool :=
  (affineTypeName? env type).isSome

end Lean
