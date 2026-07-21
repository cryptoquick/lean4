module

/-!
A24/A25 globs_shaped: base module under per-lib `srcDir = "lib"`.
Plan expands from `globs = ["Core.*"]` → Core + recursive multi-level children
(Core.Extra, Core.Nested.Deep).
-/

namespace Core

def marker : String := "globs_shaped_core"

end Core
