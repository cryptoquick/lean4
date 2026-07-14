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
| `env` | Both can print/export a usable env (Slake may be subset) |

Build the driver first:

```bash
export PATH="$PWD/build/release/stage1/bin:${PATH:-}"
cd tests/slake/driver && lake build
SLAKE_BIN="$PWD/.lake/build/bin/slake" ../parity/run_parity.sh
```

`run_parity.sh` behavior:

1. Run `lake <cmd>` and record status/artifacts.
2. If `slake` is missing, exit **SKIP** (not FAIL) with a clear message.
3. When `slake` is present and non-stub, require exit 0 **and** `.lake/build` after `build` (before final clean); clean must remove `.lake/build` only.

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
stays `(build clean env)`; classic path still inherits host env while FS_PROC child env is empty. Standalone dogfood also remains:

```bash
make -C tests/lake/examples/systems -j"$(nproc)" lake   # product extract if needed
cd tests/slake/driver && lake build
make -C tests/slake/proc_dogfood check
SLAKE_USE_FS_PROC=1 ./tests/slake/fs_proc_smoke.sh
# or: make -C tests/lake/examples/systems check-slake-proc-dogfood
```

## Freestanding DepGraph CLI plan

With `SLAKE_DEPGRAPH=1`, classic `slake build` prints a freestanding `DepGraph`
Kahn topo plan (demo multi-module `C B A`, same honesty as `depgraph_wire`) before
delegating to lake. Default path (flag unset) stays parity-green.

**SCORE honesty:** `systems-validate` / SCORE does **not** run this smoke or
`run_parity.sh`. Soft SKIP when the driver is unlinked is intentional (parity-
preserving); use `SLAKE_DEPGRAPH_SMOKE_STRICT=1` for hard fail when a linked plan
path is expected.

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
