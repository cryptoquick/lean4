module
prelude

/-!
Regression: `dlopen` must be rejected in **inline** extern patterns.
mmap is allowlisted on the freestanding libc allowlist; residual fail-closed gate uses a still-forbidden symbol.
-/

namespace Systems.Scalars
public axiom USize : Type
@[never_extract, extern c inline "((size_t)dlopen((const char*)(#1), (int)(#2)))"]
public axiom evilDlopenInline : USize → USize → USize
end Systems.Scalars

open Systems.Scalars

@[export_c lean_fs_evil_dlopen_inline]
public def wrap (path : USize) (flags : USize) : USize :=
 evilDlopenInline path flags
