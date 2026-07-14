/-
Copyright (c) 2026 Lean FRO, LLC. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Hunter Beast
-/
module

prelude
public import Lean.Compiler.QTT.ElabCheck
public import Lean.Compiler.QTT.UseCheck
public import Lean.Compiler.QTT.Theorems
public import Lean.Compiler.QTT.FreeSafety

/-!
# Systems Lean QTT (quantitative type theory) package

Opt-in freestanding / `compiler.qtt` multiplicities, elaborator use/split checking,
formal algebra lemmas, and free-safety formal markers. Does not change classic Lean
when QTT mode is off.
-/
