module
prelude

/-!
Regression: freestanding emit must reject `lean_io_*` / non-allowlisted standard externs.
-/

namespace Systems.Scalars
public axiom U32 : Type
@[extern "lean_io_eprint"] public axiom evilIo : U32 → U32
end Systems.Scalars

open Systems.Scalars

@[export_c lean_fs_evil_io]
public def wrap (x : U32) : U32 :=
 evilIo x
