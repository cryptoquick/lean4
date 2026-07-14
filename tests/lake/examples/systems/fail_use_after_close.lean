module
prelude

/-!
Regression: write after close (use-after-move of affine `Fd`) must be rejected.
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

@[fs_borrow, never_extract, extern c inline "((size_t)write((int)(#1), (const void*)(#2), (size_t)(#3)))"]
public axiom sysWrite (fd : Fd) (buf : USize) (len : USize) : USize

@[extern c inline "0"] public axiom oRdonly : U32
end Systems.Sys

open Systems.Sys
open Systems.Scalars

@[export_c lean_fs_use_after_close]
public def useAfterClose (path : USize) (buf : USize) (len : USize) : USize :=
 let fd := Systems.Sys.sysOpen path oRdonly U32.zero
 let _e := Systems.Sys.sysClose fd
 Systems.Sys.sysWrite fd buf len
