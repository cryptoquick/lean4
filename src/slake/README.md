# Slake

**Slake** is the Systems Lean twin of [Lake](../lake/README.md): same public API (CLI + package model + config surface), freestanding residual-free product cores, linear multiplicities **0/1/ω**, and a CompCert **PROVABLY** bar on accepted product TUs.

| | Lake | Slake |
|--|------|-------|
| Tree | `src/lake/` | `src/slake/` (this directory) |
| Implementation | Classic Lean (Init/Std/IO/elab) | Systems freestanding + linear types |
| Config | `lakefile.toml` / `lakefile.lean` | Same files (TOML first for freestanding core) |
| Memory story | RC/GC host | `PRODUCT_GC_FREE` product + MemSafetyCert + ccomp PROVABLY |
| Status | Ships with Lean | Built by phase; Systems Lean dogfoods Slake |

Thin-forward examples (outside CLAIMED; need package root unless noted):

```text
slake translate-config   # W81
slake run                # W81
slake setup-file         # W82 classic + W102 FS_PROC/PIPE dual residual
slake self-check         # W82 classic + W103 FS_PROC/PIPE dual residual
slake version-tags       # W82 classic + W104 FS_PROC/PIPE dual residual
slake query-kind         # W83 classic + W113 FS_PROC/PIPE dual residual
slake resolve-deps       # W83 classic + W114 FS_PROC/PIPE dual residual
slake reservoir-config   # W83 classic + W115 FS_PROC/PIPE dual residual
slake exec               # W84 classic + W112 FS_PROC/PIPE dual residual (lake alias of exe)
slake upgrade            # W84 classic + W116 FS_PROC/PIPE dual residual (lake alias of update)
```

**Do not freestanding-ize Lake in place.** Slake is a parallel tree that implements the Lake API contract. Behavioral reference remains Lake; parity tests gate claims.

## Layout

```
src/slake/
  README.md          — this file
  Slake.lean         — root public import surface
  SlakeMain.lean     — classic-host executable entry
  Slake/
    CLI.lean         — Phase 2 MVP commands (build|clean|test|script|exe|lint|check-build|check-test|check-lint|query|shake|update|pack|unpack|cache|lean|scripts|new|init|serve|upload|translate-config|run|setup-file|self-check|version-tags|query-kind|resolve-deps|reservoir-config|env|--help|--version)
    Config.lean      — host TOML subset scan (name / defaultTargets names / lean_lib) for env+build+plan

tests/slake/driver/  — Lake package that builds the runnable `slake` binary
```

Freestanding **product math** (dep graph, TOML subset, traces, cache index, hashes, path views, proc spawn) lives under `src/Systems/` as residual-green `*Lite` modules and is linked through the Systems product matrix (`tests/lake/examples/systems/`). The Slake driver orchestrates those cores and (today) delegates package builds to classic `lake`.

## Phase 2 MVP status (honest residual)

