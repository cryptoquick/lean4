# Lake ↔ Slake parity packages

Golden trees for behavioral parity between **lake** (classic) and **slake** (Systems).

## Packages

| Dir | Purpose |
|-----|---------|
| `basic_toml/` | Minimal TOML package: one lib root, test driver exe, no git deps |

## Runner

```bash
# From repo root (stage1 lake on PATH recommended)
# Build classic-host slake first:
cd tests/slake/driver && lake build && cd -

SLAKE_BIN="$PWD/tests/slake/driver/.lake/build/bin/slake" \
  ./tests/slake/parity/run_parity.sh
```

Exit:

- `0` — claimed checks green (lake+slake with artifacts, or slake SKIP if no binary)
- non-zero — lake fail or slake fail when present

See `run_parity.sh` for the claimed command list (`build` / `clean` / `env` / `test`). Honest residual: classic host `slake` delegates claimed `build`/`test` (and thin forwards) to `lake`; native `clean` is dual residual; not freestanding TCB.
