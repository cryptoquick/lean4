# Slake tests

Parity and driver tests for **Slake** (Systems Lean twin of Lake).

Design: [`doc/dev/slake.md`](../../doc/dev/slake.md).

## Parity harness (sketch)

Goal: golden packages build under **both** `lake` and `slake` with matching
exit codes and primary artifacts for the **claimed** API subset.

```
tests/slake/
  README.md                 — this file
  driver/                   — Lake package: builds classic-host `slake` from src/slake/
    lakefile.lean
  proc_dogfood/             — freestanding Systems.Proc dogfood (links extract; /bin/true + pipe)
  depgraph_wire/            — freestanding DepGraph wire dogfood (topo plan demo)
  parity/
    README.md               — how to run parity
    basic_toml/             — minimal lakefile.toml package (path-only deps)
      lakefile.toml
      BasicToml.lean        — trivial lib root
    run_parity.sh           — lake vs slake for claimed commands
```

### Claimed subset (Phase 2 MVP target)

| Command | Expectation |
|---------|-------------|
| `build` | Both succeed; produce olean/C (or freestanding residual artifacts for Slake paths) |
| `clean` | Both succeed; remove build outputs under documented dirs |
| `env` | Both can print/export a usable env (Slake may be subset; host TOML identity) |
| `test` | Both exit 0 via lake-test package driver (partial semantics; not freestanding TCB) |

Build the driver first:

```bash
export PATH="$PWD/build/release/stage1/bin:${PATH:-}"
cd tests/slake/driver && lake build
SLAKE_BIN="$PWD/.lake/build/bin/slake" ../parity/run_parity.sh
```

`run_parity.sh` behavior:

1. Run `lake <cmd>` and record status/artifacts.
2. If `slake` is missing, exit **SKIP** (not FAIL) with a clear message.
3. When `slake` is present and non-stub, require exit 0 **and** `.lake/build` after `build` (before final clean); clean must remove `.lake/build` and package-local `.slake-native` (A17 native product out dir wipe subset).

### Honesty

- Do **not** claim full Lake parity from a partial harness.
- Freestanding Slake may write residual-free product artifacts under different paths;
  document allowed deltas in `parity/README.md` as claims grow.
- Product residual gates remain under `tests/lake/examples/systems/` + SCORE.

## Freestanding Proc dogfood

Default `slake build` still uses `IO.Process` → `lake`. With `SLAKE_USE_FS_PROC=1`,
the classic driver uses freestanding multi-arg `Systems.Proc` (Option C shim linked
with the product extract). W86: FS_PROC/PIPE plumb remaining argv after `build` via a
fixed stack argv table (max **64** rest tokens; no shell; overflow fail-closed as spawn
fail). Spawn-path dual residual also covers `test`/`exe`/`lint`/`script`/`clean`/`update`/
`pack`/`cache`/`unpack`/`query`/`shake`/`serve`/`upload`/`lean` (W87–W100; `lean` is W100
chdir(pkg)+resolveLakeAbs pre-chdir; rest plumbed except `clean` empty-rest-only). CLAIMED
is `(build clean env test)` (`test` = lake-test exit 0; partial semantics); classic path
still inherits host env while FS_PROC child env is empty. Standalone dogfood also remains:

```bash
make -C tests/lake/examples/systems -j"$(nproc)" lake   # product extract if needed
cd tests/slake/driver && lake build
make -C tests/slake/proc_dogfood check
SLAKE_USE_FS_PROC=1 ./tests/slake/fs_proc_smoke.sh
# or: make -C tests/lake/examples/systems check-slake-proc-dogfood
```

## Freestanding DepGraph CLI plan (A3–A35) + PLAN_ONLY + import-scan + srcDir + per-lib roots + globs + multi-line arrays + path [[require]] + sibling confining ../path + path-dep cascade + path-dep deps-hash fold + NATIVE_CHECK + NATIVE_OLEAN + cache + NATIVE_BUILD + JOBS + NATIVE_C + NATIVE_OBJ + NATIVE_IRLINK + NATIVE_AR + NATIVE_EXE + NATIVE_LINK + NATIVE_GRAPH + NATIVE_SEAL + clean product out dir (A17+A33 path-require) + A34 object inventory + A35 C source inventory