| Piece | Status |
|-------|--------|
| CLI CLAIMED `build` / `clean` / `env` / `test` | **Wired** on classic host (`Slake.CLI`) — not freestanding TCB; default parity slice (`test` = `IO.Process` → `lake test` exit 0) |
| CLI thin forwards `script` / `exe` / `lint` / `check-build` (optional FS_PROC/PIPE W109; chdir+resolveLakeAbs) / `check-test` (optional FS_PROC/PIPE W110; chdir+resolveLakeAbs) / `check-lint` / `query` (optional FS_PROC/PIPE W96) / `shake` (optional FS_PROC/PIPE W97) / `serve` (optional FS_PROC/PIPE W98; chdir+resolveLakeAbs; rest may rebind) / `update` (optional FS_PROC/PIPE W92) / `pack` (optional FS_PROC/PIPE W93) / `unpack` (optional FS_PROC/PIPE W95) / `cache` (optional FS_PROC/PIPE W94) / `upload` (optional FS_PROC/PIPE W99; chdir+resolveLakeAbs; rest may rebind) / `lean` (optional FS_PROC/PIPE W100; chdir+resolveLakeAbs; rest may rebind) / `scripts` (optional FS_PROC/PIPE W101; chdir+resolveLakeAbs; rest may rebind) / `setup-file` (optional FS_PROC/PIPE W102; chdir+resolveLakeAbs; rest may rebind) / `self-check` (optional FS_PROC/PIPE W103; chdir+resolveLakeAbs; rest may rebind) / `new` (optional FS_PROC/PIPE W107; cwd bootstrap; chdir(cwd); resolveLakeAbs) / `init` (optional FS_PROC/PIPE W108) / `check-build` (optional FS_PROC/PIPE W109; chdir+resolveLakeAbs) / `translate-config` (optional FS_PROC/PIPE W105; chdir+resolveLakeAbs; rest may rebind) / `run` (optional FS_PROC/PIPE W106; chdir+resolveLakeAbs; rest may rebind) / `version-tags` (optional FS_PROC/PIPE W104; chdir+resolveLakeAbs; rest may rebind) / `query-kind` (optional FS_PROC/PIPE W113; chdir+resolveLakeAbs) / `resolve-deps` (optional FS_PROC/PIPE W114; chdir+resolveLakeAbs) / `reservoir-config` (optional FS_PROC/PIPE W115; chdir+resolveLakeAbs) / `exec` / `upgrade` | **Wired** → real Lake names via `IO.Process` default; `exe` optional FS_PROC/PIPE (W88); `lint` optional FS_PROC/PIPE (W89); `script` optional FS_PROC/PIPE (W90); `update` optional FS_PROC/PIPE (W92) — thin forwards **outside CLAIMED** (Lake has no bare `check`). CLAIMED is `(build clean env test)` (`new` dual residual outside CLAIMED; cwd bootstrap); `clean` FS_PROC/PIPE dual residual is on the CLAIMED row, not a thin-forward. |
| `build` spawn path | **Default:** `IO.Process` → `lake build`. **Optional:** `SLAKE_USE_FS_PROC=1` freestanding multi-arg `Systems.Proc`; `SLAKE_USE_FS_PROC_PIPE=1` freestanding pipe/stdio stdout capture demo (Option C shim + extract; empty child env). `SLAKE_FS_PROC_STRICT=1` disables fall back. Dogfood: `tests/slake/proc_dogfood`; smokes: `fs_proc_smoke.sh` / `fs_proc_pipe_smoke.sh` |
| `test` spawn path | **Default (CLAIMED):** `IO.Process` → `lake test` (parity: exit 0 via package test driver). **Optional (W87):** same `SLAKE_USE_FS_PROC=1` / `SLAKE_USE_FS_PROC_PIPE=1` / `STRICT` flags as build (empty child env; freestanding multi-arg / pipe). Smokes: `fs_proc_smoke.sh` / `fs_proc_pipe_smoke.sh` test bands |
| `exe` spawn path | **Default:** `IO.Process` → `lake exe` (outside CLAIMED). **Optional (W88):** same FS_PROC/PIPE/STRICT flags as build/test (empty child env). Smokes: `fs_proc_smoke.sh` / `fs_proc_pipe_smoke.sh` exe bands |
| `lint` spawn path | **Default:** `IO.Process` → `lake lint` (outside CLAIMED). **Optional (W89):** same FS_PROC/PIPE/STRICT flags as build/test/exe (empty child env). Smokes: `fs_proc_smoke.sh` / `fs_proc_pipe_smoke.sh` lint bands |
| `script` spawn path | **Default:** `IO.Process` → `lake script` (outside CLAIMED). **Optional (W90):** same FS_PROC/PIPE/STRICT flags as build/test/exe/lint (empty child env). Smokes: `fs_proc_smoke.sh` / `fs_proc_pipe_smoke.sh` script bands |
| `update` spawn path | **Default:** classic `IO.Process` → `lake update` (rest plumbed). **Optional (W92):** FS_PROC/PIPE → `lake update` (empty child env; rest plumbed; **not** empty-rest-only; outside CLAIMED). Smokes: update bands in `fs_proc_smoke.sh` / `fs_proc_pipe_smoke.sh`. |
| `pack` spawn path | **Default:** classic `IO.Process` → `lake pack` (`cwd=pkg`; rest plumbed). **Optional (W93):** FS_PROC/PIPE → `lake pack` (empty child env; **chdir(pkg)** so relative archive args match classic; rest plumbed — **not** empty-rest-only; outside CLAIMED). Bare pack may exit nonzero without prior `buildDir` artifacts — freestanding banner + no fall-back still counts as true dual-residual path. Smokes: pack bands in `fs_proc_smoke.sh` / `fs_proc_pipe_smoke.sh` (incl. relative archive parity). |
| `unpack` spawn path | **Default:** classic `IO.Process` → `lake unpack` (`cwd=pkg`; rest plumbed). **Optional (W95):** FS_PROC/PIPE → `lake unpack` (empty child env; **chdir(pkg)** so relative path args match classic; **resolveLakeAbs pre-chdir**; rest plumbed — **not** empty-rest-only; outside CLAIMED). Smokes: unpack bands in `fs_proc_smoke.sh` / `fs_proc_pipe_smoke.sh` (incl. cwd-parity / STRICT-negative / relative-path honesty).
| `query` spawn path | **Default:** classic `IO.Process` → `lake query` (`cwd=pkg`; rest plumbed). **Optional (W96):** FS_PROC/PIPE → `lake query` (empty child env; **chdir(pkg)** so relative path args match classic; **resolveLakeAbs pre-chdir**; rest plumbed — **not** empty-rest-only; outside CLAIMED). Smokes: query bands in `fs_proc_smoke.sh` / `fs_proc_pipe_smoke.sh` (incl. empty-rest / help / cwd-parity / STRICT-negative).
| `shake` spawn path | **Default:** classic `IO.Process` → `lake shake` (`cwd=pkg`; rest plumbed). **Optional (W97):** FS_PROC/PIPE → `lake shake` (empty child env; **chdir(pkg)** so relative path args match classic; **resolveLakeAbs pre-chdir**; rest plumbed — **not** empty-rest-only; outside CLAIMED). Smokes: shake bands in `fs_proc_smoke.sh` / `fs_proc_pipe_smoke.sh` (incl. empty-rest / help / cwd-parity / STRICT-negative). |
| `serve` spawn path | **Default:** classic `IO.Process` → `lake serve` (`cwd=pkg`; rest plumbed). **Optional (W98):** FS_PROC/PIPE → `lake serve` (empty child env; **chdir(pkg)** so relative path args match classic; **resolveLakeAbs pre-chdir**; rest plumbed — **not** empty-rest-only; rest may rebind Lake globals; outside CLAIMED; CLAIMED is `(build clean env test)`). Smokes: serve bands in `fs_proc_smoke.sh` / `fs_proc_pipe_smoke.sh` (incl. empty-rest / help / cwd-parity multi-arg / STRICT-negative; PIPE has no dedicated cwd-parity band — same as query/shake). |
| `upload` spawn path | **Default:** classic `IO.Process` → `lake upload` (`cwd=pkg`; rest plumbed). **Optional (W99):** FS_PROC/PIPE → `lake upload` (empty child env; **chdir(pkg)** so relative path args match classic; **resolveLakeAbs pre-chdir**; rest plumbed — **not** empty-rest-only; outside CLAIMED; CLAIMED is `(build clean env test)`). Smokes: upload bands in `fs_proc_smoke.sh` / `fs_proc_pipe_smoke.sh` (incl. empty-rest / help / cwd-parity multi-arg / STRICT-negative; PIPE has no dedicated cwd-parity band — same as query/shake/serve). |
| `lean` spawn path | **Default:** classic `IO.Process` → `lake lean` (`cwd=pkg`; rest plumbed). **Optional (W100):** FS_PROC/PIPE → `lake lean` (empty child env; **chdir(pkg)** so relative path args match classic; **resolveLakeAbs pre-chdir**; rest plumbed — **not** empty-rest-only; outside CLAIMED; CLAIMED is `(build clean env test)`). Smokes: lean bands in `fs_proc_smoke.sh` / `fs_proc_pipe_smoke.sh` (incl. empty-rest / help / cwd-parity / STRICT-negative). |
| `scripts` spawn path | **Default:** classic `IO.Process` → `lake scripts` (`cwd=pkg`; rest plumbed). **Optional (W101):** FS_PROC/PIPE → `lake scripts` (empty child env; **chdir(pkg)** so relative path args match classic; **resolveLakeAbs pre-chdir**; rest plumbed — **not** empty-rest-only; outside CLAIMED; CLAIMED is `(build clean env test)`). Smokes: scripts bands in `fs_proc_smoke.sh` / `fs_proc_pipe_smoke.sh` (incl. empty-rest / help / cwd-parity / STRICT-negative). |
| `version-tags` spawn path | **Default:** classic `IO.Process` → `lake version-tags` (`cwd=pkg`; rest plumbed). **Optional (W104):** FS_PROC/PIPE → `lake version-tags` (empty child env; **chdir(pkg)** so relative path args match classic; **resolveLakeAbs pre-chdir**; rest plumbed — **not** empty-rest-only; outside CLAIMED; CLAIMED is `(build clean env test)`). Smokes: version-tags bands in `fs_proc_smoke.sh` / `fs_proc_pipe_smoke.sh` (incl. empty-rest / help / cwd-parity / STRICT-negative). |
| `translate-config` spawn path | **Default:** classic `IO.Process` → `lake translate-config` (`cwd=pkg`; rest plumbed). **Optional (W105):** FS_PROC/PIPE → `lake translate-config` (empty child env; **chdir(pkg)** so relative path args match classic; **resolveLakeAbs pre-chdir**; rest plumbed — **not** empty-rest-only; outside CLAIMED; CLAIMED is `(build clean env test)`). Smokes: translate-config bands in `fs_proc_smoke.sh` / `fs_proc_pipe_smoke.sh` (when present). |
| `run` spawn path | **Default:** classic `IO.Process` → `lake run` (`cwd=pkg`; rest plumbed; Lake shorthand for `script run`). **Optional (W106):** FS_PROC/PIPE → `lake run` (empty child env; **chdir(pkg)** so relative path args match classic; **resolveLakeAbs pre-chdir**; rest plumbed — **not** empty-rest-only; outside CLAIMED; CLAIMED is `(build clean env test)`). Smokes: run bands in `fs_proc_smoke.sh` / `fs_proc_pipe_smoke.sh` (when present). |
| `new` spawn path | **Default:** classic `IO.Process` → `lake new` (cwd bootstrap — no package walk-up; rest plumbed). **Optional (W107):** FS_PROC/PIPE → `lake new` (empty child env; **chdir(cwd)** bootstrap — no package walk-up; **resolveLakeAbs pre-chdir**; rest plumbed — **not** empty-rest-only; outside CLAIMED; CLAIMED is `(build clean env test)`). Smokes: new bands in `fs_proc_smoke.sh` / `fs_proc_pipe_smoke.sh` (when present). |
| `init` spawn path | **Default:** classic `IO.Process` → `lake init` (cwd bootstrap — no package walk-up; rest plumbed). **Optional (W108):** FS_PROC/PIPE → `lake init` (empty child env; **chdir(cwd)** bootstrap — no package walk-up; **resolveLakeAbs pre-chdir**; rest plumbed — **not** empty-rest-only; outside CLAIMED; CLAIMED is `(build clean env test)`). Smokes: init bands in `fs_proc_smoke.sh` / `fs_proc_pipe_smoke.sh` (when present). |
| `check-build` spawn path | **Default:** classic `IO.Process` → `lake check-build` (`cwd=pkg`; rest plumbed). **Optional (W109):** FS_PROC/PIPE → `lake check-build` (empty child env; **chdir(pkg)** so relative path args match classic; **resolveLakeAbs pre-chdir**; rest plumbed — **not** empty-rest-only; outside CLAIMED; CLAIMED is `(build clean env test)`). |
| `self-check` spawn path | **Default:** classic `IO.Process` → `lake self-check` (`cwd=pkg`; rest plumbed). **Optional (W103):** FS_PROC/PIPE → `lake self-check` (empty child env; **chdir(pkg)** so relative path args match classic; **resolveLakeAbs pre-chdir**; rest plumbed — **not** empty-rest-only; outside CLAIMED; CLAIMED is `(build clean env test)`). Smokes: self-check bands in `fs_proc_smoke.sh` / `fs_proc_pipe_smoke.sh` (incl. empty-rest / help / cwd-parity / STRICT-negative). |
| `setup-file` spawn path | **Default:** classic `IO.Process` → `lake setup-file` (`cwd=pkg`; rest plumbed). **Optional (W102):** FS_PROC/PIPE → `lake setup-file` (empty child env; **chdir(pkg)** so relative path args match classic; **resolveLakeAbs pre-chdir**; rest plumbed — **not** empty-rest-only; outside CLAIMED; CLAIMED is `(build clean env test)`). Smokes: setup-file bands in `fs_proc_smoke.sh` / `fs_proc_pipe_smoke.sh` (incl. empty-rest / help / cwd-parity / STRICT-negative). |
| `cache` spawn path | **Default:** classic `IO.Process` → `lake cache` (`cwd=pkg`; rest plumbed). **Optional (W94):** FS_PROC/PIPE → `lake cache` (empty child env; **chdir(pkg)** so relative path args match classic; rest plumbed — **not** empty-rest-only; outside CLAIMED). Smokes: cache bands in `fs_proc_smoke.sh` / `fs_proc_pipe_smoke.sh` (incl. cwd-parity / relative-path honesty after BUG-1 absolute lake resolve). |
| `clean` spawn path | **Default (CLAIMED; A17+A33):** native wipe `pkg/.lake/build` **and** `pkg/.slake-native` when present, then each path-require package’s `.slake-native/` (A26 under-pkg / A29 sibling confining; identity order; soft missing OK; symlink fence; **empty-rest-only** — non-empty rest refused; native product out dir wipe subset — not full Lake clean / not git/url / not multi-`..` / not dep `.lake/build`). **Optional (W91):** FS_PROC/PIPE → `lake clean` then same native wipe set (Lake clean may wipe more than `.lake/build`; **empty-rest-only**; empty child env; CLAIMED token dual residual). Smokes: clean bands in `fs_proc_smoke.sh` / `fs_proc_pipe_smoke.sh`; A17 `native_clean_smoke.sh`; A33 `native_pathdep_clean_smoke.sh`. |
| `build` depgraph plan | **Optional (A3–A35):** `SLAKE_DEPGRAPH=1` prints **package-derived** freestanding `DepGraph` Kahn plan (host `Slake.Config` nodes = package `name` + `defaultTargets` / per-lib `roots` / per-lib `globs` expand / lean_lib names; module paths via package or per-lib `srcDir` + dotted `Foo/Bar.lean` with flat fallback; **import-scan DAG subset** among plan nodes when top-level `import` edges exist, else Option C `chain_topo` declaration-order fallback) before lake. `SLAKE_PLAN_ONLY=1` prints the same plan and **skips lake** (exit 0; dry-run / CI plan path). `SLAKE_DEPGRAPH_DEMO=1` also prints legacy demo `C B A`. Plan ≠ freestanding build TCB; package/per-lib srcDir + roots/globs subset — not full Lake import resolution / module faceting / full Glob. A18: multi-line `defaultTargets` / per-lib `roots` / `globs` double-quoted arrays (not full TOML). A24/A25: per-lib `globs` ones + `.+` / `.*` recursive multi-level confining walk, depth-bounded (not full Lake Glob / freestanding build TCB / CLAIMED). Unlinked + DEPGRAPH (no PLAN_ONLY) → soft-skip warn. Smokes: `depgraph_cli_smoke.sh` / `plan_only_smoke.sh` / `systems_plan_smoke.sh` / `import_dag_smoke.sh` / `srcdir_plan_smoke.sh` / `native_check_smoke.sh` / `native_olean_smoke.sh` / `native_olean_cache_smoke.sh` / `native_olean_hash_smoke.sh` / `native_build_smoke.sh` / `native_olean_deps_hash_smoke.sh` / `native_olean_parallel_smoke.sh` / `native_link_smoke.sh` / `native_graph_smoke.sh` / `native_seal_smoke.sh` / `native_c_smoke.sh` / `native_obj_smoke.sh` / `native_irlink_smoke.sh` / `native_ar_smoke.sh` / `native_exe_smoke.sh` / `roots_plan_smoke.sh` / `multiline_roots_plan_smoke.sh` / `globs_plan_smoke.sh` / `require_path_smoke.sh` / `require_path_cascade_smoke.sh` / `require_path_deps_hash_smoke.sh` / `require_sibling_smoke.sh` (soft SKIP without binary; `*_SMOKE_STRICT=1` hard-fails). **A26 path `[[require]]`**: safe relative `path` (no absolute; no `..` except A29); LEAN_PATH feed + path-dep olean precompile (depth-bounded); root plan stays root-only — not git/url / not Lake resolve-deps / not package-transitive root plan / not freestanding build TCB / not CLAIMED. **A29 sibling confining `../path`**: exactly one leading `..` + ≥1 safe components under package-parent confining root (`../dep`, `../packages/foo`); refuse multi-`..` escape / bare `..` / mid-path `..` / absolute; real-dir lstat fence — not workspace multi-level walk-up / not freestanding build TCB / not CLAIMED. **A27 path-dep → root cascade**: after path-require precompile, consumer modules that import path-dep plan modules rebuild when a path-dep olean is newer (`path-dep-olean-newer`) — not package-transitive plan into root / not freestanding build TCB / not CLAIMED. **A28 path-dep deps-hash fold**: path-dep import source hashes fold into A11 frozen `deps <hex>` (deps-line-stale across package boundary; not Lake package-transitive / not package-transitive plan into root / not freestanding build TCB / not CLAIMED). **`SLAKE_NATIVE_CHECK=1`**: after plan, sequential host-lean typecheck of plan modules (`lean <file>`; skip package name; LEAN_PATH=pkg[+srcDir]; implies plan print; with PLAN_ONLY still no lake; not freestanding build TCB / not olean orchestration / not CLAIMED). **`SLAKE_NATIVE_OLEAN=1`**: after plan, multi-module host-lean compile writing oleans into package-local `.slake-native/` + LEAN_PATH feed (implies plan; with PLAN_ONLY still no lake; default sequential honesty; **A9** mtime + plan-edge cascade; **A10** FNV-1a 64 source content-hash sidecar subset — touch-without-edit → `hash-fresh` skip; **A11** plan-node transitive deps-hash — live plan-import dep hash-fresh gate + optional frozen `deps <hex>` sidecar line; **A12** optional `SLAKE_NATIVE_OLEAN_JOBS=N` ready-set parallel host-lean olean waves (default sequential; not Lake job server TCB / not CLAIMED / not shared-lib link); `SLAKE_NATIVE_OLEAN_FORCE=1` rebuilds all; not freestanding build TCB / not lake-equivalent TCB / not CLAIMED / not full olean graph invalidation / not Lake shake/hash TCB / not Lake package-transitive hash). **`SLAKE_NATIVE_BUILD=1`**: freestanding-adjacent native olean build subset (implies plan + NATIVE_OLEAN; JOBS applies; skip lake on success; fail-closed on compile fail; not freestanding build TCB / not Lake TCB / not CLAIMED). **`SLAKE_NATIVE_C=1` (A19)**: host lean C-output emit subset after oleans (implies plan + NATIVE_OLEAN; `lean -c .slake-native/<ModRel>.c <file>` with same LEAN_PATH as olean; not freestanding build TCB / not Lake lean_lib SO of compiled Lean IR / not object compile+link of Lean runtime / not CLAIMED; with NATIVE_BUILD, skip-lake requires C emit success). **`SLAKE_NATIVE_OBJ=1` (A20)**: host object compile of lean C after C emit (implies plan + NATIVE_OLEAN + NATIVE_C; `cc -c -fPIC -I<leanInclude> -o .slake-native/<ModRel>.o .slake-native/<ModRel>.c`; not freestanding build TCB / not Lake lean_lib SO / not linking Lean runtime into SO / not CLAIMED; with NATIVE_BUILD, skip-lake requires object compile success). **`SLAKE_NATIVE_IRLINK=1` (A21)**: host leanc IR shared-lib link of plan-module objects + Lean runtime via leanc (implies plan + NATIVE_OLEAN + NATIVE_C + NATIVE_OBJ; `leanc -shared -o .slake-native/libslake_ir.so <objs…>`; not freestanding build TCB / not Lake lean_lib shared-object TCB / not CLAIMED; A13 remains separate name-table SO; with NATIVE_BUILD, skip-lake requires IR link success). **`SLAKE_NATIVE_AR=1` (A22)**: host static archive of plan-module objects via ar rcs (implies plan + NATIVE_OLEAN + NATIVE_C + NATIVE_OBJ; does not imply IRLINK; `ar rcs .slake-native/libslake_ir.a <objs…>`; not freestanding build TCB / not Lake lean_lib static/shared facet / not CLAIMED / not linking Lean runtime into the archive; with NATIVE_BUILD, skip-lake requires archive success). **`SLAKE_NATIVE_EXE=1` (A23)**: host leanc executable link of plan-module objects + stub main + Lean runtime via leanc (implies plan + NATIVE_OLEAN + NATIVE_C + NATIVE_OBJ; does not imply IRLINK or AR; `leanc -o .slake-native/slake_ir .slake-native/slake_native_main.c <objs…>`; generated stub main returns 0 — not Lake lean_exe root / not freestanding app TCB / not CLAIMED; with NATIVE_BUILD, skip-lake requires executable link success). **`SLAKE_NATIVE_LINK=1` (A13)**: host shared-lib link subset after oleans (implies plan + NATIVE_OLEAN; `.slake-native/libslake_native.so` via host `cc -shared -fPIC`; exports `slake_native_plan_modules`; not Lake lean_lib shared-object / not freestanding build TCB / not Lake shared-lib TCB / not CLAIMED; with NATIVE_BUILD, skip-lake requires link success). **`SLAKE_NATIVE_GRAPH=1` (A14)**: host package link graph subset after oleans (implies plan + NATIVE_OLEAN; writes `.slake-native/slake_native_graph` with package/module/edge/optional shared_lib/optional shared_lib_ir/optional static_lib/optional executable/summary; **A32** A30-folded path-dep modules list root-package-relative olean paths e.g. `dep/.slake-native/Dep.olean`; not freestanding build TCB / not Lake build graph TCB / not Lake lean_lib SO / not CLAIMED; with NATIVE_BUILD, skip-lake requires graph write). **`SLAKE_NATIVE_SEAL=1` (A15)**: host freestanding-adjacent product seal subset after oleans (implies plan + NATIVE_OLEAN; writes `.slake-native/slake_native_seal` with package/module olean_hash/optional graph_hash/optional shared_lib/optional shared_lib_ir/optional static_lib/optional executable/seal digest/summary; **A32** A30-folded path-dep modules contribute olean_hash from path-dep sidecar/source; not freestanding build TCB / not Lake lean_lib SO / not Lake build graph TCB / not CLAIMED; with NATIVE_BUILD, skip-lake requires seal write; order olean → C emit → obj → IR link → static archive → executable link → name-table link → graph → seal). **SCORE alone does not prove these smokes**. |
| `clean` (semantics) | **Native (A17+A33):** removes package **`pkg/.lake/build`** and **`pkg/.slake-native`** when present, then each path-require package’s **`.slake-native`** (A26 under-pkg / A29 sibling confining; identity order; not bare `build/`; not full Lake clean; not dep `.lake/build`); best-effort `lstat` symlink fence on `.lake` / `.lake/build` / `.slake-native` root + path-require (TOCTOU residual; not fd/`O_NOFOLLOW`). **FS_PROC/PIPE:** delegates to `lake clean` (Lake’s clean set) then still native-wipes root + path-require `.slake-native`. Both paths: empty rest only. |
| Package walk-up | Nearest plausible root; rejects bare monorepo `tests/lakefile.toml` |
| Config identity | **Shipped** (`Slake.Config`): host scan of `lakefile.toml` for package `name` / `defaultTargets` **names** (+ count; single- or multi-line arrays A18) / `[[lean_lib]]` count + names + optional per-lib `roots`/`srcDir`/`globs` (A16/A24/A25; multi-line arrays A18) / optional package `srcDir` / optional `[[require]]` name+path (A26 under-pkg safe relative **or** A29 sibling confining `../dep`; not git/url / not Lake resolve-deps / not multi-`..` escape); plan nodes + package/per-lib srcDir/dotted path resolution for DEPGRAPH / PLAN_ONLY / NATIVE_CHECK / NATIVE_OLEAN / NATIVE_BUILD / NATIVE_C / NATIVE_OBJ / NATIVE_IRLINK / NATIVE_AR / NATIVE_EXE / NATIVE_LINK / NATIVE_GRAPH / NATIVE_SEAL; A26 path-require LEAN_PATH + path-dep olean precompile on NATIVE_*; A29 sibling confining resolve under package parent; A27 path-dep → root cascade (`path-dep-olean-newer`); A28 path-dep source-hash fold into A11 deps-line; A30 package-transitive plan subset (import-driven); A31 path-dep plan-module C/OBJ into IR products; A32 path-dep plan-module nodes in NATIVE_GRAPH + NATIVE_SEAL (root-package-relative olean paths + path-dep olean_hash); A35 plan-module C source inventory in NATIVE_GRAPH + NATIVE_SEAL (`c_source <Mod>` + `c_hash`); A34 plan-module object inventory in NATIVE_GRAPH + NATIVE_SEAL (`object <Mod>` + `obj_hash`); A33 path-require package `.slake-native` wipe on CLAIMED clean; printed by CLAIMED `env` and `build`. Freestanding decode stays in `Systems.TomlConfig` |
| Runnable `slake` binary | **Shipped** via `tests/slake/driver` (links freestanding extract for FS_PROC; not installed with stage1 by default) |
| Full Lake parity | **Not claimed** |

