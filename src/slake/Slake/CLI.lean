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
  `SLAKE_FS_PROC_STRICT=1`). With `SLAKE_DEPGRAPH=1`, print a freestanding
  `DepGraph` Kahn topo plan (demo C→B→A) before the lake delegate.
* `clean` — dual residual (CLAIMED token):
  - **native (default):** wipe package `.lake/build` only (not bare `build/`; not full Lake clean).
    Non-empty rest is **refused** (native cannot rebind package / has no Lake globals).
  - **FS_PROC / PIPE:** optional `SLAKE_USE_FS_PROC=1` / `SLAKE_USE_FS_PROC_PIPE=1` delegates to
    `lake clean` (Lake’s clean semantics — may wipe more than `.lake/build`). **Empty rest only**
    so Lake globals (`--dir`/`-d`/`--file`/…) cannot redirect the wipe. Empty child env; STRICT
    refuses fall-back to native on unlinked/spawn fail (native wipe is still the non-STRICT fall-back).
* `test` — default classic `IO.Process` → `lake test`; optional `SLAKE_USE_FS_PROC=1` /
  `SLAKE_USE_FS_PROC_PIPE=1` freestanding multi-arg / pipe (W87; empty child env; not
  CLAIMED; residual honesty dual path). Rest argv plumbed like build.
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
  CLAIMED stays `(build clean env)` only — argv plumbing does not expand CLAIMED semantics.
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

/-- Print freestanding DepGraph demo plan (`slake depgraph plan: C B A`).

Returns `0` on success, nonzero on init/edge/topo failure. -/
@[extern "slake_fs_depgraph_print_plan"]
opaque slakeFsDepgraphPrintPlan : Unit → UInt32

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
  "  clean       Dual residual: native wipe pkg/.lake/build (default; empty rest only);\n" ++
  "              FS_PROC/PIPE → lake clean (empty rest only; Lake clean semantics)\n" ++
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
  "  env         Print cwd, package dir, LEAN_PATH, FS_PROC/PIPE/DEPGRAPH status\n" ++
  "  --help      Show this help\n" ++
  "  --version   Show version\n" ++
  "\n" ++
  "Env:\n" ++
  "  SLAKE_USE_FS_PROC=1      freestanding Systems.Proc multi-arg spawn\n" ++
  "  SLAKE_USE_FS_PROC_PIPE=1 freestanding Proc pipe/stdio (stdout capture demo)\n" ++
  "  SLAKE_FS_PROC_STRICT=1   no IO.Process fall back on build/test/exe/lint/script/update/pack/cache/unpack/query/shake/serve/upload/lean/scripts/setup-file/self-check/version-tags/translate-config/run/new/init/check-build/check-test/check-lint/exec/query-kind/resolve-deps/reservoir-config/upgrade;\n" ++
  "                          clean: no native wipe fall-back (unlinked/spawn fail)\n" ++
  "  SLAKE_DEPGRAPH=1         print freestanding DepGraph plan (demo C→B→A)\n" ++
  "  LAKE=/path/to/lake       absolute lake binary (required for FS_PROC paths)\n" ++
  "  FS_PROC child env is empty (not host-env inherit); classic path inherits.\n" ++
  "  PIPE path is demo/capture only — not full Lake IO redirect product.\n" ++
  "  clean rest: empty only on native and FS_PROC/PIPE (no Lake global rebinds).\n" ++
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
  let linked := slakeFsProcLinked ()
  let pipeLinked := slakeFsProcPipeLinked ()
  let dgLinked := slakeFsDepgraphLinked ()
  IO.println s!"SLAKE_USE_FS_PROC: {if useFs then "1" else "0"}"
  IO.println s!"SLAKE_USE_FS_PROC_PIPE: {if usePipe then "1" else "0"}"
  IO.println s!"SLAKE_FS_PROC_STRICT: {if strict then "1" else "0"}"
  IO.println s!"SLAKE_FS_PROC_LINKED: {linked}"
  IO.println s!"SLAKE_FS_PROC_PIPE_LINKED: {pipeLinked}"
  IO.println s!"SLAKE_DEPGRAPH: {if useDg then "1" else "0"}"
  IO.println s!"SLAKE_DEPGRAPH_LINKED: {dgLinked}"
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
    IO.println "slake env: default path — build/test/exe/lint/script/update/pack/cache/unpack/query/shake/serve/upload/lean/scripts/setup-file/self-check/version-tags/translate-config/run/new/init/check-build/check-test/check-lint/exec/query-kind/resolve-deps/reservoir-config/upgrade use classic IO.Process (inherits host env); clean defaults to native wipe pkg/.lake/build (not IO.Process)"
  if useDg && dgLinked == 1 then
    IO.println "slake env: DEPGRAPH plan print active when building (demo C→B→A; not package parse)"
  else if useDg then
    IO.println "slake env: DEPGRAPH requested but shim not linked (plan skipped)"
  else
    IO.println "slake env: DEPGRAPH plan print off (default)"
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
command is itself in CLAIMED (`build` only among IO.Process forwards). -/
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

