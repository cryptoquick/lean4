# srcdir_shaped — A6 srcDir / nested / dotted dogfood

Minimal multi-target package whose Lean sources live under `src/` (`srcDir = "src"`
in `lakefile.toml`), not at the package root.

* Declaration order: `defaultTargets = ["Host", "Foo.Bar"]` (Host first).
* `src/Host.lean` does `meta import Foo.Bar` — import-scan + **srcDir** + **dotted**
  resolution (`Foo.Bar` → `src/Foo/Bar.lean`) must place **Foo.Bar** before Host.
* Exercises: package-level `srcDir`, multi-segment module path, `meta import` keyword.
* Without srcDir-aware path resolution, plan falls back to declaration-order chain
  (`Host` before `Foo.Bar`) because package-root modules are absent.

Used by `tests/slake/srcdir_plan_smoke.sh`.
