module

/-!
# Specs.Log — abstract append-log model (last-write-wins)

Pure host model of last-write-wins key/value lookup over an abstract sequence of records.

This **abstracts the LWW policy** of freestanding `logPut`/`logGet` (scan from offset 0;
later equal keys win). It does **not** machine-check on-disk layout, endian, `uint32`
narrowing, error codes, or C statement-expr bodies (no C semantics / no FFI refinement).

**Freestanding-free:** no import of extract APIs. Extract format changes will not break
typecheck here by design — treat that as **model drift risk**, not a free proof of the extract.
-/

namespace Specs.Log

/-- One abstract record: key/value as byte lists.

On freestanding wire (informal): `uint32_t klen; uint32_t vlen; key[klen]; val[vlen]`
(host endian). Lengths are implicit in the host lists; overflow / narrow checks stay in the
extract and are not modeled here. -/
public structure Record where
  key : List UInt8
  val : List UInt8
  deriving DecidableEq, Repr

/-- Abstract log: chronological sequence of appended records. -/
public abbrev Log := List Record

/-- Append a put (abstract analogue of freestanding `logPut` growing the file). -/
@[expose] public def put (log : Log) (k v : List UInt8) : Log :=
  log ++ [{ key := k, val := v }]

/-- Last-write-wins get: scan left-to-right, keep the latest matching value.

Abstracts the LWW policy of freestanding `logGet` (not a refinement of the C scan body). -/
@[expose] public def get (log : Log) (k : List UInt8) : Option (List UInt8) :=
  log.foldl (fun acc r => if r.key = k then some r.val else acc) none

/-- Empty log has no entries. -/
public theorem get_nil (k : List UInt8) : get [] k = none := by
  simp [get]

/-- Put then get the same key returns that value (last write wins over prior history). -/
public theorem get_put_same (log : Log) (k v : List UInt8) :
    get (put log k v) k = some v := by
  simp [get, put, List.foldl_append]

/-- Put of a different key leaves lookup of `k` unchanged. -/
public theorem get_put_diff (log : Log) (k k' v : List UInt8) (h : k' ≠ k) :
    get (put log k' v) k = get log k := by
  simp [get, put, List.foldl_append, h]

/-- Two puts of the same key: get returns the second value. -/
public theorem get_put_put_same (log : Log) (k v₁ v₂ : List UInt8) :
    get (put (put log k v₁) k v₂) k = some v₂ := by
  simp [get_put_same]

/-- Session log built by successive puts from empty. -/
@[expose] public def ofPuts (pairs : List (List UInt8 × List UInt8)) : Log :=
  pairs.foldl (fun log p => put log p.1 p.2) []

/-- After `ofPuts`, a trailing put for `k` is what `get` returns. -/
public theorem get_ofPuts_snoc (pairs : List (List UInt8 × List UInt8)) (k v : List UInt8) :
    get (ofPuts (pairs ++ [(k, v)])) k = some v := by
  have h : ofPuts (pairs ++ [(k, v)]) = put (ofPuts pairs) k v := by
    simp only [ofPuts, List.foldl_append, List.foldl_cons, List.foldl_nil]
  rw [h, get_put_same]

end Specs.Log
