import Lake
open System Lake DSL

/-!
# Slake classic-host driver package

Builds the runnable `slake` binary from classic modules under `src/slake/`.

Links freestanding `Systems.Proc` via `slake_fs_proc.c` + product extract bundle
so `SLAKE_USE_FS_PROC=1` multi-arg / `SLAKE_USE_FS_PROC_PIPE=1` pipe/stdio capture
can spawn `lake build` without `IO.Process` (Option C).
Also links `slake_fs_depgraph.c` so `SLAKE_DEPGRAPH=1` / `SLAKE_PLAN_ONLY=1` can
print a package-derived freestanding `DepGraph` Kahn plan (Config identity nodes
+ import-scan DAG when edges exist, else chain topo; demo C→B→A via
`SLAKE_DEPGRAPH_DEMO=1`). PLAN_ONLY skips lake. `SLAKE_NATIVE_CHECK=1` implies
plan print then sequential host-lean typecheck of plan modules (not freestanding
build TCB / not CLAIMED; with PLAN_ONLY still skips lake). `SLAKE_NATIVE_OLEAN=1`
implies plan then multi-module host-lean compile writing oleans into
package-local `.slake-native/` + LEAN_PATH feed (default sequential; not freestanding
build TCB / not lake-equivalent TCB / not CLAIMED; with PLAN_ONLY still skips lake).
A9 adds mtime + plan-edge cascade skip when oleans are fresh (`SLAKE_NATIVE_OLEAN_FORCE=1`
rebuilds all). A10 adds FNV-1a 64 source content-hash sidecars (touch-without-edit
→ skip) and `SLAKE_NATIVE_BUILD=1` freestanding-adjacent native olean build that
skips lake on success. A11 adds plan-node transitive deps-hash (direct plan-import
dep hash-fresh snapshot + frozen `deps <hex>` + skip-heal; cascade multi-hop; not
Lake package-transitive / not CLAIMED). A12 adds optional `SLAKE_NATIVE_OLEAN_JOBS=N`
ready-set parallel host-lean olean waves (default sequential; not Lake job server
TCB / not CLAIMED / not shared-lib link). A13 adds optional `SLAKE_NATIVE_LINK=1`
host shared-lib link subset after oleans (`.slake-native/libslake_native.so` via
host `cc -shared -fPIC`; exports `slake_native_plan_modules`; not Lake lean_lib
shared-object / not freestanding build TCB / not Lake shared-lib TCB / not CLAIMED;
with NATIVE_BUILD, skip-lake requires link success). A14 adds optional
`SLAKE_NATIVE_GRAPH=1` host package link graph subset after oleans
(`.slake-native/slake_native_graph`; plan modules with oleans + A5 import edges +
optional shared_lib; not freestanding build TCB / not Lake build graph TCB / not
Lake lean_lib SO / not CLAIMED; with NATIVE_BUILD, skip-lake requires graph write).
A15 adds optional `SLAKE_NATIVE_SEAL=1` host freestanding-adjacent product seal
subset after oleans (`.slake-native/slake_native_seal`; module olean_hash +
optional graph_hash + optional shared_lib + seal digest; not freestanding build
TCB / not Lake lean_lib SO / not Lake build graph TCB / not CLAIMED; with
NATIVE_BUILD, skip-lake requires seal write; order olean → link → graph → seal).
Default CLI path remains
`IO.Process` → `lake build` (parity stays green without requiring the flags).

