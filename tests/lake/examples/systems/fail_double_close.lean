module
prelude

/-!
Regression: double-close of an affine `Fd` must be rejected by the freestanding
affine checker (`use-after-move`).
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

@[never_extract, extern c inline "((uint32_t)close((int)(#1)))"]
public axiom sysClose (fd : Fd) : U32

@[extern c inline "0"] public axiom oRdonly : U32
end Systems.Sys

open Systems.Sys
open Systems.Scalars

@[export_c lean_fs_double_close]
public def doubleClose (path : USize) : U32 :=
 let fd := Systems.Sys.sysOpen path oRdonly U32.zero
 let _e1 := Systems.Sys.sysClose fd
 let e2 := Systems.Sys.sysClose fd
 e2