### How to build and run

```bash
# stage1 lean/lake on PATH
export PATH="$PWD/build/release/stage1/bin:${PATH:-}"

# product extract (required for FS_PROC link)
make -C tests/lake/examples/systems -j"$(nproc)" lake

cd tests/slake/driver && lake build
# → tests/slake/driver/.lake/build/bin/slake

# optional drop-in for parity default lookup:
# cp/symlink .lake/build/bin/slake → tests/slake/parity/slake

./.lake/build/bin/slake --help
./.lake/build/bin/slake --version
./.lake/build/bin/slake env          # reports FS_PROC / DEPGRAPH link status
./.lake/build/bin/slake build        # default: IO.Process → lake build
SLAKE_USE_FS_PROC=1 ./.lake/build/bin/slake build   # freestanding Systems.Proc multi-arg
SLAKE_USE_FS_PROC=1 ./.lake/build/bin/slake test    # freestanding Proc for test (W87; CLAIMED default is classic IO.Process)
SLAKE_USE_FS_PROC=1 ./.lake/build/bin/slake exe --help  # freestanding Proc for exe (W88; not CLAIMED)
SLAKE_USE_FS_PROC=1 ./.lake/build/bin/slake lint --help # freestanding Proc for lint (W89; not CLAIMED)
SLAKE_USE_FS_PROC=1 ./.lake/build/bin/slake script --help # freestanding Proc for script (W90; not CLAIMED)
SLAKE_USE_FS_PROC=1 ./.lake/build/bin/slake clean         # freestanding Proc → lake clean (W91; CLAIMED dual residual; empty rest only)
SLAKE_USE_FS_PROC=1 ./.lake/build/bin/slake update        # freestanding Proc → lake update (W92; outside CLAIMED; rest plumbed)
SLAKE_USE_FS_PROC_PIPE=1 ./.lake/build/bin/slake update   # freestanding pipe → lake update (W92)
SLAKE_USE_FS_PROC=1 ./.lake/build/bin/slake pack          # freestanding Proc → lake pack (W93; outside CLAIMED; rest plumbed; chdir pkg)
SLAKE_USE_FS_PROC=1 ./.lake/build/bin/slake unpack        # freestanding Proc → lake unpack (W95; outside CLAIMED; rest plumbed; chdir pkg)
SLAKE_USE_FS_PROC=1 ./.lake/build/bin/slake query         # freestanding Proc → lake query (W96; outside CLAIMED; rest plumbed; chdir pkg)
SLAKE_USE_FS_PROC=1 ./.lake/build/bin/slake shake         # freestanding Proc → lake shake (W97; outside CLAIMED; rest plumbed; chdir pkg)
SLAKE_USE_FS_PROC=1 ./.lake/build/bin/slake serve         # freestanding Proc → lake serve (W98; outside CLAIMED; rest plumbed; chdir pkg; resolveLakeAbs pre-chdir)
SLAKE_USE_FS_PROC_PIPE=1 ./.lake/build/bin/slake serve    # freestanding pipe → lake serve (W98)
SLAKE_USE_FS_PROC=1 ./.lake/build/bin/slake serve --help  # serve rest plumbed (may rebind Lake globals; not empty-rest-only)
SLAKE_USE_FS_PROC=1 ./.lake/build/bin/slake pack --help   # pack rest plumbed (may rebind Lake globals; not empty-rest-only)
# bare pack may exit nonzero without .lake/build artifacts — still require freestanding banner (no IO.Process fall-back)
# clean non-empty rest (incl. --help) is refused on native and FS_PROC/PIPE
SLAKE_USE_FS_PROC_PIPE=1 ./.lake/build/bin/slake build  # freestanding Proc pipe/stdio demo
SLAKE_DEPGRAPH=1 ./.lake/build/bin/slake build      # package-derived freestanding DepGraph plan then lake
SLAKE_PLAN_ONLY=1 ./.lake/build/bin/slake build     # package plan only; skip lake (exit 0)
SLAKE_DEPGRAPH=1 SLAKE_PLAN_ONLY=1 ./.lake/build/bin/slake build  # freestanding plan, no lake
SLAKE_PLAN_ONLY=1 SLAKE_NATIVE_CHECK=1 ./.lake/build/bin/slake build  # plan + sequential host-lean typecheck; no lake (A7; not CLAIMED)
SLAKE_PLAN_ONLY=1 SLAKE_NATIVE_OLEAN=1 ./.lake/build/bin/slake build  # plan + multi-module sequential olean compile; no lake (A8–A12; mtime/hash/deps-hash skip when fresh; not CLAIMED)
SLAKE_PLAN_ONLY=1 SLAKE_NATIVE_OLEAN=1 SLAKE_NATIVE_OLEAN_JOBS=2 ./.lake/build/bin/slake build  # plan + parallel ready-set olean waves; no lake (A12; not Lake job server TCB / not CLAIMED)
SLAKE_PLAN_ONLY=1 SLAKE_NATIVE_OLEAN=1 SLAKE_NATIVE_OLEAN_FORCE=1 ./.lake/build/bin/slake build  # force rebuild all oleans (A9–A11)
SLAKE_NATIVE_BUILD=1 ./.lake/build/bin/slake build  # freestanding-adjacent native olean build; skip lake on success (A10–A12; JOBS applies; not CLAIMED)
SLAKE_PLAN_ONLY=1 SLAKE_NATIVE_C=1 ./.lake/build/bin/slake build  # plan + olean + host lean C-output emit; no lake (A19; not freestanding build TCB / not Lake lean_lib SO / not CLAIMED)
SLAKE_NATIVE_BUILD=1 SLAKE_NATIVE_C=1 ./.lake/build/bin/slake build  # olean + C emit; skip lake only if both succeed (A19)
SLAKE_PLAN_ONLY=1 SLAKE_NATIVE_OBJ=1 ./.lake/build/bin/slake build  # plan + olean + C + host object compile; no lake (A20; not freestanding build TCB / not Lake lean_lib SO / not CLAIMED)
SLAKE_NATIVE_BUILD=1 SLAKE_NATIVE_OBJ=1 ./.lake/build/bin/slake build  # olean + C emit + object compile; skip lake only if all succeed (A20)
SLAKE_PLAN_ONLY=1 SLAKE_NATIVE_IRLINK=1 ./.lake/build/bin/slake build  # plan + olean + C + obj + leanc IR shared-lib; no lake (A21; not freestanding build TCB / not Lake lean_lib SO TCB / not CLAIMED)
SLAKE_NATIVE_BUILD=1 SLAKE_NATIVE_IRLINK=1 ./.lake/build/bin/slake build  # olean + C + obj + IR link; skip lake only if all succeed (A21)
SLAKE_PLAN_ONLY=1 SLAKE_NATIVE_AR=1 ./.lake/build/bin/slake build  # plan + olean + C + obj + static archive; no lake (A22; not freestanding build TCB / not Lake lean_lib static/shared facet / not CLAIMED)
SLAKE_NATIVE_BUILD=1 SLAKE_NATIVE_AR=1 ./.lake/build/bin/slake build  # olean + C + obj + static archive; skip lake only if all succeed (A22)
SLAKE_PLAN_ONLY=1 SLAKE_NATIVE_EXE=1 ./.lake/build/bin/slake build  # plan + olean + C + obj + host leanc executable link; no lake (A23; not freestanding build TCB / not Lake lean_exe / not CLAIMED)
SLAKE_NATIVE_BUILD=1 SLAKE_NATIVE_EXE=1 ./.lake/build/bin/slake build  # olean + C + obj + executable link; skip lake only if all succeed (A23)
SLAKE_PLAN_ONLY=1 SLAKE_NATIVE_LINK=1 ./.lake/build/bin/slake build  # plan + olean + host shared-lib link; no lake (A13; not freestanding build TCB / not Lake shared-lib TCB / not CLAIMED)
SLAKE_NATIVE_BUILD=1 SLAKE_NATIVE_LINK=1 ./.lake/build/bin/slake build  # olean + shared-lib link; skip lake only if both succeed (A13)
SLAKE_PLAN_ONLY=1 SLAKE_NATIVE_GRAPH=1 ./.lake/build/bin/slake build  # plan + olean + package link graph; no lake (A14; not freestanding build TCB / not Lake build graph TCB / not CLAIMED)
SLAKE_NATIVE_BUILD=1 SLAKE_NATIVE_GRAPH=1 ./.lake/build/bin/slake build  # olean + package link graph; skip lake only if both succeed (A14)
SLAKE_NATIVE_BUILD=1 SLAKE_NATIVE_LINK=1 SLAKE_NATIVE_GRAPH=1 ./.lake/build/bin/slake build  # olean + link + graph; skip lake only if all succeed (A13+A14)
SLAKE_PLAN_ONLY=1 SLAKE_NATIVE_SEAL=1 ./.lake/build/bin/slake build  # plan + olean + product seal; no lake (A15; not freestanding build TCB / not Lake lean_lib SO / not Lake build graph TCB / not CLAIMED)
SLAKE_NATIVE_BUILD=1 SLAKE_NATIVE_SEAL=1 ./.lake/build/bin/slake build  # olean + product seal; skip lake only if both succeed (A15)
SLAKE_NATIVE_BUILD=1 SLAKE_NATIVE_LINK=1 SLAKE_NATIVE_GRAPH=1 SLAKE_NATIVE_SEAL=1 ./.lake/build/bin/slake build  # olean + link + graph + seal; skip lake only if all succeed (A13–A15)
./.lake/build/bin/slake clean        # native: removes package .lake/build + .slake-native + path-require dep .slake-native when present (empty rest; A17+A33 product out dir wipe subset — not full Lake clean / not git/url / not multi-..)
./.lake/build/bin/slake test         # delegates to lake test (IO.Process)
./.lake/build/bin/slake script       # delegates to lake script (IO.Process; not CLAIMED)
./.lake/build/bin/slake exe          # delegates to lake exe (IO.Process; not CLAIMED)
./.lake/build/bin/slake lint         # delegates to lake lint (IO.Process; not CLAIMED)
./.lake/build/bin/slake check-build  # delegates to lake check-build (IO.Process default; optional FS_PROC/PIPE W109; not CLAIMED; no bare `check`)
./.lake/build/bin/slake check-test   # delegates to lake check-test (classic default; optional FS_PROC/PIPE W110; not CLAIMED)
./.lake/build/bin/slake check-lint   # delegates to lake check-lint (IO.Process; not CLAIMED)
./.lake/build/bin/slake query        # delegates to lake query (IO.Process default; optional FS_PROC/PIPE W96; not CLAIMED)
./.lake/build/bin/slake shake        # delegates to lake shake (IO.Process default; optional FS_PROC/PIPE W97; not CLAIMED)
./.lake/build/bin/slake update       # delegates to lake update (IO.Process default; optional FS_PROC/PIPE W92; not CLAIMED)
./.lake/build/bin/slake pack         # delegates to lake pack (IO.Process; not CLAIMED)
./.lake/build/bin/slake unpack       # delegates to lake unpack (IO.Process default; optional FS_PROC/PIPE W95; not CLAIMED)
./.lake/build/bin/slake cache        # delegates to lake cache (IO.Process default; optional FS_PROC/PIPE W94; not CLAIMED)
./.lake/build/bin/slake lean         # delegates to lake lean (IO.Process default; optional FS_PROC/PIPE W100 dual residual; not CLAIMED)
./.lake/build/bin/slake scripts      # delegates to lake scripts (IO.Process default; optional FS_PROC/PIPE W101 dual residual; not CLAIMED)
./.lake/build/bin/slake new          # delegates to lake new (IO.Process default; optional FS_PROC/PIPE W107 dual residual; cwd bootstrap; not CLAIMED)
./.lake/build/bin/slake init         # delegates to lake init (IO.Process default; optional FS_PROC/PIPE W108; not CLAIMED)
./.lake/build/bin/slake serve        # delegates to lake serve (classic IO.Process default; optional FS_PROC/PIPE W98 dual residual; not CLAIMED)
./.lake/build/bin/slake upload       # delegates to lake upload (classic IO.Process default; optional FS_PROC/PIPE W99 dual residual; not CLAIMED)
./.lake/build/bin/slake translate-config  # delegates to lake translate-config (IO.Process default; optional FS_PROC/PIPE W105 dual residual; not CLAIMED)
./.lake/build/bin/slake run          # delegates to lake run (IO.Process default; optional FS_PROC/PIPE W106 dual residual; not CLAIMED)
./.lake/build/bin/slake setup-file   # delegates to lake setup-file (IO.Process default; optional FS_PROC/PIPE W102 dual residual; not CLAIMED)
./.lake/build/bin/slake self-check   # delegates to lake self-check (IO.Process default; optional FS_PROC/PIPE W103 dual residual; not CLAIMED)
./.lake/build/bin/slake version-tags # delegates to lake version-tags (IO.Process default; optional FS_PROC/PIPE W104 dual residual; not CLAIMED)
./.lake/build/bin/slake query-kind   # delegates to lake query-kind (IO.Process default; optional FS_PROC/PIPE W113 dual residual; not CLAIMED)
./.lake/build/bin/slake resolve-deps # delegates to lake resolve-deps (IO.Process default; optional FS_PROC/PIPE W114 dual residual; not CLAIMED)
./.lake/build/bin/slake reservoir-config # delegates to lake reservoir-config (IO.Process default; optional FS_PROC/PIPE W115 dual residual; not CLAIMED)
./.lake/build/bin/slake exec      # delegates to lake exec (IO.Process default; optional FS_PROC/PIPE W112 dual residual; not CLAIMED; alias of exe)
./.lake/build/bin/slake upgrade   # delegates to lake upgrade (IO.Process default; optional FS_PROC/PIPE W116 dual residual; not CLAIMED; Lake alias of update)
SLAKE_USE_FS_PROC=1 ./.lake/build/bin/slake query-kind --help  # freestanding Proc → lake query-kind (W113)
SLAKE_USE_FS_PROC=1 ./.lake/build/bin/slake resolve-deps --help  # freestanding Proc → lake resolve-deps (W114)
SLAKE_USE_FS_PROC=1 ./.lake/build/bin/slake reservoir-config --help  # freestanding Proc → lake reservoir-config (W115)
SLAKE_USE_FS_PROC=1 ./.lake/build/bin/slake upgrade --help  # freestanding Proc → lake upgrade (W116)
```

