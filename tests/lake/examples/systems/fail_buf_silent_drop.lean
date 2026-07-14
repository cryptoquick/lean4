module
prelude

/-!
Regression: silent drop of a let-bound affine `MallocBuf` without `bufFree` must be rejected.
-/

namespace Systems.Scalars
public axiom USize : Type
public axiom U32 : Type
@[extern c inline "0"] public axiom U32.zero : U32
end Systems.Scalars

namespace Systems.Sys
open Systems.Scalars

@[affine]
public structure MallocBuf where
 raw : USize

@[never_extract, extern c inline "((size_t)malloc((size_t)(#1)))"]
public axiom bufAlloc (n : USize) : MallocBuf
end Systems.Sys

open Systems.Sys
open Systems.Scalars

@[export_c lean_fs_buf_silent_drop]
public def bufSilentDrop (n : USize) : U32 :=
 let _p := Systems.Sys.bufAlloc n
 U32.zero