With `SLAKE_DEPGRAPH=1` and/or `SLAKE_PLAN_ONLY=1` and/or `SLAKE_NATIVE_CHECK=1`
and/or `SLAKE_NATIVE_OLEAN=1` and/or `SLAKE_NATIVE_BUILD=1` and/or
`SLAKE_NATIVE_C=1` and/or `SLAKE_NATIVE_OBJ=1` and/or
`SLAKE_NATIVE_IRLINK=1` and/or `SLAKE_NATIVE_AR=1` and/or `SLAKE_NATIVE_EXE=1` and/or
`SLAKE_NATIVE_LINK=1` and/or `SLAKE_NATIVE_GRAPH=1` and/or `SLAKE_NATIVE_SEAL=1`,
classic `slake build` prints a **package-derived**
freestanding `DepGraph` Kahn plan (host Config nodes = package `name` +
`defaultTargets` / per-lib `roots` / per-lib `globs` expand / lean_lib names). Module `.lean` paths resolve via optional
package- or per-lib `srcDir` + dotted `Foo/Bar.lean` (flat package-root fallback; A16).
**A18:** package `defaultTargets` and per-lib `roots` / `globs` accept multi-line double-quoted
string arrays (same fail-closed quote-scan; not full TOML).
**A24/A25:** per-lib `globs` ones + `.+` / `.*` **recursive multi-level** confining
walk under srcDir, depth-bounded (not full Lake Glob / freestanding build TCB /
CLAIMED; roots still win when set). Multi-level e.g. `Core.Nested.Deep` from
`lib/Core/Nested/Deep.lean`. When those files have top-level imports among plan
nodes, topo uses the **import-scan DAG subset**; otherwise declaration-order
`chain_topo`.
`SLAKE_PLAN_ONLY=1` **skips lake** after the plan (exit 0). Optional
`SLAKE_DEPGRAPH_DEMO=1` also prints legacy demo `C B A`. `SLAKE_NATIVE_CHECK=1`
(implies plan print) runs a **thin sequential host-lean typecheck** of plan module
nodes after the plan (`lean <file>` via classic `IO.Process`; skip package name;
LEAN_PATH includes package root + optional srcDir; `SLAKE_NATIVE_CHECK_STRICT=1`
fail-closed on missing lean/file). `SLAKE_NATIVE_OLEAN=1` (implies plan print) runs
a **multi-module host-lean compile** writing oleans into package-local
`.slake-native/` and feeding that dir on LEAN_PATH so later modules can import
earlier ones (`lean -o …`; `SLAKE_NATIVE_OLEAN_STRICT=1` fail-closed). **A9:**
skip recompile when olean mtime is fresh unless a plan-node import dependency was
recompiled or soft-skipped this run (cascade), a plan-import dep olean is newer
than this module's olean (cross-run / interrupted-run subset), or
`SLAKE_NATIVE_OLEAN_FORCE=1`. **A10:** after successful `-o`, write FNV-1a 64
**source content-hash** sidecar (`.olean.slakehash`); touch-without-edit →
`skip (hash-fresh)` even if mtime is newer; content edit → rebuild + cascade.
**A11:** plan-node **transitive deps-hash** (direct plan-import edges + cascade
multi-hop) — before mtime/hash skip, every direct plan-import dep must be
hash-fresh at run-start snapshot (olean+sidecar+source); sidecar may carry frozen
`deps <hex>` (sorted direct plan-import dep names + source hashes); live
dep-hash-stale or deps-line mismatch forces dependent rebuild; mtime/hash skip
heals self+deps sidecar (plan-import edges — not Lake package-transitive).
**A28:** path-dep import source hashes also fold into the same A11 `deps <hex>`
(consumer imports of path-dep plan modules after A26 inventory; deps-line-stale
when path-dep source changes even if path-dep olean is not newer — not Lake
package-transitive hash / not CLAIMED).
**A29:** sibling confining `path = "../dep"` (exactly one leading `..` + ≥1 safe
components; resolve under package-parent confining root; refuse multi-`..` escape /
bare `..` / mid-path `..` / absolute; real-dir lstat fence) — monorepo sibling only;
not full Lake path require / not workspace multi-level walk-up / not CLAIMED.
Fixture `require_sibling_shaped`; smoke `require_sibling_smoke.sh` (STRICT via
`SLAKE_REQUIRE_SIBLING_SMOKE_STRICT=1`).
**A30:** package-transitive plan subset — when a root plan module imports a
path-dep plan module name, fold it into the root plan (import-driven; Dep before
App via Kahn; path-dep olean still under path-require package; root wave skips
path-dep plan nodes). Not Lake resolve-deps / not every dep plan module / not
CLAIMED. Smoke `require_transitive_plan_smoke.sh` (STRICT via
`SLAKE_REQUIRE_TRANSITIVE_PLAN_SMOKE_STRICT=1`).
**A12:** `SLAKE_NATIVE_OLEAN_JOBS=N` opt-in **parallel ready-set** host-lean olean
waves — default/unset/`1`/invalid → sequential; `N≥2` → up to N concurrent
`lean -o` among modules whose direct plan-import deps finished this run (Host
never before Core when Host imports Core); empty import-scan edges ⇒ plan-order
batches of N only (prefer import-scan edges for multi-module JOBS≥2); logs
`native olean: jobs=N`; not Lake job server TCB / not freestanding build TCB /
not CLAIMED / not shared-lib link.
Fixture `parallel_shaped` (A+B independent, Top imports both). Smoke:
`native_olean_parallel_smoke.sh` (STRICT via `SLAKE_NATIVE_OLEAN_PARALLEL_SMOKE_STRICT=1`).
**`SLAKE_NATIVE_BUILD=1`:**
implies plan + NATIVE_OLEAN; on successful olean compile **skip lake** (exit 0);
on compile failure exit nonzero (fail-closed, no lake fallback); JOBS applies —
freestanding-adjacent native olean build subset. Soft-skip messages note
dependents cascade; prefer STRICT fail-closed in CI. Combined with PLAN_ONLY
still skips lake; without PLAN_ONLY (and without NATIVE_BUILD) lake follows after
the step. **A19 `SLAKE_NATIVE_C=1`:** implies plan + NATIVE_OLEAN; after oleans,
host **lean C-output emit subset** — for each plan module (skip package name)
`lean -c .slake-native/<ModRel>.c <file>` with same LEAN_PATH as olean
(`.slake-native` first, then pkg [+srcDir]); nested modules → `Foo/Bar.c`; not
freestanding build TCB / not Lake lean_lib shared-object of compiled Lean IR /
not full object compile+link of Lean runtime / not CLAIMED. Missing lean / missing
source soft-skips unless `SLAKE_NATIVE_C_STRICT=1` or combined with NATIVE_BUILD
(then skip-lake requires C emit success). Nonzero lean always fail-closed. JOBS
applies to olean only; C emit is sequential. Smoke: `native_c_smoke.sh` (STRICT
via `SLAKE_NATIVE_C_SMOKE_STRICT=1`).
**A20 `SLAKE_NATIVE_OBJ=1`:** implies plan + NATIVE_OLEAN + NATIVE_C; after C emit,
host **object compile of lean C subset** — for each plan module (skip package
name) `cc -c -fPIC -I<leanInclude> -o .slake-native/<ModRel>.o
.slake-native/<ModRel>.c`; nested modules → `Foo/Bar.o`; include via
`LEAN_INCLUDE` / `LEAN_SYSROOT`/`LEAN_PREFIX`+`/include` / `lean --print-prefix`;
not freestanding build TCB / not Lake lean_lib SO / not linking Lean runtime into
SO / not CLAIMED. Missing cc / include / C soft-skips unless
`SLAKE_NATIVE_OBJ_STRICT=1` or combined with NATIVE_BUILD (then skip-lake requires
object compile success). Nonzero cc always fail-closed. JOBS applies to olean only;
object compile is sequential. Smoke: `native_obj_smoke.sh` (STRICT via
`SLAKE_NATIVE_OBJ_SMOKE_STRICT=1`).
**A21 `SLAKE_NATIVE_IRLINK=1`:** implies plan + NATIVE_OLEAN + NATIVE_C +
NATIVE_OBJ; after object compile (before AR/EXE/A13 NATIVE_LINK when set), host **leanc
IR shared-lib link subset** of plan-module objects + Lean runtime via leanc —
collect non-empty regular `.slake-native/<ModRel>.o` and
`leanc -shared -o .slake-native/libslake_ir.so <objs…>` (`LEANC` env or `leanc`
on PATH; optional same-dir as `LEAN`); not freestanding build TCB / not Lake
lean_lib shared-object TCB / not CLAIMED / not full Lake shared facet. A13
`NATIVE_LINK` remains a separate name-table SO (`libslake_native.so`); both can
coexist. Missing leanc / missing `.o` soft-skips unless
`SLAKE_NATIVE_IRLINK_STRICT=1` or combined with NATIVE_BUILD (then skip-lake
requires IR link success). Nonzero leanc always fail-closed. Smoke:
`native_irlink_smoke.sh` (STRICT via `SLAKE_NATIVE_IRLINK_SMOKE_STRICT=1`).
**A22 `SLAKE_NATIVE_AR=1`:** implies plan + NATIVE_OLEAN + NATIVE_C + NATIVE_OBJ
(does **not** imply NATIVE_IRLINK); after object compile (and after IRLINK when both
set; before EXE/A13 NATIVE_LINK when set), host **static archive of plan-module objects
subset** via `ar rcs` — collect non-empty regular `.slake-native/<ModRel>.o` and
`ar rcs .slake-native/libslake_ir.a <objs…>` (`AR` env or `ar` on PATH); not
freestanding build TCB / not Lake lean_lib static/shared facet / not CLAIMED / not
linking Lean runtime into the archive (plain ar of module `.o` only; A21 leanc still
pulls runtime into SO). Coexists with `libslake_ir.so` and `libslake_native.so`.
Missing ar / missing `.o` soft-skips unless `SLAKE_NATIVE_AR_STRICT=1` or combined
with NATIVE_BUILD (then skip-lake requires archive success). Nonzero ar always
fail-closed. Smoke: `native_ar_smoke.sh` (STRICT via `SLAKE_NATIVE_AR_SMOKE_STRICT=1`).

