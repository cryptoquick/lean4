# systems_shaped

Tiny multi-target TOML package used by `tests/slake/systems_plan_smoke.sh` and
`tests/slake/import_dag_smoke.sh` to dogfood package-derived `slake` DepGraph
plans (`SLAKE_DEPGRAPH` / `SLAKE_PLAN_ONLY`) against a Systems-shaped layout.

* `defaultTargets = ["Host", "Core"]` — declaration order puts **Host** first.
* `Host.lean` does `import Core` — import-scan DAG must place **Core** before Host.

Not freestanding product TCB. Not full Lake parity. Import scan is a fail-closed
top-level line subset (not full Lake module faceting).
