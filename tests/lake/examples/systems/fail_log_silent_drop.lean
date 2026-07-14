module
prelude

/-!
Regression: silent drop of a let-bound affine `Log` without close must be rejected.
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
end Systems.Sys

open Systems.Sys
open Systems.Scalars

@[export_c lean_fs_log_silent_drop]
public def logSilentDrop (path : USize) : U32 :=
 let _log := Systems.Sys.logOpen path
 U32.zero