Parity harness (default IO.Process path; **CLAIMED** = `build`/`clean`/`env`/`test` — `slake script`/`exe`/`lint`/`check-build` (optional FS_PROC/PIPE W109)/`check-test` (optional FS_PROC/PIPE W110)/`check-lint`/`query`/`shake`/`update`/`pack`/`unpack`/`cache`/`lean`/`scripts`/`new`/`init`/`serve`/`upload`/`translate-config` (optional FS_PROC/PIPE W105)/`run` (optional FS_PROC/PIPE W106)/`setup-file` (optional FS_PROC/PIPE W102)/`self-check` (optional FS_PROC/PIPE W103)/`version-tags` (optional FS_PROC/PIPE W104)/`query-kind`/`resolve-deps`/`reservoir-config`/`exec`/`upgrade` (optional FS_PROC/PIPE W116) are CLI-wired (dispatch-level residual; **no** dedicated CLI smoke harness) but **outside** CLAIMED until `Slake_parity_more` grows the harness; `test` is CLAIMED with partial semantics — exit 0 via lake-test delegate, not freestanding TCB):

```bash
SLAKE_BIN="$PWD/tests/slake/driver/.lake/build/bin/slake" \
  ./tests/slake/parity/run_parity.sh
# → OK: lake and slake claimed slice (build clean env test) with build artifacts

# FS_PROC true-green smoke (requires linked extract):
SLAKE_USE_FS_PROC=1 ./tests/slake/fs_proc_smoke.sh
SLAKE_USE_FS_PROC_PIPE=1 ./tests/slake/fs_proc_pipe_smoke.sh

# DEPGRAPH package plan smoke (requires linked extract; soft SKIP if unlinked):
SLAKE_DEPGRAPH=1 ./tests/slake/depgraph_cli_smoke.sh
# PLAN_ONLY dry-run (no lake spawn; soft SKIP if binary missing):
./tests/slake/plan_only_smoke.sh
# A4 Systems-shaped multi-target dogfood:
./tests/slake/systems_plan_smoke.sh
# A5 import-scan DAG (Host imports Core → Core before Host):
./tests/slake/import_dag_smoke.sh
# A6 srcDir + dotted (src/Host meta-imports Foo.Bar → Foo.Bar before Host):
./tests/slake/srcdir_plan_smoke.sh
# A7 thin sequential host-lean typecheck (PLAN_ONLY+NATIVE_CHECK; not CLAIMED / not freestanding build TCB):
./tests/slake/native_check_smoke.sh
# A8 multi-module sequential host-lean + olean LEAN_PATH (PLAN_ONLY+NATIVE_OLEAN; not CLAIMED / not freestanding build TCB):
./tests/slake/native_olean_smoke.sh
# A9 mtime + plan-edge cascade (skip fresh; soft-skip/dep-olean-newer cascade; FORCE rebuilds all; not Lake shake/hash TCB):
./tests/slake/native_olean_cache_smoke.sh
# A10 FNV-1a 64 source content-hash sidecar (touch-without-edit → hash-fresh; content edit rebuilds + cascade):
./tests/slake/native_olean_hash_smoke.sh
# A10 NATIVE_BUILD freestanding-adjacent sequential native olean build (skip lake on success; not CLAIMED):
./tests/slake/native_build_smoke.sh
# A11 plan-node transitive deps-hash (direct plan-import hash-fresh snapshot + frozen deps <hex> + skip-heal; cascade multi-hop; not Lake package-transitive):
./tests/slake/native_olean_deps_hash_smoke.sh
# A28 path-dep source-hash fold into A11 deps-line (consumer path-dep imports; deps-line-stale across package boundary; not Lake package-transitive):
./tests/slake/require_path_deps_hash_smoke.sh
# A29 sibling confining path [[require]] (../dep under package-parent; multi-.. escape refuse; not CLAIMED):
./tests/slake/require_sibling_smoke.sh
# A30 package-transitive plan subset (import-driven path-dep plan fold; not Lake resolve-deps):
./tests/slake/require_transitive_plan_smoke.sh
# A31 path-dep plan-module C/OBJ into IR products (A30-folded only; not Lake lean_lib facet):
./tests/slake/native_pathdep_ir_smoke.sh
# A32 path-dep plan-module nodes in NATIVE_GRAPH + NATIVE_SEAL (package-cwd-relative olean paths + path-dep olean_hash; not CLAIMED):
./tests/slake/native_pathdep_graph_seal_smoke.sh
# A33 path-require package .slake-native wipe on CLAIMED clean (after A17 root wipe; not git/url / not multi-.. / not CLAIMED expansion):
./tests/slake/native_pathdep_clean_smoke.sh
# A34 plan-module object inventory in NATIVE_GRAPH + NATIVE_SEAL (object <Mod> relpath + obj_hash; not CLAIMED):
./tests/slake/native_obj_graph_seal_smoke.sh
# A35 plan-module C source inventory in NATIVE_GRAPH + NATIVE_SEAL (c_source <Mod> relpath + c_hash; not CLAIMED):
./tests/slake/native_c_graph_seal_smoke.sh
# A12 JOBS ready-set parallel host-lean olean waves (default sequential; N≥2 concurrent lean -o among ready plan modules; not Lake job server / not CLAIMED):
./tests/slake/native_olean_parallel_smoke.sh
# A13 host shared-lib link subset after native oleans (not freestanding build TCB / not Lake shared-lib TCB / not CLAIMED):
./tests/slake/native_link_smoke.sh
# A14 host package link graph subset after native oleans (not freestanding build TCB / not Lake build graph TCB / not CLAIMED):
./tests/slake/native_graph_smoke.sh
# A15 host freestanding-adjacent product seal subset after native oleans (not freestanding build TCB / not Lake lean_lib SO / not Lake build graph TCB / not CLAIMED):
./tests/slake/native_seal_smoke.sh
# hard-fail if binary/shim missing (CI opt-in):
SLAKE_DEPGRAPH_SMOKE_STRICT=1 ./tests/slake/depgraph_cli_smoke.sh
SLAKE_PLAN_ONLY_SMOKE_STRICT=1 ./tests/slake/plan_only_smoke.sh
SLAKE_SYSTEMS_PLAN_SMOKE_STRICT=1 ./tests/slake/systems_plan_smoke.sh
SLAKE_IMPORT_DAG_SMOKE_STRICT=1 ./tests/slake/import_dag_smoke.sh
SLAKE_SRCDIR_PLAN_SMOKE_STRICT=1 ./tests/slake/srcdir_plan_smoke.sh
SLAKE_NATIVE_CHECK_SMOKE_STRICT=1 ./tests/slake/native_check_smoke.sh
SLAKE_NATIVE_OLEAN_SMOKE_STRICT=1 ./tests/slake/native_olean_smoke.sh
SLAKE_NATIVE_OLEAN_CACHE_SMOKE_STRICT=1 ./tests/slake/native_olean_cache_smoke.sh
SLAKE_NATIVE_OLEAN_HASH_SMOKE_STRICT=1 ./tests/slake/native_olean_hash_smoke.sh
SLAKE_NATIVE_BUILD_SMOKE_STRICT=1 ./tests/slake/native_build_smoke.sh
SLAKE_NATIVE_OLEAN_DEPS_HASH_SMOKE_STRICT=1 ./tests/slake/native_olean_deps_hash_smoke.sh
SLAKE_NATIVE_OLEAN_PARALLEL_SMOKE_STRICT=1 ./tests/slake/native_olean_parallel_smoke.sh
SLAKE_NATIVE_LINK_SMOKE_STRICT=1 ./tests/slake/native_link_smoke.sh
SLAKE_NATIVE_GRAPH_SMOKE_STRICT=1 ./tests/slake/native_graph_smoke.sh
SLAKE_NATIVE_SEAL_SMOKE_STRICT=1 ./tests/slake/native_seal_smoke.sh
SLAKE_NATIVE_PATHDEP_GRAPH_SEAL_SMOKE_STRICT=1 ./tests/slake/native_pathdep_graph_seal_smoke.sh
SLAKE_NATIVE_OBJ_GRAPH_SEAL_SMOKE_STRICT=1 ./tests/slake/native_obj_graph_seal_smoke.sh
SLAKE_NATIVE_C_GRAPH_SEAL_SMOKE_STRICT=1 ./tests/slake/native_c_graph_seal_smoke.sh
SLAKE_NATIVE_C_SMOKE_STRICT=1 ./tests/slake/native_c_smoke.sh
SLAKE_NATIVE_OBJ_SMOKE_STRICT=1 ./tests/slake/native_obj_smoke.sh

# A16 per-lib roots + srcDir (no defaultTargets; plan Alpha Beta under lib/):
SLAKE_ROOTS_PLAN_SMOKE_STRICT=1 ./tests/slake/roots_plan_smoke.sh

# A18 multi-line roots / defaultTargets (plan Alpha Beta under lib/):
SLAKE_MULTILINE_ROOTS_PLAN_SMOKE_STRICT=1 ./tests/slake/multiline_roots_plan_smoke.sh

# A24/A25 per-lib globs recursive multi-level (Core.* → Core Core.Extra Core.Nested.Deep under lib/):
SLAKE_GLOBS_PLAN_SMOKE_STRICT=1 ./tests/slake/globs_plan_smoke.sh
```

