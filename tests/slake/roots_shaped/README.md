# roots_shaped (A16 per-lib roots + srcDir dogfood)

Minimal package for **per-`[[lean_lib]]` `roots` / `srcDir`** plan + path resolution.

- No `defaultTargets` — plan modules expand from lib `roots = ["Alpha", "Beta"]`
- No package-level `srcDir` — modules live under per-lib `srcDir = "lib"`
- `lib/Beta.lean` imports `Alpha` → import-scan plan `roots_shaped Alpha Beta`
- Not full Lake faceting / globs / package imports

Smoke: `../roots_plan_smoke.sh` (`SLAKE_ROOTS_PLAN_SMOKE_STRICT=1`).