**A31:** freestanding-adjacent path-dep plan-module C/OBJ into IR products — A30-folded path-dep modules emit `lean -c` / `cc -c` under `dep/.slake-native/` and those `.o` feed NATIVE_IRLINK / AR / EXE (topo order). Not Lake lean_lib shared facet / not freestanding build TCB / not CLAIMED. Smoke: `native_pathdep_ir_smoke.sh`.

**A32:** freestanding-adjacent path-dep plan-module nodes in NATIVE_GRAPH + NATIVE_SEAL — A30-folded path-dep modules appear in `.slake-native/slake_native_graph` with **package-cwd-relative** olean paths (`dep/.slake-native/Dep.olean`; A29 sibling `../dep/.slake-native/Dep.olean`) and in `.slake-native/slake_native_seal` with path-dep `olean_hash` (sidecar or source FNV). Soft path may omit missing path-dep olean lines with warn; STRICT/NATIVE_BUILD fail-closed on empty graph/seal like root modules. Not freestanding build TCB / not Lake build graph TCB / not Lake resolve-deps / not CLAIMED / not every dep plan module / not git/url / not multi-`..`. Smoke: `native_pathdep_graph_seal_smoke.sh` (STRICT via `SLAKE_NATIVE_PATHDEP_GRAPH_SEAL_SMOKE_STRICT=1`; under-pkg + sibling + nested bands).