**Honesty:** `./script/systems-validate.sh` SCORE does **not** run `run_parity.sh`,
`depgraph_cli_smoke.sh`, `plan_only_smoke.sh`, `systems_plan_smoke.sh`,
`import_dag_smoke.sh`, `srcdir_plan_smoke.sh`, `native_check_smoke.sh`,
`native_olean_smoke.sh`, `native_olean_cache_smoke.sh`,
`native_olean_hash_smoke.sh`, `native_build_smoke.sh`,
`native_olean_deps_hash_smoke.sh`, `native_olean_parallel_smoke.sh`, or
`native_link_smoke.sh` / `native_graph_smoke.sh` / `native_seal_smoke.sh` /
`roots_plan_smoke.sh` / `multiline_roots_plan_smoke.sh` / `globs_plan_smoke.sh`. Green SCORE proves product residual gates, not classic
Slake DepGraph / PLAN_ONLY / import-scan / srcDir / per-lib roots (A16) / multi-line arrays (A18) / per-lib globs recursive multi-level (A24/A25) / NATIVE_CHECK / NATIVE_OLEAN /
A9–A15 cache / NATIVE_BUILD / JOBS / NATIVE_C / NATIVE_OBJ / NATIVE_IRLINK / NATIVE_AR / NATIVE_EXE / NATIVE_LINK / NATIVE_GRAPH / NATIVE_SEAL wiring.


