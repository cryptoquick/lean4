/-
Copyright (c) 2026 Hunter Beast. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Hunter Beast
-/
module

public import Slake.CLI

/-!
# SlakeMain

Entry point for the classic-host `slake` executable (built via
`tests/slake/driver`). Not freestanding product TCB.
-/

/-- Classic host `slake` driver entry. -/
public def main (args : List String) : IO UInt32 :=
  Slake.CLI.run args