**A33:** freestanding-adjacent path-require package `.slake-native` wipe on CLAIMED `slake clean` — after root `.lake/build` + root `.slake-native` (A17), also wipe each path-require package’s `.slake-native/` (A26 under-pkg / A29 sibling confining; identity order; soft missing OK; symlink fence; not git/url / not Lake resolve-deps / not multi-`..` / not dep `.lake/build` / not CLAIMED token expansion). FS_PROC/PIPE applies the same wipe set after `lake clean`. Smoke: `native_pathdep_clean_smoke.sh` (STRICT via `SLAKE_NATIVE_PATHDEP_CLEAN_SMOKE_STRICT=1`).

**A34:** freestanding-adjacent plan-module object inventory in NATIVE_GRAPH + NATIVE_SEAL — when plan-module `.o` files exist (root under `.slake-native/<ModRel>.o` or A30-folded path-dep under package-cwd-relative `dep/.slake-native/…` / A29 sibling `../dep/.slake-native/…`), **NATIVE_GRAPH** lists distinct `object <Mod> <relpath>` lines and **NATIVE_SEAL** lists `module <Mod> obj_hash <16-hex>` (FNV-1a 64 of object file bytes). Soft-omit missing `.o`; banners/headers only when ≥1 object/obj_hash line actually written. Olean-only GRAPH+SEAL (no NATIVE_OBJ) stays green with no A34 claims. Not freestanding build TCB / not Lake lean_lib facet / not CLAIMED / not every dep plan module / not name-table SO (A13). Smoke: `native_obj_graph_seal_smoke.sh` (STRICT via `SLAKE_NATIVE_OBJ_GRAPH_SEAL_SMOKE_STRICT=1`; systems_shaped + path-dep + sibling + olean-only negative).

**A35:** freestanding-adjacent plan-module C source inventory in NATIVE_GRAPH + NATIVE_SEAL — when plan-module `.c` files exist (root under `.slake-native/<ModRel>.c` or A30-folded path-dep under package-cwd-relative `dep/.slake-native/…` / A29 sibling `../dep/.slake-native/…`), **NATIVE_GRAPH** lists distinct `c_source <Mod> <relpath>` lines and **NATIVE_SEAL** lists `module <Mod> c_hash <16-hex>` (FNV-1a 64 of C file bytes). Soft-omit missing `.c`; banners/headers only when ≥1 c_source/c_hash line actually written. Seal digest folds sorted `c_hash` after `olean_hash` and before `obj_hash`. Olean-only GRAPH+SEAL (no NATIVE_C) stays green with no A35 claims. Not freestanding build TCB / not Lake lean_lib facet / not CLAIMED / not every dep plan module / not changing C emit semantics. Smoke: `native_c_graph_seal_smoke.sh` (STRICT via `SLAKE_NATIVE_C_GRAPH_SEAL_SMOKE_STRICT=1`; systems_shaped + path-dep + sibling + nested + olean-only negative).

