module
prelude

/-!
Regression: ownership sink — affine parameter moved in but never closed/returned
must be rejected. Default (non-`@[fs_borrow]`) params are owned, not silently droppable.
-/

namespace Systems.Scalars
public axiom USize : Type
public axiom U32 : Type
@[extern c inline "0"] public axiom U32.zero : U32
end Systems.Scalars

namespace Systems.Sys
open Systems.Scalars

@[affine]
public structure Fd where
 raw : USize
end Systems.Sys

open Systems.Sys
open Systems.Scalars

/-- Ownership sink: takes moved `Fd` and discards without close. -/
@[export_c lean_fs_drop_fd]
public def dropFd (fd : Fd) : U32 :=
 U32.zero
