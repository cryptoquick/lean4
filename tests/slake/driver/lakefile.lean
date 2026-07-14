import Lake
open System Lake DSL

/-!
# Slake classic-host driver package

Builds the runnable `slake` binary from classic modules under `src/slake/`.

Links freestanding `Systems.Proc` via `slake_fs_proc.c` + product extract bundle
so `SLAKE_USE_FS_PROC=1` multi-arg / `SLAKE_USE_FS_PROC_PIPE=1` pipe/stdio capture
can spawn `lake build` without `IO.Process` (Option C).
Also links `slake_fs_depgraph.c` so `SLAKE_DEPGRAPH=1` can print a freestanding
`DepGraph` Kahn topo plan before build (demo C→B→A; real package parse residual).
Default CLI path remains `IO.Process` → `lake build` (parity stays green without
requiring the flags).

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