**A23 `SLAKE_NATIVE_EXE=1`:** implies plan + NATIVE_OLEAN + NATIVE_C + NATIVE_OBJ
(does **not** imply IRLINK or AR). After object compile (after IRLINK/AR when set;
before A13 LINK): write generated stub main `.slake-native/slake_native_main.c` and
host `leanc -o .slake-native/slake_ir …` (LEANC env or leanc on PATH). **Not** freestanding
build TCB / **not** Lake lean_exe / **not** CLAIMED / **not** a real app entry.
Missing leanc soft-skips unless `SLAKE_NATIVE_EXE_STRICT=1` or combined with
`SLAKE_NATIVE_BUILD=1`. Nonzero leanc always fail-closed. Smoke: `native_exe_smoke.sh`
(STRICT via `SLAKE_NATIVE_EXE_SMOKE_STRICT=1`).
**A13 `SLAKE_NATIVE_LINK=1`:** implies plan + NATIVE_OLEAN; after oleans (and after
NATIVE_C / NATIVE_OBJ / NATIVE_IRLINK / NATIVE_AR / NATIVE_EXE when set), host **shared-lib link subset** — write
`.slake-native/slake_native_export.c` exporting `slake_native_plan_modules` (topo
plan module names) and `cc -shared -fPIC -o .slake-native/libslake_native.so`
(`CC` env or `cc` on PATH); not Lake lean_lib shared-object of compiled Lean IR /
not freestanding build TCB / not Lake shared-lib TCB / not IR link of NATIVE_OBJ
`.o` (that is NATIVE_IRLINK) / not static archive (that is NATIVE_AR) / not
executable link (that is NATIVE_EXE) / not CLAIMED. Missing `cc` soft-skips unless
`SLAKE_NATIVE_LINK_STRICT=1` or combined with NATIVE_BUILD (then skip-lake requires
link success). JOBS applies to olean only; link is sequential single host cc. Smoke:
`native_link_smoke.sh` (STRICT via `SLAKE_NATIVE_LINK_SMOKE_STRICT=1`).
**A14 `SLAKE_NATIVE_GRAPH=1`:** implies plan + NATIVE_OLEAN; after oleans (and after
NATIVE_C / NATIVE_OBJ / NATIVE_IRLINK / NATIVE_AR / NATIVE_EXE / NATIVE_LINK when set), write `.slake-native/slake_native_graph` — host
**package link graph subset** (package line, module olean lines, A5 edge lines,
optional shared_lib / optional shared_lib_ir / optional static_lib / optional executable when present, summary counts); **A32** A30-folded path-dep modules use package-cwd-relative olean paths (under-pkg or A29 sibling `../dep/…`); **A35** when plan-module `.c` exists, distinct `c_source <Mod> <package-cwd-relative path>` lines (soft-omit missing); **A34** when plan-module `.o` exists, distinct `object <Mod> <package-cwd-relative path>` lines (soft-omit missing); not freestanding build TCB / not Lake build
graph TCB / not Lake lean_lib SO / not CLAIMED. Graph write IO always fail-closed;
empty modules soft-skip unless `SLAKE_NATIVE_GRAPH_STRICT=1` or NATIVE_BUILD. With
NATIVE_BUILD, skip-lake requires graph write success. Order: olean → C emit (if
set) → obj (if set) → IR link (if set) → static archive (if set) → executable link (if set) → link (if set) → graph.
Smoke: `native_graph_smoke.sh` (STRICT via `SLAKE_NATIVE_GRAPH_SMOKE_STRICT=1`); path-dep band `native_pathdep_graph_seal_smoke.sh`; C source inventory `native_c_graph_seal_smoke.sh`; object inventory `native_obj_graph_seal_smoke.sh`.
**A15 `SLAKE_NATIVE_SEAL=1`:** implies plan + NATIVE_OLEAN; after oleans (and after
NATIVE_C / NATIVE_OBJ / NATIVE_IRLINK / NATIVE_AR / NATIVE_EXE / NATIVE_LINK / NATIVE_GRAPH when set), write
`.slake-native/slake_native_seal` — host **freestanding-adjacent product seal
subset** (package line, module olean_hash lines from sidecar or source FNV-1a 64,
optional graph_hash of graph file bytes, optional shared_lib / optional shared_lib_ir / optional static_lib / optional executable,
seal digest, summary counts); **A32** A30-folded path-dep olean_hash from path-dep sidecar/source; **A35** optional `module <Mod> c_hash` (FNV-1a 64 of `.c` bytes when present; soft-omit missing; do not fail seal solely for zero C sources; folded into seal digest after olean_hash before obj_hash); **A34** optional `module <Mod> obj_hash` (FNV-1a 64 of `.o` bytes when present; soft-omit missing; do not fail seal solely for zero objects); not freestanding build TCB / not Lake lean_lib SO / not Lake build graph
TCB / not CLAIMED. Seal write IO always fail-closed; empty modules / cannot hash
soft-skip unless `SLAKE_NATIVE_SEAL_STRICT=1` or NATIVE_BUILD. With NATIVE_BUILD,
skip-lake requires seal write success. Order: olean → C emit → obj → IR link → static archive → executable link → name-table link → graph → seal.
Smoke: `native_seal_smoke.sh` (STRICT via `SLAKE_NATIVE_SEAL_SMOKE_STRICT=1`); path-dep band `native_pathdep_graph_seal_smoke.sh`; C source inventory `native_c_graph_seal_smoke.sh`; object inventory `native_obj_graph_seal_smoke.sh`.
**A17 CLAIMED `clean`:** native wipe of package-local `.slake-native/` **and**
`.lake/build` (symlink fence on both; empty rest only). FS_PROC/PIPE still
delegates to `lake clean` then native-wipes `.slake-native` so freestanding-
adjacent products do not leak. Honesty: **native product out dir wipe subset** —
not full Lake clean set / not freestanding build TCB beyond hygiene / not a new
CLAIMED token. Smoke: `native_clean_smoke.sh` (STRICT via
`SLAKE_NATIVE_CLEAN_SMOKE_STRICT=1`). **A33** extends the wipe set to path-require
package `.slake-native/` (see A33 above; smoke `native_pathdep_clean_smoke.sh`).
CLAIMED `build` without these flags stays lake-delegated. Plan ≠ freestanding
build TCB; NATIVE_CHECK ≠ freestanding compile / not olean orchestration / not
CLAIMED; NATIVE_OLEAN ≠ freestanding build TCB / not lake-equivalent TCB / not
CLAIMED / not full olean graph invalidation / not Lake shake/hash TCB / not Lake
package-transitive hash / not Lake job server TCB; NATIVE_BUILD ≠ freestanding
build TCB / not Lake TCB / not CLAIMED; NATIVE_LINK ≠ freestanding build TCB /
not Lake shared-lib TCB / not CLAIMED; NATIVE_C ≠ freestanding build TCB / not Lake
lean_lib SO / not object compile+link of Lean runtime / not CLAIMED; NATIVE_OBJ ≠
freestanding build TCB / not Lake lean_lib SO / not linking Lean runtime into SO /
not CLAIMED; NATIVE_IRLINK ≠ freestanding build TCB / not Lake lean_lib shared-object
TCB / not CLAIMED / not full Lake shared facet (A13 remains name-table SO);
NATIVE_AR ≠ freestanding build TCB / not Lake lean_lib static/shared facet / not CLAIMED;
NATIVE_EXE ≠ freestanding build TCB / not Lake lean_exe / not
CLAIMED / not linking Lean runtime into the archive (plain ar of module .o only);
NATIVE_GRAPH ≠
freestanding build TCB / not Lake build graph TCB / not CLAIMED; NATIVE_SEAL ≠
freestanding build TCB / per-lib roots ≠ full Lake faceting / per-lib globs ≠ full
Lake Glob / not Lake lean_lib SO / not Lake build graph TCB / not CLAIMED; A17 clean ≠
full Lake clean / not freestanding build TCB; nested/srcDir resolution subset — not
full Lake import resolution / faceting. Default path (flags unset) stays parity-green.

