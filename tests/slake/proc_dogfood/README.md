# Slake freestanding `Systems.Proc` dogfood

Small C binary that **links** the freestanding product archive (`libfs_extract_bundle.a`)
and calls `lean_fs_proc_spawn` / `lean_fs_proc_spawn_argv` / `lean_fs_proc_spawn_argv_pipe` /
`lean_fs_proc_pipe` / `lean_fs_proc_wait` on `/bin/true`, multi-arg `/bin/sh -c true`, and
pipe-redirected `/bin/echo hi`.

This is residual-honest proof that freestanding Proc (including multi-arg argv tables and
pipe/stdio redirect) is available for Slake tool spawn. The classic-host `slake` CLI
(`tests/slake/driver`) still uses `IO.Process` → `lake build` by default.

```bash
# Build product extract first (if needed):
make -C tests/lake/examples/systems -j"$(nproc)" lake

# Run dogfood:
make -C tests/slake/proc_dogfood check
# or:
make -C tests/lake/examples/systems check-slake-proc-dogfood
```

Honesty:

* argv0-only, multi-arg, and pipe/stdout redirect freestanding spawn available
* empty child env; no PATH search (`execve` path must be absolute or relative)
* parent closes unused pipe ends; reads child stdout via `lean_fs_read` on the pipe read end
* optional soft `lake --version` when `command -v lake` yields an absolute path
* not freestanding TCB for the whole Slake CLI; classic CLI still `IO.Process`
