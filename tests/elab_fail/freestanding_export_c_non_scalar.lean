module
prelude
-- Freestanding K12 ABI: export_c rejects non-scalar signatures.

/-- Not a freestanding scalar (not in Systems.Scalars type table). -/
public axiom Blob : Type

@[export_c lean_bad_blob]
public def bad (x : Blob) : Blob := x