/-- `test`: classic-host MVP — delegate to `lake test` in the package dir.

Default: `IO.Process` → `lake test` (parity green without extract).
With `SLAKE_USE_FS_PROC_PIPE=1` / `SLAKE_USE_FS_PROC=1`: freestanding Proc paths
(W87; same flags/STRICT/empty-child-env honesty as `build`). **Not** in CLAIMED
parity slice. **Not** full Lake parity. -/
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

/-- Native clean: remove package `.lake/build` only (default CLAIMED path).

Semantics: wipe `pkg/.lake/build` only — not full Lake `clean` (which may remove
more workspace artifacts). Non-empty rest is refused by `cmdClean` before this
runs (native has no Lake global rebind surface).

**TOCTOU residual (pre-existing):** `tryRemoveBuildDir` is a best-effort lstat
fence before `removeDirAll`, not an fd-based `O_NOFOLLOW` open. Concurrent
replace of `.lake` between checks and removal can still redirect wipe. -/
def cmdCleanNative (pkg : FilePath) : IO UInt32 := do
  match ← tryRemoveBuildDir pkg with
  | none =>
    return 1
  | some true =>
    IO.println "slake clean: OK"
    return 0
  | some false =>
    IO.println "slake clean: nothing to clean"
    return 0

/-- Freestanding Proc multi-arg path (`lake --dir=<pkg> clean` — **empty rest only**).

Child env is **empty** (freestanding `execve` honesty — not a host-env clone).
Returns process exit `0…255`, `fsSpawnFail`, or `fsWaitFail`. W91 FS_PROC clean.
CLAIMED stays `(build clean env)`; freestanding path delegates to `lake clean`
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

/-- `clean`: dual residual — native wipe `pkg/.lake/build` vs FS_PROC → `lake clean`.

**Native (default):** remove package `.lake/build` only. Bare package `build/` is
**not** removed (broader than Lake and unsafe for unrelated trees). Non-empty
rest is **refused** (clear error) — native has no argv surface for Lake globals.

**FS_PROC / PIPE:** with `SLAKE_USE_FS_PROC_PIPE=1` / `SLAKE_USE_FS_PROC=1`,
freestanding Proc paths (W91; same flags/empty-child-env honesty as peers).
**Empty rest only** so `--dir`/`-d`/`--file`/… cannot rebind the wipe target.
Lake `clean` may remove a wider workspace set than native `.lake/build` only —
documented dual residual, not a bug. STRICT refuses fall-back to native wipe
on unlinked/spawn fail; non-STRICT fall-back is native (still empty-rest gated).
CLAIMED stays `(build clean env)`. -/
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
    return code

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
CLAIMED envelope stays `(build clean env)` — check-build is residual honesty dual path only.
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
CLAIMED envelope stays `(build clean env)` — check-test is residual honesty dual path only. -/
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
Outside CLAIMED; CLAIMED stays `(build clean env)`. -/
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
CLAIMED envelope stays `(build clean env)` — check-lint is residual honesty dual path only. -/
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
  match ← resolveLakeAbs lake with
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
CLAIMED envelope stays `(build clean env)` — lean is residual honesty dual path only. -/
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
CLAIMED envelope stays `(build clean env)` — scripts is residual honesty dual path only. -/
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
CLAIMED envelope stays `(build clean env)` — new is residual honesty dual path only.
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
CLAIMED envelope stays `(build clean env)` — init is residual honesty dual path only.
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
CLAIMED envelope stays `(build clean env)` — serve is residual honesty dual path only. -/
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
CLAIMED envelope stays `(build clean env)` — upload is residual honesty dual path only. -/
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
CLAIMED envelope stays `(build clean env)` — translate-config is residual honesty dual path only.
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
CLAIMED envelope stays `(build clean env)` — run is residual honesty dual path only.
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

