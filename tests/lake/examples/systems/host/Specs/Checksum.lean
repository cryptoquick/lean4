module

/-!
# Specs.Checksum — pure host model of the S1 polynomial fold 

Pure `List UInt8 → UInt32` fold `acc = acc * 31 + byte` (host modular arithmetic).

This is the **intended pure model** of freestanding `checksum` / `checksumGo` (Lean
freestanding control-flow over a raw address: `acc * 31 + byte`). There is **no**
machine-checked C semantics / FFI refinement here. The only cross-check with the
freestanding C consumer is the shared harness constant:
`fold [1,2,3,4,5] = 986115` (= Makefile `EXPECTED_CHECKSUM`).

**Freestanding-free:** does not import `Systems.*` or `Specs.Scalars`, so freestanding
API renames do not break this module's typecheck.
-/

namespace Specs.Checksum

/-- One polynomial step: `acc * 31 + byte` (host `UInt32`). -/
@[expose] public def step (acc : UInt32) (byte : UInt32) : UInt32 :=
  acc * 31 + byte

/-- Pure host polynomial checksum (intended model of freestanding / harness fold semantics). -/
@[expose] public def fold (bytes : List UInt8) : UInt32 :=
  bytes.foldl (fun acc b => step acc b.toUInt32) 0

/-- Empty buffer → checksum `0`. -/
public theorem fold_nil : fold [] = 0 := by
  simp [fold]

/-- Left-fold step for a non-empty list. -/
public theorem fold_cons (b : UInt8) (bs : List UInt8) :
    fold (b :: bs) =
      bs.foldl (fun acc x => step acc x.toUInt32) (step 0 b.toUInt32) := by
  simp [fold, List.foldl_cons]

/-- Singleton list: `0 * 31 + b = b` (as `UInt32`). -/
public theorem fold_singleton (b : UInt8) : fold [b] = b.toUInt32 := by
  simp [fold, step]

/-- Append continuation: folding `xs ++ ys` continues from `fold xs`. -/
public theorem fold_append (xs ys : List UInt8) :
    fold (xs ++ ys) =
      ys.foldl (fun acc b => step acc b.toUInt32) (fold xs) := by
  simp only [fold, List.foldl_append]

/-- Harness reference buffer `{1,2,3,4,5}` → `986115` (Makefile `EXPECTED_CHECKSUM`).

Machine-checked equality of the pure host model with the constant the freestanding C
consumer also expects — not a proof that freestanding `checksumGo` C equals `fold`. -/
public theorem fold_harness_12345 : fold [1, 2, 3, 4, 5] = 986115 := by
  native_decide

/-- Extending by a zero byte multiplies the accumulator by 31. -/
public theorem fold_snoc_zero (xs : List UInt8) :
    fold (xs ++ [0]) = fold xs * 31 := by
  rw [fold_append]
  simp [step, List.foldl_cons, List.foldl_nil]

end Specs.Checksum
