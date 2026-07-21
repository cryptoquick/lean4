module

/-!
Nested dotted module under `srcDir = "src"`: plan node `Foo.Bar` → `src/Foo/Bar.lean`.
-/

namespace Foo.Bar

def marker : String := "srcdir_shaped_foo_bar"

end Foo.Bar
