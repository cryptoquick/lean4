module

import Core

/-!
Minimal Systems-shaped second library for multi-target plan dogfood.

Imports `Core` so freestanding package plan can exercise the **import-scan DAG**
path (declaration order lists Host before Core; topo must still place Core first).
-/

namespace Host

def marker : String := "systems_shaped_host"

end Host
