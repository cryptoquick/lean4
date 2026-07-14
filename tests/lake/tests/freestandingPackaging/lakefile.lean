import Lake
open Lake DSL

/-!
# Systems Lean freestanding packaging Lake unit test

Positive + fail-closed packaging for:
* `freestanding := true` / `LeanLib.freestandingFacet` (ordered multi-archive list)
* `LeanLib.freestandingBundleFacet` (single combined archive for C consumers)
-/

package freestandingPackaging

-- Non-freestanding lean_lib (normal Init module). Used only as a negative needs target.
lean_lib HostLib where
  roots := #[`HostLib]
  defaultFacets := #[LeanLib.leanArtsFacet]

-- Shared freestanding leaf (diamond base).
lean_lib FsD where
  freestanding := true
  defaultFacets := #[LeanLib.freestandingFacet]
  roots := #[`FsD]
  libName := "fs_d"

lean_lib FsB where
  freestanding := true
  defaultFacets := #[LeanLib.freestandingFacet]
  roots := #[`FsB]
  libName := "fs_b"
  needs := #[`@/FsD]

lean_lib FsC where
  freestanding := true
  defaultFacets := #[LeanLib.freestandingFacet]
  roots := #[`FsC]
  libName := "fs_c"
  needs := #[`@/FsD]

@[default_target]
lean_lib FsA where
  freestanding := true
  -- Force true last even if someone sets false in leanOptions (fail-closed policy).
  leanOptions := #[⟨`compiler.freestanding, false⟩]
  defaultFacets := #[LeanLib.freestandingFacet]
  roots := #[`FsA]
  libName := "fs_a"
  needs := #[`@/FsB, `@/FsC]

-- Misconfig: freestanding lib that needs a non-freestanding lean_lib.
lean_lib FsBad where
  freestanding := true
  defaultFacets := #[LeanLib.freestandingFacet]
  roots := #[`FsBad]
  libName := "fs_bad"
  needs := #[`@/HostLib]
