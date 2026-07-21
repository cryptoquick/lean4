module

import Core.Extra

/-!
A25 globs_shaped: multi-level nested submodule under lib/Core/Nested/Deep.lean.
`globs = ["Core.*"]` recursive walk must include Core.Nested.Deep.
Import-scan: Core.Extra before Core.Nested.Deep when both are plan nodes.
-/

namespace Core.Nested.Deep

def marker : String := "globs_shaped_core_nested_deep"

end Core.Nested.Deep