Detection paths the parity script accepts:

1. `slake` on `PATH`
2. `$SLAKE_BIN` absolute path to the executable
3. stage1-adjacent `build/release/stage1/bin/slake` if present
4. `tests/slake/parity/slake` drop-in

## Docs

- Design + API parity checklist: [`doc/dev/slake.md`](../../doc/dev/slake.md)
- Systems Lean: [`doc/dev/systems-lean.md`](../../doc/dev/systems-lean.md)
- Parity harness sketch: [`tests/slake/README.md`](../../tests/slake/README.md)

## Phases (gates only)

See `doc/dev/slake.md`. Phase 0 = design + checklist + harness sketch. Phase 1 = freestanding cores. Phase 2 = MVP CLI + classic-host binary + lake-delegate `build` (**this**) + freestanding self-host of product still growing.

## Argv forward residual (W85–W120)

W114: freestanding FS_PROC/PIPE also cover `resolve-deps` (outside CLAIMED; rest plumbed — **not** empty-rest-only; empty child env; **chdir(pkg)**; **resolveLakeAbs pre-chdir**; dual residual classic IO.Process vs optional FS_PROC/PIPE). W113: freestanding FS_PROC/PIPE also cover `query-kind` (outside CLAIMED; rest plumbed — **not** empty-rest-only; empty child env; **chdir(pkg)**; **resolveLakeAbs pre-chdir**; dual residual classic IO.Process vs optional FS_PROC/PIPE). W112: freestanding FS_PROC/PIPE also cover `exec` (outside CLAIMED; rest plumbed — **not** empty-rest-only; empty child env; **chdir(pkg)**; **resolveLakeAbs pre-chdir**; dual residual classic IO.Process vs optional FS_PROC/PIPE). W99: freestanding FS_PROC/PIPE also cover `upload` (outside CLAIMED; rest plumbed — **not** empty-rest-only; empty child env; **chdir(pkg)**; **resolveLakeAbs pre-chdir**; rest may rebind Lake globals; dual residual classic IO.Process vs optional FS_PROC/PIPE). W98: freestanding FS_PROC/PIPE also cover `serve` (outside CLAIMED; rest plumbed — **not** empty-rest-only; empty child env; **chdir(pkg)**; **resolveLakeAbs pre-chdir**; rest may rebind Lake globals; dual residual classic IO.Process vs optional FS_PROC/PIPE). W97: freestanding FS_PROC/PIPE also cover `shake` (outside CLAIMED; rest plumbed — **not** empty-rest-only; empty child env; **chdir(pkg)**; **resolveLakeAbs pre-chdir**; rest may rebind Lake globals). W96: freestanding FS_PROC/PIPE also cover `query` (outside CLAIMED; rest plumbed — **not** empty-rest-only; empty child env; **chdir(pkg)**; **resolveLakeAbs pre-chdir**; rest may rebind Lake globals). W95: freestanding FS_PROC/PIPE also cover `unpack` (outside CLAIMED; rest plumbed; not empty-rest-only; chdir pkg; absolute lake pre-chdir). W94: freestanding FS_PROC/PIPE also cover `cache` (outside CLAIMED; rest plumbed; not empty-rest-only; chdir pkg; absolute lake pre-chdir). W93: freestanding FS_PROC/PIPE also cover `pack` (outside CLAIMED; rest plumbed; not empty-rest-only; chdir pkg). W92: freestanding FS_PROC/PIPE also cover `update` (outside CLAIMED; rest plumbed; not empty-rest-only). W91: freestanding FS_PROC/PIPE also cover `clean` (CLAIMED dual residual; **empty-rest-only** on native and FS_PROC/PIPE so Lake globals cannot rebind wipe; native = wipe `pkg/.lake/build` only; FS_PROC/PIPE = `lake clean` Lake semantics; same empty child env). W90: freestanding FS_PROC/PIPE also cover `script` (same empty child env as build/test/exe/lint). W89: freestanding FS_PROC/PIPE also cover `lint` (same empty child env as build/test/exe). W88: freestanding FS_PROC/PIPE also cover `exe` (same empty child env as build/test). W87 freestanding test retained. W86 freestanding build rest retained. Classic IO.Process rest plumbing from W85 retained. CLAIMED stays `(build clean env)`. Dual residual honesty: classic IO.Process vs optional FS_PROC (clean: native wipe vs lake clean; pack/cache/unpack/query/shake/serve: classic `cwd=pkg` vs FS_PROC/PIPE chdir(pkg) + empty child env).
W115: freestanding FS_PROC/PIPE also cover `reservoir-config` (outside CLAIMED; rest plumbed — **not** empty-rest-only; empty child env; **chdir(pkg)**; **resolveLakeAbs pre-chdir**; dual residual classic IO.Process vs optional FS_PROC/PIPE; CLAIMED stays `(build clean env)`).
W116: freestanding FS_PROC/PIPE also cover `upgrade` (outside CLAIMED; rest plumbed — **not** empty-rest-only; empty child env; **chdir(pkg)**; **resolveLakeAbs pre-chdir**; dual residual classic IO.Process vs optional FS_PROC/PIPE; CLAIMED stays `(build clean env)`; classic-only FS_PROC queue empty).
W117: no new FS_PROC Lake command — classic-only FS_PROC void for wired Lake cmds remains **empty**; CLAIMED stays `(build clean env)` (harness/parity residual only).
W118: no new FS_PROC Lake command — classic-only FS_PROC void for wired Lake cmds remains **empty**; CLAIMED stays `(build clean env)` (harness/parity residual only; no new `slake_fs_run_lake_*`).
W119: no new FS_PROC Lake command — classic-only FS_PROC void for wired Lake cmds remains **empty**; CLAIMED stays `(build clean env)` (harness/parity residual only; no new `slake_fs_run_lake_*`).
W120: no new FS_PROC Lake command — classic-only FS_PROC void for wired Lake cmds remains **empty**; CLAIMED stays `(build clean env)` (harness/parity residual only; no new `slake_fs_run_lake_*`).


