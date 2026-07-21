# require_sibling_shaped (A29)

Monorepo-style sibling path `[[require]]`: package `app` requires
`path = "../dep"` (sibling under the fixture parent confining root).

```
require_sibling_shaped/
  app/          — consumer (path = "../dep")
  dep/          — path-dep package
```

`App.lean` imports `Dep`. A26 LEAN_PATH + path-dep olean precompile must resolve
the sibling path under the package parent and produce oleans under both packages.

Honesty: **sibling confining `../path` subset** (exactly one leading `..` + ≥1
safe components; package-parent confining root; real-dir lstat fence) — not
multi-`..` escape / not bare `..` / not absolute / not git/url / not Lake
resolve-deps / not workspace multi-level
walk-up / not freestanding build TCB / not CLAIMED.

Smoke: `tests/slake/require_sibling_smoke.sh` (STRICT via
`SLAKE_REQUIRE_SIBLING_SMOKE_STRICT=1`).