```bash
SLAKE_BIN="$PWD/tests/slake/driver/.lake/build/bin/slake" \
  ./tests/slake/depgraph_cli_smoke.sh
./tests/slake/plan_only_smoke.sh
./tests/slake/systems_plan_smoke.sh   # A4 multi-target systems_shaped dogfood
./tests/slake/import_dag_smoke.sh     # A5 Host imports Core; Core before Host
./tests/slake/srcdir_plan_smoke.sh    # A6 srcDir=src; Foo.Bar before Host; meta import; path confinement
./tests/slake/roots_plan_smoke.sh      # A16 per-lib roots + srcDir; plan Alpha Beta; path confinement
./tests/slake/multiline_roots_plan_smoke.sh  # A18 multi-line roots/defaultTargets; plan Alpha Beta; negatives
./tests/slake/globs_plan_smoke.sh      # A24/A25 per-lib globs Core.* → Core Core.Extra Core.Nested.Deep; path-escape; roots win
./tests/slake/require_path_smoke.sh    # A26 path [[require]] LEAN_PATH + path-dep olean precompile; absolute/multi-.. negatives (not CLAIMED)
./tests/slake/require_path_cascade_smoke.sh  # A27 path-dep → root olean cascade (path-dep-olean-newer; not CLAIMED)
./tests/slake/require_path_deps_hash_smoke.sh  # A28 path-dep source-hash fold into A11 deps-line (not CLAIMED)
./tests/slake/require_sibling_smoke.sh  # A29 sibling confining ../path under package-parent (not CLAIMED / not multi-.. escape)
./tests/slake/require_transitive_plan_smoke.sh  # A30 package-transitive plan subset (import-driven Dep before App; not CLAIMED)
./tests/slake/native_pathdep_ir_smoke.sh  # A31 path-dep plan-module C/OBJ into IR products (Dep.o under dep/; not CLAIMED)
./tests/slake/native_pathdep_graph_seal_smoke.sh  # A32 path-dep plan-module nodes in NATIVE_GRAPH + NATIVE_SEAL (not CLAIMED)
./tests/slake/native_pathdep_clean_smoke.sh  # A33 path-require package .slake-native wipe on clean (CLAIMED clean growth; not CLAIMED expansion)
./tests/slake/native_obj_graph_seal_smoke.sh  # A34 plan-module object inventory in NATIVE_GRAPH + NATIVE_SEAL (not CLAIMED)
./tests/slake/native_c_graph_seal_smoke.sh  # A35 plan-module C source inventory in NATIVE_GRAPH + NATIVE_SEAL (not CLAIMED)
./tests/slake/native_check_smoke.sh   # A7 PLAN_ONLY+NATIVE_CHECK sequential host-lean typecheck (not CLAIMED)
./tests/slake/native_olean_smoke.sh   # A8 PLAN_ONLY+NATIVE_OLEAN multi-module sequential oleans (not CLAIMED)
./tests/slake/native_olean_cache_smoke.sh  # A9 mtime + plan-edge + dep-olean-newer cascade (not CLAIMED)
./tests/slake/native_olean_hash_smoke.sh   # A10 FNV-1a 64 source content-hash sidecar (not CLAIMED)
./tests/slake/native_build_smoke.sh        # A10 NATIVE_BUILD skip-lake product path (not CLAIMED)
./tests/slake/native_olean_deps_hash_smoke.sh  # A11 plan-node transitive deps-hash (not CLAIMED)
./tests/slake/native_olean_parallel_smoke.sh   # A12 JOBS ready-set parallel host-lean olean waves (not CLAIMED)
./tests/slake/native_link_smoke.sh             # A13 NATIVE_LINK host shared-lib link subset (not CLAIMED)
./tests/slake/native_graph_smoke.sh            # A14 NATIVE_GRAPH host package link graph subset (not CLAIMED)
./tests/slake/native_seal_smoke.sh             # A15 NATIVE_SEAL product seal subset (not CLAIMED)
./tests/slake/native_c_smoke.sh                # A19 NATIVE_C host lean C-output emit subset (not CLAIMED)
./tests/slake/native_obj_smoke.sh              # A20 NATIVE_OBJ host object compile of lean C subset (not CLAIMED)
./tests/slake/native_irlink_smoke.sh           # A21 NATIVE_IRLINK host leanc IR shared-lib link (not CLAIMED)
./tests/slake/native_ar_smoke.sh               # A22 NATIVE_AR host static archive of plan-module objects (not CLAIMED)
./tests/slake/native_exe_smoke.sh              # A23 NATIVE_EXE host leanc executable link + stub main (not CLAIMED)
./tests/slake/roots_plan_smoke.sh              # A16 per-lib roots/srcDir plan (not CLAIMED / not full Lake faceting)
./tests/slake/multiline_roots_plan_smoke.sh    # A18 multi-line roots/defaultTargets (not CLAIMED / not full TOML)
./tests/slake/globs_plan_smoke.sh              # A24/A25 per-lib globs recursive multi-level plan expand (not CLAIMED / not full Lake Glob)
./tests/slake/require_path_smoke.sh            # A26 path [[require]] LEAN_PATH + path-dep olean precompile (not CLAIMED / not Lake resolve-deps)
./tests/slake/require_path_cascade_smoke.sh    # A27 path-dep → root olean cascade path-dep-olean-newer (not CLAIMED)
./tests/slake/require_path_deps_hash_smoke.sh  # A28 path-dep source-hash fold into A11 deps-line (not CLAIMED / not Lake package-transitive)
./tests/slake/require_sibling_smoke.sh         # A29 sibling confining ../path (package-parent; not multi-.. / not CLAIMED)
./tests/slake/require_transitive_plan_smoke.sh # A30 package-transitive plan subset (import-driven; not CLAIMED)
./tests/slake/native_clean_smoke.sh            # A17 clean wipes .slake-native + .lake/build (CLAIMED clean growth; not full Lake clean)
./tests/slake/native_pathdep_clean_smoke.sh    # A33 path-require package .slake-native wipe on clean (CLAIMED clean growth; not git/url / not multi-..)
```