## W114 resolve-deps dual residual

Optional `SLAKE_USE_FS_PROC=1` / `SLAKE_USE_FS_PROC_PIPE=1` freestanding multi-arg/pipe for `resolve-deps` (outside CLAIMED; rest plumbed — **not** empty-rest-only; empty child env; STRICT no IO.Process fall-back; non-STRICT may fall back to classic `cwd=pkg` + host env). Driver **chdir(pkg)** around FS_PROC spawn so relative path args match classic `IO.Process` `cwd=pkg`. Lake binary is resolved to a **true absolute** path **before** chdir (BUG-1; relative `$LAKE` / PATH hits joined to pre-chdir cwd). Rest may rebind Lake globals (`--dir`/`-d`/etc.). CLAIMED remains `(build clean env)`. Classic-only remain after W114: `reservoir-config` / `upgrade` (W115 dual-paths reservoir-config; W116 dual-paths upgrade → queue empty).

## W115 reservoir-config dual residual

Optional `SLAKE_USE_FS_PROC=1` / `SLAKE_USE_FS_PROC_PIPE=1` freestanding multi-arg/pipe for `reservoir-config` (outside CLAIMED; rest plumbed — **not** empty-rest-only; empty child env; **chdir(pkg)**; **resolveLakeAbs pre-chdir**; dual residual classic IO.Process vs optional FS_PROC/PIPE; CLAIMED stays `(build clean env)`). Classic-only remaining at W115 ship: **`upgrade` only** (superseded by W116).

