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
    Config.lean      — host-side config notes (points at Systems.TomlConfig / Manifest)

tests/slake/driver/  — Lake package that builds the runnable `slake` binary
```

Freestanding **product math** (dep graph, TOML subset, traces, cache index, hashes, path views, proc spawn) lives under `src/Systems/` as residual-green `*Lite` modules and is linked through the Systems product matrix (`tests/lake/examples/systems/`). The Slake driver orchestrates those cores and (today) delegates package builds to classic `lake`.

## Phase 2 MVP status (honest residual)

| Piece | Status |
|-------|--------|
| CLI CLAIMED `build` / `clean` / `env` | **Wired** on classic host (`Slake.CLI`) — not freestanding TCB; default parity slice |
| CLI thin forwards `test` / `script` / `exe` / `lint` / `check-build` (optional FS_PROC/PIPE W109; chdir+resolveLakeAbs) / `check-test` (optional FS_PROC/PIPE W110; chdir+resolveLakeAbs) / `check-lint` / `query` (optional FS_PROC/PIPE W96) / `shake` (optional FS_PROC/PIPE W97) / `serve` (optional FS_PROC/PIPE W98; chdir+resolveLakeAbs; rest may rebind) / `update` (optional FS_PROC/PIPE W92) / `pack` (optional FS_PROC/PIPE W93) / `unpack` (optional FS_PROC/PIPE W95) / `cache` (optional FS_PROC/PIPE W94) / `upload` (optional FS_PROC/PIPE W99; chdir+resolveLakeAbs; rest may rebind) / `lean` (optional FS_PROC/PIPE W100; chdir+resolveLakeAbs; rest may rebind) / `scripts` (optional FS_PROC/PIPE W101; chdir+resolveLakeAbs; rest may rebind) / `setup-file` (optional FS_PROC/PIPE W102; chdir+resolveLakeAbs; rest may rebind) / `self-check` (optional FS_PROC/PIPE W103; chdir+resolveLakeAbs; rest may rebind) / `new` (optional FS_PROC/PIPE W107; cwd bootstrap; chdir(cwd); resolveLakeAbs) / `init` (optional FS_PROC/PIPE W108) / `check-build` (optional FS_PROC/PIPE W109; chdir+resolveLakeAbs) / `translate-config` (optional FS_PROC/PIPE W105; chdir+resolveLakeAbs; rest may rebind) / `run` (optional FS_PROC/PIPE W106; chdir+resolveLakeAbs; rest may rebind) / `version-tags` (optional FS_PROC/PIPE W104; chdir+resolveLakeAbs; rest may rebind) / `query-kind` (optional FS_PROC/PIPE W113; chdir+resolveLakeAbs) / `resolve-deps` (optional FS_PROC/PIPE W114; chdir+resolveLakeAbs) / `reservoir-config` (optional FS_PROC/PIPE W115; chdir+resolveLakeAbs) / `exec` / `upgrade` | **Wired** → real Lake names via `IO.Process` default; `test` optional FS_PROC/PIPE (W87); `exe` optional FS_PROC/PIPE (W88); `lint` optional FS_PROC/PIPE (W89); `script` optional FS_PROC/PIPE (W90); `update` optional FS_PROC/PIPE (W92) — thin forwards **outside CLAIMED** (Lake has no bare `check`). CLAIMED stays `(build clean env)` (W107: `new` dual residual outside CLAIMED; cwd bootstrap); `clean` FS_PROC/PIPE dual residual is on the CLAIMED row, not a thin-forward. |
| `build` spawn path | **Default:** `IO.Process` → `lake build`. **Optional:** `SLAKE_USE_FS_PROC=1` freestanding multi-arg `Systems.Proc`; `SLAKE_USE_FS_PROC_PIPE=1` freestanding pipe/stdio stdout capture demo (Option C shim + extract; empty child env). `SLAKE_FS_PROC_STRICT=1` disables fall back. Dogfood: `tests/slake/proc_dogfood`; smokes: `fs_proc_smoke.sh` / `fs_proc_pipe_smoke.sh` |
| `test` spawn path | **Default:** `IO.Process` → `lake test` (outside CLAIMED). **Optional (W87):** same `SLAKE_USE_FS_PROC=1` / `SLAKE_USE_FS_PROC_PIPE=1` / `STRICT` flags as build (empty child env; freestanding multi-arg / pipe). Smokes: `fs_proc_smoke.sh` / `fs_proc_pipe_smoke.sh` test bands |
| `exe` spawn path | **Default:** `IO.Process` → `lake exe` (outside CLAIMED). **Optional (W88):** same FS_PROC/PIPE/STRICT flags as build/test (empty child env). Smokes: `fs_proc_smoke.sh` / `fs_proc_pipe_smoke.sh` exe bands |
| `lint` spawn path | **Default:** `IO.Process` → `lake lint` (outside CLAIMED). **Optional (W89):** same FS_PROC/PIPE/STRICT flags as build/test/exe (empty child env). Smokes: `fs_proc_smoke.sh` / `fs_proc_pipe_smoke.sh` lint bands |
| `script` spawn path | **Default:** `IO.Process` → `lake script` (outside CLAIMED). **Optional (W90):** same FS_PROC/PIPE/STRICT flags as build/test/exe/lint (empty child env). Smokes: `fs_proc_smoke.sh` / `fs_proc_pipe_smoke.sh` script bands |
| `update` spawn path | **Default:** classic `IO.Process` → `lake update` (rest plumbed). **Optional (W92):** FS_PROC/PIPE → `lake update` (empty child env; rest plumbed; **not** empty-rest-only; outside CLAIMED). Smokes: update bands in `fs_proc_smoke.sh` / `fs_proc_pipe_smoke.sh`. |
| `pack` spawn path | **Default:** classic `IO.Process` → `lake pack` (`cwd=pkg`; rest plumbed). **Optional (W93):** FS_PROC/PIPE → `lake pack` (empty child env; **chdir(pkg)** so relative archive args match classic; rest plumbed — **not** empty-rest-only; outside CLAIMED). Bare pack may exit nonzero without prior `buildDir` artifacts — freestanding banner + no fall-back still counts as true dual-residual path. Smokes: pack bands in `fs_proc_smoke.sh` / `fs_proc_pipe_smoke.sh` (incl. relative archive parity). |
| `unpack` spawn path | **Default:** classic `IO.Process` → `lake unpack` (`cwd=pkg`; rest plumbed). **Optional (W95):** FS_PROC/PIPE → `lake unpack` (empty child env; **chdir(pkg)** so relative path args match classic; **resolveLakeAbs pre-chdir**; rest plumbed — **not** empty-rest-only; outside CLAIMED). Smokes: unpack bands in `fs_proc_smoke.sh` / `fs_proc_pipe_smoke.sh` (incl. cwd-parity / STRICT-negative / relative-path honesty).
| `query` spawn path | **Default:** classic `IO.Process` → `lake query` (`cwd=pkg`; rest plumbed). **Optional (W96):** FS_PROC/PIPE → `lake query` (empty child env; **chdir(pkg)** so relative path args match classic; **resolveLakeAbs pre-chdir**; rest plumbed — **not** empty-rest-only; outside CLAIMED). Smokes: query bands in `fs_proc_smoke.sh` / `fs_proc_pipe_smoke.sh` (incl. empty-rest / help / cwd-parity / STRICT-negative).
| `shake` spawn path | **Default:** classic `IO.Process` → `lake shake` (`cwd=pkg`; rest plumbed). **Optional (W97):** FS_PROC/PIPE → `lake shake` (empty child env; **chdir(pkg)** so relative path args match classic; **resolveLakeAbs pre-chdir**; rest plumbed — **not** empty-rest-only; outside CLAIMED). Smokes: shake bands in `fs_proc_smoke.sh` / `fs_proc_pipe_smoke.sh` (incl. empty-rest / help / cwd-parity / STRICT-negative). |
| `serve` spawn path | **Default:** classic `IO.Process` → `lake serve` (`cwd=pkg`; rest plumbed). **Optional (W98):** FS_PROC/PIPE → `lake serve` (empty child env; **chdir(pkg)** so relative path args match classic; **resolveLakeAbs pre-chdir**; rest plumbed — **not** empty-rest-only; rest may rebind Lake globals; outside CLAIMED; CLAIMED stays `(build clean env)`). Smokes: serve bands in `fs_proc_smoke.sh` / `fs_proc_pipe_smoke.sh` (incl. empty-rest / help / cwd-parity multi-arg / STRICT-negative; PIPE has no dedicated cwd-parity band — same as query/shake). |
| `upload` spawn path | **Default:** classic `IO.Process` → `lake upload` (`cwd=pkg`; rest plumbed). **Optional (W99):** FS_PROC/PIPE → `lake upload` (empty child env; **chdir(pkg)** so relative path args match classic; **resolveLakeAbs pre-chdir**; rest plumbed — **not** empty-rest-only; outside CLAIMED; CLAIMED stays `(build clean env)`). Smokes: upload bands in `fs_proc_smoke.sh` / `fs_proc_pipe_smoke.sh` (incl. empty-rest / help / cwd-parity multi-arg / STRICT-negative; PIPE has no dedicated cwd-parity band — same as query/shake/serve). |
| `lean` spawn path | **Default:** classic `IO.Process` → `lake lean` (`cwd=pkg`; rest plumbed). **Optional (W100):** FS_PROC/PIPE → `lake lean` (empty child env; **chdir(pkg)** so relative path args match classic; **resolveLakeAbs pre-chdir**; rest plumbed — **not** empty-rest-only; outside CLAIMED; CLAIMED stays `(build clean env)`). Smokes: lean bands in `fs_proc_smoke.sh` / `fs_proc_pipe_smoke.sh` (incl. empty-rest / help / cwd-parity / STRICT-negative). |
| `scripts` spawn path | **Default:** classic `IO.Process` → `lake scripts` (`cwd=pkg`; rest plumbed). **Optional (W101):** FS_PROC/PIPE → `lake scripts` (empty child env; **chdir(pkg)** so relative path args match classic; **resolveLakeAbs pre-chdir**; rest plumbed — **not** empty-rest-only; outside CLAIMED; CLAIMED stays `(build clean env)`). Smokes: scripts bands in `fs_proc_smoke.sh` / `fs_proc_pipe_smoke.sh` (incl. empty-rest / help / cwd-parity / STRICT-negative). |
| `version-tags` spawn path | **Default:** classic `IO.Process` → `lake version-tags` (`cwd=pkg`; rest plumbed). **Optional (W104):** FS_PROC/PIPE → `lake version-tags` (empty child env; **chdir(pkg)** so relative path args match classic; **resolveLakeAbs pre-chdir**; rest plumbed — **not** empty-rest-only; outside CLAIMED; CLAIMED stays `(build clean env)`). Smokes: version-tags bands in `fs_proc_smoke.sh` / `fs_proc_pipe_smoke.sh` (incl. empty-rest / help / cwd-parity / STRICT-negative). |
| `translate-config` spawn path | **Default:** classic `IO.Process` → `lake translate-config` (`cwd=pkg`; rest plumbed). **Optional (W105):** FS_PROC/PIPE → `lake translate-config` (empty child env; **chdir(pkg)** so relative path args match classic; **resolveLakeAbs pre-chdir**; rest plumbed — **not** empty-rest-only; outside CLAIMED; CLAIMED stays `(build clean env)`). Smokes: translate-config bands in `fs_proc_smoke.sh` / `fs_proc_pipe_smoke.sh` (when present). |
| `run` spawn path | **Default:** classic `IO.Process` → `lake run` (`cwd=pkg`; rest plumbed; Lake shorthand for `script run`). **Optional (W106):** FS_PROC/PIPE → `lake run` (empty child env; **chdir(pkg)** so relative path args match classic; **resolveLakeAbs pre-chdir**; rest plumbed — **not** empty-rest-only; outside CLAIMED; CLAIMED stays `(build clean env)`). Smokes: run bands in `fs_proc_smoke.sh` / `fs_proc_pipe_smoke.sh` (when present). |
| `new` spawn path | **Default:** classic `IO.Process` → `lake new` (cwd bootstrap — no package walk-up; rest plumbed). **Optional (W107):** FS_PROC/PIPE → `lake new` (empty child env; **chdir(cwd)** bootstrap — no package walk-up; **resolveLakeAbs pre-chdir**; rest plumbed — **not** empty-rest-only; outside CLAIMED; CLAIMED stays `(build clean env)`). Smokes: new bands in `fs_proc_smoke.sh` / `fs_proc_pipe_smoke.sh` (when present). |
| `init` spawn path | **Default:** classic `IO.Process` → `lake init` (cwd bootstrap — no package walk-up; rest plumbed). **Optional (W108):** FS_PROC/PIPE → `lake init` (empty child env; **chdir(cwd)** bootstrap — no package walk-up; **resolveLakeAbs pre-chdir**; rest plumbed — **not** empty-rest-only; outside CLAIMED; CLAIMED stays `(build clean env)`). Smokes: init bands in `fs_proc_smoke.sh` / `fs_proc_pipe_smoke.sh` (when present). |
| `check-build` spawn path | **Default:** classic `IO.Process` → `lake check-build` (`cwd=pkg`; rest plumbed). **Optional (W109):** FS_PROC/PIPE → `lake check-build` (empty child env; **chdir(pkg)** so relative path args match classic; **resolveLakeAbs pre-chdir**; rest plumbed — **not** empty-rest-only; outside CLAIMED; CLAIMED stays `(build clean env)`). |
| `self-check` spawn path | **Default:** classic `IO.Process` → `lake self-check` (`cwd=pkg`; rest plumbed). **Optional (W103):** FS_PROC/PIPE → `lake self-check` (empty child env; **chdir(pkg)** so relative path args match classic; **resolveLakeAbs pre-chdir**; rest plumbed — **not** empty-rest-only; outside CLAIMED; CLAIMED stays `(build clean env)`). Smokes: self-check bands in `fs_proc_smoke.sh` / `fs_proc_pipe_smoke.sh` (incl. empty-rest / help / cwd-parity / STRICT-negative). |
| `setup-file` spawn path | **Default:** classic `IO.Process` → `lake setup-file` (`cwd=pkg`; rest plumbed). **Optional (W102):** FS_PROC/PIPE → `lake setup-file` (empty child env; **chdir(pkg)** so relative path args match classic; **resolveLakeAbs pre-chdir**; rest plumbed — **not** empty-rest-only; outside CLAIMED; CLAIMED stays `(build clean env)`). Smokes: setup-file bands in `fs_proc_smoke.sh` / `fs_proc_pipe_smoke.sh` (incl. empty-rest / help / cwd-parity / STRICT-negative). |
| `cache` spawn path | **Default:** classic `IO.Process` → `lake cache` (`cwd=pkg`; rest plumbed). **Optional (W94):** FS_PROC/PIPE → `lake cache` (empty child env; **chdir(pkg)** so relative path args match classic; rest plumbed — **not** empty-rest-only; outside CLAIMED). Smokes: cache bands in `fs_proc_smoke.sh` / `fs_proc_pipe_smoke.sh` (incl. cwd-parity / relative-path honesty after BUG-1 absolute lake resolve). |
| `clean` spawn path | **Default (CLAIMED):** native wipe `pkg/.lake/build` only (**empty-rest-only** — non-empty rest refused). **Optional (W91):** FS_PROC/PIPE → `lake clean` (Lake clean semantics; may wipe more than `.lake/build`; **empty-rest-only**; empty child env; CLAIMED token dual residual). Smokes: clean bands in `fs_proc_smoke.sh` / `fs_proc_pipe_smoke.sh`. |
| `build` depgraph plan | **Optional:** `SLAKE_DEPGRAPH=1` prints freestanding `DepGraph` Kahn topo plan (demo `C B A`) before lake build (Option C `slake_fs_depgraph.c` + extract). Real lakefile multi-module parse remains residual. Unlinked + flag → soft-skip warn (parity-preserving). Smoke: `tests/slake/depgraph_cli_smoke.sh` (soft SKIP without linked driver; `SLAKE_DEPGRAPH_SMOKE_STRICT=1` hard-fails). **SCORE alone does not prove this smoke** (`systems-validate` does not run it). |
| `clean` (semantics) | **Native:** removes package **`pkg/.lake/build` only** (not bare `build/`; not full Lake clean); best-effort `lstat` symlink fence on `.lake` / `.lake/build` (TOCTOU residual; not fd/`O_NOFOLLOW`). **FS_PROC/PIPE:** delegates to `lake clean` (Lake’s clean set). Both paths: empty rest only. |
| Package walk-up | Nearest plausible root; rejects bare monorepo `tests/lakefile.toml` |
| Config notes | **Shipped** (`Slake.Config`) — freestanding decode stays in `Systems.*` |
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
SLAKE_USE_FS_PROC=1 ./.lake/build/bin/slake test    # freestanding Proc for test (W87; not CLAIMED)
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
SLAKE_DEPGRAPH=1 ./.lake/build/bin/slake build      # freestanding DepGraph plan then lake
./.lake/build/bin/slake clean        # native: removes package .lake/build only (empty rest)
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

Parity harness (default IO.Process path; **CLAIMED** = `build`/`clean`/`env` only — `slake test`/`script`/`exe`/`lint`/`check-build` (optional FS_PROC/PIPE W109)/`check-test` (optional FS_PROC/PIPE W110)/`check-lint`/`query`/`shake`/`update`/`pack`/`unpack`/`cache`/`lean`/`scripts`/`new`/`init`/`serve`/`upload`/`translate-config` (optional FS_PROC/PIPE W105)/`run` (optional FS_PROC/PIPE W106)/`setup-file` (optional FS_PROC/PIPE W102)/`self-check` (optional FS_PROC/PIPE W103)/`version-tags` (optional FS_PROC/PIPE W104)/`query-kind`/`resolve-deps`/`reservoir-config`/`exec`/`upgrade` (optional FS_PROC/PIPE W116) are CLI-wired (dispatch-level residual; **no** dedicated CLI smoke harness) but **not** claimed-slice until `Slake_parity_more` grows the harness):

```bash
SLAKE_BIN="$PWD/tests/slake/driver/.lake/build/bin/slake" \
  ./tests/slake/parity/run_parity.sh
# → OK: lake and slake claimed slice (build clean env) with build artifacts

# FS_PROC true-green smoke (requires linked extract):
SLAKE_USE_FS_PROC=1 ./tests/slake/fs_proc_smoke.sh
SLAKE_USE_FS_PROC_PIPE=1 ./tests/slake/fs_proc_pipe_smoke.sh

# DEPGRAPH plan smoke (requires linked extract; soft SKIP if unlinked):
SLAKE_DEPGRAPH=1 ./tests/slake/depgraph_cli_smoke.sh
# hard-fail if binary/shim missing (CI opt-in):
SLAKE_DEPGRAPH_SMOKE_STRICT=1 ./tests/slake/depgraph_cli_smoke.sh
```

**Honesty:** `./script/systems-validate.sh` SCORE does **not** run `run_parity.sh` or
`depgraph_cli_smoke.sh`. Green SCORE proves product residual gates, not classic
Slake DepGraph CLI wiring.


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
