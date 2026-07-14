module
prelude

/-!
Regression: silent drop of a let-bound affine `Arena` without free must be rejected.
-/

namespace Systems.Scalars
public axiom USize : Type
public axiom U32 : Type
@[extern c inline "0"] public axiom U32.zero : U32
end Systems.Scalars

namespace Systems.Sys
open Systems.Scalars

@[affine]
public structure Arena where
 raw : USize

@[never_extract, extern c inline "((size_t)malloc((size_t)(#1) + 3 * sizeof(size_t)))"]
public axiom Arena.create (cap : USize) : Arena
end Systems.Sys

open Systems.Sys
open Systems.Scalars

@[export_c lean_fs_arena_silent_drop]
public def arenaSilentDrop (cap : USize) : U32 :=
 let _a := Systems.Sys.Arena.create cap
 U32.zero
