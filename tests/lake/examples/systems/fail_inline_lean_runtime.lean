module
prelude

/-!
Regression: freestanding emit must reject inline extern patterns that call Lean runtime (N6).
-/

namespace Systems.Scalars
public axiom U64 : Type
@[extern c inline "lean_uint64_add(#1, #2)"] public axiom evilAdd : U64 → U64 → U64
end Systems.Scalars

open Systems.Scalars

@[export_c lean_fs_evil]
public def add (x y : U64) : U64 :=
 evilAdd x y
