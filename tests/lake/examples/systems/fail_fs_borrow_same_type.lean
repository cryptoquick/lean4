module
prelude

/-!
Regression: `@[fs_borrow]` must not return the same affine type as a
borrowed parameter. That would dual-own one runtime resource (fresh region → double-free;
shared region → dual stamp ownership). Derived views use a distinct type (`BytePtr` from `Arena`).
-/

namespace Systems.Scalars
public axiom USize : Type
public axiom U32 : Type
end Systems.Scalars

namespace Systems.Sys
open Systems.Scalars

@[affine]
public structure Arena where
 raw : USize

@[never_extract, extern c inline "(#1)"]
public axiom Arena.create (cap : USize) : Arena

@[never_extract, extern c inline "(free((void*)(#1)), (uint32_t)0)"]
public axiom Arena.free (a : Arena) : U32

/-- Illegal: same-type fs_borrow affine return (peek). -/
@[fs_borrow, never_extract, extern c inline "(#1)"]
public axiom Arena.peek (a : Arena) : Arena
end Systems.Sys

open Systems.Sys
open Systems.Scalars

@[export_c lean_fs_peek_double_free]
public def peekDoubleFree (cap : USize) : U32 :=
 let a := Systems.Sys.Arena.create cap
 let a2 := Systems.Sys.Arena.peek a
 let _e1 := Systems.Sys.Arena.free a
 Systems.Sys.Arena.free a2
