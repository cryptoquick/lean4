module
prelude

/-!
Regression: free of an arena-derived `BytePtr` must not kill the arena region
or allow dropping the `Arena` without `Arena.free`.

`bufFree` is typed on `MallocBuf` only; a free-shaped consumer of `BytePtr` must not
invalidate arena ownership (root-type kill). After such a free, the arena is still owned →
silent drop if not freed.
-/

namespace Systems.Scalars
public axiom USize : Type
public axiom U32 : Type
@[extern c inline "0"] public axiom U32.zero : U32
end Systems.Scalars

namespace Systems.Sys
open Systems.Scalars

@[affine]
public structure Arena where
 raw : USize

@[affine]
public structure BytePtr where
 addr : USize

@[never_extract, extern c inline "((size_t)malloc((size_t)(#1) + 3 * sizeof(size_t)))"]
public axiom Arena.create (cap : USize) : Arena

@[never_extract, extern c inline "(((size_t*)(#1))[2] = (size_t)(((uint8_t*)(#1)) + 3 * sizeof(size_t)), (size_t)(#1))"]
public axiom Arena.alloc (a : Arena) (nbytes : USize) : Arena

@[fs_borrow, never_extract, extern c inline "((size_t)(#1) ? ((size_t*)(#1))[2] : (size_t)0)"]
public axiom Arena.lastPtr (a : Arena) : BytePtr

/-- Hostile free of a derived BytePtr (not the public API). Must not kill Arena region. -/
@[never_extract, extern c inline "(free((void*)(#1)), (uint32_t)0)"]
public axiom badFreeBytePtr (p : BytePtr) : U32
end Systems.Sys

open Systems.Sys
open Systems.Scalars

/-- free derived ptr then drop arena without Arena.free → silent drop of Arena (not accepted). -/
@[export_c lean_fs_arena_buf_free_derived]
public def arenaBufFreeDerived (cap : USize) (n : USize) : U32 :=
 let a := Systems.Sys.Arena.create cap
 let a := Systems.Sys.Arena.alloc a n
 let p := Systems.Sys.Arena.lastPtr a
 let _e := Systems.Sys.badFreeBytePtr p
 U32.zero