## W116 upgrade dual residual

Optional `SLAKE_USE_FS_PROC=1` / `SLAKE_USE_FS_PROC_PIPE=1` freestanding multi-arg/pipe for `upgrade` (outside CLAIMED; rest plumbed — **not** empty-rest-only; empty child env; **chdir(pkg)**; **resolveLakeAbs pre-chdir**; dual residual classic IO.Process vs optional FS_PROC/PIPE; CLAIMED stays `(build clean env)`). Classic-only FS_PROC queue for wired Lake cmds is **empty** after this wave (CLAIMED residual only). Lake alias of `update` — FS_PROC dual residual is on both `update` (W92) and `upgrade` (W116).

## W117 Slake_parity_more honesty (CLAIMED residual only)

**No new dual residual Lake command this wave.** Classic-only FS_PROC void for wired Lake cmds remains **empty** after W116 upgrade. CLAIMED stays `(build clean env)`. `Slake_parity_more` residual is harness/parity work only — do not invent new `slake_fs_run_lake_*` FS_PROC wiring. Dual residual honesty unchanged: freestanding product cores `PRODUCT_GC_FREE=1`; classic host elaborator `GC_FREE_ELABORATOR=0` (classic_RC_shared).

## W118 Slake_parity_more honesty (CLAIMED residual only)

**No new dual residual Lake command this wave.** Classic-only FS_PROC void for wired Lake cmds remains **empty** after W116 upgrade (same CLAIMED residual honesty as W117). CLAIMED stays `(build clean env)`. `Slake_parity_more` residual is harness/parity work only — do not invent new `slake_fs_run_lake_*` FS_PROC wiring. Dual residual honesty unchanged: freestanding product cores `PRODUCT_GC_FREE=1`; classic host elaborator `GC_FREE_ELABORATOR=0` (classic_RC_shared). See also [`doc/dev/slake.md`](../../doc/dev/slake.md) checklist row **W118**.

## W119 Slake_parity_more honesty (CLAIMED residual only)

**No new dual residual Lake command this wave.** Classic-only FS_PROC void for wired Lake cmds remains **empty** after W116 upgrade (same CLAIMED residual honesty as W117–W118). CLAIMED stays `(build clean env)`. `Slake_parity_more` residual is harness/parity work only — do not invent new `slake_fs_run_lake_*` FS_PROC wiring. Dual residual honesty unchanged: freestanding product cores `PRODUCT_GC_FREE=1`; classic host elaborator `GC_FREE_ELABORATOR=0` (classic_RC_shared). See also [`doc/dev/slake.md`](../../doc/dev/slake.md) checklist row **W119**.

## W120 Slake_parity_more honesty (CLAIMED residual only)

**No new dual residual Lake command this wave.** Classic-only FS_PROC void for wired Lake cmds remains **empty** after W116 upgrade (same CLAIMED residual honesty as W117–W119). CLAIMED stays `(build clean env)`. `Slake_parity_more` residual is harness/parity work only — do not invent new `slake_fs_run_lake_*` FS_PROC wiring. Dual residual honesty unchanged: freestanding product cores `PRODUCT_GC_FREE=1`; classic host elaborator `GC_FREE_ELABORATOR=0` (classic_RC_shared). See also [`doc/dev/slake.md`](../../doc/dev/slake.md) checklist row **W120**.

## W113 query-kind dual residual

Optional `SLAKE_USE_FS_PROC=1` / `SLAKE_USE_FS_PROC_PIPE=1` freestanding multi-arg/pipe for `query-kind` (outside CLAIMED; rest plumbed — **not** empty-rest-only; empty child env; STRICT no IO.Process fall-back; non-STRICT may fall back to classic `cwd=pkg` + host env). Driver **chdir(pkg)** around FS_PROC spawn so relative path args match classic `IO.Process` `cwd=pkg`. Lake binary is resolved to a **true absolute** path **before** chdir (BUG-1; relative `$LAKE` / PATH hits joined to pre-chdir cwd). Rest may rebind Lake globals (`--dir`/`-d`/etc.). CLAIMED remains `(build clean env)`. Classic-only remain after W113: `resolve-deps` / `reservoir-config` / `upgrade` (W114 dual-paths `resolve-deps`).

## W98 serve dual residual

Optional `SLAKE_USE_FS_PROC=1` / `SLAKE_USE_FS_PROC_PIPE=1` freestanding multi-arg/pipe for `serve` (outside CLAIMED; rest plumbed — **not** empty-rest-only; empty child env; STRICT no IO.Process fall-back; non-STRICT may fall back to classic `cwd=pkg` + host env). Driver **chdir(pkg)** around FS_PROC spawn so relative path args match classic `IO.Process` `cwd=pkg`. Lake binary is resolved to a **true absolute** path **before** chdir (BUG-1; relative `$LAKE` / PATH hits joined to pre-chdir cwd). Rest may rebind Lake globals (`--dir`/`-d`/etc.). CLAIMED remains `(build clean env)`.

## W99 upload dual residual

Optional `SLAKE_USE_FS_PROC=1` / `SLAKE_USE_FS_PROC_PIPE=1` freestanding multi-arg/pipe for `upload` (outside CLAIMED; rest plumbed — **not** empty-rest-only; empty child env; STRICT no IO.Process fall-back; non-STRICT may fall back to classic `cwd=pkg` + host env). Driver **chdir(pkg)** around FS_PROC spawn so relative path args match classic `IO.Process` `cwd=pkg`. Lake binary is resolved to a **true absolute** path **before** chdir (BUG-1; relative `$LAKE` / PATH hits joined to pre-chdir cwd). Rest may rebind Lake globals (`--dir`/`-d`/etc.). CLAIMED remains `(build clean env)`.


## W97 shake dual residual

Optional `SLAKE_USE_FS_PROC=1` / `SLAKE_USE_FS_PROC_PIPE=1` freestanding multi-arg/pipe for `shake` (outside CLAIMED; rest plumbed — **not** empty-rest-only; empty child env; STRICT no IO.Process fall-back; non-STRICT may fall back to classic `cwd=pkg` + host env). Driver **chdir(pkg)** around FS_PROC spawn so relative path args match classic. Lake absolutized **before** chdir (BUG-1). CLAIMED remains `(build clean env)`.

## W96 query dual residual

Optional `SLAKE_USE_FS_PROC=1` / `SLAKE_USE_FS_PROC_PIPE=1` freestanding multi-arg/pipe for `query` (outside CLAIMED; rest plumbed — **not** empty-rest-only; empty child env; STRICT no IO.Process fall-back; non-STRICT may fall back to classic `cwd=pkg` + host env). Driver **chdir(pkg)** around FS_PROC spawn so relative path args match classic. Lake absolutized **before** chdir (BUG-1). CLAIMED remains `(build clean env)`.

## W93 pack dual residual

Optional `SLAKE_USE_FS_PROC=1` / `SLAKE_USE_FS_PROC_PIPE=1` freestanding multi-arg/pipe for `pack` (outside CLAIMED; rest plumbed — **not** empty-rest-only; empty child env; STRICT no IO.Process fall-back; non-STRICT may fall back to classic `cwd=pkg` + host env). Driver **chdir(pkg)** around FS_PROC spawn so relative archive paths match classic `IO.Process` `cwd=pkg`. Bare pack may exit nonzero without prior build artifacts — true freestanding green still requires Systems.Proc banners and no fall-back. CLAIMED remains `(build clean env)`.


## W95 unpack dual residual

Optional `SLAKE_USE_FS_PROC=1` / `SLAKE_USE_FS_PROC_PIPE=1` freestanding multi-arg/pipe for `unpack` (outside CLAIMED; rest plumbed — **not** empty-rest-only; empty child env; STRICT no IO.Process fall-back; non-STRICT may fall back to classic `cwd=pkg` + host env). Driver **chdir(pkg)** around FS_PROC spawn so relative path args match classic `IO.Process` `cwd=pkg`. Lake binary is resolved to a **true absolute** path **before** chdir (BUG-1; relative `$LAKE` / PATH hits joined to pre-chdir cwd). CLAIMED remains `(build clean env)`.

## W94 cache dual residual

Optional `SLAKE_USE_FS_PROC=1` / `SLAKE_USE_FS_PROC_PIPE=1` freestanding multi-arg/pipe for `cache` (outside CLAIMED; rest plumbed — **not** empty-rest-only; empty child env; STRICT no IO.Process fall-back; non-STRICT may fall back to classic `cwd=pkg` + host env). Driver **chdir(pkg)** around FS_PROC spawn so relative path args match classic `IO.Process` `cwd=pkg`. Lake binary is resolved to a **true absolute** path **before** chdir (BUG-1; relative `$LAKE` / PATH hits joined to pre-chdir cwd). CLAIMED remains `(build clean env)`.
