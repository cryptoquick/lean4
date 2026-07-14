module
prelude

/-!
Regression: freestanding emit must reject mangled Lean `l_*` identifiers even when
embedded inside a GNU statement expression (not only as a whole-pattern prefix).
This check also rejects GNU statement-expr openers themselves; this fixture still exercises both
the dialect reject and (historically) the `l_*` identifier scan.
-/

namespace Systems.Scalars
public axiom U64 : Type
@[extern c inline "({ l_Foo(#1); })"] public axiom evilMangle : U64 → U64
end Systems.Scalars

open Systems.Scalars

@[export_c lean_fs_evil_mangle]
public def wrap (x : U64) : U64 :=
 evilMangle x
