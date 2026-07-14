module
prelude

/-!
Regression: silent drop of a let-bound affine `Fd` without close must be rejected.
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

@[never_extract, extern c inline "((size_t)open((const char*)(#1), (int)(#2), (int)(#3)))"]
public axiom sysOpen (path : USize) (flags : U32) (mode : U32) : Fd

@[extern c inline "0"] public axiom oRdonly : U32
end Systems.Sys

open Systems.Sys
open Systems.Scalars

@[export_c lean_fs_silent_drop]
public def silentDrop (path : USize) : U32 :=
 let _fd := Systems.Sys.sysOpen path oRdonly U32.zero
 U32.zero
