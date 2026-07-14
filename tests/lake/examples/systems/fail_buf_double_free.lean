module
prelude

/-!
Regression: double-free of affine `MallocBuf` must be rejected (`use-after-move`).
-/

namespace Systems.Scalars
public axiom USize : Type
public axiom U32 : Type
end Systems.Scalars

namespace Systems.Sys
open Systems.Scalars

@[affine]
public structure MallocBuf where
 raw : USize

@[never_extract, extern c inline "((size_t)malloc((size_t)(#1)))"]
public axiom bufAlloc (n : USize) : MallocBuf

@[never_extract, extern c inline "(free((void*)(#1)), (uint32_t)0)"]
public axiom bufFree (p : MallocBuf) : U32
end Systems.Sys

open Systems.Sys
open Systems.Scalars

@[export_c lean_fs_buf_double_free]
public def bufDoubleFree (n : USize) : U32 :=
 let p := Systems.Sys.bufAlloc n
 let _e1 := Systems.Sys.bufFree p
 Systems.Sys.bufFree p
