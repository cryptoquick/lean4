# require_path_nested_shaped

A31 nested path-dep ModRel fixture: root `App` imports path-require
`Foo.Bar` under `dep/Foo/Bar.lean`. Exercises `pathDepOutDir` strip of
`moduleOleanRel` so C/OBJ land at `dep/.slake-native/Foo/Bar.{c,o}`
(not `…/Foo/Foo/Bar.*`).

Not a full Lake lean_lib facet / not freestanding build TCB / not CLAIMED.
