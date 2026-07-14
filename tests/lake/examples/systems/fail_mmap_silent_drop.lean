module
prelude

/-!
Regression: silent drop of a let-bound affine `MMap` without munmap must be rejected.
-/

namespace Systems.Scalars
public axiom USize : Type
public axiom U32 : Type
@[extern c inline "0"] public axiom U32.zero : U32
@[extern c inline "0"] public axiom USize.zero : USize
end Systems.Scalars

namespace Systems.Sys
open Systems.Scalars

@[affine]
public structure Fd where
 raw : USize

@[affine]
public structure MMap where
 addr : USize

@[never_extract, extern c inline "((size_t)open((const char*)(#1), (int)(#2), (int)(#3)))"]
public axiom sysOpen (path : USize) (flags : U32) (mode : U32) : Fd

@[fs_borrow, never_extract, extern c inline "((uint32_t)ftruncate((int)(#1), (long)(#2)))"]
public axiom sysFtruncate (fd : Fd) (len : USize) : U32

@[fs_borrow, fs_fresh_region, never_extract,
 extern c inline "((size_t)mmap((void*)0, (size_t)(#2), (int)(#3), (int)(#4), (int)(#1), (long)(#5)))"]
public axiom sysMmap (fd : Fd) (len : USize) (prot : U32) (flags : U32) (off : USize) : MMap

@[never_extract, extern c inline "((uint32_t)close((int)(#1)))"]
public axiom sysClose (fd : Fd) : U32

@[extern c inline "2"] public axiom oRdwr : U32
end Systems.Sys

open Systems.Sys
open Systems.Scalars

@[export_c lean_fs_mmap_silent_drop]
public def mmapSilentDrop (path : USize) (len : USize) (prot : U32) (flags : U32) : U32 :=
 let fd := Systems.Sys.sysOpen path oRdwr U32.zero
 let _t := Systems.Sys.sysFtruncate fd len
 let _m := Systems.Sys.sysMmap fd len prot flags USize.zero
 Systems.Sys.sysClose fd
