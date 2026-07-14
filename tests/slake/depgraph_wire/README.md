# Slake freestanding `DepGraph` wire dogfood

Small C binary that **links** the freestanding product archive and builds a three-module
dependency DAG (`A` depends on `B` depends on `C`), runs `lean_fs_depgraph_topo`, and
prints the planned build order (`C B A`).

This is residual-honest proof that freestanding `DepGraph` is available for Slake
build-order planning. Classic-host `slake` may still use `IO.Process` → `lake`; wiring
DepGraph into the CLI planner remains a residual path.

```bash
make -C tests/lake/examples/systems -j"$(nproc)" lake
make -C tests/slake/depgraph_wire check
# or:
make -C tests/lake/examples/systems check-slake-depgraph-wire
```

Honesty:

* fixed-cap Kahn topo only (not a general graph library)
* demo graph is hard-coded (not lakefile parse)
* proves extract exports are linkable for build-order planning
