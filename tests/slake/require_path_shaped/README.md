# require_path_shaped (A26 + A27 + A28)

Root package `require_path_shaped` has a path `[[require]]` of `dep` and
`App.lean` imports `Dep`. Path-require LEAN_PATH + path-dep olean precompile
must make `SLAKE_NATIVE_OLEAN` / `SLAKE_NATIVE_BUILD` succeed. A27: content-edit
or newer path-dep olean cascades root `App` rebuild (`path-dep-olean-newer`).
A28: path-dep `Dep` source hash folds into App's A11 `deps <hex>` (deps-line-stale
when Dep source changes even if Dep.olean is not newer).

Honesty: path `[[require]]` + path-dep → root cascade + path-dep deps-hash fold
subset only (A26 safe under-pkg relative path; A29 sibling confining `../dep`
is a separate fixture) — not absolute / multi-`..` escape / git/url — not Lake
resolve-deps / not Lake package-transitive
hash / not freestanding build TCB / not CLAIMED.
