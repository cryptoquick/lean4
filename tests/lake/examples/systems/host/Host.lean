module

public import Specs.Scalars
public import Specs.Checksum
public import Specs.Log

/-!
# Host — host-proof root (dual pipeline)

Machine-checked host specs about the freestanding computational spine:

* `Specs.Scalars` — freestanding `U64`/`U32` ↔ host bridge (imports freestanding oleans)
* `Specs.Checksum` — pure polynomial fold model of freestanding (freestanding-free)
* `Specs.Log` — abstract last-write-wins policy model of freestanding (freestanding-free)

This package is **host-only**: explicit empty `leanOptions` (no `compiler.freestanding`),
full `Init`/tactics/`Prop`. Host Lake still emits ordinary host IR/C for computational
defs; those artifacts are **not** linked into the freestanding embed `.a`. Prop is erased
from the extract TCB.
-/

namespace Host

/-- Smoke: harness checksum constant is machine-checked on the pure host model. -/
theorem checksum_harness : Specs.Checksum.fold [1, 2, 3, 4, 5] = 986115 :=
  Specs.Checksum.fold_harness_12345

/-- Smoke: LWW get-after-put on the abstract log. -/
theorem log_lww_smoke :
    Specs.Log.get (Specs.Log.put [] [1, 2] [9, 9]) [1, 2] = some [9, 9] := by
  simp [Specs.Log.get_put_same]

end Host
