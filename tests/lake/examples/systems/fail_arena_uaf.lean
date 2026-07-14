module
prelude

/-!
Regression: use of a `BytePtr` derived from an arena after `Arena.free` must be
rejected as **region use-after-free** (AffineCheck region stamps).

Shape: free the arena, then **return** the live `BytePtr` (a consuming use). Returning
the derived handle after free reaches LCNF region UAF. A post-free `@[fs_borrow]` cast
only (`asUSizeUnchecked`) is rejected earlier as QTT silent-drop of the unconsumed
`BytePtr` and does **not** exercise the region gate.

Note: casting with `asUSizeUnchecked` **before** free, then using the raw `USize` after free,
is **out of scope** for the MVP region gate (K11 dual-param ABI erases the handle).
-/

namespace Systems.Scalars
public axiom USize : Type
public axiom U32 : Type
public axiom U8 : Type
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

@[never_extract, extern c inline "(free((void*)(#1)), (uint32_t)0)"]
public axiom Arena.free (a : Arena) : U32
end Systems.Sys

open Systems.Sys
open Systems.Scalars

/-- Free arena then return derived `BytePtr` — region use-after-free. -/
@[export_c lean_fs_arena_uaf]
public def arenaUaf (cap : USize) (n : USize) : BytePtr :=
 let a := Systems.Sys.Arena.create cap
 let a := Systems.Sys.Arena.alloc a n
 let p := Systems.Sys.Arena.lastPtr a
 let _e := Systems.Sys.Arena.free a
 p
