module
prelude

/-!
Regression: put/get after `logClose` must be rejected (`use-after-move` of affine `Log`).
Mirrors `fail_use_after_close.lean` for `Fd`.
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

@[fs_borrow, never_extract, extern c inline "((uint32_t)0)"]
public axiom logPut (log : Log) (k : USize) (klen : USize) (v : USize) (vlen : USize) : U32
end Systems.Sys

open Systems.Sys
open Systems.Scalars

@[export_c lean_fs_log_use_after_close]
public def logUseAfterClose (path : USize) (k : USize) (klen : USize) (v : USize) (vlen : USize) : U32 :=
 let log := Systems.Sys.logOpen path
 let _e := Systems.Sys.logClose log
 Systems.Sys.logPut log k klen v vlen