**SCORE honesty:** `systems-validate` / SCORE does **not** run `run_parity.sh` or
any of the plan smokes (`depgraph_cli_smoke.sh`, `plan_only_smoke.sh`,
`systems_plan_smoke.sh`, `import_dag_smoke.sh`, `srcdir_plan_smoke.sh`,
`native_check_smoke.sh`, `native_olean_smoke.sh`, `native_olean_cache_smoke.sh`,
`native_olean_hash_smoke.sh`, `native_build_smoke.sh`,
`native_olean_deps_hash_smoke.sh`, `native_olean_parallel_smoke.sh`,
`native_link_smoke.sh`, `native_graph_smoke.sh`, `native_seal_smoke.sh`,
`native_c_smoke.sh`, `native_obj_smoke.sh`, `native_irlink_smoke.sh`,
`native_ar_smoke.sh`, `native_exe_smoke.sh`,
`roots_plan_smoke.sh`, `multiline_roots_plan_smoke.sh`, `globs_plan_smoke.sh`,
`require_path_smoke.sh`,
`require_path_cascade_smoke.sh`,
`require_path_deps_hash_smoke.sh`,
`require_sibling_smoke.sh`,
`require_transitive_plan_smoke.sh`,
`native_pathdep_ir_smoke.sh`,
`native_pathdep_graph_seal_smoke.sh`,
`native_pathdep_clean_smoke.sh`,
`native_obj_graph_seal_smoke.sh`,
`native_c_graph_seal_smoke.sh`,
`native_clean_smoke.sh`).
Soft SKIP when the driver is unlinked is intentional (parity-preserving). CI
opt-in hard-fail: `SLAKE_DEPGRAPH_SMOKE_STRICT=1`, `SLAKE_PLAN_ONLY_SMOKE_STRICT=1`,
`SLAKE_SYSTEMS_PLAN_SMOKE_STRICT=1`, `SLAKE_IMPORT_DAG_SMOKE_STRICT=1`,
`SLAKE_SRCDIR_PLAN_SMOKE_STRICT=1`, `SLAKE_NATIVE_CHECK_SMOKE_STRICT=1`,
`SLAKE_NATIVE_OLEAN_SMOKE_STRICT=1`, `SLAKE_NATIVE_OLEAN_CACHE_SMOKE_STRICT=1`,
`SLAKE_NATIVE_OLEAN_HASH_SMOKE_STRICT=1`, `SLAKE_NATIVE_BUILD_SMOKE_STRICT=1`,
`SLAKE_NATIVE_OLEAN_DEPS_HASH_SMOKE_STRICT=1`,
`SLAKE_NATIVE_OLEAN_PARALLEL_SMOKE_STRICT=1`,
`SLAKE_NATIVE_LINK_SMOKE_STRICT=1`,
`SLAKE_NATIVE_GRAPH_SMOKE_STRICT=1`,
`SLAKE_NATIVE_SEAL_SMOKE_STRICT=1`,
`SLAKE_NATIVE_PATHDEP_GRAPH_SEAL_SMOKE_STRICT=1`,
`SLAKE_NATIVE_OBJ_GRAPH_SEAL_SMOKE_STRICT=1`,
`SLAKE_NATIVE_C_SMOKE_STRICT=1`,
`SLAKE_NATIVE_OBJ_SMOKE_STRICT=1`,
`SLAKE_NATIVE_IRLINK_SMOKE_STRICT=1`,
`SLAKE_NATIVE_AR_SMOKE_STRICT=1`, `SLAKE_NATIVE_EXE_SMOKE_STRICT=1`,
`SLAKE_ROOTS_PLAN_SMOKE_STRICT=1`,
`SLAKE_MULTILINE_ROOTS_PLAN_SMOKE_STRICT=1`,
`SLAKE_GLOBS_PLAN_SMOKE_STRICT=1`,
`SLAKE_REQUIRE_PATH_SMOKE_STRICT=1`,
`SLAKE_REQUIRE_PATH_CASCADE_SMOKE_STRICT=1`,
`SLAKE_REQUIRE_PATH_DEPS_HASH_SMOKE_STRICT=1`,
`SLAKE_NATIVE_CLEAN_SMOKE_STRICT=1`.

