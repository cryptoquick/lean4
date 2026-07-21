# multiline_roots_shaped (A18 multi-line roots dogfood)

Minimal package for **multi-line** per-`[[lean_lib]]` `roots` array parse (A18)
plus per-lib `srcDir` plan resolution (A16).

- No `defaultTargets` — plan modules expand from multi-line
  ```toml
  roots = [
    "Alpha",
    "Beta",
  ]
  ```
- No package-level `srcDir` — modules live under per-lib `srcDir = "lib"`
- `lib/Beta.lean` imports `Alpha` → import-scan plan `multiline_roots_shaped Alpha Beta`
- Not full TOML multi-line tables / Lake faceting / globs / package imports

Smoke: `../multiline_roots_plan_smoke.sh` (`SLAKE_MULTILINE_ROOTS_PLAN_SMOKE_STRICT=1`).
