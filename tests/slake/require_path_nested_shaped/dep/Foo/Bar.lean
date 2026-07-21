/-!
Nested path-dep module for A31: plan node `Foo.Bar` → `dep/Foo/Bar.lean`
and C/OBJ under `dep/.slake-native/Foo/Bar.{c,o}` (not doubled Foo/Foo/Bar).
-/

namespace Foo.Bar

def marker : String := "nested_pathdep_foo_bar"

end Foo.Bar
