/-
Copyright (c) 2026 Lean FRO, LLC. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Hunter Beast
-/
module

prelude
public import Init.Data.Repr
public import Lean.Attributes
public import Lean.MonadEnv
public import Lean.CoreM
public import Lean.LocalContext
public import Lean.Compiler.Options
public import Lean.Compiler.Freestanding
public import Lean.Data.KVMap

/-!
# Quantitative type theory (QTT) multiplicities for Systems Lean freestanding

Deep embedding of Idris 2–class **multiplicities** for the freestanding extract path:

| Qty | Name | Meaning (Idris 2 / QTT) |
|-----|------|-------------------------|
| `0` | zero | Erased — available for typechecking/proofs only; **no runtime residual** |
| `1` | one  | Linear — must be used **exactly once** (free-safety / ownership) |
| `ω` | omega | Unrestricted — free copy/drop (unboxed scalars, pure data) |

## Algebra (as in QTT / Idris 2)

* **Addition** (`+`): context splitting / parallel use — `1 + 1 = ω`.
* **Multiplication** (`*`): function application / nesting — `0 * q = 0`, `1 * q = q`.
* **Order** (`≤`): `0 ≤ 1 ≤ ω` (can promote usage requirements).

Freestanding **resource** types (`@[affine]` / `@[linear]`) default to **one**.
Freestanding **scalars** and non-resource data default to **omega**.
**Proofs / erased** material is **zero** and must not appear in product C.

This module is the **semantic core**. Enforcement is elaborator `QTT.UseCheck` (use/split),
`LCNF.AffineCheck` (quantitative freestanding / regions), and `MemSafetyCert` (certificates
assert / inventory / independently verify claim strings for 0-qty erasure and linear
exact-once — not a proof of ISO C memory safety of the emission).
-/

public section

namespace Lean.Compiler

/-- Idris 2 / QTT multiplicity. -/
public inductive Multiplicity where
  /-- Erased (0): type-level / proof only; no runtime representation in freestanding C. -/
  | zero
  /-- Linear (1): exactly one use; move-only ownership. -/
  | one
  /-- Unrestricted (ω): free duplication and discard. -/
  | omega
  deriving Inhabited, BEq, Repr, DecidableEq

namespace Multiplicity

public def toString : Multiplicity → String
  | .zero => "0"
  | .one  => "1"
  | .omega => "ω"

public instance : ToString Multiplicity where
  toString := toString

/-- Partial order `0 ≤ 1 ≤ ω`. -/
public def le : Multiplicity → Multiplicity → Bool
  | .zero, _ => true
  | .one, .one => true
  | .one, .omega => true
  | .omega, .omega => true
  | _, _ => false

public def lt (a b : Multiplicity) : Bool :=
  le a b && !(a == b)

/-- Context addition (parallel composition / split reassembly). `1 + 1 = ω`. -/
public def add : Multiplicity → Multiplicity → Multiplicity
  | .zero, q => q
  | q, .zero => q
  | .one, .one => .omega
  | .one, .omega => .omega
  | .omega, .one => .omega
  | .omega, .omega => .omega

/-- Multiplicity multiplication (application / under binders). -/
public def mul : Multiplicity → Multiplicity → Multiplicity
  | .zero, _ => .zero
  | _, .zero => .zero
  | .one, q => q
  | q, .one => q
  | .omega, .omega => .omega

public instance : Add Multiplicity where
  add := add

public instance : Mul Multiplicity where
  mul := mul

/-- May discard without an explicit consumer (`ω` only; linear `1` must be used). -/
public def mayDiscard : Multiplicity → Bool
  | .omega => true
  | .zero => true  -- erased: not a runtime value to free
  | .one => false

/-- Runtime relevant (not fully erased). -/
public def isRuntime : Multiplicity → Bool
  | .zero => false
  | _ => true

/-- Exactly-once linear. -/
public def isLinear : Multiplicity → Bool
  | .one => true
  | _ => false

/-- Unrestricted. -/
public def isUnrestricted : Multiplicity → Bool
  | .omega => true
  | _ => false

/-- Erased / 0-quantity. -/
public def isErased : Multiplicity → Bool
  | .zero => true
  | _ => false

/--
Remaining multiplicity after a single runtime use, or `none` if impossible.

QTT intuition: using a linear resource once requires availability ≥ 1 and leaves 0 for that name.
Using under ω leaves ω. Erased (0) cannot be used at runtime.
-/
public def useOnce (avail : Multiplicity) : Option Multiplicity :=
  match avail with
  | .zero => none
  | .one => some .zero  -- consumed; remaining is "used up"
  | .omega => some .omega

/-- Require at least linear availability (for move/consume). -/
public def requireLinear (avail : Multiplicity) : Bool :=
  match avail with
  | .one | .omega => true
  | .zero => false

end Multiplicity

/-- Environment extension: default multiplicity for a type constructor (freestanding QTT). -/
builtin_initialize multiplicityTypeExt : MapDeclarationExtension Multiplicity ←
  mkMapDeclarationExtension

/--
Marks a type constructor with an explicit freestanding multiplicity (QTT).

* `@[quantity 0]` / erased — no runtime
* `@[quantity 1]` / linear — exactly once
* `@[quantity ω]` / unrestricted

Prefer the sugar attributes `@[linear]`, `@[unrestricted]`, `@[erased]` when possible.
`@[affine]` is treated as **linear (1)** for freestanding resources (must consume; no silent drop).
-/
private def parseMultiplicityName (n : Name) : CoreM Multiplicity := do
  let s := n.toString
  if s == "0" || s == "zero" || s == "erased" then pure Multiplicity.zero
  else if s == "1" || s == "one" || s == "linear" then pure Multiplicity.one
  else if s == "ω" || s == "w" || s == "omega" || s == "unrestricted" then
    pure Multiplicity.omega
  else throwError "Invalid quantity `{n}`: use 0/1/ω (or zero/one/omega/erased/linear/unrestricted)"

