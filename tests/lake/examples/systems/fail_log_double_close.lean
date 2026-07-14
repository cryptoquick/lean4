module
prelude

/-!
Regression: double-close of an affine `Log` must be rejected by the freestanding
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
public structure Log where
 raw : USize

@[never_extract, extern c inline "((size_t)open((const char*)(#1), O_RDWR|O_CREAT, 0644))"]
public axiom logOpen (path : USize) : Log

@[never_extract, extern c inline "((uint32_t)close((int)(#1)))"]
public axiom logClose (log : Log) : U32
end Systems.Sys

open Systems.Sys
open Systems.Scalars

@[export_c lean_fs_log_double_close]
public def logDoubleClose (path : USize) : U32 :=
 let log := Systems.Sys.logOpen path
 let _e1 := Systems.Sys.logClose log
 let e2 := Systems.Sys.logClose log
 e2
