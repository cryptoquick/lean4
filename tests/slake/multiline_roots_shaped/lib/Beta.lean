module

import Alpha

/-!
A18 multiline_roots_shaped: second root imports Alpha under the same per-lib
srcDir. Import-scan must place Alpha before Beta (same golden as single-line
A16 roots_shaped).
-/

namespace Beta

def marker : String := "multiline_roots_shaped_beta"

end Beta