```bash
make -C tests/lake/examples/systems -j"$(nproc)" lake
cd tests/slake/driver && lake build
SLAKE_DEPGRAPH=1 ./tests/slake/depgraph_cli_smoke.sh
# standalone wire dogfood still:
make -C tests/slake/depgraph_wire check
```

## Freestanding Proc pipe/stdio CLI

With `SLAKE_USE_FS_PROC_PIPE=1`, classic `slake build` uses freestanding
`Systems.Proc` pipe/stdio (Option C `slake_fs_proc.c` + extract) to spawn lake with
stdout captured into a parent-owned pipe (demo only — not full Lake IO redirect;
stderr still inherits; child env empty). Default path (flag unset) stays
parity-green (`IO.Process`).

`SLAKE_FS_PROC_STRICT=1` applies to both multi-arg and pipe FS paths (no
`IO.Process` fall-back on unlinked/spawn fail / bad absolute `LAKE`). Soft SKIP when
the driver is unlinked is intentional; use `SLAKE_FS_PROC_PIPE_SMOKE_STRICT=1` for
hard fail when a linked pipe path is expected.

```bash
make -C tests/lake/examples/systems -j"$(nproc)" lake
cd tests/slake/driver && lake build
SLAKE_USE_FS_PROC_PIPE=1 ./tests/slake/fs_proc_pipe_smoke.sh
# product STRICT negative is inside the smoke (bad LAKE + SLAKE_FS_PROC_STRICT=1)
```

## Product cores

Freestanding Slake cores (`DepGraph`, `TomlConfig`, `Proc`, …) are residual-tested
via the Systems example matrix, not only this directory. See
`script/systems-product-stdlib-modules.txt` and `RESIDUAL.md`.
