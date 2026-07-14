import Lake
open System Lake DSL

/-!
# systems_host

Host-only Lean package for proofs about the systems freestanding computational spine (K9).

* Explicit empty `leanOptions` — never set `compiler.freestanding=true`.
* Full host `Init` / tactics / `Prop` available.
* Only `Specs.Scalars` requires freestanding oleans (I6 bridge); Checksum/Log are freestanding-free.
* Host Lake may emit host IR/C; those artifacts are **not** linked into the freestanding `.a`.
-/

package systems_host

require systems from ".." / "lib"

@[default_target]
lean_lib Host where
  roots := #[`Host, `Specs.Scalars, `Specs.Checksum, `Specs.Log]
  -- Dual-pipeline contract: host never enables freestanding codegen (Makefile greps this).
  leanOptions := #[]
