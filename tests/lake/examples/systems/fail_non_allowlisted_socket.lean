module
prelude

/-!
Regression: `socket` is not on the freestanding libc allowlist.
Fail-closed emit must reject it as a non-allowlisted standard extern
(mmap is allowlisted on the freestanding libc allowlist; residual gate uses a still-forbidden symbol).
-/

namespace Systems.Scalars
public axiom USize : Type
public axiom U32 : Type
end Systems.Scalars

open Systems.Scalars

/-- Deliberately non-allowlisted POSIX symbol. -/
@[never_extract, extern "socket"]
public axiom badSocket (domain : U32) (type : U32) (protocol : U32) : USize

@[export_c lean_fs_bad_socket]
public def useBadSocket (d t p : U32) : USize :=
 badSocket d t p
