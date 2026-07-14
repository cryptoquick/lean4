module
prelude

/-!
Regression: double-free of an affine `Arena` must be rejected (`use-after-move`).
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

@[never_extract, extern c inline "(free((void*)(#1)), (uint32_t)0)"]
public axiom Arena.free (a : Arena) : U32
end Systems.Sys

open Systems.Sys
open Systems.Scalars

@[export_c lean_fs_arena_double_free]
public def arenaDoubleFree (cap : USize) : U32 :=
 let a := Systems.Sys.Arena.create cap
 let _e1 := Systems.Sys.Arena.free a
 Systems.Sys.Arena.free a
