module

meta import Foo.Bar

/-!
Host under `srcDir = "src"` uses **`meta import Foo.Bar`** so import-scan must:
1. resolve `src/Host.lean` (not package-root `Host.lean`);
2. resolve dotted target `Foo.Bar` → `src/Foo/Bar.lean`;
3. accept the `meta import` keyword variant;
4. place Foo.Bar before Host in the package plan.
-/

namespace Host

def marker : String := "srcdir_shaped_host"

end Host
