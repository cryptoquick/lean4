module

import Alpha

/-!
A16 roots_shaped: second root imports Alpha under the same per-lib srcDir.
Import-scan must place Alpha before Beta (not declaration-order Beta-only /
not lib name `Lib`).
-/

namespace Beta

def marker : String := "roots_shaped_beta"

end Beta