/-- Optionally print freestanding DepGraph demo plan before lake build.

`SLAKE_DEPGRAPH=1` + linked shim → print `slake depgraph plan: C B A` (demo graph
matching depgraph_wire; real lakefile multi-module parse remains residual).
Unlinked + flag → **intentional soft-skip**: warn and continue so default
parity stays green without extract (not a hard fail; `systems-validate` SCORE
does not run `depgraph_cli_smoke`). Topo/init fail → exit 1. Default (flag
unset) is a no-op. Smoke opt-in: `SLAKE_DEPGRAPH_SMOKE_STRICT=1` fails when the
smoke expects a linked plan path. -/
def maybePrintDepgraphPlan : IO (Option UInt32) := do
  let useDg ← envFlagTruthy "SLAKE_DEPGRAPH"
  if !useDg then
    return none
  let linked := slakeFsDepgraphLinked ()
  if linked != 1 then
    IO.eprintln "slake build: SLAKE_DEPGRAPH=1 but DEPGRAPH shim not linked; skipping plan"
    return none
  IO.println "slake build: SLAKE_DEPGRAPH=1; freestanding DepGraph Kahn topo (demo C→B→A)"
  IO.println "  (demo multi-module graph; not package lakefile parse — residual honesty)"
  let st := slakeFsDepgraphPrintPlan ()
  if st != 0 then
    IO.eprintln "slake build: freestanding DepGraph plan failed"
    return some 1
  return none

/-- `build`: classic-host MVP — delegate to `lake build` in the package dir.

Default: `IO.Process` → `lake build` (parity green without extract).
With `SLAKE_USE_FS_PROC_PIPE=1`: freestanding pipe/stdio `Systems.Proc` (stdout
capture demo; takes precedence over multi-arg when both set).
With `SLAKE_USE_FS_PROC=1`: freestanding multi-arg `Systems.Proc` via linked
shim (`slake_fs_proc.c` + extract bundle; remaining argv after `build` plumbed). On **spawn** fail only, fall back to
`IO.Process` unless `SLAKE_FS_PROC_STRICT=1`. Wait fail / lake exit never
retries via IO.Process. With `SLAKE_DEPGRAPH=1`: print freestanding DepGraph
demo plan first (then continue to lake). **Not** full Lake parity. -/
public def cmdBuild (rest : List String := []) : IO UInt32 := do
  let cwd ← IO.currentDir
  let pkg ← match ← findPackageDir cwd with
    | some p => pure p
    | none =>
      IO.eprintln "slake build: no package root found (plausible lakefile walk-up)"
      return 1
  let id ← Slake.Config.readPackageIdentity pkg
  IO.println s!"slake build: {Slake.Config.formatIdentity id}"
  match ← maybePrintDepgraphPlan with
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
CLAIMED envelope stays `(build clean env)` — setup-file is residual honesty dual path only. -/
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
CLAIMED envelope stays `(build clean env)` — self-check is residual honesty dual path only. -/
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
CLAIMED envelope stays `(build clean env)` — version-tags is residual honesty dual path only.
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
Outside CLAIMED; CLAIMED stays `(build clean env)`. -/
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
CLAIMED envelope stays `(build clean env)` — query-kind is residual honesty dual path only. -/
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
  match ← resolveLakeAbs lake with
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
Outside CLAIMED; CLAIMED stays `(build clean env)`. -/
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
CLAIMED envelope stays `(build clean env)` — resolve-deps is residual honesty dual path only. -/
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
  match ← resolveLakeAbs lake with
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
Outside CLAIMED; CLAIMED stays `(build clean env)`. -/
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
CLAIMED envelope stays `(build clean env)` — reservoir-config is residual honesty dual path only. -/
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
  match ← resolveLakeAbs lake with
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
Outside CLAIMED; CLAIMED stays `(build clean env)`. -/
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
CLAIMED envelope stays `(build clean env)` — exec is residual honesty dual path only.
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
  match ← resolveLakeAbs lake with
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
Outside CLAIMED; CLAIMED stays `(build clean env)`. -/
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
CLAIMED envelope stays `(build clean env)` — upgrade is residual honesty dual path only.
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
  match ← resolveLakeAbs lake with
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
