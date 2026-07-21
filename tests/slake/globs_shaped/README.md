# globs_shaped (A24/A25 per-lib globs plan dogfood)

Minimal package for **per-`[[lean_lib]]` `globs`** plan expansion + path resolution.

- No `defaultTargets` — plan modules expand from `globs = ["Core.*"]`
- No package-level `srcDir` — modules live under per-lib `srcDir = "lib"`
- `lib/Core.lean` + `lib/Core/Extra.lean` + `lib/Core/Nested/Deep.lean`
  → plan `globs_shaped Core Core.Extra Core.Nested.Deep`
- `Core.Extra` imports `Core`; `Core.Nested.Deep` imports `Core.Extra`
  → import-scan order Core before Extra before Nested.Deep
- Recursive multi-level confining walk (A25), depth-bounded — **not** full Lake
  Glob / faceting / package imports / freestanding build TCB / CLAIMED

Smoke: `../globs_plan_smoke.sh` (`SLAKE_GLOBS_PLAN_SMOKE_STRICT=1`).
