/-
Copyright (c) 2026 Hunter Beast. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Hunter Beast
-/
module

import Slake.Config

/-!
# Slake.CLI

Phase-2 **MVP command surface** for the Systems Lean twin of Lake.

This module is **classic Lean** host-side driver glue under `src/slake/`.
It is **not** freestanding product TCB and is **not** residual-green product
itself. Freestanding residual-green cores remain under `src/Systems/`
(`DepGraph`, `TomlConfig`, `Trace`, `CacheIndex`, `Proc`, …).

MVP commands (classic host driver — **not** full Lake parity):

* `build` — delegate to `lake build` in the package dir via `IO.Process` by
  default; with `SLAKE_USE_FS_PROC=1`, use freestanding `Systems.Proc` multi-arg
  spawn via the linked `slake_fs_proc` shim + extract bundle (Option C). With
  `SLAKE_USE_FS_PROC_PIPE=1`, use freestanding pipe/stdio spawn (stdout capture
  demo). Fall back to `IO.Process` if freestanding spawn fails (unless
  `SLAKE_FS_PROC_STRICT=1`). With `SLAKE_DEPGRAPH=1`, print a package-derived
  freestanding `DepGraph` Kahn topo plan (Config scan nodes + import-scan DAG
  when package-local import edges exist after srcDir/dotted path resolution,
  else declaration-order chain) before the lake delegate. With
  `SLAKE_PLAN_ONLY=1`, print the plan and **skip** lake (exit 0; dry-run / CI
  plan path — real reduction of pure lake cosplay). With `SLAKE_NATIVE_CHECK=1`
  (implies plan print), after the plan run a **thin sequential host-lean
  typecheck** of plan module nodes via classic `IO.Process` → `lean <file>`
  (LEAN env or PATH; LEAN_PATH includes package root + optional srcDir). Not
  freestanding build TCB / not olean orchestration / not CLAIMED. Combined with
  PLAN_ONLY still skips lake; without PLAN_ONLY lake follows after native check.
  With `SLAKE_NATIVE_OLEAN=1` (implies plan print), after the plan compile plan
  modules with host lean writing oleans into package-local `.slake-native/` and
  feed that dir on LEAN_PATH so later modules can import earlier ones (default
  multi-module **sequential** honesty; A9 mtime + plan-edge cascade skip when
  fresh; A10 FNV-1a 64 **source content-hash sidecar** subset — touch-without-edit
  skips when hash matches even if mtime is newer; A11 **plan-node transitive
  deps-hash** — live plan-import dep hash-fresh gate + optional frozen `deps
  <hex>` sidecar line; A12 optional `SLAKE_NATIVE_OLEAN_JOBS=N` ready-set
  **parallel** host-lean olean waves when N≥2 — not freestanding build TCB / not
  Lake job server TCB / not CLAIMED / not shared-lib link; A26 path `[[require]]`
  LEAN_PATH + path-dep olean precompile; **A27** path-dep → root cascade
  (`path-dep-olean-newer` on consumer imports of path-dep plan modules after
  precompile); **A28** path-dep source-hash fold into A11 frozen `deps <hex>`
  (consumer imports of path-dep plan modules — not Lake package-transitive hash);
  **A30** package-transitive plan subset (import-driven path-dep plan modules folded
  into root plan when imported — not Lake resolve-deps / not every dep module);
  `SLAKE_NATIVE_OLEAN_FORCE=1`
  rebuilds all; not freestanding build TCB / not lake-equivalent TCB / not CLAIMED /
  not full olean graph invalidation / not Lake shake/hash TCB / not Lake
  package-transitive hash).
  With `SLAKE_NATIVE_BUILD=1` (implies plan +
  NATIVE_OLEAN), after successful olean compile **skip lake** (exit 0) —
  freestanding-adjacent native olean build subset (fail-closed on compile
  failure; JOBS applies; not freestanding build TCB / not Lake TCB / not CLAIMED).
  With `SLAKE_NATIVE_LINK=1` (implies plan + NATIVE_OLEAN), after successful
  olean compile run a **host shared-lib link subset**: generate
  `.slake-native/slake_native_export.c` exporting `slake_native_plan_modules`
  (topo plan module names) and compile with host `cc -shared -fPIC` into
  `.slake-native/libslake_native.so` (`CC` env or `cc` on PATH). **Not** Lake
  lean_lib shared-object of compiled Lean IR / **not** freestanding build TCB /
  **not** Lake shared-lib TCB / **not** CLAIMED. Missing `cc` soft-skips unless
  `SLAKE_NATIVE_LINK_STRICT=1` or combined with `SLAKE_NATIVE_BUILD=1` (then
  skip-lake requires link success). JOBS applies to olean waves only; link is
  sequential single host cc. With `SLAKE_NATIVE_C=1` (implies plan + NATIVE_OLEAN),
  after successful olean compile run **host lean C-output emit subset**: for each
  plan module (skip package name) spawn host
  `lean -c <pkg>/.slake-native/<ModRel>.c <file>` with the same LEAN_PATH as olean
  (`.slake-native` first, then pkg [+ srcDir]); nested modules → `Foo/Bar.c`.
  **Not** freestanding build TCB / **not** Lake lean_lib shared-object of compiled
  Lean IR / **not** full object compile+link of Lean runtime / **not** CLAIMED.
  Missing lean / missing source soft-skips unless `SLAKE_NATIVE_C_STRICT=1` or
  combined with `SLAKE_NATIVE_BUILD=1` (then skip-lake requires C emit success).
  Nonzero lean → exit nonzero. With `SLAKE_NATIVE_OBJ=1` (implies plan +
  NATIVE_OLEAN + NATIVE_C), after successful C emit run **host object compile of
  lean C subset**: for each plan module (skip package name) spawn host
  `cc -c -fPIC -I<leanInclude> -o .slake-native/<ModRel>.o .slake-native/<ModRel>.c`
  with `cwd=pkg`; nested modules → `Foo/Bar.o`. Include via `LEAN_INCLUDE` /
  `LEAN_SYSROOT`/`LEAN_PREFIX`+`/include` / `lean --print-prefix`+`/include`.
  **Not** freestanding build TCB / **not** Lake lean_lib SO of compiled Lean IR /
  **not** linking Lean runtime into SO / **not** CLAIMED. Missing cc / include /
  C input soft-skips unless `SLAKE_NATIVE_OBJ_STRICT=1` or NATIVE_BUILD
  (skip-lake requires object compile success). Nonzero cc → exit nonzero. With
  `SLAKE_NATIVE_IRLINK=1` (implies plan + NATIVE_OLEAN + NATIVE_C + NATIVE_OBJ),
  after successful object compile run **host leanc IR shared-lib link subset**:
  collect non-empty plan-module `.slake-native/<ModRel>.o` and spawn host
  `leanc -shared -o .slake-native/libslake_ir.so <objs…>` (`LEANC` or `leanc` on
  PATH). **Not** freestanding build TCB / **not** Lake lean_lib shared-object TCB /
  **not** CLAIMED / **not** full Lake shared facet. **A31:** A30-folded path-dep
  plan modules also emit C/OBJ under `dep/.slake-native/` and those `.o` feed
  IRLINK/AR/EXE (topo order; freestanding-adjacent path-dep plan-module C/OBJ into
  IR products subset — not every dep plan module / not git/url / not Lake lean_lib
  shared facet). A13 name-table SO remains separate (`libslake_native.so`). Missing
  leanc / zero objs soft-skips unless `SLAKE_NATIVE_IRLINK_STRICT=1` or NATIVE_BUILD
  (skip-lake requires IR link success). Nonzero leanc → exit nonzero. With
  `SLAKE_NATIVE_AR=1` (implies plan +
  NATIVE_OLEAN + NATIVE_C + NATIVE_OBJ; does **not** imply IRLINK), after object
  compile (and after IRLINK when both set) run **host static archive of
  plan-module objects subset**: collect non-empty plan-module `.o` and spawn host
  `ar rcs .slake-native/libslake_ir.a <objs…>` (`AR` or `ar` on PATH). **Not**
  freestanding build TCB / **not** Lake lean_lib static/shared facet / **not**
  CLAIMED / **not** linking Lean runtime into the archive (plain `ar` of module
  `.o` only; A21 leanc still pulls runtime into SO). Missing ar / zero objs
  soft-skips unless `SLAKE_NATIVE_AR_STRICT=1` or NATIVE_BUILD (skip-lake requires
  archive success). Nonzero ar → exit nonzero. With `SLAKE_NATIVE_EXE=1` (implies
  plan + NATIVE_OLEAN + NATIVE_C + NATIVE_OBJ; does **not** imply IRLINK or AR),
  after object compile (and after IRLINK / AR when set; before A13 NATIVE_LINK)
  run **host leanc executable link subset**: write package-local
  `.slake-native/slake_native_main.c` (generated stub `main` that returns 0 — not
  a Lake lean_exe root / not freestanding app TCB) and spawn host
  `leanc -o .slake-native/slake_ir .slake-native/slake_native_main.c <objs…>`
  (`LEANC` or `leanc` on PATH; same resolve as A21). **Not** freestanding build TCB /
  **not** Lake lean_exe / **not** Lake lean_lib shared facet / **not** CLAIMED /
  **not** a real application entry from lakefile. Missing leanc / zero objs
  soft-skips unless `SLAKE_NATIVE_EXE_STRICT=1` or NATIVE_BUILD (skip-lake requires
  executable link success). Nonzero leanc → exit nonzero. With `SLAKE_NATIVE_GRAPH=1` (implies
  plan + NATIVE_OLEAN), after oleans (and after NATIVE_C / NATIVE_OBJ /
  NATIVE_IRLINK / NATIVE_AR / NATIVE_EXE / NATIVE_LINK when set) write package-local
  `.slake-native/slake_native_graph` — **host package link graph subset** (plan
  modules with oleans + A5 import edges + optional `shared_lib` when
  `libslake_native.so` exists + optional `shared_lib_ir` when `libslake_ir.so`
  exists + optional `static_lib` when `libslake_ir.a` exists + optional
  `executable` when `slake_ir` exists). **A32:** A30-folded path-dep plan modules
  appear as module lines with **package-cwd-relative** olean paths
  (`dep/.slake-native/…`, A29 sibling `../dep/.slake-native/…`). **A35:** when
  plan-module `.c` files exist (root or A30-folded path-dep), list distinct
  `c_source <Mod> <package-cwd-relative path>` lines (soft-omit missing `.c`).
  **A34:** when
  plan-module `.o` files exist (root or A30-folded path-dep), list distinct
  `object <Mod> <package-cwd-relative path>` lines (soft-omit missing `.o`).
  **Not** freestanding
  build TCB / **not** Lake build graph TCB / **not** Lake lean_lib SO / **not**
  CLAIMED / **not** Lake resolve-deps / **not** every dep plan module. Graph write
  IO failure always fail-closed; empty modules fail-closed under
  `SLAKE_NATIVE_GRAPH_STRICT=1` or NATIVE_BUILD. With `SLAKE_NATIVE_SEAL=1`
  (implies plan + NATIVE_OLEAN), after oleans (and after NATIVE_C / NATIVE_OBJ /
  NATIVE_IRLINK / NATIVE_AR / NATIVE_EXE / NATIVE_LINK / NATIVE_GRAPH when set) write
  package-local `.slake-native/slake_native_seal` — **host freestanding-adjacent
  product seal subset** (module olean_hash from sidecar/source FNV-1a 64 +
  optional graph_hash + optional shared_lib + optional shared_lib_ir + optional
  static_lib + optional executable + seal digest). **A32:** A30-folded path-dep
  plan modules contribute olean_hash from path-dep sidecar or source. **A35:**
  optional `module <Mod> c_hash <16-hex>` (FNV-1a 64 of C file bytes) when
  plan-module `.c` exists (soft-omit missing; do not fail seal solely for zero
  C sources). **A34:**
  optional `module <Mod> obj_hash <16-hex>` (FNV-1a 64 of object file bytes) when
  plan-module `.o` exists (soft-omit missing; do not fail seal solely for zero
  objects). **Not**
  freestanding build TCB / **not** Lake lean_lib SO / **not** Lake build graph TCB /
  **not** CLAIMED / **not** Lake resolve-deps / **not** every dep plan module. Seal
  write IO failure always
  fail-closed; empty modules / cannot hash fail-closed under
  `SLAKE_NATIVE_SEAL_STRICT=1` or NATIVE_BUILD. Order: olean → C emit → obj → IR
  link → static archive → executable link → name-table link → graph → seal. PLAN_ONLY remains dry-run
  plan(+optional check/olean/c-emit/obj/irlink/ar/exe/link/graph/seal).
* `clean` — dual residual (CLAIMED token; A17 + A33 semantic growth of wipe set):
  - **native (default):** wipe package `.lake/build` **and** package-local `.slake-native/` when
    present, then each path-require package’s `.slake-native/` (A26 under-pkg / A29 sibling
    confining; identity order; soft missing OK) (not bare `build/`; not full Lake clean; not
    dep `.lake/build`; not git/url). Non-empty rest is **refused** (native cannot rebind
    package / has no Lake globals). Symlink fence on `.lake` / `.lake/build` and on
    `.slake-native` (root + path-require deps; best-effort `lstat`; TOCTOU residual).
  - **FS_PROC / PIPE:** optional `SLAKE_USE_FS_PROC=1` / `SLAKE_USE_FS_PROC_PIPE=1` delegates to
    `lake clean` (Lake’s clean semantics — may wipe more than `.lake/build`), then always
    performs the same native wipe of root + path-require `.slake-native/` so freestanding-
    adjacent products do not leak after dual residual clean. **Empty rest only** so Lake
    globals (`--dir`/`-d`/`--file`/…) cannot redirect the wipe. Empty child env; STRICT
    refuses fall-back to native on unlinked/spawn fail (native wipe is still the non-STRICT
    fall-back).
* `test` — CLAIMED token (partial semantics: exit 0 via `lake test` delegate; not freestanding
  TCB). Default classic `IO.Process` → `lake test`; optional `SLAKE_USE_FS_PROC=1` /
  `SLAKE_USE_FS_PROC_PIPE=1` freestanding multi-arg / pipe (W87; empty child env; residual
  honesty dual path). Rest argv plumbed like build.
* `script` — default classic `IO.Process` → `lake script`; optional `SLAKE_USE_FS_PROC=1` /
  `SLAKE_USE_FS_PROC_PIPE=1` freestanding multi-arg / pipe (W90; empty child env; not
  CLAIMED; residual honesty dual path). Rest argv plumbed like build/test/exe/lint
* `exe` — default classic `IO.Process` → `lake exe`; optional `SLAKE_USE_FS_PROC=1` /
  `SLAKE_USE_FS_PROC_PIPE=1` freestanding multi-arg / pipe (W88; empty child env; not
  CLAIMED; residual honesty dual path). Rest argv plumbed like build/test
* `lint` — default classic `IO.Process` → `lake lint`; optional `SLAKE_USE_FS_PROC=1` /
  `SLAKE_USE_FS_PROC_PIPE=1` freestanding multi-arg / pipe (W89; empty child env; not
  CLAIMED; residual honesty dual path). Rest argv plumbed like build/test/exe
* `check-build` — default classic `IO.Process` → `lake check-build`; optional `SLAKE_USE_FS_PROC=1` /
  `SLAKE_USE_FS_PROC_PIPE=1` freestanding dual residual (W109; outside
  CLAIMED; empty child env; rest plumbed — **not** empty-rest-only;
  **chdir(pkg)** + **resolveLakeAbs pre-chdir**)
  (W73 parity growth; same `IO.Process` path as `test`; **not** in default CLAIMED
  parity slice; residual honesty; Lake has no bare `check`)
* `check-test` — default classic `IO.Process` → `lake check-test`; optional `SLAKE_USE_FS_PROC=1` /
  `SLAKE_USE_FS_PROC_PIPE=1` freestanding dual residual (W110; outside
  CLAIMED; rest plumbed — **not** empty-rest-only; empty child env;
  **chdir(pkg)** + **resolveLakeAbs pre-chdir**).
* `check-lint` — default classic `IO.Process` → `lake check-lint`; optional `SLAKE_USE_FS_PROC=1` /
  `SLAKE_USE_FS_PROC_PIPE=1` freestanding dual residual (W111; outside
  CLAIMED; rest plumbed — **not** empty-rest-only; empty child env;
  **chdir(pkg)** + **resolveLakeAbs pre-chdir**).

* `query` — default classic `IO.Process` → `lake query`; optional `SLAKE_USE_FS_PROC=1` /
  `SLAKE_USE_FS_PROC_PIPE=1` freestanding multi-arg/pipe (W96; outside
  CLAIMED; residual honesty dual path). Rest argv plumbed like pack/cache/unpack (**not** empty-rest-only).
  FS_PROC chdir(pkg) for relative path parity with classic cwd=pkg.
* `shake` — default classic `IO.Process` → `lake shake`; optional `SLAKE_USE_FS_PROC=1` /
  `SLAKE_USE_FS_PROC_PIPE=1` freestanding multi-arg/pipe (W97; outside
  CLAIMED; residual honesty dual path). Rest argv plumbed like pack/cache/unpack/query (**not** empty-rest-only).
  FS_PROC chdir(pkg) for relative path parity with classic cwd=pkg.
* `update` — default classic `IO.Process` → `lake update`; optional `SLAKE_USE_FS_PROC=1` /
  `SLAKE_USE_FS_PROC_PIPE=1` freestanding multi-arg / pipe (W92; empty child env; not
  CLAIMED; residual honesty dual path). Rest argv plumbed like build/test/exe/lint/script
* `pack` — default classic `IO.Process` → `lake pack`; optional `SLAKE_USE_FS_PROC=1` /
  `SLAKE_USE_FS_PROC_PIPE=1` freestanding multi-arg / pipe (W93; empty child env; not
  CLAIMED; residual honesty dual path). Rest argv plumbed like build/test/exe/lint/script/update
  (**not** empty-rest-only — only `clean` is)
* `cache` — default classic `IO.Process` → `lake cache`; optional `SLAKE_USE_FS_PROC=1` /
  `SLAKE_USE_FS_PROC_PIPE=1` freestanding multi-arg / pipe (W94; empty child env; not
  CLAIMED; residual honesty dual path). Rest argv plumbed like pack (**not** empty-rest-only).
  FS_PROC chdir(pkg) for relative path parity with classic cwd=pkg.
* `unpack` — default classic `IO.Process` → `lake unpack`; optional `SLAKE_USE_FS_PROC=1` /
  `SLAKE_USE_FS_PROC_PIPE=1` freestanding multi-arg/pipe (W95; outside
  CLAIMED; residual honesty dual path). Rest argv plumbed like pack/cache (**not** empty-rest-only).
  FS_PROC chdir(pkg) for relative path parity with classic cwd=pkg.
  (W77 parity growth base; **not** in default CLAIMED
  parity slice; residual honesty; real Lake names only)
* `scripts` — default classic `IO.Process` → `lake scripts`; optional `SLAKE_USE_FS_PROC=1` /
  `SLAKE_USE_FS_PROC_PIPE=1` freestanding multi-arg/pipe (W101; outside
  CLAIMED; rest plumbed — **not** empty-rest-only; empty child env;
  FS_PROC chdir(pkg) for relative path parity with classic cwd=pkg; resolveLakeAbs pre-chdir).
* `new` — default classic `IO.Process` → `lake new`; optional `SLAKE_USE_FS_PROC=1` /
  `SLAKE_USE_FS_PROC_PIPE=1` freestanding dual residual (W107; outside
  CLAIMED; rest plumbed — **not** empty-rest-only; empty child env;
  **cwd bootstrap** — no package walk-up; **chdir(cwd)** + **resolveLakeAbs pre-chdir**).
  (W79 classic base + W107 FS_PROC/PIPE dual residual; **not** in default CLAIMED
  parity slice; residual honesty; real Lake names only)
* `init` — default classic `IO.Process` → `lake init`; optional `SLAKE_USE_FS_PROC=1` /
  `SLAKE_USE_FS_PROC_PIPE=1` freestanding dual residual (W108; outside
  CLAIMED; rest plumbed — **not** empty-rest-only; empty child env;
  **cwd bootstrap** — no package walk-up; **chdir(cwd)** + **resolveLakeAbs pre-chdir**).
  (W79 classic base + W108 FS_PROC/PIPE dual residual; **not** in default CLAIMED
  parity slice; residual honesty; real Lake names only)
* `serve` — default classic `IO.Process` → `lake serve`; optional `SLAKE_USE_FS_PROC=1` /
  `SLAKE_USE_FS_PROC_PIPE=1` freestanding multi-arg/pipe (W98; outside
  CLAIMED; residual honesty dual path). Rest argv plumbed like pack/cache/unpack/query/shake (**not** empty-rest-only).
  FS_PROC chdir(pkg) for relative path parity with classic cwd=pkg.
* `lean` — default classic `IO.Process` → `lake lean`; optional `SLAKE_USE_FS_PROC=1` /
  `SLAKE_USE_FS_PROC_PIPE=1` freestanding multi-arg/pipe (W100; outside
  CLAIMED; rest plumbed — **not** empty-rest-only; empty child env;
  FS_PROC chdir(pkg) for relative path parity with classic cwd=pkg; resolveLakeAbs pre-chdir).
* `upload` — default classic `IO.Process` → `lake upload`; optional `SLAKE_USE_FS_PROC=1` /
  `SLAKE_USE_FS_PROC_PIPE=1` freestanding multi-arg/pipe (W99; outside
  CLAIMED; residual honesty dual path). Rest argv plumbed like pack/cache/unpack/query/shake/serve (**not** empty-rest-only).
  FS_PROC chdir(pkg) for relative path parity with classic cwd=pkg; resolveLakeAbs pre-chdir.
* `setup-file` — default classic `IO.Process` → `lake setup-file`; optional `SLAKE_USE_FS_PROC=1` /
  `SLAKE_USE_FS_PROC_PIPE=1` freestanding multi-arg/pipe (W102; outside
  CLAIMED; rest plumbed — **not** empty-rest-only; empty child env;
  FS_PROC chdir(pkg) for relative path parity with classic cwd=pkg; resolveLakeAbs pre-chdir).
* `self-check` — default classic `IO.Process` → `lake self-check`; optional `SLAKE_USE_FS_PROC=1` /
  `SLAKE_USE_FS_PROC_PIPE=1` freestanding dual residual (W103; outside
  CLAIMED; rest plumbed — **not** empty-rest-only; empty child env;
  **chdir(pkg)** + **resolveLakeAbs pre-chdir**).
* `version-tags` — default classic `IO.Process` → `lake version-tags`; optional `SLAKE_USE_FS_PROC=1` /
  `SLAKE_USE_FS_PROC_PIPE=1` freestanding dual residual (W104; outside
  CLAIMED; rest plumbed — **not** empty-rest-only; empty child env;
  **chdir(pkg)** + **resolveLakeAbs pre-chdir**).
  (W82 classic base + W104 FS_PROC/PIPE dual residual; **not** in default CLAIMED
  parity slice; residual honesty; package-root gate; real Lake names only)
* `query-kind` — default classic `IO.Process` → `lake query-kind`; optional `SLAKE_USE_FS_PROC=1` /
  `SLAKE_USE_FS_PROC_PIPE=1` freestanding dual residual (W113; outside
  CLAIMED; rest plumbed — **not** empty-rest-only; empty child env;
  **chdir(pkg)** + **resolveLakeAbs pre-chdir**).
  (W83 classic base + W113 FS_PROC/PIPE dual residual; **not** in default CLAIMED
  parity slice; residual honesty; package-root gate; real Lake names only)
* `resolve-deps` — default classic `IO.Process` → `lake resolve-deps`; optional `SLAKE_USE_FS_PROC=1` /
  `SLAKE_USE_FS_PROC_PIPE=1` freestanding dual residual (W114; outside
  CLAIMED; rest plumbed — **not** empty-rest-only; empty child env;
  **chdir(pkg)** + **resolveLakeAbs pre-chdir**).
  (W83 classic base + W114 FS_PROC/PIPE dual residual; **not** in default CLAIMED
  parity slice; residual honesty; package-root gate; real Lake names only)
* `reservoir-config` — default classic `IO.Process` → `lake reservoir-config`; optional `SLAKE_USE_FS_PROC=1` /
  `SLAKE_USE_FS_PROC_PIPE=1` freestanding dual residual (W115; outside
  CLAIMED; rest plumbed — **not** empty-rest-only; empty child env;
  **chdir(pkg)** + **resolveLakeAbs pre-chdir**).
  (W83 classic base + W115 FS_PROC/PIPE dual residual; **not** in default CLAIMED
  parity slice; residual honesty; package-root gate; real Lake names only)
* `exec` — default classic `IO.Process` → `lake exec`; optional `SLAKE_USE_FS_PROC=1` /
  `SLAKE_USE_FS_PROC_PIPE=1` freestanding dual residual (W112; outside
  CLAIMED; rest plumbed — **not** empty-rest-only; empty child env;
  **chdir(pkg)** + **resolveLakeAbs pre-chdir**). Lake alias of `exe`
  (`exe`|`exec` → `lake.exe`).
* `upgrade` — default classic `IO.Process` → `lake upgrade`; optional `SLAKE_USE_FS_PROC=1` /
  `SLAKE_USE_FS_PROC_PIPE=1` freestanding dual residual (W116; outside
  CLAIMED; rest plumbed — **not** empty-rest-only; empty child env;
  **chdir(pkg)** + **resolveLakeAbs pre-chdir**).
  (W84 classic base + W116 FS_PROC/PIPE dual residual; **not** in default CLAIMED
  parity slice; residual honesty; package-root gate; real Lake alias —
  `update`|`upgrade` → `lake.update`. FS_PROC/PIPE dual residual is also on
  `update` (W92) and now on the `upgrade` alias (W116).)
* **W85 argv plumbing** — classic-host thin forwards pass remaining argv after the
  command token through to `lake` via fixed `IO.Process` args arrays (no shell).
  Covers all package-root / cwd bootstrap IO.Process forwards (`build`/`test`/`exe`/
  `exec`/`run`/`script`/…); freestanding FS_PROC / PIPE build paths plumb remaining
  argv after `build` (W86); W87 also plumbs FS_PROC/PIPE for `test`; W88 also plumbs FS_PROC/PIPE for `exe`; W89 also plumbs FS_PROC/PIPE for `lint`; W90 also plumbs FS_PROC/PIPE for `script`; W91 also covers FS_PROC/PIPE for `clean` (**empty rest only** — security envelope; same empty child env); W92 also plumbs FS_PROC/PIPE for `update` (rest plumbed; **not** empty-rest-only); W93 also plumbs FS_PROC/PIPE for `pack` (rest plumbed; **not** empty-rest-only); W94 also plumbs FS_PROC/PIPE for `cache` (rest plumbed; **not** empty-rest-only; chdir pkg); W95 also plumbs FS_PROC/PIPE for `unpack` (rest plumbed; **not** empty-rest-only; chdir pkg; resolveLakeAbs pre-chdir); W96 also plumbs FS_PROC/PIPE for `query` (rest plumbed; **not** empty-rest-only; chdir pkg; resolveLakeAbs pre-chdir); W97 also plumbs FS_PROC/PIPE for `shake` (rest plumbed; **not** empty-rest-only; chdir pkg; resolveLakeAbs pre-chdir); W98 also plumbs FS_PROC/PIPE for `serve` (rest plumbed; **not** empty-rest-only; chdir pkg; resolveLakeAbs pre-chdir); W99 also plumbs FS_PROC/PIPE for `upload` (rest plumbed; **not** empty-rest-only; chdir pkg; resolveLakeAbs pre-chdir); W100 also plumbs FS_PROC/PIPE for `lean` (rest plumbed; **not** empty-rest-only; chdir pkg; resolveLakeAbs pre-chdir); W101 also plumbs FS_PROC/PIPE for `scripts` (rest plumbed; **not** empty-rest-only; chdir pkg; resolveLakeAbs pre-chdir); W102 also plumbs FS_PROC/PIPE for `setup-file` (rest plumbed; **not** empty-rest-only; chdir pkg; resolveLakeAbs pre-chdir); W103 also plumbs FS_PROC/PIPE for `self-check` (rest plumbed; **not** empty-rest-only; chdir pkg; resolveLakeAbs pre-chdir); W104 also plumbs FS_PROC/PIPE for `version-tags` (rest plumbed; **not** empty-rest-only; chdir pkg; resolveLakeAbs pre-chdir); W105 also plumbs FS_PROC/PIPE for `translate-config` (rest plumbed; **not** empty-rest-only; chdir pkg; resolveLakeAbs pre-chdir); W106 also plumbs FS_PROC/PIPE for `run` (rest plumbed; **not** empty-rest-only; chdir pkg; resolveLakeAbs pre-chdir); W107 also plumbs FS_PROC/PIPE for `new` (rest plumbed; **not** empty-rest-only; **cwd bootstrap** — no package walk-up; chdir(cwd); resolveLakeAbs pre-chdir); W108 also plumbs FS_PROC/PIPE for `init` (rest plumbed; **not** empty-rest-only; **cwd bootstrap** — no package walk-up; chdir(cwd); resolveLakeAbs pre-chdir). W109 also plumbs FS_PROC/PIPE for `check-build` (rest plumbed; **not** empty-rest-only; chdir pkg; resolveLakeAbs pre-chdir). W110 also plumbs FS_PROC/PIPE for `check-test` (rest plumbed; **not** empty-rest-only; chdir pkg; resolveLakeAbs pre-chdir). W111 also plumbs FS_PROC/PIPE for `check-lint` (rest plumbed; **not** empty-rest-only; chdir pkg; resolveLakeAbs pre-chdir). W112 also plumbs FS_PROC/PIPE for `exec` (rest plumbed; **not** empty-rest-only; chdir pkg; resolveLakeAbs pre-chdir). W113 also plumbs FS_PROC/PIPE for `query-kind` (rest plumbed; **not** empty-rest-only; chdir pkg; resolveLakeAbs pre-chdir). W114 also plumbs FS_PROC/PIPE for `resolve-deps` (rest plumbed; **not** empty-rest-only; chdir pkg; resolveLakeAbs pre-chdir). W115 also plumbs FS_PROC/PIPE for `reservoir-config` (rest plumbed; **not** empty-rest-only; chdir pkg; resolveLakeAbs pre-chdir). W116 also plumbs FS_PROC/PIPE for `upgrade` (rest plumbed; **not** empty-rest-only; chdir pkg; resolveLakeAbs pre-chdir).
  CLAIMED is `(build clean env test)` — argv plumbing does not expand CLAIMED semantics beyond that harness slice.
* `translate-config` — default classic `IO.Process` → `lake translate-config`; optional `SLAKE_USE_FS_PROC=1` /
  `SLAKE_USE_FS_PROC_PIPE=1` freestanding dual residual (W105; outside
  CLAIMED; rest plumbed — **not** empty-rest-only; empty child env;
  **chdir(pkg)** + **resolveLakeAbs pre-chdir**).
  (W81 classic base + W105 FS_PROC/PIPE dual residual; **not** in default CLAIMED
  parity slice; residual honesty; package-root gate; real Lake names only)
* `run` — default classic `IO.Process` → `lake run`; optional `SLAKE_USE_FS_PROC=1` /
  `SLAKE_USE_FS_PROC_PIPE=1` freestanding dual residual (W106; outside
  CLAIMED; rest plumbed — **not** empty-rest-only; empty child env;
  **chdir(pkg)** + **resolveLakeAbs pre-chdir**).
  (W81 classic base + W106 FS_PROC/PIPE dual residual; **not** in default CLAIMED
  parity slice; residual honesty; package-root gate; real Lake names —
  `run` is shorthand for `lake script run`)
* `new` — default classic `IO.Process` → `lake new`; optional `SLAKE_USE_FS_PROC=1` /
  `SLAKE_USE_FS_PROC_PIPE=1` freestanding dual residual (W107; outside
  CLAIMED; rest plumbed — **not** empty-rest-only; empty child env;
  **cwd bootstrap** — no package walk-up; **chdir(cwd)** + **resolveLakeAbs pre-chdir**).
  (W79 classic base + W107 FS_PROC/PIPE dual residual; **not** in default CLAIMED
  parity slice; residual honesty; real Lake names only)
* `env` — print cwd, package dir (safe lakefile walk-up), optional `LEAN_PATH`,
  FS_PROC / FS_PROC_PIPE / DEPGRAPH flag/link status
* `--help` / `--version` — usage / version string

**Package discovery:** walk-up accepts the nearest directory with a lakefile that
looks like a real package (`lean-toolchain`, `lake-manifest.json`, any `*.lean`,
or a non-`tests` basename). The monorepo root `tests/lakefile.toml` alone is
**rejected** so `slake clean` from `tests/slake` cannot wipe the wrong tree.
Prefer running from the package root (e.g. `tests/slake/parity/basic_toml`).

Build the runnable binary via `tests/slake/driver` (`lake build` →
`.lake/build/bin/slake`; links freestanding extract + Option C shims
`slake_fs_proc.c` / `slake_fs_depgraph.c` for FS_PROC and DEPGRAPH paths). See
`src/slake/README.md` and `doc/dev/slake.md`.
-/

namespace Slake.CLI

open System

/-- Freestanding multi-arg `lake --dir=<pkg> build [rest…]` via linked extract (`slake_fs_proc.c`).

`rest` is remaining argv after the `build` token (targets/flags). Empty array is
valid. Returns process exit status, or `0xFFFFFFFF` on spawn/arg failure. -/
@[extern "slake_fs_run_lake_build"]
opaque slakeFsRunLakeBuild (pkgDir : @& String) (lakePath : @& String) (rest : @& Array String) : UInt32

/-- Freestanding multi-arg **pipe** `lake --dir=<pkg> build [rest…]` (stdout → parent pipe).

Demo/capture only — not full Lake IO redirect. Returns same status encoding as
`slakeFsRunLakeBuild`. -/
@[extern "slake_fs_run_lake_build_pipe"]
opaque slakeFsRunLakeBuildPipe (pkgDir : @& String) (lakePath : @& String) (rest : @& Array String) : UInt32

/-- Freestanding multi-arg `lake --dir=<pkg> test [rest…]` (W87 FS_PROC test path). -/
@[extern "slake_fs_run_lake_test"]
opaque slakeFsRunLakeTest (pkgDir : @& String) (lakePath : @& String) (rest : @& Array String) : UInt32

/-- Freestanding multi-arg **pipe** `lake --dir=<pkg> test [rest…]` (stdout capture demo). -/
@[extern "slake_fs_run_lake_test_pipe"]
opaque slakeFsRunLakeTestPipe (pkgDir : @& String) (lakePath : @& String) (rest : @& Array String) : UInt32

/-- Freestanding multi-arg `lake --dir=<pkg> exe [rest…]` (W88 FS_PROC exe path). -/
@[extern "slake_fs_run_lake_exe"]
opaque slakeFsRunLakeExe (pkgDir : @& String) (lakePath : @& String) (rest : @& Array String) : UInt32

/-- Freestanding multi-arg **pipe** `lake --dir=<pkg> exe [rest…]` (stdout capture demo). -/
@[extern "slake_fs_run_lake_exe_pipe"]
opaque slakeFsRunLakeExePipe (pkgDir : @& String) (lakePath : @& String) (rest : @& Array String) : UInt32

/-- Option C: freestanding `Systems.Proc` multi-arg spawn for `lake lint` (W89; outside CLAIMED). -/
@[extern "slake_fs_run_lake_lint"]
opaque slakeFsRunLakeLint (pkgDir : @& String) (lakePath : @& String) (rest : @& Array String) : UInt32

/-- Option C: freestanding pipe/stdio spawn for `lake lint` (W89; outside CLAIMED). -/
@[extern "slake_fs_run_lake_lint_pipe"]
opaque slakeFsRunLakeLintPipe (pkgDir : @& String) (lakePath : @& String) (rest : @& Array String) : UInt32

/-- Option C: freestanding `Systems.Proc` multi-arg spawn for `lake script` (W90; outside CLAIMED). -/
@[extern "slake_fs_run_lake_script"]
opaque slakeFsRunLakeScript (pkgDir : @& String) (lakePath : @& String) (rest : @& Array String) : UInt32

/-- Option C: freestanding pipe/stdio spawn for `lake script` (W90; outside CLAIMED). -/
@[extern "slake_fs_run_lake_script_pipe"]
opaque slakeFsRunLakeScriptPipe (pkgDir : @& String) (lakePath : @& String) (rest : @& Array String) : UInt32

/-- Option C: freestanding `Systems.Proc` multi-arg spawn for `lake clean` (W91; CLAIMED token dual path). -/
@[extern "slake_fs_run_lake_clean"]
opaque slakeFsRunLakeClean (pkgDir : @& String) (lakePath : @& String) (rest : @& Array String) : UInt32

/-- Option C: freestanding pipe/stdio spawn for `lake clean` (W91; CLAIMED token dual path). -/
@[extern "slake_fs_run_lake_clean_pipe"]
opaque slakeFsRunLakeCleanPipe (pkgDir : @& String) (lakePath : @& String) (rest : @& Array String) : UInt32

/-- Option C: freestanding `Systems.Proc` multi-arg spawn for `lake update` (W92; outside CLAIMED). -/
@[extern "slake_fs_run_lake_update"]
opaque slakeFsRunLakeUpdate (pkg : @& String) (lake : @& String) (rest : @& Array String) : UInt32

/-- Option C: freestanding pipe/stdio spawn for `lake update` (W92; outside CLAIMED). -/
@[extern "slake_fs_run_lake_update_pipe"]
opaque slakeFsRunLakeUpdatePipe (pkg : @& String) (lake : @& String) (rest : @& Array String) : UInt32

/-- Option C: freestanding `Systems.Proc` multi-arg spawn for `lake pack` (W93; outside CLAIMED). -/
@[extern "slake_fs_run_lake_pack"]
opaque slakeFsRunLakePack (pkg : @& String) (lake : @& String) (rest : @& Array String) : UInt32

/-- Option C: freestanding pipe/stdio spawn for `lake pack` (W93; outside CLAIMED). -/
@[extern "slake_fs_run_lake_pack_pipe"]
opaque slakeFsRunLakePackPipe (pkg : @& String) (lake : @& String) (rest : @& Array String) : UInt32

/-- Option C: freestanding `Systems.Proc` multi-arg spawn for `lake cache` (W94; outside CLAIMED). -/
@[extern "slake_fs_run_lake_cache"]
opaque slakeFsRunLakeCache (pkg : @& String) (lake : @& String) (rest : @& Array String) : UInt32

/-- Option C: freestanding pipe/stdio spawn for `lake cache` (W94; outside CLAIMED). -/
@[extern "slake_fs_run_lake_cache_pipe"]
opaque slakeFsRunLakeCachePipe (pkg : @& String) (lake : @& String) (rest : @& Array String) : UInt32

/-- Option C: freestanding `Systems.Proc` multi-arg spawn for `lake unpack` (W95; outside CLAIMED). -/
@[extern "slake_fs_run_lake_unpack"]
opaque slakeFsRunLakeUnpack (pkg : @& String) (lake : @& String) (rest : @& Array String) : UInt32

/-- Option C: freestanding pipe/stdio spawn for `lake unpack` (W95; outside CLAIMED). -/
@[extern "slake_fs_run_lake_unpack_pipe"]
opaque slakeFsRunLakeUnpackPipe (pkg : @& String) (lake : @& String) (rest : @& Array String) : UInt32

/-- Option C: freestanding `Systems.Proc` multi-arg spawn for `lake query` (W96; outside CLAIMED). -/
@[extern "slake_fs_run_lake_query"]
opaque slakeFsRunLakeQuery (pkg : @& String) (lake : @& String) (rest : @& Array String) : UInt32

/-- Option C: freestanding pipe/stdio spawn for `lake query` (W96; outside CLAIMED). -/
@[extern "slake_fs_run_lake_query_pipe"]
opaque slakeFsRunLakeQueryPipe (pkg : @& String) (lake : @& String) (rest : @& Array String) : UInt32

/-- Option C: freestanding `Systems.Proc` multi-arg spawn for `lake shake` (W97; outside CLAIMED). -/
@[extern "slake_fs_run_lake_shake"]
opaque slakeFsRunLakeShake (pkg : @& String) (lake : @& String) (rest : @& Array String) : UInt32

/-- Option C: freestanding pipe/stdio spawn for `lake shake` (W97; outside CLAIMED). -/
@[extern "slake_fs_run_lake_shake_pipe"]
opaque slakeFsRunLakeShakePipe (pkg : @& String) (lake : @& String) (rest : @& Array String) : UInt32

/-- Option C: freestanding `Systems.Proc` multi-arg spawn for `lake serve` (W98; outside CLAIMED). -/
@[extern "slake_fs_run_lake_serve"]
opaque slakeFsRunLakeServe (pkg : @& String) (lake : @& String) (rest : @& Array String) : UInt32

/-- Option C: freestanding pipe/stdio spawn for `lake serve` (W98; outside CLAIMED). -/
@[extern "slake_fs_run_lake_serve_pipe"]
opaque slakeFsRunLakeServePipe (pkg : @& String) (lake : @& String) (rest : @& Array String) : UInt32

/-- Option C: freestanding `Systems.Proc` multi-arg spawn for `lake upload` (W99; outside CLAIMED). -/
@[extern "slake_fs_run_lake_upload"]
opaque slakeFsRunLakeUpload (pkg : @& String) (lake : @& String) (rest : @& Array String) : UInt32

/-- Option C: freestanding pipe/stdio spawn for `lake upload` (W99; outside CLAIMED). -/
@[extern "slake_fs_run_lake_upload_pipe"]
opaque slakeFsRunLakeUploadPipe (pkg : @& String) (lake : @& String) (rest : @& Array String) : UInt32

/-- Option C: freestanding `Systems.Proc` multi-arg spawn for `lake lean` (W100; outside CLAIMED). -/
@[extern "slake_fs_run_lake_lean"]
opaque slakeFsRunLakeLean (pkg : @& String) (lake : @& String) (rest : @& Array String) : UInt32

/-- Option C: freestanding pipe/stdio spawn for `lake lean` (W100; outside CLAIMED). -/
@[extern "slake_fs_run_lake_lean_pipe"]
opaque slakeFsRunLakeLeanPipe (pkg : @& String) (lake : @& String) (rest : @& Array String) : UInt32

/-- Option C: freestanding `Systems.Proc` multi-arg spawn for `lake scripts` (W101; outside CLAIMED). -/
@[extern "slake_fs_run_lake_scripts"]
opaque slakeFsRunLakeScripts (pkg : @& String) (lake : @& String) (rest : @& Array String) : UInt32

/-- Option C: freestanding pipe/stdio spawn for `lake scripts` (W101; outside CLAIMED). -/
@[extern "slake_fs_run_lake_scripts_pipe"]
opaque slakeFsRunLakeScriptsPipe (pkg : @& String) (lake : @& String) (rest : @& Array String) : UInt32

/-- Option C: freestanding `Systems.Proc` multi-arg spawn for `lake setup-file` (W102; outside CLAIMED). -/
@[extern "slake_fs_run_lake_setup_file"]
opaque slakeFsRunLakeSetupFile (pkg : @& String) (lake : @& String) (rest : @& Array String) : UInt32

/-- Option C: freestanding pipe/stdio spawn for `lake setup-file` (W102; outside CLAIMED). -/
@[extern "slake_fs_run_lake_setup_file_pipe"]
opaque slakeFsRunLakeSetupFilePipe (pkg : @& String) (lake : @& String) (rest : @& Array String) : UInt32

/-- Option C: freestanding `Systems.Proc` multi-arg spawn for `lake self-check` (W103; outside CLAIMED). -/
@[extern "slake_fs_run_lake_self_check"]
opaque slakeFsRunLakeSelfCheck (pkg : @& String) (lake : @& String) (rest : @& Array String) : UInt32

/-- Option C: freestanding pipe/stdio spawn for `lake self-check` (W103; outside CLAIMED). -/
@[extern "slake_fs_run_lake_self_check_pipe"]
opaque slakeFsRunLakeSelfCheckPipe (pkg : @& String) (lake : @& String) (rest : @& Array String) : UInt32

/-- Option C: freestanding `Systems.Proc` multi-arg spawn for `lake version-tags` (W104; outside CLAIMED). -/
@[extern "slake_fs_run_lake_version_tags"]
opaque slakeFsRunLakeVersionTags (pkg : @& String) (lake : @& String) (rest : @& Array String) : UInt32

/-- Option C: freestanding pipe/stdio spawn for `lake version-tags` (W104; outside CLAIMED). -/
@[extern "slake_fs_run_lake_version_tags_pipe"]
opaque slakeFsRunLakeVersionTagsPipe (pkg : @& String) (lake : @& String) (rest : @& Array String) : UInt32

/-- Option C: freestanding multi-arg spawn for `lake translate-config` (W105; outside CLAIMED). -/
@[extern "slake_fs_run_lake_translate_config"]
opaque slakeFsRunLakeTranslateConfig (pkg : @& String) (lake : @& String) (rest : @& Array String) : UInt32

/-- Option C: freestanding pipe/stdio spawn for `lake translate-config` (W105; outside CLAIMED). -/
@[extern "slake_fs_run_lake_translate_config_pipe"]
opaque slakeFsRunLakeTranslateConfigPipe (pkg : @& String) (lake : @& String) (rest : @& Array String) : UInt32

/-- Option C: freestanding multi-arg spawn for `lake run` (W106; outside CLAIMED). -/
@[extern "slake_fs_run_lake_run"]
opaque slakeFsRunLakeRun (pkg : @& String) (lake : @& String) (rest : @& Array String) : UInt32

/-- Option C: freestanding pipe/stdio spawn for `lake run` (W106; outside CLAIMED). -/
@[extern "slake_fs_run_lake_run_pipe"]
opaque slakeFsRunLakeRunPipe (pkg : @& String) (lake : @& String) (rest : @& Array String) : UInt32

/-- Option C: freestanding multi-arg spawn for `lake new` (W107; outside CLAIMED; cwd bootstrap). -/
@[extern "slake_fs_run_lake_new"]
opaque slakeFsRunLakeNew (cwd : @& String) (lake : @& String) (rest : @& Array String) : UInt32

/-- Option C: freestanding pipe/stdio spawn for `lake new` (W107; outside CLAIMED; cwd bootstrap). -/
@[extern "slake_fs_run_lake_new_pipe"]
opaque slakeFsRunLakeNewPipe (cwd : @& String) (lake : @& String) (rest : @& Array String) : UInt32

/-- Option C: freestanding `Systems.Proc` multi-arg spawn for `lake init` (W108; outside CLAIMED; cwd bootstrap). -/
@[extern "slake_fs_run_lake_init"]
opaque slakeFsRunLakeInit (cwd : @& String) (lake : @& String) (rest : @& Array String) : UInt32

/-- Option C: freestanding pipe/stdio spawn for `lake init` (W108; outside CLAIMED; cwd bootstrap). -/
@[extern "slake_fs_run_lake_init_pipe"]
opaque slakeFsRunLakeInitPipe (cwd : @& String) (lake : @& String) (rest : @& Array String) : UInt32

/-- Option C: freestanding `Systems.Proc` multi-arg spawn for `lake check-build` (W109; outside CLAIMED; chdir pkg). -/
@[extern "slake_fs_run_lake_check_build"]
opaque slakeFsRunLakeCheckBuild (pkg : @& String) (lake : @& String) (rest : @& Array String) : UInt32

/-- Option C: freestanding pipe/stdio spawn for `lake check-build` (W109; outside CLAIMED; chdir pkg). -/
@[extern "slake_fs_run_lake_check_build_pipe"]
opaque slakeFsRunLakeCheckBuildPipe (pkg : @& String) (lake : @& String) (rest : @& Array String) : UInt32

/-- Option C: freestanding `Systems.Proc` multi-arg spawn for `lake check-test` (W110; outside CLAIMED; chdir pkg). -/
@[extern "slake_fs_run_lake_check_test"]
opaque slakeFsRunLakeCheckTest (pkg : @& String) (lake : @& String) (rest : @& Array String) : UInt32

/-- Option C: freestanding pipe/stdio spawn for `lake check-test` (W110; outside CLAIMED; chdir pkg). -/
@[extern "slake_fs_run_lake_check_test_pipe"]
opaque slakeFsRunLakeCheckTestPipe (pkg : @& String) (lake : @& String) (rest : @& Array String) : UInt32

/-- Option C: freestanding `Systems.Proc` multi-arg spawn for `lake check-lint` (W111; outside CLAIMED; chdir pkg). -/
@[extern "slake_fs_run_lake_check_lint"]
opaque slakeFsRunLakeCheckLint (pkg : @& String) (lake : @& String) (rest : @& Array String) : UInt32

/-- Option C: freestanding pipe/stdio spawn for `lake check-lint` (W111; outside CLAIMED; chdir pkg). -/
@[extern "slake_fs_run_lake_check_lint_pipe"]
opaque slakeFsRunLakeCheckLintPipe (pkg : @& String) (lake : @& String) (rest : @& Array String) : UInt32

/-- Option C: freestanding `Systems.Proc` multi-arg spawn for `lake exec` (W112; outside CLAIMED; chdir pkg). -/
@[extern "slake_fs_run_lake_exec"]
opaque slakeFsRunLakeExec (pkg : @& String) (lake : @& String) (rest : @& Array String) : UInt32

/-- Option C: freestanding pipe/stdio spawn for `lake exec` (W112; outside CLAIMED; chdir pkg). -/
@[extern "slake_fs_run_lake_exec_pipe"]
opaque slakeFsRunLakeExecPipe (pkg : @& String) (lake : @& String) (rest : @& Array String) : UInt32

/-- Option C: freestanding `Systems.Proc` multi-arg spawn for `lake query-kind` (W113; outside CLAIMED; chdir pkg). -/
@[extern "slake_fs_run_lake_query_kind"]
opaque slakeFsRunLakeQueryKind (pkg : @& String) (lake : @& String) (rest : @& Array String) : UInt32

/-- Option C: freestanding pipe/stdio spawn for `lake query-kind` (W113; outside CLAIMED; chdir pkg). -/
@[extern "slake_fs_run_lake_query_kind_pipe"]
opaque slakeFsRunLakeQueryKindPipe (pkg : @& String) (lake : @& String) (rest : @& Array String) : UInt32

/-- Option C: freestanding `Systems.Proc` multi-arg spawn for `lake resolve-deps` (W114; outside CLAIMED; chdir pkg). -/
@[extern "slake_fs_run_lake_resolve_deps"]
opaque slakeFsRunLakeResolveDeps (pkg : @& String) (lake : @& String) (rest : @& Array String) : UInt32

/-- Option C: freestanding pipe/stdio spawn for `lake resolve-deps` (W114; outside CLAIMED; chdir pkg). -/
@[extern "slake_fs_run_lake_resolve_deps_pipe"]
opaque slakeFsRunLakeResolveDepsPipe (pkg : @& String) (lake : @& String) (rest : @& Array String) : UInt32

/-- Option C: freestanding `Systems.Proc` multi-arg spawn for `lake reservoir-config` (W115; outside CLAIMED; chdir pkg). -/
@[extern "slake_fs_run_lake_reservoir_config"]
opaque slakeFsRunLakeReservoirConfig (pkg : @& String) (lake : @& String) (rest : @& Array String) : UInt32

/-- Option C: freestanding pipe/stdio spawn for `lake reservoir-config` (W115; outside CLAIMED; chdir pkg). -/
@[extern "slake_fs_run_lake_reservoir_config_pipe"]
opaque slakeFsRunLakeReservoirConfigPipe (pkg : @& String) (lake : @& String) (rest : @& Array String) : UInt32

/-- Option C: freestanding `Systems.Proc` multi-arg spawn for `lake upgrade` (W116; outside CLAIMED; chdir pkg). -/
@[extern "slake_fs_run_lake_upgrade"]
opaque slakeFsRunLakeUpgrade (pkg : @& String) (lake : @& String) (rest : @& Array String) : UInt32

/-- Option C: freestanding pipe/stdio spawn for `lake upgrade` (W116; outside CLAIMED; chdir pkg). -/
@[extern "slake_fs_run_lake_upgrade_pipe"]
opaque slakeFsRunLakeUpgradePipe (pkg : @& String) (lake : @& String) (rest : @& Array String) : UInt32

/-- `1` when the driver was linked with the freestanding Proc shim. -/
@[extern "slake_fs_proc_linked"]
opaque slakeFsProcLinked : Unit → UInt32

/-- `1` when the driver was linked with the freestanding Proc **pipe** path. -/
@[extern "slake_fs_proc_pipe_linked"]
opaque slakeFsProcPipeLinked : Unit → UInt32

/-- Print freestanding DepGraph **demo** plan (`slake depgraph plan: C B A`).

Demo-only (depgraph_wire parity). Package-derived plans use `chainTopo` /
`edgesTopo` + labels. -/
@[extern "slake_fs_depgraph_print_plan"]
opaque slakeFsDepgraphPrintPlan : Unit → UInt32

/-- Freestanding Kahn topo of a declaration-order chain `0→1→…→n-1` (package plan fallback).

`n` in `1…16`. Returns `0` on success; order readable via `slakeFsDepgraphChainOutAt`. -/
@[extern "slake_fs_depgraph_chain_topo"]
opaque slakeFsDepgraphChainTopo (n : UInt32) : UInt32

/-- Clear staged import-scan edges before `edgeAdd` / `edgesTopo`. -/
@[extern "slake_fs_depgraph_edge_clear"]
opaque slakeFsDepgraphEdgeClear : Unit → UInt32

/-- Stage one directed edge `src → dst` (src precedes dst) for import-scan DAG. -/
@[extern "slake_fs_depgraph_edge_add"]
opaque slakeFsDepgraphEdgeAdd (src : UInt32) (dst : UInt32) : UInt32

/-- Freestanding Kahn topo on staged import-scan edges for `n` nodes.

Empty edge set is valid (seed order). Order via `slakeFsDepgraphChainOutAt`. -/
@[extern "slake_fs_depgraph_edges_topo"]
opaque slakeFsDepgraphEdgesTopo (n : UInt32) : UInt32

/-- Index into last successful `chainTopo` / `edgesTopo` result (`0xffffffff` if OOB). -/
@[extern "slake_fs_depgraph_chain_out_at"]
opaque slakeFsDepgraphChainOutAt (i : UInt32) : UInt32

/-- `1` when the driver was linked with the freestanding DepGraph shim. -/
@[extern "slake_fs_depgraph_linked"]
opaque slakeFsDepgraphLinked : Unit → UInt32

/-- Printed version string (Phase 2 MVP classic host driver). -/
public def versionString : String :=
  "slake 0.0.1-mvp (classic host driver; not full Lake parity)"

/-- Usage text for `--help` / unknown commands. -/
public def usage : String :=
  "Usage: slake <command>\n" ++
  "\n" ++
  "Commands (MVP classic host driver; not full Lake parity):\n" ++
  "  build       Build the package (delegates to `lake build`)\n" ++
  "  clean       Dual residual: native wipe pkg/.lake/build + pkg/.slake-native\n" ++
  "              + path-require dep .slake-native (A17+A33; default; empty rest only;\n" ++
  "              native product out dir wipe subset; not git/url / not multi-..);\n" ++
  "              FS_PROC/PIPE → lake clean then same native wipe set\n" ++
  "              (empty rest only; Lake clean may wipe more than .lake/build)\n" ++
  "  test        Run package tests (delegates to `lake test`)\n" ++
  "  script      Forward to `lake script` (classic host; not CLAIMED parity)\n" ++
  "  exe         Forward to `lake exe` (classic host; not CLAIMED parity)\n" ++
  "  lint        Forward to `lake lint` (classic host; not CLAIMED parity)\n" ++
  "  check-build Forward to `lake check-build` (classic host dual residual; not CLAIMED;\n" ++
  "              optional FS_PROC/PIPE empty child env; chdir(pkg);\n" ++
  "              resolveLakeAbs pre-chdir; not empty-rest-only — rest may rebind Lake globals)\n" ++
  "  check-test  Forward to `lake check-test` (classic host dual residual; not CLAIMED;\n" ++
  "              optional FS_PROC/PIPE empty child env; chdir(pkg);\n" ++
  "              resolveLakeAbs pre-chdir; not empty-rest-only — rest may rebind Lake globals)\n" ++
  "  check-lint  Forward to `lake check-lint` (classic host dual residual; not CLAIMED;\n" ++
  "              optional FS_PROC/PIPE empty child env; chdir(pkg);\n" ++
  "              resolveLakeAbs pre-chdir; not empty-rest-only — rest may rebind Lake globals)\n" ++
  "  query       Forward to `lake query` (classic host dual residual; not CLAIMED;\n" ++
  "              optional FS_PROC/PIPE freestanding multi-arg; rest plumbed;\n" ++
  "              FS_PROC chdir(pkg) for relative path parity with classic cwd=pkg;\n" ++
  "              resolveLakeAbs pre-chdir; not empty-rest-only — rest may rebind Lake globals)\n" ++
  "  shake       Forward to `lake shake` (classic host dual residual; not CLAIMED;\n" ++
  "              optional FS_PROC/PIPE freestanding multi-arg; rest plumbed;\n" ++
  "              FS_PROC chdir(pkg) for relative path parity with classic cwd=pkg;\n" ++
  "              resolveLakeAbs pre-chdir; not empty-rest-only — rest may rebind Lake globals)\n" ++
  "  update      Forward to `lake update` (classic host dual residual; not CLAIMED;\n" ++
  "              optional FS_PROC/PIPE freestanding multi-arg; rest plumbed)\n" ++
  "  pack        Forward to `lake pack` (classic host dual residual; not CLAIMED;\n" ++
  "              optional FS_PROC/PIPE freestanding multi-arg; rest plumbed;\n" ++
  "              FS_PROC chdir(pkg) for relative archive parity with classic cwd=pkg;\n" ++
  "              not empty-rest-only — rest may rebind Lake globals)\n" ++
  "  unpack      Forward to `lake unpack` (classic host dual residual; not CLAIMED;\n" ++
  "              optional FS_PROC/PIPE freestanding multi-arg; rest plumbed;\n" ++
  "              FS_PROC chdir(pkg) for relative path parity with classic cwd=pkg;\n" ++
  "              resolveLakeAbs pre-chdir; not empty-rest-only — rest may rebind Lake globals)\n" ++
  "  cache       Forward to `lake cache` (classic host dual residual; not CLAIMED;\n" ++
  "              optional FS_PROC/PIPE freestanding multi-arg; rest plumbed;\n" ++
  "              FS_PROC chdir(pkg) for relative path parity with classic cwd=pkg;\n" ++
  "              rest may rebind Lake globals — residual honesty)\n" ++
  "  lean        Forward to `lake lean` (classic host dual residual; not CLAIMED;\n" ++
  "              optional FS_PROC/PIPE freestanding multi-arg; rest plumbed;\n" ++
  "              FS_PROC chdir(pkg) for relative path parity with classic cwd=pkg;\n" ++
  "              resolveLakeAbs pre-chdir; empty child env; not empty-rest-only — rest may rebind Lake globals)\n" ++
  "  scripts     Forward to `lake scripts` (classic host dual residual; not CLAIMED;\n" ++
  "              optional FS_PROC/PIPE freestanding multi-arg; rest plumbed;\n" ++
  "              FS_PROC chdir(pkg) for relative path parity with classic cwd=pkg;\n" ++
  "              resolveLakeAbs pre-chdir; empty child env; not empty-rest-only — rest may rebind Lake globals)\n" ++
  "  new         Forward to `lake new` (classic host dual residual; cwd bootstrap; not CLAIMED;\n" ++
  "              optional FS_PROC/PIPE freestanding multi-arg; rest plumbed;\n" ++
  "              FS_PROC chdir(cwd) bootstrap (no package walk-up);\n" ++
  "              resolveLakeAbs pre-chdir; empty child env; not empty-rest-only — rest may rebind Lake globals)\n" ++
  "  init        Forward to `lake init` (classic host dual residual; cwd bootstrap; not CLAIMED;\n" ++
  "              optional FS_PROC/PIPE freestanding multi-arg; rest plumbed;\n" ++
  "              FS_PROC chdir(cwd) bootstrap (no package walk-up);\n" ++
  "              resolveLakeAbs pre-chdir; empty child env; not empty-rest-only — rest may rebind Lake globals)\n" ++
  "  serve       Forward to `lake serve` (classic host dual residual; not CLAIMED;\n" ++
  "              optional FS_PROC/PIPE freestanding multi-arg; rest plumbed;\n" ++
  "              FS_PROC chdir(pkg) for relative path parity with classic cwd=pkg;\n" ++
  "              resolveLakeAbs pre-chdir; not empty-rest-only — rest may rebind Lake globals)\n" ++
  "  upload      Forward to `lake upload` (classic host dual residual; not CLAIMED;\n" ++
  "              optional FS_PROC/PIPE empty child env; chdir(pkg);\n" ++
  "              resolveLakeAbs pre-chdir; not empty-rest-only — rest may rebind Lake globals)\n" ++
  "  translate-config  Forward to `lake translate-config` (classic host dual residual; not CLAIMED;\n" ++
  "              optional FS_PROC/PIPE freestanding multi-arg; rest plumbed;\n" ++
  "              FS_PROC chdir(pkg) for relative path parity with classic cwd=pkg;\n" ++
  "              resolveLakeAbs pre-chdir; empty child env; not empty-rest-only — rest may rebind Lake globals)\n" ++
  "  run         Forward to `lake run` (classic host dual residual; not CLAIMED;\n" ++
  "              optional FS_PROC/PIPE freestanding multi-arg; rest plumbed;\n" ++
  "              FS_PROC chdir(pkg) for relative path parity with classic cwd=pkg;\n" ++
  "              resolveLakeAbs pre-chdir; empty child env; not empty-rest-only — rest may rebind Lake globals)\n" ++
  "  setup-file  Forward to `lake setup-file` (classic host dual residual; not CLAIMED;\n" ++
  "              optional FS_PROC/PIPE freestanding multi-arg; rest plumbed;\n" ++
  "              FS_PROC chdir(pkg) for relative path parity with classic cwd=pkg;\n" ++
  "              resolveLakeAbs pre-chdir; empty child env; not empty-rest-only — rest may rebind Lake globals)\n" ++
  "  self-check  Forward to `lake self-check` (classic host dual residual; not CLAIMED;\n" ++
  "              optional FS_PROC/PIPE freestanding multi-arg; rest plumbed;\n" ++
  "              FS_PROC chdir(pkg) for relative path parity with classic cwd=pkg;\n" ++
  "              resolveLakeAbs pre-chdir; empty child env; not empty-rest-only — rest may rebind Lake globals)\n" ++
  "  version-tags Forward to `lake version-tags` (classic host dual residual; not CLAIMED;\n" ++
  "              optional FS_PROC/PIPE freestanding multi-arg; rest plumbed;\n" ++
  "              FS_PROC chdir(pkg) for relative path parity with classic cwd=pkg;\n" ++
  "              resolveLakeAbs pre-chdir; empty child env; not empty-rest-only — rest may rebind Lake globals)\n" ++
  "  query-kind  Forward to `lake query-kind` (classic host dual residual; not CLAIMED;\n" ++
  "              optional FS_PROC/PIPE freestanding multi-arg; rest plumbed;\n" ++
  "              FS_PROC chdir(pkg) for relative path parity with classic cwd=pkg;\n" ++
  "              resolveLakeAbs pre-chdir; empty child env; not empty-rest-only — rest may rebind Lake globals)\n" ++
  "  resolve-deps Forward to `lake resolve-deps` (classic host dual residual; not CLAIMED;\n" ++
  "              optional FS_PROC/PIPE freestanding multi-arg; rest plumbed;\n" ++
  "              FS_PROC chdir(pkg) for relative path parity with classic cwd=pkg;\n" ++
  "              resolveLakeAbs pre-chdir; empty child env; not empty-rest-only — rest may rebind Lake globals)\n" ++
  "  reservoir-config Forward to `lake reservoir-config` (classic host dual residual; not CLAIMED;\n" ++
  "              optional FS_PROC/PIPE freestanding multi-arg; rest plumbed;\n" ++
  "              FS_PROC chdir(pkg) for relative path parity with classic cwd=pkg;\n" ++
  "              resolveLakeAbs pre-chdir; empty child env; not empty-rest-only — rest may rebind Lake globals)\n" ++
  "  exec        Forward to `lake exec` (classic host dual residual; not CLAIMED;\n" ++
  "             alias of exe; FS_PROC/PIPE optional; chdir pkg)\n" ++
  "  upgrade     Forward to `lake upgrade` (classic host dual residual; not CLAIMED;\n" ++
  "              Lake alias of update; optional FS_PROC/PIPE freestanding multi-arg; rest plumbed;\n" ++
  "              FS_PROC chdir(pkg) for relative path parity with classic cwd=pkg;\n" ++
  "              resolveLakeAbs pre-chdir; empty child env; not empty-rest-only — rest may rebind Lake globals)\n" ++
  "  env         Print cwd, package dir, LEAN_PATH, FS_PROC/PIPE/DEPGRAPH/PLAN_ONLY/NATIVE_CHECK/NATIVE_OLEAN/FORCE/JOBS/NATIVE_BUILD/NATIVE_C/NATIVE_OBJ/NATIVE_IRLINK/NATIVE_AR/NATIVE_EXE/NATIVE_LINK/NATIVE_GRAPH/NATIVE_SEAL status\n" ++
  "  --help      Show this help\n" ++
  "  --version   Show version\n" ++
  "\n" ++
  "Env:\n" ++
  "  SLAKE_USE_FS_PROC=1      freestanding Systems.Proc multi-arg spawn\n" ++
  "  SLAKE_USE_FS_PROC_PIPE=1 freestanding Proc pipe/stdio (stdout capture demo)\n" ++
  "  SLAKE_FS_PROC_STRICT=1   no IO.Process fall back on build/test/exe/lint/script/update/pack/cache/unpack/query/shake/serve/upload/lean/scripts/setup-file/self-check/version-tags/translate-config/run/new/init/check-build/check-test/check-lint/exec/query-kind/resolve-deps/reservoir-config/upgrade;\n" ++
  "                          clean: no native wipe fall-back (unlinked/spawn fail)\n" ++
  "  SLAKE_DEPGRAPH=1         print package-derived freestanding DepGraph plan then lake\n" ++
  "  SLAKE_PLAN_ONLY=1        print package plan (Config + DepGraph when linked) and skip lake\n" ++
  "  SLAKE_DEPGRAPH_DEMO=1    also print demo C→B→A plan (depgraph_wire parity; residual)\n" ++
  "  SLAKE_NATIVE_CHECK=1     after package plan, sequential host-lean typecheck of plan\n" ++
  "                          modules (implies plan print; not CLAIMED / not freestanding\n" ++
  "                          build TCB / not olean orchestration); with PLAN_ONLY still\n" ++
  "                          skips lake; without PLAN_ONLY lake runs after check\n" ++
  "  SLAKE_NATIVE_CHECK_STRICT=1  fail if lean missing or a plan module file is missing\n" ++
  "                          (default soft-skips missing lean/file with a warn)\n" ++
  "  SLAKE_NATIVE_OLEAN=1     after package plan, sequential host-lean compile writing\n" ++
  "                          oleans into package-local .slake-native/ and feed that dir on\n" ++
  "                          LEAN_PATH (implies plan; multi-module sequential honesty;\n" ++
  "                          A9 mtime + plan-edge cascade skip when olean is fresh\n" ++
  "                          (this-run recompiled/soft-skip cascade + dep-olean-newer\n" ++
  "                          cross-run subset); A10 FNV-1a 64 source content-hash\n" ++
  "                          sidecar subset (.olean.slakehash) — touch-without-edit skips\n" ++
  "                          when hash matches even if mtime is newer; A11 plan-node\n" ++
  "                          transitive deps-hash: live direct plan-import dep must be\n" ++
  "                          hash-fresh (run-start snapshot) before skip + optional frozen\n" ++
  "                          deps <hex> line (direct plan-import dep source closure +\n" ++
  "                          A28 path-dep import source-hash fold; cascade multi-hop;\n" ++
  "                          skip-heal on mtime/hash skip; not Lake package-transitive /\n" ++
  "                          not freestanding TCB / not CLAIMED / not full olean graph\n" ++
  "                          invalidation / not Lake shake/hash TCB); with PLAN_ONLY still\n" ++
  "                          skips lake; without PLAN_ONLY lake follows; when both\n" ++
  "                          NATIVE_OLEAN and NATIVE_CHECK are set, olean compile runs\n" ++
  "                          (superset) and thin typecheck is skipped; A17: package-local\n" ++
  "                          .slake-native/ is wiped by slake clean (native product out dir\n" ++
  "                          wipe subset with .lake/build; not full Lake clean set / not\n" ++
  "                          freestanding build TCB); A33: path-require package\n" ++
  "                          .slake-native/ also wiped on clean (A26 under-pkg / A29 sibling\n" ++
  "                          confining; identity order; not git/url / not Lake resolve-deps /\n" ++
  "                          not multi-.. / not dep .lake/build)\n" ++
  "  SLAKE_NATIVE_OLEAN_STRICT=1  fail if lean missing or a plan module file is missing\n" ++
  "                          under NATIVE_OLEAN (default soft-skips missing lean/file;\n" ++
  "                          soft-skipped deps cascade dependents)\n" ++
  "  SLAKE_NATIVE_OLEAN_FORCE=1   always rebuild all plan modules under NATIVE_OLEAN\n" ++
  "                          (ignore mtime/hash freshness; cascade still tracks recompiles)\n" ++
  "  SLAKE_NATIVE_OLEAN_JOBS=N    opt-in parallel host-lean olean waves (A12): default/\n" ++
  "                          unset/1/invalid → sequential (A8–A11 path); N≥2 → compile\n" ++
  "                          ready plan modules (direct plan-import deps finished this run)\n" ++
  "                          with up to N concurrent lean -o (IO.asTask); Host never starts\n" ++
  "                          before Core when Host imports Core; skip/cascade/hash decisions\n" ++
  "                          stay single-threaded; fail-closed if any lean fails (drain\n" ++
  "                          batch); empty import-scan edges ⇒ no ready-set gating beyond\n" ++
  "                          plan-order batches of N (prefer import-scan edges for multi-module\n" ++
  "                          JOBS≥2); logs native olean: jobs=N; not freestanding build TCB /\n" ++
  "                          not Lake job server TCB / not CLAIMED / not shared-lib link\n" ++
  "  SLAKE_NATIVE_BUILD=1     freestanding-adjacent native olean build subset:\n" ++
  "                          implies plan + NATIVE_OLEAN compile (A8–A12 cache; JOBS applies);\n" ++
  "                          on successful olean compile (lean present; at least one module\n" ++
  "                          compiled or skipped-fresh) skip lake (exit 0); on lean\n" ++
  "                          nonzero / lean missing / zero modules / missing work exit\n" ++
  "                          nonzero (fail-closed, no lake fallback; no zero-work success);\n" ++
  "                          with NATIVE_C also set, skip-lake requires C emit success;\n" ++
  "                          with NATIVE_OBJ also set, skip-lake requires object compile success;\n" ++
  "                          with NATIVE_IRLINK also set, skip-lake requires IR shared-lib link success;\n" ++
  "                          with NATIVE_AR also set, skip-lake requires static archive success;\n" ++
  "                          with NATIVE_EXE also set, skip-lake requires executable link success;\n" ++
  "                          with NATIVE_LINK also set, skip-lake requires name-table link success;\n" ++
  "                          with NATIVE_GRAPH also set, skip-lake requires graph write;\n" ++
  "                          with NATIVE_SEAL also set, skip-lake requires seal write;\n" ++
  "                          not freestanding build TCB / not Lake TCB / not CLAIMED.\n" ++
  "                          PLAN_ONLY remains dry-run plan(+optional check/olean/c-emit/obj/irlink/ar/exe/link/graph/seal); CLAIMED\n" ++
  "                          build without this flag stays lake-delegated\n" ++
  "  SLAKE_NATIVE_C=1         host lean C-output emit subset after native oleans (A19):\n" ++
  "                          implies plan + NATIVE_OLEAN; for each plan module (skip package\n" ++
  "                          name) runs host lean -c .slake-native/<ModRel>.c <file> with\n" ++
  "                          same LEAN_PATH as olean (.slake-native first, then pkg [+srcDir],\n" ++
  "                          then A26 path-require roots when present);\n" ++
  "                          nested modules → Foo/Bar.c under .slake-native/; always re-emits;\n" ++
  "                          not freestanding build TCB / not Lake lean_lib shared-object of\n" ++
  "                          compiled Lean IR / not full object compile+link of Lean runtime /\n" ++
  "                          not CLAIMED; JOBS applies to olean only (C emit is sequential);\n" ++
  "                          with PLAN_ONLY still skips lake after olean+C; without\n" ++
  "                          PLAN_ONLY/NATIVE_BUILD lake follows after C emit; with\n" ++
  "                          NATIVE_BUILD, skip-lake requires both olean and C emit success\n" ++
  "                          (+ obj when NATIVE_OBJ set) (+ link when NATIVE_LINK set)\n" ++
  "                          (+ graph when NATIVE_GRAPH set) (+ seal when NATIVE_SEAL set);\n" ++
  "                          order olean → C emit → obj → link → graph → seal\n" ++
  "  SLAKE_NATIVE_C_STRICT=1  fail if lean missing or a plan module source is missing under\n" ++
  "                          NATIVE_C (default soft-skips missing lean/file with a warn;\n" ++
  "                          actual lean nonzero exit is always fail-closed; NATIVE_BUILD+\n" ++
  "                          NATIVE_C also fail-closed on missing lean / zero C files so\n" ++
  "                          skip-lake is not zero-work)\n" ++
  "  SLAKE_NATIVE_OBJ=1       host object compile of lean C subset after native C emit (A20):\n" ++
  "                          implies plan + NATIVE_OLEAN + NATIVE_C; for each plan module\n" ++
  "                          (skip package name) runs host cc -c -fPIC -I<leanInclude>\n" ++
  "                          -o .slake-native/<ModRel>.o .slake-native/<ModRel>.c;\n" ++
  "                          nested modules → Foo/Bar.o; include via LEAN_INCLUDE or\n" ++
  "                          LEAN_SYSROOT/LEAN_PREFIX/include or lean --print-prefix/include;\n" ++
  "                          not freestanding build TCB / not Lake lean_lib shared-object of\n" ++
  "                          compiled Lean IR / not linking Lean runtime into SO / not CLAIMED;\n" ++
  "                          JOBS applies to olean only (object compile is sequential);\n" ++
  "                          with PLAN_ONLY still skips lake after olean+C+obj; without\n" ++
  "                          PLAN_ONLY/NATIVE_BUILD lake follows after obj; with NATIVE_BUILD,\n" ++
  "                          skip-lake requires olean + C emit + object compile success\n" ++
  "                          (+ IR link when NATIVE_IRLINK set) (+ link when NATIVE_LINK set —\n" ++
  "                          still name-table SO, not IR link) (+ graph when NATIVE_GRAPH set)\n" ++
  "                          (+ seal when NATIVE_SEAL set)\n" ++
  "  SLAKE_NATIVE_OBJ_STRICT=1  fail if cc/include missing or a plan module .c is missing\n" ++
  "                          under NATIVE_OBJ (default soft-skips missing cc/include/C with a\n" ++
  "                          warn; actual cc nonzero exit is always fail-closed; NATIVE_BUILD+\n" ++
  "                          NATIVE_OBJ also fail-closed on missing cc/include / zero .o so\n" ++
  "                          skip-lake is not zero-work)\n" ++
  "  SLAKE_NATIVE_IRLINK=1    host leanc IR shared-lib link subset after native object compile\n" ++
  "                          (A21): implies plan + NATIVE_OLEAN + NATIVE_C + NATIVE_OBJ;\n" ++
  "                          collects non-empty plan-module .o (root .slake-native/<ModRel>.o +\n" ++
  "                          A31 A30-folded path-dep dep/.slake-native/<ModRel>.o) and runs host\n" ++
  "                          leanc -shared -o .slake-native/libslake_ir.so <objs…>;\n" ++
  "                          LEANC env or leanc on PATH (optional same-dir as LEAN);\n" ++
  "                          host leanc IR shared-lib link subset of plan-module objects +\n" ++
  "                          Lean runtime via leanc — not freestanding build TCB / not Lake\n" ++
  "                          lean_lib shared-object TCB / not CLAIMED / not full Lake shared\n" ++
  "                          facet; A13 NATIVE_LINK remains separate name-table SO\n" ++
  "                          (libslake_native.so); both SOs can coexist; with PLAN_ONLY still\n" ++
  "                          skips lake after olean+C+obj+IR link; without PLAN_ONLY/NATIVE_BUILD\n" ++
  "                          lake follows after IR link; with NATIVE_BUILD, skip-lake requires\n" ++
  "                          olean + C emit + object compile + IR link success (+ static\n" ++
  "                          archive when NATIVE_AR set) (+ executable link when NATIVE_EXE\n" ++
  "                          set) (+ name-table link when NATIVE_LINK set) (+ graph when\n" ++
  "                          NATIVE_GRAPH set) (+ seal when NATIVE_SEAL set); order olean →\n" ++
  "                          path-dep C → root C → path-dep obj → root obj → IR link → static\n" ++
  "                          archive → executable link → name-table link → graph → seal\n" ++
  "  SLAKE_NATIVE_IRLINK_STRICT=1  fail if leanc missing or a plan module .o is missing under\n" ++
  "                          NATIVE_IRLINK (default soft-skips missing leanc/obj with a warn;\n" ++
  "                          actual leanc nonzero exit is always fail-closed; empty/missing SO\n" ++
  "                          after claimed success is always fail-closed; NATIVE_BUILD+\n" ++
  "                          NATIVE_IRLINK also fail-closed on missing leanc / zero objs so\n" ++
  "                          skip-lake is not zero-work)\n" ++
  "  SLAKE_NATIVE_AR=1        host static archive of plan-module objects subset after native\n" ++
  "                          object compile (A22): implies plan + NATIVE_OLEAN + NATIVE_C +\n" ++
  "                          NATIVE_OBJ (does NOT imply NATIVE_IRLINK); collects non-empty\n" ++
  "                          plan-module .o (root .slake-native/<ModRel>.o + A31 A30-folded\n" ++
  "                          path-dep dep/.slake-native/<ModRel>.o) and runs host\n" ++
  "                          ar rcs .slake-native/libslake_ir.a <objs…>; AR env or ar on PATH;\n" ++
  "                          host static archive of plan-module objects subset via ar rcs —\n" ++
  "                          not freestanding build TCB / not Lake lean_lib static/shared facet\n" ++
  "                          / not CLAIMED / not linking Lean runtime into the archive (plain\n" ++
  "                          ar of module .o only; A21 leanc still the path that pulls runtime\n" ++
  "                          into SO); coexists with libslake_ir.so and libslake_native.so;\n" ++
  "                          with PLAN_ONLY still skips lake after olean+C+obj(+irlink)+ar;\n" ++
  "                          without PLAN_ONLY/NATIVE_BUILD lake follows after ar; with\n" ++
  "                          NATIVE_BUILD, skip-lake requires olean + C emit + object compile +\n" ++
  "                          static archive success (+ IR link when NATIVE_IRLINK set)\n" ++
  "                          (+ executable link when NATIVE_EXE set) (+ name-table link when\n" ++
  "                          NATIVE_LINK set) (+ graph when NATIVE_GRAPH set) (+ seal when\n" ++
  "                          NATIVE_SEAL set); order olean → path-dep C → root C → path-dep\n" ++
  "                          obj → root obj → IR link → static archive → executable link →\n" ++
  "                          name-table link → graph → seal\n" ++
  "  SLAKE_NATIVE_AR_STRICT=1 fail if ar missing or a plan module .o is missing under\n" ++
  "                          NATIVE_AR (default soft-skips missing ar/obj with a warn; actual\n" ++
  "                          ar nonzero exit is always fail-closed; empty/missing .a after\n" ++
  "                          claimed success is always fail-closed; NATIVE_BUILD+NATIVE_AR also\n" ++
  "                          fail-closed on missing ar / zero objs so skip-lake is not\n" ++
  "                          zero-work)\n" ++
  "  SLAKE_NATIVE_EXE=1       host leanc executable link subset of plan-module objects + stub\n" ++
  "                          main + Lean runtime via leanc after native object compile (A23):\n" ++
  "                          implies plan + NATIVE_OLEAN + NATIVE_C + NATIVE_OBJ (does NOT\n" ++
  "                          imply NATIVE_IRLINK or NATIVE_AR); writes generated stub main\n" ++
  "                          .slake-native/slake_native_main.c (returns 0 — not Lake lean_exe\n" ++
  "                          root / not freestanding app TCB) and runs host\n" ++
  "                          leanc -o .slake-native/slake_ir .slake-native/slake_native_main.c\n" ++
  "                          <objs…> (objs = root + A31 A30-folded path-dep .o); LEANC env or\n" ++
  "                          leanc on PATH (same resolve as A21);\n" ++
  "                          host leanc executable link subset of plan-module objects + stub\n" ++
  "                          main + Lean runtime via leanc — not freestanding build TCB / not\n" ++
  "                          Lake lean_exe / not Lake lean_lib shared facet / not CLAIMED / not\n" ++
  "                          a real application entry from lakefile; coexists with\n" ++
  "                          libslake_ir.so / libslake_ir.a / libslake_native.so; with PLAN_ONLY\n" ++
  "                          still skips lake after olean+C+obj(+irlink/+ar)+exe; without\n" ++
  "                          PLAN_ONLY/NATIVE_BUILD lake follows after exe; with NATIVE_BUILD,\n" ++
  "                          skip-lake requires olean + C emit + object compile + executable\n" ++
  "                          link success (+ IR link when NATIVE_IRLINK set) (+ static archive\n" ++
  "                          when NATIVE_AR set) (+ name-table link when NATIVE_LINK set)\n" ++
  "                          (+ graph when NATIVE_GRAPH set) (+ seal when NATIVE_SEAL set);\n" ++
  "                          order olean → path-dep C → root C → path-dep obj → root obj → IR\n" ++
  "                          link → static archive → executable link → name-table link → graph\n" ++
  "                          → seal\n" ++
  "  SLAKE_NATIVE_EXE_STRICT=1  fail if leanc missing or a plan module .o is missing under\n" ++
  "                          NATIVE_EXE (default soft-skips missing leanc/obj with a warn;\n" ++
  "                          actual leanc nonzero exit is always fail-closed; empty/missing\n" ++
  "                          binary after claimed success is always fail-closed; NATIVE_BUILD+\n" ++
  "                          NATIVE_EXE also fail-closed on missing leanc / zero objs so\n" ++
  "                          skip-lake is not zero-work)\n" ++
  "  SLAKE_NATIVE_LINK=1      host shared-lib link subset after native oleans (A13):\n" ++
  "                          implies plan + NATIVE_OLEAN; generates .slake-native/\n" ++
  "                          slake_native_export.c exporting slake_native_plan_modules\n" ++
  "                          (topo plan module names, skip package name) and runs host\n" ++
  "                          cc -shared -fPIC -o .slake-native/libslake_native.so;\n" ++
  "                          not Lake lean_lib shared-object of compiled Lean IR / not\n" ++
  "                          freestanding build TCB / not Lake shared-lib TCB / not CLAIMED;\n" ++
  "                          not IR link of NATIVE_OBJ .o (that is NATIVE_IRLINK);\n" ++
  "                          JOBS applies to olean only (link is sequential single cc);\n" ++
  "                          with PLAN_ONLY still skips lake after olean+link; without\n" ++
  "                          PLAN_ONLY/NATIVE_BUILD lake follows after link; with\n" ++
  "                          NATIVE_BUILD, skip-lake requires both olean and link success\n" ++
  "                          (+ graph write when NATIVE_GRAPH also set)\n" ++
  "                          (+ seal write when NATIVE_SEAL also set)\n" ++
  "  SLAKE_NATIVE_LINK_STRICT=1  fail if cc missing or link fails under NATIVE_LINK\n" ++
  "                          (default soft-skips missing cc with a warn; actual link\n" ++
  "                          failure is always fail-closed; NATIVE_BUILD+NATIVE_LINK also\n" ++
  "                          fail-closed on missing cc so skip-lake is not zero-work)\n" ++
  "  SLAKE_NATIVE_GRAPH=1     host package link graph subset after native oleans (A14):\n" ++
  "                          implies plan + NATIVE_OLEAN; after oleans (and after NATIVE_C /\n" ++
  "                          NATIVE_OBJ / NATIVE_IRLINK / NATIVE_AR / NATIVE_EXE / NATIVE_LINK when set) writes\n" ++
  "                          .slake-native/slake_native_graph (package line, module olean lines\n" ++
  "                          for plan modules with regular-file oleans, edge lines from A5\n" ++
  "                          plan-import edges, optional shared_lib when libslake_native.so\n" ++
  "                          exists, optional shared_lib_ir when libslake_ir.so exists, optional\n" ++
  "                          static_lib when libslake_ir.a exists, optional executable when\n" ++
  "                          slake_ir exists, summary counts); A32: A30-folded path-dep plan\n" ++
  "                          modules list package-cwd-relative olean paths (e.g.\n" ++
  "                          dep/.slake-native/Dep.olean; A29 sibling ../dep/…); A35: when\n" ++
  "                          plan-module .c files exist (root or A30-folded path-dep),\n" ++
  "                          distinct c_source <Mod> <package-cwd-relative path> lines\n" ++
  "                          (soft-omit missing .c); A34: when plan-module .o files exist\n" ++
  "                          (root or A30-folded path-dep), distinct object <Mod>\n" ++
  "                          <package-cwd-relative path> lines (soft-omit missing .o; not\n" ++
  "                          freestanding build TCB / not Lake lean_lib facet / not CLAIMED);\n" ++
  "                          always re-writes; not freestanding build TCB / not Lake build\n" ++
  "                          graph TCB / not Lake lean_lib SO / not CLAIMED; JOBS applies to\n" ++
  "                          olean only; graph IO failure always fail-closed; with PLAN_ONLY\n" ++
  "                          still skips lake after olean(+C/+obj/+irlink/+ar/+exe/+link)+graph;\n" ++
  "                          without PLAN_ONLY/NATIVE_BUILD lake follows; with NATIVE_BUILD,\n" ++
  "                          skip-lake requires olean (+C if set) (+obj if set) (+irlink if set)\n" ++
  "                          (+ar if set) (+exe if set) (+link if set) and graph write success (+ seal when\n" ++
  "                          NATIVE_SEAL also set)\n" ++
  "  SLAKE_NATIVE_GRAPH_STRICT=1  fail if graph cannot be produced under NATIVE_GRAPH\n" ++
  "                          (empty plan modules / no oleans present); default soft-skips those\n" ++
  "                          with a warn; graph write IO failure is always fail-closed;\n" ++
  "                          NATIVE_BUILD+NATIVE_GRAPH also fail-closed on empty graph so\n" ++
  "                          skip-lake is not zero-work\n" ++
  "  SLAKE_NATIVE_SEAL=1      host freestanding-adjacent product seal subset after native\n" ++
  "                          oleans (A15): implies plan + NATIVE_OLEAN; after oleans (and after\n" ++
  "                          NATIVE_C / NATIVE_OBJ / NATIVE_IRLINK / NATIVE_AR / NATIVE_EXE /\n" ++
  "                          NATIVE_LINK / NATIVE_GRAPH when set) writes .slake-native/slake_native_seal\n" ++
  "                          (package line, module olean_hash lines from sidecar or source\n" ++
  "                          FNV-1a 64, optional graph_hash of graph file bytes, optional\n" ++
  "                          shared_lib, optional shared_lib_ir, optional static_lib, optional\n" ++
  "                          executable, seal FNV-1a 64 digest over package + sorted olean_hash\n" ++
  "                          module lines + optional sorted c_hash module lines (A35) +\n" ++
  "                          optional sorted obj_hash module lines (A34) + optional graph_hash +\n" ++
  "                          optional shared_lib + optional shared_lib_ir + optional static_lib +\n" ++
  "                          optional executable, summary counts); A32: A30-folded path-dep plan\n" ++
  "                          modules contribute olean_hash from path-dep sidecar or source;\n" ++
  "                          A35: when plan-module .c files exist, module <Mod> c_hash <16-hex>\n" ++
  "                          (FNV-1a 64 of C file bytes; soft-omit missing .c; do not fail seal\n" ++
  "                          solely for zero C sources; folded into seal digest after sorted\n" ++
  "                          olean_hash lines, before obj_hash); A34: when plan-module .o files\n" ++
  "                          exist, module <Mod> obj_hash <16-hex> (FNV-1a 64 of object bytes;\n" ++
  "                          soft-omit missing .o; do not fail seal solely for zero objects;\n" ++
  "                          folded into seal digest after sorted c_hash lines); always\n" ++
  "                          re-writes; not freestanding build TCB / not Lake lean_lib SO / not\n" ++
  "                          Lake build graph TCB / not CLAIMED; JOBS applies to olean only;\n" ++
  "                          seal IO failure always fail-closed; with PLAN_ONLY still skips lake\n" ++
  "                          after olean(+C/+obj/+irlink/+ar/+exe/+link/graph)+seal; without\n" ++
  "                          PLAN_ONLY/NATIVE_BUILD lake follows; with NATIVE_BUILD, skip-lake\n" ++
  "                          requires olean (+C if set) (+obj if set) (+irlink if set) (+ar if\n" ++
  "                          set) (+exe if set) (+link if set) (+graph if set) and seal write\n" ++
  "                          success\n" ++
  "  SLAKE_NATIVE_SEAL_STRICT=1  fail if seal cannot be produced under NATIVE_SEAL\n" ++
  "                          (empty plan modules / no oleans / cannot hash); default soft-skips\n" ++
  "                          those with a warn; seal write IO failure is always fail-closed;\n" ++
  "                          NATIVE_BUILD+NATIVE_SEAL also fail-closed on empty seal so\n" ++
  "                          skip-lake is not zero-work\n" ++
  "  LEAN=/path/to/lean       host lean for NATIVE_CHECK / NATIVE_OLEAN / NATIVE_BUILD / NATIVE_C / NATIVE_OBJ / NATIVE_IRLINK / NATIVE_AR / NATIVE_EXE / NATIVE_LINK / NATIVE_GRAPH / NATIVE_SEAL\n" ++
  "                          (default: lean on PATH; relative LEAN is absolute-resolved\n" ++
  "                          against process cwd; must be a real lean: --version exit 0 +\n" ++
  "                          Lean marker; NATIVE_OBJ may also use lean --print-prefix;\n" ++
  "                          NATIVE_IRLINK / NATIVE_EXE may try sibling leanc when LEANC unset)\n" ++
  "  LEAN_INCLUDE=/path       direct -I path for NATIVE_OBJ (directory; overrides prefix)\n" ++
  "  LEAN_PREFIX=/path        Lean install prefix for NATIVE_OBJ include (<prefix>/include)\n" ++
  "  LEAN_SYSROOT=/path       alternate install root for NATIVE_OBJ include (same as PREFIX)\n" ++
  "  CC=/path/to/cc           host C compiler for NATIVE_OBJ / NATIVE_LINK (default: cc on PATH;\n" ++
  "                          relative CC is absolute-resolved against process cwd;\n" ++
  "                          probed with --version exit 0 + non-empty output + C\n" ++
  "                          toolchain marker (gcc/clang/cc/FSF/Apple LLVM/tcc);\n" ++
  "                          rejects /bin/true-style exit-0 fakes)\n" ++
  "  LEANC=/path/to/leanc    host leanc for NATIVE_IRLINK / NATIVE_EXE (default: leanc on PATH,\n" ++
  "                          else sibling of LEAN; relative LEANC absolute-resolved against\n" ++
  "                          process cwd; probed with --version exit 0 + C toolchain marker\n" ++
  "                          like CC; set-but-bad LEANC does not fall through to PATH)\n" ++
  "  AR=/path/to/ar           host archiver for NATIVE_AR (default: ar on PATH; relative AR\n" ++
  "                          absolute-resolved against process cwd; probed with --version or\n" ++
  "                          -V exit 0 + non-empty ar/binutils marker; set-but-bad AR does not\n" ++
  "                          fall through to PATH)\n" ++
  "  LAKE=/path/to/lake       absolute lake binary (required for FS_PROC paths)\n" ++
  "  FS_PROC child env is empty (not host-env inherit); classic path inherits.\n" ++
  "  PIPE path is demo/capture only — not full Lake IO redirect product.\n" ++
  "  clean rest: empty only on native and FS_PROC/PIPE (no Lake global rebinds).\n" ++
  "  Package plan uses import-scan DAG subset when edges exist, else declaration-order\n" ++
  "  chain; module paths resolve via package/per-lib srcDir + dotted Foo/Bar.lean\n" ++
  "  (flat root fallback); per-lib roots/srcDir + per-lib globs recursive multi-level\n" ++
  "  subset (depth-bounded; A24/A25) + nested/srcDir — not full Lake Glob / faceting /\n" ++
  "  package imports / not freestanding build TCB / not CLAIMED. A26: path [[require]]\n" ++
  "  name+safe relative path subset feeds LEAN_PATH and precompiles path-dep oleans\n" ++
  "  (depth-bounded; not git/url / not Lake resolve-deps / not freestanding build TCB /\n" ++
  "  not CLAIMED). A29: sibling confining path = \"../dep\" (one leading .. under\n" ++
  "  package-parent confining root; refuse multi-.. escape / bare .. / absolute — not\n" ++
  "  full Lake path require / not workspace walk-up). A30: package-transitive plan\n" ++
  "  subset (import-driven path-dep plan modules folded into root plan when root plan\n" ++
  "  modules import them — not Lake resolve-deps / not every dep plan module / not\n" ++
  "  freestanding build TCB / not CLAIMED). A31: freestanding-adjacent path-dep\n" ++
  "  plan-module C/OBJ into IR products subset (A30-folded path-dep modules only emit\n" ++
  "  lean -c / cc -c under dep/.slake-native/ and feed those .o into NATIVE_IRLINK /\n" ++
  "  NATIVE_AR / NATIVE_EXE — not Lake lean_lib shared facet / not freestanding build\n" ++
  "  TCB / not CLAIMED / not every dep plan module / not git/url). A32: freestanding-\n" ++
  "  adjacent path-dep plan-module nodes in NATIVE_GRAPH + NATIVE_SEAL subset (A30-\n" ++
  "  folded modules list package-cwd-relative olean paths in graph (under-pkg dep/…\n" ++
  "  or A29 sibling ../dep/…) and olean_hash in seal — not freestanding build TCB /\n" ++
  "  not Lake build graph TCB / not Lake resolve-deps / not CLAIMED / not every dep\n" ++
  "  plan module / not git/url / not multi-..). A35: freestanding-adjacent plan-\n" ++
  "  module C source inventory in NATIVE_GRAPH + NATIVE_SEAL (c_source <Mod> <relpath>\n" ++
  "  lines for regular-file plan-module .c under root or A30-folded path-dep\n" ++
  "  package-cwd-relative paths; seal module <Mod> c_hash FNV-1a 64 of .c bytes;\n" ++
  "  soft-omit missing .c; banners only when >=1 c_source/c_hash line — not\n" ++
  "  freestanding build TCB / not Lake lean_lib facet / not CLAIMED / not every dep\n" ++
  "  plan module / not changing C emit semantics). A34: freestanding-adjacent plan-\n" ++
  "  module object inventory in NATIVE_GRAPH + NATIVE_SEAL (object <Mod> <relpath>\n" ++
  "  lines for regular-file plan-module .o under root or A30-folded path-dep\n" ++
  "  package-cwd-relative paths; seal module <Mod> obj_hash FNV-1a 64 of .o bytes;\n" ++
  "  soft-omit missing .o; banners only when >=1 object/obj_hash line — not\n" ++
  "  freestanding build TCB / not Lake lean_lib facet / not CLAIMED / not every dep\n" ++
  "  plan module / not name-table SO). A33: path-require package\n" ++
  "  .slake-native wipe on CLAIMED clean (after root .lake/build + root .slake-native;\n" ++
  "  A26 under-pkg / A29 sibling confining; identity order; soft missing OK; symlink\n" ++
  "  fence; not git/url / not Lake resolve-deps / not multi-.. / not dep .lake/build /\n" ++
  "  not CLAIMED token expansion).\n" ++
  "  A27: path-dep → root olean cascade (path-dep-olean-newer on consumer imports of\n" ++
  "  path-dep plan modules; not freestanding build TCB / not CLAIMED). A28: path-dep\n" ++
  "  source-hash fold into A11 frozen deps <hex> (consumer path-dep imports; not Lake\n" ++
  "  package-transitive hash / not freestanding build TCB / not CLAIMED).\n" ++
  "  NATIVE_CHECK is thin sequential host lean only\n" ++
  "  (multi-module imports need oleans/LEAN_PATH). NATIVE_OLEAN is multi-module\n" ++
  "  host-lean + package-local olean LEAN_PATH + mtime/plan-edge cascade +\n" ++
  "  FNV-1a 64 source content-hash + plan-node transitive deps-hash sidecar subset\n" ++
  "  (default sequential; optional SLAKE_NATIVE_OLEAN_JOBS parallel ready-set waves) —\n" ++
  "  not lake-compatible build / not freestanding build TCB / not Lake shake/hash TCB /\n" ++
  "  not Lake job server TCB. NATIVE_BUILD is the product compile-without-lake path\n" ++
  "  (implies NATIVE_OLEAN). NATIVE_C is the host lean C-output emit subset after\n" ++
  "  oleans (implies NATIVE_OLEAN; not freestanding build TCB / not Lake lean_lib SO /\n" ++
  "  not object compile+link of Lean runtime). NATIVE_OBJ is the host object compile of\n" ++
  "  lean C subset after C emit (implies NATIVE_OLEAN + NATIVE_C; not freestanding build\n" ++
  "  TCB / not Lake lean_lib SO / not linking Lean runtime into SO). NATIVE_IRLINK is the\n" ++
  "  host leanc IR shared-lib link of plan-module objects + Lean runtime via leanc\n" ++
  "  (implies NATIVE_OLEAN + NATIVE_C + NATIVE_OBJ; libslake_ir.so — not freestanding build\n" ++
  "  TCB / not Lake lean_lib shared-object TCB / not CLAIMED). NATIVE_AR is the host static\n" ++
  "  archive of plan-module objects via ar rcs (implies NATIVE_OLEAN + NATIVE_C + NATIVE_OBJ;\n" ++
  "  does not imply IRLINK; libslake_ir.a — not freestanding build TCB / not Lake lean_lib\n" ++
  "  static/shared facet / not CLAIMED / not linking Lean runtime into the archive).\n" ++
  "  NATIVE_EXE is the host leanc executable link of plan-module objects + stub main + Lean\n" ++
  "  runtime via leanc (implies NATIVE_OLEAN + NATIVE_C + NATIVE_OBJ; does not imply IRLINK\n" ++
  "  or AR; .slake-native/slake_ir — not freestanding build TCB / not Lake lean_exe / not\n" ++
  "  CLAIMED / generated stub main not a real app entry).\n" ++
  "  NATIVE_LINK is the host shared-lib link subset after oleans (implies NATIVE_OLEAN;\n" ++
  "  name-table SO — not Lake lean_lib shared-object / not IR link of NATIVE_OBJ .o files).\n" ++
  "  NATIVE_GRAPH is the host package link graph artifact after oleans (implies\n" ++
  "  NATIVE_OLEAN; not freestanding build TCB / not Lake build graph TCB). NATIVE_SEAL\n" ++
  "  is the host freestanding-adjacent product seal after oleans (implies NATIVE_OLEAN;\n" ++
  "  not freestanding build TCB / not Lake lean_lib SO / not Lake build graph TCB).\n" ++
  "  Order: olean → path-dep C → root C → path-dep obj → root obj → IR link → static archive → executable link → name-table link → graph → seal.\n" ++
  "  Both NATIVE_CHECK+OLEAN → olean only (superset).\n" ++
  "\n" ++
  "Run from a package root (lakefile.toml / lakefile.lean). Walk-up skips bare\n" ++
  "monorepo `tests/` so clean cannot target the wrong package.\n" ++
  "Slake is a parallel tree under src/slake/; freestanding cores live in Systems.*\n" ++
  "This is not full Lake parity. See doc/dev/slake.md.\n"

/-- Result of pure command-token classification (messages only; IO is in `run`). -/
public inductive CmdResult where
  /-- Command recognized; `code` is process exit status (0 ok). -/
  | ok (code : UInt32) (msg : String)
  /-- Unknown / missing command. -/
  | err (code : UInt32) (msg : String)
  deriving Repr

/-- True when `p` contains `lakefile.toml` or `lakefile.lean`. -/
def hasLakefile (p : FilePath) : BaseIO Bool := do
  let toml ← (p / "lakefile.toml").pathExists
  if toml then return true
  (p / "lakefile.lean").pathExists

/-- True when `p` has at least one `*.lean` entry (non-recursive). -/
def hasLeanSources (p : FilePath) : BaseIO Bool := do
  match ← p.readDir.toBaseIO with
  | .ok ents => return ents.any fun e => e.fileName.endsWith ".lean"
  | .error _ => return false

/-- Accept package roots; reject monorepo `tests/` harness.

Any directory with a lakefile is a candidate **except** a directory whose
basename is exactly `tests` and which has no local `*.lean` sources. That
rejects lean4's monorepo `tests/lakefile.toml` (+ `lean-toolchain`) so walk-up
from `tests/slake` never binds the wrong package, while
`tests/slake/driver` (basename `driver`) and `basic_toml` (has `*.lean`) still
match. Prefer running from the package root. -/
public def isPackageRoot (p : FilePath) : BaseIO Bool := do
  unless ← hasLakefile p do
    return false
  match p.fileName with
  | some "tests" =>
    -- Monorepo harness only: require a local Lean source file at this level.
    hasLeanSources p
  | _ =>
    return true

/-- Walk up from `start` to the nearest plausible package root. -/
public partial def findPackageDir (start : FilePath) : BaseIO (Option FilePath) := do
  if ← isPackageRoot start then
    return some start
  match start.parent with
  | none => return none
  | some parent =>
    if parent == start then
      return none
    else
      findPackageDir parent

/-- True when env `name` is set to a truthy value (`1` / `true` / `yes` / `on`).

Used for `SLAKE_USE_FS_PROC`, `SLAKE_DEPGRAPH`, `SLAKE_FS_PROC_STRICT`, etc. -/
def envFlagTruthy (name : String) : BaseIO Bool := do
  match ← IO.getEnv name with
  | some v =>
    let v := v.trimAscii.toString.toLower
    pure (v == "1" || v == "true" || v == "yes" || v == "on")
  | none => pure false

/-- A12: parse `SLAKE_NATIVE_OLEAN_JOBS`.

Default / unset / empty / invalid / `0` → **1** (sequential; A8–A11 smokes unchanged).
`N ≥ 2` → ready-set wave parallelism (up to N concurrent host `lean -o`).
Not freestanding build TCB / not Lake job server TCB / not CLAIMED. -/
def parseNativeOleanJobs : IO Nat := do
  match ← IO.getEnv "SLAKE_NATIVE_OLEAN_JOBS" with
  | none => pure 1
  | some s =>
    let t := s.trimAscii.toString
    if t.isEmpty then pure 1
    else
      match t.toNat? with
      | some n => if n >= 1 then pure n else pure 1
      | none => pure 1

/-- `env`: cwd, package dir (safe walk-up), host TOML package identity, LEAN_PATH, FS_PROC/DEPGRAPH status. Always exits 0. -/
public def cmdEnv : IO UInt32 := do
  let cwd ← IO.currentDir
  IO.println s!"cwd: {cwd}"
  match ← findPackageDir cwd with
  | some pkg =>
    IO.println s!"package: {pkg}"
    let id ← Slake.Config.readPackageIdentity pkg
    IO.println (Slake.Config.formatIdentity id)
  | none =>
    IO.println "package: (not found; no plausible lakefile package in walk-up)"
  match ← IO.getEnv "LEAN_PATH" with
  | some lp =>
    IO.println s!"LEAN_PATH: {lp}"
  | none =>
    IO.println "LEAN_PATH: (unset)"
  let useFs ← envFlagTruthy "SLAKE_USE_FS_PROC"
  let usePipe ← envFlagTruthy "SLAKE_USE_FS_PROC_PIPE"
  let strict ← envFlagTruthy "SLAKE_FS_PROC_STRICT"
  let useDg ← envFlagTruthy "SLAKE_DEPGRAPH"
  let planOnly ← envFlagTruthy "SLAKE_PLAN_ONLY"
  let wantDemo ← envFlagTruthy "SLAKE_DEPGRAPH_DEMO"
  let nativeCheck ← envFlagTruthy "SLAKE_NATIVE_CHECK"
  let nativeStrict ← envFlagTruthy "SLAKE_NATIVE_CHECK_STRICT"
  let nativeOlean ← envFlagTruthy "SLAKE_NATIVE_OLEAN"
  let nativeOleanStrict ← envFlagTruthy "SLAKE_NATIVE_OLEAN_STRICT"
  let nativeOleanForce ← envFlagTruthy "SLAKE_NATIVE_OLEAN_FORCE"
  let nativeOleanJobs ← parseNativeOleanJobs
  let nativeBuild ← envFlagTruthy "SLAKE_NATIVE_BUILD"
  let nativeCFlag ← envFlagTruthy "SLAKE_NATIVE_C"
  let nativeCStrict ← envFlagTruthy "SLAKE_NATIVE_C_STRICT"
  let nativeObjFlag ← envFlagTruthy "SLAKE_NATIVE_OBJ"
  let nativeObjStrict ← envFlagTruthy "SLAKE_NATIVE_OBJ_STRICT"
  let nativeIrLink ← envFlagTruthy "SLAKE_NATIVE_IRLINK"
  let nativeIrLinkStrict ← envFlagTruthy "SLAKE_NATIVE_IRLINK_STRICT"
  let nativeAr ← envFlagTruthy "SLAKE_NATIVE_AR"
  let nativeArStrict ← envFlagTruthy "SLAKE_NATIVE_AR_STRICT"
  let nativeExe ← envFlagTruthy "SLAKE_NATIVE_EXE"
  let nativeExeStrict ← envFlagTruthy "SLAKE_NATIVE_EXE_STRICT"
  let nativeLink ← envFlagTruthy "SLAKE_NATIVE_LINK"
  let nativeLinkStrict ← envFlagTruthy "SLAKE_NATIVE_LINK_STRICT"
  let nativeGraph ← envFlagTruthy "SLAKE_NATIVE_GRAPH"
  let nativeGraphStrict ← envFlagTruthy "SLAKE_NATIVE_GRAPH_STRICT"
  let nativeSeal ← envFlagTruthy "SLAKE_NATIVE_SEAL"
  let nativeSealStrict ← envFlagTruthy "SLAKE_NATIVE_SEAL_STRICT"
  -- NATIVE_IRLINK / NATIVE_AR / NATIVE_EXE imply NATIVE_OBJ (need .o); NATIVE_OBJ implies NATIVE_C.
  -- NATIVE_AR / NATIVE_EXE do NOT imply IRLINK (static archive, executable, and IR link are independent).
  let nativeObj := nativeObjFlag || nativeIrLink || nativeAr || nativeExe
  let nativeC := nativeCFlag || nativeObj
  -- NATIVE_BUILD / NATIVE_C / NATIVE_OBJ / NATIVE_IRLINK / NATIVE_AR / NATIVE_EXE / NATIVE_LINK / NATIVE_GRAPH / NATIVE_SEAL imply NATIVE_OLEAN.
  let nativeOleanEff :=
    nativeOlean || nativeBuild || nativeC || nativeObj || nativeIrLink || nativeAr || nativeExe || nativeLink || nativeGraph || nativeSeal
  let linked := slakeFsProcLinked ()
  let pipeLinked := slakeFsProcPipeLinked ()
  let dgLinked := slakeFsDepgraphLinked ()
  IO.println s!"SLAKE_USE_FS_PROC: {if useFs then "1" else "0"}"
  IO.println s!"SLAKE_USE_FS_PROC_PIPE: {if usePipe then "1" else "0"}"
  IO.println s!"SLAKE_FS_PROC_STRICT: {if strict then "1" else "0"}"
  IO.println s!"SLAKE_FS_PROC_LINKED: {linked}"
  IO.println s!"SLAKE_FS_PROC_PIPE_LINKED: {pipeLinked}"
  IO.println s!"SLAKE_DEPGRAPH: {if useDg then "1" else "0"}"
  IO.println s!"SLAKE_PLAN_ONLY: {if planOnly then "1" else "0"}"
  IO.println s!"SLAKE_DEPGRAPH_DEMO: {if wantDemo then "1" else "0"}"
  IO.println s!"SLAKE_DEPGRAPH_LINKED: {dgLinked}"
  IO.println s!"SLAKE_NATIVE_CHECK: {if nativeCheck then "1" else "0"}"
  IO.println s!"SLAKE_NATIVE_CHECK_STRICT: {if nativeStrict then "1" else "0"}"
  IO.println s!"SLAKE_NATIVE_OLEAN: {if nativeOlean then "1" else "0"}"
  IO.println s!"SLAKE_NATIVE_OLEAN_STRICT: {if nativeOleanStrict then "1" else "0"}"
  IO.println s!"SLAKE_NATIVE_OLEAN_FORCE: {if nativeOleanForce then "1" else "0"}"
  IO.println s!"SLAKE_NATIVE_OLEAN_JOBS: {nativeOleanJobs}"
  IO.println s!"SLAKE_NATIVE_BUILD: {if nativeBuild then "1" else "0"}"
  IO.println s!"SLAKE_NATIVE_C: {if nativeCFlag then "1" else "0"}"
  IO.println s!"SLAKE_NATIVE_C_STRICT: {if nativeCStrict then "1" else "0"}"
  IO.println s!"SLAKE_NATIVE_OBJ: {if nativeObjFlag then "1" else "0"}"
  IO.println s!"SLAKE_NATIVE_OBJ_STRICT: {if nativeObjStrict then "1" else "0"}"
  IO.println s!"SLAKE_NATIVE_IRLINK: {if nativeIrLink then "1" else "0"}"
  IO.println s!"SLAKE_NATIVE_IRLINK_STRICT: {if nativeIrLinkStrict then "1" else "0"}"
  IO.println s!"SLAKE_NATIVE_AR: {if nativeAr then "1" else "0"}"
  IO.println s!"SLAKE_NATIVE_AR_STRICT: {if nativeArStrict then "1" else "0"}"
  IO.println s!"SLAKE_NATIVE_EXE: {if nativeExe then "1" else "0"}"
  IO.println s!"SLAKE_NATIVE_EXE_STRICT: {if nativeExeStrict then "1" else "0"}"
  IO.println s!"SLAKE_NATIVE_LINK: {if nativeLink then "1" else "0"}"
  IO.println s!"SLAKE_NATIVE_LINK_STRICT: {if nativeLinkStrict then "1" else "0"}"
  IO.println s!"SLAKE_NATIVE_GRAPH: {if nativeGraph then "1" else "0"}"
  IO.println s!"SLAKE_NATIVE_GRAPH_STRICT: {if nativeGraphStrict then "1" else "0"}"
  IO.println s!"SLAKE_NATIVE_SEAL: {if nativeSeal then "1" else "0"}"
  IO.println s!"SLAKE_NATIVE_SEAL_STRICT: {if nativeSealStrict then "1" else "0"}"
  if usePipe && pipeLinked == 1 then
    IO.println "slake env: FS_PROC_PIPE path active when building/testing/exe/lint/script/clean/update/pack/cache/unpack/query/shake/serve/upload/lean/scripts/setup-file/self-check/version-tags/translate-config/run/new/init/check-build/check-test/check-lint/exec/query-kind/resolve-deps/reservoir-config/upgrade (stdout capture demo)"
    IO.println "slake env: FS_PROC_PIPE child uses empty env (no inherit; freestanding honesty)"
  else if usePipe && strict then
    IO.println "slake env: FS_PROC_PIPE requested + STRICT; unlinked/shim fail will error (no fall back)"
  else if usePipe then
    IO.println "slake env: FS_PROC_PIPE requested but shim not linked (will fall back unless STRICT)"
  else if useFs && linked == 1 then
    IO.println "slake env: FS_PROC path active when building/testing/exe/lint/script/clean/update/pack/cache/unpack/query/shake/serve/upload/lean/scripts/setup-file/self-check/version-tags/translate-config/run/new/init/check-build/check-test/check-lint/exec/query-kind/resolve-deps/reservoir-config/upgrade"
    IO.println "slake env: FS_PROC child uses empty env (no inherit; freestanding honesty)"
  else if useFs && strict then
    IO.println "slake env: FS_PROC requested + STRICT; unlinked/shim fail will error (no fall back)"
  else if useFs then
    IO.println "slake env: FS_PROC requested but shim not linked (will fall back unless STRICT)"
  else
    IO.println "slake env: default path — build/test/exe/lint/script/update/pack/cache/unpack/query/shake/serve/upload/lean/scripts/setup-file/self-check/version-tags/translate-config/run/new/init/check-build/check-test/check-lint/exec/query-kind/resolve-deps/reservoir-config/upgrade use classic IO.Process (inherits host env); clean defaults to native wipe pkg/.lake/build + pkg/.slake-native + path-require dep .slake-native (not IO.Process; A17+A33 native product out dir wipe subset)"
  -- Package plan narrative (A3/A5/A6/A7/A8/A9/A10): Config identity + freestanding Kahn when linked
  -- (import-scan DAG subset when edges exist, else declaration-order chain;
  -- srcDir + dotted module path resolution subset). NATIVE_CHECK / NATIVE_OLEAN /
  -- NATIVE_BUILD imply plan. PLAN_ONLY / NATIVE_* alone still plan on build; do not
  -- claim "plan off" when set.
  if (useDg || planOnly || nativeCheck || nativeOleanEff) && dgLinked == 1 then
    IO.println "slake env: package-derived freestanding DepGraph plan active on build (Config name+targets/per-lib roots/globs; import-scan DAG subset when edges exist else declaration-order chain; package/per-lib srcDir + nested resolution subset; path [[require]] subset for LEAN_PATH/path-dep olean precompile (A26) + sibling confining ../path (A29 package-parent confining) + path-dep → root cascade (A27 path-dep-olean-newer) + path-dep source-hash fold into A11 deps-line (A28) + package-transitive plan subset (A30 import-driven — not git/url / not Lake resolve-deps / not multi-.. escape); not full Lake import resolution / faceting / full Glob / not build TCB)"
    if planOnly then
      IO.println "slake env: SLAKE_PLAN_ONLY=1 — print package plan and skip lake (exit 0)"
    else if useDg then
      IO.println "slake env: SLAKE_DEPGRAPH=1 — print package plan then lake"
    else if nativeBuild then
      IO.println "slake env: SLAKE_NATIVE_BUILD=1 — package plan print implied (topo order for freestanding-adjacent sequential native olean build)"
    else if nativeIrLink then
      IO.println "slake env: SLAKE_NATIVE_IRLINK=1 — package plan print implied (topo order for native olean + host lean C-output emit + host object compile + host leanc IR shared-lib link subset)"
    else if nativeAr then
      IO.println "slake env: SLAKE_NATIVE_AR=1 — package plan print implied (topo order for native olean + host lean C-output emit + host object compile + host static archive of plan-module objects subset)"
    else if nativeExe then
      IO.println "slake env: SLAKE_NATIVE_EXE=1 — package plan print implied (topo order for native olean + host lean C-output emit + host object compile + host leanc executable link subset)"
    else if nativeObj then
      IO.println "slake env: SLAKE_NATIVE_OBJ=1 — package plan print implied (topo order for native olean + host lean C-output emit + host object compile of lean C subset)"
    else if nativeC then
      IO.println "slake env: SLAKE_NATIVE_C=1 — package plan print implied (topo order for native olean + host lean C-output emit subset)"
    else if nativeLink then
      IO.println "slake env: SLAKE_NATIVE_LINK=1 — package plan print implied (topo order for native olean + host shared-lib link subset)"
    else if nativeGraph then
      IO.println "slake env: SLAKE_NATIVE_GRAPH=1 — package plan print implied (topo order for native olean + host package link graph subset)"
    else if nativeSeal then
      IO.println "slake env: SLAKE_NATIVE_SEAL=1 — package plan print implied (topo order for native olean + host freestanding-adjacent product seal subset)"
    else if nativeOlean then
      IO.println "slake env: SLAKE_NATIVE_OLEAN=1 — package plan print implied (topo order for multi-module sequential host-lean + olean)"
    else if nativeCheck then
      IO.println "slake env: SLAKE_NATIVE_CHECK=1 — package plan print implied (topo order for sequential host-lean typecheck)"
    if wantDemo then
      IO.println "slake env: SLAKE_DEPGRAPH_DEMO=1 — also print legacy demo C→B→A (not package parse)"
  else if (useDg || planOnly || nativeCheck || nativeOleanEff) && (planOnly || nativeCheck || nativeOleanEff) then
    -- Unlinked PLAN_ONLY / NATIVE_*: host Config plan (import-scan host Kahn when edges exist).
    if planOnly then
      IO.println "slake env: SLAKE_PLAN_ONLY=1 — host package plan on build (DEPGRAPH shim not linked; import-scan host Kahn when edges exist; package/per-lib srcDir + roots + globs recursive multi-level subset); skip lake"
    else if nativeBuild then
      IO.println "slake env: SLAKE_NATIVE_BUILD=1 — host package plan on build (DEPGRAPH shim not linked; topo order for freestanding-adjacent sequential native olean build)"
    else if nativeIrLink then
      IO.println "slake env: SLAKE_NATIVE_IRLINK=1 — host package plan on build (DEPGRAPH shim not linked; topo order for native olean + host lean C-output emit + host object compile + host leanc IR shared-lib link subset)"
    else if nativeAr then
      IO.println "slake env: SLAKE_NATIVE_AR=1 — host package plan on build (DEPGRAPH shim not linked; topo order for native olean + host lean C-output emit + host object compile + host static archive of plan-module objects subset)"
    else if nativeExe then
      IO.println "slake env: SLAKE_NATIVE_EXE=1 — host package plan on build (DEPGRAPH shim not linked; topo order for native olean + host lean C-output emit + host object compile + host leanc executable link subset)"
    else if nativeObj then
      IO.println "slake env: SLAKE_NATIVE_OBJ=1 — host package plan on build (DEPGRAPH shim not linked; topo order for native olean + host lean C-output emit + host object compile of lean C subset)"
    else if nativeC then
      IO.println "slake env: SLAKE_NATIVE_C=1 — host package plan on build (DEPGRAPH shim not linked; topo order for native olean + host lean C-output emit subset)"
    else if nativeLink then
      IO.println "slake env: SLAKE_NATIVE_LINK=1 — host package plan on build (DEPGRAPH shim not linked; topo order for native olean + host shared-lib link subset)"
    else if nativeGraph then
      IO.println "slake env: SLAKE_NATIVE_GRAPH=1 — host package plan on build (DEPGRAPH shim not linked; topo order for native olean + host package link graph subset)"
    else if nativeSeal then
      IO.println "slake env: SLAKE_NATIVE_SEAL=1 — host package plan on build (DEPGRAPH shim not linked; topo order for native olean + host freestanding-adjacent product seal subset)"
    else if nativeOlean then
      IO.println "slake env: SLAKE_NATIVE_OLEAN=1 — host package plan on build (DEPGRAPH shim not linked; topo order for multi-module sequential host-lean + olean)"
    else
      IO.println "slake env: SLAKE_NATIVE_CHECK=1 — host package plan on build (DEPGRAPH shim not linked; topo order for sequential host-lean typecheck)"
    if useDg then
      IO.println "slake env: SLAKE_DEPGRAPH=1 but shim not linked (freestanding plan soft-skipped)"
  else if useDg then
    IO.println "slake env: DEPGRAPH requested but shim not linked (freestanding plan soft-skipped; lake continues)"
  else
    IO.println "slake env: package plan print off (set SLAKE_DEPGRAPH=1 and/or SLAKE_PLAN_ONLY=1 and/or SLAKE_NATIVE_CHECK=1 and/or SLAKE_NATIVE_OLEAN=1 and/or SLAKE_NATIVE_BUILD=1 and/or SLAKE_NATIVE_C=1 and/or SLAKE_NATIVE_OBJ=1 and/or SLAKE_NATIVE_IRLINK=1 and/or SLAKE_NATIVE_AR=1 and/or SLAKE_NATIVE_EXE=1 and/or SLAKE_NATIVE_LINK=1 and/or SLAKE_NATIVE_GRAPH=1 and/or SLAKE_NATIVE_SEAL=1)"
  if nativeCheck then
    IO.println "slake env: SLAKE_NATIVE_CHECK=1 — thin sequential host-lean typecheck after plan (not freestanding build TCB / not olean orchestration / not CLAIMED)"
    if nativeStrict then
      IO.println "slake env: SLAKE_NATIVE_CHECK_STRICT=1 — fail if lean or a plan module file is missing"
    if planOnly && !nativeOleanEff then
      IO.println "slake env: PLAN_ONLY + NATIVE_CHECK — plan, sequential lean check, still skip lake"
    else if !nativeOleanEff then
      IO.println "slake env: NATIVE_CHECK without PLAN_ONLY — plan + lean check then lake"
  if nativeOleanEff then
    IO.println "slake env: SLAKE_NATIVE_OLEAN=1 — multi-module sequential host-lean + olean LEAN_PATH subset after plan (mtime + plan-edge cascade + FNV-1a 64 source content-hash sidecar + plan-node transitive deps-hash subset; default sequential; optional JOBS ready-set parallel waves; A26 path [[require]] LEAN_PATH + path-dep olean precompile + A29 sibling confining ../path (package-parent) + A27 path-dep → root olean cascade (path-dep-olean-newer) + A28 path-dep source-hash fold into A11 deps-line subset; not freestanding build TCB / not lake-equivalent TCB / not CLAIMED / not full olean graph invalidation / not Lake shake/hash TCB / not Lake package-transitive hash / not Lake job server TCB / not git/url require / not Lake resolve-deps / not multi-.. escape; A30 package-transitive plan subset when root plan modules import path-dep plan modules)"
    if nativeBuild && !nativeOlean && !nativeC && !nativeObj && !nativeIrLink && !nativeAr && !nativeExe && !nativeLink && !nativeGraph && !nativeSeal then
      IO.println "slake env: SLAKE_NATIVE_BUILD=1 implies NATIVE_OLEAN compile path"
    if nativeIrLink && !nativeOlean && !nativeBuild && !nativeObjFlag && !nativeCFlag then
      IO.println "slake env: SLAKE_NATIVE_IRLINK=1 implies NATIVE_OLEAN + NATIVE_C + NATIVE_OBJ compile paths"
    if nativeAr && !nativeOlean && !nativeBuild && !nativeObjFlag && !nativeCFlag && !nativeIrLink && !nativeExe then
      IO.println "slake env: SLAKE_NATIVE_AR=1 implies NATIVE_OLEAN + NATIVE_C + NATIVE_OBJ compile paths"
    if nativeExe && !nativeOlean && !nativeBuild && !nativeObjFlag && !nativeCFlag && !nativeIrLink && !nativeAr then
      IO.println "slake env: SLAKE_NATIVE_EXE=1 implies NATIVE_OLEAN + NATIVE_C + NATIVE_OBJ compile paths"
    if nativeObjFlag && !nativeOlean && !nativeBuild && !nativeCFlag && !nativeIrLink && !nativeAr && !nativeExe then
      IO.println "slake env: SLAKE_NATIVE_OBJ=1 implies NATIVE_OLEAN + NATIVE_C compile paths"
    if nativeCFlag && !nativeOlean && !nativeBuild then
      IO.println "slake env: SLAKE_NATIVE_C=1 implies NATIVE_OLEAN compile path"
    if nativeLink && !nativeOlean && !nativeBuild && !nativeC && !nativeObj && !nativeIrLink && !nativeAr && !nativeExe then
      IO.println "slake env: SLAKE_NATIVE_LINK=1 implies NATIVE_OLEAN compile path"
    if nativeGraph && !nativeOlean && !nativeBuild && !nativeC && !nativeObj && !nativeIrLink && !nativeAr && !nativeExe && !nativeLink then
      IO.println "slake env: SLAKE_NATIVE_GRAPH=1 implies NATIVE_OLEAN compile path"
    if nativeSeal && !nativeOlean && !nativeBuild && !nativeC && !nativeObj && !nativeIrLink && !nativeAr && !nativeExe && !nativeLink && !nativeGraph then
      IO.println "slake env: SLAKE_NATIVE_SEAL=1 implies NATIVE_OLEAN compile path"
    if nativeOleanStrict then
      IO.println "slake env: SLAKE_NATIVE_OLEAN_STRICT=1 — fail if lean or a plan module file is missing"
    if nativeOleanForce then
      IO.println "slake env: SLAKE_NATIVE_OLEAN_FORCE=1 — always rebuild all plan modules (ignore mtime/hash freshness)"
    if nativeOleanJobs >= 2 then
      IO.println s!"slake env: SLAKE_NATIVE_OLEAN_JOBS={nativeOleanJobs} — parallel host-lean olean wave subset (ready-set; up to {nativeOleanJobs} concurrent lean -o; not freestanding build TCB / not Lake job server TCB / not CLAIMED / not shared-lib link)"
    else
      IO.println "slake env: SLAKE_NATIVE_OLEAN_JOBS=1 — sequential host-lean olean (default; unset/invalid also sequential)"
    if nativeBuild then
      -- Fold NATIVE_IRLINK / NATIVE_AR / NATIVE_EXE / NATIVE_OBJ / NATIVE_C into LINK/GRAPH/SEAL primary
      -- cascade so skip-lake requirements match build orchestration (C + obj + IR/ar/exe before name-table link).
      let cascadeTag : String :=
        if nativeIrLink || nativeAr || nativeExe then
          (if nativeIrLink then " + NATIVE_IRLINK" else "") ++
            (if nativeAr then " + NATIVE_AR" else "") ++
            (if nativeExe then " + NATIVE_EXE" else "")
        else if nativeObj then " + NATIVE_OBJ"
        else if nativeC then " + NATIVE_C"
        else ""
      let cascadeMid : String :=
        if nativeIrLink || nativeAr || nativeExe then
          ", host lean C-output emit, host object compile of lean C" ++
            (if nativeIrLink then ", host leanc IR shared-lib link" else "") ++
            (if nativeAr then ", host static archive" else "") ++
            (if nativeExe then ", host leanc executable link" else "")
        else if nativeObj then ", host lean C-output emit, host object compile of lean C"
        else if nativeC then ", host lean C-output emit"
        else ""
      let cascadeSkipMid : String :=
        if nativeIrLink || nativeAr || nativeExe then
          " + C emit + object compile" ++
            (if nativeIrLink then " + IR link" else "") ++
            (if nativeAr then " + static archive" else "") ++
            (if nativeExe then " + executable link" else "")
        else if nativeObj then " + C emit + object compile"
        else if nativeC then " + C emit"
        else ""
      if nativeLink && nativeGraph then
        if nativeSeal then
          IO.println s!"slake env: NATIVE_BUILD{cascadeTag} + NATIVE_LINK + NATIVE_GRAPH + NATIVE_SEAL — plan, olean compile (JOBS applies){cascadeMid}, host shared-lib link, package link graph, product seal, skip lake only if olean{cascadeSkipMid} + link + graph + seal succeed (fail-closed on lean/cc/leanc/ar missing / zero work / compile/link/graph/seal fail — no lake fallback; freestanding-adjacent native olean + shared-lib link + package link graph + product seal subset — not freestanding build TCB / not Lake TCB / not Lake shared-lib TCB / not Lake build graph TCB / not CLAIMED)"
        else
          IO.println s!"slake env: NATIVE_BUILD{cascadeTag} + NATIVE_LINK + NATIVE_GRAPH — plan, olean compile (JOBS applies){cascadeMid}, host shared-lib link, package link graph, skip lake only if olean{cascadeSkipMid} + link + graph succeed (fail-closed on lean/cc/leanc/ar missing / zero work / compile/link/graph fail — no lake fallback; freestanding-adjacent native olean + shared-lib link + package link graph subset — not freestanding build TCB / not Lake TCB / not Lake shared-lib TCB / not Lake build graph TCB / not CLAIMED)"
      else if nativeLink then
        if nativeSeal then
          IO.println s!"slake env: NATIVE_BUILD{cascadeTag} + NATIVE_LINK + NATIVE_SEAL — plan, olean compile (JOBS applies){cascadeMid}, host shared-lib link, product seal, skip lake only if olean{cascadeSkipMid} + link + seal succeed (fail-closed on lean/cc/leanc/ar missing / zero work / compile/link/seal fail — no lake fallback; freestanding-adjacent native olean + shared-lib link + product seal subset — not freestanding build TCB / not Lake TCB / not Lake shared-lib TCB / not CLAIMED)"
        else if nativeOleanForce then
          IO.println s!"slake env: NATIVE_BUILD{cascadeTag} + NATIVE_LINK + FORCE — plan, olean compile (FORCE rebuilds all; JOBS applies){cascadeMid}, host shared-lib link, skip lake only if olean{cascadeSkipMid} + link succeed (fail-closed on lean/cc/leanc/ar missing / zero work / compile/link fail — no lake fallback; freestanding-adjacent native olean + shared-lib link subset — not freestanding build TCB / not Lake TCB / not Lake shared-lib TCB / not CLAIMED)"
        else
          IO.println s!"slake env: NATIVE_BUILD{cascadeTag} + NATIVE_LINK — plan, olean compile (skip fresh when mtime/plan-edge/hash/deps-hash allow; JOBS applies){cascadeMid}, host shared-lib link, skip lake only if olean{cascadeSkipMid} + link succeed (fail-closed on lean/cc/leanc/ar missing / zero work / compile/link fail — no lake fallback; freestanding-adjacent native olean + shared-lib link subset — not freestanding build TCB / not Lake TCB / not Lake shared-lib TCB / not CLAIMED)"
      else if nativeGraph then
        if nativeSeal then
          IO.println s!"slake env: NATIVE_BUILD{cascadeTag} + NATIVE_GRAPH + NATIVE_SEAL — plan, olean compile (JOBS applies){cascadeMid}, package link graph, product seal, skip lake only if olean{cascadeSkipMid} + graph + seal succeed (fail-closed on lean/leanc/ar missing / zero work / compile/graph/seal fail — no lake fallback; freestanding-adjacent native olean + package link graph + product seal subset — not freestanding build TCB / not Lake TCB / not Lake build graph TCB / not CLAIMED)"
        else
          IO.println s!"slake env: NATIVE_BUILD{cascadeTag} + NATIVE_GRAPH — plan, olean compile (JOBS applies){cascadeMid}, package link graph, skip lake only if olean{cascadeSkipMid} + graph succeed (fail-closed on lean/leanc/ar missing / zero work / compile/graph fail — no lake fallback; freestanding-adjacent native olean + package link graph subset — not freestanding build TCB / not Lake TCB / not Lake build graph TCB / not CLAIMED)"
      else if nativeSeal then
        IO.println s!"slake env: NATIVE_BUILD{cascadeTag} + NATIVE_SEAL — plan, olean compile (JOBS applies){cascadeMid}, product seal, skip lake only if olean{cascadeSkipMid} + seal succeed (fail-closed on lean/leanc/ar missing / zero work / compile/seal fail — no lake fallback; freestanding-adjacent native olean + product seal subset — not freestanding build TCB / not Lake TCB / not CLAIMED)"
      else if nativeIrLink || nativeAr || nativeExe then
        let cascadeTag2 : String :=
          (if nativeIrLink then " + NATIVE_IRLINK" else "") ++
            (if nativeAr then " + NATIVE_AR" else "") ++
            (if nativeExe then " + NATIVE_EXE" else "")
        let cascadeMid2 : String :=
          ", host lean C-output emit, host object compile of lean C" ++
            (if nativeIrLink then ", host leanc IR shared-lib link" else "") ++
            (if nativeAr then ", host static archive" else "") ++
            (if nativeExe then ", host leanc executable link" else "")
        let cascadeSkip2 : String :=
          " + C emit + object compile" ++
            (if nativeIrLink then " + IR link" else "") ++
            (if nativeAr then " + static archive" else "") ++
            (if nativeExe then " + executable link" else "")
        let tools2 : String :=
          "lean/cc" ++
            (if nativeIrLink || nativeExe then "/leanc" else "") ++
            (if nativeAr then "/ar" else "") ++
            "/include"
        let products2 : String :=
          if nativeIrLink && nativeAr && nativeExe then "host leanc IR shared-lib + host static archive + host leanc executable link subset"
          else if nativeIrLink && nativeAr then "host leanc IR shared-lib + host static archive subset"
          else if nativeIrLink && nativeExe then "host leanc IR shared-lib + host leanc executable link subset"
          else if nativeAr && nativeExe then "host static archive + host leanc executable link subset"
          else if nativeIrLink then "host leanc IR shared-lib link subset"
          else if nativeAr then "host static archive of plan-module objects subset"
          else "host leanc executable link subset of plan-module objects + stub main + Lean runtime via leanc"
        let honesty2 : String :=
          if nativeExe && !nativeIrLink && !nativeAr then
            "not freestanding build TCB / not Lake lean_exe / not CLAIMED"
          else if nativeAr && !nativeIrLink && !nativeExe then
            "not freestanding build TCB / not Lake lean_lib static/shared facet / not CLAIMED"
          else if nativeIrLink && !nativeAr && !nativeExe then
            "not freestanding build TCB / not Lake lean_lib shared-object TCB / not CLAIMED"
          else
            "not freestanding build TCB / not Lake lean_lib facet / not Lake lean_exe / not CLAIMED"
        if nativeOleanForce then
          IO.println s!"slake env: NATIVE_BUILD{cascadeTag2} + FORCE — plan, olean compile (FORCE rebuilds all; JOBS applies){cascadeMid2}, skip lake only if olean{cascadeSkip2} succeed (fail-closed on {tools2} missing / missing source/C/obj / zero or empty C/obj/product / compile/emit/cc/leanc/ar fail — no lake fallback; {products2} — {honesty2})"
        else
          IO.println s!"slake env: NATIVE_BUILD{cascadeTag2} — plan, olean compile (skip fresh when mtime/plan-edge/hash/deps-hash allow; JOBS applies){cascadeMid2}, skip lake only if olean{cascadeSkip2} succeed (fail-closed on {tools2} missing / missing source/C/obj / zero or empty C/obj/product / compile/emit/cc/leanc/ar fail — no lake fallback; {products2} — {honesty2})"
      else if nativeObj then
        if nativeOleanForce then
          IO.println "slake env: NATIVE_BUILD + NATIVE_OBJ + FORCE — plan, olean compile (FORCE rebuilds all; JOBS applies), host lean C-output emit, host object compile of lean C, skip lake only if olean + C emit + object compile succeed (fail-closed on lean/cc/include missing / missing source/C / zero or empty C/obj / compile/emit/cc fail — no lake fallback; host object compile of lean C subset — not freestanding build TCB / not Lake lean_lib SO / not CLAIMED)"
        else
          IO.println "slake env: NATIVE_BUILD + NATIVE_OBJ — plan, olean compile (skip fresh when mtime/plan-edge/hash/deps-hash allow; JOBS applies), host lean C-output emit, host object compile of lean C, skip lake only if olean + C emit + object compile succeed (fail-closed on lean/cc/include missing / missing source/C / zero or empty C/obj / compile/emit/cc fail — no lake fallback; host object compile of lean C subset — not freestanding build TCB / not Lake lean_lib SO / not CLAIMED)"
      else if nativeC then
        if nativeOleanForce then
          IO.println "slake env: NATIVE_BUILD + NATIVE_C + FORCE — plan, olean compile (FORCE rebuilds all; JOBS applies), host lean C-output emit, skip lake only if olean + C emit succeed (fail-closed on lean missing / missing source / zero or empty C / compile/emit fail — no lake fallback; host lean C-output emit subset — not freestanding build TCB / not Lake lean_lib SO / not CLAIMED)"
        else
          IO.println "slake env: NATIVE_BUILD + NATIVE_C — plan, olean compile (skip fresh when mtime/plan-edge/hash/deps-hash allow; JOBS applies), host lean C-output emit, skip lake only if olean + C emit succeed (fail-closed on lean missing / missing source / zero or empty C / compile/emit fail — no lake fallback; host lean C-output emit subset — not freestanding build TCB / not Lake lean_lib SO / not CLAIMED)"
      else if nativeOleanForce then
        IO.println "slake env: NATIVE_BUILD + FORCE — plan, olean compile (FORCE rebuilds all; JOBS applies), skip lake on success (fail-closed on lean missing / zero work / compile fail — no lake fallback; freestanding-adjacent native olean build subset — not freestanding build TCB / not Lake TCB / not CLAIMED)"
      else
        IO.println "slake env: NATIVE_BUILD — plan, olean compile (skip fresh when mtime/plan-edge/hash/deps-hash allow; JOBS applies), skip lake on success (fail-closed on lean missing / zero work / compile fail — no lake fallback; freestanding-adjacent native olean build subset — not freestanding build TCB / not Lake TCB / not CLAIMED)"
    else if planOnly then
      let cascadeTag : String :=
        if nativeIrLink || nativeAr || nativeExe then
          (if nativeIrLink then " + NATIVE_IRLINK" else "") ++
            (if nativeAr then " + NATIVE_AR" else "") ++
            (if nativeExe then " + NATIVE_EXE" else "")
        else if nativeObj then " + NATIVE_OBJ"
        else if nativeC then " + NATIVE_C"
        else ""
      let cascadeMid : String :=
        if nativeIrLink || nativeAr || nativeExe then
          ", host lean C-output emit, host object compile of lean C" ++
            (if nativeIrLink then ", host leanc IR shared-lib link" else "") ++
            (if nativeAr then ", host static archive" else "") ++
            (if nativeExe then ", host leanc executable link" else "")
        else if nativeObj then ", host lean C-output emit, host object compile of lean C"
        else if nativeC then ", host lean C-output emit"
        else ""
      if nativeLink && nativeGraph then
        if nativeSeal then
          IO.println s!"slake env: PLAN_ONLY + NATIVE_OLEAN{cascadeTag} + NATIVE_LINK + NATIVE_GRAPH + NATIVE_SEAL — plan, olean compile (JOBS applies){cascadeMid}, host shared-lib link, package link graph, product seal, still skip lake"
        else
          IO.println s!"slake env: PLAN_ONLY + NATIVE_OLEAN{cascadeTag} + NATIVE_LINK + NATIVE_GRAPH — plan, olean compile (JOBS applies){cascadeMid}, host shared-lib link, package link graph, still skip lake"
      else if nativeLink then
        if nativeSeal then
          IO.println s!"slake env: PLAN_ONLY + NATIVE_OLEAN{cascadeTag} + NATIVE_LINK + NATIVE_SEAL — plan, olean compile (JOBS applies){cascadeMid}, host shared-lib link, product seal, still skip lake"
        else if nativeOleanForce then
          IO.println s!"slake env: PLAN_ONLY + NATIVE_OLEAN{cascadeTag} + NATIVE_LINK + FORCE — plan, olean compile (FORCE rebuilds all; JOBS applies){cascadeMid}, host shared-lib link, still skip lake"
        else
          IO.println s!"slake env: PLAN_ONLY + NATIVE_OLEAN{cascadeTag} + NATIVE_LINK — plan, olean compile (skip fresh when mtime/plan-edge/hash/deps-hash allow; JOBS applies){cascadeMid}, host shared-lib link, still skip lake"
      else if nativeGraph then
        if nativeSeal then
          IO.println s!"slake env: PLAN_ONLY + NATIVE_OLEAN{cascadeTag} + NATIVE_GRAPH + NATIVE_SEAL — plan, olean compile (JOBS applies){cascadeMid}, package link graph, product seal, still skip lake"
        else
          IO.println s!"slake env: PLAN_ONLY + NATIVE_OLEAN{cascadeTag} + NATIVE_GRAPH — plan, olean compile (JOBS applies){cascadeMid}, package link graph, still skip lake"
      else if nativeSeal then
        IO.println s!"slake env: PLAN_ONLY + NATIVE_OLEAN{cascadeTag} + NATIVE_SEAL — plan, olean compile (JOBS applies){cascadeMid}, product seal, still skip lake"
      else if nativeIrLink || nativeAr || nativeExe then
        if nativeOleanForce then
          IO.println s!"slake env: PLAN_ONLY + NATIVE_OLEAN{cascadeTag} + FORCE — plan, olean compile (FORCE rebuilds all; JOBS applies){cascadeMid}, still skip lake"
        else
          IO.println s!"slake env: PLAN_ONLY + NATIVE_OLEAN{cascadeTag} — plan, olean compile{cascadeMid}, still skip lake"
      else if nativeObj then
        if nativeOleanForce then
          IO.println "slake env: PLAN_ONLY + NATIVE_OLEAN + NATIVE_OBJ + FORCE — plan, olean compile (FORCE rebuilds all; JOBS applies), host lean C-output emit, host object compile of lean C, still skip lake"
        else
          IO.println "slake env: PLAN_ONLY + NATIVE_OLEAN + NATIVE_OBJ — plan, olean compile, host lean C-output emit, host object compile of lean C, still skip lake"
      else if nativeC then
        if nativeOleanForce then
          IO.println "slake env: PLAN_ONLY + NATIVE_OLEAN + NATIVE_C + FORCE — plan, olean compile (FORCE rebuilds all; JOBS applies), host lean C-output emit, still skip lake"
        else
          IO.println "slake env: PLAN_ONLY + NATIVE_OLEAN + NATIVE_C — plan, olean compile, host lean C-output emit, still skip lake"
      else if nativeOleanForce then
        IO.println "slake env: PLAN_ONLY + NATIVE_OLEAN + FORCE — plan, olean compile (FORCE rebuilds all; JOBS applies), still skip lake"
      else
        IO.println "slake env: PLAN_ONLY + NATIVE_OLEAN — plan, olean compile (skip fresh when mtime/plan-edge/hash/deps-hash allow; JOBS applies), still skip lake"
    else if nativeLink then
      if nativeGraph then
        if nativeSeal then
          IO.println "slake env: NATIVE_LINK + NATIVE_GRAPH + NATIVE_SEAL without PLAN_ONLY — plan + olean compile (JOBS applies) + host shared-lib link + package link graph + product seal then lake"
        else if nativeOleanForce then
          IO.println "slake env: NATIVE_LINK + NATIVE_GRAPH + FORCE without PLAN_ONLY — plan + olean compile (FORCE rebuilds all; JOBS applies) + host shared-lib link + package link graph then lake"
        else
          IO.println "slake env: NATIVE_LINK + NATIVE_GRAPH without PLAN_ONLY — plan + olean compile (skip fresh when mtime/plan-edge/hash/deps-hash allow; JOBS applies) + host shared-lib link + package link graph then lake"
      else if nativeSeal then
        IO.println "slake env: NATIVE_LINK + NATIVE_SEAL without PLAN_ONLY — plan + olean compile (JOBS applies) + host shared-lib link + product seal then lake"
      else if nativeOleanForce then
        IO.println "slake env: NATIVE_LINK + FORCE without PLAN_ONLY — plan + olean compile (FORCE rebuilds all; JOBS applies) + host shared-lib link then lake"
      else
        IO.println "slake env: NATIVE_LINK without PLAN_ONLY — plan + olean compile (skip fresh when mtime/plan-edge/hash/deps-hash allow; JOBS applies) + host shared-lib link then lake"
    else if nativeGraph then
      if nativeSeal then
        IO.println "slake env: NATIVE_GRAPH + NATIVE_SEAL without PLAN_ONLY — plan + olean compile (JOBS applies) + package link graph + product seal then lake"
      else
        IO.println "slake env: NATIVE_GRAPH without PLAN_ONLY — plan + olean compile (JOBS applies) + package link graph then lake"
    else if nativeSeal then
      IO.println "slake env: NATIVE_SEAL without PLAN_ONLY — plan + olean compile (JOBS applies) + product seal then lake"
    else if nativeOleanForce then
      IO.println "slake env: NATIVE_OLEAN + FORCE without PLAN_ONLY — plan + olean compile (FORCE rebuilds all; JOBS applies) then lake"
    else
      IO.println "slake env: NATIVE_OLEAN without PLAN_ONLY — plan + olean compile (skip fresh when mtime/plan-edge/hash/deps-hash allow; JOBS applies) then lake"
  if nativeCFlag || (nativeC && !nativeObj) then
    IO.println "slake env: SLAKE_NATIVE_C=1 — host lean C-output emit subset after native oleans (.slake-native/<ModRel>.c via lean -c; same LEAN_PATH as olean; A31 freestanding-adjacent path-dep plan-module C/OBJ into IR products subset when A30-folded path-dep plan nodes present — not freestanding build TCB / not Lake lean_lib shared-object of compiled Lean IR / not full object compile+link of Lean runtime / not CLAIMED)"
    if nativeCStrict then
      IO.println "slake env: SLAKE_NATIVE_C_STRICT=1 — fail if lean missing or a plan module source is missing"
    -- Conjunction honesty when cascade above did not name NATIVE_C (e.g. LINK/GRAPH/SEAL
    -- branches, or NATIVE_C alone already printed NATIVE_BUILD + NATIVE_C). Always state
    -- skip-lake / PLAN_ONLY conjunction so env identity does not lag build orchestration.
    if nativeBuild && !nativeObj then
      IO.println "slake env: NATIVE_BUILD + NATIVE_C — skip lake only if olean + host lean C-output emit succeed (+ obj when NATIVE_OBJ set) (+ IR link when NATIVE_IRLINK set) (+ static archive when NATIVE_AR set) (+ executable link when NATIVE_EXE set) (+ link when NATIVE_LINK set) (+ graph when NATIVE_GRAPH set) (+ seal when NATIVE_SEAL set); fail-closed on lean missing / missing source / zero or empty C (not freestanding build TCB / not Lake lean_lib SO / not CLAIMED)"
    else if planOnly && !nativeObj then
      IO.println "slake env: PLAN_ONLY + NATIVE_C — plan, olean compile, host lean C-output emit, still skip lake"
  -- OBJ flag (or effective OBJ without IRLINK/AR/EXE): print A20 honesty; when only IRLINK/AR/EXE is set,
  -- those blocks below cover the full olean→C→obj→… chain without duplicating OBJ banners.
  if nativeObjFlag || (nativeObj && !nativeIrLink && !nativeAr && !nativeExe) then
    IO.println "slake env: SLAKE_NATIVE_OBJ=1 — host object compile of lean C subset after native C emit (.slake-native/<ModRel>.o via cc -c -fPIC -I<leanInclude>; implies NATIVE_C; A31 freestanding-adjacent path-dep plan-module C/OBJ into IR products subset when A30-folded path-dep plan nodes present — not freestanding build TCB / not Lake lean_lib shared-object of compiled Lean IR / not linking Lean runtime into SO / not CLAIMED)"
    if nativeObjStrict then
      IO.println "slake env: SLAKE_NATIVE_OBJ_STRICT=1 — fail if cc/include missing or a plan module .c is missing"
    if nativeBuild && !nativeIrLink && !nativeAr && !nativeExe then
      IO.println "slake env: NATIVE_BUILD + NATIVE_OBJ — skip lake only if olean + host lean C-output emit + host object compile succeed (+ IR link when NATIVE_IRLINK set) (+ static archive when NATIVE_AR set) (+ executable link when NATIVE_EXE set) (+ link when NATIVE_LINK set — still name-table SO) (+ graph when NATIVE_GRAPH set) (+ seal when NATIVE_SEAL set); fail-closed on lean/cc/include missing / missing source/C / zero or empty C/obj (not freestanding build TCB / not Lake lean_lib SO / not CLAIMED)"
    else if planOnly && !nativeIrLink && !nativeAr && !nativeExe then
      IO.println "slake env: PLAN_ONLY + NATIVE_OBJ — plan, olean compile, host lean C-output emit, host object compile of lean C, still skip lake"
  if nativeIrLink then
    IO.println "slake env: SLAKE_NATIVE_IRLINK=1 — host leanc IR shared-lib link subset of plan-module objects + Lean runtime via leanc (.slake-native/libslake_ir.so via leanc -shared; implies NATIVE_OLEAN + NATIVE_C + NATIVE_OBJ; A31 freestanding-adjacent path-dep plan-module C/OBJ into IR products subset when A30-folded path-dep plan nodes present — not freestanding build TCB / not Lake lean_lib shared-object TCB / not CLAIMED / not full Lake shared facet; A13 NATIVE_LINK remains separate name-table SO)"
    if nativeIrLinkStrict then
      IO.println "slake env: SLAKE_NATIVE_IRLINK_STRICT=1 — fail if leanc missing or plan-module .o missing or IR link fails"
    if nativeBuild then
      IO.println "slake env: NATIVE_BUILD + NATIVE_IRLINK — skip lake only if olean + host lean C-output emit + host object compile + host leanc IR shared-lib link succeed (+ static archive when NATIVE_AR set) (+ executable link when NATIVE_EXE set) (+ link when NATIVE_LINK set — still name-table SO) (+ graph when NATIVE_GRAPH set) (+ seal when NATIVE_SEAL set); fail-closed on lean/cc/leanc/include missing / missing source/C/obj / zero or empty C/obj/SO (not freestanding build TCB / not Lake lean_lib shared-object TCB / not CLAIMED)"
    else if planOnly then
      IO.println "slake env: PLAN_ONLY + NATIVE_IRLINK — plan, olean compile, host lean C-output emit, host object compile of lean C, host leanc IR shared-lib link, still skip lake"
  if nativeAr then
    IO.println "slake env: SLAKE_NATIVE_AR=1 — host static archive of plan-module objects subset via ar rcs (.slake-native/libslake_ir.a via ar rcs; implies NATIVE_OLEAN + NATIVE_C + NATIVE_OBJ; does not imply NATIVE_IRLINK; A31 freestanding-adjacent path-dep plan-module C/OBJ into IR products subset when A30-folded path-dep plan nodes present — not freestanding build TCB / not Lake lean_lib static/shared facet / not CLAIMED / not linking Lean runtime into the archive; A21 leanc still the path that pulls runtime into SO; A13 NATIVE_LINK remains separate name-table SO)"
    if nativeArStrict then
      IO.println "slake env: SLAKE_NATIVE_AR_STRICT=1 — fail if ar missing or plan-module .o missing or static archive fails"
    if nativeBuild then
      IO.println "slake env: NATIVE_BUILD + NATIVE_AR — skip lake only if olean + host lean C-output emit + host object compile + host static archive succeed (+ IR link when NATIVE_IRLINK set) (+ executable link when NATIVE_EXE set) (+ link when NATIVE_LINK set — still name-table SO) (+ graph when NATIVE_GRAPH set) (+ seal when NATIVE_SEAL set); fail-closed on lean/cc/ar/include missing / missing source/C/obj / zero or empty C/obj/archive (not freestanding build TCB / not Lake lean_lib static/shared facet / not CLAIMED)"
    else if planOnly then
      IO.println "slake env: PLAN_ONLY + NATIVE_AR — plan, olean compile, host lean C-output emit, host object compile of lean C, host static archive, still skip lake"
  if nativeExe then
    IO.println "slake env: SLAKE_NATIVE_EXE=1 — host leanc executable link subset of plan-module objects + stub main + Lean runtime via leanc (.slake-native/slake_ir via leanc -o + generated stub main; implies NATIVE_OLEAN + NATIVE_C + NATIVE_OBJ; does not imply NATIVE_IRLINK or NATIVE_AR; A31 freestanding-adjacent path-dep plan-module C/OBJ into IR products subset when A30-folded path-dep plan nodes present — not freestanding build TCB / not Lake lean_exe / not Lake lean_lib shared facet / not CLAIMED / not a real application entry from lakefile; generated stub main not Lake lean_exe root)"
    if nativeExeStrict then
      IO.println "slake env: SLAKE_NATIVE_EXE_STRICT=1 — fail if leanc missing or plan-module .o missing or executable link fails"
    if nativeBuild then
      IO.println "slake env: NATIVE_BUILD + NATIVE_EXE — skip lake only if olean + host lean C-output emit + host object compile + host leanc executable link succeed (+ IR link when NATIVE_IRLINK set) (+ static archive when NATIVE_AR set) (+ link when NATIVE_LINK set — still name-table SO) (+ graph when NATIVE_GRAPH set) (+ seal when NATIVE_SEAL set); fail-closed on lean/cc/leanc/include missing / missing source/C/obj / zero or empty C/obj/binary (not freestanding build TCB / not Lake lean_exe / not CLAIMED)"
    else if planOnly then
      IO.println "slake env: PLAN_ONLY + NATIVE_EXE — plan, olean compile, host lean C-output emit, host object compile of lean C, host leanc executable link, still skip lake"
  if nativeLink then
    IO.println "slake env: SLAKE_NATIVE_LINK=1 — host shared-lib link subset after native oleans (.slake-native/libslake_native.so via cc -shared -fPIC; exports slake_native_plan_modules; not Lake lean_lib shared-object / not freestanding build TCB / not Lake shared-lib TCB / not CLAIMED; not IR link of NATIVE_OBJ .o — that is NATIVE_IRLINK; not static archive — that is NATIVE_AR; not executable link — that is NATIVE_EXE)"
    if nativeLinkStrict then
      IO.println "slake env: SLAKE_NATIVE_LINK_STRICT=1 — fail if cc missing or link fails"
  if nativeGraph then
    IO.println "slake env: SLAKE_NATIVE_GRAPH=1 — host package link graph subset after native oleans (.slake-native/slake_native_graph; plan modules with oleans + A5 import edges + optional shared_lib + optional shared_lib_ir + optional static_lib + optional executable; A32 freestanding-adjacent path-dep plan-module nodes in NATIVE_GRAPH subset when A30-folded path-dep plan nodes present — package-cwd-relative olean paths (under-pkg dep/… or A29 sibling ../dep/…); A35 freestanding-adjacent plan-module C source inventory in NATIVE_GRAPH when plan-module .c files exist (c_source <Mod> package-cwd-relative path; root or A30-folded path-dep; soft-omit missing; banners only when ≥1 c_source line); A34 freestanding-adjacent plan-module object inventory in NATIVE_GRAPH when plan-module .o files exist (object <Mod> package-cwd-relative path; root or A30-folded path-dep; soft-omit missing; banners only when ≥1 object line); not freestanding build TCB / not Lake build graph TCB / not Lake lean_lib SO / not Lake resolve-deps / not CLAIMED / not every dep plan module / not git/url / not multi-..)"
    if nativeGraphStrict then
      IO.println "slake env: SLAKE_NATIVE_GRAPH_STRICT=1 — fail if graph cannot be produced (empty modules / no oleans)"
  if nativeSeal then
    IO.println "slake env: SLAKE_NATIVE_SEAL=1 — host freestanding-adjacent product seal subset after native oleans (.slake-native/slake_native_seal; module olean_hash + optional graph_hash + optional shared_lib + optional shared_lib_ir + optional static_lib + optional executable + seal digest; A32 freestanding-adjacent path-dep plan-module nodes in NATIVE_SEAL subset when A30-folded path-dep plan nodes present — path-dep olean_hash from sidecar/source; A35 freestanding-adjacent plan-module C source inventory in NATIVE_SEAL when plan-module .c files exist (module <Mod> c_hash FNV-1a 64 of .c bytes; soft-omit missing; do not fail seal solely for zero C sources; banners only when ≥1 c_hash line; folded into seal digest after olean_hash, before obj_hash); A34 freestanding-adjacent plan-module object inventory in NATIVE_SEAL when plan-module .o files exist (module <Mod> obj_hash FNV-1a 64 of .o bytes; soft-omit missing; do not fail seal solely for zero objects; banners only when ≥1 obj_hash line); not freestanding build TCB / not Lake lean_lib SO / not Lake build graph TCB / not Lake resolve-deps / not CLAIMED / not every dep plan module / not git/url / not multi-..)"
    if nativeSealStrict then
      IO.println "slake env: SLAKE_NATIVE_SEAL_STRICT=1 — fail if seal cannot be produced (empty modules / no oleans / cannot hash)"
  -- A33 clean hygiene honesty (always true for CLAIMED clean; not an env flag).
  IO.println "slake env: A33 path-require package .slake-native wipe on clean (after root .lake/build + root .slake-native; A26 under-pkg / A29 sibling confining; identity order; soft missing OK; symlink fence; not git/url / not Lake resolve-deps / not multi-.. / not dep .lake/build / not CLAIMED token expansion)"
  if nativeOleanEff && nativeCheck then
    IO.println "slake env: NATIVE_OLEAN + NATIVE_CHECK — olean path wins (superset); thin NATIVE_CHECK typecheck skipped on build"
  IO.println "slake env: OK (classic host driver)"
  return 0

/-- True when `p` exists and is a symlink (lstat; does not follow final component).

Missing path → `false`. Stat error → `none`. -/
def pathIsSymlink (p : FilePath) : IO (Option Bool) := do
  match ← p.symlinkMetadata.toBaseIO with
  | .error _ =>
    -- Missing is not a symlink fence hit (caller decides absence policy).
    if ← p.pathExists then
      -- Exists but metadata failed (race / permission).
      return none
    else
      return some false
  | .ok st =>
    return some (st.type == .symlink)

/-- A26/A33: true when `p` is a real directory for path-require (not missing, not
symlink, not a regular file). Best-effort `lstat` fence (same residual as A17/A25
— TOCTOU; not fd/`O_NOFOLLOW`). Shared by LEAN_PATH root collection and A33
path-require `.slake-native` wipe. -/
def isRealPathRequireDir (p : FilePath) : IO Bool := do
  match ← pathIsSymlink p with
  | none =>
    -- Stat failed while path exists, or missing: treat as not a usable dir.
    pure false
  | some true =>
    -- Refuse symlink roots (escape residual; A25/A17 style).
    pure false
  | some false =>
    if !(← p.pathExists) then pure false
    else p.isDir

/-- Remove package `.lake/build` only if neither `.lake` nor `.lake/build` is a symlink.

Intermediate-symlink fence: check each component with `symlinkMetadata` before
`removeDirAll` so a symlink at `pkg/.lake` → foreign tree does not bypass a
final-only check.

**Residual honesty (TOCTOU):** this is a best-effort `lstat` fence, not an
fd-based `O_NOFOLLOW` open. A concurrent replace of `.lake` between the
symlink checks and `removeDirAll` can still redirect removal. Full atomic
intermediate-symlink fence is larger than the W69 DepGraph work; do not claim
complete race-free protection.

Returns `some true` when removed, `some false` when absent/skipped, `none` on error. -/
def tryRemoveBuildDir (pkg : FilePath) : IO (Option Bool) := do
  let lakeDir := pkg / ".lake"
  let buildDir := lakeDir / "build"
  -- Fence `.lake` first (intermediate component).
  match ← pathIsSymlink lakeDir with
  | none =>
    IO.eprintln s!"slake clean: failed to stat {lakeDir}"
    return none
  | some true =>
    IO.eprintln s!"slake clean: refuse symlink path {lakeDir}"
    return none
  | some false => pure ()
  -- Fence final `.lake/build`.
  match ← pathIsSymlink buildDir with
  | none =>
    IO.eprintln s!"slake clean: failed to stat {buildDir}"
    return none
  | some true =>
    IO.eprintln s!"slake clean: refuse symlink path {buildDir}"
    return none
  | some false => pure ()
  if !(← buildDir.pathExists) then
    return some false
  match ← buildDir.symlinkMetadata.toBaseIO with
  | .error e =>
    IO.eprintln s!"slake clean: failed to stat {buildDir}: {e}"
    return none
  | .ok st =>
    if st.type != .dir then
      IO.eprintln s!"slake clean: skip non-directory {buildDir}"
      return some false
    try
      IO.FS.removeDirAll buildDir
      IO.println s!"slake clean: removed {buildDir}"
      return some true
    catch e =>
      IO.eprintln s!"slake clean: failed to remove {buildDir}: {e}"
      return none

/-- Remove package-local `.slake-native` if present and not a symlink (A17).

Same best-effort `lstat` symlink fence as `tryRemoveBuildDir` (TOCTOU residual;
not fd/`O_NOFOLLOW`). Missing path → `some false` (OK). Symlink / stat/remove
error → `none`. Regular directory → `removeDirAll` → `some true`.

Honesty: native product out dir wipe subset — not full Lake clean set, not
freestanding build TCB expansion beyond hygiene. -/
def tryRemoveSlakeNativeDir (pkg : FilePath) : IO (Option Bool) := do
  let nativeDir := pkg / ".slake-native"
  match ← pathIsSymlink nativeDir with
  | none =>
    IO.eprintln s!"slake clean: failed to stat {nativeDir}"
    return none
  | some true =>
    IO.eprintln s!"slake clean: refuse symlink path {nativeDir}"
    return none
  | some false => pure ()
  if !(← nativeDir.pathExists) then
    return some false
  match ← nativeDir.symlinkMetadata.toBaseIO with
  | .error e =>
    IO.eprintln s!"slake clean: failed to stat {nativeDir}: {e}"
    return none
  | .ok st =>
    if st.type != .dir then
      IO.eprintln s!"slake clean: skip non-directory {nativeDir}"
      return some false
    try
      IO.FS.removeDirAll nativeDir
      IO.println s!"slake clean: removed {nativeDir}"
      return some true
    catch e =>
      IO.eprintln s!"slake clean: failed to remove {nativeDir}: {e}"
      return none

/-- A33: wipe path-require packages' `.slake-native/` after root clean (product hygiene).

Walks identity `pathRequires` in order (stable). For each entry:
- resolve with A26/A29 `resolveRequirePath` (under-pkg or sibling `../…` under
  package parent; refuse absolute / multi-`..` / mid-path `..` / bare `..`);
- require dep package path is a **real directory** (lstat fence — soft-skip
  missing/symlink/file when deciding wipe targets, same soft policy as A26
  LEAN_PATH root collection);
- wipe `dep/.slake-native` via `tryRemoveSlakeNativeDir` (same symlink fence as
  A17 root — refuse + `none` when `.slake-native` is a symlink).

Soft missing dep `.slake-native` is OK. **Not** git/url require wipe / **not**
Lake resolve-deps clean of every workspace package / **not** multi-`..` walk-up /
**not** wiping dep `.lake/build` (only freestanding-adjacent `.slake-native`) /
**not** CLAIMED token expansion (clean behavior growth within CLAIMED).

Returns `some true` if any path-dep `.slake-native` was removed, `some false`
when none removed (no path requires or all soft-absent), `none` on hard fence
error (e.g. symlink `.slake-native`). -/
def wipePathRequireSlakeNativeDirs (pkg : FilePath) : IO (Option Bool) := do
  let id ← Slake.Config.readPackageIdentity pkg
  let rec go (rs : List Slake.Config.RequireIdentity) (anyRemoved : Bool)
      : IO (Option Bool) := do
    match rs with
    | [] => pure (some anyRemoved)
    | r :: rest =>
      match Slake.Config.resolveRequirePath pkg r with
      | none => go rest anyRemoved
      | some depPkg =>
        -- Real-dir fence on the dep package itself (soft-skip non-dirs; A26 helper).
        if !(← isRealPathRequireDir depPkg) then
          go rest anyRemoved
        else
          match ← tryRemoveSlakeNativeDir depPkg with
          | none => return none
          | some true =>
            -- Log only when something was actually removed (soft-missing is silent OK).
            IO.println s!"slake clean: A33 path-require wiped under {depPkg} (path-require package .slake-native; not git/url / not Lake resolve-deps / not multi-.. / not dep .lake/build)"
            go rest true
          | some false => go rest anyRemoved
  go (Slake.Config.pathRequires id) false

/-- Resolve `lake` executable name (`$LAKE` or `lake` on PATH). -/
def lakeCmd : BaseIO String := do
  match ← IO.getEnv "LAKE" with
  | some c => pure c
  | none => pure "lake"

/-- True when `p` exists and metadata reports a regular file (not a directory).

Used before treating a PATH hit as `lakeAbs`. Non-file paths fail closed here;
`execve` would also fail later. -/
def pathIsRegularFile (p : FilePath) : BaseIO Bool := do
  match ← p.metadata.toBaseIO with
  | .ok st => pure (st.type == .file)
  | .error _ => pure false

/-- Resolve a **true absolute** path to `lake` for freestanding `execve` (no PATH search).

Must complete **before** any FS_PROC `chdir(pkg)` (pack/cache/unpack/query/shake/serve/upload/lean/scripts/setup-file/self-check/version-tags/translate-config/run/new/init/check-build/check-test/check-lint/exec/query-kind/resolve-deps/reservoir-config/upgrade dual residual): relative
`$LAKE` hits like `./lake` or `bin/lake` (and relative PATH entries) are joined to the
**pre-chdir** cwd so `execve` still targets the same image after chdir.

Prefers absolute `$LAKE` (`FilePath.isAbsolute` / leading `/`); otherwise relative
path-with-separator resolved against cwd; otherwise searches `$PATH` for the basename
(each hit made absolute against cwd when the PATH entry is relative).
Requires a regular file; directories / missing paths fail closed before `execve`.
Does **not** treat mere presence of `/` as absolute (BUG-1 / S2). -/
def resolveLakeAbs : IO (Option String) := do
  let cand ← lakeCmd
  let asAbsFile (p : FilePath) : IO (Option String) := do
    let abs : FilePath ←
      if p.isAbsolute then pure p
      else do
        let cwd ← IO.currentDir
        pure (cwd / p)
    if ← pathIsRegularFile abs then return some abs.toString else return none
  let candP : FilePath := cand
  if candP.isAbsolute then
    return (← asAbsFile candP)
  -- Relative path containing a separator (e.g. ./lake, bin/lake) — not PATH basename.
  if cand.any (fun c => c == '/' || c == '\\') then
    return (← asAbsFile candP)
  match ← IO.getEnv "PATH" with
  | none => return none
  | some path =>
    for dir in path.splitOn ":" do
      if dir.isEmpty then continue
      let p : FilePath := dir / cand
      match ← asAbsFile p with
      | some s => return some s
      | none => pure ()
    return none

/-- Spawn failure sentinel from `slake_fs_run_lake_build` (`0xFFFFFFFF`). -/
def fsSpawnFail : UInt32 := 0xffffffff

/-- Wait failure sentinel from shim (`0xFFFFFFFE`); distinct from spawn fail / 8-bit exit. -/
def fsWaitFail : UInt32 := 0xfffffffe


/-- Forward `cmd :: rest` to `lake` via classic `IO.Process` (fixed argv array; no shell).

W85 argv plumbing: remaining tokens after the slake command are appended so
`slake build foo` → `lake build foo`, `slake exe bar --baz` → `lake exe bar --baz`,
etc. Child inherits host env. Not FS_PROC. Outside CLAIMED parity unless the
command is itself in CLAIMED (`build` and `test` among IO.Process forwards;
`clean`/`env` use dedicated paths). -/
def cmdLakeForwardIoProcess (label : String) (pkg : FilePath) (lake : String)
    (cmd : String) (rest : List String) : IO UInt32 := do
  let args := #[cmd] ++ rest.toArray
  let shown := " ".intercalate args.toList
  IO.println s!"slake {label}: classic host driver; delegating to `{lake} {shown}` in {pkg}"
  IO.println "  (IO.Process path; inherits host env; remaining argv plumbed; not FS_PROC — residual honesty)"
  let child ← IO.Process.spawn {
    cmd := lake
    args := args
    cwd := some pkg
  }
  let code ← child.wait
  if code == 0 then
    IO.println s!"slake {label}: OK (via lake / IO.Process)"
  else
    IO.eprintln s!"slake {label}: lake exited {code}"
  return code

/-- Same as `cmdLakeForwardIoProcess` but for bootstrap cmds (`new`/`init`) with explicit cwd. -/
def cmdLakeForwardIoProcessCwd (label : String) (cwd : FilePath) (lake : String)
    (cmd : String) (rest : List String) : IO UInt32 := do
  let args := #[cmd] ++ rest.toArray
  let shown := " ".intercalate args.toList
  IO.println s!"slake {label}: classic host driver; delegating to `{lake} {shown}` in {cwd}"
  IO.println "  (IO.Process path; cwd bootstrap; remaining argv plumbed; not FS_PROC — residual honesty)"
  let child ← IO.Process.spawn {
    cmd := lake
    args := args
    cwd := some cwd
  }
  let code ← child.wait
  if code == 0 then
    IO.println s!"slake {label}: OK (via lake / IO.Process)"
  else
    IO.eprintln s!"slake {label}: lake exited {code}"
  return code

/-- Classic `IO.Process` → `lake build` (+ remaining argv) in `pkg`.

W85: rest tokens plumbed on classic path. W86: FS_PROC/PIPE also plumb rest. -/
def cmdBuildIoProcess (pkg : FilePath) (lake : String) (rest : List String := []) : IO UInt32 := do
  let args := #["build"] ++ rest.toArray
  let shown := " ".intercalate args.toList
  IO.println s!"slake build: classic host driver; delegating to `{lake} {shown}` in {pkg}"
  IO.println "  (IO.Process path; inherits host env; remaining argv plumbed; set SLAKE_USE_FS_PROC=1 for freestanding Systems.Proc)"
  let child ← IO.Process.spawn {
    cmd := lake
    args := args
    cwd := some pkg
  }
  let code ← child.wait
  if code == 0 then
    IO.println "slake build: OK (via lake / IO.Process)"
  else
    IO.eprintln s!"slake build: lake exited {code}"
  return code


/-- Classic `IO.Process` → `lake test` in `pkg` (W71 parity growth).

Same host path as `cmdBuildIoProcess`. W87: optional FS_PROC/PIPE path also available. -/
def cmdTestIoProcess (pkg : FilePath) (lake : String) (rest : List String := []) : IO UInt32 := do
  cmdLakeForwardIoProcess "test" pkg lake "test" rest

/-- Freestanding Proc multi-arg path (`lake --dir=<pkg> test [rest…]`).

Child env is **empty** (freestanding `execve` honesty — not a host-env clone).
Returns process exit `0…255`, `fsSpawnFail`, or `fsWaitFail`. W87 FS_PROC test. -/
def cmdTestFsProc (pkg : FilePath) (lakeAbs : String) (rest : List String := []) : IO UInt32 := do
  let restA := rest.toArray
  let shown := " ".intercalate ("test" :: rest)
  IO.println s!"slake test: SLAKE_USE_FS_PROC=1; freestanding Systems.Proc multi-arg"
  IO.println s!"  lake={lakeAbs} --dir={pkg} {shown}"
  IO.println "  (FS_PROC child env empty — does not inherit host LEAN_PATH/PATH)"
  let code := slakeFsRunLakeTest pkg.toString lakeAbs restA
  if code == fsSpawnFail then
    IO.eprintln "slake test: freestanding Proc spawn failed"
    return code
  if code == fsWaitFail then
    IO.eprintln "slake test: freestanding Proc wait failed"
    return code
  if code == 0 then
    IO.println "slake test: OK (via lake / Systems.Proc)"
  else
    IO.eprintln s!"slake test: lake exited {code} (Systems.Proc)"
  return code

/-- Freestanding Proc **pipe** path for `lake test` (stdout capture demo). W87. -/
def cmdTestFsProcPipe (pkg : FilePath) (lakeAbs : String) (rest : List String := []) : IO UInt32 := do
  let restA := rest.toArray
  let shown := " ".intercalate ("test" :: rest)
  IO.println s!"slake test: SLAKE_USE_FS_PROC_PIPE=1; freestanding Systems.Proc pipe/stdio"
  IO.println s!"  lake={lakeAbs} --dir={pkg} {shown}"
  IO.println "  (FS_PROC_PIPE stdout→parent pipe capture demo; child env empty)"
  IO.println "  (not full Lake IO redirect product — residual honesty)"
  let code := slakeFsRunLakeTestPipe pkg.toString lakeAbs restA
  if code == fsSpawnFail then
    IO.eprintln "slake test: freestanding Proc pipe spawn failed"
    return code
  if code == fsWaitFail then
    IO.eprintln "slake test: freestanding Proc pipe wait failed"
    return code
  if code == 0 then
    IO.println "slake test: OK (via lake / Systems.Proc pipe)"
  else
    IO.eprintln s!"slake test: lake exited {code} (Systems.Proc pipe)"
  return code

/-- `test`: CLAIMED classic-host path — delegate to `lake test` in the package dir.

CLAIMED partial semantics: exit 0 via `lake test` (package test driver); not freestanding TCB;
**not** full Lake test semantics. Default: `IO.Process` → `lake test` (parity green without
extract). With `SLAKE_USE_FS_PROC_PIPE=1` / `SLAKE_USE_FS_PROC=1`: freestanding Proc paths
(W87; same flags/STRICT/empty-child-env honesty as `build`). -/
public def cmdTest (rest : List String := []) : IO UInt32 := do
  let cwd ← IO.currentDir
  let pkg ← match ← findPackageDir cwd with
    | some p => pure p
    | none =>
      IO.eprintln "slake test: no package root found (plausible lakefile walk-up)"
      return 1
  let lake ← lakeCmd
  let usePipe ← envFlagTruthy "SLAKE_USE_FS_PROC_PIPE"
  let useFs ← envFlagTruthy "SLAKE_USE_FS_PROC"
  let strict ← envFlagTruthy "SLAKE_FS_PROC_STRICT"
  if !usePipe && !useFs then
    return (← cmdTestIoProcess pkg lake rest)
  let linked := slakeFsProcLinked ()
  let pipeLinked := slakeFsProcPipeLinked ()
  let wantPipe := usePipe
  let pathLinked := if wantPipe then pipeLinked else linked
  let pathName := if wantPipe then "FS_PROC_PIPE" else "FS_PROC"
  if pathLinked != 1 then
    if strict then
      IO.eprintln s!"slake test: SLAKE_USE_{pathName}=1 + STRICT but {pathName} shim not linked"
      return 1
    IO.eprintln s!"slake test: SLAKE_USE_{pathName}=1 but {pathName} shim not linked; falling back"
    return (← cmdTestIoProcess pkg lake rest)
  match ← resolveLakeAbs with
  | none =>
    IO.eprintln s!"slake test: cannot resolve absolute lake path for {pathName} (set LAKE=/abs/path)"
    if strict then
      IO.eprintln "slake test: SLAKE_FS_PROC_STRICT=1; not falling back"
      return 1
    IO.eprintln "slake test: falling back to IO.Process"
    return (← cmdTestIoProcess pkg lake rest)
  | some lakeAbs =>
    let code ← if wantPipe then cmdTestFsProcPipe pkg lakeAbs rest else cmdTestFsProc pkg lakeAbs rest
    if code == fsSpawnFail then
      if strict then
        IO.eprintln s!"slake test: SLAKE_FS_PROC_STRICT=1; not falling back after {pathName} spawn fail"
        return 1
      IO.eprintln s!"slake test: falling back to IO.Process after {pathName} spawn fail"
      return (← cmdTestIoProcess pkg lake rest)
    if code == fsWaitFail then
      IO.eprintln s!"slake test: {pathName} wait fail (no IO.Process fall back)"
      return 1
    return code

/-- Classic `IO.Process` → `lake script` in `pkg` (W72 parity growth).

Thin forward; remaining argv after the command token is plumbed (W85).
Same host path as `cmdTestIoProcess`; not CLAIMED parity. -/
def cmdScriptIoProcess (pkg : FilePath) (lake : String) (rest : List String := []) : IO UInt32 := do
  cmdLakeForwardIoProcess "script" pkg lake "script" rest

/-- Freestanding Proc multi-arg path (`lake --dir=<pkg> script [rest…]`).

Child env is **empty** (freestanding `execve` honesty — not a host-env clone).
Returns process exit `0…255`, `fsSpawnFail`, or `fsWaitFail`. W90 FS_PROC script. -/
def cmdScriptFsProc (pkg : FilePath) (lakeAbs : String) (rest : List String := []) : IO UInt32 := do
  let restA := rest.toArray
  let shown := " ".intercalate ("script" :: rest)
  IO.println s!"slake script: SLAKE_USE_FS_PROC=1; freestanding Systems.Proc multi-arg"
  IO.println s!"  lake={lakeAbs} --dir={pkg} {shown}"
  IO.println "  (FS_PROC child env empty — does not inherit host LEAN_PATH/PATH)"
  let code := slakeFsRunLakeScript pkg.toString lakeAbs restA
  if code == fsSpawnFail then
    IO.eprintln "slake script: freestanding Proc spawn failed"
    return code
  if code == fsWaitFail then
    IO.eprintln "slake script: freestanding Proc wait failed"
    return code
  if code == 0 then
    IO.println "slake script: OK (via lake / Systems.Proc)"
  else
    IO.eprintln s!"slake script: lake exited {code} (Systems.Proc)"
  return code

/-- Freestanding Proc **pipe** path for `lake script` (stdout capture demo). W90. -/
def cmdScriptFsProcPipe (pkg : FilePath) (lakeAbs : String) (rest : List String := []) : IO UInt32 := do
  let restA := rest.toArray
  let shown := " ".intercalate ("script" :: rest)
  IO.println s!"slake script: SLAKE_USE_FS_PROC_PIPE=1; freestanding Systems.Proc pipe/stdio"
  IO.println s!"  lake={lakeAbs} --dir={pkg} {shown}"
  IO.println "  (FS_PROC_PIPE stdout→parent pipe capture demo; child env empty)"
  IO.println "  (not full Lake IO redirect product — residual honesty)"
  let code := slakeFsRunLakeScriptPipe pkg.toString lakeAbs restA
  if code == fsSpawnFail then
    IO.eprintln "slake script: freestanding Proc pipe spawn failed"
    return code
  if code == fsWaitFail then
    IO.eprintln "slake script: freestanding Proc pipe wait failed"
    return code
  if code == 0 then
    IO.println "slake script: OK (via lake / Systems.Proc pipe)"
  else
    IO.eprintln s!"slake script: lake exited {code} (Systems.Proc pipe)"
  return code

/-- `script`: classic-host MVP — delegate to `lake script` in the package dir.

Default: `IO.Process` → `lake script` (parity green without extract).
With `SLAKE_USE_FS_PROC_PIPE=1` / `SLAKE_USE_FS_PROC=1`: freestanding Proc paths
(W90; same flags/STRICT/empty-child-env honesty as `build`/`test`/`exe`/`lint`). **Not** in CLAIMED
parity slice. **Not** full Lake parity. -/
public def cmdScript (rest : List String := []) : IO UInt32 := do
  let cwd ← IO.currentDir
  let pkg ← match ← findPackageDir cwd with
    | some p => pure p
    | none =>
      IO.eprintln "slake script: no package root found (plausible lakefile walk-up)"
      return 1
  let lake ← lakeCmd
  let usePipe ← envFlagTruthy "SLAKE_USE_FS_PROC_PIPE"
  let useFs ← envFlagTruthy "SLAKE_USE_FS_PROC"
  let strict ← envFlagTruthy "SLAKE_FS_PROC_STRICT"
  if !usePipe && !useFs then
    return (← cmdScriptIoProcess pkg lake rest)
  let linked := slakeFsProcLinked ()
  let pipeLinked := slakeFsProcPipeLinked ()
  let wantPipe := usePipe
  let pathLinked := if wantPipe then pipeLinked else linked
  let pathName := if wantPipe then "FS_PROC_PIPE" else "FS_PROC"
  if pathLinked != 1 then
    if strict then
      IO.eprintln s!"slake script: SLAKE_USE_{pathName}=1 + STRICT but {pathName} shim not linked"
      return 1
    IO.eprintln s!"slake script: SLAKE_USE_{pathName}=1 but {pathName} shim not linked; falling back"
    return (← cmdScriptIoProcess pkg lake rest)
  match ← resolveLakeAbs with
  | none =>
    IO.eprintln s!"slake script: cannot resolve absolute lake path for {pathName} (set LAKE=/abs/path)"
    if strict then
      IO.eprintln "slake script: SLAKE_FS_PROC_STRICT=1; not falling back"
      return 1
    IO.eprintln "slake script: falling back to IO.Process"
    return (← cmdScriptIoProcess pkg lake rest)
  | some lakeAbs =>
    let code ← if wantPipe then cmdScriptFsProcPipe pkg lakeAbs rest else cmdScriptFsProc pkg lakeAbs rest
    if code == fsSpawnFail then
      if strict then
        IO.eprintln s!"slake script: SLAKE_FS_PROC_STRICT=1; not falling back after {pathName} spawn fail"
        return 1
      IO.eprintln s!"slake script: falling back to IO.Process after {pathName} spawn fail"
      return (← cmdScriptIoProcess pkg lake rest)
    if code == fsWaitFail then
      IO.eprintln s!"slake script: {pathName} wait fail (no IO.Process fall back)"
      return 1
    return code

/-- Native clean: remove package `.lake/build` and `.slake-native` (default CLAIMED path).

Semantics (A17 + A33): wipe `pkg/.lake/build` **and** package-local `pkg/.slake-native`
when present, then wipe each path-require package’s `.slake-native/` (A26 under-pkg /
A29 sibling confining; identity order; soft missing OK; symlink fence) —
**native product out dir wipe subset**, not full Lake `clean` (which may remove
more workspace artifacts). Non-empty rest is refused by `cmdClean` before this
runs (native has no Lake global rebind surface).

**TOCTOU residual (pre-existing):** `tryRemoveBuildDir` / `tryRemoveSlakeNativeDir`
are best-effort lstat fences before `removeDirAll`, not fd-based `O_NOFOLLOW`
opens. Concurrent replace of a fenced path between checks and removal can still
redirect wipe. -/
def cmdCleanNative (pkg : FilePath) : IO UInt32 := do
  let buildR ← tryRemoveBuildDir pkg
  let nativeR ← tryRemoveSlakeNativeDir pkg
  -- A33: after root wipe, path-require dep .slake-native (identity order).
  let pathDepR ← wipePathRequireSlakeNativeDirs pkg
  match buildR, nativeR, pathDepR with
  | none, _, _ => return 1
  | _, none, _ => return 1
  | _, _, none => return 1
  | some true, _, _ =>
    IO.println "slake clean: OK"
    return 0
  | _, some true, _ =>
    IO.println "slake clean: OK"
    return 0
  | _, _, some true =>
    IO.println "slake clean: OK"
    return 0
  | some false, some false, some false =>
    IO.println "slake clean: nothing to clean"
    return 0

/-- Freestanding Proc multi-arg path (`lake --dir=<pkg> clean` — **empty rest only**).

Child env is **empty** (freestanding `execve` honesty — not a host-env clone).
Returns process exit `0…255`, `fsSpawnFail`, or `fsWaitFail`. W91 FS_PROC clean.
CLAIMED is `(build clean env test)`; freestanding path delegates to `lake clean`
(Lake clean semantics — may wipe more than native `.lake/build` only).
Empty rest is enforced in `cmdClean` so Lake globals cannot rebind the wipe. -/
def cmdCleanFsProc (pkg : FilePath) (lakeAbs : String) : IO UInt32 := do
  let restA : Array String := #[]
  IO.println s!"slake clean: SLAKE_USE_FS_PROC=1; freestanding Systems.Proc multi-arg"
  IO.println s!"  lake={lakeAbs} --dir={pkg} clean"
  IO.println "  (FS_PROC child env empty — does not inherit host LEAN_PATH/PATH)"
  IO.println "  (empty rest only — no Lake global rebinds on clean)"
  let code := slakeFsRunLakeClean pkg.toString lakeAbs restA
  if code == fsSpawnFail then
    IO.eprintln "slake clean: freestanding Proc spawn failed"
    return code
  if code == fsWaitFail then
    IO.eprintln "slake clean: freestanding Proc wait failed"
    return code
  if code == 0 then
    IO.println "slake clean: OK (via lake / Systems.Proc)"
  else
    IO.eprintln s!"slake clean: lake exited {code} (Systems.Proc)"
  return code

/-- Freestanding Proc **pipe** path for `lake clean` (stdout capture demo; empty rest only). W91. -/
def cmdCleanFsProcPipe (pkg : FilePath) (lakeAbs : String) : IO UInt32 := do
  let restA : Array String := #[]
  IO.println s!"slake clean: SLAKE_USE_FS_PROC_PIPE=1; freestanding Systems.Proc pipe/stdio"
  IO.println s!"  lake={lakeAbs} --dir={pkg} clean"
  IO.println "  (FS_PROC_PIPE stdout→parent pipe capture demo; child env empty)"
  IO.println "  (empty rest only — no Lake global rebinds on clean)"
  IO.println "  (not full Lake IO redirect product — residual honesty)"
  let code := slakeFsRunLakeCleanPipe pkg.toString lakeAbs restA
  if code == fsSpawnFail then
    IO.eprintln "slake clean: freestanding Proc pipe spawn failed"
    return code
  if code == fsWaitFail then
    IO.eprintln "slake clean: freestanding Proc pipe wait failed"
    return code
  if code == 0 then
    IO.println "slake clean: OK (via lake / Systems.Proc pipe)"
  else
    IO.eprintln s!"slake clean: lake exited {code} (Systems.Proc pipe)"
  return code

/-- `clean`: dual residual — native wipe `pkg/.lake/build` + `.slake-native` (+ A33
path-require dep `.slake-native`) vs FS_PROC → `lake clean` then same native wipe set
(A17 + A33).

**Native (default):** remove package `.lake/build` and package-local
`.slake-native/` when present, then each path-require package’s `.slake-native/`
(A26/A29 confining; identity order). Bare package `build/` is **not** removed
(broader than Lake and unsafe for unrelated trees). Non-empty rest is **refused**
(clear error) — native has no argv surface for Lake globals.

**FS_PROC / PIPE:** with `SLAKE_USE_FS_PROC_PIPE=1` / `SLAKE_USE_FS_PROC=1`,
freestanding Proc paths (W91; same flags/empty-child-env honesty as peers), then
always attempt the native root + path-require `.slake-native` wipe set so
freestanding-adjacent products do not leak after dual residual clean. **Empty rest
only** so `--dir`/`-d`/`--file`/… cannot rebind the wipe target. Lake `clean` may
remove a wider workspace set than native `.lake/build` only — documented dual
residual, not a bug. STRICT refuses fall-back to native wipe on unlinked/spawn
fail; non-STRICT fall-back is native (still empty-rest gated). CLAIMED is
`(build clean env test)` — A17/A33 is semantic growth of clean within CLAIMED,
not a new token. -/
public def cmdClean (rest : List String := []) : IO UInt32 := do
  -- Empty-rest-only on both native and FS_PROC/PIPE (security envelope).
  if !rest.isEmpty then
    IO.eprintln "slake clean: non-empty rest refused (empty rest only; no Lake global rebinds)"
    return 1
  let cwd ← IO.currentDir
  let pkg ← match ← findPackageDir cwd with
    | some p => pure p
    | none =>
      IO.eprintln "slake clean: no package root found (plausible lakefile walk-up)"
      return 1
  let usePipe ← envFlagTruthy "SLAKE_USE_FS_PROC_PIPE"
  let useFs ← envFlagTruthy "SLAKE_USE_FS_PROC"
  let strict ← envFlagTruthy "SLAKE_FS_PROC_STRICT"
  if !usePipe && !useFs then
    return (← cmdCleanNative pkg)
  let linked := slakeFsProcLinked ()
  let pipeLinked := slakeFsProcPipeLinked ()
  let wantPipe := usePipe
  let pathLinked := if wantPipe then pipeLinked else linked
  let pathName := if wantPipe then "FS_PROC_PIPE" else "FS_PROC"
  if pathLinked != 1 then
    if strict then
      IO.eprintln s!"slake clean: SLAKE_USE_{pathName}=1 + STRICT but {pathName} shim not linked"
      return 1
    IO.eprintln s!"slake clean: SLAKE_USE_{pathName}=1 but {pathName} shim not linked; falling back"
    return (← cmdCleanNative pkg)
  match ← resolveLakeAbs with
  | none =>
    IO.eprintln s!"slake clean: cannot resolve absolute lake path for {pathName} (set LAKE=/abs/path)"
    if strict then
      IO.eprintln "slake clean: SLAKE_FS_PROC_STRICT=1; not falling back"
      return 1
    IO.eprintln "slake clean: falling back to native clean"
    return (← cmdCleanNative pkg)
  | some lakeAbs =>
    let code ← if wantPipe then cmdCleanFsProcPipe pkg lakeAbs else cmdCleanFsProc pkg lakeAbs
    if code == fsSpawnFail then
      if strict then
        IO.eprintln s!"slake clean: SLAKE_FS_PROC_STRICT=1; not falling back after {pathName} spawn fail"
        return 1
      IO.eprintln s!"slake clean: falling back to native clean after {pathName} spawn fail"
      return (← cmdCleanNative pkg)
    if code == fsWaitFail then
      IO.eprintln s!"slake clean: {pathName} wait fail (no native fall back)"
      return 1
    -- A17+A33: after lake clean (any normal exit), always native-wipe root
    -- .slake-native and path-require dep .slake-native so freestanding-adjacent
    -- products do not leak on the FS_PROC/PIPE residual path.
    match ← tryRemoveSlakeNativeDir pkg with
    | none => return 1
    | some _ =>
      match ← wipePathRequireSlakeNativeDirs pkg with
      | none => return 1
      | some _ => return code

/-- Classic `IO.Process` → `lake exe` in `pkg` (W72 parity growth).

Thin forward; remaining argv after the command token is plumbed (W85).
Same host path as `cmdTestIoProcess`; not CLAIMED parity. -/
def cmdExeIoProcess (pkg : FilePath) (lake : String) (rest : List String := []) : IO UInt32 := do
  cmdLakeForwardIoProcess "exe" pkg lake "exe" rest

/-- Freestanding Proc multi-arg path (`lake --dir=<pkg> exe [rest…]`).

Child env is **empty** (freestanding `execve` honesty — not a host-env clone).
Returns process exit `0…255`, `fsSpawnFail`, or `fsWaitFail`. W88 FS_PROC exe. -/
def cmdExeFsProc (pkg : FilePath) (lakeAbs : String) (rest : List String := []) : IO UInt32 := do
  let restA := rest.toArray
  let shown := " ".intercalate ("exe" :: rest)
  IO.println s!"slake exe: SLAKE_USE_FS_PROC=1; freestanding Systems.Proc multi-arg"
  IO.println s!"  lake={lakeAbs} --dir={pkg} {shown}"
  IO.println "  (FS_PROC child env empty — does not inherit host LEAN_PATH/PATH)"
  let code := slakeFsRunLakeExe pkg.toString lakeAbs restA
  if code == fsSpawnFail then
    IO.eprintln "slake exe: freestanding Proc spawn failed"
    return code
  if code == fsWaitFail then
    IO.eprintln "slake exe: freestanding Proc wait failed"
    return code
  if code == 0 then
    IO.println "slake exe: OK (via lake / Systems.Proc)"
  else
    IO.eprintln s!"slake exe: lake exited {code} (Systems.Proc)"
  return code

/-- Freestanding Proc **pipe** path for `lake exe` (stdout capture demo). W88. -/
def cmdExeFsProcPipe (pkg : FilePath) (lakeAbs : String) (rest : List String := []) : IO UInt32 := do
  let restA := rest.toArray
  let shown := " ".intercalate ("exe" :: rest)
  IO.println s!"slake exe: SLAKE_USE_FS_PROC_PIPE=1; freestanding Systems.Proc pipe/stdio"
  IO.println s!"  lake={lakeAbs} --dir={pkg} {shown}"
  IO.println "  (FS_PROC_PIPE stdout→parent pipe capture demo; child env empty)"
  IO.println "  (not full Lake IO redirect product — residual honesty)"
  let code := slakeFsRunLakeExePipe pkg.toString lakeAbs restA
  if code == fsSpawnFail then
    IO.eprintln "slake exe: freestanding Proc pipe spawn failed"
    return code
  if code == fsWaitFail then
    IO.eprintln "slake exe: freestanding Proc pipe wait failed"
    return code
  if code == 0 then
    IO.println "slake exe: OK (via lake / Systems.Proc pipe)"
  else
    IO.eprintln s!"slake exe: lake exited {code} (Systems.Proc pipe)"
  return code

/-- `exe`: classic-host MVP — delegate to `lake exe` in the package dir.

Default: `IO.Process` → `lake exe` (parity green without extract).
With `SLAKE_USE_FS_PROC_PIPE=1` / `SLAKE_USE_FS_PROC=1`: freestanding Proc paths
(W88; same flags/STRICT/empty-child-env honesty as `build`/`test`). **Not** in CLAIMED
parity slice. **Not** full Lake parity. -/
public def cmdExe (rest : List String := []) : IO UInt32 := do
  let cwd ← IO.currentDir
  let pkg ← match ← findPackageDir cwd with
    | some p => pure p
    | none =>
      IO.eprintln "slake exe: no package root found (plausible lakefile walk-up)"
      return 1
  let lake ← lakeCmd
  let usePipe ← envFlagTruthy "SLAKE_USE_FS_PROC_PIPE"
  let useFs ← envFlagTruthy "SLAKE_USE_FS_PROC"
  let strict ← envFlagTruthy "SLAKE_FS_PROC_STRICT"
  if !usePipe && !useFs then
    return (← cmdExeIoProcess pkg lake rest)
  let linked := slakeFsProcLinked ()
  let pipeLinked := slakeFsProcPipeLinked ()
  let wantPipe := usePipe
  let pathLinked := if wantPipe then pipeLinked else linked
  let pathName := if wantPipe then "FS_PROC_PIPE" else "FS_PROC"
  if pathLinked != 1 then
    if strict then
      IO.eprintln s!"slake exe: SLAKE_USE_{pathName}=1 + STRICT but {pathName} shim not linked"
      return 1
    IO.eprintln s!"slake exe: SLAKE_USE_{pathName}=1 but {pathName} shim not linked; falling back"
    return (← cmdExeIoProcess pkg lake rest)
  match ← resolveLakeAbs with
  | none =>
    IO.eprintln s!"slake exe: cannot resolve absolute lake path for {pathName} (set LAKE=/abs/path)"
    if strict then
      IO.eprintln "slake exe: SLAKE_FS_PROC_STRICT=1; not falling back"
      return 1
    IO.eprintln "slake exe: falling back to IO.Process"
    return (← cmdExeIoProcess pkg lake rest)
  | some lakeAbs =>
    let code ← if wantPipe then cmdExeFsProcPipe pkg lakeAbs rest else cmdExeFsProc pkg lakeAbs rest
    if code == fsSpawnFail then
      if strict then
        IO.eprintln s!"slake exe: SLAKE_FS_PROC_STRICT=1; not falling back after {pathName} spawn fail"
        return 1
      IO.eprintln s!"slake exe: falling back to IO.Process after {pathName} spawn fail"
      return (← cmdExeIoProcess pkg lake rest)
    if code == fsWaitFail then
      IO.eprintln s!"slake exe: {pathName} wait fail (no IO.Process fall back)"
      return 1
    return code

/-- Classic `IO.Process` → `lake lint` in `pkg` (W73 parity growth).

Thin forward; remaining argv after the command token is plumbed (W85).
Same host path as `cmdTestIoProcess`; not CLAIMED parity. -/
def cmdLintIoProcess (pkg : FilePath) (lake : String) (rest : List String := []) : IO UInt32 := do
  cmdLakeForwardIoProcess "lint" pkg lake "lint" rest

/-- Freestanding Proc multi-arg path (`lake --dir=<pkg> lint [rest…]`).

Child env is **empty** (freestanding `execve` honesty — not a host-env clone).
Returns process exit `0…255`, `fsSpawnFail`, or `fsWaitFail`. W89 FS_PROC lint. -/
def cmdLintFsProc (pkg : FilePath) (lakeAbs : String) (rest : List String := []) : IO UInt32 := do
  let restA := rest.toArray
  let shown := " ".intercalate ("lint" :: rest)
  IO.println s!"slake lint: SLAKE_USE_FS_PROC=1; freestanding Systems.Proc multi-arg"
  IO.println s!"  lake={lakeAbs} --dir={pkg} {shown}"
  IO.println "  (FS_PROC child env empty — does not inherit host LEAN_PATH/PATH)"
  let code := slakeFsRunLakeLint pkg.toString lakeAbs restA
  if code == fsSpawnFail then
    IO.eprintln "slake lint: freestanding Proc spawn failed"
    return code
  if code == fsWaitFail then
    IO.eprintln "slake lint: freestanding Proc wait failed"
    return code
  if code == 0 then
    IO.println "slake lint: OK (via lake / Systems.Proc)"
  else
    IO.eprintln s!"slake lint: lake exited {code} (Systems.Proc)"
  return code

/-- Freestanding Proc **pipe** path for `lake lint` (stdout capture demo). W89. -/
def cmdLintFsProcPipe (pkg : FilePath) (lakeAbs : String) (rest : List String := []) : IO UInt32 := do
  let restA := rest.toArray
  let shown := " ".intercalate ("lint" :: rest)
  IO.println s!"slake lint: SLAKE_USE_FS_PROC_PIPE=1; freestanding Systems.Proc pipe/stdio"
  IO.println s!"  lake={lakeAbs} --dir={pkg} {shown}"
  IO.println "  (FS_PROC_PIPE stdout→parent pipe capture demo; child env empty)"
  IO.println "  (not full Lake IO redirect product — residual honesty)"
  let code := slakeFsRunLakeLintPipe pkg.toString lakeAbs restA
  if code == fsSpawnFail then
    IO.eprintln "slake lint: freestanding Proc pipe spawn failed"
    return code
  if code == fsWaitFail then
    IO.eprintln "slake lint: freestanding Proc pipe wait failed"
    return code
  if code == 0 then
    IO.println "slake lint: OK (via lake / Systems.Proc pipe)"
  else
    IO.eprintln s!"slake lint: lake exited {code} (Systems.Proc pipe)"
  return code

/-- `lint`: classic-host MVP — delegate to `lake lint` in the package dir.

Default: `IO.Process` → `lake lint` (parity green without extract).
With `SLAKE_USE_FS_PROC_PIPE=1` / `SLAKE_USE_FS_PROC=1`: freestanding Proc paths
(W89; same flags/STRICT/empty-child-env honesty as `build`/`test`/`exe`). **Not** in CLAIMED
parity slice. **Not** full Lake parity. -/
public def cmdLint (rest : List String := []) : IO UInt32 := do
  let cwd ← IO.currentDir
  let pkg ← match ← findPackageDir cwd with
    | some p => pure p
    | none =>
      IO.eprintln "slake lint: no package root found (plausible lakefile walk-up)"
      return 1
  let lake ← lakeCmd
  let usePipe ← envFlagTruthy "SLAKE_USE_FS_PROC_PIPE"
  let useFs ← envFlagTruthy "SLAKE_USE_FS_PROC"
  let strict ← envFlagTruthy "SLAKE_FS_PROC_STRICT"
  if !usePipe && !useFs then
    return (← cmdLintIoProcess pkg lake rest)
  let linked := slakeFsProcLinked ()
  let pipeLinked := slakeFsProcPipeLinked ()
  let wantPipe := usePipe
  let pathLinked := if wantPipe then pipeLinked else linked
  let pathName := if wantPipe then "FS_PROC_PIPE" else "FS_PROC"
  if pathLinked != 1 then
    if strict then
      IO.eprintln s!"slake lint: SLAKE_USE_{pathName}=1 + STRICT but {pathName} shim not linked"
      return 1
    IO.eprintln s!"slake lint: SLAKE_USE_{pathName}=1 but {pathName} shim not linked; falling back"
    return (← cmdLintIoProcess pkg lake rest)
  match ← resolveLakeAbs with
  | none =>
    IO.eprintln s!"slake lint: cannot resolve absolute lake path for {pathName} (set LAKE=/abs/path)"
    if strict then
      IO.eprintln "slake lint: SLAKE_FS_PROC_STRICT=1; not falling back"
      return 1
    IO.eprintln "slake lint: falling back to IO.Process"
    return (← cmdLintIoProcess pkg lake rest)
  | some lakeAbs =>
    let code ← if wantPipe then cmdLintFsProcPipe pkg lakeAbs rest else cmdLintFsProc pkg lakeAbs rest
    if code == fsSpawnFail then
      if strict then
        IO.eprintln s!"slake lint: SLAKE_FS_PROC_STRICT=1; not falling back after {pathName} spawn fail"
        return 1
      IO.eprintln s!"slake lint: falling back to IO.Process after {pathName} spawn fail"
      return (← cmdLintIoProcess pkg lake rest)
    if code == fsWaitFail then
      IO.eprintln s!"slake lint: {pathName} wait fail (no IO.Process fall back)"
      return 1
    return code

/-- Classic `IO.Process` → `lake check-build` in package dir (W73 parity growth base; W109 dual residual).

Thin forward; remaining argv after the command token is plumbed (W85).
Requires package root (real `lake check-build` checks package build configuration). -/
public def cmdCheckBuildIoProcess (pkg : FilePath) (lake : String) (rest : List String := []) : IO UInt32 := do
  cmdLakeForwardIoProcess "check-build" pkg lake "check-build" rest

/-- Freestanding Proc multi-arg path (`lake --dir=<pkg> check-build [rest…]`).

Returns process exit `0…255`, `fsSpawnFail`, or `fsWaitFail`. W109 FS_PROC check-build.
Empty child env; rest plumbed (**not** empty-rest-only); chdir(pkg); lakeAbs pre-resolved. -/
def cmdCheckBuildFsProc (pkg : FilePath) (lakeAbs : String) (rest : List String := []) : IO UInt32 := do
  let restArr := rest.toArray
  let shown := " ".intercalate ("check-build" :: rest)
  IO.println s!"slake check-build: SLAKE_USE_FS_PROC=1; freestanding Systems.Proc multi-arg"
  IO.println s!"  lake={lakeAbs} --dir={pkg} {shown}"
  IO.println "  (empty child env; inherits no host LAKE_*/LEAN_* — dual residual vs classic IO.Process)"
  IO.println "  (check-build FS_PROC chdir to package root for relative path parity with classic cwd=pkg)"
  let code := slakeFsRunLakeCheckBuild pkg.toString lakeAbs restArr
  if code == fsSpawnFail then
    IO.eprintln "slake check-build: freestanding Proc spawn failed"
    return code
  if code == fsWaitFail then
    IO.eprintln "slake check-build: freestanding Proc wait failed"
    return code
  if code == 0 then
    IO.println "slake check-build: OK (via lake / Systems.Proc)"
  else
    IO.eprintln s!"slake check-build: lake exited {code} (Systems.Proc)"
  return code

/-- Freestanding Proc **pipe** path for `lake check-build` (stdout capture demo). W109.
Same chdir(pkg) relative-path parity as multi-arg check-build FS_PROC. -/
def cmdCheckBuildFsProcPipe (pkg : FilePath) (lakeAbs : String) (rest : List String := []) : IO UInt32 := do
  let restArr := rest.toArray
  let shown := " ".intercalate ("check-build" :: rest)
  IO.println s!"slake check-build: SLAKE_USE_FS_PROC_PIPE=1; freestanding Systems.Proc pipe/stdio"
  IO.println s!"  lake={lakeAbs} --dir={pkg} {shown}"
  IO.println "  (empty child env; inherits no host LAKE_*/LEAN_* — dual residual vs classic IO.Process)"
  IO.println "  (check-build FS_PROC_PIPE chdir to package root for relative path parity with classic cwd=pkg)"
  let code := slakeFsRunLakeCheckBuildPipe pkg.toString lakeAbs restArr
  if code == fsSpawnFail then
    IO.eprintln "slake check-build: freestanding Proc pipe spawn failed"
    return code
  if code == fsWaitFail then
    IO.eprintln "slake check-build: freestanding Proc pipe wait failed"
    return code
  if code == 0 then
    IO.println "slake check-build: OK (via lake / Systems.Proc pipe)"
  else
    IO.eprintln s!"slake check-build: lake exited {code} (Systems.Proc pipe)"
  return code

/-- `check-build`: classic-host MVP — delegate to `lake check-build` in the package dir.

Default: `IO.Process` → `lake check-build` with `cwd=pkg` (parity green without extract).
Optional FS_PROC/PIPE (W109): freestanding empty child env; rest plumbed (**not** empty-rest-only —
only `clean` is); rest may rebind Lake globals (`--dir`/`-d`/etc.); chdir(pkg);
resolveLakeAbs **before** chdir. Outside CLAIMED. STRICT: no IO.Process fall-back.
CLAIMED envelope stays `(build clean env test)` — check-build is residual honesty dual path only.
Lake has no bare `check` — use real subcommand `check-build`. -/
public def cmdCheckBuild (rest : List String := []) : IO UInt32 := do
  let cwd ← IO.currentDir
  let pkg ← match ← findPackageDir cwd with
    | some p => pure p
    | none =>
      IO.eprintln "slake check-build: no package root found (plausible lakefile walk-up)"
      return 1
  let lake ← lakeCmd
  let usePipe ← envFlagTruthy "SLAKE_USE_FS_PROC_PIPE"
  let useFs ← envFlagTruthy "SLAKE_USE_FS_PROC"
  let strict ← envFlagTruthy "SLAKE_FS_PROC_STRICT"
  if !usePipe && !useFs then
    return (← cmdCheckBuildIoProcess pkg lake rest)
  let linked := slakeFsProcLinked ()
  let pipeLinked := slakeFsProcPipeLinked ()
  let wantPipe := usePipe
  let pathLinked := if wantPipe then pipeLinked else linked
  let pathName := if wantPipe then "FS_PROC_PIPE" else "FS_PROC"
  if pathLinked != 1 then
    if strict then
      IO.eprintln s!"slake check-build: SLAKE_USE_{pathName}=1 + STRICT but {pathName} shim not linked"
      return 1
    IO.eprintln s!"slake check-build: SLAKE_USE_{pathName}=1 but {pathName} shim not linked; falling back"
    return (← cmdCheckBuildIoProcess pkg lake rest)
  match ← resolveLakeAbs with
  | none =>
    IO.eprintln s!"slake check-build: cannot resolve absolute lake path for {pathName} (set LAKE=/abs/path)"
    if strict then
      IO.eprintln "slake check-build: SLAKE_FS_PROC_STRICT=1; not falling back"
      return 1
    IO.eprintln "slake check-build: falling back to IO.Process"
    return (← cmdCheckBuildIoProcess pkg lake rest)
  | some lakeAbs =>
    let code ← if wantPipe then cmdCheckBuildFsProcPipe pkg lakeAbs rest else cmdCheckBuildFsProc pkg lakeAbs rest
    if code == fsSpawnFail then
      if strict then
        IO.eprintln s!"slake check-build: SLAKE_FS_PROC_STRICT=1; not falling back after {pathName} spawn fail"
        return 1
      IO.eprintln s!"slake check-build: falling back to IO.Process after {pathName} spawn fail"
      return (← cmdCheckBuildIoProcess pkg lake rest)
    if code == fsWaitFail then
      IO.eprintln s!"slake check-build: {pathName} wait fail (no IO.Process fall back)"
      return 1
    return code

/-- Classic `IO.Process` → `lake check-test` in package dir (W74 parity growth base; W110 dual residual).

Thin forward; remaining argv after the command token is plumbed (W85).
Requires package root (real `lake check-test` checks package test configuration). -/
public def cmdCheckTestIoProcess (pkg : FilePath) (lake : String) (rest : List String := []) : IO UInt32 := do
  cmdLakeForwardIoProcess "check-test" pkg lake "check-test" rest

/-- Freestanding Proc multi-arg path (`lake --dir=<pkg> check-test [rest…]`).

Returns process exit `0…255`, `fsSpawnFail`, or `fsWaitFail`. W110 FS_PROC check-test.
Empty child env; rest plumbed (**not** empty-rest-only); chdir(pkg); lakeAbs pre-resolved. -/
def cmdCheckTestFsProc (pkg : FilePath) (lakeAbs : String) (rest : List String := []) : IO UInt32 := do
  let restArr := rest.toArray
  let shown := " ".intercalate ("check-test" :: rest)
  IO.println s!"slake check-test: SLAKE_USE_FS_PROC=1; freestanding Systems.Proc multi-arg"
  IO.println s!"  lake={lakeAbs} --dir={pkg} {shown}"
  IO.println "  (empty child env; inherits no host LAKE_*/LEAN_* — dual residual vs classic IO.Process)"
  IO.println "  (check-test FS_PROC chdir to package root for relative path parity with classic cwd=pkg)"
  let code := slakeFsRunLakeCheckTest pkg.toString lakeAbs restArr
  if code == fsSpawnFail then
    IO.eprintln "slake check-test: freestanding Proc spawn failed"
    return code
  if code == fsWaitFail then
    IO.eprintln "slake check-test: freestanding Proc wait failed"
    return code
  if code == 0 then
    IO.println "slake check-test: OK (via lake / Systems.Proc)"
  else
    IO.eprintln s!"slake check-test: lake exited {code} (Systems.Proc)"
  return code

/-- Freestanding Proc **pipe** path for `lake check-test` (stdout capture demo). W110.
Same chdir(pkg) relative-path parity as multi-arg check-test FS_PROC. -/
def cmdCheckTestFsProcPipe (pkg : FilePath) (lakeAbs : String) (rest : List String := []) : IO UInt32 := do
  let restArr := rest.toArray
  let shown := " ".intercalate ("check-test" :: rest)
  IO.println s!"slake check-test: SLAKE_USE_FS_PROC_PIPE=1; freestanding Systems.Proc pipe/stdio"
  IO.println s!"  lake={lakeAbs} --dir={pkg} {shown}"
  IO.println "  (empty child env; inherits no host LAKE_*/LEAN_* — dual residual vs classic IO.Process)"
  IO.println "  (check-test FS_PROC_PIPE chdir to package root for relative path parity with classic cwd=pkg)"
  let code := slakeFsRunLakeCheckTestPipe pkg.toString lakeAbs restArr
  if code == fsSpawnFail then
    IO.eprintln "slake check-test: freestanding Proc pipe spawn failed"
    return code
  if code == fsWaitFail then
    IO.eprintln "slake check-test: freestanding Proc pipe wait failed"
    return code
  if code == 0 then
    IO.println "slake check-test: OK (via lake / Systems.Proc pipe)"
  else
    IO.eprintln s!"slake check-test: lake exited {code} (Systems.Proc pipe)"
  return code

/-- `check-test`: classic-host MVP — delegate to `lake check-test` in the package dir.

Default: `IO.Process` → `lake check-test` with `cwd=pkg` (parity green without extract).
Optional FS_PROC/PIPE (W110): freestanding empty child env; rest plumbed (**not** empty-rest-only —
only `clean` is); rest may rebind Lake globals (`--dir`/`-d`/etc.); chdir(pkg);
resolveLakeAbs **before** chdir. Outside CLAIMED. STRICT: no IO.Process fall-back.
CLAIMED envelope stays `(build clean env test)` — check-test is residual honesty dual path only. -/
public def cmdCheckTest (rest : List String := []) : IO UInt32 := do
  let cwd ← IO.currentDir
  let pkg ← match ← findPackageDir cwd with
    | some p => pure p
    | none =>
      IO.eprintln "slake check-test: no package root found (plausible lakefile walk-up)"
      return 1
  let lake ← lakeCmd
  let usePipe ← envFlagTruthy "SLAKE_USE_FS_PROC_PIPE"
  let useFs ← envFlagTruthy "SLAKE_USE_FS_PROC"
  let strict ← envFlagTruthy "SLAKE_FS_PROC_STRICT"
  if !usePipe && !useFs then
    return (← cmdCheckTestIoProcess pkg lake rest)
  let linked := slakeFsProcLinked ()
  let pipeLinked := slakeFsProcPipeLinked ()
  let wantPipe := usePipe
  let pathLinked := if wantPipe then pipeLinked else linked
  let pathName := if wantPipe then "FS_PROC_PIPE" else "FS_PROC"
  if pathLinked != 1 then
    if strict then
      IO.eprintln s!"slake check-test: SLAKE_USE_{pathName}=1 + STRICT but {pathName} shim not linked"
      return 1
    IO.eprintln s!"slake check-test: SLAKE_USE_{pathName}=1 but {pathName} shim not linked; falling back"
    return (← cmdCheckTestIoProcess pkg lake rest)
  match ← resolveLakeAbs with
  | none =>
    IO.eprintln s!"slake check-test: cannot resolve absolute lake path for {pathName} (set LAKE=/abs/path)"
    if strict then
      IO.eprintln "slake check-test: SLAKE_FS_PROC_STRICT=1; not falling back"
      return 1
    IO.eprintln "slake check-test: falling back to IO.Process"
    return (← cmdCheckTestIoProcess pkg lake rest)
  | some lakeAbs =>
    let code ← if wantPipe then cmdCheckTestFsProcPipe pkg lakeAbs rest else cmdCheckTestFsProc pkg lakeAbs rest
    if code == fsSpawnFail then
      if strict then
        IO.eprintln s!"slake check-test: SLAKE_FS_PROC_STRICT=1; not falling back after {pathName} spawn fail"
        return 1
      IO.eprintln s!"slake check-test: falling back to IO.Process after {pathName} spawn fail"
      return (← cmdCheckTestIoProcess pkg lake rest)
    if code == fsWaitFail then
      IO.eprintln s!"slake check-test: {pathName} wait fail (no IO.Process fall back)"
      return 1
    return code

/-- Classic `IO.Process` → `lake check-lint` in package dir (W74 parity growth base; W111 dual residual).

Thin forward; remaining argv after the command token is plumbed (W85).
Requires package root (real `lake check-lint` checks package lint configuration). -/
public def cmdCheckLintIoProcess (pkg : FilePath) (lake : String) (rest : List String := []) : IO UInt32 := do
  cmdLakeForwardIoProcess "check-lint" pkg lake "check-lint" rest

/-- Freestanding Proc multi-arg path (`lake --dir=<pkg> check-lint [rest…]`).

Returns process exit `0…255`, `fsSpawnFail`, or `fsWaitFail`. W111 FS_PROC check-lint.
Empty child env; rest plumbed (**not** empty-rest-only); chdir(pkg); lakeAbs pre-resolved.
Outside CLAIMED; CLAIMED is `(build clean env test)`. -/
def cmdCheckLintFsProc (pkg : FilePath) (lakeAbs : String) (rest : List String := []) : IO UInt32 := do
  let restArr := rest.toArray
  let shown := " ".intercalate ("check-lint" :: rest)
  IO.println s!"slake check-lint: SLAKE_USE_FS_PROC=1; freestanding Systems.Proc multi-arg"
  IO.println s!"  lake={lakeAbs} --dir={pkg} {shown}"
  IO.println "  (FS_PROC child env empty — does not inherit host LEAN_PATH/PATH)"
  IO.println "  (check-lint FS_PROC chdir to package root for relative path parity with classic cwd=pkg)"
  let code := slakeFsRunLakeCheckLint pkg.toString lakeAbs restArr
  if code == fsSpawnFail then
    IO.eprintln "slake check-lint: freestanding Proc spawn failed"
    return code
  if code == fsWaitFail then
    IO.eprintln "slake check-lint: freestanding Proc wait failed"
    return code
  if code == 0 then
    IO.println "slake check-lint: OK (via lake / Systems.Proc)"
  else
    IO.eprintln s!"slake check-lint: lake exited {code} (Systems.Proc)"
  return code

/-- Freestanding Proc **pipe** path for `lake check-lint` (stdout capture demo). W111.
Same chdir(pkg) relative-path parity as multi-arg check-lint FS_PROC. -/
def cmdCheckLintFsProcPipe (pkg : FilePath) (lakeAbs : String) (rest : List String := []) : IO UInt32 := do
  let restArr := rest.toArray
  let shown := " ".intercalate ("check-lint" :: rest)
  IO.println s!"slake check-lint: SLAKE_USE_FS_PROC_PIPE=1; freestanding Systems.Proc pipe/stdio"
  IO.println s!"  lake={lakeAbs} --dir={pkg} {shown}"
  IO.println "  (FS_PROC_PIPE stdout→parent pipe capture demo; child env empty)"
  IO.println "  (check-lint FS_PROC_PIPE chdir to package root for relative path parity with classic cwd=pkg)"
  IO.println "  (not full Lake IO redirect product — residual honesty)"
  let code := slakeFsRunLakeCheckLintPipe pkg.toString lakeAbs restArr
  if code == fsSpawnFail then
    IO.eprintln "slake check-lint: freestanding Proc pipe spawn failed"
    return code
  if code == fsWaitFail then
    IO.eprintln "slake check-lint: freestanding Proc pipe wait failed"
    return code
  if code == 0 then
    IO.println "slake check-lint: OK (via lake / Systems.Proc pipe)"
  else
    IO.eprintln s!"slake check-lint: lake exited {code} (Systems.Proc pipe)"
  return code

/-- `check-lint`: classic-host MVP — delegate to `lake check-lint` in the package dir.

Default: `IO.Process` → `lake check-lint` with `cwd=pkg` (parity green without extract).
Optional FS_PROC/PIPE dual residual (empty child env; chdir(pkg); resolveLakeAbs pre-chdir;
STRICT no fall-back). Rest plumbed (**not** empty-rest-only).
CLAIMED envelope stays `(build clean env test)` — check-lint is residual honesty dual path only. -/
public def cmdCheckLint (rest : List String := []) : IO UInt32 := do
  let cwd ← IO.currentDir
  let pkg ← match ← findPackageDir cwd with
    | some p => pure p
    | none =>
      IO.eprintln "slake check-lint: no package root found (plausible lakefile walk-up)"
      return 1
  let lake ← lakeCmd
  let wantPipe := (← IO.getEnv "SLAKE_USE_FS_PROC_PIPE") == some "1"
  let wantFs := wantPipe || (← IO.getEnv "SLAKE_USE_FS_PROC") == some "1"
  let strict := (← IO.getEnv "SLAKE_FS_PROC_STRICT") == some "1"
  if !wantFs then
    return (← cmdCheckLintIoProcess pkg lake rest)
  let pathName := if wantPipe then "FS_PROC_PIPE" else "FS_PROC"
  let linked := if wantPipe then slakeFsProcPipeLinked () else slakeFsProcLinked ()
  if linked != 1 then
    if strict then
      IO.eprintln s!"slake check-lint: SLAKE_USE_{pathName}=1 + STRICT but {pathName} shim not linked"
      return 1
    IO.eprintln s!"slake check-lint: SLAKE_USE_{pathName}=1 but {pathName} shim not linked; falling back"
    return (← cmdCheckLintIoProcess pkg lake rest)
  -- resolveLakeAbs MUST complete before any FS_PROC chdir(pkg)
  match ← resolveLakeAbs with
  | none =>
    IO.eprintln s!"slake check-lint: cannot resolve absolute lake path for {pathName} (set LAKE=/abs/path)"
    if strict then
      IO.eprintln "slake check-lint: SLAKE_FS_PROC_STRICT=1; not falling back"
      return 1
    IO.eprintln "slake check-lint: falling back to IO.Process"
    return (← cmdCheckLintIoProcess pkg lake rest)
  | some lakeAbs =>
    let code ← if wantPipe then cmdCheckLintFsProcPipe pkg lakeAbs rest else cmdCheckLintFsProc pkg lakeAbs rest
    if code == fsSpawnFail then
      if strict then
        IO.eprintln s!"slake check-lint: SLAKE_FS_PROC_STRICT=1; not falling back after {pathName} spawn fail"
        return 1
      IO.eprintln s!"slake check-lint: falling back to IO.Process after {pathName} spawn fail"
      return (← cmdCheckLintIoProcess pkg lake rest)
    if code == fsWaitFail then
      IO.eprintln s!"slake check-lint: {pathName} wait fail (no IO.Process fall back)"
      return 1
    return code



/-- Classic `IO.Process` → `lake query` in `pkg` (W75 parity growth).

Thin forward; remaining argv after the command token is plumbed (W85).
Same host path as `cmdTestIoProcess`; not CLAIMED parity.
Real Lake name — build targets and output results. -/
def cmdQueryIoProcess (pkg : FilePath) (lake : String) (rest : List String := []) : IO UInt32 := do
  cmdLakeForwardIoProcess "query" pkg lake "query" rest

/-- Freestanding Proc multi-arg path (`lake --dir=<pkg> query [rest…]`).

Child env is **empty** (freestanding `execve` honesty — not a host-env clone).
Driver **chdir(pkg)** around spawn so relative path args match classic `cwd=pkg`
(freestanding spawn API has no cwd parameter; pack/cache/unpack/query alignment).
Returns process exit `0…255`, `fsSpawnFail`, or `fsWaitFail`. W96 FS_PROC query.
Outside CLAIMED; rest argv plumbed like build/test/exe/lint/script/update/pack/cache/unpack (**not** empty-rest-only —
only `clean` is empty-rest-only). Rest may still rebind Lake globals (`--dir`/`-d`/etc.). -/
def cmdQueryFsProc (pkg : FilePath) (lakeAbs : String) (rest : List String := []) : IO UInt32 := do
  let restA := rest.toArray
  let shown := " ".intercalate ("query" :: rest)
  IO.println s!"slake query: SLAKE_USE_FS_PROC=1; freestanding Systems.Proc multi-arg"
  IO.println s!"  lake={lakeAbs} --dir={pkg} {shown}"
  IO.println "  (FS_PROC child env empty — does not inherit host LEAN_PATH/PATH)"
  IO.println "  (query FS_PROC chdir to package root for relative path parity with classic cwd=pkg)"
  let code := slakeFsRunLakeQuery pkg.toString lakeAbs restA
  if code == fsSpawnFail then
    IO.eprintln "slake query: freestanding Proc spawn failed"
    return code
  if code == fsWaitFail then
    IO.eprintln "slake query: freestanding Proc wait failed"
    return code
  if code == 0 then
    IO.println "slake query: OK (via lake / Systems.Proc)"
  else
    IO.eprintln s!"slake query: lake exited {code} (Systems.Proc)"
  return code

/-- Freestanding Proc **pipe** path for `lake query` (stdout capture demo). W96.
Same chdir(pkg) relative-path parity as multi-arg query FS_PROC. -/
def cmdQueryFsProcPipe (pkg : FilePath) (lakeAbs : String) (rest : List String := []) : IO UInt32 := do
  let restA := rest.toArray
  let shown := " ".intercalate ("query" :: rest)
  IO.println s!"slake query: SLAKE_USE_FS_PROC_PIPE=1; freestanding Systems.Proc pipe/stdio"
  IO.println s!"  lake={lakeAbs} --dir={pkg} {shown}"
  IO.println "  (FS_PROC_PIPE stdout→parent pipe capture demo; child env empty)"
  IO.println "  (query FS_PROC_PIPE chdir to package root for relative path parity with classic cwd=pkg)"
  IO.println "  (not full Lake IO redirect product — residual honesty)"
  let code := slakeFsRunLakeQueryPipe pkg.toString lakeAbs restA
  if code == fsSpawnFail then
    IO.eprintln "slake query: freestanding Proc pipe spawn failed"
    return code
  if code == fsWaitFail then
    IO.eprintln "slake query: freestanding Proc pipe wait failed"
    return code
  if code == 0 then
    IO.println "slake query: OK (via lake / Systems.Proc pipe)"
  else
    IO.eprintln s!"slake query: lake exited {code} (Systems.Proc pipe)"
  return code

/-- `query`: classic-host MVP — delegate to `lake query` in the package dir.

Default: `IO.Process` → `lake query` with `cwd=pkg` (parity green without extract).
With `SLAKE_USE_FS_PROC_PIPE=1` / `SLAKE_USE_FS_PROC=1`: freestanding Proc paths
(W96; same flags/STRICT/empty-child-env honesty as `build`/`test`/`exe`/`lint`/`script`/`update`/`pack`/`cache`/`unpack`;
driver chdir(pkg) so relative path args match classic cwd).
Rest argv plumbed (**not** empty-rest-only — only `clean` is); rest may rebind Lake globals
(`--dir`/`-d`/etc.) unlike clean's empty-rest envelope.
Non-STRICT: unlinked/spawn-fail falls back to classic IO.Process (host env + cwd=pkg);
STRICT: no fall-back. Fall-back after FS_PROC spawn fail inherits host env (dual residual honesty).
**Not** in CLAIMED parity slice. **Not** full Lake parity. -/
public def cmdQuery (rest : List String := []) : IO UInt32 := do
  let cwd ← IO.currentDir
  let pkg ← match ← findPackageDir cwd with
    | some p => pure p
    | none =>
      IO.eprintln "slake query: no package root found (plausible lakefile walk-up)"
      return 1
  let lake ← lakeCmd
  let usePipe ← envFlagTruthy "SLAKE_USE_FS_PROC_PIPE"
  let useFs ← envFlagTruthy "SLAKE_USE_FS_PROC"
  let strict ← envFlagTruthy "SLAKE_FS_PROC_STRICT"
  if !usePipe && !useFs then
    return (← cmdQueryIoProcess pkg lake rest)
  let linked := slakeFsProcLinked ()
  let pipeLinked := slakeFsProcPipeLinked ()
  let wantPipe := usePipe
  let pathLinked := if wantPipe then pipeLinked else linked
  let pathName := if wantPipe then "FS_PROC_PIPE" else "FS_PROC"
  if pathLinked != 1 then
    if strict then
      IO.eprintln s!"slake query: SLAKE_USE_{pathName}=1 + STRICT but {pathName} shim not linked"
      return 1
    IO.eprintln s!"slake query: SLAKE_USE_{pathName}=1 but {pathName} shim not linked; falling back"
    return (← cmdQueryIoProcess pkg lake rest)
  match ← resolveLakeAbs with
  | none =>
    IO.eprintln s!"slake query: cannot resolve absolute lake path for {pathName} (set LAKE=/abs/path)"
    if strict then
      IO.eprintln "slake query: SLAKE_FS_PROC_STRICT=1; not falling back"
      return 1
    IO.eprintln "slake query: falling back to IO.Process"
    return (← cmdQueryIoProcess pkg lake rest)
  | some lakeAbs =>
    let code ← if wantPipe then cmdQueryFsProcPipe pkg lakeAbs rest else cmdQueryFsProc pkg lakeAbs rest
    if code == fsSpawnFail then
      if strict then
        IO.eprintln s!"slake query: SLAKE_FS_PROC_STRICT=1; not falling back after {pathName} spawn fail"
        return 1
      IO.eprintln s!"slake query: falling back to IO.Process after {pathName} spawn fail"
      return (← cmdQueryIoProcess pkg lake rest)
    if code == fsWaitFail then
      IO.eprintln s!"slake query: {pathName} wait fail (no IO.Process fall back)"
      return 1
    return code

/-- Classic `IO.Process` → `lake shake` in `pkg` (W75 parity growth).

Thin forward; remaining argv after the command token is plumbed (W85).
Same host path as `cmdTestIoProcess`; not CLAIMED parity.
Real Lake name — minimize imports. -/
def cmdShakeIoProcess (pkg : FilePath) (lake : String) (rest : List String := []) : IO UInt32 := do
  cmdLakeForwardIoProcess "shake" pkg lake "shake" rest

/-- Freestanding Proc multi-arg path (`lake --dir=<pkg> shake [rest…]`).

Child env is **empty** (freestanding `execve` honesty — not a host-env clone).
Driver **chdir(pkg)** around spawn so relative path args match classic `cwd=pkg`
(freestanding spawn API has no cwd parameter; pack/cache/unpack/query/shake alignment).
Returns process exit `0…255`, `fsSpawnFail`, or `fsWaitFail`. W97 FS_PROC shake.
Outside CLAIMED; rest argv plumbed like build/test/exe/lint/script/update/pack/cache/unpack/query (**not** empty-rest-only —
only `clean` is empty-rest-only). Rest may still rebind Lake globals (`--dir`/`-d`/etc.). -/
def cmdShakeFsProc (pkg : FilePath) (lakeAbs : String) (rest : List String := []) : IO UInt32 := do
  let restA := rest.toArray
  let shown := " ".intercalate ("shake" :: rest)
  IO.println s!"slake shake: SLAKE_USE_FS_PROC=1; freestanding Systems.Proc multi-arg"
  IO.println s!"  lake={lakeAbs} --dir={pkg} {shown}"
  IO.println "  (FS_PROC child env empty — does not inherit host LEAN_PATH/PATH)"
  IO.println "  (shake FS_PROC chdir to package root for relative path parity with classic cwd=pkg)"
  let code := slakeFsRunLakeShake pkg.toString lakeAbs restA
  if code == fsSpawnFail then
    IO.eprintln "slake shake: freestanding Proc spawn failed"
    return code
  if code == fsWaitFail then
    IO.eprintln "slake shake: freestanding Proc wait failed"
    return code
  if code == 0 then
    IO.println "slake shake: OK (via lake / Systems.Proc)"
  else
    IO.eprintln s!"slake shake: lake exited {code} (Systems.Proc)"
  return code

/-- Freestanding Proc **pipe** path for `lake shake` (stdout capture demo). W97.
Same chdir(pkg) relative-path parity as multi-arg shake FS_PROC. -/
def cmdShakeFsProcPipe (pkg : FilePath) (lakeAbs : String) (rest : List String := []) : IO UInt32 := do
  let restA := rest.toArray
  let shown := " ".intercalate ("shake" :: rest)
  IO.println s!"slake shake: SLAKE_USE_FS_PROC_PIPE=1; freestanding Systems.Proc pipe/stdio"
  IO.println s!"  lake={lakeAbs} --dir={pkg} {shown}"
  IO.println "  (FS_PROC_PIPE stdout→parent pipe capture demo; child env empty)"
  IO.println "  (shake FS_PROC_PIPE chdir to package root for relative path parity with classic cwd=pkg)"
  IO.println "  (not full Lake IO redirect product — residual honesty)"
  let code := slakeFsRunLakeShakePipe pkg.toString lakeAbs restA
  if code == fsSpawnFail then
    IO.eprintln "slake shake: freestanding Proc pipe spawn failed"
    return code
  if code == fsWaitFail then
    IO.eprintln "slake shake: freestanding Proc pipe wait failed"
    return code
  if code == 0 then
    IO.println "slake shake: OK (via lake / Systems.Proc pipe)"
  else
    IO.eprintln s!"slake shake: lake exited {code} (Systems.Proc pipe)"
  return code

/-- `shake`: classic-host MVP — delegate to `lake shake` in the package dir.

Default: `IO.Process` → `lake shake` with `cwd=pkg` (parity green without extract).
With `SLAKE_USE_FS_PROC_PIPE=1` / `SLAKE_USE_FS_PROC=1`: freestanding Proc paths
(W97; same flags/STRICT/empty-child-env honesty as `build`/`test`/`exe`/`lint`/`script`/`update`/`pack`/`cache`/`unpack`/`query`;
driver chdir(pkg) so relative path args match classic cwd).
Rest argv plumbed (**not** empty-rest-only — only `clean` is); rest may rebind Lake globals
(`--dir`/`-d`/etc.) unlike clean's empty-rest envelope.
Non-STRICT: unlinked/spawn-fail falls back to classic IO.Process (host env + cwd=pkg);
STRICT: no fall-back. Fall-back after FS_PROC spawn fail inherits host env (dual residual honesty).
**Not** in CLAIMED parity slice. **Not** full Lake parity. -/
public def cmdShake (rest : List String := []) : IO UInt32 := do
  let cwd ← IO.currentDir
  let pkg ← match ← findPackageDir cwd with
    | some p => pure p
    | none =>
      IO.eprintln "slake shake: no package root found (plausible lakefile walk-up)"
      return 1
  let lake ← lakeCmd
  let usePipe ← envFlagTruthy "SLAKE_USE_FS_PROC_PIPE"
  let useFs ← envFlagTruthy "SLAKE_USE_FS_PROC"
  let strict ← envFlagTruthy "SLAKE_FS_PROC_STRICT"
  if !usePipe && !useFs then
    return (← cmdShakeIoProcess pkg lake rest)
  let linked := slakeFsProcLinked ()
  let pipeLinked := slakeFsProcPipeLinked ()
  let wantPipe := usePipe
  let pathLinked := if wantPipe then pipeLinked else linked
  let pathName := if wantPipe then "FS_PROC_PIPE" else "FS_PROC"
  if pathLinked != 1 then
    if strict then
      IO.eprintln s!"slake shake: SLAKE_USE_{pathName}=1 + STRICT but {pathName} shim not linked"
      return 1
    IO.eprintln s!"slake shake: SLAKE_USE_{pathName}=1 but {pathName} shim not linked; falling back"
    return (← cmdShakeIoProcess pkg lake rest)
  match ← resolveLakeAbs with
  | none =>
    IO.eprintln s!"slake shake: cannot resolve absolute lake path for {pathName} (set LAKE=/abs/path)"
    if strict then
      IO.eprintln "slake shake: SLAKE_FS_PROC_STRICT=1; not falling back"
      return 1
    IO.eprintln "slake shake: falling back to IO.Process"
    return (← cmdShakeIoProcess pkg lake rest)
  | some lakeAbs =>
    let code ← if wantPipe then cmdShakeFsProcPipe pkg lakeAbs rest else cmdShakeFsProc pkg lakeAbs rest
    if code == fsSpawnFail then
      if strict then
        IO.eprintln s!"slake shake: SLAKE_FS_PROC_STRICT=1; not falling back after {pathName} spawn fail"
        return 1
      IO.eprintln s!"slake shake: falling back to IO.Process after {pathName} spawn fail"
      return (← cmdShakeIoProcess pkg lake rest)
    if code == fsWaitFail then
      IO.eprintln s!"slake shake: {pathName} wait fail (no IO.Process fall back)"
      return 1
    return code



/-- Classic `IO.Process` → `lake update` in `pkg` (W76 parity growth).

Thin forward; remaining argv after the command token is plumbed (W85).
Same host path as `cmdTestIoProcess`; not CLAIMED parity.
Real Lake name — update dependencies and save manifest. -/
def cmdUpdateIoProcess (pkg : FilePath) (lake : String) (rest : List String := []) : IO UInt32 := do
  cmdLakeForwardIoProcess "update" pkg lake "update" rest

/-- Freestanding Proc multi-arg path (`lake --dir=<pkg> update [rest…]`).

Child env is **empty** (freestanding `execve` honesty — not a host-env clone).
Returns process exit `0…255`, `fsSpawnFail`, or `fsWaitFail`. W92 FS_PROC update.
Outside CLAIMED; rest argv plumbed like build/test/exe/lint/script (not empty-rest-only). -/
def cmdUpdateFsProc (pkg : FilePath) (lakeAbs : String) (rest : List String := []) : IO UInt32 := do
  let restA := rest.toArray
  let shown := " ".intercalate ("update" :: rest)
  IO.println s!"slake update: SLAKE_USE_FS_PROC=1; freestanding Systems.Proc multi-arg"
  IO.println s!"  lake={lakeAbs} --dir={pkg} {shown}"
  IO.println "  (FS_PROC child env empty — does not inherit host LEAN_PATH/PATH)"
  let code := slakeFsRunLakeUpdate pkg.toString lakeAbs restA
  if code == fsSpawnFail then
    IO.eprintln "slake update: freestanding Proc spawn failed"
    return code
  if code == fsWaitFail then
    IO.eprintln "slake update: freestanding Proc wait failed"
    return code
  if code == 0 then
    IO.println "slake update: OK (via lake / Systems.Proc)"
  else
    IO.eprintln s!"slake update: lake exited {code} (Systems.Proc)"
  return code

/-- Freestanding Proc **pipe** path for `lake update` (stdout capture demo). W92. -/
def cmdUpdateFsProcPipe (pkg : FilePath) (lakeAbs : String) (rest : List String := []) : IO UInt32 := do
  let restA := rest.toArray
  let shown := " ".intercalate ("update" :: rest)
  IO.println s!"slake update: SLAKE_USE_FS_PROC_PIPE=1; freestanding Systems.Proc pipe/stdio"
  IO.println s!"  lake={lakeAbs} --dir={pkg} {shown}"
  IO.println "  (FS_PROC_PIPE stdout→parent pipe capture demo; child env empty)"
  IO.println "  (not full Lake IO redirect product — residual honesty)"
  let code := slakeFsRunLakeUpdatePipe pkg.toString lakeAbs restA
  if code == fsSpawnFail then
    IO.eprintln "slake update: freestanding Proc pipe spawn failed"
    return code
  if code == fsWaitFail then
    IO.eprintln "slake update: freestanding Proc pipe wait failed"
    return code
  if code == 0 then
    IO.println "slake update: OK (via lake / Systems.Proc pipe)"
  else
    IO.eprintln s!"slake update: lake exited {code} (Systems.Proc pipe)"
  return code

/-- `update`: classic-host MVP — delegate to `lake update` in the package dir.

Default: `IO.Process` → `lake update` (parity green without extract).
With `SLAKE_USE_FS_PROC_PIPE=1` / `SLAKE_USE_FS_PROC=1`: freestanding Proc paths
(W92; same flags/STRICT/empty-child-env honesty as `build`/`test`/`exe`/`lint`/`script`).
Rest argv plumbed (not empty-rest-only — only `clean` is empty-rest-only).
**Not** in CLAIMED parity slice. **Not** full Lake parity. -/
public def cmdUpdate (rest : List String := []) : IO UInt32 := do
  let cwd ← IO.currentDir
  let pkg ← match ← findPackageDir cwd with
    | some p => pure p
    | none =>
      IO.eprintln "slake update: no package root found (plausible lakefile walk-up)"
      return 1
  let lake ← lakeCmd
  let usePipe ← envFlagTruthy "SLAKE_USE_FS_PROC_PIPE"
  let useFs ← envFlagTruthy "SLAKE_USE_FS_PROC"
  let strict ← envFlagTruthy "SLAKE_FS_PROC_STRICT"
  if !usePipe && !useFs then
    return (← cmdUpdateIoProcess pkg lake rest)
  let linked := slakeFsProcLinked ()
  let pipeLinked := slakeFsProcPipeLinked ()
  let wantPipe := usePipe
  let pathLinked := if wantPipe then pipeLinked else linked
  let pathName := if wantPipe then "FS_PROC_PIPE" else "FS_PROC"
  if pathLinked != 1 then
    if strict then
      IO.eprintln s!"slake update: SLAKE_USE_{pathName}=1 + STRICT but {pathName} shim not linked"
      return 1
    IO.eprintln s!"slake update: SLAKE_USE_{pathName}=1 but {pathName} shim not linked; falling back"
    return (← cmdUpdateIoProcess pkg lake rest)
  match ← resolveLakeAbs with
  | none =>
    IO.eprintln s!"slake update: cannot resolve absolute lake path for {pathName} (set LAKE=/abs/path)"
    if strict then
      IO.eprintln "slake update: SLAKE_FS_PROC_STRICT=1; not falling back"
      return 1
    IO.eprintln "slake update: falling back to IO.Process"
    return (← cmdUpdateIoProcess pkg lake rest)
  | some lakeAbs =>
    let code ← if wantPipe then cmdUpdateFsProcPipe pkg lakeAbs rest else cmdUpdateFsProc pkg lakeAbs rest
    if code == fsSpawnFail then
      if strict then
        IO.eprintln s!"slake update: SLAKE_FS_PROC_STRICT=1; not falling back after {pathName} spawn fail"
        return 1
      IO.eprintln s!"slake update: falling back to IO.Process after {pathName} spawn fail"
      return (← cmdUpdateIoProcess pkg lake rest)
    if code == fsWaitFail then
      IO.eprintln s!"slake update: {pathName} wait fail (no IO.Process fall back)"
      return 1
    return code

/-- Classic `IO.Process` → `lake pack` in `pkg` (W76 parity growth; W93 dual residual).

Thin forward; remaining argv after the command token is plumbed (W85).
Same host path as `cmdTestIoProcess`; not CLAIMED parity.
Real Lake name — pack build artifacts. -/
def cmdPackIoProcess (pkg : FilePath) (lake : String) (rest : List String := []) : IO UInt32 := do
  cmdLakeForwardIoProcess "pack" pkg lake "pack" rest

/-- Freestanding Proc multi-arg path (`lake --dir=<pkg> pack [rest…]`).

Child env is **empty** (freestanding `execve` honesty — not a host-env clone).
Driver **chdir(pkg)** around spawn so relative archive args match classic `cwd=pkg`
(freestanding spawn API has no cwd parameter; pack-only alignment).
Returns process exit `0…255`, `fsSpawnFail`, or `fsWaitFail`. W93 FS_PROC pack.
Outside CLAIMED; rest argv plumbed like build/test/exe/lint/script/update (**not** empty-rest-only —
only `clean` is empty-rest-only). Rest may still rebind Lake globals (`--dir`/`-d`/etc.). -/
def cmdPackFsProc (pkg : FilePath) (lakeAbs : String) (rest : List String := []) : IO UInt32 := do
  let restA := rest.toArray
  let shown := " ".intercalate ("pack" :: rest)
  IO.println s!"slake pack: SLAKE_USE_FS_PROC=1; freestanding Systems.Proc multi-arg"
  IO.println s!"  lake={lakeAbs} --dir={pkg} {shown}"
  IO.println "  (FS_PROC child env empty — does not inherit host LEAN_PATH/PATH)"
  IO.println "  (pack FS_PROC chdir to package root for relative archive path parity with classic cwd=pkg)"
  let code := slakeFsRunLakePack pkg.toString lakeAbs restA
  if code == fsSpawnFail then
    IO.eprintln "slake pack: freestanding Proc spawn failed"
    return code
  if code == fsWaitFail then
    IO.eprintln "slake pack: freestanding Proc wait failed"
    return code
  if code == 0 then
    IO.println "slake pack: OK (via lake / Systems.Proc)"
  else
    IO.eprintln s!"slake pack: lake exited {code} (Systems.Proc)"
  return code

/-- Freestanding Proc **pipe** path for `lake pack` (stdout capture demo). W93.
Same chdir(pkg) relative-archive parity as multi-arg pack FS_PROC. -/
def cmdPackFsProcPipe (pkg : FilePath) (lakeAbs : String) (rest : List String := []) : IO UInt32 := do
  let restA := rest.toArray
  let shown := " ".intercalate ("pack" :: rest)
  IO.println s!"slake pack: SLAKE_USE_FS_PROC_PIPE=1; freestanding Systems.Proc pipe/stdio"
  IO.println s!"  lake={lakeAbs} --dir={pkg} {shown}"
  IO.println "  (FS_PROC_PIPE stdout→parent pipe capture demo; child env empty)"
  IO.println "  (pack FS_PROC_PIPE chdir to package root for relative archive path parity with classic cwd=pkg)"
  IO.println "  (not full Lake IO redirect product — residual honesty)"
  let code := slakeFsRunLakePackPipe pkg.toString lakeAbs restA
  if code == fsSpawnFail then
    IO.eprintln "slake pack: freestanding Proc pipe spawn failed"
    return code
  if code == fsWaitFail then
    IO.eprintln "slake pack: freestanding Proc pipe wait failed"
    return code
  if code == 0 then
    IO.println "slake pack: OK (via lake / Systems.Proc pipe)"
  else
    IO.eprintln s!"slake pack: lake exited {code} (Systems.Proc pipe)"
  return code

/-- `pack`: classic-host MVP — delegate to `lake pack` in the package dir.

Default: `IO.Process` → `lake pack` with `cwd=pkg` (parity green without extract).
With `SLAKE_USE_FS_PROC_PIPE=1` / `SLAKE_USE_FS_PROC=1`: freestanding Proc paths
(W93; same flags/STRICT/empty-child-env honesty as `build`/`test`/`exe`/`lint`/`script`/`update`;
driver chdir(pkg) so relative archive args match classic cwd).
Rest argv plumbed (**not** empty-rest-only — only `clean` is); rest may rebind Lake globals
(`--dir`/`-d`/etc.) unlike clean's empty-rest envelope.
Non-STRICT: unlinked/spawn-fail falls back to classic IO.Process (host env + cwd=pkg);
STRICT: no fall-back. Fall-back after FS_PROC spawn fail inherits host env (dual residual honesty).
**Not** in CLAIMED parity slice. **Not** full Lake parity. -/
public def cmdPack (rest : List String := []) : IO UInt32 := do
  let cwd ← IO.currentDir
  let pkg ← match ← findPackageDir cwd with
    | some p => pure p
    | none =>
      IO.eprintln "slake pack: no package root found (plausible lakefile walk-up)"
      return 1
  let lake ← lakeCmd
  let usePipe ← envFlagTruthy "SLAKE_USE_FS_PROC_PIPE"
  let useFs ← envFlagTruthy "SLAKE_USE_FS_PROC"
  let strict ← envFlagTruthy "SLAKE_FS_PROC_STRICT"
  if !usePipe && !useFs then
    return (← cmdPackIoProcess pkg lake rest)
  let linked := slakeFsProcLinked ()
  let pipeLinked := slakeFsProcPipeLinked ()
  let wantPipe := usePipe
  let pathLinked := if wantPipe then pipeLinked else linked
  let pathName := if wantPipe then "FS_PROC_PIPE" else "FS_PROC"
  if pathLinked != 1 then
    if strict then
      IO.eprintln s!"slake pack: SLAKE_USE_{pathName}=1 + STRICT but {pathName} shim not linked"
      return 1
    IO.eprintln s!"slake pack: SLAKE_USE_{pathName}=1 but {pathName} shim not linked; falling back"
    return (← cmdPackIoProcess pkg lake rest)
  match ← resolveLakeAbs with
  | none =>
    IO.eprintln s!"slake pack: cannot resolve absolute lake path for {pathName} (set LAKE=/abs/path)"
    if strict then
      IO.eprintln "slake pack: SLAKE_FS_PROC_STRICT=1; not falling back"
      return 1
    IO.eprintln "slake pack: falling back to IO.Process"
    return (← cmdPackIoProcess pkg lake rest)
  | some lakeAbs =>
    let code ← if wantPipe then cmdPackFsProcPipe pkg lakeAbs rest else cmdPackFsProc pkg lakeAbs rest
    if code == fsSpawnFail then
      if strict then
        IO.eprintln s!"slake pack: SLAKE_FS_PROC_STRICT=1; not falling back after {pathName} spawn fail"
        return 1
      IO.eprintln s!"slake pack: falling back to IO.Process after {pathName} spawn fail"
      return (← cmdPackIoProcess pkg lake rest)
    if code == fsWaitFail then
      IO.eprintln s!"slake pack: {pathName} wait fail (no IO.Process fall back)"
      return 1
    return code


/-- Classic `IO.Process` → `lake unpack` in `pkg` (W77 parity growth; W95 dual residual).

Thin forward; remaining argv after the command token is plumbed (W85).
Same host path as `cmdTestIoProcess`; not CLAIMED parity.
Real Lake name — unpack build artifacts. -/
def cmdUnpackIoProcess (pkg : FilePath) (lake : String) (rest : List String := []) : IO UInt32 := do
  cmdLakeForwardIoProcess "unpack" pkg lake "unpack" rest

/-- Freestanding Proc multi-arg path (`lake --dir=<pkg> unpack [rest…]`).

Child env is **empty** (freestanding `execve` honesty — not a host-env clone).
Driver **chdir(pkg)** around spawn so relative path args match classic `cwd=pkg`
(freestanding spawn API has no cwd parameter; pack/cache/unpack alignment).
Returns process exit `0…255`, `fsSpawnFail`, or `fsWaitFail`. W95 FS_PROC unpack.
Outside CLAIMED; rest argv plumbed like build/test/exe/lint/script/update/pack/cache (**not** empty-rest-only —
only `clean` is empty-rest-only). Rest may still rebind Lake globals (`--dir`/`-d`/etc.). -/
def cmdUnpackFsProc (pkg : FilePath) (lakeAbs : String) (rest : List String := []) : IO UInt32 := do
  let restA := rest.toArray
  let shown := " ".intercalate ("unpack" :: rest)
  IO.println s!"slake unpack: SLAKE_USE_FS_PROC=1; freestanding Systems.Proc multi-arg"
  IO.println s!"  lake={lakeAbs} --dir={pkg} {shown}"
  IO.println "  (FS_PROC child env empty — does not inherit host LEAN_PATH/PATH)"
  IO.println "  (unpack FS_PROC chdir to package root for relative path parity with classic cwd=pkg)"
  let code := slakeFsRunLakeUnpack pkg.toString lakeAbs restA
  if code == fsSpawnFail then
    IO.eprintln "slake unpack: freestanding Proc spawn failed"
    return code
  if code == fsWaitFail then
    IO.eprintln "slake unpack: freestanding Proc wait failed"
    return code
  if code == 0 then
    IO.println "slake unpack: OK (via lake / Systems.Proc)"
  else
    IO.eprintln s!"slake unpack: lake exited {code} (Systems.Proc)"
  return code

/-- Freestanding Proc **pipe** path for `lake unpack` (stdout capture demo). W95.
Same chdir(pkg) relative-path parity as multi-arg unpack FS_PROC. -/
def cmdUnpackFsProcPipe (pkg : FilePath) (lakeAbs : String) (rest : List String := []) : IO UInt32 := do
  let restA := rest.toArray
  let shown := " ".intercalate ("unpack" :: rest)
  IO.println s!"slake unpack: SLAKE_USE_FS_PROC_PIPE=1; freestanding Systems.Proc pipe/stdio"
  IO.println s!"  lake={lakeAbs} --dir={pkg} {shown}"
  IO.println "  (FS_PROC_PIPE stdout→parent pipe capture demo; child env empty)"
  IO.println "  (unpack FS_PROC_PIPE chdir to package root for relative path parity with classic cwd=pkg)"
  IO.println "  (not full Lake IO redirect product — residual honesty)"
  let code := slakeFsRunLakeUnpackPipe pkg.toString lakeAbs restA
  if code == fsSpawnFail then
    IO.eprintln "slake unpack: freestanding Proc pipe spawn failed"
    return code
  if code == fsWaitFail then
    IO.eprintln "slake unpack: freestanding Proc pipe wait failed"
    return code
  if code == 0 then
    IO.println "slake unpack: OK (via lake / Systems.Proc pipe)"
  else
    IO.eprintln s!"slake unpack: lake exited {code} (Systems.Proc pipe)"
  return code

/-- `unpack`: classic-host MVP — delegate to `lake unpack` in the package dir.

Default: `IO.Process` → `lake unpack` with `cwd=pkg` (parity green without extract).
With `SLAKE_USE_FS_PROC_PIPE=1` / `SLAKE_USE_FS_PROC=1`: freestanding Proc paths
(W95; same flags/STRICT/empty-child-env honesty as `build`/`test`/`exe`/`lint`/`script`/`update`/`pack`/`cache`;
driver chdir(pkg) so relative path args match classic cwd).
Rest argv plumbed (**not** empty-rest-only — only `clean` is); rest may rebind Lake globals
(`--dir`/`-d`/etc.) unlike clean's empty-rest envelope.
Non-STRICT: unlinked/spawn-fail falls back to classic IO.Process (host env + cwd=pkg);
STRICT: no fall-back. Fall-back after FS_PROC spawn fail inherits host env (dual residual honesty).
**Not** in CLAIMED parity slice. **Not** full Lake parity. -/
public def cmdUnpack (rest : List String := []) : IO UInt32 := do
  let cwd ← IO.currentDir
  let pkg ← match ← findPackageDir cwd with
    | some p => pure p
    | none =>
      IO.eprintln "slake unpack: no package root found (plausible lakefile walk-up)"
      return 1
  let lake ← lakeCmd
  let usePipe ← envFlagTruthy "SLAKE_USE_FS_PROC_PIPE"
  let useFs ← envFlagTruthy "SLAKE_USE_FS_PROC"
  let strict ← envFlagTruthy "SLAKE_FS_PROC_STRICT"
  if !usePipe && !useFs then
    return (← cmdUnpackIoProcess pkg lake rest)
  let linked := slakeFsProcLinked ()
  let pipeLinked := slakeFsProcPipeLinked ()
  let wantPipe := usePipe
  let pathLinked := if wantPipe then pipeLinked else linked
  let pathName := if wantPipe then "FS_PROC_PIPE" else "FS_PROC"
  if pathLinked != 1 then
    if strict then
      IO.eprintln s!"slake unpack: SLAKE_USE_{pathName}=1 + STRICT but {pathName} shim not linked"
      return 1
    IO.eprintln s!"slake unpack: SLAKE_USE_{pathName}=1 but {pathName} shim not linked; falling back"
    return (← cmdUnpackIoProcess pkg lake rest)
  match ← resolveLakeAbs with
  | none =>
    IO.eprintln s!"slake unpack: cannot resolve absolute lake path for {pathName} (set LAKE=/abs/path)"
    if strict then
      IO.eprintln "slake unpack: SLAKE_FS_PROC_STRICT=1; not falling back"
      return 1
    IO.eprintln "slake unpack: falling back to IO.Process"
    return (← cmdUnpackIoProcess pkg lake rest)
  | some lakeAbs =>
    let code ← if wantPipe then cmdUnpackFsProcPipe pkg lakeAbs rest else cmdUnpackFsProc pkg lakeAbs rest
    if code == fsSpawnFail then
      if strict then
        IO.eprintln s!"slake unpack: SLAKE_FS_PROC_STRICT=1; not falling back after {pathName} spawn fail"
        return 1
      IO.eprintln s!"slake unpack: falling back to IO.Process after {pathName} spawn fail"
      return (← cmdUnpackIoProcess pkg lake rest)
    if code == fsWaitFail then
      IO.eprintln s!"slake unpack: {pathName} wait fail (no IO.Process fall back)"
      return 1
    return code

/-- Classic `IO.Process` → `lake cache` in `pkg` (W77 parity growth).

Thin forward; remaining argv after the command token is plumbed (W85).
Same host path as `cmdTestIoProcess`; not CLAIMED parity.
Real Lake name — manage Lake cache. -/
def cmdCacheIoProcess (pkg : FilePath) (lake : String) (rest : List String := []) : IO UInt32 := do
  cmdLakeForwardIoProcess "cache" pkg lake "cache" rest

/-- Freestanding Proc multi-arg path (`lake --dir=<pkg> cache [rest…]`).

Child env is **empty** (freestanding `execve` honesty — not a host-env clone).
Driver **chdir(pkg)** around spawn so relative path args match classic `cwd=pkg`
(freestanding spawn API has no cwd parameter; pack/cache alignment).
Returns process exit `0…255`, `fsSpawnFail`, or `fsWaitFail`. W94 FS_PROC cache.
Outside CLAIMED; rest argv plumbed like build/test/exe/lint/script/update/pack (**not** empty-rest-only —
only `clean` is empty-rest-only). Rest may still rebind Lake globals (`--dir`/`-d`/etc.). -/
def cmdCacheFsProc (pkg : FilePath) (lakeAbs : String) (rest : List String := []) : IO UInt32 := do
  let restA := rest.toArray
  let shown := " ".intercalate ("cache" :: rest)
  IO.println s!"slake cache: SLAKE_USE_FS_PROC=1; freestanding Systems.Proc multi-arg"
  IO.println s!"  lake={lakeAbs} --dir={pkg} {shown}"
  IO.println "  (FS_PROC child env empty — does not inherit host LEAN_PATH/PATH)"
  IO.println "  (cache FS_PROC chdir to package root for relative path parity with classic cwd=pkg)"
  let code := slakeFsRunLakeCache pkg.toString lakeAbs restA
  if code == fsSpawnFail then
    IO.eprintln "slake cache: freestanding Proc spawn failed"
    return code
  if code == fsWaitFail then
    IO.eprintln "slake cache: freestanding Proc wait failed"
    return code
  if code == 0 then
    IO.println "slake cache: OK (via lake / Systems.Proc)"
  else
    IO.eprintln s!"slake cache: lake exited {code} (Systems.Proc)"
  return code

/-- Freestanding Proc **pipe** path for `lake cache` (stdout capture demo). W94.
Same chdir(pkg) relative-path parity as multi-arg cache FS_PROC. -/
def cmdCacheFsProcPipe (pkg : FilePath) (lakeAbs : String) (rest : List String := []) : IO UInt32 := do
  let restA := rest.toArray
  let shown := " ".intercalate ("cache" :: rest)
  IO.println s!"slake cache: SLAKE_USE_FS_PROC_PIPE=1; freestanding Systems.Proc pipe/stdio"
  IO.println s!"  lake={lakeAbs} --dir={pkg} {shown}"
  IO.println "  (FS_PROC_PIPE stdout→parent pipe capture demo; child env empty)"
  IO.println "  (cache FS_PROC_PIPE chdir to package root for relative path parity with classic cwd=pkg)"
  IO.println "  (not full Lake IO redirect product — residual honesty)"
  let code := slakeFsRunLakeCachePipe pkg.toString lakeAbs restA
  if code == fsSpawnFail then
    IO.eprintln "slake cache: freestanding Proc pipe spawn failed"
    return code
  if code == fsWaitFail then
    IO.eprintln "slake cache: freestanding Proc pipe wait failed"
    return code
  if code == 0 then
    IO.println "slake cache: OK (via lake / Systems.Proc pipe)"
  else
    IO.eprintln s!"slake cache: lake exited {code} (Systems.Proc pipe)"
  return code

/-- `cache`: classic-host MVP — delegate to `lake cache` in the package dir.

Default: `IO.Process` → `lake cache` with `cwd=pkg` (parity green without extract).
With `SLAKE_USE_FS_PROC_PIPE=1` / `SLAKE_USE_FS_PROC=1`: freestanding Proc paths
(W94; same flags/STRICT/empty-child-env honesty as `build`/`test`/`exe`/`lint`/`script`/`update`/`pack`;
driver chdir(pkg) so relative path args match classic cwd).
Rest argv plumbed (**not** empty-rest-only — only `clean` is); rest may rebind Lake globals
(`--dir`/`-d`/etc.) unlike clean's empty-rest envelope.
Non-STRICT: unlinked/spawn-fail falls back to classic IO.Process (host env + cwd=pkg);
STRICT: no fall-back. Fall-back after FS_PROC spawn fail inherits host env (dual residual honesty).
**Not** in CLAIMED parity slice. **Not** full Lake parity. -/
public def cmdCache (rest : List String := []) : IO UInt32 := do
  let cwd ← IO.currentDir
  let pkg ← match ← findPackageDir cwd with
    | some p => pure p
    | none =>
      IO.eprintln "slake cache: no package root found (plausible lakefile walk-up)"
      return 1
  let lake ← lakeCmd
  let usePipe ← envFlagTruthy "SLAKE_USE_FS_PROC_PIPE"
  let useFs ← envFlagTruthy "SLAKE_USE_FS_PROC"
  let strict ← envFlagTruthy "SLAKE_FS_PROC_STRICT"
  if !usePipe && !useFs then
    return (← cmdCacheIoProcess pkg lake rest)
  let linked := slakeFsProcLinked ()
  let pipeLinked := slakeFsProcPipeLinked ()
  let wantPipe := usePipe
  let pathLinked := if wantPipe then pipeLinked else linked
  let pathName := if wantPipe then "FS_PROC_PIPE" else "FS_PROC"
  if pathLinked != 1 then
    if strict then
      IO.eprintln s!"slake cache: SLAKE_USE_{pathName}=1 + STRICT but {pathName} shim not linked"
      return 1
    IO.eprintln s!"slake cache: SLAKE_USE_{pathName}=1 but {pathName} shim not linked; falling back"
    return (← cmdCacheIoProcess pkg lake rest)
  match ← resolveLakeAbs with
  | none =>
    IO.eprintln s!"slake cache: cannot resolve absolute lake path for {pathName} (set LAKE=/abs/path)"
    if strict then
      IO.eprintln "slake cache: SLAKE_FS_PROC_STRICT=1; not falling back"
      return 1
    IO.eprintln "slake cache: falling back to IO.Process"
    return (← cmdCacheIoProcess pkg lake rest)
  | some lakeAbs =>
    let code ← if wantPipe then cmdCacheFsProcPipe pkg lakeAbs rest else cmdCacheFsProc pkg lakeAbs rest
    if code == fsSpawnFail then
      if strict then
        IO.eprintln s!"slake cache: SLAKE_FS_PROC_STRICT=1; not falling back after {pathName} spawn fail"
        return 1
      IO.eprintln s!"slake cache: falling back to IO.Process after {pathName} spawn fail"
      return (← cmdCacheIoProcess pkg lake rest)
    if code == fsWaitFail then
      IO.eprintln s!"slake cache: {pathName} wait fail (no IO.Process fall back)"
      return 1
    return code

/-- Classic `IO.Process` → `lake lean` in package dir (W78 parity growth base; W100 dual residual).

Requires package root (real `lake lean` runs against package toolchain/config). -/
def cmdLeanIoProcess (pkg : FilePath) (lake : String) (rest : List String := []) : IO UInt32 := do
  cmdLakeForwardIoProcess "lean" pkg lake "lean" rest

/-- Freestanding Proc multi-arg path (`lake --dir=<pkg> lean [rest…]`).
Child env is **empty** (freestanding `execve` honesty — not a host-env clone).
Driver **chdir(pkg)** around spawn so relative path args match classic `cwd=pkg`
(freestanding spawn API has no cwd parameter; pack/cache/unpack/query/shake/serve/upload/lean alignment).
Returns process exit `0…255`, `fsSpawnFail`, or `fsWaitFail`. W100 FS_PROC lean.
Outside CLAIMED; rest argv plumbed like pack/cache/unpack/query/shake/serve (**not** empty-rest-only —
only `clean` is empty-rest-only). Rest may still rebind Lake globals (`--dir`/`-d`/etc.). -/
def cmdLeanFsProc (pkg : FilePath) (lakeAbs : String) (rest : List String := []) : IO UInt32 := do
  let restArr := rest.toArray
  let shown := " ".intercalate ("lean" :: rest)
  IO.println s!"slake lean: SLAKE_USE_FS_PROC=1; freestanding Systems.Proc multi-arg"
  IO.println s!"  lake={lakeAbs} --dir={pkg} {shown}"
  IO.println "  (empty child env — residual honesty dual path)"
  IO.println "  (lean FS_PROC chdir to package root for relative path parity with classic cwd=pkg)"
  let code := slakeFsRunLakeLean pkg.toString lakeAbs restArr
  if code == fsSpawnFail then
    IO.eprintln "slake lean: freestanding Proc spawn failed"
    return code
  if code == fsWaitFail then
    IO.eprintln "slake lean: freestanding Proc wait failed"
    return code
  if code == 0 then
    IO.println "slake lean: OK (via lake / Systems.Proc)"
  else
    IO.eprintln s!"slake lean: lake exited {code} (Systems.Proc)"
  return code

/-- Freestanding Proc **pipe** path for `lake lean` (stdout capture demo). W100.
Same chdir(pkg) relative-path parity as multi-arg lean FS_PROC.
Rest plumbed (**not** empty-rest-only); rest may rebind Lake globals; CLAIMED unchanged. -/
def cmdLeanFsProcPipe (pkg : FilePath) (lakeAbs : String) (rest : List String := []) : IO UInt32 := do
  let restArr := rest.toArray
  let shown := " ".intercalate ("lean" :: rest)
  IO.println s!"slake lean: SLAKE_USE_FS_PROC_PIPE=1; freestanding Systems.Proc pipe/stdio"
  IO.println s!"  lake={lakeAbs} --dir={pkg} {shown}"
  IO.println "  (empty child env — residual honesty dual path)"
  IO.println "  (lean FS_PROC_PIPE chdir to package root for relative path parity with classic cwd=pkg)"
  let code := slakeFsRunLakeLeanPipe pkg.toString lakeAbs restArr
  if code == fsSpawnFail then
    IO.eprintln "slake lean: freestanding Proc pipe spawn failed"
    return code
  if code == fsWaitFail then
    IO.eprintln "slake lean: freestanding Proc pipe wait failed"
    return code
  if code == 0 then
    IO.println "slake lean: OK (via lake / Systems.Proc pipe)"
  else
    IO.eprintln s!"slake lean: lake exited {code} (Systems.Proc pipe)"
  return code

/-- `lean`: classic-host MVP — delegate to `lake lean` in the package dir.

Default: `IO.Process` → `lake lean` with `cwd=pkg` (parity green without extract).
Optional FS_PROC/PIPE (W100): freestanding empty child env; rest plumbed (**not** empty-rest-only —
only `clean` is); rest may rebind Lake globals (`--dir`/`-d`/etc.); chdir(pkg);
resolveLakeAbs **before** chdir. Outside CLAIMED. STRICT: no IO.Process fall-back.
CLAIMED envelope stays `(build clean env test)` — lean is residual honesty dual path only. -/
public def cmdLean (rest : List String := []) : IO UInt32 := do
  let cwd ← IO.currentDir
  let pkg ← match ← findPackageDir cwd with
    | some p => pure p
    | none =>
      IO.eprintln "slake lean: no package root found (plausible lakefile walk-up)"
      return 1
  let lake ← lakeCmd
  let usePipe ← envFlagTruthy "SLAKE_USE_FS_PROC_PIPE"
  let useFs ← envFlagTruthy "SLAKE_USE_FS_PROC"
  let strict ← envFlagTruthy "SLAKE_FS_PROC_STRICT"
  if !usePipe && !useFs then
    return (← cmdLeanIoProcess pkg lake rest)
  let linked := slakeFsProcLinked ()
  let pipeLinked := slakeFsProcPipeLinked ()
  let wantPipe := usePipe
  let pathLinked := if wantPipe then pipeLinked else linked
  let pathName := if wantPipe then "FS_PROC_PIPE" else "FS_PROC"
  if pathLinked != 1 then
    if strict then
      IO.eprintln s!"slake lean: SLAKE_USE_{pathName}=1 + STRICT but {pathName} shim not linked"
      return 1
    IO.eprintln s!"slake lean: SLAKE_USE_{pathName}=1 but {pathName} shim not linked; falling back"
    return (← cmdLeanIoProcess pkg lake rest)
  match ← resolveLakeAbs with
  | none =>
    IO.eprintln s!"slake lean: cannot resolve absolute lake path for {pathName} (set LAKE=/abs/path)"
    if strict then
      IO.eprintln "slake lean: SLAKE_FS_PROC_STRICT=1; not falling back"
      return 1
    IO.eprintln "slake lean: falling back to IO.Process"
    return (← cmdLeanIoProcess pkg lake rest)
  | some lakeAbs =>
    let code ← if wantPipe then cmdLeanFsProcPipe pkg lakeAbs rest else cmdLeanFsProc pkg lakeAbs rest
    if code == fsSpawnFail then
      if strict then
        IO.eprintln s!"slake lean: SLAKE_FS_PROC_STRICT=1; not falling back after {pathName} spawn fail"
        return 1
      IO.eprintln s!"slake lean: falling back to IO.Process after {pathName} spawn fail"
      return (← cmdLeanIoProcess pkg lake rest)
    if code == fsWaitFail then
      IO.eprintln s!"slake lean: {pathName} wait fail (no IO.Process fall back)"
      return 1
    return code


/-- Classic `IO.Process` → `lake scripts` in package dir (W78 parity growth base; W101 dual residual).

Requires package root (real `lake scripts` runs against package toolchain/config). -/
def cmdScriptsIoProcess (pkg : FilePath) (lake : String) (rest : List String := []) : IO UInt32 := do
  cmdLakeForwardIoProcess "scripts" pkg lake "scripts" rest

/-- Freestanding Proc multi-arg path (`lake --dir=<pkg> scripts [rest…]`).
Child env is **empty** (freestanding `execve` honesty — not a host-env clone).
Driver **chdir(pkg)** around spawn so relative path args match classic `cwd=pkg`
(freestanding spawn API has no cwd parameter; pack/cache/unpack/query/shake/serve/upload/lean/scripts alignment).
Returns process exit `0…255`, `fsSpawnFail`, or `fsWaitFail`. W101 FS_PROC scripts.
Outside CLAIMED; rest argv plumbed like pack/cache/unpack/query/shake/serve/upload/lean (**not** empty-rest-only —
only `clean` is empty-rest-only). Rest may still rebind Lake globals (`--dir`/`-d`/etc.). -/
def cmdScriptsFsProc (pkg : FilePath) (lakeAbs : String) (rest : List String := []) : IO UInt32 := do
  let restArr := rest.toArray
  let shown := " ".intercalate ("scripts" :: rest)
  IO.println s!"slake scripts: SLAKE_USE_FS_PROC=1; freestanding Systems.Proc multi-arg"
  IO.println s!"  lake={lakeAbs} --dir={pkg} {shown}"
  IO.println "  (empty child env — residual honesty dual path)"
  IO.println "  (scripts FS_PROC chdir to package root for relative path parity with classic cwd=pkg)"
  let code := slakeFsRunLakeScripts pkg.toString lakeAbs restArr
  if code == fsSpawnFail then
    IO.eprintln "slake scripts: freestanding Proc spawn failed"
    return code
  if code == fsWaitFail then
    IO.eprintln "slake scripts: freestanding Proc wait failed"
    return code
  if code == 0 then
    IO.println "slake scripts: OK (via lake / Systems.Proc)"
  else
    IO.eprintln s!"slake scripts: lake exited {code} (Systems.Proc)"
  return code

/-- Freestanding Proc **pipe** path for `lake scripts` (stdout capture demo). W101.
Same chdir(pkg) relative-path parity as multi-arg scripts FS_PROC.
Rest plumbed (**not** empty-rest-only); rest may rebind Lake globals; CLAIMED unchanged. -/
def cmdScriptsFsProcPipe (pkg : FilePath) (lakeAbs : String) (rest : List String := []) : IO UInt32 := do
  let restArr := rest.toArray
  let shown := " ".intercalate ("scripts" :: rest)
  IO.println s!"slake scripts: SLAKE_USE_FS_PROC_PIPE=1; freestanding Systems.Proc pipe/stdio"
  IO.println s!"  lake={lakeAbs} --dir={pkg} {shown}"
  IO.println "  (empty child env — residual honesty dual path)"
  IO.println "  (scripts FS_PROC_PIPE chdir to package root for relative path parity with classic cwd=pkg)"
  let code := slakeFsRunLakeScriptsPipe pkg.toString lakeAbs restArr
  if code == fsSpawnFail then
    IO.eprintln "slake scripts: freestanding Proc pipe spawn failed"
    return code
  if code == fsWaitFail then
    IO.eprintln "slake scripts: freestanding Proc pipe wait failed"
    return code
  if code == 0 then
    IO.println "slake scripts: OK (via lake / Systems.Proc pipe)"
  else
    IO.eprintln s!"slake scripts: lake exited {code} (Systems.Proc pipe)"
  return code

/-- `scripts`: classic-host MVP — delegate to `lake scripts` in the package dir.

Default: `IO.Process` → `lake scripts` with `cwd=pkg` (parity green without extract).
Optional FS_PROC/PIPE (W101): freestanding empty child env; rest plumbed (**not** empty-rest-only —
only `clean` is); rest may rebind Lake globals (`--dir`/`-d`/etc.); chdir(pkg);
resolveLakeAbs **before** chdir. Outside CLAIMED. STRICT: no IO.Process fall-back.
CLAIMED envelope stays `(build clean env test)` — scripts is residual honesty dual path only. -/
public def cmdScripts (rest : List String := []) : IO UInt32 := do
  let cwd ← IO.currentDir
  let pkg ← match ← findPackageDir cwd with
    | some p => pure p
    | none =>
      IO.eprintln "slake scripts: no package root found (plausible lakefile walk-up)"
      return 1
  let lake ← lakeCmd
  let usePipe ← envFlagTruthy "SLAKE_USE_FS_PROC_PIPE"
  let useFs ← envFlagTruthy "SLAKE_USE_FS_PROC"
  let strict ← envFlagTruthy "SLAKE_FS_PROC_STRICT"
  if !usePipe && !useFs then
    return (← cmdScriptsIoProcess pkg lake rest)
  let linked := slakeFsProcLinked ()
  let pipeLinked := slakeFsProcPipeLinked ()
  let wantPipe := usePipe
  let pathLinked := if wantPipe then pipeLinked else linked
  let pathName := if wantPipe then "FS_PROC_PIPE" else "FS_PROC"
  if pathLinked != 1 then
    if strict then
      IO.eprintln s!"slake scripts: SLAKE_USE_{pathName}=1 + STRICT but {pathName} shim not linked"
      return 1
    IO.eprintln s!"slake scripts: SLAKE_USE_{pathName}=1 but {pathName} shim not linked; falling back"
    return (← cmdScriptsIoProcess pkg lake rest)
  match ← resolveLakeAbs with
  | none =>
    IO.eprintln s!"slake scripts: cannot resolve absolute lake path for {pathName} (set LAKE=/abs/path)"
    if strict then
      IO.eprintln "slake scripts: SLAKE_FS_PROC_STRICT=1; not falling back"
      return 1
    IO.eprintln "slake scripts: falling back to IO.Process"
    return (← cmdScriptsIoProcess pkg lake rest)
  | some lakeAbs =>
    let code ← if wantPipe then cmdScriptsFsProcPipe pkg lakeAbs rest else cmdScriptsFsProc pkg lakeAbs rest
    if code == fsSpawnFail then
      if strict then
        IO.eprintln s!"slake scripts: SLAKE_FS_PROC_STRICT=1; not falling back after {pathName} spawn fail"
        return 1
      IO.eprintln s!"slake scripts: falling back to IO.Process after {pathName} spawn fail"
      return (← cmdScriptsIoProcess pkg lake rest)
    if code == fsWaitFail then
      IO.eprintln s!"slake scripts: {pathName} wait fail (no IO.Process fall back)"
      return 1
    return code


/-- Classic `IO.Process` → `lake new` in `cwd` (W79 parity growth base; W107 dual residual).

Thin forward; remaining argv after the command token is plumbed (W85). Spawns in process cwd — does **not** require an existing lakefile
(real `lake new` bootstraps an empty directory). -/
public def cmdNewIoProcess (cwd : FilePath) (lake : String) (rest : List String := []) : IO UInt32 := do
  cmdLakeForwardIoProcessCwd "new" cwd lake "new" rest

/-- Freestanding Proc multi-arg path (`lake --dir=<cwd> new [rest…]`).

Returns process exit `0…255`, `fsSpawnFail`, or `fsWaitFail`. W107 FS_PROC new.
Empty child env; rest plumbed (**not** empty-rest-only); chdir(cwd) bootstrap; lakeAbs pre-resolved.
**Honesty:** cwd bootstrap — no package walk-up (unlike run/build). -/
def cmdNewFsProc (cwd : FilePath) (lakeAbs : String) (rest : List String := []) : IO UInt32 := do
  let restArr := rest.toArray
  let shown := " ".intercalate ("new" :: rest)
  IO.println s!"slake new: SLAKE_USE_FS_PROC=1; freestanding Systems.Proc multi-arg"
  IO.println s!"  lake={lakeAbs} --dir={cwd} {shown}"
  IO.println "  (empty child env; inherits no host LAKE_*/LEAN_* — dual residual vs classic IO.Process)"
  IO.println "  (new FS_PROC chdir to process cwd bootstrap — no package walk-up; relative path parity with classic cwd)"
  let code := slakeFsRunLakeNew cwd.toString lakeAbs restArr
  if code == fsSpawnFail then
    IO.eprintln "slake new: freestanding Proc spawn failed"
    return code
  if code == fsWaitFail then
    IO.eprintln "slake new: freestanding Proc wait failed"
    return code
  if code == 0 then
    IO.println "slake new: OK (via lake / Systems.Proc)"
  else
    IO.eprintln s!"slake new: lake exited {code} (Systems.Proc)"
  return code

/-- Freestanding Proc **pipe** path for `lake new` (stdout capture demo). W107.
Same chdir(cwd) bootstrap parity as multi-arg new FS_PROC. -/
def cmdNewFsProcPipe (cwd : FilePath) (lakeAbs : String) (rest : List String := []) : IO UInt32 := do
  let restArr := rest.toArray
  let shown := " ".intercalate ("new" :: rest)
  IO.println s!"slake new: SLAKE_USE_FS_PROC_PIPE=1; freestanding Systems.Proc pipe/stdio"
  IO.println s!"  lake={lakeAbs} --dir={cwd} {shown}"
  IO.println "  (empty child env; inherits no host LAKE_*/LEAN_* — dual residual vs classic IO.Process)"
  IO.println "  (new FS_PROC_PIPE chdir to process cwd bootstrap — no package walk-up; relative path parity with classic cwd)"
  let code := slakeFsRunLakeNewPipe cwd.toString lakeAbs restArr
  if code == fsSpawnFail then
    IO.eprintln "slake new: freestanding Proc pipe spawn failed"
    return code
  if code == fsWaitFail then
    IO.eprintln "slake new: freestanding Proc pipe wait failed"
    return code
  if code == 0 then
    IO.println "slake new: OK (via lake / Systems.Proc pipe)"
  else
    IO.eprintln s!"slake new: lake exited {code} (Systems.Proc pipe)"
  return code

/-- `new`: classic-host MVP — delegate to `lake new` from process cwd.

Bootstrap command: does **not** walk up for a package root (unlike build/clean/run).
Default: `IO.Process` → `lake new` with `cwd=process cwd` (parity green without extract).
Optional FS_PROC/PIPE (W107): freestanding empty child env; rest plumbed (**not** empty-rest-only —
only `clean` is); rest may rebind Lake globals (`--dir`/`-d`/etc.); chdir(cwd);
resolveLakeAbs **before** chdir. Outside CLAIMED. STRICT: no IO.Process fall-back.
CLAIMED envelope stays `(build clean env test)` — new is residual honesty dual path only.
**Honesty:** cwd bootstrap (no package-root gate). -/
public def cmdNew (rest : List String := []) : IO UInt32 := do
  let cwd ← IO.currentDir
  let lake ← lakeCmd
  let usePipe ← envFlagTruthy "SLAKE_USE_FS_PROC_PIPE"
  let useFs ← envFlagTruthy "SLAKE_USE_FS_PROC"
  let strict ← envFlagTruthy "SLAKE_FS_PROC_STRICT"
  if !usePipe && !useFs then
    return (← cmdNewIoProcess cwd lake rest)
  let linked := slakeFsProcLinked ()
  let pipeLinked := slakeFsProcPipeLinked ()
  let wantPipe := usePipe
  let pathLinked := if wantPipe then pipeLinked else linked
  let pathName := if wantPipe then "FS_PROC_PIPE" else "FS_PROC"
  if pathLinked != 1 then
    if strict then
      IO.eprintln s!"slake new: SLAKE_USE_{pathName}=1 + STRICT but {pathName} shim not linked"
      return 1
    IO.eprintln s!"slake new: SLAKE_USE_{pathName}=1 but {pathName} shim not linked; falling back"
    return (← cmdNewIoProcess cwd lake rest)
  match ← resolveLakeAbs with
  | none =>
    IO.eprintln s!"slake new: cannot resolve absolute lake path for {pathName} (set LAKE=/abs/path)"
    if strict then
      IO.eprintln "slake new: SLAKE_FS_PROC_STRICT=1; not falling back"
      return 1
    IO.eprintln "slake new: falling back to IO.Process"
    return (← cmdNewIoProcess cwd lake rest)
  | some lakeAbs =>
    let code ← if wantPipe then cmdNewFsProcPipe cwd lakeAbs rest else cmdNewFsProc cwd lakeAbs rest
    if code == fsSpawnFail then
      if strict then
        IO.eprintln s!"slake new: SLAKE_FS_PROC_STRICT=1; not falling back after {pathName} spawn fail"
        return 1
      IO.eprintln s!"slake new: falling back to IO.Process after {pathName} spawn fail"
      return (← cmdNewIoProcess cwd lake rest)
    if code == fsWaitFail then
      IO.eprintln s!"slake new: {pathName} wait fail (no IO.Process fall back)"
      return 1
    return code

/-- Classic `IO.Process` → `lake init` in `cwd` (W79 parity growth base; W108 dual residual).

Thin forward; remaining argv after the command token is plumbed (W85). Spawns in process cwd — does **not** require an existing lakefile
(real `lake init` initializes the current directory). -/
public def cmdInitIoProcess (cwd : FilePath) (lake : String) (rest : List String := []) : IO UInt32 := do
  cmdLakeForwardIoProcessCwd "init" cwd lake "init" rest

/-- Freestanding Proc multi-arg path (`lake --dir=<cwd> init [rest…]`).

Returns process exit `0…255`, `fsSpawnFail`, or `fsWaitFail`. W108 FS_PROC init.
Empty child env; rest plumbed (**not** empty-rest-only); chdir(cwd) bootstrap; lakeAbs pre-resolved.
**Honesty:** cwd bootstrap — no package walk-up (like `new`; unlike run/build). -/
def cmdInitFsProc (cwd : FilePath) (lakeAbs : String) (rest : List String := []) : IO UInt32 := do
  let restArr := rest.toArray
  let shown := " ".intercalate ("init" :: rest)
  IO.println s!"slake init: SLAKE_USE_FS_PROC=1; freestanding Systems.Proc multi-arg"
  IO.println s!"  lake={lakeAbs} --dir={cwd} {shown}"
  IO.println "  (empty child env; inherits no host LAKE_*/LEAN_* — dual residual vs classic IO.Process)"
  IO.println "  (init FS_PROC chdir to process cwd bootstrap — no package walk-up; relative path parity with classic cwd)"
  let code := slakeFsRunLakeInit cwd.toString lakeAbs restArr
  if code == fsSpawnFail then
    IO.eprintln "slake init: freestanding Proc spawn failed"
    return code
  if code == fsWaitFail then
    IO.eprintln "slake init: freestanding Proc wait failed"
    return code
  if code == 0 then
    IO.println "slake init: OK (via lake / Systems.Proc)"
  else
    IO.eprintln s!"slake init: lake exited {code} (Systems.Proc)"
  return code

/-- Freestanding Proc **pipe** path for `lake init` (stdout capture demo). W108.
Same chdir(cwd) bootstrap parity as multi-arg init FS_PROC. -/
def cmdInitFsProcPipe (cwd : FilePath) (lakeAbs : String) (rest : List String := []) : IO UInt32 := do
  let restArr := rest.toArray
  let shown := " ".intercalate ("init" :: rest)
  IO.println s!"slake init: SLAKE_USE_FS_PROC_PIPE=1; freestanding Systems.Proc pipe/stdio"
  IO.println s!"  lake={lakeAbs} --dir={cwd} {shown}"
  IO.println "  (empty child env; inherits no host LAKE_*/LEAN_* — dual residual vs classic IO.Process)"
  IO.println "  (init FS_PROC_PIPE chdir to process cwd bootstrap — no package walk-up; relative path parity with classic cwd)"
  let code := slakeFsRunLakeInitPipe cwd.toString lakeAbs restArr
  if code == fsSpawnFail then
    IO.eprintln "slake init: freestanding Proc pipe spawn failed"
    return code
  if code == fsWaitFail then
    IO.eprintln "slake init: freestanding Proc pipe wait failed"
    return code
  if code == 0 then
    IO.println "slake init: OK (via lake / Systems.Proc pipe)"
  else
    IO.eprintln s!"slake init: lake exited {code} (Systems.Proc pipe)"
  return code

/-- `init`: classic-host MVP — delegate to `lake init` from process cwd.

Bootstrap command: does **not** walk up for a package root (unlike build/clean/run).
Default: `IO.Process` → `lake init` with `cwd=process cwd` (parity green without extract).
Optional FS_PROC/PIPE (W108): freestanding empty child env; rest plumbed (**not** empty-rest-only —
only `clean` is); rest may rebind Lake globals (`--dir`/`-d`/etc.); chdir(cwd);
resolveLakeAbs **before** chdir. Outside CLAIMED. STRICT: no IO.Process fall-back.
CLAIMED envelope stays `(build clean env test)` — init is residual honesty dual path only.
**Honesty:** cwd bootstrap (no package-root gate); same shape as `new`. -/
public def cmdInit (rest : List String := []) : IO UInt32 := do
  let cwd ← IO.currentDir
  let lake ← lakeCmd
  let usePipe ← envFlagTruthy "SLAKE_USE_FS_PROC_PIPE"
  let useFs ← envFlagTruthy "SLAKE_USE_FS_PROC"
  let strict ← envFlagTruthy "SLAKE_FS_PROC_STRICT"
  if !usePipe && !useFs then
    return (← cmdInitIoProcess cwd lake rest)
  let linked := slakeFsProcLinked ()
  let pipeLinked := slakeFsProcPipeLinked ()
  let wantPipe := usePipe
  let pathLinked := if wantPipe then pipeLinked else linked
  let pathName := if wantPipe then "FS_PROC_PIPE" else "FS_PROC"
  if pathLinked != 1 then
    if strict then
      IO.eprintln s!"slake init: SLAKE_USE_{pathName}=1 + STRICT but {pathName} shim not linked"
      return 1
    IO.eprintln s!"slake init: SLAKE_USE_{pathName}=1 but {pathName} shim not linked; falling back"
    return (← cmdInitIoProcess cwd lake rest)
  match ← resolveLakeAbs with
  | none =>
    IO.eprintln s!"slake init: cannot resolve absolute lake path for {pathName} (set LAKE=/abs/path)"
    if strict then
      IO.eprintln "slake init: SLAKE_FS_PROC_STRICT=1; not falling back"
      return 1
    IO.eprintln "slake init: falling back to IO.Process"
    return (← cmdInitIoProcess cwd lake rest)
  | some lakeAbs =>
    let code ← if wantPipe then cmdInitFsProcPipe cwd lakeAbs rest else cmdInitFsProc cwd lakeAbs rest
    if code == fsSpawnFail then
      if strict then
        IO.eprintln s!"slake init: SLAKE_FS_PROC_STRICT=1; not falling back after {pathName} spawn fail"
        return 1
      IO.eprintln s!"slake init: falling back to IO.Process after {pathName} spawn fail"
      return (← cmdInitIoProcess cwd lake rest)
    if code == fsWaitFail then
      IO.eprintln s!"slake init: {pathName} wait fail (no IO.Process fall back)"
      return 1
    return code

/-- Classic `IO.Process` → `lake serve` in package dir (W80 parity growth base).

Requires package root (real `lake serve` is a package-scoped language server helper). -/
def cmdServeIoProcess (pkg : FilePath) (lake : String) (rest : List String := []) : IO UInt32 := do
  cmdLakeForwardIoProcess "serve" pkg lake "serve" rest

/-- Freestanding Proc multi-arg path (`lake --dir=<pkg> serve [rest…]`).
Child env is **empty** (freestanding `execve` honesty — not a host-env clone).
Driver **chdir(pkg)** around spawn so relative path args match classic `cwd=pkg`
(freestanding spawn API has no cwd parameter; pack/cache/unpack/query/shake/serve alignment).
Returns process exit `0…255`, `fsSpawnFail`, or `fsWaitFail`. W98 FS_PROC serve.
Outside CLAIMED; rest argv plumbed like pack/cache/unpack/query/shake (**not** empty-rest-only —
only `clean` is empty-rest-only). Rest may still rebind Lake globals (`--dir`/`-d`/etc.). -/
def cmdServeFsProc (pkg : FilePath) (lakeAbs : String) (rest : List String := []) : IO UInt32 := do
  let restArr := rest.toArray
  let shown := " ".intercalate ("serve" :: rest)
  IO.println s!"slake serve: SLAKE_USE_FS_PROC=1; freestanding Systems.Proc multi-arg"
  IO.println s!"  lake={lakeAbs} --dir={pkg} {shown}"
  IO.println "  (empty child env — residual honesty dual path)"
  IO.println "  (serve FS_PROC chdir to package root for relative path parity with classic cwd=pkg)"
  let code := slakeFsRunLakeServe pkg.toString lakeAbs restArr
  if code == fsSpawnFail then
    IO.eprintln "slake serve: freestanding Proc spawn failed"
    return code
  if code == fsWaitFail then
    IO.eprintln "slake serve: freestanding Proc wait failed"
    return code
  if code == 0 then
    IO.println "slake serve: OK (via lake / Systems.Proc)"
  else
    IO.eprintln s!"slake serve: lake exited {code} (Systems.Proc)"
  return code

/-- Freestanding Proc **pipe** path for `lake serve` (stdout capture demo). W98.
Same chdir(pkg) relative-path parity as multi-arg serve FS_PROC.
Rest plumbed (**not** empty-rest-only); rest may rebind Lake globals; CLAIMED unchanged. -/
def cmdServeFsProcPipe (pkg : FilePath) (lakeAbs : String) (rest : List String := []) : IO UInt32 := do
  let restArr := rest.toArray
  let shown := " ".intercalate ("serve" :: rest)
  IO.println s!"slake serve: SLAKE_USE_FS_PROC_PIPE=1; freestanding Systems.Proc pipe/stdio"
  IO.println s!"  lake={lakeAbs} --dir={pkg} {shown}"
  IO.println "  (empty child env — residual honesty dual path)"
  IO.println "  (serve FS_PROC_PIPE chdir to package root for relative path parity with classic cwd=pkg)"
  let code := slakeFsRunLakeServePipe pkg.toString lakeAbs restArr
  if code == fsSpawnFail then
    IO.eprintln "slake serve: freestanding Proc pipe spawn failed"
    return code
  if code == fsWaitFail then
    IO.eprintln "slake serve: freestanding Proc pipe wait failed"
    return code
  if code == 0 then
    IO.println "slake serve: OK (via lake / Systems.Proc pipe)"
  else
    IO.eprintln s!"slake serve: lake exited {code} (Systems.Proc pipe)"
  return code

/-- `serve`: classic-host MVP — delegate to `lake serve` in the package dir.

Default: `IO.Process` → `lake serve` with `cwd=pkg` (parity green without extract).
Optional FS_PROC/PIPE (W98): freestanding empty child env; rest plumbed (**not** empty-rest-only —
only `clean` is); rest may rebind Lake globals (`--dir`/`-d`/etc.); chdir(pkg);
resolveLakeAbs **before** chdir. Outside CLAIMED. STRICT: no IO.Process fall-back.
CLAIMED envelope stays `(build clean env test)` — serve is residual honesty dual path only. -/
public def cmdServe (rest : List String := []) : IO UInt32 := do

  let cwd ← IO.currentDir
  let pkg ← match ← findPackageDir cwd with
    | some p => pure p
    | none =>
      IO.eprintln "slake serve: no package root found (plausible lakefile walk-up)"
      return 1
  let lake ← lakeCmd
  let usePipe ← envFlagTruthy "SLAKE_USE_FS_PROC_PIPE"
  let useFs ← envFlagTruthy "SLAKE_USE_FS_PROC"
  let strict ← envFlagTruthy "SLAKE_FS_PROC_STRICT"
  if !usePipe && !useFs then
    return (← cmdServeIoProcess pkg lake rest)
  let linked := slakeFsProcLinked ()
  let pipeLinked := slakeFsProcPipeLinked ()
  let wantPipe := usePipe
  let pathLinked := if wantPipe then pipeLinked else linked
  let pathName := if wantPipe then "FS_PROC_PIPE" else "FS_PROC"
  if pathLinked != 1 then
    if strict then
      IO.eprintln s!"slake serve: SLAKE_USE_{pathName}=1 + STRICT but {pathName} shim not linked"
      return 1
    IO.eprintln s!"slake serve: SLAKE_USE_{pathName}=1 but {pathName} shim not linked; falling back"
    return (← cmdServeIoProcess pkg lake rest)
  match ← resolveLakeAbs with
  | none =>
    IO.eprintln s!"slake serve: cannot resolve absolute lake path for {pathName} (set LAKE=/abs/path)"
    if strict then
      IO.eprintln "slake serve: SLAKE_FS_PROC_STRICT=1; not falling back"
      return 1
    IO.eprintln "slake serve: falling back to IO.Process"
    return (← cmdServeIoProcess pkg lake rest)
  | some lakeAbs =>
    let code ← if wantPipe then cmdServeFsProcPipe pkg lakeAbs rest else cmdServeFsProc pkg lakeAbs rest
    if code == fsSpawnFail then
      if strict then
        IO.eprintln s!"slake serve: SLAKE_FS_PROC_STRICT=1; not falling back after {pathName} spawn fail"
        return 1
      IO.eprintln s!"slake serve: falling back to IO.Process after {pathName} spawn fail"
      return (← cmdServeIoProcess pkg lake rest)
    if code == fsWaitFail then
      IO.eprintln s!"slake serve: {pathName} wait fail (no IO.Process fall back)"
      return 1
    return code



/-- Classic `IO.Process` → `lake upload` in package dir (W80 parity growth base).

Requires package root (real `lake upload` uploads package build artifacts). -/
def cmdUploadIoProcess (pkg : FilePath) (lake : String) (rest : List String := []) : IO UInt32 := do
  cmdLakeForwardIoProcess "upload" pkg lake "upload" rest

/-- Freestanding Proc multi-arg path (`lake --dir=<pkg> upload [rest…]`).
Child env is **empty** (freestanding `execve` honesty — not a host-env clone).
Driver **chdir(pkg)** around spawn so relative path args match classic `cwd=pkg`
(freestanding spawn API has no cwd parameter; pack/cache/unpack/query/shake/serve/upload/lean alignment).
Returns process exit `0…255`, `fsSpawnFail`, or `fsWaitFail`. W99 FS_PROC upload.
Outside CLAIMED; rest argv plumbed like pack/cache/unpack/query/shake/serve (**not** empty-rest-only —
only `clean` is empty-rest-only). Rest may still rebind Lake globals (`--dir`/`-d`/etc.). -/
def cmdUploadFsProc (pkg : FilePath) (lakeAbs : String) (rest : List String := []) : IO UInt32 := do
  let restArr := rest.toArray
  let shown := " ".intercalate ("upload" :: rest)
  IO.println s!"slake upload: SLAKE_USE_FS_PROC=1; freestanding Systems.Proc multi-arg"
  IO.println s!"  lake={lakeAbs} --dir={pkg} {shown}"
  IO.println "  (empty child env — residual honesty dual path)"
  IO.println "  (upload FS_PROC chdir to package root for relative path parity with classic cwd=pkg)"
  let code := slakeFsRunLakeUpload pkg.toString lakeAbs restArr
  if code == fsSpawnFail then
    IO.eprintln "slake upload: freestanding Proc spawn failed"
    return code
  if code == fsWaitFail then
    IO.eprintln "slake upload: freestanding Proc wait failed"
    return code
  if code == 0 then
    IO.println "slake upload: OK (via lake / Systems.Proc)"
  else
    IO.eprintln s!"slake upload: lake exited {code} (Systems.Proc)"
  return code

/-- Freestanding Proc **pipe** path for `lake upload` (stdout capture demo). W99.
Same chdir(pkg) relative-path parity as multi-arg upload FS_PROC.
Rest plumbed (**not** empty-rest-only); rest may rebind Lake globals; CLAIMED unchanged. -/
def cmdUploadFsProcPipe (pkg : FilePath) (lakeAbs : String) (rest : List String := []) : IO UInt32 := do
  let restArr := rest.toArray
  let shown := " ".intercalate ("upload" :: rest)
  IO.println s!"slake upload: SLAKE_USE_FS_PROC_PIPE=1; freestanding Systems.Proc pipe/stdio"
  IO.println s!"  lake={lakeAbs} --dir={pkg} {shown}"
  IO.println "  (empty child env — residual honesty dual path)"
  IO.println "  (upload FS_PROC_PIPE chdir to package root for relative path parity with classic cwd=pkg)"
  let code := slakeFsRunLakeUploadPipe pkg.toString lakeAbs restArr
  if code == fsSpawnFail then
    IO.eprintln "slake upload: freestanding Proc pipe spawn failed"
    return code
  if code == fsWaitFail then
    IO.eprintln "slake upload: freestanding Proc pipe wait failed"
    return code
  if code == 0 then
    IO.println "slake upload: OK (via lake / Systems.Proc pipe)"
  else
    IO.eprintln s!"slake upload: lake exited {code} (Systems.Proc pipe)"
  return code

/-- `upload`: classic-host MVP — delegate to `lake upload` in the package dir.

Default: `IO.Process` → `lake upload` with `cwd=pkg` (parity green without extract).
Optional FS_PROC/PIPE (W99): freestanding empty child env; rest plumbed (**not** empty-rest-only —
only `clean` is); rest may rebind Lake globals (`--dir`/`-d`/etc.); chdir(pkg);
resolveLakeAbs **before** chdir. Outside CLAIMED. STRICT: no IO.Process fall-back.
CLAIMED envelope stays `(build clean env test)` — upload is residual honesty dual path only. -/
public def cmdUpload (rest : List String := []) : IO UInt32 := do
  let cwd ← IO.currentDir
  let pkg ← match ← findPackageDir cwd with
    | some p => pure p
    | none =>
      IO.eprintln "slake upload: no package root found (plausible lakefile walk-up)"
      return 1
  let lake ← lakeCmd
  let usePipe ← envFlagTruthy "SLAKE_USE_FS_PROC_PIPE"
  let useFs ← envFlagTruthy "SLAKE_USE_FS_PROC"
  let strict ← envFlagTruthy "SLAKE_FS_PROC_STRICT"
  if !usePipe && !useFs then
    return (← cmdUploadIoProcess pkg lake rest)
  let linked := slakeFsProcLinked ()
  let pipeLinked := slakeFsProcPipeLinked ()
  let wantPipe := usePipe
  let pathLinked := if wantPipe then pipeLinked else linked
  let pathName := if wantPipe then "FS_PROC_PIPE" else "FS_PROC"
  if pathLinked != 1 then
    if strict then
      IO.eprintln s!"slake upload: SLAKE_USE_{pathName}=1 + STRICT but {pathName} shim not linked"
      return 1
    IO.eprintln s!"slake upload: SLAKE_USE_{pathName}=1 but {pathName} shim not linked; falling back"
    return (← cmdUploadIoProcess pkg lake rest)
  match ← resolveLakeAbs with
  | none =>
    IO.eprintln s!"slake upload: cannot resolve absolute lake path for {pathName} (set LAKE=/abs/path)"
    if strict then
      IO.eprintln "slake upload: SLAKE_FS_PROC_STRICT=1; not falling back"
      return 1
    IO.eprintln "slake upload: falling back to IO.Process"
    return (← cmdUploadIoProcess pkg lake rest)
  | some lakeAbs =>
    let code ← if wantPipe then cmdUploadFsProcPipe pkg lakeAbs rest else cmdUploadFsProc pkg lakeAbs rest
    if code == fsSpawnFail then
      if strict then
        IO.eprintln s!"slake upload: SLAKE_FS_PROC_STRICT=1; not falling back after {pathName} spawn fail"
        return 1
      IO.eprintln s!"slake upload: falling back to IO.Process after {pathName} spawn fail"
      return (← cmdUploadIoProcess pkg lake rest)
    if code == fsWaitFail then
      IO.eprintln s!"slake upload: {pathName} wait fail (no IO.Process fall back)"
      return 1
    return code

/-- Classic `IO.Process` → `lake translate-config` in package dir (W81 parity growth base; W105 dual residual).

Thin forward; remaining argv after the command token is plumbed (W85).
Requires package root (rewrites package config language). -/
public def cmdTranslateConfigIoProcess (pkg : FilePath) (lake : String) (rest : List String := []) : IO UInt32 := do
  cmdLakeForwardIoProcess "translate-config" pkg lake "translate-config" rest

/-- Freestanding Proc multi-arg path (`lake --dir=<pkg> translate-config [rest…]`).

Returns process exit `0…255`, `fsSpawnFail`, or `fsWaitFail`. W105 FS_PROC translate-config.
Empty child env; rest plumbed (**not** empty-rest-only); chdir(pkg); lakeAbs pre-resolved. -/
def cmdTranslateConfigFsProc (pkg : FilePath) (lakeAbs : String) (rest : List String := []) : IO UInt32 := do
  let restArr := rest.toArray
  let shown := " ".intercalate ("translate-config" :: rest)
  IO.println s!"slake translate-config: SLAKE_USE_FS_PROC=1; freestanding Systems.Proc multi-arg"
  IO.println s!"  lake={lakeAbs} --dir={pkg} {shown}"
  IO.println "  (empty child env; inherits no host LAKE_*/LEAN_* — dual residual vs classic IO.Process)"
  IO.println "  (translate-config FS_PROC chdir to package root for relative path parity with classic cwd=pkg)"
  let code := slakeFsRunLakeTranslateConfig pkg.toString lakeAbs restArr
  if code == fsSpawnFail then
    IO.eprintln "slake translate-config: freestanding Proc spawn failed"
    return code
  if code == fsWaitFail then
    IO.eprintln "slake translate-config: freestanding Proc wait failed"
    return code
  if code == 0 then
    IO.println "slake translate-config: OK (via lake / Systems.Proc)"
  else
    IO.eprintln s!"slake translate-config: lake exited {code} (Systems.Proc)"
  return code

/-- Freestanding Proc **pipe** path for `lake translate-config` (stdout capture demo). W105.
Same chdir(pkg) relative-path parity as multi-arg translate-config FS_PROC. -/
def cmdTranslateConfigFsProcPipe (pkg : FilePath) (lakeAbs : String) (rest : List String := []) : IO UInt32 := do
  let restArr := rest.toArray
  let shown := " ".intercalate ("translate-config" :: rest)
  IO.println s!"slake translate-config: SLAKE_USE_FS_PROC_PIPE=1; freestanding Systems.Proc pipe/stdio"
  IO.println s!"  lake={lakeAbs} --dir={pkg} {shown}"
  IO.println "  (empty child env; inherits no host LAKE_*/LEAN_* — dual residual vs classic IO.Process)"
  IO.println "  (translate-config FS_PROC_PIPE chdir to package root for relative path parity with classic cwd=pkg)"
  let code := slakeFsRunLakeTranslateConfigPipe pkg.toString lakeAbs restArr
  if code == fsSpawnFail then
    IO.eprintln "slake translate-config: freestanding Proc pipe spawn failed"
    return code
  if code == fsWaitFail then
    IO.eprintln "slake translate-config: freestanding Proc pipe wait failed"
    return code
  if code == 0 then
    IO.println "slake translate-config: OK (via lake / Systems.Proc pipe)"
  else
    IO.eprintln s!"slake translate-config: lake exited {code} (Systems.Proc pipe)"
  return code

/-- `translate-config`: classic-host MVP — delegate to `lake translate-config` in the package dir.

Default: `IO.Process` → `lake translate-config` with `cwd=pkg` (parity green without extract).
Optional FS_PROC/PIPE (W105): freestanding empty child env; rest plumbed (**not** empty-rest-only —
only `clean` is); rest may rebind Lake globals (`--dir`/`-d`/etc.); chdir(pkg);
resolveLakeAbs **before** chdir. Outside CLAIMED. STRICT: no IO.Process fall-back.
CLAIMED envelope stays `(build clean env test)` — translate-config is residual honesty dual path only.
Plumbed-like peers for this cmd end at prior peer `…/version-tags` (not including self). -/
public def cmdTranslateConfig (rest : List String := []) : IO UInt32 := do
  let cwd ← IO.currentDir
  let pkg ← match ← findPackageDir cwd with
    | some p => pure p
    | none =>
      IO.eprintln "slake translate-config: no package root found (plausible lakefile walk-up)"
      return 1
  let lake ← lakeCmd
  let usePipe ← envFlagTruthy "SLAKE_USE_FS_PROC_PIPE"
  let useFs ← envFlagTruthy "SLAKE_USE_FS_PROC"
  let strict ← envFlagTruthy "SLAKE_FS_PROC_STRICT"
  if !usePipe && !useFs then
    return (← cmdTranslateConfigIoProcess pkg lake rest)
  let linked := slakeFsProcLinked ()
  let pipeLinked := slakeFsProcPipeLinked ()
  let wantPipe := usePipe
  let pathLinked := if wantPipe then pipeLinked else linked
  let pathName := if wantPipe then "FS_PROC_PIPE" else "FS_PROC"
  if pathLinked != 1 then
    if strict then
      IO.eprintln s!"slake translate-config: SLAKE_USE_{pathName}=1 + STRICT but {pathName} shim not linked"
      return 1
    IO.eprintln s!"slake translate-config: SLAKE_USE_{pathName}=1 but {pathName} shim not linked; falling back"
    return (← cmdTranslateConfigIoProcess pkg lake rest)
  match ← resolveLakeAbs with
  | none =>
    IO.eprintln s!"slake translate-config: cannot resolve absolute lake path for {pathName} (set LAKE=/abs/path)"
    if strict then
      IO.eprintln "slake translate-config: SLAKE_FS_PROC_STRICT=1; not falling back"
      return 1
    IO.eprintln "slake translate-config: falling back to IO.Process"
    return (← cmdTranslateConfigIoProcess pkg lake rest)
  | some lakeAbs =>
    let code ← if wantPipe then cmdTranslateConfigFsProcPipe pkg lakeAbs rest else cmdTranslateConfigFsProc pkg lakeAbs rest
    if code == fsSpawnFail then
      if strict then
        IO.eprintln s!"slake translate-config: SLAKE_FS_PROC_STRICT=1; not falling back after {pathName} spawn fail"
        return 1
      IO.eprintln s!"slake translate-config: falling back to IO.Process after {pathName} spawn fail"
      return (← cmdTranslateConfigIoProcess pkg lake rest)
    if code == fsWaitFail then
      IO.eprintln s!"slake translate-config: {pathName} wait fail (no IO.Process fall back)"
      return 1
    return code

/-- Classic `IO.Process` → `lake run` in package dir (W81 parity growth base; W106 dual residual).

Thin forward; remaining argv after the command token is plumbed (W85).
Requires package root (real `lake run` is shorthand for `lake script run`). -/
public def cmdRunIoProcess (pkg : FilePath) (lake : String) (rest : List String := []) : IO UInt32 := do
  cmdLakeForwardIoProcess "run" pkg lake "run" rest

/-- Freestanding Proc multi-arg path (`lake --dir=<pkg> run [rest…]`).

Returns process exit `0…255`, `fsSpawnFail`, or `fsWaitFail`. W106 FS_PROC run.
Empty child env; rest plumbed (**not** empty-rest-only); chdir(pkg); lakeAbs pre-resolved. -/
def cmdRunFsProc (pkg : FilePath) (lakeAbs : String) (rest : List String := []) : IO UInt32 := do
  let restArr := rest.toArray
  let shown := " ".intercalate ("run" :: rest)
  IO.println s!"slake run: SLAKE_USE_FS_PROC=1; freestanding Systems.Proc multi-arg"
  IO.println s!"  lake={lakeAbs} --dir={pkg} {shown}"
  IO.println "  (empty child env; inherits no host LAKE_*/LEAN_* — dual residual vs classic IO.Process)"
  IO.println "  (run FS_PROC chdir to package root for relative path parity with classic cwd=pkg)"
  let code := slakeFsRunLakeRun pkg.toString lakeAbs restArr
  if code == fsSpawnFail then
    IO.eprintln "slake run: freestanding Proc spawn failed"
    return code
  if code == fsWaitFail then
    IO.eprintln "slake run: freestanding Proc wait failed"
    return code
  if code == 0 then
    IO.println "slake run: OK (via lake / Systems.Proc)"
  else
    IO.eprintln s!"slake run: lake exited {code} (Systems.Proc)"
  return code

/-- Freestanding Proc **pipe** path for `lake run` (stdout capture demo). W106.
Same chdir(pkg) relative-path parity as multi-arg run FS_PROC. -/
def cmdRunFsProcPipe (pkg : FilePath) (lakeAbs : String) (rest : List String := []) : IO UInt32 := do
  let restArr := rest.toArray
  let shown := " ".intercalate ("run" :: rest)
  IO.println s!"slake run: SLAKE_USE_FS_PROC_PIPE=1; freestanding Systems.Proc pipe/stdio"
  IO.println s!"  lake={lakeAbs} --dir={pkg} {shown}"
  IO.println "  (empty child env; inherits no host LAKE_*/LEAN_* — dual residual vs classic IO.Process)"
  IO.println "  (run FS_PROC_PIPE chdir to package root for relative path parity with classic cwd=pkg)"
  let code := slakeFsRunLakeRunPipe pkg.toString lakeAbs restArr
  if code == fsSpawnFail then
    IO.eprintln "slake run: freestanding Proc pipe spawn failed"
    return code
  if code == fsWaitFail then
    IO.eprintln "slake run: freestanding Proc pipe wait failed"
    return code
  if code == 0 then
    IO.println "slake run: OK (via lake / Systems.Proc pipe)"
  else
    IO.eprintln s!"slake run: lake exited {code} (Systems.Proc pipe)"
  return code

/-- `run`: classic-host MVP — delegate to `lake run` in the package dir.

Default: `IO.Process` → `lake run` with `cwd=pkg` (parity green without extract).
Optional FS_PROC/PIPE (W106): freestanding empty child env; rest plumbed (**not** empty-rest-only —
only `clean` is); rest may rebind Lake globals (`--dir`/`-d`/etc.); chdir(pkg);
resolveLakeAbs **before** chdir. Outside CLAIMED. STRICT: no IO.Process fall-back.
CLAIMED envelope stays `(build clean env test)` — run is residual honesty dual path only.
Plumbed-like peers for this cmd end at prior peer `…/translate-config` (not including self). -/
public def cmdRun (rest : List String := []) : IO UInt32 := do
  let cwd ← IO.currentDir
  let pkg ← match ← findPackageDir cwd with
    | some p => pure p
    | none =>
      IO.eprintln "slake run: no package root found (plausible lakefile walk-up)"
      return 1
  let lake ← lakeCmd
  let usePipe ← envFlagTruthy "SLAKE_USE_FS_PROC_PIPE"
  let useFs ← envFlagTruthy "SLAKE_USE_FS_PROC"
  let strict ← envFlagTruthy "SLAKE_FS_PROC_STRICT"
  if !usePipe && !useFs then
    return (← cmdRunIoProcess pkg lake rest)
  let linked := slakeFsProcLinked ()
  let pipeLinked := slakeFsProcPipeLinked ()
  let wantPipe := usePipe
  let pathLinked := if wantPipe then pipeLinked else linked
  let pathName := if wantPipe then "FS_PROC_PIPE" else "FS_PROC"
  if pathLinked != 1 then
    if strict then
      IO.eprintln s!"slake run: SLAKE_USE_{pathName}=1 + STRICT but {pathName} shim not linked"
      return 1
    IO.eprintln s!"slake run: SLAKE_USE_{pathName}=1 but {pathName} shim not linked; falling back"
    return (← cmdRunIoProcess pkg lake rest)
  match ← resolveLakeAbs with
  | none =>
    IO.eprintln s!"slake run: cannot resolve absolute lake path for {pathName} (set LAKE=/abs/path)"
    if strict then
      IO.eprintln "slake run: SLAKE_FS_PROC_STRICT=1; not falling back"
      return 1
    IO.eprintln "slake run: falling back to IO.Process"
    return (← cmdRunIoProcess pkg lake rest)
  | some lakeAbs =>
    let code ← if wantPipe then cmdRunFsProcPipe pkg lakeAbs rest else cmdRunFsProc pkg lakeAbs rest
    if code == fsSpawnFail then
      if strict then
        IO.eprintln s!"slake run: SLAKE_FS_PROC_STRICT=1; not falling back after {pathName} spawn fail"
        return 1
      IO.eprintln s!"slake run: falling back to IO.Process after {pathName} spawn fail"
      return (← cmdRunIoProcess pkg lake rest)
    if code == fsWaitFail then
      IO.eprintln s!"slake run: {pathName} wait fail (no IO.Process fall back)"
      return 1
    return code


/-- Freestanding Proc multi-arg path (`lake --dir=<pkg> build [rest…]`).

Child env is **empty** (freestanding `execve` honesty — not a host-env clone).
Returns process exit `0…255`, `fsSpawnFail`, or `fsWaitFail`. -/
def cmdBuildFsProc (pkg : FilePath) (lakeAbs : String) (rest : List String := []) : IO UInt32 := do
  let restA := rest.toArray
  let shown := " ".intercalate ("build" :: rest)
  IO.println s!"slake build: SLAKE_USE_FS_PROC=1; freestanding Systems.Proc multi-arg"
  IO.println s!"  lake={lakeAbs} --dir={pkg} {shown}"
  IO.println "  (FS_PROC child env empty — does not inherit host LEAN_PATH/PATH)"
  let code := slakeFsRunLakeBuild pkg.toString lakeAbs restA
  if code == fsSpawnFail then
    IO.eprintln "slake build: freestanding Proc spawn failed"
    return code
  if code == fsWaitFail then
    IO.eprintln "slake build: freestanding Proc wait failed"
    return code
  if code == 0 then
    IO.println "slake build: OK (via lake / Systems.Proc)"
  else
    IO.eprintln s!"slake build: lake exited {code} (Systems.Proc)"
  return code

/-- Freestanding Proc **pipe** path (`lake --dir=<pkg> build [rest…]` with stdout capture).

Uses `lean_fs_proc_pipe` + `lean_fs_proc_spawn_argv_pipe` via Option C shim.
Demo/capture only — not full Lake IO redirect product (stderr still inherits).
Child env empty. Returns same status encoding as `cmdBuildFsProc`. -/
def cmdBuildFsProcPipe (pkg : FilePath) (lakeAbs : String) (rest : List String := []) : IO UInt32 := do
  let restA := rest.toArray
  let shown := " ".intercalate ("build" :: rest)
  IO.println s!"slake build: SLAKE_USE_FS_PROC_PIPE=1; freestanding Systems.Proc pipe/stdio"
  IO.println s!"  lake={lakeAbs} --dir={pkg} {shown}"
  IO.println "  (FS_PROC_PIPE stdout→parent pipe capture demo; child env empty)"
  IO.println "  (not full Lake IO redirect product — residual honesty)"
  let code := slakeFsRunLakeBuildPipe pkg.toString lakeAbs restA
  if code == fsSpawnFail then
    IO.eprintln "slake build: freestanding Proc pipe spawn failed"
    return code
  if code == fsWaitFail then
    IO.eprintln "slake build: freestanding Proc pipe wait failed"
    return code
  if code == 0 then
    IO.println "slake build: OK (via lake / Systems.Proc pipe)"
  else
    IO.eprintln s!"slake build: lake exited {code} (Systems.Proc pipe)"
  return code

/-- Max nodes for freestanding package topo (matches `PKG_MAX` in C). -/
def depgraphPkgMaxNodes : Nat := 16

/-- Map freestanding topo indices (via `chainOutAt`) to plan node labels. -/
def collectFsTopoLabels (nodes : List String) (n : Nat) : Option (List String) :=
  let rec collect (i : Nat) (acc : List String) : Option (List String) :=
    if i >= n then some acc.reverse
    else
      let idx := slakeFsDepgraphChainOutAt i.toUInt32
      if idx == 0xffffffff then none
      else
        let j := idx.toNat
        if j >= n then none
        else
          match nodes[j]? with
          | some lab => collect (i + 1) (lab :: acc)
          | none => none
  collect 0 []

/-- Honesty suffix for plan banners: mention per-lib roots/srcDir (A16),
per-lib globs recursive multi-level (A24/A25), path requires (A26), or package
srcDir/nested only when this package actually used those shapes.

Flat undotted packages with import edges keep plain import-scan wording. -/
def planPathHonestyNote (id : Slake.Config.PackageIdentity) (nodes : List String)
    (transitivePlan : Bool := false) : String :=
  let perLib := Slake.Config.hasPerLibRootsOrSrcDir id
  let globs := Slake.Config.usesPerLibGlobs id
  let pathReq := Slake.Config.hasPathRequires id
  let usedNested :=
    id.srcDir.isSome || perLib || globs || pathReq || nodes.any (fun n => n.any (· == '.'))
  let pathReqNote :=
    if pathReq then
      "; path [[require]] subset (LEAN_PATH + path-dep olean precompile + A29 sibling confining ../path under package-parent + A27 path-dep → root cascade path-dep-olean-newer + A28 path-dep source-hash fold into A11 deps-line" ++
        (if transitivePlan then
          " + A30 package-transitive plan subset — not git/url / not Lake resolve-deps / not multi-.. escape / not freestanding build TCB / not CLAIMED)"
        else
          " — not git/url / not Lake resolve-deps / not multi-.. escape / not freestanding build TCB / not CLAIMED)")
    else if transitivePlan then
      "; package-transitive plan subset (import-driven path-dep plan modules folded into root plan — not Lake resolve-deps / not git/url / not freestanding build TCB / not CLAIMED)"
    else ""
  if globs && perLib then
    "; per-lib roots/srcDir + globs recursive multi-level subset — not full Lake Glob / faceting / not build TCB" ++ pathReqNote
  else if globs then
    "; per-lib globs recursive multi-level subset — not full Lake Glob / faceting / package imports / not build TCB" ++ pathReqNote
  else if perLib then
    "; per-lib roots/srcDir subset — not full Lake import resolution / faceting / not build TCB" ++ pathReqNote
  else if pathReq then
    pathReqNote
  else if usedNested then
    "; srcDir/nested path resolution used — not full Lake import resolution / not build TCB"
  else
    " — not full Lake import resolution / not build TCB"

/-- Print host-only package plan (import-scan host Kahn when edges exist).

Returns `some ordered` on success, `none` on hard fail (errors already printed).
Fail-closed on cycle / bounds / node-count OOB (aligned with freestanding path —
no silent chain fallback when import edges were present but Kahn failed). -/
def printHostPackagePlan (pkg : FilePath) (id : Slake.Config.PackageIdentity)
    (nodes : List String) (extraSrc : List (String × FilePath) := [])
    (transitivePlan : Bool := false) : IO (Option (List String)) := do
  let n := nodes.length
  if n == 0 || n > depgraphPkgMaxNodes then
    IO.eprintln s!"slake build: package plan node count {n} out of range 1..{depgraphPkgMaxNodes}"
    return none
  let edges ← Slake.Config.collectImportEdges pkg nodes id extraSrc
  if edges.isEmpty then
    IO.println "slake build: package plan (host Config scan; freestanding DepGraph not used)"
    IO.println s!"  ({Slake.Config.formatIdentity id}; declaration-order chain — no package import edges{planPathHonestyNote id nodes transitivePlan})"
    if transitivePlan then
      IO.println "  (package-transitive plan subset — import-driven path-dep plan modules folded into root plan; not Lake resolve-deps / not git/url / not freestanding build TCB / not CLAIMED)"
    IO.println s!"slake depgraph plan: {Slake.Config.formatPlanNodes nodes}"
    return some nodes
  else
    IO.println "slake build: package plan (host Config + import-scan Kahn; freestanding DepGraph not used)"
    IO.println s!"  ({Slake.Config.formatIdentity id}; import-scan DAG subset, {edges.length} edge(s){planPathHonestyNote id nodes transitivePlan})"
    match Slake.Config.hostKahnTopo n edges with
    | none =>
      IO.eprintln "slake build: host import-scan Kahn failed (cycle or bounds)"
      return none
    | some order =>
      let rec labs (idxs : List Nat) (acc : List String) : Option (List String) :=
        match idxs with
        | [] => some acc.reverse
        | i :: rest =>
          match nodes[i]? with
          | some lab => labs rest (lab :: acc)
          | none => none
      match labs order [] with
      | none =>
        IO.eprintln "slake build: host import-scan order OOB"
        return none
      | some ordered =>
        IO.println s!"slake depgraph plan: {Slake.Config.formatPlanNodes ordered}"
        return some ordered

/-- Print package-derived freestanding DepGraph plan; import-scan edges or chain.

Returns `some ordered` on success, `none` on hard fail (errors already printed).
Fail-closed on cycle / degree overflow / bounds when import edges are present
(aligned with host path — no silent declaration-order fallback). -/
def printFsPackagePlan (pkg : FilePath) (id : Slake.Config.PackageIdentity)
    (nodes : List String) (extraSrc : List (String × FilePath) := [])
    (transitivePlan : Bool := false) : IO (Option (List String)) := do
  let n := nodes.length
  if n == 0 || n > depgraphPkgMaxNodes then
    IO.eprintln s!"slake build: package plan node count {n} out of range 1..{depgraphPkgMaxNodes}"
    return none
  let edges ← Slake.Config.collectImportEdges pkg nodes id extraSrc
  if edges.isEmpty then
    IO.println "slake build: freestanding DepGraph Kahn topo (package-derived)"
    -- A30: path-require honesty + package-transitive plan subset when expanded.
    IO.println s!"  ({Slake.Config.formatIdentity id}; chain = declaration order — no package import edges{planPathHonestyNote id nodes transitivePlan})"
    let st := slakeFsDepgraphChainTopo n.toUInt32
    if st != 0 then
      IO.eprintln "slake build: freestanding DepGraph package plan failed"
      return none
  else
    IO.println "slake build: freestanding DepGraph Kahn topo (package-derived; import-scan DAG subset)"
    IO.println s!"  ({Slake.Config.formatIdentity id}; {edges.length} import edge(s) among plan nodes{planPathHonestyNote id nodes transitivePlan})"
    let _ := slakeFsDepgraphEdgeClear ()
    let rec addAll (es : List (Nat × Nat)) : Bool :=
      match es with
      | [] => true
      | (s, d) :: rest =>
        if slakeFsDepgraphEdgeAdd s.toUInt32 d.toUInt32 != 0 then false
        else addAll rest
    if !addAll edges then
      IO.eprintln "slake build: freestanding DepGraph edge staging failed"
      return none
    let st := slakeFsDepgraphEdgesTopo n.toUInt32
    if st != 0 then
      IO.eprintln "slake build: freestanding DepGraph import-scan topo failed (cycle or bounds)"
      return none
  match collectFsTopoLabels nodes n with
  | none =>
    IO.eprintln "slake build: freestanding DepGraph package plan order OOB"
    return none
  | some ordered =>
    IO.println s!"slake depgraph plan: {Slake.Config.formatPlanNodes ordered}"
    return some ordered

/-- Absolute-resolve a relative `LEAN` path against process cwd.

Bare command names (no `/`, `\`, or leading `.`) stay bare for PATH lookup.
Relative paths are joined with `IO.currentDir` so spawn with `cwd=pkg` still
finds the binary. Absolute paths are left unchanged. -/
def resolveLeanPathForSpawn (raw : String) : IO String := do
  let p := FilePath.mk raw
  if p.isAbsolute then
    pure raw
  else if raw.any (fun c => c == '/' || c == '\\') || raw.startsWith "." then
    let cwd ← IO.currentDir
    pure (cwd / raw).normalize.toString
  else
    pure raw

/-- Resolve host `lean` binary for `SLAKE_NATIVE_CHECK`.

Prefers `LEAN` env, else `lean` on PATH. Probes with `--version` and requires
**exit 0** plus a Lean version marker in stdout/stderr (rejects `/bin/true` and
other non-Lean tools). Relative `LEAN` paths are absolute-resolved against the
process cwd before probe/spawn. Spawn failure / bad probe → `none` (caller
soft-skips or STRICT-fails). -/
def resolveLeanCmd : IO (Option String) := do
  let raw ← match ← IO.getEnv "LEAN" with
    | some c =>
      let t := c.trimAscii.toString
      if t.isEmpty then pure "lean" else pure t
    | none => pure "lean"
  let cmd ← resolveLeanPathForSpawn raw
  match ← (IO.Process.output { cmd := cmd, args := #["--version"] }).toBaseIO with
  | .error _ => pure none
  | .ok out =>
    if out.exitCode != 0 then
      pure none
    else
      -- Require a Lean identity marker so non-Lean exit-0 tools cannot green-wash.
      let looksLean :=
        out.stdout.contains "Lean" || out.stderr.contains "Lean"
      if looksLean then pure (some cmd) else pure none

/-- A26: max depth for path-`[[require]]` LEAN_PATH walk / olean precompile.

Cycle residual: depth cap only (not full Lake resolve-deps / not package graph
cycle detection TCB). -/
def pathRequireMaxDepth : Nat := 4

-- `isRealPathRequireDir` is defined with A17 clean helpers (shared A26 LEAN_PATH +
-- A33 path-require wipe real-dir fence).

/-- Host plan order without printing (A26 path-dep precompile).

Same Kahn / declaration-order rules as `printHostPackagePlan`; returns `none` on
node-count OOB or Kahn failure. -/
def hostPlanOrder (pkg : FilePath) (id : Slake.Config.PackageIdentity)
    (nodes : List String) (extraSrc : List (String × FilePath) := [])
    : IO (Option (List String)) := do
  let n := nodes.length
  if n == 0 || n > depgraphPkgMaxNodes then
    return none
  let edges ← Slake.Config.collectImportEdges pkg nodes id extraSrc
  if edges.isEmpty then
    return some nodes
  else
    match Slake.Config.hostKahnTopo n edges with
    | none => return none
    | some order =>
      let rec labs (idxs : List Nat) (acc : List String) : Option (List String) :=
        match idxs with
        | [] => some acc.reverse
        | i :: rest =>
          match nodes[i]? with
          | some lab => labs rest (lab :: acc)
          | none => none
      pure (labs order [])

/-- A26: LEAN_PATH search roots for path `[[require]]` deps (depth-bounded).

For each safe relative path require whose target is a **real directory** (exists,
not symlink, not file — lstat fence): nested path-require roots first, then dep
`.slake-native`, dep safe srcDirs, dep package root. Missing / symlink / file
targets skipped (caller may fail-closed on precompile). Not git/url / not Lake
resolve-deps. A30 folds imported path-dep plan modules into root plan separately. -/
partial def collectPathRequireSearchRoots (pkg : FilePath)
    (id : Slake.Config.PackageIdentity) (depth : Nat) : IO (List FilePath) := do
  if depth == 0 then
    return []
  let rec go (rs : List Slake.Config.RequireIdentity) (acc : List FilePath)
      : IO (List FilePath) := do
    match rs with
    | [] => pure acc
    | r :: rest =>
      match Slake.Config.resolveRequirePath pkg r with
      | none => go rest acc
      | some depPkg =>
        if !(← isRealPathRequireDir depPkg) then
          go rest acc
        else
          let depId ← Slake.Config.readPackageIdentity depPkg
          let nested ← collectPathRequireSearchRoots depPkg depId (depth - 1)
          let depOut := depPkg / ".slake-native"
          let srcDirs := Slake.Config.allSafeSrcDirs depId
          let dirPaths : List FilePath := srcDirs.map (fun (d : String) => depPkg / d)
          go rest (acc ++ nested ++ (depOut :: dirPaths ++ [depPkg]))
  go (Slake.Config.pathRequires id) []

/-- `LEAN_PATH` for native check: package root (+ safe package/per-lib `srcDir`s),
A26 path-require roots (dep `.slake-native` + dep srcDirs + dep root), then any
existing host `LEAN_PATH`. Multi-module / path-dep imports still need oleans
(A26 precompile) — residual honesty. -/
def nativeCheckLeanPath (pkg : FilePath) (id : Slake.Config.PackageIdentity) : IO String := do
  let srcDirs := Slake.Config.allSafeSrcDirs id
  let dirPaths : List FilePath := srcDirs.map (fun (d : String) => pkg / d)
  let reqRoots ← collectPathRequireSearchRoots pkg id pathRequireMaxDepth
  let roots : SearchPath := dirPaths ++ [pkg] ++ reqRoots
  match ← IO.getEnv "LEAN_PATH" with
  | none => pure (SearchPath.toString roots)
  | some existing =>
    let rest := SearchPath.parse existing
    pure (SearchPath.toString (roots ++ rest))

/-- A7: sequential host-lean typecheck of topo-ordered plan module nodes.

Skips the package `name` node (not a module file) and `(unknown)`. Resolves each
label via `resolveModulePath` (srcDir + dotted + confinement). Spawns classic
`IO.Process` → `lean <file>` with `cwd=pkg` and child `LEAN_PATH` including the
package root (+ safe srcDir + A26 path-require roots). Missing lean / missing
file: soft warn unless `SLAKE_NATIVE_CHECK_STRICT=1` (fail-closed). Zero modules
actually typechecked: warn (and STRICT-fail) rather than unconditional OK.
Nonzero lean exit → fail and name the module. Honesty: thin sequential host
typecheck subset — **not** freestanding build TCB / **not** olean graph
orchestration / **not** CLAIMED / multi-module imports without oleans may fail
(documented limit; A26 precompiles path-dep oleans when path requires exist). -/
def runNativeTypecheck (pkg : FilePath) (id : Slake.Config.PackageIdentity)
    (ordered : List String) : IO (Option UInt32) := do
  let strict ← envFlagTruthy "SLAKE_NATIVE_CHECK_STRICT"
  let lean ← match ← resolveLeanCmd with
    | some c => pure c
    | none =>
      if strict then
        IO.eprintln "slake build: SLAKE_NATIVE_CHECK=1 but lean not found or not a real Lean binary (set LEAN= to absolute lean; relative LEAN is cwd-resolved); STRICT"
        return some 1
      else
        IO.eprintln "slake build: SLAKE_NATIVE_CHECK=1 but lean not found or not a real Lean binary; skipping native check"
        return none
  let leanPath ← nativeCheckLeanPath pkg id
  IO.println "slake build: SLAKE_NATIVE_CHECK=1; sequential host-lean typecheck"
  IO.println "  (thin subset — not freestanding build TCB / not olean orchestration / not CLAIMED)"
  if Slake.Config.hasPathRequires id then
    IO.println "  (A26 path [[require]] LEAN_PATH subset — path-dep olean precompile runs before check when requires present; not git/url / not Lake resolve-deps / not freestanding build TCB / not CLAIMED)"
  IO.println s!"  lean={lean} cwd={pkg} LEAN_PATH={leanPath}"
  let pkgName := id.name
  let rec go (nodes : List String) (checked : Nat) : IO (Option UInt32) := do
    match nodes with
    | [] =>
      if checked == 0 then
        if strict then
          IO.eprintln "slake build: native check: no modules typechecked (STRICT)"
          return some 1
        else
          IO.eprintln "slake build: native check: warn — no modules typechecked (all skipped or package-name-only plan)"
          return none
      else
        IO.println s!"slake build: native check OK (host lean sequential; {checked} module(s))"
        return none
    | n :: rest =>
      if pkgName == some n || n == "(unknown)" then
        go rest checked
      else
        match ← Slake.Config.resolveModulePathFor pkg id n with
        | none =>
          if strict then
            IO.eprintln s!"slake build: native check: unresolvable module {n} (STRICT)"
            return some 1
          else
            IO.eprintln s!"slake build: native check: skip unresolvable module {n}"
            go rest checked
        | some path => do
          if !(← path.pathExists) then
            if strict then
              IO.eprintln s!"slake build: native check: missing file for {n} at {path} (STRICT)"
              return some 1
            else
              IO.eprintln s!"slake build: native check: skip missing file for {n} at {path}"
              go rest checked
          else
            IO.println s!"slake build: native check: {lean} {path}"
            let child ← IO.Process.spawn {
              cmd := lean
              args := #[path.toString]
              cwd := some pkg
              env := #[("LEAN_PATH", some leanPath)]
            }
            let code ← child.wait
            if code != 0 then
              IO.eprintln s!"slake build: native check failed for module {n} (lean exited {code})"
              return some code
            go rest (checked + 1)
  go ordered 0

/-- Package-local olean output root for A8 `SLAKE_NATIVE_OLEAN` (not Lake `.lake/build`). -/
def nativeOleanOutDir (pkg : FilePath) : FilePath :=
  pkg / ".slake-native"

/-- Relative olean path under the olean out dir: `Foo.Bar` → `Foo/Bar.olean`.

Returns `none` when `modName` fails `isSafeModName` (path-escape fail-closed). -/
def moduleOleanRel (modName : String) : Option FilePath :=
  if !Slake.Config.isSafeModName modName then none
  else some (FilePath.mk (("/".intercalate (modName.splitOn ".")) ++ ".olean"))

/-- Absolute olean output path under package-local `.slake-native/`. -/
def moduleOleanOutPath (outDir : FilePath) (modName : String) : Option FilePath :=
  match moduleOleanRel modName with
  | none => none
  | some rel => some (outDir / rel)

/-- `LEAN_PATH` for A8 native olean compile: package-local `.slake-native` first
(so earlier modules' oleans are found), then package root (+ safe package/per-lib
`srcDir`s), then A26 path-require roots (dep `.slake-native` + dep srcDirs + dep
root, depth-bounded), then any existing host `LEAN_PATH`. Not Lake `.lake/build`
compatibility / not git/url require TCB. -/
def nativeOleanLeanPath (pkg : FilePath) (outDir : FilePath)
    (id : Slake.Config.PackageIdentity) : IO String := do
  let srcDirs := Slake.Config.allSafeSrcDirs id
  let dirPaths : List FilePath := srcDirs.map (fun (d : String) => pkg / d)
  let reqRoots ← collectPathRequireSearchRoots pkg id pathRequireMaxDepth
  let pkgRoots : SearchPath := outDir :: dirPaths ++ [pkg] ++ reqRoots
  match ← IO.getEnv "LEAN_PATH" with
  | none => pure (SearchPath.toString pkgRoots)
  | some existing =>
    let rest := SearchPath.parse existing
    pure (SearchPath.toString (pkgRoots ++ rest))

/-- True when `path` is under directory `root` (normalized string prefix + separator).

Used so `-R srcDir` is only passed when the **resolved** module file lives under
`pkg/srcDir` (not when A6 flat package-root fallback won). -/
def pathIsUnderDir (root : FilePath) (path : FilePath) : Bool :=
  let r := root.normalize.toString
  let p := path.normalize.toString
  if p == r then true
  else
    let sep := FilePath.pathSeparator.toString
    p.startsWith (r ++ sep)

/-- Package-cwd-relative path string for spawn argv and portable graph artifacts.

Prefer relative forms under `pkg` (e.g. `Core.lean`, `.slake-native/Core.olean`,
`dep/.slake-native/Dep.olean`) so tools see paths consistent with `cwd=pkg`.
**A29/A32:** when `path` is under the package parent (sibling confining
`path = "../dep"`), emit a single leading `../` form
(e.g. `../dep/.slake-native/Dep.olean`) — not multi-`..`, not absolute host
paths. Falls back to absolute only when neither under-pkg nor single-parent
relative applies. -/
def pathRelToPkg (pkg : FilePath) (path : FilePath) : String :=
  let pkgS := pkg.normalize.toString
  let pathS := path.normalize.toString
  if pathS == pkgS then "."
  else
    let sep := FilePath.pathSeparator.toString
    let pkgPrefix := pkgS ++ sep
    if pathS.startsWith pkgPrefix then
      (pathS.drop pkgPrefix.length).copy
    else
      -- A29: single package-parent relative (sibling confining require path).
      match pkg.parent with
      | none => path.toString
      | some parent =>
        let parentS := parent.normalize.toString
        if pathS == parentS then
          ".."
        else
          let parentPrefix := parentS ++ sep
          if pathS.startsWith parentPrefix then
            ".." ++ sep ++ (pathS.drop parentPrefix.length).copy
          else
            path.toString

/-- Package-relative olean output arg: `.slake-native/Foo/Bar.olean` (cwd=pkg). -/
def nativeOleanRelArg (modName : String) : Option String :=
  match moduleOleanRel modName with
  | none => none
  | some rel => some (FilePath.mk ".slake-native" / rel).toString

/-- Per-module lean `-R` args: only when a safe preferred `srcDir` (A16 per-lib or
package) is set **and** the resolved source file is under `pkg/srcDir`. Flat
package-root fallback must not get `-R` — lean requires the input file to be
contained in the root. -/
def nativeOleanRootArgs (pkg : FilePath) (id : Slake.Config.PackageIdentity)
    (modName : String) (resolved : FilePath) : Array String :=
  match Slake.Config.srcDirForModule id modName with
  | some d =>
    if pathIsUnderDir (pkg / d) resolved then #["-R", d] else #[]
  | none => #[]

/-- A9: true when `olean` is a regular file whose mtime is ≥ `src` mtime.

Missing olean / non-file / metadata error → not fresh (must rebuild). A10 content
hash is a separate path (touch-without-edit). Not Lake shake TCB. -/
def nativeOleanMtimeFresh (src olean : FilePath) : IO Bool := do
  match ← olean.metadata.toBaseIO with
  | .error _ => pure false
  | .ok om =>
    if om.type != .file then pure false
    else
      match ← src.metadata.toBaseIO with
      | .error _ => pure false
      | .ok sm => pure (om.modified >= sm.modified)

/-- A10: FNV-1a 64-bit offset basis (`0xcbf29ce484222325`). -/
def fnv1a64Offset : UInt64 := 14695981039346656037

/-- A10: FNV-1a 64-bit prime (`0x100000001b3`). -/
def fnv1a64Prime : UInt64 := 1099511628211

/-- A10: FNV-1a 64 over full file bytes (portable non-crypto content hash).

Honesty: **source content-hash sidecar subset** only — not Lake shake TCB, not
content-hash of transitive imports, not freestanding build TCB, not CLAIMED. -/
def fnv1a64Bytes (data : ByteArray) : UInt64 :=
  data.foldl (init := fnv1a64Offset) fun h b =>
    (h.xor b.toUInt64) * fnv1a64Prime

/-- A10: zero-padded lowercase 16-nibble hex of a `UInt64`. -/
def uInt64ToHex16 (u : UInt64) : String := Id.run do
  let mut s := ""
  let mut x := u
  for _i in List.range 16 do
    let nibble := (x &&& (0xf : UInt64)).toNat
    let ch :=
      if nibble < 10 then Char.ofNat ('0'.toNat + nibble)
      else Char.ofNat ('a'.toNat + nibble - 10)
    s := String.singleton ch ++ s
    x := x >>> 4
  pure s

/-- A10: sidecar path next to olean — e.g. `.slake-native/Core.olean.slakehash`. -/
def nativeOleanHashPath (olean : FilePath) : FilePath :=
  FilePath.mk (olean.toString ++ ".slakehash")

/-- A10: FNV-1a 64 hex digest of source file bytes (`none` on read error). -/
def nativeOleanSourceHashHex (src : FilePath) : IO (Option String) := do
  match ← IO.FS.readBinFile src |>.toBaseIO with
  | .error _ => pure none
  | .ok data => pure (some (uInt64ToHex16 (fnv1a64Bytes data)))

/-- A9: plan-node import dependency names of `mod` from A5 edges (`src → dst` means
`dst` imports `src`; indices into declaration-order `nodes`). -/
def planImportDepsOf (nodes : List String) (edges : List (Nat × Nat))
    (mod : String) : List String :=
  edges.filterMap fun (s, d) =>
    match nodes[d]?, nodes[s]? with
    | some dn, some sn => if dn == mod then some sn else none
    | _, _ => none

/-- A9: true when any plan-node import dependency of `mod` is in `names` (this-run
recompiled or soft-skipped). Topo + direct edges ⇒ transitive cascade. -/
def planDepIn (nodes : List String) (edges : List (Nat × Nat))
    (mod : String) (names : List String) : Bool :=
  (planImportDepsOf nodes edges mod).any fun dep => names.any (· == dep)

/-- A9: true when any plan-import dep olean is a regular file newer than `selfOlean`.

Cross-run / interrupted-run subset: if Core.olean was rewritten after Host.olean
without Host rebuilding, force Host rebuild even when both sources look mtime-fresh.
Missing dep olean does not force here (dep soft-skip / recompile paths handle that).
Still plan-edge only — not Lake shake TCB. A30 path-dep plan-import deps: see
`planDepOleanNewer` overload after `PathDepModuleInfo` (path-dep olean resolve). -/
def planDepOleanNewerRoot (outDir : FilePath) (nodes : List String)
    (edges : List (Nat × Nat)) (mod : String) (selfOlean : FilePath) : IO Bool := do
  match ← selfOlean.metadata.toBaseIO with
  | .error _ => pure false
  | .ok sm =>
    if sm.type != .file then pure false
    else
      let rec go (deps : List String) : IO Bool := do
        match deps with
        | [] => pure false
        | d :: rest =>
          match moduleOleanOutPath outDir d with
          | none => go rest
          | some depOlean =>
            match ← depOlean.metadata.toBaseIO with
            | .error _ => go rest
            | .ok dm =>
              if dm.type == .file && dm.modified > sm.modified then pure true
              else go rest
      go (planImportDepsOf nodes edges mod)

/-- A27/A28: one path-dep plan module with package-local olean + source paths.

Collected after A26 path-require precompile for path-dep → root cascade
(`path-dep-olean-newer`, A27) and path-dep source-hash fold into A11 `deps`
(A28). A30 may also list the module as a root plan node when imported. -/
structure PathDepModuleInfo where
  mod : String
  olean : FilePath
  /-- Resolved source path in the path-dep package (A28 deps-hash fold). -/
  src : FilePath
  deriving Repr

/-- A9 plan-edge olean-newer with A30 path-dep plan-node olean resolve.

When a plan-import dep is package-local (root resolve succeeds), probe root
`.slake-native/`. When resolve fails and path-dep inventory owns the name, probe
`info.olean` under the path-require package. Package-local wins on flat-name
collision. A27 still covers path-dep-only imports that are not plan nodes. -/
def planDepOleanNewer (pkg : FilePath) (id : Slake.Config.PackageIdentity)
    (outDir : FilePath) (nodes : List String)
    (edges : List (Nat × Nat)) (mod : String) (selfOlean : FilePath)
    (pathDepMods : List PathDepModuleInfo := []) : IO Bool := do
  if pathDepMods.isEmpty then
    planDepOleanNewerRoot outDir nodes edges mod selfOlean
  else
    match ← selfOlean.metadata.toBaseIO with
    | .error _ => pure false
    | .ok sm =>
      if sm.type != .file then pure false
      else
        let rec go (deps : List String) : IO Bool := do
          match deps with
          | [] => pure false
          | d :: rest =>
            let depOlean? : Option FilePath ← do
              -- Package-local only when source exists (resolve may prefer missing path).
              let localExists ← do
                match ← Slake.Config.resolveModulePathFor pkg id d with
                | none => pure false
                | some src => src.pathExists
              if localExists then
                pure (moduleOleanOutPath outDir d)
              else
                match pathDepMods.find? (fun p => p.mod == d) with
                | some info => pure (some info.olean)
                | none => pure (moduleOleanOutPath outDir d)
            match depOlean? with
            | none => go rest
            | some depOlean =>
              match ← depOlean.metadata.toBaseIO with
              | .error _ => go rest
              | .ok dm =>
                if dm.type == .file && dm.modified > sm.modified then pure true
                else go rest
        go (planImportDepsOf nodes edges mod)

/-- A27/A28: collect path-dep plan modules + olean/source paths (depth-bounded).

For each safe relative path require that is a real directory: nested path-deps
first, then each non-package-name plan module of that dep with its
`dep/.slake-native/<Mod>.olean` path (may not exist yet) and resolved source.
Same depth unit as `collectPathRequireSearchRoots` / precompile walker. Skips
modules whose source or olean path cannot be resolved. Not git/url / not Lake
resolve-deps. A30 may fold imported names into root plan. -/
partial def collectPathDepModules (pkg : FilePath)
    (id : Slake.Config.PackageIdentity) (depth : Nat)
    : IO (List PathDepModuleInfo) := do
  if depth == 0 then
    return []
  let rec go (rs : List Slake.Config.RequireIdentity) (acc : List PathDepModuleInfo)
      : IO (List PathDepModuleInfo) := do
    match rs with
    | [] => pure acc
    | r :: rest =>
      match Slake.Config.resolveRequirePath pkg r with
      | none => go rest acc
      | some depPkg =>
        if !(← isRealPathRequireDir depPkg) then
          go rest acc
        else
          let depId ← Slake.Config.readPackageIdentity depPkg
          let nested ← collectPathDepModules depPkg depId (depth - 1)
          let nodes ← Slake.Config.planNodesIO depPkg depId
          let pkgName := depId.name
          let work := nodes.filter fun n => !(pkgName == some n || n == "(unknown)")
          let outDir := nativeOleanOutDir depPkg
          let rec mods (ns : List String) (a : List PathDepModuleInfo)
              : IO (List PathDepModuleInfo) := do
            match ns with
            | [] => pure a
            | n :: nsRest =>
              match ← Slake.Config.resolveModulePathFor depPkg depId n with
              | none => mods nsRest a
              | some src =>
                match moduleOleanOutPath outDir n with
                | none => mods nsRest a
                | some olean => mods nsRest ({ mod := n, olean, src } :: a)
          let localMods ← mods work []
          go rest (acc ++ nested ++ localMods)
  go (Slake.Config.pathRequires id) []

/-- A30: path-dep module name → source path map for import-scan resolve. -/
def pathDepExtraSrc (pathDepMods : List PathDepModuleInfo) : List (String × FilePath) :=
  pathDepMods.map fun p => (p.mod, p.src)

/-- A30: path-dep inventory entries present in the expanded plan **only because**
they were folded by import-driven expand (not already root plan names).

Flat-name collision residual: if root and a path-dep both ship `Lib`, and root
already lists `Lib`, that name is **not** treated as a path-dep plan node (skip
root compile / prefer path-dep olean). Only A30-appended names qualify. -/
def pathDepPlanNodes (rootNodes : List String) (planNodes : List String)
    (pathDepMods : List PathDepModuleInfo) : List PathDepModuleInfo :=
  pathDepMods.filter fun p =>
    planNodes.any (· == p.mod) && !(rootNodes.any (· == p.mod))

/-- A30: expand root plan with path-dep plan modules **imported by** root work modules.

After `planNodesIO` yields root nodes, if path requires exist: scan each root work
module (skip package-name / `(unknown)`) for top-level imports; when an import
target matches a path-dep inventory plan module name (`PathDepModuleInfo.mod`),
is safe, and is not already a plan node, append it (first-seen import order).
Total nodes capped at `depgraphPkgMaxNodes` (1…16). When an import-driven append
would exceed the cap, the second component is `true` (truncated) — callers emit a
banner and fail-closed under `SLAKE_NATIVE_OLEAN_STRICT` / `SLAKE_NATIVE_BUILD`
(A26 require-cap style). Soft path keeps the truncated plan with a warn.

Honesty: **package-transitive plan subset** (import-driven) — not every dep plan
module unconditionally / not Lake resolve-deps / not git/url / not freestanding
build TCB / not CLAIMED. -/
def expandPlanWithPathDepImports (pkg : FilePath) (id : Slake.Config.PackageIdentity)
    (rootNodes : List String) (pathDepMods : List PathDepModuleInfo)
    : IO (List String × Bool) := do
  if pathDepMods.isEmpty || !Slake.Config.hasPathRequires id then
    return (rootNodes, false)
  let pkgName := id.name
  let work := rootNodes.filter fun n => !(pkgName == some n || n == "(unknown)")
  let rec addImps (ts : List String) (a : List String) (trunc : Bool)
      : List String × Bool :=
    match ts with
    | [] => (a, trunc)
    | t :: tr =>
      if !Slake.Config.isSafeModName t then addImps tr a trunc
      else if a.any (· == t) then addImps tr a trunc
      else if pathDepMods.any (fun p => p.mod == t) then
        if a.length >= depgraphPkgMaxNodes then
          addImps tr a true
        else
          addImps tr (a ++ [t]) trunc
      else
        addImps tr a trunc
  let rec scanMods (ms : List String) (acc : List String) (trunc : Bool)
      : IO (List String × Bool) := do
    match ms with
    | [] => pure (acc, trunc)
    | m :: rest =>
      -- Scan root work sources only (package-local first via WithExtra).
      match ←
          Slake.Config.resolveModulePathForWithExtra pkg id m (pathDepExtraSrc pathDepMods) with
      | none => scanMods rest acc trunc
      | some src =>
        if !(← src.pathExists) then
          scanMods rest acc trunc
        else
          match ← IO.FS.readFile src |>.toBaseIO with
          | .error _ => scanMods rest acc trunc
          | .ok text =>
            let imps := Slake.Config.scanModuleImports text
            let (a', t') := addImps imps acc trunc
            scanMods rest a' t'
  scanMods work rootNodes false

/-- Emit A30 plan-cap honesty; fail-closed under STRICT / NATIVE_BUILD. -/
def reportPlanExpandTruncated (failClosed : Bool) : IO (Option UInt32) := do
  if failClosed then
    IO.eprintln s!"slake build: A30 package-transitive plan truncated (cap={depgraphPkgMaxNodes}; fail-closed — import-driven path-dep fold incomplete)"
    pure (some 1)
  else
    IO.eprintln s!"slake build: A30 package-transitive plan warn — truncated (cap={depgraphPkgMaxNodes}); plan omits some imported path-dep modules"
    pure none

/-- A30: root plan nodes + path-dep inventory (when path requires present).

`planNodes` is expanded (import-driven package-transitive plan subset) when
path requires exist; otherwise plain `planNodesIO`. Third component is `true`
when expand hit the 1…16 cap while more path-dep imports remained. Inventory is
always collected when path requires present (A27/A28/A30 consumers). -/
def planNodesExpandedIO (pkg : FilePath) (id : Slake.Config.PackageIdentity)
    : IO (List String × List PathDepModuleInfo × Bool) := do
  let root ← Slake.Config.planNodesIO pkg id
  if !Slake.Config.hasPathRequires id then
    pure (root, [], false)
  else
    let pd ← collectPathDepModules pkg id pathRequireMaxDepth
    let (exp, trunc) ← expandPlanWithPathDepImports pkg id root pd
    pure (exp, pd, trunc)

/-- A27/A28: path-dep inventory entries imported by consumer module source `src`.

Scans top-level imports of `src`. Keeps import targets that (1) pass
`isSafeModName`, (2) match a `PathDepModuleInfo.mod` name from path-require
inventory. Path-dep modules folded into the plan by A30 still use this path so
`path-dep-olean-newer` and A28 deps-fold keep working; A9 plan-edge olean-newer
also resolves path-dep plan-node oleans via `planDepOleanNewer` + inventory.
First matching path-dep entry wins when names collide (rare multi-dep residual).
Not full Lake package import resolution. -/
def pathDepImportInfosOf (_planNodes : List String)
    (pathDepMods : List PathDepModuleInfo) (src : FilePath)
    : IO (List PathDepModuleInfo) := do
  match ← IO.FS.readFile src |>.toBaseIO with
  | .error _ => pure []
  | .ok text =>
    let imps := Slake.Config.scanModuleImports text
    let rec go (ts : List String) (acc : List PathDepModuleInfo) : List PathDepModuleInfo :=
      match ts with
      | [] => acc.reverse
      | t :: rest =>
        if !Slake.Config.isSafeModName t then go rest acc
        else
          match pathDepMods.find? (fun p => p.mod == t) with
          | some info => go rest (info :: acc)
          | none => go rest acc
    pure (go imps [])

/-- A27: olean paths of path-dep modules imported by consumer module `src`. -/
def pathDepImportOleansOf (planNodes : List String)
    (pathDepMods : List PathDepModuleInfo) (src : FilePath)
    : IO (List FilePath) := do
  let infos ← pathDepImportInfosOf planNodes pathDepMods src
  pure (infos.map (·.olean))

/-- A27: true when any path-dep import olean is a regular file newer than `selfOlean`.

Closes A26 residual: path-dep modules may sit outside the root plan (or be A30
plan nodes with oleans under path-require packages), so A9 plan-edge cascade
alone is incomplete without path-dep olean resolve. Same mtime comparison residual
as A9 (`>` only; equal-second clocks residual). Missing path-dep olean does not
force here (lean may fail later). Not Lake shake TCB. -/
def pathDepOleanNewer (selfOlean : FilePath) (depOleas : List FilePath) : IO Bool := do
  match ← selfOlean.metadata.toBaseIO with
  | .error _ => pure false
  | .ok sm =>
    if sm.type != .file then pure false
    else
      let rec go (deps : List FilePath) : IO Bool := do
        match deps with
        | [] => pure false
        | depOlean :: rest =>
          match ← depOlean.metadata.toBaseIO with
          | .error _ => go rest
          | .ok dm =>
            if dm.type == .file && dm.modified > sm.modified then pure true
            else go rest
      go depOleas

/-- A10/A11: write sidecar after successful lean `-o`.

Format (backward compatible):
* Line 1: `fnv1a64 <16-hex> [module]` (self source FNV-1a 64)
* Optional line 2: `deps <16-hex>` — A11/A28 **direct** plan-import + path-dep
  import dep source-hash closure (sorted dep names + their source hashes at
  compile time; cascade supplies multi-hop). Absent on pre-A11 sidecars; parse
  still accepts line-1-only.

Best-effort: write errors are logged but do not fail the compile (olean is
already good). Not Lake shake TCB. -/
def writeNativeOleanHashSidecar (olean : FilePath) (mod : String) (hex : String)
    (depsHex : Option String) : IO Unit := do
  let path := nativeOleanHashPath olean
  let body :=
    match depsHex with
    | some d => s!"fnv1a64 {hex} {mod}\ndeps {d}\n"
    | none => s!"fnv1a64 {hex} {mod}\n"
  try
    IO.FS.writeFile path body
  catch e =>
    IO.eprintln s!"slake build: native olean: warn — could not write hash sidecar {path}: {e}"

/-- A10/A11: parse sidecar text → `(selfHex, optional depsHex)`.

Line 1 must be `fnv1a64 <16-hex> …` (self hex length must be 16, same as deps).
Optional later line `deps <16-hex>`. Old A10 line-1-only sidecars → `depsHex = none`.
Not Lake shake TCB. -/
def parseNativeOleanSidecar (text : String) : Option (String × Option String) :=
  let lines := text.splitOn "\n" |>.map (·.trimAscii.toString) |>.filter (· ≠ "")
  match lines with
  | [] => none
  | first :: rest =>
    let parts := first.splitOn " "
    match parts with
    | "fnv1a64" :: hex :: _ =>
      -- Mirror deps-line validation: require exactly 16 hex chars for self hash.
      if hex.length != 16 then none
      else
        let rec findDeps (ls : List String) : Option String :=
          match ls with
          | [] => none
          | l :: rs =>
            let ps := l.splitOn " "
            match ps with
            | "deps" :: dhex :: _ =>
              if dhex.length == 16 then some dhex.toLower else findDeps rs
            | _ => findDeps rs
        some (hex.toLower, findDeps rest)
    | _ => none

/-- A10: true when olean exists as a regular file **and** sidecar FNV-1a 64 matches
current source bytes (line 1 only; A11 `deps` line is a separate gate).

Missing olean / non-file olean → false (must rebuild even if orphan sidecar remains).
Missing/unreadable sidecar or parse fail → false (must rebuild when mtime is also
stale). Source read fail → false. Not Lake shake / not freestanding TCB. -/
def nativeOleanHashFresh (src olean : FilePath) : IO Bool := do
  -- Require olean artifact itself (orphan .slakehash must not hash-fresh-skip).
  match ← olean.metadata.toBaseIO with
  | .error _ => pure false
  | .ok om =>
    if om.type != .file then pure false
    else
      match ← nativeOleanSourceHashHex src with
      | none => pure false
      | some want =>
        let path := nativeOleanHashPath olean
        match ← IO.FS.readFile path |>.toBaseIO with
        | .error _ => pure false
        | .ok text =>
          match parseNativeOleanSidecar text with
          | some (hex, _) => pure (hex == want.toLower)
          | none => pure false

/-- A11: fold one UTF-8 string into an existing FNV-1a 64 hash (no reset). -/
def fnv1a64FoldString (h : UInt64) (s : String) : UInt64 :=
  s.toUTF8.foldl (init := h) fun acc b =>
    (acc.xor b.toUInt64) * fnv1a64Prime

/-- A11/A28: canonical **direct** plan-import + path-dep import dep source-hash
closure hex.

Folds **direct** `planImportDepsOf` edges (A5 `dst imports src` among plan
nodes) **and** (A28) consumer imports of path-dep plan modules from
`pathDepMods` (same inventory as A27; A30 may also list path-dep modules as
plan nodes — still fold once via path-dep src). Sorted (by name) unique dep
names of `mod`; for each dep feed `name ++ "\\n" ++ sourceHashHex ++ "\\n"` into
FNV-1a 64. Path-dep inventory `src` preferred when present (A26 path-require
package); else plan-local resolve via consumer package. Empty dep list → hash
of empty input (FNV offset). Returns `none` if any dep source is unreadable /
unresolvable (caller treats as stale / force rebuild).

Multi-hop A→B→C invalidation when A’s source changes is **not** folded into C’s
deps hex; cascade (this-run recompiled / soft-skip + dep-olean-newer +
path-dep-olean-newer) supplies multi-hop. Honesty: **direct plan-import +
path-dep import dep source-hash closure** (cascade multi-hop) — not Lake
package-transitive hash / not freestanding TCB / not CLAIMED. -/
def planImportDepsHashHex (pkg : FilePath) (id : Slake.Config.PackageIdentity)
    (nodes : List String) (edges : List (Nat × Nat)) (mod : String)
    (modSrc : FilePath) (pathDepMods : List PathDepModuleInfo)
    : IO (Option String) := do
  let planDeps := planImportDepsOf nodes edges mod
  let pathInfos ←
    if pathDepMods.isEmpty then pure []
    else pathDepImportInfosOf nodes pathDepMods modSrc
  -- Unique names: A30 path-dep plan nodes appear in both planDeps and pathInfos.
  let pathOnly :=
    (pathInfos.map (·.mod)).filter fun m => !planDeps.any (· == m)
  let deps := (planDeps ++ pathOnly).toArray.qsort (· < ·) |>.toList
  let rec go (acc : UInt64) (ds : List String) : IO (Option UInt64) := do
    match ds with
    | [] => pure (some acc)
    | d :: rest =>
      -- Package-local src first (must exist); path-dep inventory otherwise (A30).
      let src? ← do
        if !planDeps.any (· == d) then
          pure (pathInfos.find? (fun p => p.mod == d) |>.map (·.src))
        else
          match ← Slake.Config.resolveModulePathFor pkg id d with
          | some src =>
            if ← src.pathExists then pure (some src)
            else
              match pathDepMods.find? (fun p => p.mod == d) with
              | some info => pure (some info.src)
              | none => pure (pathInfos.find? (fun p => p.mod == d) |>.map (·.src))
          | none =>
            match pathDepMods.find? (fun p => p.mod == d) with
            | some info => pure (some info.src)
            | none => pure (pathInfos.find? (fun p => p.mod == d) |>.map (·.src))
      match src? with
      | none => pure none
      | some src =>
        match ← nativeOleanSourceHashHex src with
        | none => pure none
        | some hhex =>
          let acc1 := fnv1a64FoldString acc d
          let acc2 := fnv1a64FoldString acc1 "\n"
          let acc3 := fnv1a64FoldString acc2 hhex
          let acc4 := fnv1a64FoldString acc3 "\n"
          go acc4 rest
  match ← go fnv1a64Offset deps with
  | none => pure none
  | some h => pure (some (uInt64ToHex16 h))

/-- A11/A28: best-effort rewrite self `fnv1a64` + `deps` sidecar from **current**
sources without recompiling. Used on mtime-fresh / hash-fresh skip so a missing
or stale sidecar is healed under `.slake-native/` and dependents can reconverge
(option A). Write errors are logged inside `writeNativeOleanHashSidecar`. -/
def refreshNativeOleanHashSidecar (pkg : FilePath) (id : Slake.Config.PackageIdentity)
    (olean src : FilePath) (mod : String) (nodes : List String)
    (edges : List (Nat × Nat)) (pathDepMods : List PathDepModuleInfo) : IO Unit := do
  match ← nativeOleanSourceHashHex src with
  | none =>
    IO.eprintln s!"slake build: native olean: warn — could not hash source {src} for skip-heal sidecar"
  | some hex =>
    let depsHex ← planImportDepsHashHex pkg id nodes edges mod src pathDepMods
    writeNativeOleanHashSidecar olean mod hex depsHex

/-- A11: snapshot `(mod, hash-fresh)` at the **start** of a native olean run.

Live `dep-hash-stale` uses this snapshot so mid-run skip-heal of a dep’s sidecar
does not hide a missing/stale proof from dependents in the **same** run (one
fail-closed rebuild), while heal still restores the sidecar for reconvergence on
the next run. Plan nodes only — not Lake shake TCB. A30 path-dep plan nodes use
path-dep package olean/src (root `.slake-native/` has no Dep.olean). -/
def planModulesHashFreshSnapshot (pkg : FilePath) (id : Slake.Config.PackageIdentity)
    (outDir : FilePath) (nodes : List String)
    (pathDepMods : List PathDepModuleInfo := []) : IO (List (String × Bool)) := do
  let rec go (ns : List String) (acc : List (String × Bool)) : IO (List (String × Bool)) := do
    match ns with
    | [] => pure acc.reverse
    | n :: rest =>
      -- Package-local first only when source exists (resolve may return a missing
      -- preferred path); else path-dep inventory (A30 plan nodes under path-require).
      let local? ← do
        match ← Slake.Config.resolveModulePathFor pkg id n with
        | none => pure none
        | some src =>
          if ← src.pathExists then
            pure (some (src, moduleOleanOutPath outDir n))
          else
            pure none
      match local? with
      | some (src, some olean) =>
        let fresh ← nativeOleanHashFresh src olean
        go rest ((n, fresh) :: acc)
      | _ =>
        match pathDepMods.find? (fun p => p.mod == n) with
        | some info =>
          let fresh ← nativeOleanHashFresh info.src info.olean
          go rest ((n, fresh) :: acc)
        | none =>
          -- Unresolvable / unsafe → not hash-fresh in the snapshot.
          go rest ((n, false) :: acc)
  go nodes []

/-- A11: true when any **direct** plan-import dep of `mod` is not hash-fresh in
the start-of-run snapshot (olean + sidecar self-hash).

Blocks mtime/hash skip of dependents when a plan dep lacked a matching
olean/sidecar proof at run start. Unknown dep names → stale (fail-closed).
Direct edges only — multi-hop via cascade. Not Lake shake TCB. -/
def planDepNotHashFreshSnapshot (nodes : List String) (edges : List (Nat × Nat))
    (mod : String) (snap : List (String × Bool)) : Bool :=
  let rec go (deps : List String) : Bool :=
    match deps with
    | [] => false
    | d :: rest =>
      match snap.find? (fun p => p.1 == d) with
      | some (_, true) => go rest
      | some (_, false) => true
      | none => true
  go (planImportDepsOf nodes edges mod)

/-- A11/A28: true when M's sidecar has a `deps` line that does **not** match the
current recomputed **direct** plan-import + path-dep import dep source-hash
closure.

If no `deps` line (pre-A11 sidecar) → false (fall back to live dep hash-fresh +
A10 self hash). Missing/unreadable sidecar → false (other gates handle rebuild).
Cannot recompute current deps hash → true (fail-closed stale). -/
def nativeOleanDepsLineStale (pkg : FilePath) (id : Slake.Config.PackageIdentity)
    (olean modSrc : FilePath) (nodes : List String) (edges : List (Nat × Nat))
    (mod : String) (pathDepMods : List PathDepModuleInfo) : IO Bool := do
  let path := nativeOleanHashPath olean
  match ← IO.FS.readFile path |>.toBaseIO with
  | .error _ => pure false
  | .ok text =>
    match parseNativeOleanSidecar text with
    | none => pure false
    | some (_, none) => pure false
    | some (_, some want) =>
      match ← planImportDepsHashHex pkg id nodes edges mod modSrc pathDepMods with
      | none => pure true
      | some cur => pure (cur != want)

/-- A12: true when every **direct** plan-import dep of `mod` is in `finished`
(compiled, mtime/hash skipped, or soft-skipped this run). Ready-set gate for
parallel waves — Host never starts before Core finishes when Host imports Core.
With **empty** import-scan edges, every unfinished module is immediately ready
(no deps to wait on); `JOBS≥2` then batches plan-order modules with concurrency N
(no deeper ready-set gating). Prefer recorded import-scan edges for multi-module
`JOBS≥2`. -/
def planImportDepsFinished (nodes : List String) (edges : List (Nat × Nat))
    (mod : String) (finished : List String) : Bool :=
  (planImportDepsOf nodes edges mod).all fun d => finished.any (· == d)

/-- A12: one host-lean `-o` work item after skip/cascade decisions. -/
structure NativeOleanLeanJob where
  mod : String
  path : FilePath
  oleanPath : FilePath
  oleanRel : String
  depHashStale : Bool
  depsLineStale : Bool
  force : Bool
  cascadeRun : Bool
  cascadeDepOlean : Bool
  /-- A27: path-dep import olean newer than self (outside root plan edges). -/
  cascadePathDepOlean : Bool

/-- Per-module decision before (optional) parallel lean spawn. -/
inductive NativeOleanModDecision where
  | skipFresh (mod : String) (path : FilePath) (oleanPath : FilePath)
  | skipHashFresh (mod : String) (path : FilePath) (oleanPath : FilePath)
  | softSkip (mod : String)
  | needLean (job : NativeOleanLeanJob)
  | hardFail (code : UInt32)

/-- A8–A12 + A27: decide skip vs soft-skip vs lean for one ready plan module.

Skip/cascade/hash/deps-hash decisions stay single-threaded; only lean work may
parallelize across ready modules. Preserves A9–A11 gates. A27: also force rebuild
when an imported path-dep module olean is newer than self (path-dep modules may be
outside root plan or A30 plan nodes with oleans under path-require packages). -/
def decideNativeOleanModule (pkg : FilePath) (id : Slake.Config.PackageIdentity)
    (outDir : FilePath) (planNodes : List String) (importEdges : List (Nat × Nat))
    (hashFreshSnap : List (String × Bool)) (pathDepMods : List PathDepModuleInfo)
    (force failClosed nativeBuild strict : Bool)
    (recompiled softSkipped : List String) (n : String) : IO NativeOleanModDecision := do
  match ← Slake.Config.resolveModulePathFor pkg id n, moduleOleanOutPath outDir n,
        nativeOleanRelArg n with
  | none, _, _ =>
    if failClosed then
      if nativeBuild && !strict then
        IO.eprintln s!"slake build: native olean: unresolvable module {n} (NATIVE_BUILD fail-closed)"
      else
        IO.eprintln s!"slake build: native olean: unresolvable module {n} (STRICT)"
      pure (.hardFail 1)
    else
      IO.eprintln s!"slake build: native olean: skip unresolvable module {n} (dependents cascade rebuild)"
      pure (.softSkip n)
  | _, none, _ =>
    if failClosed then
      if nativeBuild && !strict then
        IO.eprintln s!"slake build: native olean: unsafe olean path for {n} (NATIVE_BUILD fail-closed)"
      else
        IO.eprintln s!"slake build: native olean: unsafe olean path for {n} (STRICT)"
      pure (.hardFail 1)
    else
      IO.eprintln s!"slake build: native olean: skip unsafe olean path for {n} (dependents cascade rebuild)"
      pure (.softSkip n)
  | _, _, none =>
    if failClosed then
      if nativeBuild && !strict then
        IO.eprintln s!"slake build: native olean: unsafe olean path for {n} (NATIVE_BUILD fail-closed)"
      else
        IO.eprintln s!"slake build: native olean: unsafe olean path for {n} (STRICT)"
      pure (.hardFail 1)
    else
      IO.eprintln s!"slake build: native olean: skip unsafe olean path for {n} (dependents cascade rebuild)"
      pure (.softSkip n)
  | some path, some oleanPath, some oleanRel => do
    if !(← path.pathExists) then
      if failClosed then
        if nativeBuild && !strict then
          IO.eprintln s!"slake build: native olean: missing file for {n} at {path} (NATIVE_BUILD fail-closed)"
        else
          IO.eprintln s!"slake build: native olean: missing file for {n} at {path} (STRICT)"
        pure (.hardFail 1)
      else
        IO.eprintln s!"slake build: native olean: skip missing file for {n} at {path} (dependents cascade rebuild)"
        pure (.softSkip n)
    else
      let cascadeRun :=
        planDepIn planNodes importEdges n recompiled ||
        planDepIn planNodes importEdges n softSkipped
      -- A9 + A30: plan-import dep oleans under root outDir or path-dep packages.
      let cascadeDepOlean ←
        planDepOleanNewer pkg id outDir planNodes importEdges n oleanPath pathDepMods
      -- A27: path-dep import olean-newer (inventory; coexists with A30 plan fold).
      let pathDepOleans ←
        if pathDepMods.isEmpty then pure []
        else pathDepImportOleansOf planNodes pathDepMods path
      let cascadePathDepOlean ←
        if pathDepOleans.isEmpty then pure false
        else pathDepOleanNewer oleanPath pathDepOleans
      let anyCascadeDep := cascadeDepOlean || cascadePathDepOlean
      let depHashStale :=
        if !force && !cascadeRun && !anyCascadeDep then
          planDepNotHashFreshSnapshot planNodes importEdges n hashFreshSnap
        else
          false
      let depsLineStale ←
        if !force && !cascadeRun && !anyCascadeDep && !depHashStale then
          nativeOleanDepsLineStale pkg id oleanPath path planNodes importEdges n pathDepMods
        else
          pure false
      let blockSkip :=
        force || cascadeRun || anyCascadeDep || depHashStale || depsLineStale
      let mtimeFresh ← nativeOleanMtimeFresh path oleanPath
      let hashFresh ←
        if !blockSkip && !mtimeFresh then
          nativeOleanHashFresh path oleanPath
        else
          pure false
      if !blockSkip && mtimeFresh then
        pure (.skipFresh n path oleanPath)
      else if !blockSkip && hashFresh then
        pure (.skipHashFresh n path oleanPath)
      else
        pure (.needLean {
          mod := n
          path
          oleanPath
          oleanRel
          depHashStale
          depsLineStale
          force
          cascadeRun
          cascadeDepOlean
          cascadePathDepOlean
        })

/-- Spawn one host lean `-o` (used under sequential or `IO.asTask` parallel). -/
def spawnNativeOleanLean (pkg : FilePath) (id : Slake.Config.PackageIdentity)
    (lean leanPath : String) (job : NativeOleanLeanJob) : IO UInt32 := do
  match job.oleanPath.parent with
  | some parent =>
    try IO.FS.createDirAll parent
    catch e =>
      IO.eprintln s!"slake build: native olean: cannot create parent of {job.oleanPath}: {e}"
      return 1
  | none => pure ()
  let rootArgs := nativeOleanRootArgs pkg id job.mod job.path
  let fileRel := pathRelToPkg pkg job.path
  let args := rootArgs ++ #["-o", job.oleanRel, fileRel]
  let anyPlanCascade := job.cascadeRun || job.cascadeDepOlean
  if job.cascadePathDepOlean && !job.force && !anyPlanCascade then
    IO.println s!"slake build: native olean: rebuild {job.mod} (path-dep-olean-newer)"
  else if job.depHashStale && !job.force && !anyPlanCascade && !job.cascadePathDepOlean then
    IO.println s!"slake build: native olean: rebuild {job.mod} (dep-hash-stale)"
  else if job.depsLineStale && !job.force && !anyPlanCascade && !job.cascadePathDepOlean then
    IO.println s!"slake build: native olean: rebuild {job.mod} (deps-line-stale)"
  IO.println s!"slake build: native olean: {lean} {" ".intercalate args.toList}"
  let child ← IO.Process.spawn {
    cmd := lean
    args := args
    cwd := some pkg
    env := #[("LEAN_PATH", some leanPath)]
  }
  child.wait

/-- After successful lean `-o`, write A10/A11/A28 hash sidecar (best-effort). -/
def writeNativeOleanSidecarAfterLean (pkg : FilePath) (id : Slake.Config.PackageIdentity)
    (planNodes : List String) (importEdges : List (Nat × Nat))
    (pathDepMods : List PathDepModuleInfo) (job : NativeOleanLeanJob) : IO Unit := do
  match ← nativeOleanSourceHashHex job.path with
  | some hex =>
    let depsHex ←
      planImportDepsHashHex pkg id planNodes importEdges job.mod job.path pathDepMods
    writeNativeOleanHashSidecar job.oleanPath job.mod hex depsHex
  | none =>
    IO.eprintln s!"slake build: native olean: warn — could not hash source {job.path} for sidecar"

/-- Take up to `n` elements from a list (preserves order). -/
def takeUpTo {α : Type} (n : Nat) (xs : List α) : List α × List α :=
  let rec go (k : Nat) (acc : List α) (rest : List α) : List α × List α :=
    match k, rest with
    | 0, _ => (acc.reverse, rest)
    | _, [] => (acc.reverse, [])
    | k' + 1, x :: xs' => go k' (x :: acc) xs'
  go n [] xs

/-- A12: run a queue of lean jobs with concurrency `jobs` (partial: queue shortens).

`jobs ≤ 1` sequential spawn+wait; `jobs ≥ 2` `IO.asTask` batches of size jobs.
Drain all tasks in a batch before fail-closed return.
`maxBatchAcc` tracks the largest lean batch size this pool run (for OK-banner honesty). -/
partial def runNativeOleanLeanPool (pkg : FilePath) (id : Slake.Config.PackageIdentity)
    (lean leanPath : String) (planNodes : List String) (importEdges : List (Nat × Nat))
    (pathDepMods : List PathDepModuleInfo)
    (jobs : Nat) (queue : List NativeOleanLeanJob) (compiledAcc : Nat)
    (recompiledAcc finishedAcc : List String) (maxBatchAcc : Nat)
    : IO (Except UInt32 (Nat × List String × List String × Nat)) := do
  match queue with
  | [] => pure (.ok (compiledAcc, recompiledAcc, finishedAcc, maxBatchAcc))
  | _ =>
    let (batch, rest) := takeUpTo jobs queue
    match batch with
    | [] => pure (.ok (compiledAcc, recompiledAcc, finishedAcc, maxBatchAcc))
    | job0 :: batchRest =>
      if jobs <= 1 then
        let job := job0
        let code ← spawnNativeOleanLean pkg id lean leanPath job
        if code != 0 then
          IO.eprintln s!"slake build: native olean failed for module {job.mod} (lean exited {code})"
          return .error code
        writeNativeOleanSidecarAfterLean pkg id planNodes importEdges pathDepMods job
        runNativeOleanLeanPool pkg id lean leanPath planNodes importEdges pathDepMods jobs rest
          (compiledAcc + 1) (job.mod :: recompiledAcc) (job.mod :: finishedAcc)
          (Nat.max maxBatchAcc 1)
      else
        let batchAll := job0 :: batchRest
        let batchSize := batchAll.length
        let tasks ← batchAll.mapM fun job =>
          IO.asTask (prio := .dedicated) (spawnNativeOleanLean pkg id lean leanPath job)
        let mut firstFail : Option UInt32 := none
        for pair in List.zip batchAll tasks do
          let (job, task) := pair
          match ← IO.wait task with
          | .error e =>
            IO.eprintln s!"slake build: native olean: task error for module {job.mod}: {e}"
            if firstFail.isNone then firstFail := some 1
          | .ok code =>
            if code != 0 then
              IO.eprintln s!"slake build: native olean failed for module {job.mod} (lean exited {code})"
              if firstFail.isNone then firstFail := some code
        match firstFail with
        | some code => return .error code
        | none =>
          let mut compiled2 := compiledAcc
          let mut recompiled2 := recompiledAcc
          let mut finished2 := finishedAcc
          for job in batchAll do
            writeNativeOleanSidecarAfterLean pkg id planNodes importEdges pathDepMods job
            compiled2 := compiled2 + 1
            recompiled2 := job.mod :: recompiled2
            finished2 := job.mod :: finished2
          runNativeOleanLeanPool pkg id lean leanPath planNodes importEdges pathDepMods jobs rest
            compiled2 recompiled2 finished2 (Nat.max maxBatchAcc batchSize)

/-- A12: ready-set wave driver (partial: unfinished shrinks when ready nonempty).

A module is ready when all direct plan-import deps finished this run. Skip
decisions single-threaded; lean work via `runNativeOleanLeanPool`.
`maxBatch` is the largest concurrent lean batch size across waves (OK banner
says "parallel" only when a batch of size >1 actually ran). -/
partial def runNativeOleanWave (pkg : FilePath) (id : Slake.Config.PackageIdentity)
    (outDir : FilePath) (lean leanPath : String) (planNodes : List String)
    (importEdges : List (Nat × Nat)) (hashFreshSnap : List (String × Bool))
    (pathDepMods : List PathDepModuleInfo)
    (force failClosed nativeBuild strict : Bool) (jobs : Nat)
    (unfinished : List String) (compiled skipped : Nat)
    (recompiled softSkipped finished : List String) (maxBatch : Nat)
    (skippedPathDep : Nat := 0)
    : IO (Option UInt32) := do
  match unfinished with
  | [] =>
    if compiled + skipped + skippedPathDep == 0 then
      if failClosed then
        if nativeBuild && !strict then
          IO.eprintln "slake build: native olean: no modules compiled under NATIVE_BUILD (fail-closed; no lake fallback)"
        else
          IO.eprintln "slake build: native olean: no modules compiled (STRICT)"
        return some 1
      else
        IO.eprintln "slake build: native olean: warn — no modules compiled (all skipped or package-name-only plan)"
        return none
    else
      -- "parallel" only when a lean batch of size >1 actually ran; JOBS≥2 with
      -- pure serial DAG (e.g. Core→Host) is ready-set, not achieved concurrency.
      let mode :=
        if maxBatch > 1 then "parallel olean wave"
        else if jobs >= 2 then s!"ready-set olean wave (jobs={jobs}; no concurrent batch this run)"
        else "sequential"
      -- A30 path-dep plan nodes are pre-seeded finished — not "skipped fresh".
      let pdPart :=
        if skippedPathDep == 0 then ""
        else s!", {skippedPathDep} path-dep plan node(s)"
      if skipped == 0 && skippedPathDep == 0 then
        IO.println s!"slake build: native olean OK (host lean {mode} + olean LEAN_PATH; {compiled} module(s))"
        return none
      else if skipped == 0 then
        IO.println s!"slake build: native olean OK (host lean {mode} + olean LEAN_PATH; {compiled} compiled{pdPart})"
        return none
      else
        IO.println s!"slake build: native olean OK (host lean {mode} + olean LEAN_PATH; {compiled} compiled, {skipped} skipped fresh{pdPart})"
        return none
  | _ =>
    let ready := unfinished.filter fun m =>
      planImportDepsFinished planNodes importEdges m finished
    if ready.isEmpty then
      IO.eprintln s!"slake build: native olean: no ready modules among unfinished (stuck plan-import ready-set; modules={unfinished})"
      return some 1
    let mut leanJobs : List NativeOleanLeanJob := []
    let mut compiled' := compiled
    let mut skipped' := skipped
    let mut recompiled' := recompiled
    let mut softSkipped' := softSkipped
    let mut finished' := finished
    let mut pending := unfinished
    for n in ready do
      pending := pending.filter (· != n)
      match ← decideNativeOleanModule pkg id outDir planNodes importEdges
          hashFreshSnap pathDepMods force failClosed nativeBuild strict
          recompiled' softSkipped' n with
      | .hardFail code => return some code
      | .softSkip m =>
        softSkipped' := m :: softSkipped'
        finished' := m :: finished'
      | .skipFresh m path oleanPath =>
        IO.println s!"slake build: native olean: skip {m} (fresh)"
        refreshNativeOleanHashSidecar pkg id oleanPath path m planNodes importEdges pathDepMods
        skipped' := skipped' + 1
        finished' := m :: finished'
      | .skipHashFresh m path oleanPath =>
        IO.println s!"slake build: native olean: skip {m} (hash-fresh)"
        refreshNativeOleanHashSidecar pkg id oleanPath path m planNodes importEdges pathDepMods
        skipped' := skipped' + 1
        finished' := m :: finished'
      | .needLean job =>
        leanJobs := leanJobs ++ [job]
    match ← runNativeOleanLeanPool pkg id lean leanPath planNodes importEdges pathDepMods jobs
        leanJobs 0 [] [] 0 with
    | .error code => return some code
    | .ok (cAdd, recompAdd, finAdd, batchThis) =>
      runNativeOleanWave pkg id outDir lean leanPath planNodes importEdges hashFreshSnap
        pathDepMods force failClosed nativeBuild strict jobs pending
        (compiled' + cAdd) skipped'
        (recompAdd ++ recompiled') softSkipped' (finAdd ++ finished')
        (Nat.max maxBatch batchThis) skippedPathDep

-- A26 path-require precompile ↔ native olean: mutual (single walker + compile).
mutual
/-- A26: precompile path-`[[require]]` packages into each dep's `.slake-native/`.

Single walker for OLEAN/BUILD and CHECK. For each safe relative path require
whose target is a **real directory** (lstat: not missing / not symlink / not
file): host-plan its modules, run `runNativeOleanCompile` with **`depth − 1`**
(nested requires inside the dep still expand once per hop). Missing / not a
directory / symlink / plan fail: fail-closed when `failClosed`, else soft-skip.
Truncated require list (`requireCount` > stored): warn always; fail-closed when
`failClosed`.

Honesty: not git/url / not Lake resolve-deps / not freestanding build TCB / not
CLAIMED. A30 may fold imported path-dep plan modules into the root plan (oleans
still live under path-require packages). A27 path-dep → root cascade
(`path-dep-olean-newer`) runs in the consumer package after this precompile. -/
partial def runPathRequireNativeOleens (pkg : FilePath)
    (id : Slake.Config.PackageIdentity) (depth : Nat) (failClosed : Bool)
    : IO (Option UInt32) := do
  if depth == 0 || !Slake.Config.hasPathRequires id then
    return none
  -- Cap-16 honesty: headers beyond stored list are ignored for LEAN_PATH/precompile.
  if Slake.Config.requiresTruncated id then
    if failClosed then
      IO.eprintln s!"slake build: A26 path require truncated (require={id.requireCount} stored={id.requires.length} cap={Slake.Config.requireIdentityCap}; fail-closed)"
      return some 1
    else
      IO.eprintln s!"slake build: A26 path require warn — truncated (require={id.requireCount} stored={id.requires.length} cap={Slake.Config.requireIdentityCap}); processing stored only"
  let rec go (rs : List Slake.Config.RequireIdentity) : IO (Option UInt32) := do
    match rs with
    | [] => pure none
    | r :: rest =>
      match Slake.Config.resolveRequirePath pkg r with
      | none =>
        -- Unsafe / missing path field: ignore (git-only require residual).
        go rest
      | some depPkg => do
        if !(← isRealPathRequireDir depPkg) then
          if failClosed then
            IO.eprintln s!"slake build: A26 path require missing or not a directory {depPkg} (name={r.name}; fail-closed — refuse symlink/file/missing)"
            return some 1
          else
            IO.eprintln s!"slake build: A26 path require warn — missing or not a directory {depPkg} (name={r.name}); skip"
            go rest
        else
          let depId ← Slake.Config.readPackageIdentity depPkg
          let nodes ← Slake.Config.planNodesIO depPkg depId
          match ← hostPlanOrder depPkg depId nodes with
          | none =>
            if failClosed then
              IO.eprintln s!"slake build: A26 path require plan failed for {depPkg} (name={r.name}; fail-closed)"
              return some 1
            else
              IO.eprintln s!"slake build: A26 path require warn — plan failed for {depPkg} (name={r.name}); skip"
              go rest
          | some ordered =>
            let pathLab := r.path.getD "(missing path)"
            IO.println s!"slake build: A26 path-require olean precompile name={r.name} path={pathLab} pkg={depPkg}"
            if pathLab.startsWith ".." then
              IO.println "  (path [[require]] + A29 sibling confining ../path under package-parent — not git/url / not Lake resolve-deps / not multi-.. escape / not freestanding build TCB / not CLAIMED)"
            else
              IO.println "  (path [[require]] subset — not git/url / not Lake resolve-deps / not freestanding build TCB / not CLAIMED)"
            -- One hop consumes one depth unit (matches LEAN_PATH collectPathRequireSearchRoots).
            match ← runNativeOleanCompile depPkg depId ordered (depth - 1) with
            | some code => return some code
            | none => go rest
  go (Slake.Config.pathRequires id)

/-- A8–A12: multi-module host-lean compile writing oleans into package-local
`.slake-native/` and feeding that dir on LEAN_PATH.

Walks plan modules in **ready-set waves** (A5 plan-import deps finished this run).
Default `SLAKE_NATIVE_OLEAN_JOBS` unset/`1` → sequential (one lean at a time;
A8–A11 smoke-compatible). `JOBS=N` with `N ≥ 2` → up to N concurrent host
`lean -o` among modules whose direct plan-import deps already finished
(compiled, mtime/hash skipped, or soft-skipped). Host never starts before Core
when Host imports Core. Skip/cascade/hash/deps-hash decisions stay
single-threaded per ready module before lean work; lean work may interleave
logs when parallel.

Skips package `name` node and `(unknown)`. Resolves each label via
`resolveModulePath`. Spawns classic `IO.Process` → `lean [-R srcDir] -o <out>
<file>` with `cwd=pkg` and child `LEAN_PATH` = `.slake-native` + pkg [+srcDir]
+ A26 path-require roots (dep `.slake-native` / srcDirs / root, depth-bounded).
Missing lean / missing file: soft warn unless `SLAKE_NATIVE_OLEAN_STRICT=1`.
Nonzero lean exit → fail whole compile (drain remaining parallel tasks).

**A9/A10/A11 cache invalidation subset** preserved (FORCE, this-run cascade,
dep-olean-newer, hash-fresh, deps-line, skip-heal, start-of-run hash-fresh
snapshot, NATIVE_BUILD fail-closed). **A27:** after path-require precompile,
root (consumer) modules that import path-dep plan modules rebuild when a
path-dep olean is newer than the consumer olean (`path-dep-olean-newer`) —
closes A26 residual; **A30** may also fold imported path-dep modules into the
root plan (skip lean -o under root; olean under path-require package). **A28:**
path-dep import source hashes fold into A11 frozen `deps <hex>` so hash-fresh
path-dep with non-newer olean cannot leave a consumer deps-line stale.

**A12 honesty:** parallel host-lean olean wave subset when JOBS≥2 — **not**
freestanding build TCB / **not** Lake job server TCB / **not** CLAIMED / **not**
shared-lib link / **not** lake-equivalent shake/hash TCB. Out dir remains
package-local `.slake-native/` (not lake `.lake/build`; A17: wiped by `slake clean`
as native product out dir wipe subset with `.lake/build`).

`pathReqDepth` bounds A26 path-require precompile recursion (default
`pathRequireMaxDepth`). Depth 0 skips further path-require expansion. Single
walker: `runPathRequireNativeOleens` (one hop → depth−1). -/
partial def runNativeOleanCompile (pkg : FilePath) (id : Slake.Config.PackageIdentity)
    (ordered : List String) (pathReqDepth : Nat := pathRequireMaxDepth) : IO (Option UInt32) := do
  let strict ← envFlagTruthy "SLAKE_NATIVE_OLEAN_STRICT"
  let nativeBuild ← envFlagTruthy "SLAKE_NATIVE_BUILD"
  -- Product freestanding-adjacent build path: fail-closed on missing work (do not
  -- soft-skip to none then claim NATIVE_BUILD success / skip lake).
  let failClosed := strict || nativeBuild
  -- A26: single path-require precompile walker (shared with NATIVE_CHECK-only).
  match ← runPathRequireNativeOleens pkg id pathReqDepth failClosed with
  | some code => return some code
  | none => pure ()
  let force ← envFlagTruthy "SLAKE_NATIVE_OLEAN_FORCE"
  let jobs ← parseNativeOleanJobs
  let lean ← match ← resolveLeanCmd with
    | some c => pure c
    | none =>
      if failClosed then
        if nativeBuild && !strict then
          IO.eprintln "slake build: SLAKE_NATIVE_BUILD=1 but lean not found or not a real Lean binary (set LEAN= to absolute lean; relative LEAN is cwd-resolved); fail-closed (no lake fallback)"
        else
          IO.eprintln "slake build: SLAKE_NATIVE_OLEAN=1 but lean not found or not a real Lean binary (set LEAN= to absolute lean; relative LEAN is cwd-resolved); STRICT"
        return some 1
      else
        IO.eprintln "slake build: SLAKE_NATIVE_OLEAN=1 but lean not found or not a real Lean binary; skipping native olean compile"
        return none
  let outDir := nativeOleanOutDir pkg
  try
    IO.FS.createDirAll outDir
  catch e =>
    IO.eprintln s!"slake build: SLAKE_NATIVE_OLEAN=1 cannot create {outDir}: {e}"
    return some 1
  let leanPath ← nativeOleanLeanPath pkg outDir id
  -- Declaration-order plan nodes for A5 edge indices (same list as plan scanners;
  -- A24 globs + A30 import-driven path-dep plan fold match printed plan).
  let rootNodes ← Slake.Config.planNodesIO pkg id
  -- Prefer pathReqDepth inventory (nested precompile may have updated oleans).
  let pathDepMods ← collectPathDepModules pkg id pathReqDepth
  let (planNodes, planTrunc) ← expandPlanWithPathDepImports pkg id rootNodes pathDepMods
  if planTrunc then
    match ← reportPlanExpandTruncated failClosed with
    | some code => return some code
    | none => pure ()
  let extraSrc := pathDepExtraSrc pathDepMods
  let importEdges ← Slake.Config.collectImportEdges pkg planNodes id extraSrc
  -- A30-folded path-dep plan nodes only (not flat-name collision with root modules).
  let pathDepInPlan := pathDepPlanNodes rootNodes planNodes pathDepMods
  -- A11: start-of-run hash-fresh snapshot (path-dep plan nodes use path-dep olean/src).
  let hashFreshSnap ← planModulesHashFreshSnapshot pkg id outDir planNodes pathDepInPlan
  if jobs <= 1 then
    IO.println "slake build: SLAKE_NATIVE_OLEAN=1; multi-module sequential host-lean + olean LEAN_PATH"
  else
    IO.println "slake build: SLAKE_NATIVE_OLEAN=1; multi-module parallel host-lean olean wave + LEAN_PATH"
  IO.println "  (mtime + plan-edge cascade cache invalidation subset + FNV-1a 64 source content-hash sidecar + plan-node transitive deps-hash subset — not freestanding build TCB / not lake-equivalent TCB / not CLAIMED / not full olean graph invalidation / not Lake shake/hash TCB / not Lake package-transitive hash)"
  if Slake.Config.hasPathRequires id then
    IO.println "  (A26 path [[require]] LEAN_PATH + path-dep olean precompile + A29 sibling confining ../path (package-parent) + A27 path-dep → root olean cascade (path-dep-olean-newer) + A28 path-dep source-hash fold into A11 deps-line + A30 package-transitive plan subset — not git/url / not Lake resolve-deps / not multi-.. escape / not freestanding build TCB / not CLAIMED)"
  if jobs >= 2 then
    IO.println "  (parallel host-lean olean wave subset — not freestanding build TCB / not Lake job server TCB / not CLAIMED / not shared-lib link)"
  IO.println s!"slake build: native olean: jobs={jobs}"
  if force then
    IO.println "  SLAKE_NATIVE_OLEAN_FORCE=1 — rebuild all plan modules (ignore mtime/hash freshness)"
  IO.println s!"  lean={lean} cwd={pkg} out={outDir} LEAN_PATH={leanPath}"
  let pkgName := id.name
  -- A30: path-dep plan nodes already precompiled under dep/.slake-native/ — skip
  -- root lean -o; pre-seed finished so import-scan ready-set still orders Dep before App
  -- without soft-skip cascade forcing dependents every run. Only A30-folded names
  -- (not root modules that share a flat label with path-dep inventory).
  let rec logSkips (ps : List PathDepModuleInfo) : IO Unit := do
    match ps with
    | [] => pure ()
    | p :: rest =>
      IO.println s!"slake build: native olean: skip {p.mod} (path-dep plan node; olean under path-require package)"
      logSkips rest
  logSkips pathDepInPlan
  let finished0 := pathDepInPlan.map (·.mod)
  let pathDepSkipN := finished0.length
  let work0 := ordered.filter fun n =>
    !(pkgName == some n || n == "(unknown)") && !(finished0.any (· == n))
  -- Full pathDepMods for A27/A28 import scan; pathDepInPlan for A9 olean paths via decide.
  runNativeOleanWave pkg id outDir lean leanPath planNodes importEdges hashFreshSnap
    pathDepMods force failClosed nativeBuild strict jobs work0 0 0 [] [] finished0 0 pathDepSkipN
end

/-- Escape a string for inclusion in a C double-quoted literal.

Handles common escapes; drops U+0000 / other controls / non-ASCII for portable
generated-C hygiene (plan modules are normally `isSafeModName` already). -/
def cEscapeString (s : String) : String :=
  s.foldl (init := "") fun acc c =>
    if c == '\\' then acc ++ "\\\\"
    else if c == '"' then acc ++ "\\\""
    else if c == '\n' then acc ++ "\\n"
    else if c == '\r' then acc ++ "\\r"
    else if c == '\t' then acc ++ "\\t"
    else if c.val < 32 || c.val == 127 || c.val > 127 then
      -- Defense in depth: do not emit raw controls / non-ASCII into generated C.
      acc
    else acc.push c

/-- A13: generate `slake_native_export.c` body listing plan module names. -/
def buildNativeLinkCSource (modules : List String) : String :=
  let header :=
    "/* generated by slake SLAKE_NATIVE_LINK — host shared-lib link subset\n" ++
    " * NOT Lake lean_lib shared-object of compiled Lean IR\n" ++
    " * NOT freestanding build TCB / NOT Lake shared-lib TCB / NOT CLAIMED\n" ++
    " */\n" ++
    "const char *slake_native_plan_modules[] = {\n"
  let body := modules.foldl (init := "") fun acc m =>
    acc ++ "  \"" ++ cEscapeString m ++ "\",\n"
  let footer :=
    "  (const char *)0\n" ++
    "};\n" ++
    s!"unsigned slake_native_plan_module_count = {modules.length};\n"
  header ++ body ++ footer

/-- True when `--version` output looks like a real host C toolchain (not `/bin/true`).

Requires non-empty stdout+stderr and a common marker (gcc / clang / FSF /
Apple LLVM / tcc / `cc (` version lines). Softer than Lean identity marker but
rejects exit-0 no-output fakes. -/
def looksLikeCcVersion (stdout stderr : String) : Bool :=
  let blob := stdout ++ stderr
  if blob.isEmpty then
    false
  else
    let t := blob.toLower
    t.contains "gcc" || t.contains "clang" || t.contains "free software foundation" ||
      t.contains "apple llvm" || t.contains "tcc" ||
      (t.contains "cc (" && (t.contains "version" || t.contains "gcc"))

/-- Resolve host `cc` for `SLAKE_NATIVE_LINK`.

Prefers `CC` env, else `cc` on PATH. Probes with `--version` requiring **exit 0**,
**non-empty** stdout/stderr, and a **C toolchain identity marker** (gcc/clang/cc
family) so `/bin/true`-style exit-0 tools cannot green-wash the probe (mirrors
`resolveLeanCmd` Lean-marker honesty, with a softer cc-family marker set).
Relative `CC` paths are absolute-resolved against the process cwd (same as LEAN).
Spawn failure / bad probe → `none` (caller soft-skips or STRICT/NATIVE_BUILD-fails).
Actual link still fail-closed on missing `.so` regardless. -/
def resolveCcCmd : IO (Option String) := do
  let raw ← match ← IO.getEnv "CC" with
    | some c =>
      let t := c.trimAscii.toString
      if t.isEmpty then pure "cc" else pure t
    | none => pure "cc"
  let cmd ← resolveLeanPathForSpawn raw
  match ← (IO.Process.output { cmd := cmd, args := #["--version"] }).toBaseIO with
  | .error _ => pure none
  | .ok out =>
    if out.exitCode != 0 then
      pure none
    else if looksLikeCcVersion out.stdout out.stderr then
      pure (some cmd)
    else
      pure none

/-- Probe a candidate host `leanc` path (exit 0 + C-toolchain marker).

`leanc --version` typically prints the underlying `cc` version line, so the
cc-family identity marker (`looksLikeCcVersion`) is the honest probe — rejects
`/bin/true`-style exit-0 fakes the same way as `resolveCcCmd`. -/
def probeLeancCmd (raw : String) : IO (Option String) := do
  let cmd ← resolveLeanPathForSpawn raw
  match ← (IO.Process.output { cmd := cmd, args := #["--version"] }).toBaseIO with
  | .error _ => pure none
  | .ok out =>
    if out.exitCode != 0 then
      pure none
    else if looksLikeCcVersion out.stdout out.stderr then
      pure (some cmd)
    else
      pure none

/-- Resolve host `leanc` for `SLAKE_NATIVE_IRLINK` / `SLAKE_NATIVE_EXE`.

Prefers `LEANC` env when set/non-empty (exclusive — bad `LEANC` does **not** fall
through to PATH, matching `CC` / `LEAN` honesty). Else `leanc` on PATH. Else,
when resolved host `lean` has a parent directory, try sibling `leanc` (same
install prefix as stage1 / elan). Relative paths absolute-resolved against process
cwd. Spawn failure / bad probe → `none`. -/
def resolveLeancCmd : IO (Option String) := do
  match ← IO.getEnv "LEANC" with
  | some c =>
    let t := c.trimAscii.toString
    if !t.isEmpty then
      -- Exclusive: set LEANC that fails probe → none (no PATH fallthrough).
      return (← probeLeancCmd t)
  | none => pure ()
  match ← probeLeancCmd "leanc" with
  | some cmd => return some cmd
  | none => pure ()
  -- Optional same-dir as LEAN (absolute / relative-with-separator only).
  match ← resolveLeanCmd with
  | none => pure none
  | some lean =>
    let leanPath := FilePath.mk lean
    match leanPath.parent with
    | none => pure none
    | some dir =>
      if leanPath.fileName.isSome then
        probeLeancCmd (dir / "leanc").toString
      else
        pure none

/-- True when `ar --version` / `ar -V` output looks like a real archiver (not `/bin/true`).

Requires non-empty stdout+stderr and an ar/binutils-family marker. -/
def looksLikeArVersion (stdout stderr : String) : Bool :=
  let blob := stdout ++ stderr
  if blob.isEmpty then
    false
  else
    let t := blob.toLower
    t.contains "gnu ar" || t.contains "binutils" || t.contains "llvm-ar" ||
      t.contains "bsd ar" || t.contains "free software foundation" ||
      (t.contains "ar " && (t.contains "version" || t.contains "ranlib" || t.contains "utility")) ||
      (t.contains "ar (" && t.contains "version")

/-- Probe a candidate host `ar` path (`--version`, else `-V`; exit 0 + ar marker). -/
def probeArCmd (raw : String) : IO (Option String) := do
  let cmd ← resolveLeanPathForSpawn raw
  -- Prefer GNU-style `--version`; fall back to `-V` (BSD / some macOS ar).
  match ← (IO.Process.output { cmd := cmd, args := #["--version"] }).toBaseIO with
  | .ok out =>
    if out.exitCode == 0 && looksLikeArVersion out.stdout out.stderr then
      return some cmd
  | .error _ => pure ()
  match ← (IO.Process.output { cmd := cmd, args := #["-V"] }).toBaseIO with
  | .error _ => pure none
  | .ok out =>
    if out.exitCode != 0 then
      pure none
    else if looksLikeArVersion out.stdout out.stderr then
      pure (some cmd)
    else
      pure none

/-- Resolve host `ar` for `SLAKE_NATIVE_AR`.

Prefers `AR` env when set/non-empty (exclusive — bad `AR` does **not** fall through
to PATH, matching `CC` / `LEANC` honesty). Else `ar` on PATH. Relative paths
absolute-resolved against process cwd. Spawn failure / bad probe → `none`. -/
def resolveArCmd : IO (Option String) := do
  match ← IO.getEnv "AR" with
  | some c =>
    let t := c.trimAscii.toString
    if !t.isEmpty then
      -- Exclusive: set AR that fails probe → none (no PATH fallthrough).
      return (← probeArCmd t)
  | none => pure ()
  probeArCmd "ar"

/-- Relative C path under the olean out dir: `Foo.Bar` → `Foo/Bar.c`.

Returns `none` when `modName` fails `isSafeModName` (path-escape fail-closed). -/
def moduleCRel (modName : String) : Option FilePath :=
  if !Slake.Config.isSafeModName modName then none
  else some (FilePath.mk (("/".intercalate (modName.splitOn ".")) ++ ".c"))

/-- Package-relative C output arg: `.slake-native/Foo/Bar.c` (cwd=pkg). -/
def nativeCRelArg (modName : String) : Option String :=
  match moduleCRel modName with
  | none => none
  | some rel => some (FilePath.mk ".slake-native" / rel).toString

/-- A19: host lean C-output emit subset after successful native olean compile.

For each topo plan module (skip package name / unknown; `isSafeModName` only):
resolve source via `resolveModulePathFor`, then spawn host
`lean [-R srcDir] -c .slake-native/<ModRel>.c <file>` with `cwd=pkg` and the
same child `LEAN_PATH` as olean (`.slake-native` first, then pkg [+srcDir]).

**Honesty:** host lean C-output emit subset — **not** freestanding build TCB /
**not** Lake lean_lib shared-object of compiled Lean IR / **not** full object
compile+link of Lean runtime / **not** CLAIMED. JOBS applies to olean waves only;
C emit is sequential single lean per module. Always re-emits when requested
(no mtime skip; simpler residual honesty).

Missing lean / missing source (after resolve + `pathExists`, matching A7/A8): soft
warn + skip unless `SLAKE_NATIVE_C_STRICT=1` or `SLAKE_NATIVE_BUILD=1` (fail-closed
so NATIVE_BUILD skip-lake requires C emit success when NATIVE_C is also set).
Nonzero lean exit is always fail-closed and names the failing module. Empty or
non-file `.c` after lean success is always fail-closed. Zero C files written →
soft-skip or fail-closed (no zero-work success greenwash). -/
def runNativeCEmit (pkg : FilePath) (id : Slake.Config.PackageIdentity)
    (ordered : List String) : IO (Option UInt32) := do
  let strict ← envFlagTruthy "SLAKE_NATIVE_C_STRICT"
  let nativeBuild ← envFlagTruthy "SLAKE_NATIVE_BUILD"
  let failClosed := strict || nativeBuild
  let lean ← match ← resolveLeanCmd with
    | some c => pure c
    | none =>
      if failClosed then
        if nativeBuild && !strict then
          IO.eprintln "slake build: SLAKE_NATIVE_C=1 under NATIVE_BUILD but lean not found or not a real Lean binary (set LEAN=); fail-closed (no skip-lake without C emit)"
        else
          IO.eprintln "slake build: SLAKE_NATIVE_C=1 but lean not found or not a real Lean binary (set LEAN=); STRICT"
        return some 1
      else
        IO.eprintln "slake build: SLAKE_NATIVE_C=1 but lean not found or not a real Lean binary; skipping host lean C-output emit"
        return none
  let outDir := nativeOleanOutDir pkg
  try
    IO.FS.createDirAll outDir
  catch e =>
    IO.eprintln s!"slake build: SLAKE_NATIVE_C=1 cannot create {outDir}: {e}"
    return some 1
  let leanPath ← nativeOleanLeanPath pkg outDir id
  let pkgName := id.name
  let mods := ordered.filter fun n =>
    !(pkgName == some n || n == "(unknown)") &&
      Slake.Config.isSafeModName n
  if mods.isEmpty then
    if failClosed then
      IO.eprintln "slake build: SLAKE_NATIVE_C=1 no plan modules for C emit (fail-closed)"
      return some 1
    else
      IO.eprintln "slake build: SLAKE_NATIVE_C=1 warn — no plan modules for C emit; skipping"
      return none
  IO.println "slake build: SLAKE_NATIVE_C=1; host lean C-output emit subset after native oleans"
  IO.println "  (not freestanding build TCB / not Lake lean_lib shared-object of compiled Lean IR / not full object compile+link of Lean runtime / not CLAIMED)"
  IO.println s!"  lean={lean} cwd={pkg} out={outDir} LEAN_PATH={leanPath}"
  let rec go (ms : List String) (emitted : Nat) (softSkipped : Nat) : IO (Option UInt32) := do
    match ms with
    | [] =>
      if emitted == 0 then
        if failClosed then
          IO.eprintln s!"slake build: SLAKE_NATIVE_C=1 zero C files written (soft-skipped {softSkipped}; fail-closed — no zero-work success)"
          return some 1
        else
          IO.eprintln s!"slake build: SLAKE_NATIVE_C=1 warn — zero C files written (soft-skipped {softSkipped}); skipping"
          return none
      else
        IO.println s!"slake build: native C emit OK (host lean C-output emit subset; {emitted} module(s); not freestanding build TCB / not Lake lean_lib SO / not CLAIMED)"
        return none
    | m :: rest =>
      match nativeCRelArg m, moduleCRel m with
      | some cRel, some cRelPath =>
        match ← Slake.Config.resolveModulePathFor pkg id m with
        | none =>
          if failClosed then
            IO.eprintln s!"slake build: SLAKE_NATIVE_C=1 missing source for module {m} (fail-closed)"
            return some 1
          else
            IO.eprintln s!"slake build: SLAKE_NATIVE_C=1 warn — missing source for module {m}; skipping"
            go rest emitted (softSkipped + 1)
        | some src =>
          -- resolveModulePathFor may return preferred path even when no file exists
          -- (Config first-candidate falls through). Mirror A7/A8: soft-skip missing
          -- source unless STRICT/NATIVE_BUILD; do not hand a non-existent path to lean.
          if !(← src.pathExists) then
            if failClosed then
              IO.eprintln s!"slake build: SLAKE_NATIVE_C=1 missing source for module {m} at {src} (fail-closed)"
              return some 1
            else
              IO.eprintln s!"slake build: SLAKE_NATIVE_C=1 warn — missing source for module {m} at {src}; skipping"
              go rest emitted (softSkipped + 1)
          else
            let cAbs := outDir / cRelPath
            match cAbs.parent with
            | some parent =>
              try IO.FS.createDirAll parent
              catch e =>
                IO.eprintln s!"slake build: native C emit: cannot create parent of {cAbs}: {e}"
                return some 1
            | none => pure ()
            let rootArgs := nativeOleanRootArgs pkg id m src
            let fileRel := pathRelToPkg pkg src
            let args := rootArgs ++ #["-c", cRel, fileRel]
            IO.println s!"slake build: native C emit: {lean} {" ".intercalate args.toList}"
            let child ← IO.Process.spawn {
              cmd := lean
              args := args
              cwd := some pkg
              env := #[("LEAN_PATH", some leanPath)]
            }
            let code ← child.wait
            if code != 0 then
              IO.eprintln s!"slake build: native C emit failed for module {m} (lean exited {code})"
              return some code
            -- Require regular non-empty .c (no empty-file zero-work success).
            match ← cAbs.metadata.toBaseIO with
            | .ok st =>
              if st.type != .file || st.byteSize == 0 then
                IO.eprintln s!"slake build: native C emit empty or non-file C output for module {m} at {cAbs}"
                return some 1
              else
                go rest (emitted + 1) softSkipped
            | .error _ =>
              IO.eprintln s!"slake build: native C emit claimed success but missing {cAbs}"
              return some 1
      | _, _ =>
        if failClosed then
          IO.eprintln s!"slake build: SLAKE_NATIVE_C=1 unsafe module name {m} (fail-closed)"
          return some 1
        else
          IO.eprintln s!"slake build: SLAKE_NATIVE_C=1 warn — unsafe module name {m}; skipping"
          go rest emitted (softSkipped + 1)
  go mods 0 0

/-- Relative object path under the olean out dir: `Foo.Bar` → `Foo/Bar.o`.

Returns `none` when `modName` fails `isSafeModName` (path-escape fail-closed). -/
def moduleORel (modName : String) : Option FilePath :=
  if !Slake.Config.isSafeModName modName then none
  else some (FilePath.mk (("/".intercalate (modName.splitOn ".")) ++ ".o"))

/-- Package-relative object output arg: `.slake-native/Foo/Bar.o` (cwd=pkg). -/
def nativeORelArg (modName : String) : Option String :=
  match moduleORel modName with
  | none => none
  | some rel => some (FilePath.mk ".slake-native" / rel).toString

/-- Resolve Lean C include directory for host object compile of lean C.

Order (first usable directory wins):
1. `LEAN_INCLUDE` — direct `-I` path (must exist as directory)
2. `LEAN_SYSROOT` or `LEAN_PREFIX` — use `<dir>/include` when that exists
3. Else `lean --print-prefix` (same LEAN binary as olean/C when available) →
   `<prefix>/include` when that exists

When a higher-priority env key is set/non-empty but unusable (not a directory /
missing `include/`), emit a one-line warn before falling through. When
`failClosedOnBadInclude` is true and `LEAN_INCLUDE` is set/non-empty but
unusable, do **not** fall through — return `none` so the object-compile path
fail-closes (STRICT / NATIVE_BUILD). Secondary keys (`LEAN_SYSROOT` /
`LEAN_PREFIX`) always fall through after a warn.

Returns `none` when no usable include dir (caller soft-skips or fail-closes).
**Not** freestanding build TCB — host include resolution only. -/
def resolveLeanIncludeDir (leanCmd? : Option String)
    (failClosedOnBadInclude : Bool := false) : IO (Option String) := do
  match ← IO.getEnv "LEAN_INCLUDE" with
  | some raw =>
    let t := raw.trimAscii.toString
    if !t.isEmpty then
      let p ← resolveLeanPathForSpawn t
      if ← (FilePath.mk p).isDir then
        return some p
      else if failClosedOnBadInclude then
        IO.eprintln s!"slake build: LEAN_INCLUDE set but not a directory ({p}); fail-closed (no fallthrough under STRICT/NATIVE_BUILD)"
        return none
      else
        IO.eprintln s!"slake build: LEAN_INCLUDE set but not a directory ({p}); falling through"
  | none => pure ()
  -- Prefer SYSROOT then PREFIX (both mean install root with include/).
  for key in (["LEAN_SYSROOT", "LEAN_PREFIX"] : List String) do
    match ← IO.getEnv key with
    | some raw =>
      let t := raw.trimAscii.toString
      if !t.isEmpty then
        let base ← resolveLeanPathForSpawn t
        let inc := FilePath.mk base / "include"
        if ← inc.isDir then
          return some inc.toString
        else
          IO.eprintln s!"slake build: {key} set but {inc} is not a directory; falling through"
    | none => pure ()
  match leanCmd? with
  | none => pure none
  | some lean =>
    match ← (IO.Process.output { cmd := lean, args := #["--print-prefix"] }).toBaseIO with
    | .error _ => pure none
    | .ok out =>
      if out.exitCode != 0 then
        pure none
      else
        -- Prefer stdout; some hosts may print on stderr.
        let raw :=
          if !out.stdout.isEmpty then out.stdout else out.stderr
        let leanPrefix := raw.trimAscii.toString
        if leanPrefix.isEmpty then
          pure none
        else
          let inc := FilePath.mk leanPrefix / "include"
          if ← inc.isDir then pure (some inc.toString) else pure none

/-- A20: host object compile of lean C after successful native C emit (A19).

For each topo plan module (skip package name / unknown; `isSafeModName` only):
require existing non-empty package-local `.slake-native/<ModRel>.c` (path
confinement via safe module names, matching C layout), then spawn host
`cc -c -fPIC -I<leanInclude> -o .slake-native/<ModRel>.o .slake-native/<ModRel>.c`
with `cwd=pkg`. Nested modules → `Foo/Bar.o` matching C layout.

**Honesty:** host object compile of lean C subset — **not** freestanding build
TCB / **not** Lake lean_lib shared-object of compiled Lean IR / **not** linking
Lean runtime into a shared object / **not** CLAIMED. A13 NATIVE_LINK remains the
name-table shared-lib subset (not IR SO). JOBS applies to olean waves only; object
compile is sequential single `cc -c` per module. Always re-compiles when requested
(no mtime skip; simpler residual honesty).

Include resolution (`resolveLeanIncludeDir`): `LEAN_INCLUDE` → `LEAN_SYSROOT` /
`LEAN_PREFIX` + `/include` → `lean --print-prefix` + `/include`. Set-but-unusable
higher-priority keys warn before fallthrough; set-but-unusable `LEAN_INCLUDE`
fail-closes under STRICT/NATIVE_BUILD (no silent mask by print-prefix).

Missing `cc` / missing include / missing non-empty `.c` / zero `.o` files: soft
warn + skip unless `SLAKE_NATIVE_OBJ_STRICT=1` or `SLAKE_NATIVE_BUILD=1`
(fail-closed so NATIVE_BUILD skip-lake requires object compile success when
NATIVE_OBJ is also set). Nonzero `cc` exit is always fail-closed and names the
failing module. Empty or non-file `.o` after `cc` success is always fail-closed. -/
def runNativeObjCompile (pkg : FilePath) (id : Slake.Config.PackageIdentity)
    (ordered : List String) : IO (Option UInt32) := do
  let strict ← envFlagTruthy "SLAKE_NATIVE_OBJ_STRICT"
  let nativeBuild ← envFlagTruthy "SLAKE_NATIVE_BUILD"
  let failClosed := strict || nativeBuild
  let cc ← match ← resolveCcCmd with
    | some c => pure c
    | none =>
      if failClosed then
        if nativeBuild && !strict then
          IO.eprintln "slake build: SLAKE_NATIVE_OBJ=1 under NATIVE_BUILD but cc not found or not usable (set CC=); fail-closed (no skip-lake without object compile)"
        else
          IO.eprintln "slake build: SLAKE_NATIVE_OBJ=1 but cc not found or not usable (set CC=); STRICT"
        return some 1
      else
        IO.eprintln "slake build: SLAKE_NATIVE_OBJ=1 but cc not found or not usable; skipping host object compile of lean C"
        return none
  -- Include resolution may use lean --print-prefix. Explicit LEAN_INCLUDE set but
  -- unusable fail-closes under STRICT/NATIVE_BUILD (no silent fallthrough).
  let lean? ← resolveLeanCmd
  let includeDir ← match ← resolveLeanIncludeDir lean? (failClosedOnBadInclude := failClosed) with
    | some d => pure d
    | none =>
      if failClosed then
        if nativeBuild && !strict then
          IO.eprintln "slake build: SLAKE_NATIVE_OBJ=1 under NATIVE_BUILD but Lean include dir not found (set LEAN_INCLUDE= or LEAN_PREFIX= or LEAN= with --print-prefix); fail-closed (no skip-lake without object compile)"
        else
          IO.eprintln "slake build: SLAKE_NATIVE_OBJ=1 but Lean include dir not found (set LEAN_INCLUDE= or LEAN_PREFIX= or LEAN= with --print-prefix); STRICT"
        return some 1
      else
        IO.eprintln "slake build: SLAKE_NATIVE_OBJ=1 but Lean include dir not found; skipping host object compile of lean C"
        return none
  let outDir := nativeOleanOutDir pkg
  try
    IO.FS.createDirAll outDir
  catch e =>
    IO.eprintln s!"slake build: SLAKE_NATIVE_OBJ=1 cannot create {outDir}: {e}"
    return some 1
  let pkgName := id.name
  let mods := ordered.filter fun n =>
    !(pkgName == some n || n == "(unknown)") &&
      Slake.Config.isSafeModName n
  if mods.isEmpty then
    if failClosed then
      IO.eprintln "slake build: SLAKE_NATIVE_OBJ=1 no plan modules for object compile (fail-closed)"
      return some 1
    else
      IO.eprintln "slake build: SLAKE_NATIVE_OBJ=1 warn — no plan modules for object compile; skipping"
      return none
  IO.println "slake build: SLAKE_NATIVE_OBJ=1; host object compile of lean C subset after native C emit"
  IO.println "  (not freestanding build TCB / not Lake lean_lib shared-object of compiled Lean IR / not linking Lean runtime into SO / not CLAIMED)"
  IO.println s!"  cc={cc} cwd={pkg} out={outDir} -I={includeDir}"
  let rec go (ms : List String) (compiled : Nat) (softSkipped : Nat) : IO (Option UInt32) := do
    match ms with
    | [] =>
      if compiled == 0 then
        if failClosed then
          IO.eprintln s!"slake build: SLAKE_NATIVE_OBJ=1 zero object files written (soft-skipped {softSkipped}; fail-closed — no zero-work success)"
          return some 1
        else
          IO.eprintln s!"slake build: SLAKE_NATIVE_OBJ=1 warn — zero object files written (soft-skipped {softSkipped}); skipping"
          return none
      else
        IO.println s!"slake build: native object compile OK (host object compile of lean C subset; {compiled} module(s); not freestanding build TCB / not Lake lean_lib SO / not CLAIMED)"
        return none
    | m :: rest =>
      match nativeCRelArg m, moduleCRel m, nativeORelArg m, moduleORel m with
      | some cRel, some cRelPath, some oRel, some oRelPath =>
        let cAbs := outDir / cRelPath
        -- Require existing non-empty regular .c (from A19 or prior); soft-skip missing.
        match ← cAbs.metadata.toBaseIO with
        | .ok st =>
          if st.type != .file || st.byteSize == 0 then
            if failClosed then
              IO.eprintln s!"slake build: SLAKE_NATIVE_OBJ=1 empty or non-file C input for module {m} at {cAbs} (fail-closed)"
              return some 1
            else
              IO.eprintln s!"slake build: SLAKE_NATIVE_OBJ=1 warn — empty or non-file C input for module {m} at {cAbs}; skipping"
              go rest compiled (softSkipped + 1)
          else
            let oAbs := outDir / oRelPath
            match oAbs.parent with
            | some parent =>
              try IO.FS.createDirAll parent
              catch e =>
                IO.eprintln s!"slake build: native object compile: cannot create parent of {oAbs}: {e}"
                return some 1
            | none => pure ()
            let args := #["-c", "-fPIC", s!"-I{includeDir}", "-o", oRel, cRel]
            IO.println s!"slake build: native object compile: {cc} {" ".intercalate args.toList}"
            match ← (IO.Process.output {
                cmd := cc
                args := args
                cwd := some pkg
              }).toBaseIO with
            | .error e =>
              IO.eprintln s!"slake build: native object compile spawn failed for module {m}: {e}"
              return some 1
            | .ok out =>
              if out.exitCode != 0 then
                if !out.stdout.isEmpty then
                  IO.eprintln out.stdout
                if !out.stderr.isEmpty then
                  IO.eprintln out.stderr
                IO.eprintln s!"slake build: native object compile failed for module {m} (cc exited {out.exitCode})"
                return some out.exitCode
              -- Require regular non-empty .o (no empty-file zero-work success).
              match ← oAbs.metadata.toBaseIO with
              | .ok ost =>
                if ost.type != .file || ost.byteSize == 0 then
                  IO.eprintln s!"slake build: native object compile empty or non-file object for module {m} at {oAbs}"
                  return some 1
                else
                  go rest (compiled + 1) softSkipped
              | .error _ =>
                IO.eprintln s!"slake build: native object compile claimed success but missing {oAbs}"
                return some 1
        | .error _ =>
          if failClosed then
            IO.eprintln s!"slake build: SLAKE_NATIVE_OBJ=1 missing C input for module {m} at {cAbs} (fail-closed — run NATIVE_C first or set NATIVE_OBJ which implies C emit)"
            return some 1
          else
            IO.eprintln s!"slake build: SLAKE_NATIVE_OBJ=1 warn — missing C input for module {m} at {cAbs}; skipping"
            go rest compiled (softSkipped + 1)
      | _, _, _, _ =>
        if failClosed then
          IO.eprintln s!"slake build: SLAKE_NATIVE_OBJ=1 unsafe module name {m} (fail-closed)"
          return some 1
        else
          IO.eprintln s!"slake build: SLAKE_NATIVE_OBJ=1 warn — unsafe module name {m}; skipping"
          go rest compiled (softSkipped + 1)
  go mods 0 0

/-- A31: path-dep package-local out dir (`.slake-native`) from inventory olean path.

Inventory stores `moduleOleanOutPath outDir mod` so nested `Foo.Bar` yields
`dep/.slake-native/Foo/Bar.olean`. Strip `moduleOleanRel` components (not just
one `.parent`) so outDir is `dep/.slake-native` rather than `…/Foo`. -/
def pathDepOutDir (info : PathDepModuleInfo) : Option FilePath :=
  match moduleOleanRel info.mod with
  | none => none
  | some rel =>
    let n := rel.components.length
    if n == 0 then none
    else
      let rec up (p : FilePath) (k : Nat) : Option FilePath :=
        match k with
        | 0 => some p
        | k' + 1 =>
          match p.parent with
          | none => none
          | some par => up par k'
      up info.olean n

/-- A31: path-dep package root (`dep/`) from inventory olean path. -/
def pathDepPackageRoot (info : PathDepModuleInfo) : Option FilePath :=
  match pathDepOutDir info with
  | some outDir => outDir.parent
  | none => none

/-- A31: absolute `.c` path under path-dep package out dir (`outDir / moduleCRel`). -/
def pathDepCAbs (info : PathDepModuleInfo) : Option FilePath :=
  match pathDepOutDir info, moduleCRel info.mod with
  | some outDir, some cRel => some (outDir / cRel)
  | _, _ => none

/-- A31: absolute `.o` path under path-dep package out dir (`outDir / moduleORel`). -/
def pathDepObjAbs (info : PathDepModuleInfo) : Option FilePath :=
  match pathDepOutDir info, moduleORel info.mod with
  | some outDir, some oRel => some (outDir / oRel)
  | _, _ => none

/-- A31: host lean C-output emit for A30-folded path-dep plan modules into
`dep/.slake-native/<ModRel>.c` (cwd=path-dep package; LEAN_PATH as path-dep olean).

Only A30-folded path-dep plan nodes (`pathDepInPlan`); processed in expanded-plan
topo order. Root modules stay under root `.slake-native/` via `runNativeCEmit`.
Soft vs fail-closed mirrors A19 (`SLAKE_NATIVE_C_STRICT` / `SLAKE_NATIVE_BUILD`).

**Honesty:** freestanding-adjacent path-dep plan-module C/OBJ into IR products
subset — **not** freestanding build TCB / **not** Lake lean_lib shared facet /
**not** CLAIMED / **not** every dep plan module / **not** git/url. -/
def runNativePathDepCEmit (ordered : List String) (pathDepInPlan : List PathDepModuleInfo)
    : IO (Option UInt32) := do
  if pathDepInPlan.isEmpty then
    return none
  let strict ← envFlagTruthy "SLAKE_NATIVE_C_STRICT"
  let nativeBuild ← envFlagTruthy "SLAKE_NATIVE_BUILD"
  let failClosed := strict || nativeBuild
  let lean ← match ← resolveLeanCmd with
    | some c => pure c
    | none =>
      if failClosed then
        if nativeBuild && !strict then
          IO.eprintln "slake build: SLAKE_NATIVE_C=1 under NATIVE_BUILD but lean not found or not a real Lean binary (set LEAN=); fail-closed (no skip-lake without path-dep C emit)"
        else
          IO.eprintln "slake build: SLAKE_NATIVE_C=1 but lean not found or not a real Lean binary (set LEAN=); STRICT"
        return some 1
      else
        IO.eprintln "slake build: SLAKE_NATIVE_C=1 but lean not found or not a real Lean binary; skipping path-dep host lean C-output emit"
        return none
  -- Topo order among expanded plan: only A30-folded path-dep names.
  let mods := ordered.filter fun n =>
    pathDepInPlan.any (fun p => p.mod == n) && Slake.Config.isSafeModName n
  if mods.isEmpty then
    return none
  IO.println "slake build: A31 path-dep plan-module C emit into path-require package .slake-native/"
  IO.println "  (freestanding-adjacent path-dep plan-module C/OBJ into IR products subset — not freestanding build TCB / not Lake lean_lib shared facet / not CLAIMED / not every dep plan module / not git/url)"
  IO.println s!"  lean={lean} path-dep modules={mods.length}"
  let rec go (ms : List String) (emitted : Nat) (softSkipped : Nat) : IO (Option UInt32) := do
    match ms with
    | [] =>
      if emitted == 0 then
        if failClosed then
          IO.eprintln s!"slake build: A31 path-dep C emit zero C files written (soft-skipped {softSkipped}; fail-closed — no zero-work success)"
          return some 1
        else
          IO.eprintln s!"slake build: A31 path-dep C emit warn — zero C files written (soft-skipped {softSkipped}); skipping"
          return none
      else
        IO.println s!"slake build: native path-dep C emit OK (freestanding-adjacent path-dep plan-module C/OBJ into IR products subset; {emitted} path-dep module(s); not freestanding build TCB / not Lake lean_lib shared facet / not CLAIMED)"
        return none
    | m :: rest =>
      match pathDepInPlan.find? (fun p => p.mod == m) with
      | none => go rest emitted softSkipped
      | some info =>
        match pathDepPackageRoot info, pathDepCAbs info, nativeCRelArg m with
        | some depPkg, some cAbs, some cRel =>
          let depId ← Slake.Config.readPackageIdentity depPkg
          let outDir := nativeOleanOutDir depPkg
          try
            IO.FS.createDirAll outDir
          catch e =>
            IO.eprintln s!"slake build: A31 path-dep C emit cannot create {outDir}: {e}"
            return some 1
          let leanPath ← nativeOleanLeanPath depPkg outDir depId
          let src := info.src
          if !(← src.pathExists) then
            if failClosed then
              IO.eprintln s!"slake build: A31 path-dep C emit missing source for module {m} at {src} (fail-closed)"
              return some 1
            else
              IO.eprintln s!"slake build: A31 path-dep C emit warn — missing source for module {m} at {src}; skipping"
              go rest emitted (softSkipped + 1)
          else
            match cAbs.parent with
            | some parent =>
              try IO.FS.createDirAll parent
              catch e =>
                IO.eprintln s!"slake build: A31 path-dep C emit: cannot create parent of {cAbs}: {e}"
                return some 1
            | none => pure ()
            let rootArgs := nativeOleanRootArgs depPkg depId m src
            let fileRel := pathRelToPkg depPkg src
            let args := rootArgs ++ #["-c", cRel, fileRel]
            IO.println s!"slake build: native path-dep C emit: {lean} {" ".intercalate args.toList} (cwd={depPkg})"
            let child ← IO.Process.spawn {
              cmd := lean
              args := args
              cwd := some depPkg
              env := #[("LEAN_PATH", some leanPath)]
            }
            let code ← child.wait
            if code != 0 then
              IO.eprintln s!"slake build: native path-dep C emit failed for module {m} (lean exited {code})"
              return some code
            match ← cAbs.metadata.toBaseIO with
            | .ok st =>
              if st.type != .file || st.byteSize == 0 then
                IO.eprintln s!"slake build: native path-dep C emit empty or non-file C output for module {m} at {cAbs}"
                return some 1
              else
                go rest (emitted + 1) softSkipped
            | .error _ =>
              IO.eprintln s!"slake build: native path-dep C emit claimed success but missing {cAbs}"
              return some 1
        | _, _, _ =>
          if failClosed then
            IO.eprintln s!"slake build: A31 path-dep C emit cannot resolve package/C path for module {m} (fail-closed)"
            return some 1
          else
            IO.eprintln s!"slake build: A31 path-dep C emit warn — cannot resolve package/C path for module {m}; skipping"
            go rest emitted (softSkipped + 1)
  go mods 0 0

/-- A31: host object compile of path-dep lean C into `dep/.slake-native/<ModRel>.o`
(cwd=path-dep package; same include resolve as A20).

Only A30-folded path-dep plan nodes; topo order from expanded plan. Soft vs
fail-closed mirrors A20 (`SLAKE_NATIVE_OBJ_STRICT` / `SLAKE_NATIVE_BUILD`).

**Honesty:** freestanding-adjacent path-dep plan-module C/OBJ into IR products
subset — **not** freestanding build TCB / **not** Lake lean_lib shared facet /
**not** CLAIMED / **not** every dep plan module / **not** git/url. -/
def runNativePathDepObjCompile (ordered : List String) (pathDepInPlan : List PathDepModuleInfo)
    : IO (Option UInt32) := do
  if pathDepInPlan.isEmpty then
    return none
  let strict ← envFlagTruthy "SLAKE_NATIVE_OBJ_STRICT"
  let nativeBuild ← envFlagTruthy "SLAKE_NATIVE_BUILD"
  let failClosed := strict || nativeBuild
  let cc ← match ← resolveCcCmd with
    | some c => pure c
    | none =>
      if failClosed then
        if nativeBuild && !strict then
          IO.eprintln "slake build: SLAKE_NATIVE_OBJ=1 under NATIVE_BUILD but cc not found or not usable (set CC=); fail-closed (no skip-lake without path-dep object compile)"
        else
          IO.eprintln "slake build: SLAKE_NATIVE_OBJ=1 but cc not found or not usable (set CC=); STRICT"
        return some 1
      else
        IO.eprintln "slake build: SLAKE_NATIVE_OBJ=1 but cc not found or not usable; skipping path-dep host object compile of lean C"
        return none
  let lean? ← resolveLeanCmd
  let includeDir ← match ← resolveLeanIncludeDir lean? (failClosedOnBadInclude := failClosed) with
    | some d => pure d
    | none =>
      if failClosed then
        if nativeBuild && !strict then
          IO.eprintln "slake build: SLAKE_NATIVE_OBJ=1 under NATIVE_BUILD but Lean include dir not found (set LEAN_INCLUDE= or LEAN_PREFIX= or LEAN= with --print-prefix); fail-closed (no skip-lake without path-dep object compile)"
        else
          IO.eprintln "slake build: SLAKE_NATIVE_OBJ=1 but Lean include dir not found (set LEAN_INCLUDE= or LEAN_PREFIX= or LEAN= with --print-prefix); STRICT"
        return some 1
      else
        IO.eprintln "slake build: SLAKE_NATIVE_OBJ=1 but Lean include dir not found; skipping path-dep host object compile of lean C"
        return none
  let mods := ordered.filter fun n =>
    pathDepInPlan.any (fun p => p.mod == n) && Slake.Config.isSafeModName n
  if mods.isEmpty then
    return none
  IO.println "slake build: A31 path-dep plan-module object compile into path-require package .slake-native/"
  IO.println "  (freestanding-adjacent path-dep plan-module C/OBJ into IR products subset — not freestanding build TCB / not Lake lean_lib shared facet / not CLAIMED / not every dep plan module / not git/url)"
  IO.println s!"  cc={cc} -I={includeDir} path-dep modules={mods.length}"
  let rec go (ms : List String) (compiled : Nat) (softSkipped : Nat) : IO (Option UInt32) := do
    match ms with
    | [] =>
      if compiled == 0 then
        if failClosed then
          IO.eprintln s!"slake build: A31 path-dep object compile zero object files written (soft-skipped {softSkipped}; fail-closed — no zero-work success)"
          return some 1
        else
          IO.eprintln s!"slake build: A31 path-dep object compile warn — zero object files written (soft-skipped {softSkipped}); skipping"
          return none
      else
        IO.println s!"slake build: native path-dep object compile OK (freestanding-adjacent path-dep plan-module C/OBJ into IR products subset; {compiled} path-dep module(s); not freestanding build TCB / not Lake lean_lib shared facet / not CLAIMED)"
        return none
    | m :: rest =>
      match pathDepInPlan.find? (fun p => p.mod == m) with
      | none => go rest compiled softSkipped
      | some info =>
        match pathDepPackageRoot info, pathDepCAbs info, pathDepObjAbs info, nativeCRelArg m, nativeORelArg m with
        | some depPkg, some cAbs, some oAbs, some cRel, some oRel =>
          match ← cAbs.metadata.toBaseIO with
          | .ok st =>
            if st.type != .file || st.byteSize == 0 then
              if failClosed then
                IO.eprintln s!"slake build: A31 path-dep object compile empty or non-file C input for module {m} at {cAbs} (fail-closed)"
                return some 1
              else
                IO.eprintln s!"slake build: A31 path-dep object compile warn — empty or non-file C input for module {m} at {cAbs}; skipping"
                go rest compiled (softSkipped + 1)
            else
              match oAbs.parent with
              | some parent =>
                try IO.FS.createDirAll parent
                catch e =>
                  IO.eprintln s!"slake build: A31 path-dep object compile: cannot create parent of {oAbs}: {e}"
                  return some 1
              | none => pure ()
              let args := #["-c", "-fPIC", s!"-I{includeDir}", "-o", oRel, cRel]
              IO.println s!"slake build: native path-dep object compile: {cc} {" ".intercalate args.toList} (cwd={depPkg})"
              match ← (IO.Process.output {
                  cmd := cc
                  args := args
                  cwd := some depPkg
                }).toBaseIO with
              | .error e =>
                IO.eprintln s!"slake build: native path-dep object compile spawn failed for module {m}: {e}"
                return some 1
              | .ok out =>
                if out.exitCode != 0 then
                  if !out.stdout.isEmpty then
                    IO.eprintln out.stdout
                  if !out.stderr.isEmpty then
                    IO.eprintln out.stderr
                  IO.eprintln s!"slake build: native path-dep object compile failed for module {m} (cc exited {out.exitCode})"
                  return some out.exitCode
                match ← oAbs.metadata.toBaseIO with
                | .ok ost =>
                  if ost.type != .file || ost.byteSize == 0 then
                    IO.eprintln s!"slake build: native path-dep object compile empty or non-file object for module {m} at {oAbs}"
                    return some 1
                  else
                    go rest (compiled + 1) softSkipped
                | .error _ =>
                  IO.eprintln s!"slake build: native path-dep object compile claimed success but missing {oAbs}"
                  return some 1
          | .error _ =>
            if failClosed then
              IO.eprintln s!"slake build: A31 path-dep object compile missing C input for module {m} at {cAbs} (fail-closed — run NATIVE_C first or set NATIVE_OBJ which implies C emit)"
              return some 1
            else
              IO.eprintln s!"slake build: A31 path-dep object compile warn — missing C input for module {m} at {cAbs}; skipping"
              go rest compiled (softSkipped + 1)
        | _, _, _, _, _ =>
          if failClosed then
            IO.eprintln s!"slake build: A31 path-dep object compile cannot resolve package/C/O path for module {m} (fail-closed)"
            return some 1
          else
            IO.eprintln s!"slake build: A31 path-dep object compile warn — cannot resolve package/C/O path for module {m}; skipping"
            go rest compiled (softSkipped + 1)
  go mods 0 0

/-- A21: host leanc IR shared-lib link of plan-module objects + Lean runtime.

After successful native object compile (A20 / A31 path-dep OBJ), collect non-empty
regular plan-module `.o` files in expanded-plan topo order and spawn host
`leanc -shared -o .slake-native/libslake_ir.so <obj…>` with `cwd=pkg`.
Root modules: `.slake-native/<ModRel>.o`. A30-folded path-dep modules (A31):
`dep/.slake-native/<ModRel>.o` (path relative to root when under pkg, else absolute).
`LEANC` env or `leanc` on PATH (optional same-dir as `LEAN`).

**Honesty:** host leanc IR shared-lib link subset of plan-module objects + Lean
runtime via leanc — **not** freestanding build TCB / **not** Lake lean_lib
shared-object TCB / **not** CLAIMED / **not** full Lake shared facet. A13
`NATIVE_LINK` remains a separate name-table SO (`libslake_native.so`); this
writes `libslake_ir.so` so both can coexist. When path-dep objs are linked:
freestanding-adjacent path-dep plan-module C/OBJ into IR products subset (not
every dep plan module / not git/url).

Missing leanc / missing `.o` / zero objs: soft warn + skip unless
`SLAKE_NATIVE_IRLINK_STRICT=1` or `SLAKE_NATIVE_BUILD=1` (fail-closed so
skip-lake requires IR link success when IRLINK is set). Nonzero leanc exit is
always fail-closed. Empty/missing SO after claimed success is always fail-closed.
Always re-links when requested (no mtime skip). Implies NATIVE_OBJ (+ NATIVE_C +
NATIVE_OLEAN) so the object files exist before link. -/
def runNativeIrLink (pkg : FilePath) (id : Slake.Config.PackageIdentity)
    (ordered : List String) (pathDepInPlan : List PathDepModuleInfo := []) : IO (Option UInt32) := do
  let strict ← envFlagTruthy "SLAKE_NATIVE_IRLINK_STRICT"
  let nativeBuild ← envFlagTruthy "SLAKE_NATIVE_BUILD"
  let failClosed := strict || nativeBuild
  let leanc ← match ← resolveLeancCmd with
    | some c => pure c
    | none =>
      if failClosed then
        if nativeBuild && !strict then
          IO.eprintln "slake build: SLAKE_NATIVE_IRLINK=1 under NATIVE_BUILD but leanc not found or not usable (set LEANC=); fail-closed (no skip-lake without IR link)"
        else
          IO.eprintln "slake build: SLAKE_NATIVE_IRLINK=1 but leanc not found or not usable (set LEANC=); STRICT"
        return some 1
      else
        IO.eprintln "slake build: SLAKE_NATIVE_IRLINK=1 but leanc not found or not usable; skipping host leanc IR shared-lib link"
        return none
  let outDir := nativeOleanOutDir pkg
  try
    IO.FS.createDirAll outDir
  catch e =>
    IO.eprintln s!"slake build: SLAKE_NATIVE_IRLINK=1 cannot create {outDir}: {e}"
    return some 1
  let pkgName := id.name
  let mods := ordered.filter fun n =>
    !(pkgName == some n || n == "(unknown)") &&
      Slake.Config.isSafeModName n
  if mods.isEmpty then
    if failClosed then
      IO.eprintln "slake build: SLAKE_NATIVE_IRLINK=1 no plan modules for IR link (fail-closed)"
      return some 1
    else
      IO.eprintln "slake build: SLAKE_NATIVE_IRLINK=1 warn — no plan modules for IR link; skipping"
      return none
  -- Collect non-empty regular .o args (topo order; A31 path-dep under dep outDir).
  let rec collectObjs (ms : List String) (acc : List String) (softSkipped : Nat) (pathDepN : Nat)
      : IO (Option (List String × Nat × Nat)) := do
    match ms with
    | [] => pure (some (acc.reverse, softSkipped, pathDepN))
    | m :: rest =>
      match pathDepInPlan.find? (fun p => p.mod == m) with
      | some info =>
        match pathDepObjAbs info with
        | none =>
          if failClosed then
            IO.eprintln s!"slake build: SLAKE_NATIVE_IRLINK=1 cannot resolve path-dep object for module {m} (fail-closed)"
            return none
          else
            IO.eprintln s!"slake build: SLAKE_NATIVE_IRLINK=1 warn — cannot resolve path-dep object for module {m}; skipping"
            collectObjs rest acc (softSkipped + 1) pathDepN
        | some oAbs =>
          match ← oAbs.metadata.toBaseIO with
          | .ok st =>
            if st.type != .file || st.byteSize == 0 then
              if failClosed then
                IO.eprintln s!"slake build: SLAKE_NATIVE_IRLINK=1 empty or non-file path-dep object for module {m} at {oAbs} (fail-closed — run NATIVE_OBJ first or set NATIVE_IRLINK which implies object compile)"
                return none
              else
                IO.eprintln s!"slake build: SLAKE_NATIVE_IRLINK=1 warn — empty or non-file path-dep object for module {m} at {oAbs}; skipping"
                collectObjs rest acc (softSkipped + 1) pathDepN
            else
              -- Prefer path relative to root package when under root; else absolute.
              let oArg := pathRelToPkg pkg oAbs
              collectObjs rest (oArg :: acc) softSkipped (pathDepN + 1)
          | .error _ =>
            if failClosed then
              IO.eprintln s!"slake build: SLAKE_NATIVE_IRLINK=1 missing path-dep object for module {m} at {oAbs} (fail-closed — run NATIVE_OBJ first or set NATIVE_IRLINK which implies object compile)"
              return none
            else
              IO.eprintln s!"slake build: SLAKE_NATIVE_IRLINK=1 warn — missing path-dep object for module {m} at {oAbs}; skipping"
              collectObjs rest acc (softSkipped + 1) pathDepN
      | none =>
        match nativeORelArg m, moduleORel m with
        | some oRel, some oRelPath =>
          let oAbs := outDir / oRelPath
          match ← oAbs.metadata.toBaseIO with
          | .ok st =>
            if st.type != .file || st.byteSize == 0 then
              if failClosed then
                IO.eprintln s!"slake build: SLAKE_NATIVE_IRLINK=1 empty or non-file object for module {m} at {oAbs} (fail-closed — run NATIVE_OBJ first or set NATIVE_IRLINK which implies object compile)"
                return none
              else
                IO.eprintln s!"slake build: SLAKE_NATIVE_IRLINK=1 warn — empty or non-file object for module {m} at {oAbs}; skipping"
                collectObjs rest acc (softSkipped + 1) pathDepN
            else
              collectObjs rest (oRel :: acc) softSkipped pathDepN
          | .error _ =>
            if failClosed then
              IO.eprintln s!"slake build: SLAKE_NATIVE_IRLINK=1 missing object for module {m} at {oAbs} (fail-closed — run NATIVE_OBJ first or set NATIVE_IRLINK which implies object compile)"
              return none
            else
              IO.eprintln s!"slake build: SLAKE_NATIVE_IRLINK=1 warn — missing object for module {m} at {oAbs}; skipping"
              collectObjs rest acc (softSkipped + 1) pathDepN
        | _, _ =>
          if failClosed then
            IO.eprintln s!"slake build: SLAKE_NATIVE_IRLINK=1 unsafe module name {m} (fail-closed)"
            return none
          else
            IO.eprintln s!"slake build: SLAKE_NATIVE_IRLINK=1 warn — unsafe module name {m}; skipping"
            collectObjs rest acc (softSkipped + 1) pathDepN
  match ← collectObjs mods [] 0 0 with
  | none =>
    -- collectObjs already printed; fail-closed path.
    return some 1
  | some (objRels, softSkipped, pathDepN) =>
    if objRels.isEmpty then
      if failClosed then
        IO.eprintln s!"slake build: SLAKE_NATIVE_IRLINK=1 zero object files for IR link (soft-skipped {softSkipped}; fail-closed — no zero-work success)"
        return some 1
      else
        IO.eprintln s!"slake build: SLAKE_NATIVE_IRLINK=1 warn — zero object files for IR link (soft-skipped {softSkipped}); skipping"
        return none
    let soRel := ".slake-native/libslake_ir.so"
    let soPath := outDir / "libslake_ir.so"
    let args := #["-shared", "-o", soRel] ++ objRels.toArray
    IO.println "slake build: SLAKE_NATIVE_IRLINK=1; host leanc IR shared-lib link subset of plan-module objects + Lean runtime via leanc"
    IO.println "  (not freestanding build TCB / not Lake lean_lib shared-object TCB / not CLAIMED / not full Lake shared facet; A13 NATIVE_LINK remains separate name-table SO)"
    if pathDepN > 0 then
      IO.println s!"  (A31 freestanding-adjacent path-dep plan-module C/OBJ into IR products subset; {pathDepN} path-dep object(s) — not every dep plan module / not Lake lean_lib shared facet / not freestanding build TCB / not CLAIMED)"
    IO.println s!"  leanc={leanc} cwd={pkg} out={soRel} objs={objRels.length}"
    IO.println s!"slake build: native IR link: {leanc} {" ".intercalate args.toList}"
    match ← (IO.Process.output {
        cmd := leanc
        args := args
        cwd := some pkg
      }).toBaseIO with
    | .error e =>
      IO.eprintln s!"slake build: native IR link spawn failed: {e}"
      return some 1
    | .ok out =>
      if out.exitCode != 0 then
        if !out.stdout.isEmpty then
          IO.eprintln out.stdout
        if !out.stderr.isEmpty then
          IO.eprintln out.stderr
        IO.eprintln s!"slake build: native IR link failed (leanc exit {out.exitCode})"
        return some out.exitCode
      match ← soPath.metadata.toBaseIO with
      | .ok st =>
        if st.type != .file || st.byteSize == 0 then
          IO.eprintln s!"slake build: native IR link empty or non-file SO at {soPath}"
          return some 1
        else
          let pdNote :=
            if pathDepN > 0 then s!" + {pathDepN} path-dep" else ""
          IO.println s!"slake build: native IR link OK (host leanc IR shared-lib link subset; {objRels.length} object(s){pdNote} → {soRel}; not freestanding build TCB / not Lake lean_lib shared-object TCB / not CLAIMED)"
          return none
      | .error _ =>
        IO.eprintln s!"slake build: native IR link claimed success but missing {soPath}"
        return some 1

/-- A22: host static archive of plan-module objects via `ar rcs`.

After successful native object compile (A20) — and after optional A21 IR link when
both set — collect non-empty regular `.slake-native/<ModRel>.o` for topo plan
modules (skip package name; path confinement via safe module names / `moduleORel`)
and spawn host `ar rcs .slake-native/libslake_ir.a <objRel…>` with `cwd=pkg`.
`AR` env or `ar` on PATH.

**Honesty:** host static archive of plan-module objects subset via `ar rcs` —
**not** freestanding build TCB / **not** Lake lean_lib static/shared facet /
**not** CLAIMED / **not** linking Lean runtime into the archive (plain `ar` of
module `.o` only; A21 leanc still the path that pulls runtime into SO). A13
`NATIVE_LINK` remains a separate name-table SO (`libslake_native.so`); A21
`NATIVE_IRLINK` remains a separate leanc IR SO (`libslake_ir.so`); this writes
`libslake_ir.a` so all three can coexist. Does **not** imply IRLINK.

Missing ar / missing `.o` / zero objs: soft warn + skip unless
`SLAKE_NATIVE_AR_STRICT=1` or `SLAKE_NATIVE_BUILD=1` (fail-closed so skip-lake
requires archive success when AR is set). Nonzero ar exit is always fail-closed.
Empty/missing `.a` after claimed success is always fail-closed. Always re-archives
when requested (no mtime skip). Implies NATIVE_OBJ (+ NATIVE_C + NATIVE_OLEAN) so
the object files exist before archive. -/
def runNativeAr (pkg : FilePath) (id : Slake.Config.PackageIdentity)
    (ordered : List String) (pathDepInPlan : List PathDepModuleInfo := []) : IO (Option UInt32) := do
  let strict ← envFlagTruthy "SLAKE_NATIVE_AR_STRICT"
  let nativeBuild ← envFlagTruthy "SLAKE_NATIVE_BUILD"
  let failClosed := strict || nativeBuild
  let ar ← match ← resolveArCmd with
    | some c => pure c
    | none =>
      if failClosed then
        if nativeBuild && !strict then
          IO.eprintln "slake build: SLAKE_NATIVE_AR=1 under NATIVE_BUILD but ar not found or not usable (set AR=); fail-closed (no skip-lake without static archive)"
        else
          IO.eprintln "slake build: SLAKE_NATIVE_AR=1 but ar not found or not usable (set AR=); STRICT"
        return some 1
      else
        IO.eprintln "slake build: SLAKE_NATIVE_AR=1 but ar not found or not usable; skipping host static archive of plan-module objects"
        return none
  let outDir := nativeOleanOutDir pkg
  try
    IO.FS.createDirAll outDir
  catch e =>
    IO.eprintln s!"slake build: SLAKE_NATIVE_AR=1 cannot create {outDir}: {e}"
    return some 1
  let pkgName := id.name
  let mods := ordered.filter fun n =>
    !(pkgName == some n || n == "(unknown)") &&
      Slake.Config.isSafeModName n
  if mods.isEmpty then
    if failClosed then
      IO.eprintln "slake build: SLAKE_NATIVE_AR=1 no plan modules for static archive (fail-closed)"
      return some 1
    else
      IO.eprintln "slake build: SLAKE_NATIVE_AR=1 warn — no plan modules for static archive; skipping"
      return none
  -- Collect non-empty regular .o args (topo order; A31 path-dep under dep outDir).
  let rec collectObjs (ms : List String) (acc : List String) (softSkipped : Nat) (pathDepN : Nat)
      : IO (Option (List String × Nat × Nat)) := do
    match ms with
    | [] => pure (some (acc.reverse, softSkipped, pathDepN))
    | m :: rest =>
      match pathDepInPlan.find? (fun p => p.mod == m) with
      | some info =>
        match pathDepObjAbs info with
        | none =>
          if failClosed then
            IO.eprintln s!"slake build: SLAKE_NATIVE_AR=1 cannot resolve path-dep object for module {m} (fail-closed)"
            return none
          else
            IO.eprintln s!"slake build: SLAKE_NATIVE_AR=1 warn — cannot resolve path-dep object for module {m}; skipping"
            collectObjs rest acc (softSkipped + 1) pathDepN
        | some oAbs =>
          match ← oAbs.metadata.toBaseIO with
          | .ok st =>
            if st.type != .file || st.byteSize == 0 then
              if failClosed then
                IO.eprintln s!"slake build: SLAKE_NATIVE_AR=1 empty or non-file path-dep object for module {m} at {oAbs} (fail-closed — run NATIVE_OBJ first or set NATIVE_AR which implies object compile)"
                return none
              else
                IO.eprintln s!"slake build: SLAKE_NATIVE_AR=1 warn — empty or non-file path-dep object for module {m} at {oAbs}; skipping"
                collectObjs rest acc (softSkipped + 1) pathDepN
            else
              let oArg := pathRelToPkg pkg oAbs
              collectObjs rest (oArg :: acc) softSkipped (pathDepN + 1)
          | .error _ =>
            if failClosed then
              IO.eprintln s!"slake build: SLAKE_NATIVE_AR=1 missing path-dep object for module {m} at {oAbs} (fail-closed — run NATIVE_OBJ first or set NATIVE_AR which implies object compile)"
              return none
            else
              IO.eprintln s!"slake build: SLAKE_NATIVE_AR=1 warn — missing path-dep object for module {m} at {oAbs}; skipping"
              collectObjs rest acc (softSkipped + 1) pathDepN
      | none =>
        match nativeORelArg m, moduleORel m with
        | some oRel, some oRelPath =>
          let oAbs := outDir / oRelPath
          match ← oAbs.metadata.toBaseIO with
          | .ok st =>
            if st.type != .file || st.byteSize == 0 then
              if failClosed then
                IO.eprintln s!"slake build: SLAKE_NATIVE_AR=1 empty or non-file object for module {m} at {oAbs} (fail-closed — run NATIVE_OBJ first or set NATIVE_AR which implies object compile)"
                return none
              else
                IO.eprintln s!"slake build: SLAKE_NATIVE_AR=1 warn — empty or non-file object for module {m} at {oAbs}; skipping"
                collectObjs rest acc (softSkipped + 1) pathDepN
            else
              collectObjs rest (oRel :: acc) softSkipped pathDepN
          | .error _ =>
            if failClosed then
              IO.eprintln s!"slake build: SLAKE_NATIVE_AR=1 missing object for module {m} at {oAbs} (fail-closed — run NATIVE_OBJ first or set NATIVE_AR which implies object compile)"
              return none
            else
              IO.eprintln s!"slake build: SLAKE_NATIVE_AR=1 warn — missing object for module {m} at {oAbs}; skipping"
              collectObjs rest acc (softSkipped + 1) pathDepN
        | _, _ =>
          if failClosed then
            IO.eprintln s!"slake build: SLAKE_NATIVE_AR=1 unsafe module name {m} (fail-closed)"
            return none
          else
            IO.eprintln s!"slake build: SLAKE_NATIVE_AR=1 warn — unsafe module name {m}; skipping"
            collectObjs rest acc (softSkipped + 1) pathDepN
  match ← collectObjs mods [] 0 0 with
  | none =>
    -- collectObjs already printed; fail-closed path.
    return some 1
  | some (objRels, softSkipped, pathDepN) =>
    if objRels.isEmpty then
      if failClosed then
        IO.eprintln s!"slake build: SLAKE_NATIVE_AR=1 zero object files for static archive (soft-skipped {softSkipped}; fail-closed — no zero-work success)"
        return some 1
      else
        IO.eprintln s!"slake build: SLAKE_NATIVE_AR=1 warn — zero object files for static archive (soft-skipped {softSkipped}); skipping"
        return none
    let aRel := ".slake-native/libslake_ir.a"
    let aPath := outDir / "libslake_ir.a"
    -- Always re-archive: remove stale archive first so `ar rcs` does not accumulate
    -- deleted members across plan changes (no mtime skip; honest full rewrite).
    try
      if ← pathIsRegularFile aPath then
        IO.FS.removeFile aPath
    catch _ => pure ()
    let args := #["rcs", aRel] ++ objRels.toArray
    IO.println "slake build: SLAKE_NATIVE_AR=1; host static archive of plan-module objects subset via ar rcs"
    IO.println "  (not freestanding build TCB / not Lake lean_lib static/shared facet / not CLAIMED / not linking Lean runtime into the archive; A21 leanc still the path that pulls runtime into SO)"
    if pathDepN > 0 then
      IO.println s!"  (A31 freestanding-adjacent path-dep plan-module C/OBJ into IR products subset; {pathDepN} path-dep object(s) — not every dep plan module / not Lake lean_lib shared facet / not freestanding build TCB / not CLAIMED)"
    IO.println s!"  ar={ar} cwd={pkg} out={aRel} objs={objRels.length}"
    IO.println s!"slake build: native static archive: {ar} {" ".intercalate args.toList}"
    match ← (IO.Process.output {
        cmd := ar
        args := args
        cwd := some pkg
      }).toBaseIO with
    | .error e =>
      IO.eprintln s!"slake build: native static archive spawn failed: {e}"
      return some 1
    | .ok out =>
      if out.exitCode != 0 then
        if !out.stdout.isEmpty then
          IO.eprintln out.stdout
        if !out.stderr.isEmpty then
          IO.eprintln out.stderr
        IO.eprintln s!"slake build: native static archive failed (ar exit {out.exitCode})"
        return some out.exitCode
      match ← aPath.metadata.toBaseIO with
      | .ok st =>
        if st.type != .file || st.byteSize == 0 then
          IO.eprintln s!"slake build: native static archive empty or non-file at {aPath}"
          return some 1
        else
          let pdNote := if pathDepN > 0 then s!" + {pathDepN} path-dep" else ""
          IO.println s!"slake build: native static archive OK (host static archive of plan-module objects subset; {objRels.length} object(s){pdNote} → {aRel}; not freestanding build TCB / not Lake lean_lib static/shared facet / not CLAIMED)"
          return none
      | .error _ =>
        IO.eprintln s!"slake build: native static archive claimed success but missing {aPath}"
        return some 1

/-- A23: host leanc executable link of plan-module objects + stub main + Lean runtime.

After successful native object compile (A20) — and after optional A21 IR link /
A22 static archive when set — collect non-empty regular
`.slake-native/<ModRel>.o` for topo plan modules (skip package name; path
confinement via safe module names / `moduleORel`), write package-local
`.slake-native/slake_native_main.c` with a minimal C `main` that returns 0
(generated stub main — **not** Lake lean_exe root / **not** freestanding app TCB /
**not** a real application entry from lakefile), and spawn host
`leanc -o .slake-native/slake_ir .slake-native/slake_native_main.c <objRel…>`
with `cwd=pkg`. `LEANC` env or `leanc` on PATH (same `resolveLeancCmd` as A21).

**Honesty:** host leanc executable link subset of plan-module objects + stub
main + Lean runtime via leanc — **not** freestanding build TCB / **not** Lake
lean_exe / **not** Lake lean_lib shared facet / **not** CLAIMED / **not** a real
application entry from lakefile. Coexists with `libslake_ir.so` /
`libslake_ir.a` / `libslake_native.so`. Does **not** imply IRLINK or AR.

Missing leanc / missing `.o` / zero objs: soft warn + skip unless
`SLAKE_NATIVE_EXE_STRICT=1` or `SLAKE_NATIVE_BUILD=1` (fail-closed so skip-lake
requires executable link success when EXE is set). Nonzero leanc exit is always
fail-closed. Empty/missing binary after claimed success is always fail-closed.
Always re-links when requested (no mtime skip; removes stale binary first).
Implies NATIVE_OBJ (+ NATIVE_C + NATIVE_OLEAN) so the object files exist. -/
def runNativeExe (pkg : FilePath) (id : Slake.Config.PackageIdentity)
    (ordered : List String) (pathDepInPlan : List PathDepModuleInfo := []) : IO (Option UInt32) := do
  let strict ← envFlagTruthy "SLAKE_NATIVE_EXE_STRICT"
  let nativeBuild ← envFlagTruthy "SLAKE_NATIVE_BUILD"
  let failClosed := strict || nativeBuild
  let leanc ← match ← resolveLeancCmd with
    | some c => pure c
    | none =>
      if failClosed then
        if nativeBuild && !strict then
          IO.eprintln "slake build: SLAKE_NATIVE_EXE=1 under NATIVE_BUILD but leanc not found or not usable (set LEANC=); fail-closed (no skip-lake without executable link)"
        else
          IO.eprintln "slake build: SLAKE_NATIVE_EXE=1 but leanc not found or not usable (set LEANC=); STRICT"
        return some 1
      else
        IO.eprintln "slake build: SLAKE_NATIVE_EXE=1 but leanc not found or not usable; skipping host leanc executable link"
        return none
  let outDir := nativeOleanOutDir pkg
  try
    IO.FS.createDirAll outDir
  catch e =>
    IO.eprintln s!"slake build: SLAKE_NATIVE_EXE=1 cannot create {outDir}: {e}"
    return some 1
  let pkgName := id.name
  let mods := ordered.filter fun n =>
    !(pkgName == some n || n == "(unknown)") &&
      Slake.Config.isSafeModName n
  if mods.isEmpty then
    if failClosed then
      IO.eprintln "slake build: SLAKE_NATIVE_EXE=1 no plan modules for executable link (fail-closed)"
      return some 1
    else
      IO.eprintln "slake build: SLAKE_NATIVE_EXE=1 warn — no plan modules for executable link; skipping"
      return none
  -- Collect non-empty regular .o args (topo order; A31 path-dep under dep outDir).
  let rec collectObjs (ms : List String) (acc : List String) (softSkipped : Nat) (pathDepN : Nat)
      : IO (Option (List String × Nat × Nat)) := do
    match ms with
    | [] => pure (some (acc.reverse, softSkipped, pathDepN))
    | m :: rest =>
      match pathDepInPlan.find? (fun p => p.mod == m) with
      | some info =>
        match pathDepObjAbs info with
        | none =>
          if failClosed then
            IO.eprintln s!"slake build: SLAKE_NATIVE_EXE=1 cannot resolve path-dep object for module {m} (fail-closed)"
            return none
          else
            IO.eprintln s!"slake build: SLAKE_NATIVE_EXE=1 warn — cannot resolve path-dep object for module {m}; skipping"
            collectObjs rest acc (softSkipped + 1) pathDepN
        | some oAbs =>
          match ← oAbs.metadata.toBaseIO with
          | .ok st =>
            if st.type != .file || st.byteSize == 0 then
              if failClosed then
                IO.eprintln s!"slake build: SLAKE_NATIVE_EXE=1 empty or non-file path-dep object for module {m} at {oAbs} (fail-closed — run NATIVE_OBJ first or set NATIVE_EXE which implies object compile)"
                return none
              else
                IO.eprintln s!"slake build: SLAKE_NATIVE_EXE=1 warn — empty or non-file path-dep object for module {m} at {oAbs}; skipping"
                collectObjs rest acc (softSkipped + 1) pathDepN
            else
              let oArg := pathRelToPkg pkg oAbs
              collectObjs rest (oArg :: acc) softSkipped (pathDepN + 1)
          | .error _ =>
            if failClosed then
              IO.eprintln s!"slake build: SLAKE_NATIVE_EXE=1 missing path-dep object for module {m} at {oAbs} (fail-closed — run NATIVE_OBJ first or set NATIVE_EXE which implies object compile)"
              return none
            else
              IO.eprintln s!"slake build: SLAKE_NATIVE_EXE=1 warn — missing path-dep object for module {m} at {oAbs}; skipping"
              collectObjs rest acc (softSkipped + 1) pathDepN
      | none =>
        match nativeORelArg m, moduleORel m with
        | some oRel, some oRelPath =>
          let oAbs := outDir / oRelPath
          match ← oAbs.metadata.toBaseIO with
          | .ok st =>
            if st.type != .file || st.byteSize == 0 then
              if failClosed then
                IO.eprintln s!"slake build: SLAKE_NATIVE_EXE=1 empty or non-file object for module {m} at {oAbs} (fail-closed — run NATIVE_OBJ first or set NATIVE_EXE which implies object compile)"
                return none
              else
                IO.eprintln s!"slake build: SLAKE_NATIVE_EXE=1 warn — empty or non-file object for module {m} at {oAbs}; skipping"
                collectObjs rest acc (softSkipped + 1) pathDepN
            else
              collectObjs rest (oRel :: acc) softSkipped pathDepN
          | .error _ =>
            if failClosed then
              IO.eprintln s!"slake build: SLAKE_NATIVE_EXE=1 missing object for module {m} at {oAbs} (fail-closed — run NATIVE_OBJ first or set NATIVE_EXE which implies object compile)"
              return none
            else
              IO.eprintln s!"slake build: SLAKE_NATIVE_EXE=1 warn — missing object for module {m} at {oAbs}; skipping"
              collectObjs rest acc (softSkipped + 1) pathDepN
        | _, _ =>
          if failClosed then
            IO.eprintln s!"slake build: SLAKE_NATIVE_EXE=1 unsafe module name {m} (fail-closed)"
            return none
          else
            IO.eprintln s!"slake build: SLAKE_NATIVE_EXE=1 warn — unsafe module name {m}; skipping"
            collectObjs rest acc (softSkipped + 1) pathDepN
  match ← collectObjs mods [] 0 0 with
  | none =>
    return some 1
  | some (objRels, softSkipped, pathDepN) =>
    if objRels.isEmpty then
      if failClosed then
        IO.eprintln s!"slake build: SLAKE_NATIVE_EXE=1 zero object files for executable link (soft-skipped {softSkipped}; fail-closed — no zero-work success)"
        return some 1
      else
        IO.eprintln s!"slake build: SLAKE_NATIVE_EXE=1 warn — zero object files for executable link (soft-skipped {softSkipped}); skipping"
        return none
    let mainRel := ".slake-native/slake_native_main.c"
    let mainPath := outDir / "slake_native_main.c"
    let binRel := ".slake-native/slake_ir"
    let binPath := outDir / "slake_ir"
    -- Generated stub main: libraries lack Lean `main`; plain leanc of objs fails
    -- without one. Stub returns 0 — honesty: generated stub main, not Lake lean_exe.
    let mainSrc :=
      "/* A23 generated stub main for host leanc executable link.\n" ++
      " * NOT freestanding app TCB / NOT Lake lean_exe root / NOT CLAIMED /\n" ++
      " * NOT a real application entry from lakefile.\n" ++
      " */\n" ++
      "int main(void) { return 0; }\n"
    try
      IO.FS.writeFile mainPath mainSrc
    catch e =>
      IO.eprintln s!"slake build: SLAKE_NATIVE_EXE=1 cannot write {mainPath}: {e}"
      return some 1
    -- Always re-link: remove stale binary first (no mtime skip).
    try
      if ← pathIsRegularFile binPath then
        IO.FS.removeFile binPath
    catch _ => pure ()
    let args := #["-o", binRel, mainRel] ++ objRels.toArray
    IO.println "slake build: SLAKE_NATIVE_EXE=1; host leanc executable link subset of plan-module objects + stub main + Lean runtime via leanc"
    IO.println "  (not freestanding build TCB / not Lake lean_exe / not Lake lean_lib shared facet / not CLAIMED / not a real application entry from lakefile; generated stub main not Lake lean_exe root)"
    if pathDepN > 0 then
      IO.println s!"  (A31 freestanding-adjacent path-dep plan-module C/OBJ into IR products subset; {pathDepN} path-dep object(s) — not every dep plan module / not Lake lean_lib shared facet / not freestanding build TCB / not CLAIMED)"
    IO.println s!"  leanc={leanc} cwd={pkg} out={binRel} main={mainRel} objs={objRels.length}"
    IO.println s!"slake build: native executable link: {leanc} {" ".intercalate args.toList}"
    match ← (IO.Process.output {
        cmd := leanc
        args := args
        cwd := some pkg
      }).toBaseIO with
    | .error e =>
      IO.eprintln s!"slake build: native executable link spawn failed: {e}"
      return some 1
    | .ok out =>
      if out.exitCode != 0 then
        if !out.stdout.isEmpty then
          IO.eprintln out.stdout
        if !out.stderr.isEmpty then
          IO.eprintln out.stderr
        IO.eprintln s!"slake build: native executable link failed (leanc exit {out.exitCode})"
        return some out.exitCode
      match ← binPath.metadata.toBaseIO with
      | .ok st =>
        if st.type != .file || st.byteSize == 0 then
          IO.eprintln s!"slake build: native executable link empty or non-file at {binPath}"
          return some 1
        else
          let pdNote := if pathDepN > 0 then s!" + {pathDepN} path-dep" else ""
          IO.println s!"slake build: native executable link OK (host leanc executable link subset of plan-module objects + stub main + Lean runtime via leanc; {objRels.length} object(s){pdNote} → {binRel}; not freestanding build TCB / not Lake lean_exe / not CLAIMED)"
          return none
      | .error _ =>
        IO.eprintln s!"slake build: native executable link claimed success but missing {binPath}"
        return some 1

/-- A13: host shared-lib link subset after successful native olean compile.

Writes package-local `.slake-native/slake_native_export.c` exporting
`slake_native_plan_modules` (topo plan module names; skip package name node;
only `isSafeModName` labels), then runs host
`cc -shared -fPIC -o .slake-native/libslake_native.so …`.

**Honesty:** host shared-lib link subset — **not** Lake lean_lib shared-object of
compiled Lean IR / **not** freestanding build TCB / **not** Lake shared-lib TCB /
**not** CLAIMED. JOBS applies to olean waves only; link is sequential single cc.
Does **not** replace A13 with IR link of `.o` files from NATIVE_OBJ.

Missing `cc`: soft warn + skip unless `SLAKE_NATIVE_LINK_STRICT=1` or
`SLAKE_NATIVE_BUILD=1` (fail-closed so NATIVE_BUILD skip-lake requires link
success when NATIVE_LINK is also set). Actual link failure is always fail-closed.
Link always re-runs when requested (no mtime skip; simpler residual honesty). -/
def runNativeLink (pkg : FilePath) (id : Slake.Config.PackageIdentity)
    (ordered : List String) : IO (Option UInt32) := do
  let strict ← envFlagTruthy "SLAKE_NATIVE_LINK_STRICT"
  let nativeBuild ← envFlagTruthy "SLAKE_NATIVE_BUILD"
  -- Under NATIVE_BUILD, skip-lake requires link success when NATIVE_LINK is set.
  let failClosedMissingCc := strict || nativeBuild
  let cc ← match ← resolveCcCmd with
    | some c => pure c
    | none =>
      if failClosedMissingCc then
        if nativeBuild && !strict then
          IO.eprintln "slake build: SLAKE_NATIVE_LINK=1 under NATIVE_BUILD but cc not found or not usable (set CC=); fail-closed (no skip-lake without link)"
        else
          IO.eprintln "slake build: SLAKE_NATIVE_LINK=1 but cc not found or not usable (set CC=); STRICT"
        return some 1
      else
        IO.eprintln "slake build: SLAKE_NATIVE_LINK=1 but cc not found or not usable; skipping host shared-lib link"
        return none
  let outDir := nativeOleanOutDir pkg
  try
    IO.FS.createDirAll outDir
  catch e =>
    IO.eprintln s!"slake build: SLAKE_NATIVE_LINK=1 cannot create {outDir}: {e}"
    return some 1
  let pkgName := id.name
  -- Skip package name / unknown; only export path-safe module labels (same gate as olean).
  let mods := ordered.filter fun n =>
    !(pkgName == some n || n == "(unknown)") &&
      Slake.Config.isSafeModName n
  if mods.isEmpty then
    if failClosedMissingCc then
      IO.eprintln "slake build: SLAKE_NATIVE_LINK=1 no plan modules to export (fail-closed)"
      return some 1
    else
      IO.eprintln "slake build: SLAKE_NATIVE_LINK=1 warn — no plan modules to export; skipping link"
      return none
  let cSrcPath := outDir / "slake_native_export.c"
  let soPath := outDir / "libslake_native.so"
  let cSrcRel := ".slake-native/slake_native_export.c"
  let soRel := ".slake-native/libslake_native.so"
  let src := buildNativeLinkCSource mods
  try
    IO.FS.writeFile cSrcPath src
  catch e =>
    IO.eprintln s!"slake build: SLAKE_NATIVE_LINK=1 cannot write {cSrcPath}: {e}"
    return some 1
  IO.println "slake build: SLAKE_NATIVE_LINK=1; host shared-lib link subset after native oleans"
  IO.println "  (not Lake lean_lib shared-object of compiled Lean IR / not freestanding build TCB / not Lake shared-lib TCB / not CLAIMED)"
  IO.println s!"  cc={cc} cwd={pkg} src={cSrcRel} out={soRel}"
  IO.println s!"slake build: native link: {cc} -shared -fPIC -o {soRel} {cSrcRel}"
  match ← (IO.Process.output {
      cmd := cc
      args := #["-shared", "-fPIC", "-o", soRel, cSrcRel]
      cwd := some pkg
    }).toBaseIO with
  | .error e =>
    IO.eprintln s!"slake build: native link spawn failed: {e}"
    return some 1
  | .ok out =>
    if out.exitCode != 0 then
      if !out.stdout.isEmpty then
        IO.eprintln out.stdout
      if !out.stderr.isEmpty then
        IO.eprintln out.stderr
      IO.eprintln s!"slake build: native link failed (cc exit {out.exitCode})"
      return some 1
    if !(← soPath.pathExists) then
      IO.eprintln s!"slake build: native link claimed success but missing {soPath}"
      return some 1
    IO.println s!"slake build: native link OK (host shared-lib link subset; {mods.length} plan module name(s) in slake_native_plan_modules; not freestanding build TCB / not Lake shared-lib TCB / not CLAIMED)"
    return none

/-- A14: write package-local `.slake-native/slake_native_graph` after native oleans.

Stable text format (grep-friendly):
* header lines (A14 host package link graph subset honesty denials)
* `package <name>`
* `module <Mod> olean .slake-native/<rel>.olean` for each plan module with a
  regular-file olean (skip package name / unknown; `isSafeModName` only).
  **A32:** A30-folded path-dep plan modules use **package-cwd-relative** olean
  paths via `pathRelToPkg` — under-pkg `dep/.slake-native/Dep.olean`, A29 sibling
  confining `../dep/.slake-native/Dep.olean` — not absolute host paths; not every
  dep plan module (only A30-folded via `pathDepPlanNodes`).
* `c_source <Mod> <package-cwd-relative path>` for each plan module with a
  regular-file `.c` (**A35** freestanding-adjacent plan-module C source inventory;
  root `.slake-native/<ModRel>.c` or A30-folded path-dep via `pathRelToPkg` —
  under-pkg `dep/.slake-native/Dep.c`, A29 sibling `../dep/.slake-native/Dep.c`;
  soft-omit missing `.c`; distinct line so A14/A32 olean lines stay stable).
* `object <Mod> <package-cwd-relative path>` for each plan module with a
  regular-file `.o` (**A34** freestanding-adjacent plan-module object inventory;
  root `.slake-native/<ModRel>.o` or A30-folded path-dep via `pathRelToPkg` —
  under-pkg `dep/.slake-native/Dep.o`, A29 sibling `../dep/.slake-native/Dep.o`;
  soft-omit missing `.o`; distinct line so A14/A32 olean lines stay stable).
* `edge <from> <to>` for each A5 direct plan-import edge among those modules
  (`from → to` means `to` imports `from`)
* `shared_lib .slake-native/libslake_native.so` when that file exists (after
  optional NATIVE_LINK; A13 name-table SO)
* `shared_lib_ir .slake-native/libslake_ir.so` when that file exists (after
  optional NATIVE_IRLINK; A21 IR SO — distinct field; does not replace
  `shared_lib`)
* `static_lib .slake-native/libslake_ir.a` when that file exists (after optional
  NATIVE_AR; A22 static archive — distinct field; does not replace `shared_lib`
  or `shared_lib_ir`)
* `executable .slake-native/slake_ir` when that file exists (after optional
  NATIVE_EXE; A23 host leanc executable — distinct field; does not replace
  `shared_lib` / `shared_lib_ir` / `static_lib`)
* `summary modules=N edges=M`

**Honesty:** host package link graph subset — **not** freestanding build TCB /
**not** Lake build graph TCB / **not** Lake lean_lib shared-object / **not**
CLAIMED. **A32** freestanding-adjacent path-dep plan-module nodes in NATIVE_GRAPH
subset (A30-folded only) — **not** freestanding build TCB / **not** Lake build
graph TCB / **not** Lake resolve-deps / **not** CLAIMED / **not** every dep plan
module / **not** git/url / **not** multi-`..`. **A35** freestanding-adjacent
plan-module C source inventory in NATIVE_GRAPH — **not** freestanding build TCB /
**not** Lake lean_lib facet / **not** CLAIMED / **not** every dep plan module /
**not** changing C emit semantics. **A34** freestanding-adjacent
plan-module object inventory in NATIVE_GRAPH — **not** freestanding build TCB /
**not** Lake lean_lib facet / **not** CLAIMED / **not** every dep plan module /
**not** name-table SO (A13). Always re-writes when requested (no mtime skip).
Graph write IO failure is always fail-closed. Empty plan modules / no oleans
present: fail-closed under `SLAKE_NATIVE_GRAPH_STRICT=1` or
`SLAKE_NATIVE_BUILD=1` (so skip-lake cannot greenwash empty graph); soft-skip
otherwise. Missing path-dep olean for a folded module: soft path may omit that
module line with warn (same incomplete-omit style as root modules). Missing `.c`
soft-omits that c_source line (no fail solely for zero C sources). Missing `.o`
soft-omits that object line (no fail solely for zero objects). A32 header and
banner only when at least one path-dep module line is present. A35 header and
banner only when at least one c_source line is present. A34 header and
banner only when at least one object line is present. -/
def runNativeGraph (pkg : FilePath) (id : Slake.Config.PackageIdentity)
    (ordered : List String) (pathDepMods : List PathDepModuleInfo := [])
    : IO (Option UInt32) := do
  let strict ← envFlagTruthy "SLAKE_NATIVE_GRAPH_STRICT"
  let nativeBuild ← envFlagTruthy "SLAKE_NATIVE_BUILD"
  let failClosedEmpty := strict || nativeBuild
  let outDir := nativeOleanOutDir pkg
  try
    IO.FS.createDirAll outDir
  catch e =>
    IO.eprintln s!"slake build: SLAKE_NATIVE_GRAPH=1 cannot create {outDir}: {e}"
    return some 1
  let pkgName := id.name
  let mods := ordered.filter fun n =>
    !(pkgName == some n || n == "(unknown)") &&
      Slake.Config.isSafeModName n
  if mods.isEmpty then
    if failClosedEmpty then
      IO.eprintln "slake build: SLAKE_NATIVE_GRAPH=1 no plan modules for graph (fail-closed)"
      return some 1
    else
      IO.eprintln "slake build: SLAKE_NATIVE_GRAPH=1 warn — no plan modules for graph; skipping"
      return none
  -- A30/A32/A34/A35: reuse caller path-dep inventory (same as A31 IRLINK/AR/EXE); fold filter only.
  let rootNodes ← Slake.Config.planNodesIO pkg id
  let pathDepInPlan := pathDepPlanNodes rootNodes ordered pathDepMods
  -- Modules with regular-file oleans under root `.slake-native/` or path-dep package.
  -- Acc: present (mod, package-cwd-relative olean path) + soft-omitted path-dep mods.
  let rec collectPresent (ms : List String) (acc : List (String × String))
      (omittedPd : List String) : IO (List (String × String) × List String) := do
    match ms with
    | [] => pure (acc.reverse, omittedPd.reverse)
    | m :: rest =>
      match pathDepInPlan.find? (fun p => p.mod == m) with
      | some info =>
        if ← pathIsRegularFile info.olean then
          -- A32: package-cwd-relative (under-pkg or A29 single-parent `../dep/...`).
          let relStr := pathRelToPkg pkg info.olean
          collectPresent rest ((m, relStr) :: acc) omittedPd
        else
          collectPresent rest acc (m :: omittedPd)
      | none =>
        match moduleOleanRel m with
        | none => collectPresent rest acc omittedPd
        | some rel =>
          let oleanPath := outDir / rel
          if ← pathIsRegularFile oleanPath then
            let relStr := ".slake-native/" ++ rel.toString
            collectPresent rest ((m, relStr) :: acc) omittedPd
          else
            collectPresent rest acc omittedPd
  let (present, omittedPd) ← collectPresent mods [] []
  if !omittedPd.isEmpty then
    let names := ", ".intercalate omittedPd
    IO.eprintln s!"slake build: SLAKE_NATIVE_GRAPH=1 warn — A30-folded path-dep olean missing; omitting module line(s): {names}"
  if present.isEmpty then
    if failClosedEmpty then
      IO.eprintln "slake build: SLAKE_NATIVE_GRAPH=1 no oleans present for graph (fail-closed)"
      return some 1
    else
      IO.eprintln "slake build: SLAKE_NATIVE_GRAPH=1 warn — no oleans present for graph; skipping"
      return none
  -- A35: plan-module C source inventory (root + A30-folded path-dep; soft-omit missing .c).
  let rec collectCs (ms : List String) (acc : List (String × String))
      : IO (List (String × String)) := do
    match ms with
    | [] => pure acc.reverse
    | m :: rest =>
      match pathDepInPlan.find? (fun p => p.mod == m) with
      | some info =>
        match pathDepCAbs info with
        | some cAbs =>
          if ← pathIsRegularFile cAbs then
            let relStr := pathRelToPkg pkg cAbs
            collectCs rest ((m, relStr) :: acc)
          else
            collectCs rest acc
        | none => collectCs rest acc
      | none =>
        match moduleCRel m with
        | none => collectCs rest acc
        | some rel =>
          let cPath := outDir / rel
          if ← pathIsRegularFile cPath then
            let relStr := ".slake-native/" ++ rel.toString
            collectCs rest ((m, relStr) :: acc)
          else
            collectCs rest acc
  let cs ← collectCs mods []
  let cN := cs.length
  -- A34: plan-module object inventory (root + A30-folded path-dep; soft-omit missing .o).
  let rec collectObjs (ms : List String) (acc : List (String × String))
      : IO (List (String × String)) := do
    match ms with
    | [] => pure acc.reverse
    | m :: rest =>
      match pathDepInPlan.find? (fun p => p.mod == m) with
      | some info =>
        match pathDepObjAbs info with
        | some oAbs =>
          if ← pathIsRegularFile oAbs then
            let relStr := pathRelToPkg pkg oAbs
            collectObjs rest ((m, relStr) :: acc)
          else
            collectObjs rest acc
        | none => collectObjs rest acc
      | none =>
        match moduleORel m with
        | none => collectObjs rest acc
        | some rel =>
          let oPath := outDir / rel
          if ← pathIsRegularFile oPath then
            let relStr := ".slake-native/" ++ rel.toString
            collectObjs rest ((m, relStr) :: acc)
          else
            collectObjs rest acc
  let objs ← collectObjs mods []
  let objN := objs.length
  -- Edges over expanded plan order (same set as olean wave; A31-style threaded inventory).
  let edges ← Slake.Config.collectImportEdges pkg ordered id (pathDepExtraSrc pathDepMods)
  let presentNames := present.map (·.1)
  let isPresent (n : String) : Bool := presentNames.any (· == n)
  let edgeLines : List String :=
    edges.filterMap fun (s, d) =>
      match ordered[s]?, ordered[d]? with
      | some sn, some dn =>
        if isPresent sn && isPresent dn then
          some s!"edge {sn} {dn}"
        else none
      | _, _ => none
  let pkgLabel :=
    match pkgName with
    | some n => n
    | none => "(unknown)"
  let pdN : Nat := present.foldl (init := (0 : Nat)) fun n (m, _) =>
    if pathDepInPlan.any (fun p => p.mod == m) then n + 1 else n
  -- A32 header only when at least one path-dep module line is present (not fold-only).
  let a32Header :=
    if pdN == 0 then ""
    else
      "# A32 freestanding-adjacent path-dep plan-module nodes in NATIVE_GRAPH subset (A30-folded only)\n" ++
      "# NOT freestanding build TCB / NOT Lake build graph TCB / NOT Lake resolve-deps / NOT CLAIMED / NOT every dep plan module / NOT git/url / NOT multi-..\n"
  -- A35 header only when at least one c_source line is present.
  let a35Header :=
    if cN == 0 then ""
    else
      "# A35 freestanding-adjacent plan-module C source inventory in NATIVE_GRAPH subset\n" ++
      "# NOT freestanding build TCB / NOT Lake lean_lib facet / NOT CLAIMED / NOT every dep plan module / NOT changing C emit semantics\n"
  -- A34 header only when at least one object line is present.
  let a34Header :=
    if objN == 0 then ""
    else
      "# A34 freestanding-adjacent plan-module object inventory in NATIVE_GRAPH subset\n" ++
      "# NOT freestanding build TCB / NOT Lake lean_lib facet / NOT CLAIMED / NOT every dep plan module / NOT name-table SO\n"
  let header :=
    "# A14 host package link graph subset\n" ++
    "# NOT freestanding build TCB / NOT Lake build graph TCB / NOT Lake lean_lib SO / NOT CLAIMED\n" ++
    a32Header ++
    a35Header ++
    a34Header ++
    s!"package {pkgLabel}\n"
  let modLines := present.foldl (init := "") fun acc (m, rel) =>
    acc ++ s!"module {m} olean {rel}\n"
  let cLines := cs.foldl (init := "") fun acc (m, rel) =>
    acc ++ s!"c_source {m} {rel}\n"
  let objLines := objs.foldl (init := "") fun acc (m, rel) =>
    acc ++ s!"object {m} {rel}\n"
  let edgeBody := edgeLines.foldl (init := "") fun acc e => acc ++ e ++ "\n"
  let soPath := outDir / "libslake_native.so"
  let soLine ← do
    if ← pathIsRegularFile soPath then
      pure "shared_lib .slake-native/libslake_native.so\n"
    else
      pure ""
  -- A21: optional IR SO line (distinct field; does not replace A13 shared_lib).
  let irSoPath := outDir / "libslake_ir.so"
  let irSoLine ← do
    if ← pathIsRegularFile irSoPath then
      pure "shared_lib_ir .slake-native/libslake_ir.so\n"
    else
      pure ""
  -- A22: optional static archive line (distinct; does not replace shared_lib / shared_lib_ir).
  let staticLibPath := outDir / "libslake_ir.a"
  let staticLibLine ← do
    if ← pathIsRegularFile staticLibPath then
      pure "static_lib .slake-native/libslake_ir.a\n"
    else
      pure ""
  -- A23: optional executable line (distinct; does not replace shared_lib / shared_lib_ir / static_lib).
  let exePath := outDir / "slake_ir"
  let exeLine ← do
    if ← pathIsRegularFile exePath then
      -- Prefer non-empty regular file (link success always writes non-empty).
      match ← exePath.metadata.toBaseIO with
      | .ok st =>
        if st.byteSize > 0 then
          pure "executable .slake-native/slake_ir\n"
        else
          pure ""
      | .error _ => pure ""
    else
      pure ""
  let summary := s!"summary modules={present.length} edges={edgeLines.length}\n"
  let body := header ++ modLines ++ cLines ++ objLines ++ edgeBody ++ soLine ++ irSoLine ++ staticLibLine ++ exeLine ++ summary
  let graphPath := outDir / "slake_native_graph"
  try
    IO.FS.writeFile graphPath body
  catch e =>
    IO.eprintln s!"slake build: SLAKE_NATIVE_GRAPH=1 cannot write {graphPath}: {e}"
    return some 1
  IO.println "slake build: SLAKE_NATIVE_GRAPH=1; host package link graph subset after native oleans"
  IO.println "  (not freestanding build TCB / not Lake build graph TCB / not Lake lean_lib SO / not CLAIMED)"
  if pdN > 0 then
    IO.println s!"  (A32 freestanding-adjacent path-dep plan-module nodes in NATIVE_GRAPH subset — {pdN} path-dep module line(s) with package-cwd-relative olean paths; not freestanding build TCB / not Lake build graph TCB / not Lake resolve-deps / not CLAIMED / not every dep plan module / not git/url / not multi-..)"
  if cN > 0 then
    IO.println s!"  (A35 freestanding-adjacent plan-module C source inventory in NATIVE_GRAPH subset — {cN} c_source line(s) with package-cwd-relative .c paths; not freestanding build TCB / not Lake lean_lib facet / not CLAIMED / not every dep plan module / not changing C emit semantics)"
  if objN > 0 then
    IO.println s!"  (A34 freestanding-adjacent plan-module object inventory in NATIVE_GRAPH subset — {objN} object line(s) with package-cwd-relative .o paths; not freestanding build TCB / not Lake lean_lib facet / not CLAIMED / not every dep plan module / not name-table SO)"
  IO.println s!"slake build: native graph OK (.slake-native/slake_native_graph; modules={present.length} edges={edgeLines.length}; package link graph subset — not freestanding build TCB / not Lake build graph TCB / not CLAIMED)"
  return none

/-- A15: host freestanding-adjacent product seal subset after native oleans.

Writes package-local `.slake-native/slake_native_seal` (stable text):

* Header honesty (A15 product seal subset; NOT freestanding build TCB / NOT Lake
  lean_lib SO / NOT Lake build graph TCB / NOT CLAIMED)
* `package <name>`
* `module <Mod> olean_hash <16-hex>` for each plan module with a regular-file
  olean (skip package name / unknown; `isSafeModName` only). Hash = sidecar
  line-1 FNV-1a 64 when present; else FNV-1a 64 of resolved source bytes.
  **A32:** A30-folded path-dep plan modules contribute `olean_hash` from the
  path-dep package sidecar next to the olean, or recompute from path-dep source
  (same FNV-1a 64 path as root modules) — not every dep plan module.
* `module <Mod> c_hash <16-hex>` for each plan module with a regular-file `.c`
  (**A35** freestanding-adjacent plan-module C source inventory; FNV-1a 64 of
  C file bytes via the same `fnv1a64Bytes` helper as olean/graph/obj hashes;
  soft-omit missing/unreadable `.c`; do not fail seal solely for zero C sources).
* `module <Mod> obj_hash <16-hex>` for each plan module with a regular-file `.o`
  (**A34** freestanding-adjacent plan-module object inventory; FNV-1a 64 of
  object file bytes via the same `fnv1a64Bytes` helper as olean/graph hashes;
  soft-omit missing/unreadable `.o`; do not fail seal solely for zero objects).
* `graph_hash <16-hex>` when `.slake-native/slake_native_graph` is a regular file
  (FNV-1a 64 of full graph file bytes)
* `shared_lib .slake-native/libslake_native.so` when that file exists (A13)
* `shared_lib_ir .slake-native/libslake_ir.so` when that file exists (A21 —
  distinct field; does not replace `shared_lib`)
* `static_lib .slake-native/libslake_ir.a` when that file exists (A22 —
  distinct field; does not replace `shared_lib` / `shared_lib_ir`)
* `executable .slake-native/slake_ir` when that file exists (A23 —
  distinct field; does not replace `shared_lib` / `shared_lib_ir` / `static_lib`)
* `seal <16-hex>` — FNV-1a 64 over canonical fold:
  package name + `"\n"` + sorted module lines each `"module M olean_hash H\n"`
  (by module name) + optional sorted `"module M c_hash H\n"` lines (A35; by
  module name) + optional sorted `"module M obj_hash H\n"` lines (A34; by
  module name) + optional `"graph_hash H\n"` + optional
  `"shared_lib .slake-native/libslake_native.so\n"` + optional
  `"shared_lib_ir .slake-native/libslake_ir.so\n"` + optional
  `"static_lib .slake-native/libslake_ir.a\n"` + optional
  `"executable .slake-native/slake_ir\n"`
* `summary modules=N`

**Honesty:** host freestanding-adjacent product seal subset — **not** freestanding
build TCB / **not** Lake lean_lib SO / **not** Lake build graph TCB / **not**
CLAIMED. **A32** freestanding-adjacent path-dep plan-module nodes in NATIVE_SEAL
subset (A30-folded only) — **not** freestanding build TCB / **not** Lake build
graph TCB / **not** Lake resolve-deps / **not** CLAIMED / **not** every dep plan
module / **not** git/url / **not** multi-`..`. **A35** freestanding-adjacent
plan-module C source inventory in NATIVE_SEAL — **not** freestanding build TCB /
**not** Lake lean_lib facet / **not** CLAIMED / **not** every dep plan module /
**not** changing C emit semantics. **A34** freestanding-adjacent
plan-module object inventory in NATIVE_SEAL — **not** freestanding build TCB /
**not** Lake lean_lib facet / **not** CLAIMED / **not** every dep plan module /
**not** name-table SO (A13). Always re-writes when requested
(no mtime skip). Seal write IO failure is always fail-closed. Empty plan modules /
no oleans / cannot hash a present olean: fail-closed under
`SLAKE_NATIVE_SEAL_STRICT=1` or `SLAKE_NATIVE_BUILD=1` (so skip-lake cannot
greenwash empty seal); soft-skip otherwise. Missing path-dep olean for a folded
module: soft path may omit that module line with warn (same incomplete-omit style
as root modules). Missing `.c` soft-omits that c_hash line (no fail solely for
zero C sources). Missing `.o` soft-omits that obj_hash line (no fail solely for
zero objects). A32 header and banner only when at least one path-dep olean_hash
line is present. A35 header and banner only when at least one c_hash line is
present. A34 header and banner only when at least one obj_hash line is
present. -/
def runNativeSeal (pkg : FilePath) (id : Slake.Config.PackageIdentity)
    (ordered : List String) (pathDepMods : List PathDepModuleInfo := [])
    : IO (Option UInt32) := do
  let strict ← envFlagTruthy "SLAKE_NATIVE_SEAL_STRICT"
  let nativeBuild ← envFlagTruthy "SLAKE_NATIVE_BUILD"
  let failClosedEmpty := strict || nativeBuild
  let outDir := nativeOleanOutDir pkg
  try
    IO.FS.createDirAll outDir
  catch e =>
    IO.eprintln s!"slake build: SLAKE_NATIVE_SEAL=1 cannot create {outDir}: {e}"
    return some 1
  let pkgName := id.name
  let mods := ordered.filter fun n =>
    !(pkgName == some n || n == "(unknown)") &&
      Slake.Config.isSafeModName n
  if mods.isEmpty then
    if failClosedEmpty then
      IO.eprintln "slake build: SLAKE_NATIVE_SEAL=1 no plan modules for seal (fail-closed)"
      return some 1
    else
      IO.eprintln "slake build: SLAKE_NATIVE_SEAL=1 warn — no plan modules for seal; skipping"
      return none
  -- A30/A32/A34/A35: reuse caller path-dep inventory (same as A31); fold filter only.
  let rootNodes ← Slake.Config.planNodesIO pkg id
  let pathDepInPlan := pathDepPlanNodes rootNodes ordered pathDepMods
  -- Collect (mod, olean_hash hex) + soft-omitted path-dep mods missing oleans.
  let rec collectHashed (ms : List String) (acc : List (String × String))
      (omittedPd : List String)
      : IO (Option (List (String × String) × List String)) := do
    match ms with
    | [] => pure (some (acc.reverse, omittedPd.reverse))
    | m :: rest =>
      let oleanPath? : Option FilePath ← do
        match pathDepInPlan.find? (fun p => p.mod == m) with
        | some info =>
          if ← pathIsRegularFile info.olean then pure (some info.olean) else pure none
        | none =>
          match moduleOleanRel m with
          | none => pure none
          | some rel =>
            let oleanPath := outDir / rel
            if ← pathIsRegularFile oleanPath then pure (some oleanPath) else pure none
      match oleanPath? with
      | none =>
        let omittedPd' :=
          if pathDepInPlan.any (fun p => p.mod == m) then m :: omittedPd else omittedPd
        collectHashed rest acc omittedPd'
      | some oleanPath =>
          -- Prefer sidecar line-1; else hash resolved source (path-dep or root).
          let sidePath := nativeOleanHashPath oleanPath
          let hex? : Option String ← do
            match ← IO.FS.readFile sidePath |>.toBaseIO with
            | .ok text =>
              match parseNativeOleanSidecar text with
              | some (h, _) => pure (some h)
              | none => pure none
            | .error _ => pure none
          match hex? with
          | some h => collectHashed rest ((m, h) :: acc) omittedPd
          | none =>
            let src? ←
              match pathDepInPlan.find? (fun p => p.mod == m) with
              | some info => pure (some info.src)
              | none => Slake.Config.resolveModulePathFor pkg id m
            match src? with
            | none => pure none
            | some src =>
              match ← nativeOleanSourceHashHex src with
              | none => pure none
              | some h => collectHashed rest ((m, h) :: acc) omittedPd
  match ← collectHashed mods [] [] with
  | none =>
    if failClosedEmpty then
      IO.eprintln "slake build: SLAKE_NATIVE_SEAL=1 cannot hash module source for seal (fail-closed)"
      return some 1
    else
      IO.eprintln "slake build: SLAKE_NATIVE_SEAL=1 warn — cannot hash module source for seal; skipping"
      return none
  | some (present, omittedPd) =>
    if !omittedPd.isEmpty then
      let names := ", ".intercalate omittedPd
      IO.eprintln s!"slake build: SLAKE_NATIVE_SEAL=1 warn — A30-folded path-dep olean missing; omitting module olean_hash line(s): {names}"
    if present.isEmpty then
      if failClosedEmpty then
        IO.eprintln "slake build: SLAKE_NATIVE_SEAL=1 no oleans present for seal (fail-closed)"
        return some 1
      else
        IO.eprintln "slake build: SLAKE_NATIVE_SEAL=1 warn — no oleans present for seal; skipping"
        return none
    let pkgLabel :=
      match pkgName with
      | some n => n
      | none => "(unknown)"
    -- Sorted module lines for stable seal fold + file body (by module name).
    let sorted := present.toArray.qsort (fun a b => a.1 < b.1) |>.toList
    let modLines := sorted.map fun (m, h) => s!"module {m} olean_hash {h}"
    -- A35: plan-module C source inventory hashes (soft-omit missing/unreadable .c).
    let rec collectCHashes (ms : List String) (acc : List (String × String))
        : IO (List (String × String)) := do
      match ms with
      | [] => pure acc.reverse
      | m :: rest =>
        let cAbs? : Option FilePath :=
          match pathDepInPlan.find? (fun p => p.mod == m) with
          | some info => pathDepCAbs info
          | none =>
            match moduleCRel m with
            | none => none
            | some rel => some (outDir / rel)
        match cAbs? with
        | none => collectCHashes rest acc
        | some cAbs =>
          if ← pathIsRegularFile cAbs then
            match ← IO.FS.readBinFile cAbs |>.toBaseIO with
            | .ok data =>
              let h := uInt64ToHex16 (fnv1a64Bytes data)
              collectCHashes rest ((m, h) :: acc)
            | .error _ => collectCHashes rest acc
          else
            collectCHashes rest acc
    let cPresent ← collectCHashes mods []
    let cSorted := cPresent.toArray.qsort (fun a b => a.1 < b.1) |>.toList
    let cLines := cSorted.map fun (m, h) => s!"module {m} c_hash {h}"
    let cN := cLines.length
    -- A34: plan-module object inventory hashes (soft-omit missing/unreadable .o).
    let rec collectObjHashes (ms : List String) (acc : List (String × String))
        : IO (List (String × String)) := do
      match ms with
      | [] => pure acc.reverse
      | m :: rest =>
        let oAbs? : Option FilePath :=
          match pathDepInPlan.find? (fun p => p.mod == m) with
          | some info => pathDepObjAbs info
          | none =>
            match moduleORel m with
            | none => none
            | some rel => some (outDir / rel)
        match oAbs? with
        | none => collectObjHashes rest acc
        | some oAbs =>
          if ← pathIsRegularFile oAbs then
            match ← IO.FS.readBinFile oAbs |>.toBaseIO with
            | .ok data =>
              let h := uInt64ToHex16 (fnv1a64Bytes data)
              collectObjHashes rest ((m, h) :: acc)
            | .error _ => collectObjHashes rest acc
          else
            collectObjHashes rest acc
    let objPresent ← collectObjHashes mods []
    let objSorted := objPresent.toArray.qsort (fun a b => a.1 < b.1) |>.toList
    let objLines := objSorted.map fun (m, h) => s!"module {m} obj_hash {h}"
    let objN := objLines.length
    let graphPath := outDir / "slake_native_graph"
    let graphHashLine? : Option String ← do
      if ← pathIsRegularFile graphPath then
        match ← IO.FS.readBinFile graphPath |>.toBaseIO with
        | .ok data => pure (some s!"graph_hash {uInt64ToHex16 (fnv1a64Bytes data)}")
        | .error _ =>
          -- Graph present but unreadable: fail-closed always (seal integrity).
          pure none
      else
        pure (some "")  -- absent is fine; sentinel empty means no line
    -- Distinguish unreadable graph (none) from absent (some "").
    match graphHashLine? with
    | none =>
      IO.eprintln s!"slake build: SLAKE_NATIVE_SEAL=1 cannot read {graphPath} for graph_hash (fail-closed)"
      return some 1
    | some graphHashLine =>
      let soPath := outDir / "libslake_native.so"
      let soLine ← do
        if ← pathIsRegularFile soPath then
          pure "shared_lib .slake-native/libslake_native.so"
        else
          pure ""
      -- A21: optional IR SO line (distinct; does not replace A13 shared_lib).
      let irSoPath := outDir / "libslake_ir.so"
      let irSoLine ← do
        if ← pathIsRegularFile irSoPath then
          pure "shared_lib_ir .slake-native/libslake_ir.so"
        else
          pure ""
      -- A22: optional static archive line (distinct; does not replace shared_lib / shared_lib_ir).
      let staticLibPath := outDir / "libslake_ir.a"
      let staticLibLine ← do
        if ← pathIsRegularFile staticLibPath then
          pure "static_lib .slake-native/libslake_ir.a"
        else
          pure ""
      -- A23: optional executable line (distinct; does not replace shared_lib / shared_lib_ir / static_lib).
      let exePath := outDir / "slake_ir"
      let exeLine ← do
        if ← pathIsRegularFile exePath then
          match ← exePath.metadata.toBaseIO with
          | .ok st =>
            if st.byteSize > 0 then
              pure "executable .slake-native/slake_ir"
            else
              pure ""
          | .error _ => pure ""
        else
          pure ""
      -- Seal digest: package\n + sorted olean_hash\n + optional sorted c_hash (A35)\n + optional sorted obj_hash (A34)\n + optional graph_hash\n + optional products\n
      let foldAcc0 := fnv1a64FoldString fnv1a64Offset pkgLabel
      let foldAcc1 := fnv1a64FoldString foldAcc0 "\n"
      let foldAcc2 :=
        modLines.foldl (init := foldAcc1) fun acc line =>
          let a1 := fnv1a64FoldString acc line
          fnv1a64FoldString a1 "\n"
      let foldAcc2a :=
        cLines.foldl (init := foldAcc2) fun acc line =>
          let a1 := fnv1a64FoldString acc line
          fnv1a64FoldString a1 "\n"
      let foldAcc2b :=
        objLines.foldl (init := foldAcc2a) fun acc line =>
          let a1 := fnv1a64FoldString acc line
          fnv1a64FoldString a1 "\n"
      let foldAcc3 :=
        if graphHashLine == "" then foldAcc2b
        else
          let a1 := fnv1a64FoldString foldAcc2b graphHashLine
          fnv1a64FoldString a1 "\n"
      let foldAcc4 :=
        if soLine == "" then foldAcc3
        else
          let a1 := fnv1a64FoldString foldAcc3 soLine
          fnv1a64FoldString a1 "\n"
      let foldAcc5 :=
        if irSoLine == "" then foldAcc4
        else
          let a1 := fnv1a64FoldString foldAcc4 irSoLine
          fnv1a64FoldString a1 "\n"
      let foldAcc6 :=
        if staticLibLine == "" then foldAcc5
        else
          let a1 := fnv1a64FoldString foldAcc5 staticLibLine
          fnv1a64FoldString a1 "\n"
      let foldAcc7 :=
        if exeLine == "" then foldAcc6
        else
          let a1 := fnv1a64FoldString foldAcc6 exeLine
          fnv1a64FoldString a1 "\n"
      let sealHex := uInt64ToHex16 foldAcc7
      let pdN : Nat := present.foldl (init := (0 : Nat)) fun n (m, _) =>
        if pathDepInPlan.any (fun p => p.mod == m) then n + 1 else n
      -- A32 header only when at least one path-dep olean_hash line is present.
      let a32Header :=
        if pdN == 0 then ""
        else
          "# A32 freestanding-adjacent path-dep plan-module nodes in NATIVE_SEAL subset (A30-folded only)\n" ++
          "# NOT freestanding build TCB / NOT Lake build graph TCB / NOT Lake resolve-deps / NOT CLAIMED / NOT every dep plan module / NOT git/url / NOT multi-..\n"
      -- A35 header only when at least one c_hash line is present.
      let a35Header :=
        if cN == 0 then ""
        else
          "# A35 freestanding-adjacent plan-module C source inventory in NATIVE_SEAL subset\n" ++
          "# NOT freestanding build TCB / NOT Lake lean_lib facet / NOT CLAIMED / NOT every dep plan module / NOT changing C emit semantics\n"
      -- A34 header only when at least one obj_hash line is present.
      let a34Header :=
        if objN == 0 then ""
        else
          "# A34 freestanding-adjacent plan-module object inventory in NATIVE_SEAL subset\n" ++
          "# NOT freestanding build TCB / NOT Lake lean_lib facet / NOT CLAIMED / NOT every dep plan module / NOT name-table SO\n"
      let header :=
        "# A15 host freestanding-adjacent product seal subset\n" ++
        "# NOT freestanding build TCB / NOT Lake lean_lib SO / NOT Lake build graph TCB / NOT CLAIMED\n" ++
        a32Header ++
        a35Header ++
        a34Header ++
        s!"package {pkgLabel}\n"
      let modBody := modLines.foldl (init := "") fun acc line => acc ++ line ++ "\n"
      let cBody := cLines.foldl (init := "") fun acc line => acc ++ line ++ "\n"
      let objBody := objLines.foldl (init := "") fun acc line => acc ++ line ++ "\n"
      let graphBody := if graphHashLine == "" then "" else graphHashLine ++ "\n"
      let soBody := if soLine == "" then "" else soLine ++ "\n"
      let irSoBody := if irSoLine == "" then "" else irSoLine ++ "\n"
      let staticLibBody := if staticLibLine == "" then "" else staticLibLine ++ "\n"
      let exeBody := if exeLine == "" then "" else exeLine ++ "\n"
      let sealLine := s!"seal {sealHex}\n"
      let summary := s!"summary modules={present.length}\n"
      let body := header ++ modBody ++ cBody ++ objBody ++ graphBody ++ soBody ++ irSoBody ++ staticLibBody ++ exeBody ++ sealLine ++ summary
      let sealPath := outDir / "slake_native_seal"
      try
        IO.FS.writeFile sealPath body
      catch e =>
        IO.eprintln s!"slake build: SLAKE_NATIVE_SEAL=1 cannot write {sealPath}: {e}"
        return some 1
      IO.println "slake build: SLAKE_NATIVE_SEAL=1; host freestanding-adjacent product seal subset after native oleans"
      IO.println "  (not freestanding build TCB / not Lake lean_lib SO / not Lake build graph TCB / not CLAIMED)"
      if pdN > 0 then
        IO.println s!"  (A32 freestanding-adjacent path-dep plan-module nodes in NATIVE_SEAL subset — {pdN} path-dep olean_hash line(s); not freestanding build TCB / not Lake build graph TCB / not Lake resolve-deps / not CLAIMED / not every dep plan module / not git/url / not multi-..)"
      if cN > 0 then
        IO.println s!"  (A35 freestanding-adjacent plan-module C source inventory in NATIVE_SEAL subset — {cN} c_hash line(s); not freestanding build TCB / not Lake lean_lib facet / not CLAIMED / not every dep plan module / not changing C emit semantics)"
      if objN > 0 then
        IO.println s!"  (A34 freestanding-adjacent plan-module object inventory in NATIVE_SEAL subset — {objN} obj_hash line(s); not freestanding build TCB / not Lake lean_lib facet / not CLAIMED / not every dep plan module / not name-table SO)"
      IO.println s!"slake build: native seal OK (.slake-native/slake_native_seal; modules={present.length}; product seal subset — not freestanding build TCB / not Lake lean_lib SO / not Lake build graph TCB / not CLAIMED)"
      return none

/-- Optionally print package-derived DepGraph plan, then optional A7–A23 native
host-lean steps, before lake build.

Triggers plan print when `SLAKE_DEPGRAPH=1` and/or `SLAKE_PLAN_ONLY=1` and/or
`SLAKE_NATIVE_CHECK=1` and/or `SLAKE_NATIVE_OLEAN=1` and/or `SLAKE_NATIVE_BUILD=1`
and/or `SLAKE_NATIVE_C=1` and/or `SLAKE_NATIVE_OBJ=1` and/or `SLAKE_NATIVE_IRLINK=1`
and/or `SLAKE_NATIVE_AR=1` and/or `SLAKE_NATIVE_EXE=1` and/or `SLAKE_NATIVE_LINK=1`
and/or `SLAKE_NATIVE_GRAPH=1` and/or `SLAKE_NATIVE_SEAL=1` (native flags imply plan
so topo order exists; NATIVE_BUILD / NATIVE_C / NATIVE_OBJ / NATIVE_IRLINK /
NATIVE_AR / NATIVE_EXE / NATIVE_LINK / NATIVE_GRAPH / NATIVE_SEAL also imply olean;
NATIVE_OBJ implies NATIVE_C; NATIVE_IRLINK / NATIVE_AR / NATIVE_EXE imply NATIVE_OBJ;
NATIVE_AR / NATIVE_EXE do not imply IRLINK):

* **Package plan** nodes from host `Slake.Config` (`name` + `defaultTargets`, else
  per-lib `roots` / `globs` expand / `lean_lib` names — A16/A24/A25). Module `.lean`
  paths resolve via per-lib or package-level `srcDir` + dotted `Foo/Bar.lean`
  (flat package-root fallback). Globs expand is ones + `.+`/ `.*` **recursive
  multi-level** confining walk (depth-bounded; refuse dir/file symlinks via lstat).
  When those files have top-level imports among plan nodes, freestanding
  `Systems.DepGraph` Kahn on the **import-scan DAG subset**; otherwise
  declaration-order chain (Option C shim). Unlinked host path uses host Kahn /
  declaration labels (PLAN_ONLY / NATIVE_CHECK / NATIVE_OLEAN / NATIVE_BUILD /
  NATIVE_LINK / NATIVE_GRAPH / NATIVE_SEAL still succeed when plan prints;
  DEPGRAPH alone soft-skips freestanding and continues to lake unless PLAN_ONLY /
  NATIVE_*). Not full Lake faceting / full Glob.matches / package imports.
* Node count must be in `1…16` on **both** freestanding and host paths.
* Import-scan Kahn failure (cycle / degree overflow / bounds) is **fail-closed
  exit 1** on both freestanding and host paths (no silent chain fallback when
  edges were present). Empty-edge packages still use declaration-order chain.
* `SLAKE_NATIVE_CHECK=1` → after successful plan, sequential host-lean typecheck
  of plan module nodes (`lean <file>`; skip package name; LEAN_PATH = pkg
  [+srcDir] + A26 path-require roots when present; path-dep oleans precompiled
  first when path requires exist). Soft-skip missing lean/file unless
  `SLAKE_NATIVE_CHECK_STRICT=1`. Nonzero lean → exit nonzero. Thin subset — not
  freestanding build TCB / not olean orchestration / not CLAIMED.
* `SLAKE_NATIVE_OLEAN=1` (or implied by `SLAKE_NATIVE_BUILD=1` /
  `SLAKE_NATIVE_C=1` / `SLAKE_NATIVE_OBJ=1` / `SLAKE_NATIVE_IRLINK=1` /
  `SLAKE_NATIVE_AR=1` / `SLAKE_NATIVE_EXE=1` / `SLAKE_NATIVE_LINK=1` /
  `SLAKE_NATIVE_GRAPH=1` / `SLAKE_NATIVE_SEAL=1`) → after
  successful plan, host-lean compile writing oleans into package-local
  `.slake-native/` and feeding that dir on LEAN_PATH.
  Default `SLAKE_NATIVE_OLEAN_JOBS` unset/`1`/invalid → sequential (one lean at a
  time). Optional `JOBS=N` with `N≥2` → ready-set waves: up to N concurrent host
  `lean -o` among modules whose **direct** plan-import deps finished this run
  (Host never before Core when Host imports Core); empty import-scan edges ⇒ no
  ready-set gating beyond plan-order batches of N. A9: skip when olean mtime is
  fresh unless a plan-node import dep was recompiled/soft-skipped this run, a dep
  olean is newer than this olean (cross-run subset), or
  `SLAKE_NATIVE_OLEAN_FORCE=1`. A10: FNV-1a 64 source content-hash sidecar —
  skip when hash matches even if mtime is newer (touch-without-edit). A11:
  plan-node deps-hash (direct plan-import edges + cascade multi-hop) — before
  mtime/hash skip, every **direct** plan-import dep must be hash-fresh at
  run-start snapshot (olean+sidecar+source); sidecar may carry frozen
  `deps <hex>` (sorted direct plan-import dep names + source hashes); mismatch
  forces rebuild. **A27:** after A26 path-require precompile, consumer modules
  also rebuild when an imported path-dep plan-module olean is mtime-newer than
  self (`path-dep-olean-newer`). **A28:** path-dep import source hashes fold into
  A11 frozen `deps <hex>` (deps-line-stale when path-dep source changes even if
  path-dep olean mtime is not newer). **A30:** package-transitive plan subset —
  import-driven fold of path-dep plan modules into root plan when root plan
  modules import them (oleans still under path-require packages; not Lake
  resolve-deps / not Lake shake TCB / not freestanding build TCB).
  Mtime/hash skip best-effort rewrites self+deps sidecar (heal) so dependents
  reconverge. Soft-skip missing lean/file unless `SLAKE_NATIVE_OLEAN_STRICT=1`
  (soft-skipped deps cascade dependents). Nonzero lean → exit nonzero (drain
  parallel batch). When both NATIVE flags are set, olean compile runs (superset)
  and the thin typecheck is skipped. Not freestanding build TCB / not
  lake-equivalent TCB / not CLAIMED / not full olean graph invalidation / not
  Lake shake/hash TCB / not Lake package-transitive hash / not Lake job server
  TCB.
* `SLAKE_NATIVE_C=1` → implies plan + NATIVE_OLEAN; after olean step, host lean
  C-output emit subset: for each plan module (skip package name) spawn
  `lean -c .slake-native/<ModRel>.c <file>` with same LEAN_PATH as olean. Missing
  lean / missing source soft-skips unless `SLAKE_NATIVE_C_STRICT=1` or combined
  with NATIVE_BUILD (fail-closed). Nonzero lean always fail-closed. Zero C files
  → soft-skip or fail-closed. **Not** freestanding build TCB / **not** Lake
  lean_lib SO of compiled Lean IR / **not** object compile+link of Lean runtime /
  **not** CLAIMED. JOBS applies to olean only.
* `SLAKE_NATIVE_OBJ=1` → implies plan + NATIVE_OLEAN + NATIVE_C; after C emit,
  host object compile of lean C subset: for each plan module (skip package name)
  spawn `cc -c -fPIC -I<leanInclude> -o .slake-native/<ModRel>.o
  .slake-native/<ModRel>.c`. Include via `LEAN_INCLUDE` / `LEAN_SYSROOT` /
  `LEAN_PREFIX` / `lean --print-prefix`. Missing cc / include / C soft-skips
  unless `SLAKE_NATIVE_OBJ_STRICT=1` or NATIVE_BUILD (fail-closed). Nonzero cc
  always fail-closed. Zero `.o` → soft-skip or fail-closed. **Not** freestanding
  build TCB / **not** Lake lean_lib SO / **not** linking Lean runtime into SO /
  **not** CLAIMED. JOBS applies to olean only.
* `SLAKE_NATIVE_LINK=1` → implies plan + NATIVE_OLEAN; after olean step (and after
  NATIVE_C / NATIVE_OBJ / NATIVE_IRLINK / NATIVE_AR / NATIVE_EXE when set), host
  shared-lib link subset: write `.slake-native/slake_native_export.c` exporting
  `slake_native_plan_modules` and `cc -shared -fPIC -o .slake-native/libslake_native.so`.
  Missing `cc` soft-skips unless `SLAKE_NATIVE_LINK_STRICT=1` or combined with
  NATIVE_BUILD (fail-closed). Link failure always fail-closed. **Not** Lake
  lean_lib shared-object / **not** freestanding build TCB / **not** Lake
  shared-lib TCB / **not** IR link of NATIVE_OBJ `.o` files / **not** static
  archive (NATIVE_AR) / **not** executable link (NATIVE_EXE) / **not** CLAIMED.
  JOBS applies to olean only.
* `SLAKE_NATIVE_GRAPH=1` → implies plan + NATIVE_OLEAN; after olean step (and
  after NATIVE_C / NATIVE_OBJ / NATIVE_IRLINK / NATIVE_AR / NATIVE_EXE /
  NATIVE_LINK when set), write `.slake-native/slake_native_graph` — host package
  link graph subset (modules with oleans + A5 edges + optional `shared_lib` +
  optional `shared_lib_ir` + optional `static_lib` + optional `executable`).
  Graph write IO failure always fail-closed. Empty modules / no oleans soft-skip
  unless `SLAKE_NATIVE_GRAPH_STRICT=1` or NATIVE_BUILD. **Not** freestanding
  build TCB / **not** Lake build graph TCB / **not** Lake lean_lib SO / **not**
  CLAIMED.
* `SLAKE_NATIVE_SEAL=1` → implies plan + NATIVE_OLEAN; after olean step (and
  after NATIVE_C / NATIVE_OBJ / NATIVE_IRLINK / NATIVE_AR / NATIVE_EXE /
  NATIVE_LINK / NATIVE_GRAPH when set), write `.slake-native/slake_native_seal` —
  host freestanding-adjacent product seal subset (module olean_hash lines +
  optional graph_hash + optional shared_lib + optional shared_lib_ir + optional
  static_lib + optional executable + seal digest). Seal write IO failure always
  fail-closed. Empty modules / no oleans / cannot hash soft-skip unless
  `SLAKE_NATIVE_SEAL_STRICT=1` or NATIVE_BUILD. **Not** freestanding build TCB /
  **not** Lake lean_lib SO / **not** Lake build graph TCB / **not** CLAIMED.
* `SLAKE_NATIVE_BUILD=1` → implies plan + NATIVE_OLEAN; after **successful** olean
  compile (`compiled + skipped-fresh > 0`, lean present), and after successful
  NATIVE_C / NATIVE_OBJ / NATIVE_IRLINK / NATIVE_AR / NATIVE_EXE / NATIVE_LINK /
  NATIVE_GRAPH / NATIVE_SEAL when those flags are also set, return exit `0` and
  **skip** lake (freestanding-adjacent native olean [+ host lean C-output emit]
  [+ host object compile] [+ host leanc IR shared-lib link] [+ host static
  archive] [+ host leanc executable link] [+ name-table shared-lib link]
  [+ package link graph] [+ product seal] subset; JOBS ready-set waves apply when
  set). On lean nonzero, lean missing, zero modules, other missing-work soft
  paths, or
  NATIVE_C/NATIVE_OBJ/NATIVE_IRLINK/NATIVE_AR/NATIVE_EXE/NATIVE_LINK/NATIVE_GRAPH/NATIVE_SEAL
  fail under NATIVE_BUILD, exit nonzero (fail-closed; no lake fallback; no
  “successful skip lake” banner). Not freestanding build TCB / not Lake TCB /
  not CLAIMED. PLAN_ONLY remains dry-run
  plan(+optional check/olean/c-emit/obj/irlink/ar/exe/link/graph/seal); CLAIMED `build`
  without this flag stays lake-delegated.
* `SLAKE_PLAN_ONLY=1` → after plan (+ optional native check/olean/c-emit/obj/irlink/ar/exe/link/graph/seal),
  return exit `0` and **skip** lake (dry-run / CI plan path — real reduction of
  pure lake cosplay).
* `SLAKE_DEPGRAPH_DEMO=1` + linked → also print legacy demo `C B A` (wire parity).
* Unlinked + `SLAKE_DEPGRAPH=1` without PLAN_ONLY/NATIVE_* → soft-skip warn.
* Default (flags unset) is a no-op.

Honesty: import-scan + srcDir/nested path subset ≠ full Lake import resolution /
module faceting; package plan ≠ freestanding build TCB; native check ≠ freestanding
compile TCB; native olean ≠ freestanding build / lake-equivalent TCB; content-hash
+ plan-node deps-hash sidecar ≠ Lake shake TCB; NATIVE_BUILD ≠ freestanding build
TCB; A12 JOBS ≠ Lake job server TCB; A13 NATIVE_LINK ≠ freestanding build TCB /
Lake shared-lib TCB; A14 NATIVE_GRAPH ≠ freestanding build TCB / Lake build graph
TCB; A15 NATIVE_SEAL ≠ freestanding build TCB / Lake lean_lib SO / Lake build graph
TCB; A16 per-lib roots/srcDir ≠ full Lake faceting / package imports; A24/A25
per-lib globs recursive multi-level subset (ones + `.+` / `.*` depth-bounded walk)
≠ full Lake Glob / faceting / package imports / freestanding build TCB / CLAIMED;
A18 multi-line roots/defaultTargets/globs ≠ full TOML; A19 NATIVE_C ≠ freestanding
build TCB /
Lake lean_lib SO / object compile+link of Lean runtime; A20 NATIVE_OBJ ≠
freestanding build TCB / Lake lean_lib SO / linking Lean runtime into SO;
A21 NATIVE_IRLINK ≠ freestanding build TCB / Lake lean_lib shared-object TCB /
CLAIMED (host leanc IR shared-lib of plan-module objects + Lean runtime via leanc;
A13 remains separate name-table SO); A22 NATIVE_AR ≠ freestanding build TCB /
Lake lean_lib static/shared facet / CLAIMED (host static archive of plan-module
objects via ar rcs; does not imply IRLINK; not linking Lean runtime into archive);
A23 NATIVE_EXE ≠ freestanding build TCB / Lake lean_exe / CLAIMED (host leanc
executable link of plan-module objects + stub main + Lean runtime via leanc;
does not imply IRLINK or AR; generated stub main not Lake lean_exe root).
Smokes: `depgraph_cli_smoke.sh` / `plan_only_smoke.sh` /
`systems_plan_smoke.sh` / `import_dag_smoke.sh` / `srcdir_plan_smoke.sh` /
`native_check_smoke.sh` / `native_olean_smoke.sh` / `native_olean_cache_smoke.sh` /
`native_olean_hash_smoke.sh` / `native_build_smoke.sh` /
`native_olean_deps_hash_smoke.sh` / `native_olean_parallel_smoke.sh` /
`native_link_smoke.sh` / `native_graph_smoke.sh` / `native_seal_smoke.sh` /
`native_c_smoke.sh` / `native_obj_smoke.sh` / `native_irlink_smoke.sh` /
`native_ar_smoke.sh` / `native_exe_smoke.sh` / `roots_plan_smoke.sh` /
`multiline_roots_plan_smoke.sh` / `globs_plan_smoke.sh` /
`require_path_smoke.sh`. -/
def maybePrintDepgraphPlan (pkg : FilePath) (id : Slake.Config.PackageIdentity)
    : IO (Option UInt32) := do
  let useDg ← envFlagTruthy "SLAKE_DEPGRAPH"
  let planOnly ← envFlagTruthy "SLAKE_PLAN_ONLY"
  let wantDemo ← envFlagTruthy "SLAKE_DEPGRAPH_DEMO"
  let nativeCheck ← envFlagTruthy "SLAKE_NATIVE_CHECK"
  let nativeOleanFlag ← envFlagTruthy "SLAKE_NATIVE_OLEAN"
  let nativeBuild ← envFlagTruthy "SLAKE_NATIVE_BUILD"
  let nativeCFlag ← envFlagTruthy "SLAKE_NATIVE_C"
  let nativeObjFlag ← envFlagTruthy "SLAKE_NATIVE_OBJ"
  let nativeIrLink ← envFlagTruthy "SLAKE_NATIVE_IRLINK"
  let nativeAr ← envFlagTruthy "SLAKE_NATIVE_AR"
  let nativeExe ← envFlagTruthy "SLAKE_NATIVE_EXE"
  let nativeLink ← envFlagTruthy "SLAKE_NATIVE_LINK"
  let nativeGraph ← envFlagTruthy "SLAKE_NATIVE_GRAPH"
  let nativeSeal ← envFlagTruthy "SLAKE_NATIVE_SEAL"
  -- NATIVE_IRLINK / NATIVE_AR / NATIVE_EXE imply NATIVE_OBJ (need .o); NATIVE_OBJ implies NATIVE_C.
  -- NATIVE_AR / NATIVE_EXE do NOT imply IRLINK.
  let nativeObj := nativeObjFlag || nativeIrLink || nativeAr || nativeExe
  let nativeC := nativeCFlag || nativeObj
  -- NATIVE_BUILD / NATIVE_C / NATIVE_OBJ / NATIVE_IRLINK / NATIVE_AR / NATIVE_EXE / NATIVE_LINK / NATIVE_GRAPH / NATIVE_SEAL imply plan + NATIVE_OLEAN.
  let nativeOlean :=
    nativeOleanFlag || nativeBuild || nativeC || nativeObj || nativeIrLink || nativeAr || nativeExe || nativeLink || nativeGraph || nativeSeal
  -- NATIVE_CHECK / NATIVE_OLEAN / NATIVE_BUILD / NATIVE_C / NATIVE_OBJ / NATIVE_IRLINK / NATIVE_AR / NATIVE_EXE / NATIVE_LINK / NATIVE_GRAPH / NATIVE_SEAL
  -- imply plan print.
  if !useDg && !planOnly && !nativeCheck && !nativeOlean then
    return none
  -- planNodesIO expands A24/A25 per-lib globs; A30 folds imported path-dep plan modules.
  let (nodes, pathDepMods, planTrunc) ← planNodesExpandedIO pkg id
  let extraSrc := pathDepExtraSrc pathDepMods
  let rootOnly ← Slake.Config.planNodesIO pkg id
  let transitivePlan := nodes.length > rootOnly.length
  if planTrunc then
    -- Fail-closed under NATIVE_BUILD / OLEAN_STRICT (A26 require-cap style).
    let strict ← envFlagTruthy "SLAKE_NATIVE_OLEAN_STRICT"
    let nativeBuild ← envFlagTruthy "SLAKE_NATIVE_BUILD"
    match ← reportPlanExpandTruncated (strict || nativeBuild) with
    | some code => return some code
    | none => pure ()
  let linked := slakeFsDepgraphLinked ()
  let ordered? : Option (List String) ← do
    if linked == 1 then
      match ← printFsPackagePlan pkg id nodes extraSrc transitivePlan with
      | none => pure none
      | some ordered =>
        if wantDemo then
          IO.println "slake build: SLAKE_DEPGRAPH_DEMO=1; freestanding DepGraph Kahn topo (demo C→B→A)"
          IO.println "  (demo multi-module graph; not package lakefile parse — residual honesty)"
          let st := slakeFsDepgraphPrintPlan ()
          if st != 0 then
            IO.eprintln "slake build: freestanding DepGraph demo plan failed"
            pure none
          else
            pure (some ordered)
        else
          pure (some ordered)
    else
      if useDg then
        IO.eprintln "slake build: SLAKE_DEPGRAPH=1 but DEPGRAPH shim not linked; skipping freestanding plan"
      -- Host plan when PLAN_ONLY or NATIVE_* needs topo order; DEPGRAPH-alone soft-skips.
      if planOnly || nativeCheck || nativeOlean then
        printHostPackagePlan pkg id nodes extraSrc transitivePlan
      else
        pure none
  match ordered? with
  | none =>
    -- Hard fail if we attempted a plan print path that requires success.
    if linked == 1 || planOnly || nativeCheck || nativeOlean then
      return some 1
    -- Unlinked DEPGRAPH-only soft-skip: continue to lake without plan.
    return none
  | some ordered =>
    -- Prefer olean compile when set (multi-module host-lean olean honesty superset).
    if nativeOlean then
      if nativeBuild then
        let jobs ← parseNativeOleanJobs
        if jobs <= 1 then
          IO.println "slake build: SLAKE_NATIVE_BUILD=1; freestanding-adjacent sequential native olean build subset (implies NATIVE_OLEAN; skip lake on success — not freestanding build TCB / not Lake TCB / not CLAIMED)"
        else
          IO.println s!"slake build: SLAKE_NATIVE_BUILD=1; freestanding-adjacent native olean build subset (implies NATIVE_OLEAN; JOBS={jobs} ready-set waves; skip lake on success — not freestanding build TCB / not Lake TCB / not CLAIMED)"
      if nativeC then
        IO.println "slake build: SLAKE_NATIVE_C=1; host lean C-output emit subset after oleans (implies NATIVE_OLEAN — not freestanding build TCB / not Lake lean_lib SO / not CLAIMED)"
      if nativeObj then
        IO.println "slake build: SLAKE_NATIVE_OBJ=1; host object compile of lean C subset after C emit (implies NATIVE_OLEAN + NATIVE_C — not freestanding build TCB / not Lake lean_lib SO / not CLAIMED)"
      if nativeIrLink then
        IO.println "slake build: SLAKE_NATIVE_IRLINK=1; host leanc IR shared-lib link subset of plan-module objects + Lean runtime via leanc (implies NATIVE_OLEAN + NATIVE_C + NATIVE_OBJ — not freestanding build TCB / not Lake lean_lib shared-object TCB / not CLAIMED)"
      if nativeAr then
        IO.println "slake build: SLAKE_NATIVE_AR=1; host static archive of plan-module objects subset via ar rcs (implies NATIVE_OLEAN + NATIVE_C + NATIVE_OBJ — not freestanding build TCB / not Lake lean_lib static/shared facet / not CLAIMED / not linking Lean runtime into the archive)"
      if nativeExe then
        IO.println "slake build: SLAKE_NATIVE_EXE=1; host leanc executable link subset of plan-module objects + stub main + Lean runtime via leanc (implies NATIVE_OLEAN + NATIVE_C + NATIVE_OBJ — not freestanding build TCB / not Lake lean_exe / not CLAIMED / generated stub main not Lake lean_exe root)"
      if nativeLink then
        IO.println "slake build: SLAKE_NATIVE_LINK=1; host shared-lib link subset after oleans (implies NATIVE_OLEAN — not freestanding build TCB / not Lake shared-lib TCB / not CLAIMED)"
      if nativeGraph then
        IO.println "slake build: SLAKE_NATIVE_GRAPH=1; host package link graph subset after oleans (implies NATIVE_OLEAN — not freestanding build TCB / not Lake build graph TCB / not CLAIMED)"
      if nativeSeal then
        IO.println "slake build: SLAKE_NATIVE_SEAL=1; host freestanding-adjacent product seal subset after oleans (implies NATIVE_OLEAN — not freestanding build TCB / not Lake lean_lib SO / not Lake build graph TCB / not CLAIMED)"
      match ← runNativeOleanCompile pkg id ordered with
      | some code => return some code
      | none =>
        -- A30: path-dep plan nodes live under path-require packages (oleans under dep/.slake-native/).
        -- A31: path-dep C/OBJ also under dep/.slake-native/; root C/OBJ under root outDir;
        -- IRLINK/AR/EXE collect combined objs in expanded-plan topo order (path-dep before root when Dep≺App).
        -- Only A30-folded names (pathDepPlanNodes); root modules sharing a flat label stay root-local.
        let pdPlan := pathDepPlanNodes rootOnly ordered pathDepMods
        let rootOrdered := ordered.filter fun n => !(pdPlan.any (fun p => p.mod == n))
        -- Order: olean → path-dep C → root C → path-dep OBJ → root OBJ → IRLINK → AR → EXE → LINK → GRAPH → SEAL.
        if nativeC then
          match ← runNativePathDepCEmit ordered pdPlan with
          | some code => return some code
          | none => pure ()
          match ← runNativeCEmit pkg id rootOrdered with
          | some code => return some code
          | none => pure ()
        if nativeObj then
          match ← runNativePathDepObjCompile ordered pdPlan with
          | some code => return some code
          | none => pure ()
          match ← runNativeObjCompile pkg id rootOrdered with
          | some code => return some code
          | none => pure ()
        if nativeIrLink then
          match ← runNativeIrLink pkg id ordered pdPlan with
          | some code => return some code
          | none => pure ()
        if nativeAr then
          match ← runNativeAr pkg id ordered pdPlan with
          | some code => return some code
          | none => pure ()
        if nativeExe then
          match ← runNativeExe pkg id ordered pdPlan with
          | some code => return some code
          | none => pure ()
        if nativeLink then
          -- A13 name-table SO: still root plan names only (existing A30 filter; no new A13 semantics).
          match ← runNativeLink pkg id rootOrdered with
          | some code => return some code
          | none => pure ()
        if nativeGraph then
          match ← runNativeGraph pkg id ordered pathDepMods with
          | some code => return some code
          | none => pure ()
        if nativeSeal then
          match ← runNativeSeal pkg id ordered pathDepMods with
          | some code => return some code
          | none => pure ()
    else if nativeCheck then
      -- A26: path-require olean precompile before typecheck so `import Dep` works.
      if Slake.Config.hasPathRequires id then
        let strict ← envFlagTruthy "SLAKE_NATIVE_CHECK_STRICT"
        match ← runPathRequireNativeOleens pkg id pathRequireMaxDepth strict with
        | some code => return some code
        | none => pure ()
      let pdPlan := pathDepPlanNodes rootOnly ordered pathDepMods
      let rootOrdered := ordered.filter fun n => !(pdPlan.any (fun p => p.mod == n))
      match ← runNativeTypecheck pkg id rootOrdered with
      | some code => return some code
      | none => pure ()
    if planOnly || nativeBuild then
      if nativeBuild && !planOnly then
        -- Dynamic banner preserves exact grepped strings when NATIVE_C/OBJ is off;
        -- with NATIVE_C inserts "host lean C-output emit"; with NATIVE_OBJ inserts
        -- "host object compile" after C emit; with NATIVE_IRLINK inserts
        -- "host leanc IR shared-lib link" after obj; with NATIVE_AR inserts
        -- "host static archive" after IRLINK; with NATIVE_EXE inserts
        -- "host leanc executable link" after AR (or earlier when AR off).
        let parts0 : List String := ["successful native olean compile"]
        let parts1 := if nativeC then parts0 ++ ["host lean C-output emit"] else parts0
        let parts2 := if nativeObj then parts1 ++ ["host object compile"] else parts1
        let parts2b := if nativeIrLink then parts2 ++ ["host leanc IR shared-lib link"] else parts2
        let parts2c := if nativeAr then parts2b ++ ["host static archive"] else parts2b
        let parts2d := if nativeExe then parts2c ++ ["host leanc executable link"] else parts2c
        let parts3 := if nativeLink then parts2d ++ ["host shared-lib link"] else parts2d
        let parts4 := if nativeGraph then parts3 ++ ["package link graph"] else parts3
        let parts5 := if nativeSeal then parts4 ++ ["product seal"] else parts4
        IO.println s!"slake build: SLAKE_NATIVE_BUILD=1; skipping lake after {" + ".intercalate parts5}"
      else if planOnly && linked == 1 then
        IO.println "slake build: SLAKE_PLAN_ONLY=1; skipping lake after package plan"
      else if planOnly then
        IO.println "slake build: SLAKE_PLAN_ONLY=1; skipping lake (host plan only)"
      return some 0
    return none

/-- `build`: classic-host MVP — delegate to `lake build` in the package dir.

Default: `IO.Process` → `lake build` (parity green without extract).
With `SLAKE_USE_FS_PROC_PIPE=1`: freestanding pipe/stdio `Systems.Proc` (stdout
capture demo; takes precedence over multi-arg when both set).
With `SLAKE_USE_FS_PROC=1`: freestanding multi-arg `Systems.Proc` via linked
shim (`slake_fs_proc.c` + extract bundle; remaining argv after `build` plumbed). On **spawn** fail only, fall back to
`IO.Process` unless `SLAKE_FS_PROC_STRICT=1`. Wait fail / lake exit never
retries via IO.Process. With `SLAKE_DEPGRAPH=1`: print package-derived freestanding
DepGraph plan first (import-scan DAG subset when edges exist, else declaration-order
chain; then lake). With `SLAKE_PLAN_ONLY=1`: print plan and skip lake (exit 0).
With `SLAKE_NATIVE_CHECK=1`: plan (implied) + sequential host-lean typecheck of
plan modules, then lake unless PLAN_ONLY. With `SLAKE_NATIVE_OLEAN=1`: plan
(implied) + sequential multi-module host-lean compile writing oleans into
package-local `.slake-native/` + LEAN_PATH feed (A9 mtime + plan-edge cascade;
A10 FNV-1a 64 source content-hash sidecar; FORCE rebuilds all), then lake unless
PLAN_ONLY. With `SLAKE_NATIVE_BUILD=1`: plan + NATIVE_OLEAN, skip lake on success
(fail-closed on compile fail) — freestanding-adjacent sequential native olean
build subset (not CLAIMED / not freestanding build TCB / not Lake TCB). With
`SLAKE_NATIVE_C=1`: plan + NATIVE_OLEAN + host lean C-output emit subset
(`.slake-native/<ModRel>.c` via `lean -c`; not freestanding build TCB / not Lake
lean_lib SO / not CLAIMED); with NATIVE_BUILD, skip-lake requires C emit success.
With `SLAKE_NATIVE_OBJ=1`: plan + NATIVE_OLEAN + NATIVE_C + host object compile of
lean C subset (`.slake-native/<ModRel>.o` via `cc -c -fPIC -I<leanInclude>`; not
freestanding build TCB / not Lake lean_lib SO / not linking Lean runtime into SO /
not CLAIMED); with NATIVE_BUILD, skip-lake requires object compile success. With
`SLAKE_NATIVE_IRLINK=1`: plan + NATIVE_OLEAN + NATIVE_C + NATIVE_OBJ + host leanc
IR shared-lib link subset (`.slake-native/libslake_ir.so` via `leanc -shared`; not
freestanding build TCB / not Lake lean_lib shared-object TCB / not CLAIMED); with
NATIVE_BUILD, skip-lake requires IR link success. With `SLAKE_NATIVE_AR=1`: plan +
NATIVE_OLEAN + NATIVE_C + NATIVE_OBJ + host static archive of plan-module objects
(`.slake-native/libslake_ir.a` via `ar rcs`; does not imply IRLINK; not freestanding
build TCB / not Lake lean_lib static/shared facet / not CLAIMED / not linking Lean
runtime into the archive); with NATIVE_BUILD, skip-lake requires archive success.
With `SLAKE_NATIVE_EXE=1`: plan + NATIVE_OLEAN + NATIVE_C + NATIVE_OBJ + host leanc
executable link of plan-module objects + stub main + Lean runtime via leanc
(`.slake-native/slake_ir` via `leanc -o` + generated stub main; does not imply
IRLINK or AR; not freestanding build TCB / not Lake lean_exe / not CLAIMED);
with NATIVE_BUILD, skip-lake requires executable link success.
With `SLAKE_NATIVE_LINK=1`: plan + NATIVE_OLEAN + host shared-lib link subset
(`.slake-native/libslake_native.so`; not Lake lean_lib shared-object / not
freestanding build TCB / not Lake shared-lib TCB / not IR link of NATIVE_OBJ `.o` /
not CLAIMED); with NATIVE_BUILD, skip-lake requires link success when both set.
With `SLAKE_NATIVE_GRAPH=1`: plan + NATIVE_OLEAN + host package link graph subset
(`.slake-native/slake_native_graph`; not freestanding build TCB / not Lake build
graph TCB / not CLAIMED); with NATIVE_BUILD, skip-lake requires graph write. With
`SLAKE_NATIVE_SEAL=1`: plan + NATIVE_OLEAN + host freestanding-adjacent product
seal subset (`.slake-native/slake_native_seal`; not freestanding build TCB / not
Lake lean_lib SO / not Lake build graph TCB / not CLAIMED); with NATIVE_BUILD,
skip-lake requires seal write. Order: olean → C emit → obj → IR link → static
archive → executable link → name-table link → graph → seal.
**Not** full Lake parity; plan ≠ freestanding build TCB; native check/olean/build/c-emit/obj/irlink/ar/exe/link/graph/seal ≠
freestanding compile / not CLAIMED / not lake-equivalent TCB / not Lake shake/hash
TCB. -/
public def cmdBuild (rest : List String := []) : IO UInt32 := do
  let cwd ← IO.currentDir
  let pkg ← match ← findPackageDir cwd with
    | some p => pure p
    | none =>
      IO.eprintln "slake build: no package root found (plausible lakefile walk-up)"
      return 1
  let id ← Slake.Config.readPackageIdentity pkg
  IO.println s!"slake build: {Slake.Config.formatIdentity id}"
  match ← maybePrintDepgraphPlan pkg id with
  | some code => return code
  | none => pure ()
  let lake ← lakeCmd
  let usePipe ← envFlagTruthy "SLAKE_USE_FS_PROC_PIPE"
  let useFs ← envFlagTruthy "SLAKE_USE_FS_PROC"
  let strict ← envFlagTruthy "SLAKE_FS_PROC_STRICT"
  if !usePipe && !useFs then
    return (← cmdBuildIoProcess pkg lake rest)
  let linked := slakeFsProcLinked ()
  let pipeLinked := slakeFsProcPipeLinked ()
  let wantPipe := usePipe
  let pathLinked := if wantPipe then pipeLinked else linked
  let pathName := if wantPipe then "FS_PROC_PIPE" else "FS_PROC"
  if pathLinked != 1 then
    if strict then
      IO.eprintln s!"slake build: SLAKE_USE_{pathName}=1 + STRICT but {pathName} shim not linked"
      return 1
    IO.eprintln s!"slake build: SLAKE_USE_{pathName}=1 but {pathName} shim not linked; falling back"
    return (← cmdBuildIoProcess pkg lake rest)
  match ← resolveLakeAbs with
  | none =>
    IO.eprintln s!"slake build: cannot resolve absolute lake path for {pathName} (set LAKE=/abs/path)"
    if strict then
      IO.eprintln "slake build: SLAKE_FS_PROC_STRICT=1; not falling back"
      return 1
    IO.eprintln "slake build: falling back to IO.Process"
    return (← cmdBuildIoProcess pkg lake rest)
  | some lakeAbs =>
    let code ← if wantPipe then cmdBuildFsProcPipe pkg lakeAbs rest else cmdBuildFsProc pkg lakeAbs rest
    if code == fsSpawnFail then
      if strict then
        IO.eprintln s!"slake build: SLAKE_FS_PROC_STRICT=1; not falling back after {pathName} spawn fail"
        return 1
      IO.eprintln s!"slake build: falling back to IO.Process after {pathName} spawn fail"
      return (← cmdBuildIoProcess pkg lake rest)
    if code == fsWaitFail then
      -- Wait fail is not spawn fail: do not double-run lake via IO.Process.
      IO.eprintln s!"slake build: {pathName} wait fail (no IO.Process fall back)"
      return 1
    return code

/-- Dispatch one command token without IO side effects (help/version/unknown).

For `build`/`clean`/`env` this returns a short note; real work is in `run`. -/
public def dispatch (cmd : String) : CmdResult :=
  if cmd == "build" then
    .ok 0 "slake build: classic host driver (use run for lake delegate)"
  else if cmd == "clean" then
    .ok 0 "slake clean: classic host driver (use run for native or FS_PROC lake clean)"
  else if cmd == "test" then
    .ok 0 "slake test: classic host driver (use run for lake test delegate)"
  else if cmd == "script" then
    .ok 0 "slake script: classic host driver (use run for lake script delegate)"
  else if cmd == "exe" then
    .ok 0 "slake exe: classic host driver (use run for lake exe delegate)"
  else if cmd == "lint" then
    .ok 0 "slake lint: classic host driver (use run for lake lint delegate)"
  else if cmd == "check-build" then
    .ok 0 "slake check-build: classic host dual residual (optional FS_PROC/PIPE)"
  else if cmd == "check-test" then
    .ok 0 "slake check-test: classic host dual residual (optional FS_PROC/PIPE)"
  else if cmd == "check-lint" then
    .ok 0 "slake check-lint: classic host dual residual (optional FS_PROC/PIPE)"
  else if cmd == "query" then
    .ok 0 "slake query: classic host driver (use run for lake query delegate)"
  else if cmd == "shake" then
    .ok 0 "slake shake: classic host driver (use run for lake shake delegate)"
  else if cmd == "update" then
    .ok 0 "slake update: classic host driver (use run for lake update delegate)"
  else if cmd == "pack" then
    .ok 0 "slake pack: classic host driver (use run for lake pack delegate)"
  else if cmd == "unpack" then
    .ok 0 "slake unpack: classic host driver (use run for lake unpack delegate)"
  else if cmd == "cache" then
    .ok 0 "slake cache: classic host driver (use run for lake cache delegate)"
  else if cmd == "lean" then
    .ok 0 "slake lean: classic host dual residual (optional FS_PROC/PIPE)"
  else if cmd == "scripts" then
    .ok 0 "slake scripts: classic host driver (use run for lake scripts delegate)"
  else if cmd == "new" then
    .ok 0 "slake new: classic host dual residual (optional FS_PROC/PIPE; cwd bootstrap)"
  else if cmd == "init" then
    .ok 0 "slake init: classic host dual residual (optional FS_PROC/PIPE; cwd bootstrap)"
  else if cmd == "serve" then
    .ok 0 "slake serve: classic host dual residual (use run for lake serve delegate)"
  else if cmd == "upload" then
    .ok 0 "slake upload: classic host dual residual (optional FS_PROC/PIPE)"
  else if cmd == "translate-config" then
    .ok 0 "slake translate-config: classic host dual residual (optional FS_PROC/PIPE)"
  else if cmd == "run" then
    .ok 0 "slake run: classic host dual residual (optional FS_PROC/PIPE)"
  else if cmd == "setup-file" then
    .ok 0 "slake setup-file: classic host dual residual (optional FS_PROC/PIPE)"
  else if cmd == "self-check" then
    .ok 0 "slake self-check: classic host dual residual (optional FS_PROC/PIPE)"
  else if cmd == "version-tags" then
    .ok 0 "slake version-tags: classic host dual residual (optional FS_PROC/PIPE)"
  else if cmd == "query-kind" then
    .ok 0 "slake query-kind: classic host dual residual (optional FS_PROC/PIPE)"
  else if cmd == "resolve-deps" then
    .ok 0 "slake resolve-deps: classic host dual residual (optional FS_PROC/PIPE)"
  else if cmd == "reservoir-config" then
    .ok 0 "slake reservoir-config: classic host dual residual (optional FS_PROC/PIPE)"
  else if cmd == "exec" then
    .ok 0 "slake exec: classic host dual residual (optional FS_PROC/PIPE)"
  else if cmd == "upgrade" then
    .ok 0 "slake upgrade: classic host dual residual (optional FS_PROC/PIPE)"
  else if cmd == "env" then
    .ok 0 "slake env: classic host driver (use run for live env print)"
  else if cmd == "--help" || cmd == "help" || cmd == "-h" then
    .ok 0 usage
  else if cmd == "--version" || cmd == "version" || cmd == "-V" then
    .ok 0 versionString
  else
    .err 1 s!"unknown command: {cmd}\n{usage}"


/-- Classic `IO.Process` → `lake setup-file` in package dir (W82 parity growth base; W102 dual residual).

Requires package root (real `lake setup-file` runs against package toolchain/config). -/
def cmdSetupFileIoProcess (pkg : FilePath) (lake : String) (rest : List String := []) : IO UInt32 := do
  cmdLakeForwardIoProcess "setup-file" pkg lake "setup-file" rest

/-- Freestanding Proc multi-arg path (`lake --dir=<pkg> setup-file [rest…]`).
Child env is **empty** (freestanding `execve` honesty — not a host-env clone).
Driver **chdir(pkg)** around spawn so relative path args match classic `cwd=pkg`
(freestanding spawn API has no cwd parameter; pack/cache/unpack/query/shake/serve/upload/lean/scripts/setup-file alignment).
Returns process exit `0…255`, `fsSpawnFail`, or `fsWaitFail`. W102 FS_PROC setup-file.
Outside CLAIMED; rest argv plumbed like pack/cache/unpack/query/shake/serve/upload/lean/scripts (**not** empty-rest-only —
only `clean` is empty-rest-only). Rest may still rebind Lake globals (`--dir`/`-d`/etc.). -/
def cmdSetupFileFsProc (pkg : FilePath) (lakeAbs : String) (rest : List String := []) : IO UInt32 := do
  let restArr := rest.toArray
  let shown := " ".intercalate ("setup-file" :: rest)
  IO.println s!"slake setup-file: SLAKE_USE_FS_PROC=1; freestanding Systems.Proc multi-arg"
  IO.println s!"  lake={lakeAbs} --dir={pkg} {shown}"
  IO.println "  (empty child env — residual honesty dual path)"
  IO.println "  (setup-file FS_PROC chdir to package root for relative path parity with classic cwd=pkg)"
  let code := slakeFsRunLakeSetupFile pkg.toString lakeAbs restArr
  if code == fsSpawnFail then
    IO.eprintln "slake setup-file: freestanding Proc spawn failed"
    return code
  if code == fsWaitFail then
    IO.eprintln "slake setup-file: freestanding Proc wait failed"
    return code
  if code == 0 then
    IO.println "slake setup-file: OK (via lake / Systems.Proc)"
  else
    IO.eprintln s!"slake setup-file: lake exited {code} (Systems.Proc)"
  return code

/-- Freestanding Proc **pipe** path for `lake setup-file` (stdout capture demo). W102.
Same chdir(pkg) relative-path parity as multi-arg setup-file FS_PROC.
Rest plumbed (**not** empty-rest-only); rest may rebind Lake globals; CLAIMED unchanged. -/
def cmdSetupFileFsProcPipe (pkg : FilePath) (lakeAbs : String) (rest : List String := []) : IO UInt32 := do
  let restArr := rest.toArray
  let shown := " ".intercalate ("setup-file" :: rest)
  IO.println s!"slake setup-file: SLAKE_USE_FS_PROC_PIPE=1; freestanding Systems.Proc pipe/stdio"
  IO.println s!"  lake={lakeAbs} --dir={pkg} {shown}"
  IO.println "  (empty child env — residual honesty dual path)"
  IO.println "  (setup-file FS_PROC_PIPE chdir to package root for relative path parity with classic cwd=pkg)"
  let code := slakeFsRunLakeSetupFilePipe pkg.toString lakeAbs restArr
  if code == fsSpawnFail then
    IO.eprintln "slake setup-file: freestanding Proc pipe spawn failed"
    return code
  if code == fsWaitFail then
    IO.eprintln "slake setup-file: freestanding Proc pipe wait failed"
    return code
  if code == 0 then
    IO.println "slake setup-file: OK (via lake / Systems.Proc pipe)"
  else
    IO.eprintln s!"slake setup-file: lake exited {code} (Systems.Proc pipe)"
  return code

/-- `setup-file`: classic-host MVP — delegate to `lake setup-file` in the package dir.

Default: `IO.Process` → `lake setup-file` with `cwd=pkg` (parity green without extract).
Optional FS_PROC/PIPE (W102): freestanding empty child env; rest plumbed (**not** empty-rest-only —
only `clean` is); rest may rebind Lake globals (`--dir`/`-d`/etc.); chdir(pkg);
resolveLakeAbs **before** chdir. Outside CLAIMED. STRICT: no IO.Process fall-back.
CLAIMED envelope stays `(build clean env test)` — setup-file is residual honesty dual path only. -/
public def cmdSetupFile (rest : List String := []) : IO UInt32 := do
  let cwd ← IO.currentDir
  let pkg ← match ← findPackageDir cwd with
    | some p => pure p
    | none =>
      IO.eprintln "slake setup-file: no package root found (plausible lakefile walk-up)"
      return 1
  let lake ← lakeCmd
  let usePipe ← envFlagTruthy "SLAKE_USE_FS_PROC_PIPE"
  let useFs ← envFlagTruthy "SLAKE_USE_FS_PROC"
  let strict ← envFlagTruthy "SLAKE_FS_PROC_STRICT"
  if !usePipe && !useFs then
    return (← cmdSetupFileIoProcess pkg lake rest)
  let linked := slakeFsProcLinked ()
  let pipeLinked := slakeFsProcPipeLinked ()
  let wantPipe := usePipe
  let pathLinked := if wantPipe then pipeLinked else linked
  let pathName := if wantPipe then "FS_PROC_PIPE" else "FS_PROC"
  if pathLinked != 1 then
    if strict then
      IO.eprintln s!"slake setup-file: SLAKE_USE_{pathName}=1 + STRICT but {pathName} shim not linked"
      return 1
    IO.eprintln s!"slake setup-file: SLAKE_USE_{pathName}=1 but {pathName} shim not linked; falling back"
    return (← cmdSetupFileIoProcess pkg lake rest)
  match ← resolveLakeAbs with
  | none =>
    IO.eprintln s!"slake setup-file: cannot resolve absolute lake path for {pathName} (set LAKE=/abs/path)"
    if strict then
      IO.eprintln "slake setup-file: SLAKE_FS_PROC_STRICT=1; not falling back"
      return 1
    IO.eprintln "slake setup-file: falling back to IO.Process"
    return (← cmdSetupFileIoProcess pkg lake rest)
  | some lakeAbs =>
    let code ← if wantPipe then cmdSetupFileFsProcPipe pkg lakeAbs rest else cmdSetupFileFsProc pkg lakeAbs rest
    if code == fsSpawnFail then
      if strict then
        IO.eprintln s!"slake setup-file: SLAKE_FS_PROC_STRICT=1; not falling back after {pathName} spawn fail"
        return 1
      IO.eprintln s!"slake setup-file: falling back to IO.Process after {pathName} spawn fail"
      return (← cmdSetupFileIoProcess pkg lake rest)
    if code == fsWaitFail then
      IO.eprintln s!"slake setup-file: {pathName} wait fail (no IO.Process fall back)"
      return 1
    return code


/-- Classic `IO.Process` → `lake self-check` in package dir (W82 parity growth base; W103 dual residual).

Requires package root (real `lake self-check` runs against package toolchain/config). -/
def cmdSelfCheckIoProcess (pkg : FilePath) (lake : String) (rest : List String := []) : IO UInt32 := do
  cmdLakeForwardIoProcess "self-check" pkg lake "self-check" rest

/-- Freestanding Proc multi-arg path (`lake --dir=<pkg> self-check [rest…]`).
Child env is **empty** (freestanding `execve` honesty — not a host-env clone).
Driver **chdir(pkg)** around spawn so relative path args match classic `cwd=pkg`
(freestanding spawn API has no cwd parameter; pack/cache/unpack/query/shake/serve/upload/lean/scripts/setup-file alignment).
Returns process exit `0…255`, `fsSpawnFail`, or `fsWaitFail`. W103 FS_PROC self-check.
Outside CLAIMED; rest argv plumbed like pack/cache/unpack/query/shake/serve/upload/lean/scripts/setup-file (**not** empty-rest-only —
only `clean` is empty-rest-only). Rest may still rebind Lake globals (`--dir`/`-d`/etc.). -/
def cmdSelfCheckFsProc (pkg : FilePath) (lakeAbs : String) (rest : List String := []) : IO UInt32 := do
  let restArr := rest.toArray
  let shown := " ".intercalate ("self-check" :: rest)
  IO.println s!"slake self-check: SLAKE_USE_FS_PROC=1; freestanding Systems.Proc multi-arg"
  IO.println s!"  lake={lakeAbs} --dir={pkg} {shown}"
  IO.println "  (empty child env — residual honesty dual path)"
  IO.println "  (self-check FS_PROC chdir to package root for relative path parity with classic cwd=pkg)"
  let code := slakeFsRunLakeSelfCheck pkg.toString lakeAbs restArr
  if code == fsSpawnFail then
    IO.eprintln "slake self-check: freestanding Proc spawn failed"
    return code
  if code == fsWaitFail then
    IO.eprintln "slake self-check: freestanding Proc wait failed"
    return code
  if code == 0 then
    IO.println "slake self-check: OK (via lake / Systems.Proc)"
  else
    IO.eprintln s!"slake self-check: lake exited {code} (Systems.Proc)"
  return code

/-- Freestanding Proc **pipe** path for `lake self-check` (stdout capture demo). W103.
Same chdir(pkg) relative-path parity as multi-arg self-check FS_PROC.
Rest plumbed (**not** empty-rest-only); rest may rebind Lake globals; CLAIMED unchanged. -/
def cmdSelfCheckFsProcPipe (pkg : FilePath) (lakeAbs : String) (rest : List String := []) : IO UInt32 := do
  let restArr := rest.toArray
  let shown := " ".intercalate ("self-check" :: rest)
  IO.println s!"slake self-check: SLAKE_USE_FS_PROC_PIPE=1; freestanding Systems.Proc pipe/stdio"
  IO.println s!"  lake={lakeAbs} --dir={pkg} {shown}"
  IO.println "  (empty child env — residual honesty dual path)"
  IO.println "  (self-check FS_PROC_PIPE chdir to package root for relative path parity with classic cwd=pkg)"
  let code := slakeFsRunLakeSelfCheckPipe pkg.toString lakeAbs restArr
  if code == fsSpawnFail then
    IO.eprintln "slake self-check: freestanding Proc pipe spawn failed"
    return code
  if code == fsWaitFail then
    IO.eprintln "slake self-check: freestanding Proc pipe wait failed"
    return code
  if code == 0 then
    IO.println "slake self-check: OK (via lake / Systems.Proc pipe)"
  else
    IO.eprintln s!"slake self-check: lake exited {code} (Systems.Proc pipe)"
  return code

/-- `self-check`: classic-host MVP — delegate to `lake self-check` in the package dir.

Default: `IO.Process` → `lake self-check` with `cwd=pkg` (parity green without extract).
Optional FS_PROC/PIPE (W103): freestanding empty child env; rest plumbed (**not** empty-rest-only —
only `clean` is); rest may rebind Lake globals (`--dir`/`-d`/etc.); chdir(pkg);
resolveLakeAbs **before** chdir. Outside CLAIMED. STRICT: no IO.Process fall-back.
CLAIMED envelope stays `(build clean env test)` — self-check is residual honesty dual path only. -/
public def cmdSelfCheck (rest : List String := []) : IO UInt32 := do
  let cwd ← IO.currentDir
  let pkg ← match ← findPackageDir cwd with
    | some p => pure p
    | none =>
      IO.eprintln "slake self-check: no package root found (plausible lakefile walk-up)"
      return 1
  let lake ← lakeCmd
  let usePipe ← envFlagTruthy "SLAKE_USE_FS_PROC_PIPE"
  let useFs ← envFlagTruthy "SLAKE_USE_FS_PROC"
  let strict ← envFlagTruthy "SLAKE_FS_PROC_STRICT"
  if !usePipe && !useFs then
    return (← cmdSelfCheckIoProcess pkg lake rest)
  let linked := slakeFsProcLinked ()
  let pipeLinked := slakeFsProcPipeLinked ()
  let wantPipe := usePipe
  let pathLinked := if wantPipe then pipeLinked else linked
  let pathName := if wantPipe then "FS_PROC_PIPE" else "FS_PROC"
  if pathLinked != 1 then
    if strict then
      IO.eprintln s!"slake self-check: SLAKE_USE_{pathName}=1 + STRICT but {pathName} shim not linked"
      return 1
    IO.eprintln s!"slake self-check: SLAKE_USE_{pathName}=1 but {pathName} shim not linked; falling back"
    return (← cmdSelfCheckIoProcess pkg lake rest)
  match ← resolveLakeAbs with
  | none =>
    IO.eprintln s!"slake self-check: cannot resolve absolute lake path for {pathName} (set LAKE=/abs/path)"
    if strict then
      IO.eprintln "slake self-check: SLAKE_FS_PROC_STRICT=1; not falling back"
      return 1
    IO.eprintln "slake self-check: falling back to IO.Process"
    return (← cmdSelfCheckIoProcess pkg lake rest)
  | some lakeAbs =>
    let code ← if wantPipe then cmdSelfCheckFsProcPipe pkg lakeAbs rest else cmdSelfCheckFsProc pkg lakeAbs rest
    if code == fsSpawnFail then
      if strict then
        IO.eprintln s!"slake self-check: SLAKE_FS_PROC_STRICT=1; not falling back after {pathName} spawn fail"
        return 1
      IO.eprintln s!"slake self-check: falling back to IO.Process after {pathName} spawn fail"
      return (← cmdSelfCheckIoProcess pkg lake rest)
    if code == fsWaitFail then
      IO.eprintln s!"slake self-check: {pathName} wait fail (no IO.Process fall back)"
      return 1
    return code


/-- Classic `IO.Process` → `lake version-tags` in package dir (W82 parity growth base; W104 dual residual).

Thin forward; remaining argv after the command token is plumbed (W85).
Requires package root (lists package version-shaped git tags). -/
public def cmdVersionTagsIoProcess (pkg : FilePath) (lake : String) (rest : List String := []) : IO UInt32 := do
  cmdLakeForwardIoProcess "version-tags" pkg lake "version-tags" rest

/-- Freestanding Proc multi-arg path (`lake --dir=<pkg> version-tags [rest…]`).

Returns process exit `0…255`, `fsSpawnFail`, or `fsWaitFail`. W104 FS_PROC version-tags.
Empty child env; rest plumbed (**not** empty-rest-only); chdir(pkg); lakeAbs pre-resolved. -/
def cmdVersionTagsFsProc (pkg : FilePath) (lakeAbs : String) (rest : List String := []) : IO UInt32 := do
  let restArr := rest.toArray
  let shown := " ".intercalate ("version-tags" :: rest)
  IO.println s!"slake version-tags: SLAKE_USE_FS_PROC=1; freestanding Systems.Proc multi-arg"
  IO.println s!"  lake={lakeAbs} --dir={pkg} {shown}"
  IO.println "  (empty child env; inherits no host LAKE_*/LEAN_* — dual residual vs classic IO.Process)"
  IO.println "  (version-tags FS_PROC chdir to package root for relative path parity with classic cwd=pkg)"
  let code := slakeFsRunLakeVersionTags pkg.toString lakeAbs restArr
  if code == fsSpawnFail then
    IO.eprintln "slake version-tags: freestanding Proc spawn failed"
    return code
  if code == fsWaitFail then
    IO.eprintln "slake version-tags: freestanding Proc wait failed"
    return code
  if code == 0 then
    IO.println "slake version-tags: OK (via lake / Systems.Proc)"
  else
    IO.eprintln s!"slake version-tags: lake exited {code} (Systems.Proc)"
  return code

/-- Freestanding Proc **pipe** path for `lake version-tags` (stdout capture demo). W104.
Same chdir(pkg) relative-path parity as multi-arg version-tags FS_PROC. -/
def cmdVersionTagsFsProcPipe (pkg : FilePath) (lakeAbs : String) (rest : List String := []) : IO UInt32 := do
  let restArr := rest.toArray
  let shown := " ".intercalate ("version-tags" :: rest)
  IO.println s!"slake version-tags: SLAKE_USE_FS_PROC_PIPE=1; freestanding Systems.Proc pipe/stdio"
  IO.println s!"  lake={lakeAbs} --dir={pkg} {shown}"
  IO.println "  (empty child env; inherits no host LAKE_*/LEAN_* — dual residual vs classic IO.Process)"
  IO.println "  (version-tags FS_PROC_PIPE chdir to package root for relative path parity with classic cwd=pkg)"
  let code := slakeFsRunLakeVersionTagsPipe pkg.toString lakeAbs restArr
  if code == fsSpawnFail then
    IO.eprintln "slake version-tags: freestanding Proc pipe spawn failed"
    return code
  if code == fsWaitFail then
    IO.eprintln "slake version-tags: freestanding Proc pipe wait failed"
    return code
  if code == 0 then
    IO.println "slake version-tags: OK (via lake / Systems.Proc pipe)"
  else
    IO.eprintln s!"slake version-tags: lake exited {code} (Systems.Proc pipe)"
  return code

/-- `version-tags`: classic-host MVP — delegate to `lake version-tags` in the package dir.

Default: `IO.Process` → `lake version-tags` with `cwd=pkg` (parity green without extract).
Optional FS_PROC/PIPE (W104): freestanding empty child env; rest plumbed (**not** empty-rest-only —
only `clean` is); rest may rebind Lake globals (`--dir`/`-d`/etc.); chdir(pkg);
resolveLakeAbs **before** chdir. Outside CLAIMED. STRICT: no IO.Process fall-back.
CLAIMED envelope stays `(build clean env test)` — version-tags is residual honesty dual path only.
Plumbed-like peers for this cmd end at prior peer `…/self-check` (not including self). -/
public def cmdVersionTags (rest : List String := []) : IO UInt32 := do
  let cwd ← IO.currentDir
  let pkg ← match ← findPackageDir cwd with
    | some p => pure p
    | none =>
      IO.eprintln "slake version-tags: no package root found (plausible lakefile walk-up)"
      return 1
  let lake ← lakeCmd
  let usePipe ← envFlagTruthy "SLAKE_USE_FS_PROC_PIPE"
  let useFs ← envFlagTruthy "SLAKE_USE_FS_PROC"
  let strict ← envFlagTruthy "SLAKE_FS_PROC_STRICT"
  if !usePipe && !useFs then
    return (← cmdVersionTagsIoProcess pkg lake rest)
  let linked := slakeFsProcLinked ()
  let pipeLinked := slakeFsProcPipeLinked ()
  let wantPipe := usePipe
  let pathLinked := if wantPipe then pipeLinked else linked
  let pathName := if wantPipe then "FS_PROC_PIPE" else "FS_PROC"
  if pathLinked != 1 then
    if strict then
      IO.eprintln s!"slake version-tags: SLAKE_USE_{pathName}=1 + STRICT but {pathName} shim not linked"
      return 1
    IO.eprintln s!"slake version-tags: SLAKE_USE_{pathName}=1 but {pathName} shim not linked; falling back"
    return (← cmdVersionTagsIoProcess pkg lake rest)
  match ← resolveLakeAbs with
  | none =>
    IO.eprintln s!"slake version-tags: cannot resolve absolute lake path for {pathName} (set LAKE=/abs/path)"
    if strict then
      IO.eprintln "slake version-tags: SLAKE_FS_PROC_STRICT=1; not falling back"
      return 1
    IO.eprintln "slake version-tags: falling back to IO.Process"
    return (← cmdVersionTagsIoProcess pkg lake rest)
  | some lakeAbs =>
    let code ← if wantPipe then cmdVersionTagsFsProcPipe pkg lakeAbs rest else cmdVersionTagsFsProc pkg lakeAbs rest
    if code == fsSpawnFail then
      if strict then
        IO.eprintln s!"slake version-tags: SLAKE_FS_PROC_STRICT=1; not falling back after {pathName} spawn fail"
        return 1
      IO.eprintln s!"slake version-tags: falling back to IO.Process after {pathName} spawn fail"
      return (← cmdVersionTagsIoProcess pkg lake rest)
    if code == fsWaitFail then
      IO.eprintln s!"slake version-tags: {pathName} wait fail (no IO.Process fall back)"
      return 1
    return code


/-- Classic `IO.Process` → `lake query-kind` in package dir (W83 parity growth base; W113 dual residual).

Thin forward; remaining argv after the command token is plumbed (W85).
Requires package root (real `lake query-kind` needs Lake package context). -/
public def cmdQueryKindIoProcess (pkg : FilePath) (lake : String) (rest : List String := []) : IO UInt32 := do
  cmdLakeForwardIoProcess "query-kind" pkg lake "query-kind" rest

/-- Freestanding Proc multi-arg path (`lake --dir=<pkg> query-kind [rest…]`).

Returns process exit `0…255`, `fsSpawnFail`, or `fsWaitFail`. W113 FS_PROC query-kind.
Empty child env; rest plumbed (**not** empty-rest-only); chdir(pkg); lakeAbs pre-resolved.
Outside CLAIMED; CLAIMED is `(build clean env test)`. -/
def cmdQueryKindFsProc (pkg : FilePath) (lakeAbs : String) (rest : List String := []) : IO UInt32 := do
  let restArr := rest.toArray
  let shown := " ".intercalate ("query-kind" :: rest)
  IO.println s!"slake query-kind: SLAKE_USE_FS_PROC=1; freestanding Systems.Proc multi-arg"
  IO.println s!"  lake={lakeAbs} --dir={pkg} {shown}"
  IO.println "  (FS_PROC child env empty — does not inherit host LEAN_PATH/PATH)"
  IO.println "  (query-kind FS_PROC chdir to package root for relative path parity with classic cwd=pkg)"
  let code := slakeFsRunLakeQueryKind pkg.toString lakeAbs restArr
  if code == fsSpawnFail then
    IO.eprintln "slake query-kind: freestanding Proc spawn failed"
    return code
  if code == fsWaitFail then
    IO.eprintln "slake query-kind: freestanding Proc wait failed"
    return code
  if code == 0 then
    IO.println "slake query-kind: OK (via lake / Systems.Proc)"
  else
    IO.eprintln s!"slake query-kind: lake exited {code} (Systems.Proc)"
  return code

/-- Freestanding Proc **pipe** path for `lake query-kind` (stdout capture demo). W113.
Same chdir(pkg) relative-path parity as multi-arg query-kind FS_PROC. -/
def cmdQueryKindFsProcPipe (pkg : FilePath) (lakeAbs : String) (rest : List String := []) : IO UInt32 := do
  let restArr := rest.toArray
  let shown := " ".intercalate ("query-kind" :: rest)
  IO.println s!"slake query-kind: SLAKE_USE_FS_PROC_PIPE=1; freestanding Systems.Proc pipe/stdio"
  IO.println s!"  lake={lakeAbs} --dir={pkg} {shown}"
  IO.println "  (FS_PROC_PIPE stdout→parent pipe capture demo; child env empty)"
  IO.println "  (query-kind FS_PROC_PIPE chdir to package root for relative path parity with classic cwd=pkg)"
  IO.println "  (not full Lake IO redirect product — residual honesty)"
  let code := slakeFsRunLakeQueryKindPipe pkg.toString lakeAbs restArr
  if code == fsSpawnFail then
    IO.eprintln "slake query-kind: freestanding Proc pipe spawn failed"
    return code
  if code == fsWaitFail then
    IO.eprintln "slake query-kind: freestanding Proc pipe wait failed"
    return code
  if code == 0 then
    IO.println "slake query-kind: OK (via lake / Systems.Proc pipe)"
  else
    IO.eprintln s!"slake query-kind: lake exited {code} (Systems.Proc pipe)"
  return code

/-- `query-kind`: classic-host MVP — delegate to `lake query-kind` in the package dir.

Default: `IO.Process` → `lake query-kind` with `cwd=pkg` (parity green without extract).
Optional FS_PROC/PIPE dual residual (empty child env; chdir(pkg); resolveLakeAbs pre-chdir;
STRICT no fall-back). Rest plumbed (**not** empty-rest-only).
CLAIMED envelope stays `(build clean env test)` — query-kind is residual honesty dual path only. -/
public def cmdQueryKind (rest : List String := []) : IO UInt32 := do
  let cwd ← IO.currentDir
  let pkg ← match ← findPackageDir cwd with
    | some p => pure p
    | none =>
      IO.eprintln "slake query-kind: no package root found (plausible lakefile walk-up)"
      return 1
  let lake ← lakeCmd
  let wantPipe := (← IO.getEnv "SLAKE_USE_FS_PROC_PIPE") == some "1"
  let wantFs := wantPipe || (← IO.getEnv "SLAKE_USE_FS_PROC") == some "1"
  let strict := (← IO.getEnv "SLAKE_FS_PROC_STRICT") == some "1"
  if !wantFs then
    return (← cmdQueryKindIoProcess pkg lake rest)
  let pathName := if wantPipe then "FS_PROC_PIPE" else "FS_PROC"
  let linked := if wantPipe then slakeFsProcPipeLinked () else slakeFsProcLinked ()
  if linked != 1 then
    if strict then
      IO.eprintln s!"slake query-kind: SLAKE_USE_{pathName}=1 + STRICT but {pathName} shim not linked"
      return 1
    IO.eprintln s!"slake query-kind: SLAKE_USE_{pathName}=1 but {pathName} shim not linked; falling back"
    return (← cmdQueryKindIoProcess pkg lake rest)
  -- resolveLakeAbs MUST complete before any FS_PROC chdir(pkg)
  match ← resolveLakeAbs with
  | none =>
    IO.eprintln s!"slake query-kind: cannot resolve absolute lake path for {pathName} (set LAKE=/abs/path)"
    if strict then
      IO.eprintln "slake query-kind: SLAKE_FS_PROC_STRICT=1; not falling back"
      return 1
    IO.eprintln "slake query-kind: falling back to IO.Process"
    return (← cmdQueryKindIoProcess pkg lake rest)
  | some lakeAbs =>
    let code ← if wantPipe then cmdQueryKindFsProcPipe pkg lakeAbs rest else cmdQueryKindFsProc pkg lakeAbs rest
    if code == fsSpawnFail then
      if strict then
        IO.eprintln s!"slake query-kind: SLAKE_FS_PROC_STRICT=1; not falling back after {pathName} spawn fail"
        return 1
      IO.eprintln s!"slake query-kind: falling back to IO.Process after {pathName} spawn fail"
      return (← cmdQueryKindIoProcess pkg lake rest)
    if code == fsWaitFail then
      IO.eprintln s!"slake query-kind: {pathName} wait fail (no IO.Process fall back)"
      return 1
    return code

/-- Classic `IO.Process` → `lake resolve-deps` in package dir (W83 parity growth base; W114 dual residual).

Thin forward; remaining argv after the command token is plumbed (W85).
Requires package root (real `lake resolve-deps` needs Lake package context). -/
public def cmdResolveDepsIoProcess (pkg : FilePath) (lake : String) (rest : List String := []) : IO UInt32 := do
  cmdLakeForwardIoProcess "resolve-deps" pkg lake "resolve-deps" rest

/-- Freestanding Proc multi-arg path (`lake --dir=<pkg> resolve-deps [rest…]`).

Returns process exit `0…255`, `fsSpawnFail`, or `fsWaitFail`. W114 FS_PROC resolve-deps.
Empty child env; rest plumbed (**not** empty-rest-only); chdir(pkg); lakeAbs pre-resolved.
Outside CLAIMED; CLAIMED is `(build clean env test)`. -/
def cmdResolveDepsFsProc (pkg : FilePath) (lakeAbs : String) (rest : List String := []) : IO UInt32 := do
  let restArr := rest.toArray
  let shown := " ".intercalate ("resolve-deps" :: rest)
  IO.println s!"slake resolve-deps: SLAKE_USE_FS_PROC=1; freestanding Systems.Proc multi-arg"
  IO.println s!"  lake={lakeAbs} --dir={pkg} {shown}"
  IO.println "  (FS_PROC child env empty — does not inherit host LEAN_PATH/PATH)"
  IO.println "  (resolve-deps FS_PROC chdir to package root for relative path parity with classic cwd=pkg)"
  let code := slakeFsRunLakeResolveDeps pkg.toString lakeAbs restArr
  if code == fsSpawnFail then
    IO.eprintln "slake resolve-deps: freestanding Proc spawn failed"
    return code
  if code == fsWaitFail then
    IO.eprintln "slake resolve-deps: freestanding Proc wait failed"
    return code
  if code == 0 then
    IO.println "slake resolve-deps: OK (via lake / Systems.Proc)"
  else
    IO.eprintln s!"slake resolve-deps: lake exited {code} (Systems.Proc)"
  return code

/-- Freestanding Proc **pipe** path for `lake resolve-deps` (stdout capture demo). W114.
Same chdir(pkg) relative-path parity as multi-arg resolve-deps FS_PROC. -/
def cmdResolveDepsFsProcPipe (pkg : FilePath) (lakeAbs : String) (rest : List String := []) : IO UInt32 := do
  let restArr := rest.toArray
  let shown := " ".intercalate ("resolve-deps" :: rest)
  IO.println s!"slake resolve-deps: SLAKE_USE_FS_PROC_PIPE=1; freestanding Systems.Proc pipe/stdio"
  IO.println s!"  lake={lakeAbs} --dir={pkg} {shown}"
  IO.println "  (FS_PROC_PIPE stdout→parent pipe capture demo; child env empty)"
  IO.println "  (resolve-deps FS_PROC_PIPE chdir to package root for relative path parity with classic cwd=pkg)"
  IO.println "  (not full Lake IO redirect product — residual honesty)"
  let code := slakeFsRunLakeResolveDepsPipe pkg.toString lakeAbs restArr
  if code == fsSpawnFail then
    IO.eprintln "slake resolve-deps: freestanding Proc pipe spawn failed"
    return code
  if code == fsWaitFail then
    IO.eprintln "slake resolve-deps: freestanding Proc pipe wait failed"
    return code
  if code == 0 then
    IO.println "slake resolve-deps: OK (via lake / Systems.Proc pipe)"
  else
    IO.eprintln s!"slake resolve-deps: lake exited {code} (Systems.Proc pipe)"
  return code

/-- `resolve-deps`: classic-host MVP — delegate to `lake resolve-deps` in the package dir.

Default: `IO.Process` → `lake resolve-deps` with `cwd=pkg` (parity green without extract).
Optional FS_PROC/PIPE dual residual (empty child env; chdir(pkg); resolveLakeAbs pre-chdir;
STRICT no fall-back). Rest plumbed (**not** empty-rest-only).
CLAIMED envelope stays `(build clean env test)` — resolve-deps is residual honesty dual path only. -/
public def cmdResolveDeps (rest : List String := []) : IO UInt32 := do
  let cwd ← IO.currentDir
  let pkg ← match ← findPackageDir cwd with
    | some p => pure p
    | none =>
      IO.eprintln "slake resolve-deps: no package root found (plausible lakefile walk-up)"
      return 1
  let lake ← lakeCmd
  let wantPipe := (← IO.getEnv "SLAKE_USE_FS_PROC_PIPE") == some "1"
  let wantFs := wantPipe || (← IO.getEnv "SLAKE_USE_FS_PROC") == some "1"
  let strict := (← IO.getEnv "SLAKE_FS_PROC_STRICT") == some "1"
  if !wantFs then
    return (← cmdResolveDepsIoProcess pkg lake rest)
  let pathName := if wantPipe then "FS_PROC_PIPE" else "FS_PROC"
  let linked := if wantPipe then slakeFsProcPipeLinked () else slakeFsProcLinked ()
  if linked != 1 then
    if strict then
      IO.eprintln s!"slake resolve-deps: SLAKE_USE_{pathName}=1 + STRICT but {pathName} shim not linked"
      return 1
    IO.eprintln s!"slake resolve-deps: SLAKE_USE_{pathName}=1 but {pathName} shim not linked; falling back"
    return (← cmdResolveDepsIoProcess pkg lake rest)
  -- resolveLakeAbs MUST complete before any FS_PROC chdir(pkg)
  match ← resolveLakeAbs with
  | none =>
    IO.eprintln s!"slake resolve-deps: cannot resolve absolute lake path for {pathName} (set LAKE=/abs/path)"
    if strict then
      IO.eprintln "slake resolve-deps: SLAKE_FS_PROC_STRICT=1; not falling back"
      return 1
    IO.eprintln "slake resolve-deps: falling back to IO.Process"
    return (← cmdResolveDepsIoProcess pkg lake rest)
  | some lakeAbs =>
    let code ← if wantPipe then cmdResolveDepsFsProcPipe pkg lakeAbs rest else cmdResolveDepsFsProc pkg lakeAbs rest
    if code == fsSpawnFail then
      if strict then
        IO.eprintln s!"slake resolve-deps: SLAKE_FS_PROC_STRICT=1; not falling back after {pathName} spawn fail"
        return 1
      IO.eprintln s!"slake resolve-deps: falling back to IO.Process after {pathName} spawn fail"
      return (← cmdResolveDepsIoProcess pkg lake rest)
    if code == fsWaitFail then
      IO.eprintln s!"slake resolve-deps: {pathName} wait fail (no IO.Process fall back)"
      return 1
    return code

/-- Classic `IO.Process` → `lake reservoir-config` in package dir (W83 parity growth base; W115 dual residual).

Thin forward; remaining argv after the command token is plumbed (W85).
Requires package root (real `lake reservoir-config` needs Lake package context). -/
public def cmdReservoirConfigIoProcess (pkg : FilePath) (lake : String) (rest : List String := []) : IO UInt32 := do
  cmdLakeForwardIoProcess "reservoir-config" pkg lake "reservoir-config" rest

/-- Freestanding Proc multi-arg path (`lake --dir=<pkg> reservoir-config [rest…]`).

Returns process exit `0…255`, `fsSpawnFail`, or `fsWaitFail`. W115 FS_PROC reservoir-config.
Empty child env; rest plumbed (**not** empty-rest-only); chdir(pkg); lakeAbs pre-resolved.
Outside CLAIMED; CLAIMED is `(build clean env test)`. -/
def cmdReservoirConfigFsProc (pkg : FilePath) (lakeAbs : String) (rest : List String := []) : IO UInt32 := do
  let restArr := rest.toArray
  let shown := " ".intercalate ("reservoir-config" :: rest)
  IO.println s!"slake reservoir-config: SLAKE_USE_FS_PROC=1; freestanding Systems.Proc multi-arg"
  IO.println s!"  lake={lakeAbs} --dir={pkg} {shown}"
  IO.println "  (FS_PROC child env empty — does not inherit host LEAN_PATH/PATH)"
  IO.println "  (reservoir-config FS_PROC chdir to package root for relative path parity with classic cwd=pkg)"
  let code := slakeFsRunLakeReservoirConfig pkg.toString lakeAbs restArr
  if code == fsSpawnFail then
    IO.eprintln "slake reservoir-config: freestanding Proc spawn failed"
    return code
  if code == fsWaitFail then
    IO.eprintln "slake reservoir-config: freestanding Proc wait failed"
    return code
  if code == 0 then
    IO.println "slake reservoir-config: OK (via lake / Systems.Proc)"
  else
    IO.eprintln s!"slake reservoir-config: lake exited {code} (Systems.Proc)"
  return code

/-- Freestanding Proc **pipe** path for `lake reservoir-config` (stdout capture demo). W115.
Same chdir(pkg) relative-path parity as multi-arg reservoir-config FS_PROC. -/
def cmdReservoirConfigFsProcPipe (pkg : FilePath) (lakeAbs : String) (rest : List String := []) : IO UInt32 := do
  let restArr := rest.toArray
  let shown := " ".intercalate ("reservoir-config" :: rest)
  IO.println s!"slake reservoir-config: SLAKE_USE_FS_PROC_PIPE=1; freestanding Systems.Proc pipe/stdio"
  IO.println s!"  lake={lakeAbs} --dir={pkg} {shown}"
  IO.println "  (FS_PROC_PIPE stdout→parent pipe capture demo; child env empty)"
  IO.println "  (reservoir-config FS_PROC_PIPE chdir to package root for relative path parity with classic cwd=pkg)"
  IO.println "  (not full Lake IO redirect product — residual honesty)"
  let code := slakeFsRunLakeReservoirConfigPipe pkg.toString lakeAbs restArr
  if code == fsSpawnFail then
    IO.eprintln "slake reservoir-config: freestanding Proc pipe spawn failed"
    return code
  if code == fsWaitFail then
    IO.eprintln "slake reservoir-config: freestanding Proc pipe wait failed"
    return code
  if code == 0 then
    IO.println "slake reservoir-config: OK (via lake / Systems.Proc pipe)"
  else
    IO.eprintln s!"slake reservoir-config: lake exited {code} (Systems.Proc pipe)"
  return code

/-- `reservoir-config`: classic-host MVP — delegate to `lake reservoir-config` in the package dir.

Default: `IO.Process` → `lake reservoir-config` with `cwd=pkg` (parity green without extract).
Optional FS_PROC/PIPE dual residual (empty child env; chdir(pkg); resolveLakeAbs pre-chdir;
STRICT no fall-back). Rest plumbed (**not** empty-rest-only).
CLAIMED envelope stays `(build clean env test)` — reservoir-config is residual honesty dual path only. -/
public def cmdReservoirConfig (rest : List String := []) : IO UInt32 := do
  let cwd ← IO.currentDir
  let pkg ← match ← findPackageDir cwd with
    | some p => pure p
    | none =>
      IO.eprintln "slake reservoir-config: no package root found (plausible lakefile walk-up)"
      return 1
  let lake ← lakeCmd
  let wantPipe := (← IO.getEnv "SLAKE_USE_FS_PROC_PIPE") == some "1"
  let wantFs := wantPipe || (← IO.getEnv "SLAKE_USE_FS_PROC") == some "1"
  let strict := (← IO.getEnv "SLAKE_FS_PROC_STRICT") == some "1"
  if !wantFs then
    return (← cmdReservoirConfigIoProcess pkg lake rest)
  let pathName := if wantPipe then "FS_PROC_PIPE" else "FS_PROC"
  let linked := if wantPipe then slakeFsProcPipeLinked () else slakeFsProcLinked ()
  if linked != 1 then
    if strict then
      IO.eprintln s!"slake reservoir-config: SLAKE_USE_{pathName}=1 + STRICT but {pathName} shim not linked"
      return 1
    IO.eprintln s!"slake reservoir-config: SLAKE_USE_{pathName}=1 but {pathName} shim not linked; falling back"
    return (← cmdReservoirConfigIoProcess pkg lake rest)
  -- resolveLakeAbs MUST complete before any FS_PROC chdir(pkg)
  match ← resolveLakeAbs with
  | none =>
    IO.eprintln s!"slake reservoir-config: cannot resolve absolute lake path for {pathName} (set LAKE=/abs/path)"
    if strict then
      IO.eprintln "slake reservoir-config: SLAKE_FS_PROC_STRICT=1; not falling back"
      return 1
    IO.eprintln "slake reservoir-config: falling back to IO.Process"
    return (← cmdReservoirConfigIoProcess pkg lake rest)
  | some lakeAbs =>
    let code ← if wantPipe then cmdReservoirConfigFsProcPipe pkg lakeAbs rest else cmdReservoirConfigFsProc pkg lakeAbs rest
    if code == fsSpawnFail then
      if strict then
        IO.eprintln s!"slake reservoir-config: SLAKE_FS_PROC_STRICT=1; not falling back after {pathName} spawn fail"
        return 1
      IO.eprintln s!"slake reservoir-config: falling back to IO.Process after {pathName} spawn fail"
      return (← cmdReservoirConfigIoProcess pkg lake rest)
    if code == fsWaitFail then
      IO.eprintln s!"slake reservoir-config: {pathName} wait fail (no IO.Process fall back)"
      return 1
    return code

/-- Classic `IO.Process` → `lake exec` in package dir (W84 parity growth base; W112 dual residual).

Thin forward; remaining argv after the command token is plumbed (W85).
Requires package root (real `lake exec` needs Lake package context).
Real Lake alias — `exe`|`exec` both map to `lake.exe`. -/
public def cmdExecIoProcess (pkg : FilePath) (lake : String) (rest : List String := []) : IO UInt32 := do
  cmdLakeForwardIoProcess "exec" pkg lake "exec" rest

/-- Freestanding Proc multi-arg path (`lake --dir=<pkg> exec [rest…]`).

Returns process exit `0…255`, `fsSpawnFail`, or `fsWaitFail`. W112 FS_PROC exec.
Empty child env; rest plumbed (**not** empty-rest-only); chdir(pkg); lakeAbs pre-resolved.
Outside CLAIMED; CLAIMED is `(build clean env test)`. -/
def cmdExecFsProc (pkg : FilePath) (lakeAbs : String) (rest : List String := []) : IO UInt32 := do
  let restArr := rest.toArray
  let shown := " ".intercalate ("exec" :: rest)
  IO.println s!"slake exec: SLAKE_USE_FS_PROC=1; freestanding Systems.Proc multi-arg"
  IO.println s!"  lake={lakeAbs} --dir={pkg} {shown}"
  IO.println "  (FS_PROC child env empty — does not inherit host LEAN_PATH/PATH)"
  IO.println "  (exec FS_PROC chdir to package root for relative path parity with classic cwd=pkg)"
  let code := slakeFsRunLakeExec pkg.toString lakeAbs restArr
  if code == fsSpawnFail then
    IO.eprintln "slake exec: freestanding Proc spawn failed"
    return code
  if code == fsWaitFail then
    IO.eprintln "slake exec: freestanding Proc wait failed"
    return code
  if code == 0 then
    IO.println "slake exec: OK (via lake / Systems.Proc)"
  else
    IO.eprintln s!"slake exec: lake exited {code} (Systems.Proc)"
  return code

/-- Freestanding Proc **pipe** path for `lake exec` (stdout capture demo). W112.
Same chdir(pkg) relative-path parity as multi-arg exec FS_PROC. -/
def cmdExecFsProcPipe (pkg : FilePath) (lakeAbs : String) (rest : List String := []) : IO UInt32 := do
  let restArr := rest.toArray
  let shown := " ".intercalate ("exec" :: rest)
  IO.println s!"slake exec: SLAKE_USE_FS_PROC_PIPE=1; freestanding Systems.Proc pipe/stdio"
  IO.println s!"  lake={lakeAbs} --dir={pkg} {shown}"
  IO.println "  (FS_PROC_PIPE stdout→parent pipe capture demo; child env empty)"
  IO.println "  (exec FS_PROC_PIPE chdir to package root for relative path parity with classic cwd=pkg)"
  IO.println "  (not full Lake IO redirect product — residual honesty)"
  let code := slakeFsRunLakeExecPipe pkg.toString lakeAbs restArr
  if code == fsSpawnFail then
    IO.eprintln "slake exec: freestanding Proc pipe spawn failed"
    return code
  if code == fsWaitFail then
    IO.eprintln "slake exec: freestanding Proc pipe wait failed"
    return code
  if code == 0 then
    IO.println "slake exec: OK (via lake / Systems.Proc pipe)"
  else
    IO.eprintln s!"slake exec: lake exited {code} (Systems.Proc pipe)"
  return code

/-- `exec`: classic-host MVP — delegate to `lake exec` in the package dir.

Default: `IO.Process` → `lake exec` with `cwd=pkg` (parity green without extract).
Optional FS_PROC/PIPE dual residual (empty child env; chdir(pkg); resolveLakeAbs pre-chdir;
STRICT no fall-back). Rest plumbed (**not** empty-rest-only).
CLAIMED envelope stays `(build clean env test)` — exec is residual honesty dual path only.
Lake alias of `exe` (same `lake.exe` implementation). -/
public def cmdExec (rest : List String := []) : IO UInt32 := do
  let cwd ← IO.currentDir
  let pkg ← match ← findPackageDir cwd with
    | some p => pure p
    | none =>
      IO.eprintln "slake exec: no package root found (plausible lakefile walk-up)"
      return 1
  let lake ← lakeCmd
  let wantPipe := (← IO.getEnv "SLAKE_USE_FS_PROC_PIPE") == some "1"
  let wantFs := wantPipe || (← IO.getEnv "SLAKE_USE_FS_PROC") == some "1"
  let strict := (← IO.getEnv "SLAKE_FS_PROC_STRICT") == some "1"
  if !wantFs then
    return (← cmdExecIoProcess pkg lake rest)
  let pathName := if wantPipe then "FS_PROC_PIPE" else "FS_PROC"
  let linked := if wantPipe then slakeFsProcPipeLinked () else slakeFsProcLinked ()
  if linked != 1 then
    if strict then
      IO.eprintln s!"slake exec: SLAKE_USE_{pathName}=1 + STRICT but {pathName} shim not linked"
      return 1
    IO.eprintln s!"slake exec: SLAKE_USE_{pathName}=1 but {pathName} shim not linked; falling back"
    return (← cmdExecIoProcess pkg lake rest)
  -- resolveLakeAbs MUST complete before any FS_PROC chdir(pkg)
  match ← resolveLakeAbs with
  | none =>
    IO.eprintln s!"slake exec: cannot resolve absolute lake path for {pathName} (set LAKE=/abs/path)"
    if strict then
      IO.eprintln "slake exec: SLAKE_FS_PROC_STRICT=1; not falling back"
      return 1
    IO.eprintln "slake exec: falling back to IO.Process"
    return (← cmdExecIoProcess pkg lake rest)
  | some lakeAbs =>
    let code ← if wantPipe then cmdExecFsProcPipe pkg lakeAbs rest else cmdExecFsProc pkg lakeAbs rest
    if code == fsSpawnFail then
      if strict then
        IO.eprintln s!"slake exec: SLAKE_FS_PROC_STRICT=1; not falling back after {pathName} spawn fail"
        return 1
      IO.eprintln s!"slake exec: falling back to IO.Process after {pathName} spawn fail"
      return (← cmdExecIoProcess pkg lake rest)
    if code == fsWaitFail then
      IO.eprintln s!"slake exec: {pathName} wait fail (no IO.Process fall back)"
      return 1
    return code

/-- Classic `IO.Process` → `lake upgrade` in package dir (W84 parity growth base; W116 dual residual).

Thin forward; remaining argv after the command token is plumbed (W85).
Requires package root (real `lake upgrade` needs Lake package context).
Real Lake alias — `update`|`upgrade` both map to `lake.update`. -/
public def cmdUpgradeIoProcess (pkg : FilePath) (lake : String) (rest : List String := []) : IO UInt32 := do
  cmdLakeForwardIoProcess "upgrade" pkg lake "upgrade" rest

/-- Freestanding Proc multi-arg path (`lake --dir=<pkg> upgrade [rest…]`).

Returns process exit `0…255`, `fsSpawnFail`, or `fsWaitFail`. W116 FS_PROC upgrade.
Empty child env; rest plumbed (**not** empty-rest-only); chdir(pkg); lakeAbs pre-resolved.
Outside CLAIMED; CLAIMED is `(build clean env test)`. -/
def cmdUpgradeFsProc (pkg : FilePath) (lakeAbs : String) (rest : List String := []) : IO UInt32 := do
  let restArr := rest.toArray
  let shown := " ".intercalate ("upgrade" :: rest)
  IO.println s!"slake upgrade: SLAKE_USE_FS_PROC=1; freestanding Systems.Proc multi-arg"
  IO.println s!"  lake={lakeAbs} --dir={pkg} {shown}"
  IO.println "  (FS_PROC child env empty — does not inherit host LEAN_PATH/PATH)"
  IO.println "  (upgrade FS_PROC chdir to package root for relative path parity with classic cwd=pkg)"
  let code := slakeFsRunLakeUpgrade pkg.toString lakeAbs restArr
  if code == fsSpawnFail then
    IO.eprintln "slake upgrade: freestanding Proc spawn failed"
    return code
  if code == fsWaitFail then
    IO.eprintln "slake upgrade: freestanding Proc wait failed"
    return code
  if code == 0 then
    IO.println "slake upgrade: OK (via lake / Systems.Proc)"
  else
    IO.eprintln s!"slake upgrade: lake exited {code} (Systems.Proc)"
  return code

/-- Freestanding Proc **pipe** path for `lake upgrade` (stdout capture demo). W116.
Same chdir(pkg) relative-path parity as multi-arg upgrade FS_PROC. -/
def cmdUpgradeFsProcPipe (pkg : FilePath) (lakeAbs : String) (rest : List String := []) : IO UInt32 := do
  let restArr := rest.toArray
  let shown := " ".intercalate ("upgrade" :: rest)
  IO.println s!"slake upgrade: SLAKE_USE_FS_PROC_PIPE=1; freestanding Systems.Proc pipe/stdio"
  IO.println s!"  lake={lakeAbs} --dir={pkg} {shown}"
  IO.println "  (FS_PROC_PIPE stdout→parent pipe capture demo; child env empty)"
  IO.println "  (upgrade FS_PROC_PIPE chdir to package root for relative path parity with classic cwd=pkg)"
  IO.println "  (not full Lake IO redirect product — residual honesty)"
  let code := slakeFsRunLakeUpgradePipe pkg.toString lakeAbs restArr
  if code == fsSpawnFail then
    IO.eprintln "slake upgrade: freestanding Proc pipe spawn failed"
    return code
  if code == fsWaitFail then
    IO.eprintln "slake upgrade: freestanding Proc pipe wait failed"
    return code
  if code == 0 then
    IO.println "slake upgrade: OK (via lake / Systems.Proc pipe)"
  else
    IO.eprintln s!"slake upgrade: lake exited {code} (Systems.Proc pipe)"
  return code

/-- `upgrade`: classic-host MVP — delegate to `lake upgrade` in the package dir.

Default: `IO.Process` → `lake upgrade` with `cwd=pkg` (parity green without extract).
Optional FS_PROC/PIPE dual residual (empty child env; chdir(pkg); resolveLakeAbs pre-chdir;
STRICT no fall-back). Rest plumbed (**not** empty-rest-only).
CLAIMED envelope stays `(build clean env test)` — upgrade is residual honesty dual path only.
Lake alias of `update` (same `lake.update` implementation). -/
public def cmdUpgrade (rest : List String := []) : IO UInt32 := do
  let cwd ← IO.currentDir
  let pkg ← match ← findPackageDir cwd with
    | some p => pure p
    | none =>
      IO.eprintln "slake upgrade: no package root found (plausible lakefile walk-up)"
      return 1
  let lake ← lakeCmd
  let wantPipe := (← IO.getEnv "SLAKE_USE_FS_PROC_PIPE") == some "1"
  let wantFs := wantPipe || (← IO.getEnv "SLAKE_USE_FS_PROC") == some "1"
  let strict := (← IO.getEnv "SLAKE_FS_PROC_STRICT") == some "1"
  if !wantFs then
    return (← cmdUpgradeIoProcess pkg lake rest)
  let pathName := if wantPipe then "FS_PROC_PIPE" else "FS_PROC"
  let linked := if wantPipe then slakeFsProcPipeLinked () else slakeFsProcLinked ()
  if linked != 1 then
    if strict then
      IO.eprintln s!"slake upgrade: SLAKE_USE_{pathName}=1 + STRICT but {pathName} shim not linked"
      return 1
    IO.eprintln s!"slake upgrade: SLAKE_USE_{pathName}=1 but {pathName} shim not linked; falling back"
    return (← cmdUpgradeIoProcess pkg lake rest)
  -- resolveLakeAbs MUST complete before any FS_PROC chdir(pkg)
  match ← resolveLakeAbs with
  | none =>
    IO.eprintln s!"slake upgrade: cannot resolve absolute lake path for {pathName} (set LAKE=/abs/path)"
    if strict then
      IO.eprintln "slake upgrade: SLAKE_FS_PROC_STRICT=1; not falling back"
      return 1
    IO.eprintln "slake upgrade: falling back to IO.Process"
    return (← cmdUpgradeIoProcess pkg lake rest)
  | some lakeAbs =>
    let code ← if wantPipe then cmdUpgradeFsProcPipe pkg lakeAbs rest else cmdUpgradeFsProc pkg lakeAbs rest
    if code == fsSpawnFail then
      if strict then
        IO.eprintln s!"slake upgrade: SLAKE_FS_PROC_STRICT=1; not falling back after {pathName} spawn fail"
        return 1
      IO.eprintln s!"slake upgrade: falling back to IO.Process after {pathName} spawn fail"
      return (← cmdUpgradeIoProcess pkg lake rest)
    if code == fsWaitFail then
      IO.eprintln s!"slake upgrade: {pathName} wait fail (no IO.Process fall back)"
      return 1
    return code

/-- Dispatch argv tail (first element is the command). Empty → help. -/
public def dispatchArgs (args : List String) : CmdResult :=
  match args with
  | [] => .ok 0 usage
  | c :: _ => dispatch c

/-- Run the MVP CLI on argv (without program name). -/
public def run (args : List String) : IO UInt32 := do
  match args with
  | [] =>
    IO.println usage
    return 0
  | cmd :: rest =>
    if cmd == "--help" || cmd == "help" || cmd == "-h" then
      IO.println usage
      return 0
    else if cmd == "--version" || cmd == "version" || cmd == "-V" then
      IO.println versionString
      return 0
    else if cmd == "env" then
      cmdEnv
    else if cmd == "clean" then
      cmdClean rest
    else if cmd == "test" then
      cmdTest rest
    else if cmd == "script" then
      cmdScript rest
    else if cmd == "exe" then
      cmdExe rest
    else if cmd == "lint" then
      cmdLint rest
    else if cmd == "check-build" then
      cmdCheckBuild rest
    else if cmd == "check-test" then
      cmdCheckTest rest
    else if cmd == "check-lint" then
      cmdCheckLint rest
    else if cmd == "query" then
      cmdQuery rest
    else if cmd == "shake" then
      cmdShake rest
    else if cmd == "update" then
      cmdUpdate rest
    else if cmd == "pack" then
      cmdPack rest
    else if cmd == "unpack" then
      cmdUnpack rest
    else if cmd == "cache" then
      cmdCache rest
    else if cmd == "lean" then
      cmdLean rest
    else if cmd == "scripts" then
      cmdScripts rest
    else if cmd == "new" then
      cmdNew rest
    else if cmd == "init" then
      cmdInit rest
    else if cmd == "serve" then
      cmdServe rest
    else if cmd == "upload" then
      cmdUpload rest
    else if cmd == "translate-config" then
      cmdTranslateConfig rest
    else if cmd == "run" then
      cmdRun rest
    else if cmd == "setup-file" then
      cmdSetupFile rest
    else if cmd == "self-check" then
      cmdSelfCheck rest
    else if cmd == "version-tags" then
      cmdVersionTags rest
    else if cmd == "query-kind" then
      cmdQueryKind rest
    else if cmd == "resolve-deps" then
      cmdResolveDeps rest
    else if cmd == "reservoir-config" then
      cmdReservoirConfig rest
    else if cmd == "exec" then
      cmdExec rest
    else if cmd == "upgrade" then
      cmdUpgrade rest
    else if cmd == "build" then
      cmdBuild rest
    else
      IO.eprintln s!"unknown command: {cmd}"
      IO.println usage
      return 1

end Slake.CLI