@[builtin_doc]
builtin_initialize quantityAttr : ParametricAttribute Multiplicity ←
  registerParametricAttribute {
    name := `quantity
    descr := "freestanding QTT multiplicity for a type (0 / 1 / ω)"
    getParam := fun declName stx => do
      let info ← getConstInfo declName
      match info with
      | .inductInfo _ => pure ()
      | _ => throwError "Invalid `quantity` on `{declName}`: only inductive types / structures"
      let id ← Attribute.Builtin.getId stx
      let mult ← parseMultiplicityName id
      modifyEnv (multiplicityTypeExt.insert · declName mult)
      pure mult
  }

/-- Sugar: linear (1) — same default as freestanding `@[affine]` resources. -/
@[builtin_doc]
builtin_initialize linearAttr : TagAttribute ←
  registerTagAttribute `linear
    "freestanding QTT linear (multiplicity 1): must be used exactly once"
    fun declName => do
      let info ← getConstInfo declName
      match info with
      | .inductInfo _ =>
        modifyEnv (multiplicityTypeExt.insert · declName Multiplicity.one)
      | _ => throwError "Invalid `linear` on `{declName}`: only inductive types / structures"

/-- Sugar: unrestricted (ω). -/
@[builtin_doc]
builtin_initialize unrestrictedAttr : TagAttribute ←
  registerTagAttribute `unrestricted
    "freestanding QTT unrestricted (multiplicity ω)"
    fun declName => do
      let info ← getConstInfo declName
      match info with
      | .inductInfo _ =>
        modifyEnv (multiplicityTypeExt.insert · declName Multiplicity.omega)
      | _ => throwError "Invalid `unrestricted` on `{declName}`: only inductive types / structures"

/-- Sugar: erased (0) — must not appear in freestanding product C. -/
@[builtin_doc]
builtin_initialize erasedAttr : TagAttribute ←
  registerTagAttribute `erased
    "freestanding QTT erased (multiplicity 0): no runtime residual"
    fun declName => do
      let info ← getConstInfo declName
      match info with
      | .inductInfo _ =>
        modifyEnv (multiplicityTypeExt.insert · declName Multiplicity.zero)
      | _ => throwError "Invalid `erased` on `{declName}`: only inductive types / structures"

/--
Default freestanding multiplicity for a type constructor name.

1. Explicit `quantity` / `linear` / `unrestricted` / `erased` / `@[affine]` map entry  
2. Else → **ω** (unrestricted data / scalars default; freestanding scalars are ω by this rule)
-/
public def defaultMultiplicity (env : Environment) (typeName : Name) : Multiplicity :=
  if let some m := multiplicityTypeExt.find? env typeName then m
  else Multiplicity.omega

/-- QTT / freestanding mode (opt-in). Classic Lean: both false → no QTT enforcement. -/
public def isQttMode (env : Environment) (opts : Options) : Bool :=
  isFreestandingEmit env opts || compiler.qtt.get opts

/-- Encode multiplicity in `Expr.mdata` for binder annotations (Systems Lean only). -/
public def multMDataKey : Name := `qtt.mult

public def multToNat : Multiplicity → Nat
  | .zero => 0
  | .one => 1
  | .omega => 2

public def multFromNat? : Nat → Option Multiplicity
  | 0 => some .zero
  | 1 => some .one
  | 2 => some .omega
  | _ => none

/-- Annotate a type with an explicit binder multiplicity (mdata). -/
public def annotateMult (m : Multiplicity) (type : Expr) : Expr :=
  .mdata (KVMap.empty.insert multMDataKey (DataValue.ofNat (multToNat m))) type

/-- Read multiplicity annotation from mdata, if any. -/
public def multAnnotation? (type : Expr) : Option Multiplicity :=
  match type with
  | .mdata kv b =>
    match kv.find multMDataKey with
    | some (DataValue.ofNat n) => multFromNat? n
    | _ => multAnnotation? b
  | _ => none

/--
Multiplicity of a kernel/LCNF type: explicit mdata annotation, else type head default.

Defaults (Systems Lean freestanding / QTT), pure path (no Meta `isProp`):
* `@[quantity]` / `@[linear]` / `@[affine]` / `@[erased]` / `@[unrestricted]` map entry
* `Prop` const / sorts / **`lcErased`** → **0**
* otherwise → **ω** (unrestricted data / scalars)

**LCNF vs elab:** `toLCNFType` erases propositions to `lcErased` and drops most mdata.
AffineCheck therefore relies on **attrs + `lcErased` + any surviving mdata**, not on
source-level `annotateMult` alone. Elab Meta helpers use `isProp` for Prop-valued types
that are not yet erased (see `QTT.multOfLocalType`).
-/
public def multiplicityOfType (env : Environment) (type : Expr) : Multiplicity :=
  match multAnnotation? type with
  | some m => m
  | none =>
    match type with
    | .const n _ =>
      if n == `Prop || n == `lcErased then Multiplicity.zero
      else defaultMultiplicity env n
    | .app f _ => multiplicityOfType env f
    | .mdata _ b => multiplicityOfType env b
    | .forallE _ _ b _ => multiplicityOfType env b
    | .sort _ => Multiplicity.zero
    | _ => Multiplicity.omega

/-- Multiplicity for a binder of the given type in QTT mode (same as multiplicityOfType). -/
public def binderMultiplicity (env : Environment) (binderType : Expr) : Multiplicity :=
  multiplicityOfType env binderType

/--
Type-level binder mult for LCNF params/lets and pure telescopes.

Same pure policy as `getBinderMult` on a local's type (no Meta `isProp`).
Treats `lcErased` as **0**. Explicit `qtt.mult` mdata overrides when present on the type.
-/
public abbrev getBinderMultOfType (env : Environment) (binderType : Expr) : Multiplicity :=
  binderMultiplicity env binderType

/--
If `type` already has a `qtt.mult` annotation, return it unchanged; otherwise wrap with
`annotateMult` of the default multiplicity for that type.

Used under freestanding/`compiler.qtt` so every introduced binder carries an **explicit** mult.
-/
public def ensureExplicitMult (env : Environment) (type : Expr) : Expr :=
  match multAnnotation? type with
  | some _ => type
  | none => annotateMult (binderMultiplicity env type) type

/--
Under QTT mode (`compiler.freestanding` or `compiler.qtt`), ensure binder type has explicit mult.
Classic Lean (both options false): identity — no mdata, no behavior change.
-/
public def annotateBinderTypeIfQtt (env : Environment) (opts : Options) (type : Expr) : Expr :=
  if isQttMode env opts then ensureExplicitMult env type else type

/--
Walk a forall telescope and annotate each binder domain with its multiplicity when missing.
Does not change non-forall structure. Classic callers use `annotateBinderTypeIfQtt` per site.
-/
public partial def annotateTelescopeBinderMults (env : Environment) (type : Expr) : Expr :=
  match type with
  | .forallE n d b bi =>
    let d' := ensureExplicitMult env d
    -- Body may mention the binder; keep structure (no instantiate needed for domain-only annotate).
    .forallE n d' (annotateTelescopeBinderMults env b) bi
  | .mdata kv b => .mdata kv (annotateTelescopeBinderMults env b)
  | _ => type

/--
**Single pure lookup** for the multiplicity of a local binder from its type in `lctx`.

1. Prefer explicit `qtt.mult` mdata on the binder type (`annotateMult`)
2. Else type defaults via `binderMultiplicity` (resource attrs → 1, Prop/sort/`lcErased` → 0, else ω)

Does **not** run Meta `isProp` on Prop-valued types (e.g. `True`); that is elab-only via
`QTT.multOfLocalType` / `getLocalBinderMult`. LCNF `AffineCheck` uses `getBinderMultOfType`
on param types (same pure policy). When `fvarId` is not in `lctx`, returns **ω**.
-/
public def getBinderMult (env : Environment) (lctx : LocalContext) (fvarId : FVarId) : Multiplicity :=
  match lctx.find? fvarId with
  | some decl => binderMultiplicity env decl.type
  | none => Multiplicity.omega

/-- Override map entry wins; otherwise same as `getBinderMult`. -/
public def getBinderMultWithMap (env : Environment) (lctx : LocalContext) (fvarId : FVarId)
    (overrides : FVarIdMap Multiplicity) : Multiplicity :=
  match overrides.get? fvarId with
  | some m => m
  | none => getBinderMult env lctx fvarId

/-- True if type is QTT-linear (multiplicity 1) under freestanding defaults. -/
public def isLinearType (env : Environment) (type : Expr) : Bool :=
  (multiplicityOfType env type).isLinear

/-- True if type is erased (0). -/
public def isErasedType (env : Environment) (type : Expr) : Bool :=
  (multiplicityOfType env type).isErased

-- Formal layer: definitional checks in the same module as algebra (bodies need not be exposed).
namespace Multiplicity.Theorems
private theorem add_one_one : Multiplicity.add .one .one = .omega := rfl
private theorem mul_zero_one : Multiplicity.mul .zero .one = .zero := rfl
private theorem mul_zero_omega : Multiplicity.mul .zero .omega = .zero := rfl
private theorem mul_one_omega : Multiplicity.mul .one .omega = .omega := rfl
private theorem mul_one_one : Multiplicity.mul .one .one = .one := rfl
private theorem le_zero_one : Multiplicity.le .zero .one = true := rfl
private theorem le_one_omega : Multiplicity.le .one .omega = true := rfl
private theorem le_zero_omega : Multiplicity.le .zero .omega = true := rfl
private theorem mayDiscard_one : Multiplicity.mayDiscard .one = false := rfl
private theorem mayDiscard_omega : Multiplicity.mayDiscard .omega = true := rfl
private theorem mayDiscard_zero : Multiplicity.mayDiscard .zero = true := rfl
private theorem isRuntime_zero : Multiplicity.isRuntime .zero = false := rfl
private theorem isRuntime_one : Multiplicity.isRuntime .one = true := rfl
private theorem useOnce_one : Multiplicity.useOnce .one = some .zero := rfl
private theorem useOnce_zero : Multiplicity.useOnce .zero = none := rfl
private theorem useOnce_omega : Multiplicity.useOnce .omega = some .omega := rfl
-- Identities / annihilation (0/1/ω surface)
private theorem add_zero_left_one : Multiplicity.add .zero .one = .one := rfl
private theorem add_zero_right_one : Multiplicity.add .one .zero = .one := rfl
private theorem add_zero_left_omega : Multiplicity.add .zero .omega = .omega := rfl
private theorem add_zero_right_omega : Multiplicity.add .omega .zero = .omega := rfl
private theorem mul_zero_left_one : Multiplicity.mul .zero .one = .zero := rfl
private theorem mul_one_left_omega : Multiplicity.mul .one .omega = .omega := rfl
private theorem mul_omega_one : Multiplicity.mul .omega .one = .omega := rfl
private theorem mul_omega_omega : Multiplicity.mul .omega .omega = .omega := rfl
-- Commutativity samples (definitional pairs spanning the 0/1/ω surface)
private theorem add_comm_one_omega : Multiplicity.add .one .omega = Multiplicity.add .omega .one := rfl
private theorem add_comm_zero_one : Multiplicity.add .zero .one = Multiplicity.add .one .zero := rfl
private theorem add_comm_zero_omega : Multiplicity.add .zero .omega = Multiplicity.add .omega .zero := rfl
private theorem mul_comm_one_omega : Multiplicity.mul .one .omega = Multiplicity.mul .omega .one := rfl
private theorem mul_comm_zero_omega : Multiplicity.mul .zero .omega = Multiplicity.mul .omega .zero := rfl
private theorem mul_comm_zero_one : Multiplicity.mul .zero .one = Multiplicity.mul .one .zero := rfl
-- Full 3×3 addition table (definitional; product-facing split algebra)
private theorem add_table_0_0 : Multiplicity.add .zero .zero = .zero := rfl
private theorem add_table_0_1 : Multiplicity.add .zero .one = .one := rfl
private theorem add_table_0_w : Multiplicity.add .zero .omega = .omega := rfl
private theorem add_table_1_0 : Multiplicity.add .one .zero = .one := rfl
private theorem add_table_1_1 : Multiplicity.add .one .one = .omega := rfl
private theorem add_table_1_w : Multiplicity.add .one .omega = .omega := rfl
private theorem add_table_w_0 : Multiplicity.add .omega .zero = .omega := rfl
private theorem add_table_w_1 : Multiplicity.add .omega .one = .omega := rfl
private theorem add_table_w_w : Multiplicity.add .omega .omega = .omega := rfl
-- Full 3×3 multiplication table
private theorem mul_table_0_0 : Multiplicity.mul .zero .zero = .zero := rfl
private theorem mul_table_0_1 : Multiplicity.mul .zero .one = .zero := rfl
private theorem mul_table_0_w : Multiplicity.mul .zero .omega = .zero := rfl
private theorem mul_table_1_0 : Multiplicity.mul .one .zero = .zero := rfl
private theorem mul_table_1_1 : Multiplicity.mul .one .one = .one := rfl
private theorem mul_table_1_w : Multiplicity.mul .one .omega = .omega := rfl
private theorem mul_table_w_0 : Multiplicity.mul .omega .zero = .zero := rfl
private theorem mul_table_w_1 : Multiplicity.mul .omega .one = .omega := rfl
private theorem mul_table_w_w : Multiplicity.mul .omega .omega = .omega := rfl
-- Associativity samples (named chains for greppability; full 3³ tables follow)
private theorem add_assoc_1_1_1 :
    Multiplicity.add (Multiplicity.add .one .one) .one =
      Multiplicity.add .one (Multiplicity.add .one .one) := rfl
private theorem add_assoc_1_1_w :
    Multiplicity.add (Multiplicity.add .one .one) .omega =
      Multiplicity.add .one (Multiplicity.add .one .omega) := rfl
private theorem add_assoc_0_1_w :
    Multiplicity.add (Multiplicity.add .zero .one) .omega =
      Multiplicity.add .zero (Multiplicity.add .one .omega) := rfl
private theorem mul_assoc_1_w_w :
    Multiplicity.mul (Multiplicity.mul .one .omega) .omega =
      Multiplicity.mul .one (Multiplicity.mul .omega .omega) := rfl
private theorem mul_assoc_0_1_w :
    Multiplicity.mul (Multiplicity.mul .zero .one) .omega =
      Multiplicity.mul .zero (Multiplicity.mul .one .omega) := rfl
-- Full 3³ add associativity (definitional)
private theorem add_assoc_full :
    (Multiplicity.add (Multiplicity.add .zero .zero) .zero = Multiplicity.add .zero (Multiplicity.add .zero .zero)) &&
      (Multiplicity.add (Multiplicity.add .zero .zero) .one = Multiplicity.add .zero (Multiplicity.add .zero .one)) &&
      (Multiplicity.add (Multiplicity.add .zero .zero) .omega = Multiplicity.add .zero (Multiplicity.add .zero .omega)) &&
      (Multiplicity.add (Multiplicity.add .zero .one) .zero = Multiplicity.add .zero (Multiplicity.add .one .zero)) &&
      (Multiplicity.add (Multiplicity.add .zero .one) .one = Multiplicity.add .zero (Multiplicity.add .one .one)) &&
      (Multiplicity.add (Multiplicity.add .zero .one) .omega = Multiplicity.add .zero (Multiplicity.add .one .omega)) &&
      (Multiplicity.add (Multiplicity.add .zero .omega) .zero = Multiplicity.add .zero (Multiplicity.add .omega .zero)) &&
      (Multiplicity.add (Multiplicity.add .zero .omega) .one = Multiplicity.add .zero (Multiplicity.add .omega .one)) &&
      (Multiplicity.add (Multiplicity.add .zero .omega) .omega = Multiplicity.add .zero (Multiplicity.add .omega .omega)) &&
      (Multiplicity.add (Multiplicity.add .one .zero) .zero = Multiplicity.add .one (Multiplicity.add .zero .zero)) &&
      (Multiplicity.add (Multiplicity.add .one .zero) .one = Multiplicity.add .one (Multiplicity.add .zero .one)) &&
      (Multiplicity.add (Multiplicity.add .one .zero) .omega = Multiplicity.add .one (Multiplicity.add .zero .omega)) &&
      (Multiplicity.add (Multiplicity.add .one .one) .zero = Multiplicity.add .one (Multiplicity.add .one .zero)) &&
      (Multiplicity.add (Multiplicity.add .one .one) .one = Multiplicity.add .one (Multiplicity.add .one .one)) &&
      (Multiplicity.add (Multiplicity.add .one .one) .omega = Multiplicity.add .one (Multiplicity.add .one .omega)) &&
      (Multiplicity.add (Multiplicity.add .one .omega) .zero = Multiplicity.add .one (Multiplicity.add .omega .zero)) &&
      (Multiplicity.add (Multiplicity.add .one .omega) .one = Multiplicity.add .one (Multiplicity.add .omega .one)) &&
      (Multiplicity.add (Multiplicity.add .one .omega) .omega = Multiplicity.add .one (Multiplicity.add .omega .omega)) &&
      (Multiplicity.add (Multiplicity.add .omega .zero) .zero = Multiplicity.add .omega (Multiplicity.add .zero .zero)) &&
      (Multiplicity.add (Multiplicity.add .omega .zero) .one = Multiplicity.add .omega (Multiplicity.add .zero .one)) &&
      (Multiplicity.add (Multiplicity.add .omega .zero) .omega = Multiplicity.add .omega (Multiplicity.add .zero .omega)) &&
      (Multiplicity.add (Multiplicity.add .omega .one) .zero = Multiplicity.add .omega (Multiplicity.add .one .zero)) &&
      (Multiplicity.add (Multiplicity.add .omega .one) .one = Multiplicity.add .omega (Multiplicity.add .one .one)) &&
      (Multiplicity.add (Multiplicity.add .omega .one) .omega = Multiplicity.add .omega (Multiplicity.add .one .omega)) &&
      (Multiplicity.add (Multiplicity.add .omega .omega) .zero = Multiplicity.add .omega (Multiplicity.add .omega .zero)) &&
      (Multiplicity.add (Multiplicity.add .omega .omega) .one = Multiplicity.add .omega (Multiplicity.add .omega .one)) &&
      (Multiplicity.add (Multiplicity.add .omega .omega) .omega = Multiplicity.add .omega (Multiplicity.add .omega .omega)) = true := rfl
-- Full 3³ mul associativity (definitional)
private theorem mul_assoc_full :
    (Multiplicity.mul (Multiplicity.mul .zero .zero) .zero = Multiplicity.mul .zero (Multiplicity.mul .zero .zero)) &&
      (Multiplicity.mul (Multiplicity.mul .zero .zero) .one = Multiplicity.mul .zero (Multiplicity.mul .zero .one)) &&
      (Multiplicity.mul (Multiplicity.mul .zero .zero) .omega = Multiplicity.mul .zero (Multiplicity.mul .zero .omega)) &&
      (Multiplicity.mul (Multiplicity.mul .zero .one) .zero = Multiplicity.mul .zero (Multiplicity.mul .one .zero)) &&
      (Multiplicity.mul (Multiplicity.mul .zero .one) .one = Multiplicity.mul .zero (Multiplicity.mul .one .one)) &&
      (Multiplicity.mul (Multiplicity.mul .zero .one) .omega = Multiplicity.mul .zero (Multiplicity.mul .one .omega)) &&
      (Multiplicity.mul (Multiplicity.mul .zero .omega) .zero = Multiplicity.mul .zero (Multiplicity.mul .omega .zero)) &&
      (Multiplicity.mul (Multiplicity.mul .zero .omega) .one = Multiplicity.mul .zero (Multiplicity.mul .omega .one)) &&
      (Multiplicity.mul (Multiplicity.mul .zero .omega) .omega = Multiplicity.mul .zero (Multiplicity.mul .omega .omega)) &&
      (Multiplicity.mul (Multiplicity.mul .one .zero) .zero = Multiplicity.mul .one (Multiplicity.mul .zero .zero)) &&
      (Multiplicity.mul (Multiplicity.mul .one .zero) .one = Multiplicity.mul .one (Multiplicity.mul .zero .one)) &&
      (Multiplicity.mul (Multiplicity.mul .one .zero) .omega = Multiplicity.mul .one (Multiplicity.mul .zero .omega)) &&
      (Multiplicity.mul (Multiplicity.mul .one .one) .zero = Multiplicity.mul .one (Multiplicity.mul .one .zero)) &&
      (Multiplicity.mul (Multiplicity.mul .one .one) .one = Multiplicity.mul .one (Multiplicity.mul .one .one)) &&
      (Multiplicity.mul (Multiplicity.mul .one .one) .omega = Multiplicity.mul .one (Multiplicity.mul .one .omega)) &&
      (Multiplicity.mul (Multiplicity.mul .one .omega) .zero = Multiplicity.mul .one (Multiplicity.mul .omega .zero)) &&
      (Multiplicity.mul (Multiplicity.mul .one .omega) .one = Multiplicity.mul .one (Multiplicity.mul .omega .one)) &&
      (Multiplicity.mul (Multiplicity.mul .one .omega) .omega = Multiplicity.mul .one (Multiplicity.mul .omega .omega)) &&
      (Multiplicity.mul (Multiplicity.mul .omega .zero) .zero = Multiplicity.mul .omega (Multiplicity.mul .zero .zero)) &&
      (Multiplicity.mul (Multiplicity.mul .omega .zero) .one = Multiplicity.mul .omega (Multiplicity.mul .zero .one)) &&
      (Multiplicity.mul (Multiplicity.mul .omega .zero) .omega = Multiplicity.mul .omega (Multiplicity.mul .zero .omega)) &&
      (Multiplicity.mul (Multiplicity.mul .omega .one) .zero = Multiplicity.mul .omega (Multiplicity.mul .one .zero)) &&
      (Multiplicity.mul (Multiplicity.mul .omega .one) .one = Multiplicity.mul .omega (Multiplicity.mul .one .one)) &&
      (Multiplicity.mul (Multiplicity.mul .omega .one) .omega = Multiplicity.mul .omega (Multiplicity.mul .one .omega)) &&
      (Multiplicity.mul (Multiplicity.mul .omega .omega) .zero = Multiplicity.mul .omega (Multiplicity.mul .omega .zero)) &&
      (Multiplicity.mul (Multiplicity.mul .omega .omega) .one = Multiplicity.mul .omega (Multiplicity.mul .omega .one)) &&
      (Multiplicity.mul (Multiplicity.mul .omega .omega) .omega = Multiplicity.mul .omega (Multiplicity.mul .omega .omega)) = true := rfl
-- Full 3³ left distributivity: a*(b+c) = a*b + a*c
private theorem mul_add_left_distrib_full :
    (Multiplicity.mul .zero (Multiplicity.add .zero .zero) = Multiplicity.add (Multiplicity.mul .zero .zero) (Multiplicity.mul .zero .zero)) &&
      (Multiplicity.mul .zero (Multiplicity.add .zero .one) = Multiplicity.add (Multiplicity.mul .zero .zero) (Multiplicity.mul .zero .one)) &&
      (Multiplicity.mul .zero (Multiplicity.add .zero .omega) = Multiplicity.add (Multiplicity.mul .zero .zero) (Multiplicity.mul .zero .omega)) &&
      (Multiplicity.mul .zero (Multiplicity.add .one .zero) = Multiplicity.add (Multiplicity.mul .zero .one) (Multiplicity.mul .zero .zero)) &&
      (Multiplicity.mul .zero (Multiplicity.add .one .one) = Multiplicity.add (Multiplicity.mul .zero .one) (Multiplicity.mul .zero .one)) &&
      (Multiplicity.mul .zero (Multiplicity.add .one .omega) = Multiplicity.add (Multiplicity.mul .zero .one) (Multiplicity.mul .zero .omega)) &&
      (Multiplicity.mul .zero (Multiplicity.add .omega .zero) = Multiplicity.add (Multiplicity.mul .zero .omega) (Multiplicity.mul .zero .zero)) &&
      (Multiplicity.mul .zero (Multiplicity.add .omega .one) = Multiplicity.add (Multiplicity.mul .zero .omega) (Multiplicity.mul .zero .one)) &&
      (Multiplicity.mul .zero (Multiplicity.add .omega .omega) = Multiplicity.add (Multiplicity.mul .zero .omega) (Multiplicity.mul .zero .omega)) &&
      (Multiplicity.mul .one (Multiplicity.add .zero .zero) = Multiplicity.add (Multiplicity.mul .one .zero) (Multiplicity.mul .one .zero)) &&
      (Multiplicity.mul .one (Multiplicity.add .zero .one) = Multiplicity.add (Multiplicity.mul .one .zero) (Multiplicity.mul .one .one)) &&
      (Multiplicity.mul .one (Multiplicity.add .zero .omega) = Multiplicity.add (Multiplicity.mul .one .zero) (Multiplicity.mul .one .omega)) &&
      (Multiplicity.mul .one (Multiplicity.add .one .zero) = Multiplicity.add (Multiplicity.mul .one .one) (Multiplicity.mul .one .zero)) &&
      (Multiplicity.mul .one (Multiplicity.add .one .one) = Multiplicity.add (Multiplicity.mul .one .one) (Multiplicity.mul .one .one)) &&
      (Multiplicity.mul .one (Multiplicity.add .one .omega) = Multiplicity.add (Multiplicity.mul .one .one) (Multiplicity.mul .one .omega)) &&
      (Multiplicity.mul .one (Multiplicity.add .omega .zero) = Multiplicity.add (Multiplicity.mul .one .omega) (Multiplicity.mul .one .zero)) &&
      (Multiplicity.mul .one (Multiplicity.add .omega .one) = Multiplicity.add (Multiplicity.mul .one .omega) (Multiplicity.mul .one .one)) &&
      (Multiplicity.mul .one (Multiplicity.add .omega .omega) = Multiplicity.add (Multiplicity.mul .one .omega) (Multiplicity.mul .one .omega)) &&
      (Multiplicity.mul .omega (Multiplicity.add .zero .zero) = Multiplicity.add (Multiplicity.mul .omega .zero) (Multiplicity.mul .omega .zero)) &&
      (Multiplicity.mul .omega (Multiplicity.add .zero .one) = Multiplicity.add (Multiplicity.mul .omega .zero) (Multiplicity.mul .omega .one)) &&
      (Multiplicity.mul .omega (Multiplicity.add .zero .omega) = Multiplicity.add (Multiplicity.mul .omega .zero) (Multiplicity.mul .omega .omega)) &&
      (Multiplicity.mul .omega (Multiplicity.add .one .zero) = Multiplicity.add (Multiplicity.mul .omega .one) (Multiplicity.mul .omega .zero)) &&
      (Multiplicity.mul .omega (Multiplicity.add .one .one) = Multiplicity.add (Multiplicity.mul .omega .one) (Multiplicity.mul .omega .one)) &&
      (Multiplicity.mul .omega (Multiplicity.add .one .omega) = Multiplicity.add (Multiplicity.mul .omega .one) (Multiplicity.mul .omega .omega)) &&
      (Multiplicity.mul .omega (Multiplicity.add .omega .zero) = Multiplicity.add (Multiplicity.mul .omega .omega) (Multiplicity.mul .omega .zero)) &&
      (Multiplicity.mul .omega (Multiplicity.add .omega .one) = Multiplicity.add (Multiplicity.mul .omega .omega) (Multiplicity.mul .omega .one)) &&
      (Multiplicity.mul .omega (Multiplicity.add .omega .omega) = Multiplicity.add (Multiplicity.mul .omega .omega) (Multiplicity.mul .omega .omega)) = true := rfl
-- Full 3³ right distributivity: (a+b)*c = a*c + b*c
private theorem mul_add_right_distrib_full :
    (Multiplicity.mul (Multiplicity.add .zero .zero) .zero = Multiplicity.add (Multiplicity.mul .zero .zero) (Multiplicity.mul .zero .zero)) &&
      (Multiplicity.mul (Multiplicity.add .zero .zero) .one = Multiplicity.add (Multiplicity.mul .zero .one) (Multiplicity.mul .zero .one)) &&
      (Multiplicity.mul (Multiplicity.add .zero .zero) .omega = Multiplicity.add (Multiplicity.mul .zero .omega) (Multiplicity.mul .zero .omega)) &&
      (Multiplicity.mul (Multiplicity.add .zero .one) .zero = Multiplicity.add (Multiplicity.mul .zero .zero) (Multiplicity.mul .one .zero)) &&
      (Multiplicity.mul (Multiplicity.add .zero .one) .one = Multiplicity.add (Multiplicity.mul .zero .one) (Multiplicity.mul .one .one)) &&
      (Multiplicity.mul (Multiplicity.add .zero .one) .omega = Multiplicity.add (Multiplicity.mul .zero .omega) (Multiplicity.mul .one .omega)) &&
      (Multiplicity.mul (Multiplicity.add .zero .omega) .zero = Multiplicity.add (Multiplicity.mul .zero .zero) (Multiplicity.mul .omega .zero)) &&
      (Multiplicity.mul (Multiplicity.add .zero .omega) .one = Multiplicity.add (Multiplicity.mul .zero .one) (Multiplicity.mul .omega .one)) &&
      (Multiplicity.mul (Multiplicity.add .zero .omega) .omega = Multiplicity.add (Multiplicity.mul .zero .omega) (Multiplicity.mul .omega .omega)) &&
      (Multiplicity.mul (Multiplicity.add .one .zero) .zero = Multiplicity.add (Multiplicity.mul .one .zero) (Multiplicity.mul .zero .zero)) &&
      (Multiplicity.mul (Multiplicity.add .one .zero) .one = Multiplicity.add (Multiplicity.mul .one .one) (Multiplicity.mul .zero .one)) &&
      (Multiplicity.mul (Multiplicity.add .one .zero) .omega = Multiplicity.add (Multiplicity.mul .one .omega) (Multiplicity.mul .zero .omega)) &&
      (Multiplicity.mul (Multiplicity.add .one .one) .zero = Multiplicity.add (Multiplicity.mul .one .zero) (Multiplicity.mul .one .zero)) &&
      (Multiplicity.mul (Multiplicity.add .one .one) .one = Multiplicity.add (Multiplicity.mul .one .one) (Multiplicity.mul .one .one)) &&
      (Multiplicity.mul (Multiplicity.add .one .one) .omega = Multiplicity.add (Multiplicity.mul .one .omega) (Multiplicity.mul .one .omega)) &&
      (Multiplicity.mul (Multiplicity.add .one .omega) .zero = Multiplicity.add (Multiplicity.mul .one .zero) (Multiplicity.mul .omega .zero)) &&
      (Multiplicity.mul (Multiplicity.add .one .omega) .one = Multiplicity.add (Multiplicity.mul .one .one) (Multiplicity.mul .omega .one)) &&
      (Multiplicity.mul (Multiplicity.add .one .omega) .omega = Multiplicity.add (Multiplicity.mul .one .omega) (Multiplicity.mul .omega .omega)) &&
      (Multiplicity.mul (Multiplicity.add .omega .zero) .zero = Multiplicity.add (Multiplicity.mul .omega .zero) (Multiplicity.mul .zero .zero)) &&
      (Multiplicity.mul (Multiplicity.add .omega .zero) .one = Multiplicity.add (Multiplicity.mul .omega .one) (Multiplicity.mul .zero .one)) &&
      (Multiplicity.mul (Multiplicity.add .omega .zero) .omega = Multiplicity.add (Multiplicity.mul .omega .omega) (Multiplicity.mul .zero .omega)) &&
      (Multiplicity.mul (Multiplicity.add .omega .one) .zero = Multiplicity.add (Multiplicity.mul .omega .zero) (Multiplicity.mul .one .zero)) &&
      (Multiplicity.mul (Multiplicity.add .omega .one) .one = Multiplicity.add (Multiplicity.mul .omega .one) (Multiplicity.mul .one .one)) &&
      (Multiplicity.mul (Multiplicity.add .omega .one) .omega = Multiplicity.add (Multiplicity.mul .omega .omega) (Multiplicity.mul .one .omega)) &&
      (Multiplicity.mul (Multiplicity.add .omega .omega) .zero = Multiplicity.add (Multiplicity.mul .omega .zero) (Multiplicity.mul .omega .zero)) &&
      (Multiplicity.mul (Multiplicity.add .omega .omega) .one = Multiplicity.add (Multiplicity.mul .omega .one) (Multiplicity.mul .omega .one)) &&
      (Multiplicity.mul (Multiplicity.add .omega .omega) .omega = Multiplicity.add (Multiplicity.mul .omega .omega) (Multiplicity.mul .omega .omega)) = true := rfl
-- Named distrib samples (product-facing split / nesting algebra)
private theorem mul_add_left_distrib_one_one_one :
    Multiplicity.mul .one (Multiplicity.add .one .one) =
      Multiplicity.add (Multiplicity.mul .one .one) (Multiplicity.mul .one .one) := rfl
private theorem mul_add_left_distrib_omega_one_one :
    Multiplicity.mul .omega (Multiplicity.add .one .one) =
      Multiplicity.add (Multiplicity.mul .omega .one) (Multiplicity.mul .omega .one) := rfl
private theorem mul_add_right_distrib_one_one_one :
    Multiplicity.mul (Multiplicity.add .one .one) .one =
      Multiplicity.add (Multiplicity.mul .one .one) (Multiplicity.mul .one .one) := rfl
-- Order reflexivity / anti-examples / chain
private theorem le_refl_zero : Multiplicity.le .zero .zero = true := rfl
private theorem le_refl_one : Multiplicity.le .one .one = true := rfl
private theorem le_refl_omega : Multiplicity.le .omega .omega = true := rfl
private theorem not_le_one_zero : Multiplicity.le .one .zero = false := rfl
private theorem not_le_omega_one : Multiplicity.le .omega .one = false := rfl
private theorem not_le_omega_zero : Multiplicity.le .omega .zero = false := rfl
/-- Order chain 0≤1≤ω (and direct 0≤ω) holds definitionally. -/
private theorem le_trans_chain_0_1_omega :
    (Multiplicity.le .zero .one = true) &&
      (Multiplicity.le .one .omega = true) &&
      (Multiplicity.le .zero .omega = true) = true := rfl
private theorem requireLinear_one : Multiplicity.requireLinear .one = true := rfl
private theorem requireLinear_zero : Multiplicity.requireLinear .zero = false := rfl
private theorem isLinear_one : Multiplicity.isLinear .one = true := rfl
private theorem isErased_zero : Multiplicity.isErased .zero = true := rfl
private theorem isUnrestricted_omega : Multiplicity.isUnrestricted .omega = true := rfl
-- Free-safety / 0-qty surface (definitional; product path must erase qty-0)
private theorem isErased_one_false : Multiplicity.isErased .one = false := rfl
private theorem isErased_omega_false : Multiplicity.isErased .omega = false := rfl
private theorem isLinear_zero_false : Multiplicity.isLinear .zero = false := rfl
private theorem isLinear_omega_false : Multiplicity.isLinear .omega = false := rfl
private theorem isRuntime_omega : Multiplicity.isRuntime .omega = true := rfl
private theorem requireLinear_omega : Multiplicity.requireLinear .omega = true := rfl
private theorem lt_zero_one : Multiplicity.lt .zero .one = true := rfl
private theorem lt_one_omega : Multiplicity.lt .one .omega = true := rfl
private theorem not_lt_one_one : Multiplicity.lt .one .one = false := rfl
private theorem not_lt_omega_one : Multiplicity.lt .omega .one = false := rfl
-- mul annihilates with 0 on both sides for remaining pairs
private theorem mul_one_zero : Multiplicity.mul .one .zero = .zero := rfl
private theorem mul_omega_zero : Multiplicity.mul .omega .zero = .zero := rfl
private theorem add_zero_zero : Multiplicity.add .zero .zero = .zero := rfl
private theorem mul_zero_zero : Multiplicity.mul .zero .zero = .zero := rfl
/-- 0*q = q*0 = 0 for all q (zero annihilation; mult-0 policy, not residual_nm/ir). -/
private theorem zero_mul_annihilates :
    (Multiplicity.mul .zero .zero = .zero) &&
      (Multiplicity.mul .zero .one = .zero) &&
      (Multiplicity.mul .zero .omega = .zero) &&
      (Multiplicity.mul .one .zero = .zero) &&
      (Multiplicity.mul .omega .zero = .zero) = true := rfl
-- Enc/dec roundtrip for binder mdata (0/1/ω)
private theorem multToNat_zero : multToNat .zero = 0 := rfl
private theorem multToNat_one : multToNat .one = 1 := rfl
private theorem multToNat_omega : multToNat .omega = 2 := rfl
private theorem multFromNat_zero : multFromNat? 0 = some .zero := rfl
private theorem multFromNat_one : multFromNat? 1 = some .one := rfl
private theorem multFromNat_omega : multFromNat? 2 = some .omega := rfl
private theorem multFromNat_bad : multFromNat? 3 = none := rfl
-- Free-safety policy (definitional; models UseCheck / AffineCheck exact-once + 0-qty erase)
/-- Linear: one consume leaves 0; a second `useOnce` is impossible (exact-once). -/
private theorem linear_exact_once_second_use :
    (Multiplicity.useOnce .one).bind Multiplicity.useOnce = none := rfl
/-- After consuming linear once, remaining qty is not linear and may not be re-consumed. -/
private theorem linear_after_use_not_linear :
    ((Multiplicity.useOnce .one).map Multiplicity.isLinear) = some false := rfl
/-- Linear cannot silent-drop (`mayDiscard = false`) and must be consumable (`requireLinear`). -/
private theorem linear_must_consume :
    (Multiplicity.mayDiscard .one = false) &&
      (Multiplicity.requireLinear .one = true) &&
      (Multiplicity.isLinear .one = true) = true := rfl
/-- 0-qty: erased, not runtime, cannot appear as a runtime use. -/
private theorem zero_qty_erased_policy :
    (Multiplicity.isErased .zero = true) &&
      (Multiplicity.isRuntime .zero = false) &&
      (Multiplicity.useOnce .zero = none) = true := rfl
/-- mult-0 policy: erased / non-runtime / not useOnce-able (not residual_nm/ir emission gates). -/
private theorem zero_qty_implies_non_runtime :
    (Multiplicity.isErased .zero = true) &&
      (Multiplicity.isRuntime .zero = false) &&
      (Multiplicity.useOnce .zero = none) &&
      (Multiplicity.mayDiscard .zero = true) &&
      (Multiplicity.isLinear .zero = false) &&
      (Multiplicity.requireLinear .zero = false) = true := rfl
/-- ω may discard and survives use (unrestricted free-safety complement of linear). -/
private theorem omega_unrestricted_policy :
    (Multiplicity.mayDiscard .omega = true) &&
      (Multiplicity.useOnce .omega = some .omega) &&
      (Multiplicity.isUnrestricted .omega = true) = true := rfl
/-- ω unrestricted free-use: repeated `useOnce` leaves ω. -/
private theorem omega_repeated_useOnce :
    (Multiplicity.useOnce .omega).bind Multiplicity.useOnce = some .omega := rfl
/-- Affine/linear resource model: exact-once + no silent discard (Chan / Fd-like policy). -/
private theorem affine_resource_linear_policy :
    (Multiplicity.isLinear .one = true) &&
      (Multiplicity.mayDiscard .one = false) &&
      (Multiplicity.useOnce .one = some .zero) &&
      ((Multiplicity.useOnce .one).bind Multiplicity.useOnce = none) = true := rfl
/--
Partition ownership (L/R) **caller-contract** policy: linear exact-once + requireLinear +
post-consume residual is not linear. Models exclusive transfer contract — **not** points-to /
separation logic, and **not** residual_nm / residual_ir product gates.
-/
private theorem partition_ownership_linear_policy :
    (Multiplicity.isLinear .one = true) &&
      (Multiplicity.mayDiscard .one = false) &&
      (Multiplicity.useOnce .one = some .zero) &&
      (Multiplicity.requireLinear .one = true) &&
      ((Multiplicity.useOnce .one).map Multiplicity.isLinear = some false) = true := rfl
/--
Full free-safety mult package (definitional Mult algebra policy only).

Joint witness: mult-0 erased/non-runtime/not useOnce-able, zero mul annihilation (incl. 0*0),
linear exact-once (second use impossible + post-consume not linear + requireLinear), ω unrestricted.
Emission residual_nm/residual_ir are separate product gates — not this Mult policy marker.
-/
private theorem product_residual_mult_policy :
    (Multiplicity.isErased .zero = true) &&
      (Multiplicity.isRuntime .zero = false) &&
      (Multiplicity.useOnce .zero = none) &&
      (Multiplicity.mayDiscard .zero = true) &&
      (Multiplicity.isLinear .zero = false) &&
      (Multiplicity.requireLinear .zero = false) &&
      (Multiplicity.mul .zero .zero = .zero) &&
      (Multiplicity.mul .zero .one = .zero) &&
      (Multiplicity.mul .zero .omega = .zero) &&
      (Multiplicity.mul .one .zero = .zero) &&
      (Multiplicity.mul .omega .zero = .zero) &&
      (Multiplicity.isLinear .one = true) &&
      (Multiplicity.mayDiscard .one = false) &&
      (Multiplicity.requireLinear .one = true) &&
      (Multiplicity.useOnce .one = some .zero) &&
      ((Multiplicity.useOnce .one).bind Multiplicity.useOnce = none) &&
      ((Multiplicity.useOnce .one).map Multiplicity.isLinear = some false) &&
      (Multiplicity.mayDiscard .omega = true) &&
      (Multiplicity.useOnce .omega = some .omega) &&
      (Multiplicity.isUnrestricted .omega = true) = true := rfl
/--
Marker that formal **mult algebra** checks typechecked in this module
(tables, assoc, distrib, le, annihilate, mult enc/dec). Free-safety package lemmas
are witnessed by `freeSafetyChecked` / `productResidualMultPolicyChecked` (not duplicated here).
Full 3³ tables: private `*_full` theorems are the single typed locus; `algebraChecked`
witnesses them with `have _ := *_full` (cell failure localization is on those private lemmas).
Not a free `true`.
-/
public def algebraChecked : Bool :=
  have _ : Multiplicity.add .one .one = .omega := add_one_one
  have _ : Multiplicity.mul .zero .one = .zero := mul_zero_one
  have _ : Multiplicity.mul .zero .omega = .zero := mul_zero_omega
  have _ : Multiplicity.mul .one .omega = .omega := mul_one_omega
  have _ : Multiplicity.mul .one .one = .one := mul_one_one
  have _ : Multiplicity.le .zero .one = true := le_zero_one
  have _ : Multiplicity.le .one .omega = true := le_one_omega
  have _ : Multiplicity.le .zero .omega = true := le_zero_omega
  have _ : Multiplicity.mayDiscard .one = false := mayDiscard_one
  have _ : Multiplicity.mayDiscard .omega = true := mayDiscard_omega
  have _ : Multiplicity.mayDiscard .zero = true := mayDiscard_zero
  have _ : Multiplicity.isRuntime .zero = false := isRuntime_zero
  have _ : Multiplicity.isRuntime .one = true := isRuntime_one
  have _ : Multiplicity.useOnce .one = some .zero := useOnce_one
  have _ : Multiplicity.useOnce .zero = none := useOnce_zero
  have _ : Multiplicity.useOnce .omega = some .omega := useOnce_omega
  have _ : Multiplicity.add .zero .one = .one := add_zero_left_one
  have _ : Multiplicity.add .one .zero = .one := add_zero_right_one
  have _ : Multiplicity.add .zero .omega = .omega := add_zero_left_omega
  have _ : Multiplicity.add .omega .zero = .omega := add_zero_right_omega
  have _ : Multiplicity.mul .omega .one = .omega := mul_omega_one
  have _ : Multiplicity.mul .omega .omega = .omega := mul_omega_omega
  have _ : Multiplicity.add .one .omega = Multiplicity.add .omega .one := add_comm_one_omega
  have _ : Multiplicity.add .zero .one = Multiplicity.add .one .zero := add_comm_zero_one
  have _ : Multiplicity.add .zero .omega = Multiplicity.add .omega .zero := add_comm_zero_omega
  have _ : Multiplicity.mul .one .omega = Multiplicity.mul .omega .one := mul_comm_one_omega
  have _ : Multiplicity.mul .zero .omega = Multiplicity.mul .omega .zero := mul_comm_zero_omega
  have _ : Multiplicity.mul .zero .one = Multiplicity.mul .one .zero := mul_comm_zero_one
  have _ : Multiplicity.add .zero .zero = .zero := add_table_0_0
  have _ : Multiplicity.add .zero .one = .one := add_table_0_1
  have _ : Multiplicity.add .zero .omega = .omega := add_table_0_w
  have _ : Multiplicity.add .one .zero = .one := add_table_1_0
  have _ : Multiplicity.add .one .one = .omega := add_table_1_1
  have _ : Multiplicity.add .one .omega = .omega := add_table_1_w
  have _ : Multiplicity.add .omega .zero = .omega := add_table_w_0
  have _ : Multiplicity.add .omega .one = .omega := add_table_w_1
  have _ : Multiplicity.add .omega .omega = .omega := add_table_w_w
  have _ : Multiplicity.mul .zero .zero = .zero := mul_table_0_0
  have _ : Multiplicity.mul .zero .one = .zero := mul_table_0_1
  have _ : Multiplicity.mul .zero .omega = .zero := mul_table_0_w
  have _ : Multiplicity.mul .one .zero = .zero := mul_table_1_0
  have _ : Multiplicity.mul .one .one = .one := mul_table_1_1
  have _ : Multiplicity.mul .one .omega = .omega := mul_table_1_w
  have _ : Multiplicity.mul .omega .zero = .zero := mul_table_w_0
  have _ : Multiplicity.mul .omega .one = .omega := mul_table_w_1
  have _ : Multiplicity.mul .omega .omega = .omega := mul_table_w_w
  have _ : Multiplicity.add (Multiplicity.add .one .one) .one =
      Multiplicity.add .one (Multiplicity.add .one .one) := add_assoc_1_1_1
  have _ : Multiplicity.add (Multiplicity.add .one .one) .omega =
      Multiplicity.add .one (Multiplicity.add .one .omega) := add_assoc_1_1_w
  have _ : Multiplicity.add (Multiplicity.add .zero .one) .omega =
      Multiplicity.add .zero (Multiplicity.add .one .omega) := add_assoc_0_1_w
  have _ : Multiplicity.mul (Multiplicity.mul .one .omega) .omega =
      Multiplicity.mul .one (Multiplicity.mul .omega .omega) := mul_assoc_1_w_w
  have _ : Multiplicity.mul (Multiplicity.mul .zero .one) .omega =
      Multiplicity.mul .zero (Multiplicity.mul .one .omega) := mul_assoc_0_1_w
  -- Full 3³/assoc/distrib/le-chain: private `*_full` lemmas are the typed locus; witness without retyping.
  have _ := add_assoc_full
  have _ := mul_assoc_full
  have _ := mul_add_left_distrib_full
  have _ := mul_add_right_distrib_full
  have _ : Multiplicity.mul .one (Multiplicity.add .one .one) =
      Multiplicity.add (Multiplicity.mul .one .one) (Multiplicity.mul .one .one) :=
    mul_add_left_distrib_one_one_one
  have _ : Multiplicity.mul .omega (Multiplicity.add .one .one) =
      Multiplicity.add (Multiplicity.mul .omega .one) (Multiplicity.mul .omega .one) :=
    mul_add_left_distrib_omega_one_one
  have _ : Multiplicity.mul (Multiplicity.add .one .one) .one =
      Multiplicity.add (Multiplicity.mul .one .one) (Multiplicity.mul .one .one) :=
    mul_add_right_distrib_one_one_one
  have _ : Multiplicity.le .zero .zero = true := le_refl_zero
  have _ : Multiplicity.le .one .one = true := le_refl_one
  have _ : Multiplicity.le .omega .omega = true := le_refl_omega
  have _ : Multiplicity.le .one .zero = false := not_le_one_zero
  have _ : Multiplicity.le .omega .one = false := not_le_omega_one
  have _ : Multiplicity.le .omega .zero = false := not_le_omega_zero
  have _ := le_trans_chain_0_1_omega
  have _ : Multiplicity.requireLinear .one = true := requireLinear_one
  have _ : Multiplicity.requireLinear .zero = false := requireLinear_zero
  have _ : Multiplicity.isLinear .one = true := isLinear_one
  have _ : Multiplicity.isErased .zero = true := isErased_zero
  have _ : Multiplicity.isUnrestricted .omega = true := isUnrestricted_omega
  have _ : Multiplicity.isErased .one = false := isErased_one_false
  have _ : Multiplicity.isErased .omega = false := isErased_omega_false
  have _ : Multiplicity.isLinear .zero = false := isLinear_zero_false
  have _ : Multiplicity.isLinear .omega = false := isLinear_omega_false
  have _ : Multiplicity.isRuntime .omega = true := isRuntime_omega
  have _ : Multiplicity.requireLinear .omega = true := requireLinear_omega
  have _ : Multiplicity.lt .zero .one = true := lt_zero_one
  have _ : Multiplicity.lt .one .omega = true := lt_one_omega
  have _ : Multiplicity.lt .one .one = false := not_lt_one_one
  have _ : Multiplicity.lt .omega .one = false := not_lt_omega_one
  have _ : Multiplicity.mul .one .zero = .zero := mul_one_zero
  have _ : Multiplicity.mul .omega .zero = .zero := mul_omega_zero
  have _ : Multiplicity.add .zero .zero = .zero := add_zero_zero
  have _ : Multiplicity.mul .zero .zero = .zero := mul_zero_zero
  have _ := zero_mul_annihilates
  have _ : multToNat .zero = 0 := multToNat_zero
  have _ : multToNat .one = 1 := multToNat_one
  have _ : multToNat .omega = 2 := multToNat_omega
  have _ : multFromNat? 0 = some .zero := multFromNat_zero
  have _ : multFromNat? 1 = some .one := multFromNat_one
  have _ : multFromNat? 2 = some .omega := multFromNat_omega
  have _ : multFromNat? 3 = none := multFromNat_bad
  true

/--
Free-safety / linear exact-once + 0-qty erasure formal marker.

Witnesses definitional lemmas that model free-safety Mult policy claims
(`qtt_linear_resources_exact_once`, `qtt_zero_quantity_erased`):
* linear must be consumed (no silent drop) and cannot be used twice
* mult-0 is erased / non-runtime / not `useOnce`-able
* ω is unrestricted (may discard; use leaves ω; repeated useOnce stable)
* zero mul annihilates; free-safety mult policy package

This is **not** a proof that elaborator `UseCheck` or LCNF `AffineCheck` are complete
for all surface syntax — only that the multiplicity algebra used by those checkers
satisfies the free-safety policy definitionally. Not residual_nm/residual_ir.
-/
public def freeSafetyChecked : Bool :=
  have _ : Multiplicity.mayDiscard .one = false := mayDiscard_one
  have _ : Multiplicity.useOnce .one = some .zero := useOnce_one
  have _ : Multiplicity.useOnce .zero = none := useOnce_zero
  have _ : Multiplicity.isErased .zero = true := isErased_zero
  have _ : Multiplicity.isRuntime .zero = false := isRuntime_zero
  have _ : Multiplicity.isLinear .one = true := isLinear_one
  have _ : Multiplicity.requireLinear .one = true := requireLinear_one
  have _ :
      (Multiplicity.useOnce .one).bind Multiplicity.useOnce = none := linear_exact_once_second_use
  have _ :
      ((Multiplicity.useOnce .one).map Multiplicity.isLinear) = some false :=
    linear_after_use_not_linear
  have _ :
      (Multiplicity.mayDiscard .one = false) &&
        (Multiplicity.requireLinear .one = true) &&
        (Multiplicity.isLinear .one = true) = true := linear_must_consume
  have _ :
      (Multiplicity.isErased .zero = true) &&
        (Multiplicity.isRuntime .zero = false) &&
        (Multiplicity.useOnce .zero = none) = true := zero_qty_erased_policy
  have _ :
      (Multiplicity.isErased .zero = true) &&
        (Multiplicity.isRuntime .zero = false) &&
        (Multiplicity.useOnce .zero = none) &&
        (Multiplicity.mayDiscard .zero = true) &&
        (Multiplicity.isLinear .zero = false) &&
        (Multiplicity.requireLinear .zero = false)
      = true := zero_qty_implies_non_runtime
  have _ :
      (Multiplicity.mul .zero .zero = .zero) &&
        (Multiplicity.mul .zero .one = .zero) &&
        (Multiplicity.mul .zero .omega = .zero) &&
        (Multiplicity.mul .one .zero = .zero) &&
        (Multiplicity.mul .omega .zero = .zero)
      = true := zero_mul_annihilates
  have _ :
      (Multiplicity.mayDiscard .omega = true) &&
        (Multiplicity.useOnce .omega = some .omega) &&
        (Multiplicity.isUnrestricted .omega = true) = true := omega_unrestricted_policy
  have _ : Multiplicity.mayDiscard .omega = true := mayDiscard_omega
  have _ : Multiplicity.useOnce .omega = some .omega := useOnce_omega
  have _ :
      (Multiplicity.useOnce .omega).bind Multiplicity.useOnce = some .omega :=
    omega_repeated_useOnce
  have _ :
      (Multiplicity.isLinear .one = true) &&
        (Multiplicity.mayDiscard .one = false) &&
        (Multiplicity.useOnce .one = some .zero) &&
        ((Multiplicity.useOnce .one).bind Multiplicity.useOnce = none)
      = true := affine_resource_linear_policy
  have _ :
      (Multiplicity.isLinear .one = true) &&
        (Multiplicity.mayDiscard .one = false) &&
        (Multiplicity.useOnce .one = some .zero) &&
        (Multiplicity.requireLinear .one = true) &&
        ((Multiplicity.useOnce .one).map Multiplicity.isLinear = some false)
      = true := partition_ownership_linear_policy
  have _ :
      (Multiplicity.isErased .zero = true) &&
        (Multiplicity.isRuntime .zero = false) &&
        (Multiplicity.useOnce .zero = none) &&
        (Multiplicity.mayDiscard .zero = true) &&
        (Multiplicity.isLinear .zero = false) &&
        (Multiplicity.requireLinear .zero = false) &&
        (Multiplicity.mul .zero .zero = .zero) &&
        (Multiplicity.mul .zero .one = .zero) &&
        (Multiplicity.mul .zero .omega = .zero) &&
        (Multiplicity.mul .one .zero = .zero) &&
        (Multiplicity.mul .omega .zero = .zero) &&
        (Multiplicity.isLinear .one = true) &&
        (Multiplicity.mayDiscard .one = false) &&
        (Multiplicity.requireLinear .one = true) &&
        (Multiplicity.useOnce .one = some .zero) &&
        ((Multiplicity.useOnce .one).bind Multiplicity.useOnce = none) &&
        ((Multiplicity.useOnce .one).map Multiplicity.isLinear = some false) &&
        (Multiplicity.mayDiscard .omega = true) &&
        (Multiplicity.useOnce .omega = some .omega) &&
        (Multiplicity.isUnrestricted .omega = true)
      = true := product_residual_mult_policy
  true

/--
Free-safety **multiplicity algebra** policy marker (greppable name `productResidualMultPolicyChecked`).

Witnesses mult-0 policy (erased/non-runtime/not useOnce-able), zero mul annihilation (incl. 0*0),
linear exact-once + second use impossible + post-consume not linear, affine / partition
**caller-contract** linear policies, and ω unrestricted. Definitional Mult algebra only —
emission residual_nm / residual_ir are separate `systems-validate` gates, not this marker.
-/
public def productResidualMultPolicyChecked : Bool :=
  have _ :
      (Multiplicity.isErased .zero = true) &&
        (Multiplicity.isRuntime .zero = false) &&
        (Multiplicity.useOnce .zero = none) &&
        (Multiplicity.mayDiscard .zero = true) &&
        (Multiplicity.isLinear .zero = false) &&
        (Multiplicity.requireLinear .zero = false)
      = true := zero_qty_implies_non_runtime
  have _ :
      (Multiplicity.mul .zero .zero = .zero) &&
        (Multiplicity.mul .zero .one = .zero) &&
        (Multiplicity.mul .zero .omega = .zero) &&
        (Multiplicity.mul .one .zero = .zero) &&
        (Multiplicity.mul .omega .zero = .zero)
      = true := zero_mul_annihilates
  have _ :
      (Multiplicity.isErased .zero = true) &&
        (Multiplicity.isRuntime .zero = false) &&
        (Multiplicity.useOnce .zero = none)
      = true := zero_qty_erased_policy
  have _ :
      (Multiplicity.isLinear .one = true) &&
        (Multiplicity.mayDiscard .one = false) &&
        (Multiplicity.useOnce .one = some .zero) &&
        ((Multiplicity.useOnce .one).bind Multiplicity.useOnce = none)
      = true := affine_resource_linear_policy
  have _ :
      (Multiplicity.isLinear .one = true) &&
        (Multiplicity.mayDiscard .one = false) &&
        (Multiplicity.useOnce .one = some .zero) &&
        (Multiplicity.requireLinear .one = true) &&
        ((Multiplicity.useOnce .one).map Multiplicity.isLinear = some false)
      = true := partition_ownership_linear_policy
  have _ :
      (Multiplicity.isErased .zero = true) &&
        (Multiplicity.isRuntime .zero = false) &&
        (Multiplicity.useOnce .zero = none) &&
        (Multiplicity.mayDiscard .zero = true) &&
        (Multiplicity.isLinear .zero = false) &&
        (Multiplicity.requireLinear .zero = false) &&
        (Multiplicity.mul .zero .zero = .zero) &&
        (Multiplicity.mul .zero .one = .zero) &&
        (Multiplicity.mul .zero .omega = .zero) &&
        (Multiplicity.mul .one .zero = .zero) &&
        (Multiplicity.mul .omega .zero = .zero) &&
        (Multiplicity.isLinear .one = true) &&
        (Multiplicity.mayDiscard .one = false) &&
        (Multiplicity.requireLinear .one = true) &&
        (Multiplicity.useOnce .one = some .zero) &&
        ((Multiplicity.useOnce .one).bind Multiplicity.useOnce = none) &&
        ((Multiplicity.useOnce .one).map Multiplicity.isLinear = some false) &&
        (Multiplicity.mayDiscard .omega = true) &&
        (Multiplicity.useOnce .omega = some .omega) &&
        (Multiplicity.isUnrestricted .omega = true)
      = true := product_residual_mult_policy
  have _ :
      (Multiplicity.mayDiscard .omega = true) &&
        (Multiplicity.useOnce .omega = some .omega) &&
        (Multiplicity.isUnrestricted .omega = true)
      = true := omega_unrestricted_policy
  have _ :
      (Multiplicity.useOnce .one).bind Multiplicity.useOnce = none :=
    linear_exact_once_second_use
  have _ :
      (Multiplicity.useOnce .omega).bind Multiplicity.useOnce = some .omega :=
    omega_repeated_useOnce
  true
end Multiplicity.Theorems



end Lean.Compiler

namespace Lean

export Compiler (Multiplicity)

end Lean