```bash
# From repo root (stage1 lean/lake on PATH):
make -C tests/lake/examples/systems -j"$(nproc)" lake
cd tests/slake/driver && lake build
# → .lake/build/bin/slake

SLAKE_BIN="$PWD/tests/slake/driver/.lake/build/bin/slake" \
  ./tests/slake/parity/run_parity.sh
SLAKE_USE_FS_PROC=1 ./tests/slake/fs_proc_smoke.sh
SLAKE_USE_FS_PROC_PIPE=1 ./tests/slake/fs_proc_pipe_smoke.sh
SLAKE_DEPGRAPH=1 ./tests/slake/depgraph_cli_smoke.sh
./tests/slake/plan_only_smoke.sh              # A3: package plan, skip lake
./tests/slake/systems_plan_smoke.sh           # A4: systems_shaped multi-target dogfood
./tests/slake/import_dag_smoke.sh             # A5: import-scan DAG (Core before Host)
./tests/slake/srcdir_plan_smoke.sh            # A6: srcDir + dotted Foo.Bar + path confinement
./tests/slake/native_check_smoke.sh           # A7: PLAN_ONLY+NATIVE_CHECK host-lean typecheck
./tests/slake/native_olean_smoke.sh           # A8: PLAN_ONLY+NATIVE_OLEAN multi-module oleans
./tests/slake/native_olean_cache_smoke.sh     # A9: mtime + plan-edge cascade skip/rebuild
./tests/slake/native_olean_hash_smoke.sh      # A10: FNV-1a 64 source content-hash sidecar
./tests/slake/native_build_smoke.sh           # A10: NATIVE_BUILD skip-lake product path
./tests/slake/native_olean_deps_hash_smoke.sh # A11: plan-node transitive deps-hash
./tests/slake/native_olean_parallel_smoke.sh  # A12: SLAKE_NATIVE_OLEAN_JOBS parallel waves
./tests/slake/native_link_smoke.sh            # A13: SLAKE_NATIVE_LINK host shared-lib link
./tests/slake/native_graph_smoke.sh           # A14: SLAKE_NATIVE_GRAPH host package link graph
./tests/slake/native_seal_smoke.sh            # A15: SLAKE_NATIVE_SEAL product seal subset
# CI opt-in hard-fail when binary/shim missing:
# SLAKE_DEPGRAPH_SMOKE_STRICT=1 ./tests/slake/depgraph_cli_smoke.sh
# SLAKE_PLAN_ONLY_SMOKE_STRICT=1 ./tests/slake/plan_only_smoke.sh
# SLAKE_SYSTEMS_PLAN_SMOKE_STRICT=1 ./tests/slake/systems_plan_smoke.sh
# SLAKE_IMPORT_DAG_SMOKE_STRICT=1 ./tests/slake/import_dag_smoke.sh
# SLAKE_SRCDIR_PLAN_SMOKE_STRICT=1 ./tests/slake/srcdir_plan_smoke.sh
# SLAKE_NATIVE_CHECK_SMOKE_STRICT=1 ./tests/slake/native_check_smoke.sh
# SLAKE_NATIVE_OLEAN_SMOKE_STRICT=1 ./tests/slake/native_olean_smoke.sh
# SLAKE_NATIVE_OLEAN_CACHE_SMOKE_STRICT=1 ./tests/slake/native_olean_cache_smoke.sh
# SLAKE_NATIVE_OLEAN_HASH_SMOKE_STRICT=1 ./tests/slake/native_olean_hash_smoke.sh
# SLAKE_NATIVE_BUILD_SMOKE_STRICT=1 ./tests/slake/native_build_smoke.sh
# SLAKE_NATIVE_OLEAN_DEPS_HASH_SMOKE_STRICT=1 ./tests/slake/native_olean_deps_hash_smoke.sh
# SLAKE_NATIVE_OLEAN_PARALLEL_SMOKE_STRICT=1 ./tests/slake/native_olean_parallel_smoke.sh
# SLAKE_NATIVE_LINK_SMOKE_STRICT=1 ./tests/slake/native_link_smoke.sh
# SLAKE_NATIVE_GRAPH_SMOKE_STRICT=1 ./tests/slake/native_graph_smoke.sh
# SLAKE_NATIVE_SEAL_SMOKE_STRICT=1 ./tests/slake/native_seal_smoke.sh
```

Honest residual: classic host IO + lake delegate for MVP `build`.
Does **not** freestanding-ize `src/lake`. Not full Lake parity.
-/

/-- Relative path from this package dir (`…/tests/slake/driver`) to `src/slake`. -/
def slakeSrc : System.FilePath :=
  "../../.." / "src" / "slake"

package «slake-driver» where
  srcDir := slakeSrc

lean_lib Slake

input_file slake_fs_proc.c where
  path := "slake_fs_proc.c"
  text := true

target slake_fs_proc.o pkg : FilePath := do
  let srcJob ← slake_fs_proc.c.fetch
  let oFile := pkg.buildDir / "c" / "slake_fs_proc.o"
  let weakArgs := #["-I", (← getLeanIncludeDir).toString]
  buildO oFile srcJob weakArgs #["-fPIC"] "cc" getLeanTrace

input_file slake_fs_depgraph.c where
  path := "slake_fs_depgraph.c"
  text := true

target slake_fs_depgraph.o pkg : FilePath := do
  let srcJob ← slake_fs_depgraph.c.fetch
  let oFile := pkg.buildDir / "c" / "slake_fs_depgraph.o"
  let weakArgs := #["-I", (← getLeanIncludeDir).toString]
  buildO oFile srcJob weakArgs #["-fPIC"] "cc" getLeanTrace

/-- Freestanding product extract bundle (must exist; build systems example first). -/
target fs_extract_bundle pkg : FilePath := do
  let p := (pkg.dir / ".." / ".." / "lake" / "examples" / "systems" /
    "lib" / ".lake" / "build" / "lib" / "libfs_extract_bundle.a").normalize
  unless (← p.pathExists) do
    error s!"missing freestanding extract bundle at {p}\n\
build it first: make -C tests/lake/examples/systems lake"
  inputBinFile p

@[default_target]
lean_exe slake where
  root := `SlakeMain
  moreLinkObjs := #[slake_fs_proc.o, slake_fs_depgraph.o, fs_extract_bundle]
