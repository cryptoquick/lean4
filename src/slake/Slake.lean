/-
Copyright (c) 2026 Hunter Beast. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Hunter Beast
-/
module

import Slake.CLI
import Slake.Config

/-!
# Slake

Root public surface for the **Systems Lean** twin of Lake.

This module is the classic-host import root for the Slake driver as it grows.
Freestanding residual-green product cores (dep graph, TOML subset, traces,
cache index, proc spawn, …) live under `Systems.*` and are not re-exported here
until the driver needs them on the classic path.

## Phase 2 MVP status (through W107) (honest residual)

* CLI: `Slake.CLI` — CLAIMED `build` / `clean` / `env`; classic thin forwards
  `test` / `script` / `exe` / `lint` / `check-build` / `check-test` / `check-lint` / `query` / `shake` / `update` / `pack` / `unpack` / `cache` / `lean` / `scripts` / `new` / `init` / `serve` / `upload` / `translate-config` / `run` / `setup-file` / `self-check` / `version-tags` / `query-kind` / `resolve-deps` / `reservoir-config` / `exec` / `upgrade` (outside CLAIMED); `--help` / `--version`
  (classic host: `build` delegates to `lake build`; thin forwards →
  `lake …` via `IO.Process` default; optional FS_PROC/PIPE for
  `build` / `test` / `exe` / `lint` / `script` / `clean` / `update` / `pack` / `cache` / `unpack` / `query` / `shake` / `serve` / `upload` / `lean` / `scripts` / `setup-file` / `self-check` / `version-tags` / `translate-config` / `run` / `new` / `init` / `check-build` — clean is empty-rest-only dual residual; pack/cache/unpack/query/shake/serve/upload/lean/scripts/setup-file/self-check/version-tags/translate-config/run/check-build chdir(pkg) + resolveLakeAbs pre-chdir; `new`/`init` chdir(cwd) bootstrap (no package walk-up) + resolveLakeAbs pre-chdir;
  freestanding `Systems.Proc` dogfood at `tests/slake/proc_dogfood`; pipe freestanding shipped;
  classic CLI residual).
  CLAIMED parity slice remains `build` / `clean` / `env` only.
* Config notes: `Slake.Config` — points at freestanding TOML/manifest cores.
* Binary: build via `tests/slake/driver` (`lake build` → `.lake/build/bin/slake`).
  Not installed with stage1 by default.

See `doc/dev/slake.md` and `src/slake/README.md`.
-/

-- Re-export driver namespaces for `import Slake`.
-- (Imports above pull CLI + Config; freestanding product stays under Systems.*)
