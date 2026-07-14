/* Classic-host slake helper: freestanding Systems.Proc multi-arg spawn for `lake build`/`lake test` (+ rest).
 *
 * Linked into the slake driver with libfs_extract_bundle.a (Option C).
 * Lean ABI: String args are b_lean_obj_arg; uses lean_string_cstr.
 * Optional rest argv is a Lean Array of String (b_lean_obj_arg); may be null/empty.
 *
 * Env: SLAKE_USE_FS_PROC=1 selects multi-arg path from Slake.CLI; default remains IO.Process.
 *      SLAKE_USE_FS_PROC_PIPE=1 selects pipe/stdio capture path (stdout → parent pipe).
 * CLAIMED stays (build clean env); rest tokens are lake cmd targets/flags only — no shell.
 * W91: FS_PROC also covers `clean` (CLAIMED token; dual residual optional freestanding).
 * W87: FS_PROC also covers `test` (same empty child env honesty as build).
 */
#define _POSIX_C_SOURCE 200809L
#include <lean/lean.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>

extern size_t lean_fs_proc_spawn_argv(size_t path, size_t argv_base, size_t argc);
extern size_t lean_fs_proc_spawn_argv_pipe(size_t path, size_t argv_base, size_t argc,
                                           size_t stdin_fd, size_t stdout_fd);
extern uint32_t lean_fs_proc_pipe(size_t pipe_fds);
extern uint32_t lean_fs_proc_close_raw(size_t fd);
extern uint32_t lean_fs_proc_wait(size_t pid);
extern uint32_t lean_fs_proc_pid_is_neg(size_t pid);
/* Systems.Sys read over raw fd (ABI size_t ≡ Fd). */
extern size_t lean_fs_read(size_t fd, size_t buf, size_t n);

/* Spawn failure / bad args (distinct from 8-bit exit and wait fail). */
#define SLAKE_FS_SPAWN_FAIL ((uint32_t)0xFFFFFFFFu)
/* Wait failure from lean_fs_proc_wait (maps freestanding waitFail). */
#define SLAKE_FS_WAIT_FAIL ((uint32_t)0xFFFFFFFEu)
/* Freestanding Proc waitFail uses the same 0xFFFFFFFF as spawn; remap after spawn. */
#define LEAN_FS_PROC_WAIT_FAIL ((uint32_t)0xFFFFFFFFu)
/* fdNone / negative → no redirect (matches Systems.Proc). */
#define FS_PROC_FD_NONE ((size_t)-1)

/* Max rest tokens plumbed after `build` (fixed stack argv; fail-closed if exceeded). */
#define SLAKE_FS_MAX_REST 64
/* argv = [lake, --dir=…, build, rest…] */
#define SLAKE_FS_MAX_ARGV (3 + SLAKE_FS_MAX_REST)

/*
 * Fill argv[0..*argc_out) with lake, --dir=<pkg>, <cmd>, + rest String array.
 * Returns 0 on success, -1 on fail. dirarg must be writable buffer for --dir=.
 * cmd is a fixed C string literal (e.g. "build" / "test") — not from rest.
 */
static int slake_fs_fill_cmd_argv(const char *pkg, const char *lake, const char *cmd,
                                  b_lean_obj_arg rest_a,
                                  char *dirarg, size_t dirarg_sz,
                                  size_t *argv, size_t argv_cap, size_t *argc_out) {
  size_t nrest = 0;
  size_t i;
  int n;

  if (pkg == 0 || lake == 0 || cmd == 0 || pkg[0] == '\0' || lake[0] == '\0' || cmd[0] == '\0')
    return -1;
  /* Require true absolute lake path (leading '/'). Freestanding execve does not
   * search PATH. Relative paths that merely contain '/' (./lake, bin/lake) are
   * rejected here — Slake.CLI.resolveLakeAbs must absolutize against pre-chdir
   * cwd before pack/cache/unpack/query/shake/serve/upload/lean/scripts/setup-file/self-check/version-tags/translate-config/run/new chdir(pkg-or-cwd) (BUG-1 / S2 dual-residual honesty). */
  if (lake[0] != '/')
    return -1;

  n = snprintf(dirarg, dirarg_sz, "--dir=%s", pkg);
  if (n < 0 || (size_t)n >= dirarg_sz)
    return -1;

  /* Fail-closed on ABI misuse: non-null rest must be a Lean array (empty OK). */
  if (rest_a != 0 && !lean_is_array(rest_a))
    return -1;
  if (rest_a != 0)
    nrest = lean_array_size(rest_a);
  if (nrest > SLAKE_FS_MAX_REST) {
    fprintf(stderr,
            "slake_fs_proc: rest argv exceeds max %d tokens (fail-closed; no shell)\n",
            SLAKE_FS_MAX_REST);
    return -1;
  }
  if (3 + nrest > argv_cap)
    return -1;

  argv[0] = (size_t)(uintptr_t)lake;
  argv[1] = (size_t)(uintptr_t)dirarg;
  argv[2] = (size_t)(uintptr_t)cmd;
  for (i = 0; i < nrest; i++) {
    lean_object *s = lean_array_get_core(rest_a, i);
    const char *cstr;
    if (s == 0 || !lean_is_string(s))
      return -1;
    cstr = lean_string_cstr(s);
    if (cstr == 0)
      return -1;
    argv[3 + i] = (size_t)(uintptr_t)cstr;
  }
  *argc_out = 3 + nrest;
  return 0;
}

/*
 * Run `lake --dir=<pkg> build [rest…]` via freestanding multi-arg spawn + wait.
 *
 * Child environment is empty (execve envp=NULL) — not a host-env clone.
 * rest_a: Lean Array of String (may be null/empty). CLAIMED stays (build clean env).
 * Returns:
 *   0…255-ish encoded exit from lean_fs_proc_wait on success path,
 *   SLAKE_FS_SPAWN_FAIL on arg/spawn failure,
 *   SLAKE_FS_WAIT_FAIL when spawn succeeded but wait failed
 *   (so classic CLI does not treat wait fail as spawn fail → double lake).
 */
LEAN_EXPORT uint32_t slake_fs_run_lake_build(b_lean_obj_arg pkg_s, b_lean_obj_arg lake_s,
                                             b_lean_obj_arg rest_a) {
  const char *pkg;
  const char *lake;
  char dirarg[4096];
  size_t argv[SLAKE_FS_MAX_ARGV];
  size_t argc = 0;
  size_t pid;
  uint32_t st;

  if (pkg_s == 0 || lake_s == 0)
    return SLAKE_FS_SPAWN_FAIL;
  pkg = lean_string_cstr(pkg_s);
  lake = lean_string_cstr(lake_s);
  if (slake_fs_fill_cmd_argv(pkg, lake, "build", rest_a, dirarg, sizeof dirarg,
                             argv, SLAKE_FS_MAX_ARGV, &argc) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  pid = lean_fs_proc_spawn_argv((size_t)(uintptr_t)lake, (size_t)(uintptr_t)argv, argc);
  if (lean_fs_proc_pid_is_neg(pid) != 0u)
    return SLAKE_FS_SPAWN_FAIL;
  st = lean_fs_proc_wait(pid);
  /* Distinguish waitFail (0xFFFFFFFF from Systems.Proc) from spawn fail for CLI fall back. */
  if (st == LEAN_FS_PROC_WAIT_FAIL)
    return SLAKE_FS_WAIT_FAIL;
  return st;
}

/*
 * Run `lake --dir=<pkg> build [rest…]` via freestanding multi-arg **pipe** spawn.
 *
 * Creates a parent-owned stdout pipe with lean_fs_proc_pipe, spawns with
 * lean_fs_proc_spawn_argv_pipe (stdout → write end; stdin not redirected),
 * closes the child write end in the parent, drains the read end, then wait.
 *
 * Demo/capture only — not full Lake IO redirect product; stderr still inherits.
 * Child env empty (same freestanding honesty as multi-arg path).
 */
LEAN_EXPORT uint32_t slake_fs_run_lake_build_pipe(b_lean_obj_arg pkg_s, b_lean_obj_arg lake_s,
                                                  b_lean_obj_arg rest_a) {
  const char *pkg;
  const char *lake;
  char dirarg[4096];
  size_t argv[SLAKE_FS_MAX_ARGV];
  size_t argc = 0;
  size_t pipe_fds[2];
  size_t pid;
  size_t rd, wr;
  uint32_t st;
  uint32_t pst;
  char buf[4096];
  size_t got;
  size_t total = 0;

  if (pkg_s == 0 || lake_s == 0)
    return SLAKE_FS_SPAWN_FAIL;
  pkg = lean_string_cstr(pkg_s);
  lake = lean_string_cstr(lake_s);
  if (slake_fs_fill_cmd_argv(pkg, lake, "build", rest_a, dirarg, sizeof dirarg,
                             argv, SLAKE_FS_MAX_ARGV, &argc) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  pipe_fds[0] = 0;
  pipe_fds[1] = 0;
  pst = lean_fs_proc_pipe((size_t)(uintptr_t)pipe_fds);
  if (pst != 0u)
    return SLAKE_FS_SPAWN_FAIL;
  rd = pipe_fds[0];
  wr = pipe_fds[1];

  pid = lean_fs_proc_spawn_argv_pipe(
      (size_t)(uintptr_t)lake, (size_t)(uintptr_t)argv, argc,
      FS_PROC_FD_NONE, wr);
  /* Parent never writes; close write end so child EOF is honest after exec. */
  (void)lean_fs_proc_close_raw(wr);
  if (lean_fs_proc_pid_is_neg(pid) != 0u) {
    (void)lean_fs_proc_close_raw(rd);
    return SLAKE_FS_SPAWN_FAIL;
  }

  /* Drain stdout capture (best-effort demo; not full IO product).
   * Always read to EOF/error before close so a still-writing lake child is not
   * SIGPIPE'd if parent stdout fwrite fails mid-drain (demo residual honesty). */
  for (;;) {
    got = lean_fs_read(rd, (size_t)(uintptr_t)buf, sizeof buf);
    if (got == (size_t)-1 || got == 0)
      break;
    total += got;
    /* Mirror captured bytes to parent stdout so builds stay visible. */
    if (fwrite(buf, 1, got, stdout) != got) {
      /* Keep draining so close(rd) does not signal the child mid-write. */
      continue;
    }
  }
  (void)lean_fs_proc_close_raw(rd);
  fflush(stdout);
  fprintf(stderr, "slake fs_proc_pipe: captured %zu stdout byte(s) via freestanding pipe\n",
          total);

  st = lean_fs_proc_wait(pid);
  if (st == LEAN_FS_PROC_WAIT_FAIL)
    return SLAKE_FS_WAIT_FAIL;
  return st;
}


/*
 * Run `lake --dir=<pkg> test [rest…]` via freestanding multi-arg spawn + wait.
 * Same empty-child-env honesty as build (W87 FS_PROC test path). CLAIMED unchanged.
 */
LEAN_EXPORT uint32_t slake_fs_run_lake_test(b_lean_obj_arg pkg_s, b_lean_obj_arg lake_s,
                                            b_lean_obj_arg rest_a) {
  const char *pkg;
  const char *lake;
  char dirarg[4096];
  size_t argv[SLAKE_FS_MAX_ARGV];
  size_t argc = 0;
  size_t pid;
  uint32_t st;

  if (pkg_s == 0 || lake_s == 0)
    return SLAKE_FS_SPAWN_FAIL;
  pkg = lean_string_cstr(pkg_s);
  lake = lean_string_cstr(lake_s);
  if (slake_fs_fill_cmd_argv(pkg, lake, "test", rest_a, dirarg, sizeof dirarg,
                             argv, SLAKE_FS_MAX_ARGV, &argc) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  pid = lean_fs_proc_spawn_argv((size_t)(uintptr_t)lake, (size_t)(uintptr_t)argv, argc);
  if (lean_fs_proc_pid_is_neg(pid) != 0u)
    return SLAKE_FS_SPAWN_FAIL;
  st = lean_fs_proc_wait(pid);
  if (st == LEAN_FS_PROC_WAIT_FAIL)
    return SLAKE_FS_WAIT_FAIL;
  return st;
}

/*
 * Run `lake --dir=<pkg> test [rest…]` via freestanding multi-arg **pipe** spawn.
 * Demo/capture only — same residual honesty as build pipe path.
 */
LEAN_EXPORT uint32_t slake_fs_run_lake_test_pipe(b_lean_obj_arg pkg_s, b_lean_obj_arg lake_s,
                                                 b_lean_obj_arg rest_a) {
  const char *pkg;
  const char *lake;
  char dirarg[4096];
  size_t argv[SLAKE_FS_MAX_ARGV];
  size_t argc = 0;
  size_t pipe_fds[2];
  size_t pid;
  size_t rd, wr;
  uint32_t st;
  uint32_t pst;
  char buf[4096];
  size_t got;
  size_t total = 0;

  if (pkg_s == 0 || lake_s == 0)
    return SLAKE_FS_SPAWN_FAIL;
  pkg = lean_string_cstr(pkg_s);
  lake = lean_string_cstr(lake_s);
  if (slake_fs_fill_cmd_argv(pkg, lake, "test", rest_a, dirarg, sizeof dirarg,
                             argv, SLAKE_FS_MAX_ARGV, &argc) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  pipe_fds[0] = 0;
  pipe_fds[1] = 0;
  pst = lean_fs_proc_pipe((size_t)(uintptr_t)pipe_fds);
  if (pst != 0u)
    return SLAKE_FS_SPAWN_FAIL;
  rd = pipe_fds[0];
  wr = pipe_fds[1];

  pid = lean_fs_proc_spawn_argv_pipe(
      (size_t)(uintptr_t)lake, (size_t)(uintptr_t)argv, argc,
      FS_PROC_FD_NONE, wr);
  (void)lean_fs_proc_close_raw(wr);
  if (lean_fs_proc_pid_is_neg(pid) != 0u) {
    (void)lean_fs_proc_close_raw(rd);
    return SLAKE_FS_SPAWN_FAIL;
  }

  for (;;) {
    got = lean_fs_read(rd, (size_t)(uintptr_t)buf, sizeof buf);
    if (got == (size_t)-1 || got == 0)
      break;
    total += got;
    if (fwrite(buf, 1, got, stdout) != got) {
      continue;
    }
  }
  (void)lean_fs_proc_close_raw(rd);
  fflush(stdout);
  fprintf(stderr, "slake fs_proc_pipe: captured %zu stdout byte(s) via freestanding pipe\n",
          total);

  st = lean_fs_proc_wait(pid);
  if (st == LEAN_FS_PROC_WAIT_FAIL)
    return SLAKE_FS_WAIT_FAIL;
  return st;
}


/*
 * Run `lake --dir=<pkg> exe [rest…]` via freestanding multi-arg spawn + wait.
 * Same empty-child-env honesty as build/test (W88 FS_PROC exe path). CLAIMED unchanged.
 */
LEAN_EXPORT uint32_t slake_fs_run_lake_exe(b_lean_obj_arg pkg_s, b_lean_obj_arg lake_s,
                                           b_lean_obj_arg rest_a) {
  const char *pkg;
  const char *lake;
  char dirarg[4096];
  size_t argv[SLAKE_FS_MAX_ARGV];
  size_t argc = 0;
  size_t pid;
  uint32_t st;

  if (pkg_s == 0 || lake_s == 0)
    return SLAKE_FS_SPAWN_FAIL;
  pkg = lean_string_cstr(pkg_s);
  lake = lean_string_cstr(lake_s);
  if (slake_fs_fill_cmd_argv(pkg, lake, "exe", rest_a, dirarg, sizeof dirarg,
                             argv, SLAKE_FS_MAX_ARGV, &argc) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  pid = lean_fs_proc_spawn_argv((size_t)(uintptr_t)lake, (size_t)(uintptr_t)argv, argc);
  if (lean_fs_proc_pid_is_neg(pid) != 0u)
    return SLAKE_FS_SPAWN_FAIL;
  st = lean_fs_proc_wait(pid);
  if (st == LEAN_FS_PROC_WAIT_FAIL)
    return SLAKE_FS_WAIT_FAIL;
  return st;
}

/*
 * Run `lake --dir=<pkg> exe [rest…]` via freestanding multi-arg **pipe** spawn.
 * Demo/capture only — same residual honesty as build/test pipe path.
 */
LEAN_EXPORT uint32_t slake_fs_run_lake_exe_pipe(b_lean_obj_arg pkg_s, b_lean_obj_arg lake_s,
                                                b_lean_obj_arg rest_a) {
  const char *pkg;
  const char *lake;
  char dirarg[4096];
  size_t argv[SLAKE_FS_MAX_ARGV];
  size_t argc = 0;
  size_t pipe_fds[2];
  size_t pid;
  size_t rd, wr;
  uint32_t st;
  uint32_t pst;
  char buf[4096];
  size_t got;
  size_t total = 0;

  if (pkg_s == 0 || lake_s == 0)
    return SLAKE_FS_SPAWN_FAIL;
  pkg = lean_string_cstr(pkg_s);
  lake = lean_string_cstr(lake_s);
  if (slake_fs_fill_cmd_argv(pkg, lake, "exe", rest_a, dirarg, sizeof dirarg,
                             argv, SLAKE_FS_MAX_ARGV, &argc) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  pipe_fds[0] = 0;
  pipe_fds[1] = 0;
  pst = lean_fs_proc_pipe((size_t)(uintptr_t)pipe_fds);
  if (pst != 0u)
    return SLAKE_FS_SPAWN_FAIL;
  rd = pipe_fds[0];
  wr = pipe_fds[1];

  pid = lean_fs_proc_spawn_argv_pipe(
      (size_t)(uintptr_t)lake, (size_t)(uintptr_t)argv, argc,
      FS_PROC_FD_NONE, wr);
  (void)lean_fs_proc_close_raw(wr);
  if (lean_fs_proc_pid_is_neg(pid) != 0u) {
    (void)lean_fs_proc_close_raw(rd);
    return SLAKE_FS_SPAWN_FAIL;
  }

  for (;;) {
    got = lean_fs_read(rd, (size_t)(uintptr_t)buf, sizeof buf);
    if (got == (size_t)-1 || got == 0)
      break;
    total += got;
    if (fwrite(buf, 1, got, stdout) != got) {
      continue;
    }
  }
  (void)lean_fs_proc_close_raw(rd);
  fflush(stdout);
  fprintf(stderr, "slake fs_proc_pipe: captured %zu stdout byte(s) via freestanding pipe\n",
          total);

  st = lean_fs_proc_wait(pid);
  if (st == LEAN_FS_PROC_WAIT_FAIL)
    return SLAKE_FS_WAIT_FAIL;
  return st;
}

/* Probe for env reporting: linked + callable. */
LEAN_EXPORT uint32_t slake_fs_proc_linked(void) {
  return 1u;
}

/* Probe: pipe path symbols linked (same object as multi-arg). */
LEAN_EXPORT uint32_t slake_fs_proc_pipe_linked(void) {
  return 1u;
}


/*
 * Run `lake --dir=<pkg> lint [rest…]` via freestanding multi-arg spawn + wait.
 * Same empty-child-env honesty as build/test/exe (W89 FS_PROC lint path). CLAIMED unchanged.
 */
LEAN_EXPORT uint32_t slake_fs_run_lake_lint(b_lean_obj_arg pkg_s, b_lean_obj_arg lake_s,
                                            b_lean_obj_arg rest_a) {
  const char *pkg;
  const char *lake;
  char dirarg[4096];
  size_t argv[SLAKE_FS_MAX_ARGV];
  size_t argc = 0;
  size_t pid;
  uint32_t st;

  if (pkg_s == 0 || lake_s == 0)
    return SLAKE_FS_SPAWN_FAIL;
  pkg = lean_string_cstr(pkg_s);
  lake = lean_string_cstr(lake_s);
  if (slake_fs_fill_cmd_argv(pkg, lake, "lint", rest_a, dirarg, sizeof dirarg,
                             argv, SLAKE_FS_MAX_ARGV, &argc) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  pid = lean_fs_proc_spawn_argv((size_t)(uintptr_t)lake, (size_t)(uintptr_t)argv, argc);
  if (lean_fs_proc_pid_is_neg(pid) != 0u)
    return SLAKE_FS_SPAWN_FAIL;
  st = lean_fs_proc_wait(pid);
  if (st == LEAN_FS_PROC_WAIT_FAIL)
    return SLAKE_FS_WAIT_FAIL;
  return st;
}

/*
 * Run `lake --dir=<pkg> lint [rest…]` via freestanding multi-arg **pipe** spawn.
 * Demo/capture only — same residual honesty as build/test/exe pipe path.
 */
LEAN_EXPORT uint32_t slake_fs_run_lake_lint_pipe(b_lean_obj_arg pkg_s, b_lean_obj_arg lake_s,
                                                 b_lean_obj_arg rest_a) {
  const char *pkg;
  const char *lake;
  char dirarg[4096];
  size_t argv[SLAKE_FS_MAX_ARGV];
  size_t argc = 0;
  size_t pipe_fds[2];
  size_t pid;
  size_t rd, wr;
  uint32_t st;
  uint32_t pst;
  char buf[4096];
  size_t got;
  size_t total = 0;

  if (pkg_s == 0 || lake_s == 0)
    return SLAKE_FS_SPAWN_FAIL;
  pkg = lean_string_cstr(pkg_s);
  lake = lean_string_cstr(lake_s);
  if (slake_fs_fill_cmd_argv(pkg, lake, "lint", rest_a, dirarg, sizeof dirarg,
                             argv, SLAKE_FS_MAX_ARGV, &argc) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  pipe_fds[0] = 0;
  pipe_fds[1] = 0;
  pst = lean_fs_proc_pipe((size_t)(uintptr_t)pipe_fds);
  if (pst != 0u)
    return SLAKE_FS_SPAWN_FAIL;
  rd = pipe_fds[0];
  wr = pipe_fds[1];

  pid = lean_fs_proc_spawn_argv_pipe(
      (size_t)(uintptr_t)lake, (size_t)(uintptr_t)argv, argc,
      FS_PROC_FD_NONE, wr);
  (void)lean_fs_proc_close_raw(wr);
  if (lean_fs_proc_pid_is_neg(pid) != 0u) {
    (void)lean_fs_proc_close_raw(rd);
    return SLAKE_FS_SPAWN_FAIL;
  }

  for (;;) {
    got = lean_fs_read(rd, (size_t)(uintptr_t)buf, sizeof buf);
    if (got == (size_t)-1 || got == 0)
      break;
    total += got;
    if (fwrite(buf, 1, got, stdout) != got) {
      continue;
    }
  }
  (void)lean_fs_proc_close_raw(rd);
  fflush(stdout);
  fprintf(stderr, "slake fs_proc_pipe: captured %zu stdout byte(s) via freestanding pipe\n",
          total);

  st = lean_fs_proc_wait(pid);
  if (st == LEAN_FS_PROC_WAIT_FAIL)
    return SLAKE_FS_WAIT_FAIL;
  return st;
}

/*
 * Run `lake --dir=<pkg> script [rest…]` via freestanding multi-arg spawn + wait.
 * Same empty-child-env honesty as build/test/exe/lint (W90 FS_PROC script path). CLAIMED unchanged.
 */
LEAN_EXPORT uint32_t slake_fs_run_lake_script(b_lean_obj_arg pkg_s, b_lean_obj_arg lake_s,
                                              b_lean_obj_arg rest_a) {
  const char *pkg;
  const char *lake;
  char dirarg[4096];
  size_t argv[SLAKE_FS_MAX_ARGV];
  size_t argc = 0;
  size_t pid;
  uint32_t st;

  if (pkg_s == 0 || lake_s == 0)
    return SLAKE_FS_SPAWN_FAIL;
  pkg = lean_string_cstr(pkg_s);
  lake = lean_string_cstr(lake_s);
  if (slake_fs_fill_cmd_argv(pkg, lake, "script", rest_a, dirarg, sizeof dirarg,
                             argv, SLAKE_FS_MAX_ARGV, &argc) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  pid = lean_fs_proc_spawn_argv((size_t)(uintptr_t)lake, (size_t)(uintptr_t)argv, argc);
  if (lean_fs_proc_pid_is_neg(pid) != 0u)
    return SLAKE_FS_SPAWN_FAIL;
  st = lean_fs_proc_wait(pid);
  if (st == LEAN_FS_PROC_WAIT_FAIL)
    return SLAKE_FS_WAIT_FAIL;
  return st;
}

/*
 * Run `lake --dir=<pkg> script [rest…]` via freestanding multi-arg **pipe** spawn.
 * Demo/capture only — same residual honesty as build/test/exe/lint pipe path.
 */
LEAN_EXPORT uint32_t slake_fs_run_lake_script_pipe(b_lean_obj_arg pkg_s, b_lean_obj_arg lake_s,
                                                   b_lean_obj_arg rest_a) {
  const char *pkg;
  const char *lake;
  char dirarg[4096];
  size_t argv[SLAKE_FS_MAX_ARGV];
  size_t argc = 0;
  size_t pipe_fds[2];
  size_t pid;
  size_t rd, wr;
  uint32_t st;
  uint32_t pst;
  char buf[4096];
  size_t got;
  size_t total = 0;

  if (pkg_s == 0 || lake_s == 0)
    return SLAKE_FS_SPAWN_FAIL;
  pkg = lean_string_cstr(pkg_s);
  lake = lean_string_cstr(lake_s);
  if (slake_fs_fill_cmd_argv(pkg, lake, "script", rest_a, dirarg, sizeof dirarg,
                             argv, SLAKE_FS_MAX_ARGV, &argc) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  pipe_fds[0] = 0;
  pipe_fds[1] = 0;
  pst = lean_fs_proc_pipe((size_t)(uintptr_t)pipe_fds);
  if (pst != 0u)
    return SLAKE_FS_SPAWN_FAIL;
  rd = pipe_fds[0];
  wr = pipe_fds[1];

  pid = lean_fs_proc_spawn_argv_pipe(
      (size_t)(uintptr_t)lake, (size_t)(uintptr_t)argv, argc,
      FS_PROC_FD_NONE, wr);
  (void)lean_fs_proc_close_raw(wr);
  if (lean_fs_proc_pid_is_neg(pid) != 0u) {
    (void)lean_fs_proc_close_raw(rd);
    return SLAKE_FS_SPAWN_FAIL;
  }

  for (;;) {
    got = lean_fs_read(rd, (size_t)(uintptr_t)buf, sizeof buf);
    if (got == (size_t)-1 || got == 0)
      break;
    total += got;
    if (fwrite(buf, 1, got, stdout) != got) {
      continue;
    }
  }
  (void)lean_fs_proc_close_raw(rd);
  fflush(stdout);
  fprintf(stderr, "slake fs_proc_pipe: captured %zu stdout byte(s) via freestanding pipe\n",
          total);

  st = lean_fs_proc_wait(pid);
  if (st == LEAN_FS_PROC_WAIT_FAIL)
    return SLAKE_FS_WAIT_FAIL;
  return st;
}

/*
 * Run `lake --dir=<pkg> clean [rest…]` via freestanding multi-arg spawn + wait.
 * Same empty-child-env honesty as build/test/exe/lint/script (W91 FS_PROC clean path).
 * CLAIMED stays (build clean env); freestanding path is optional dual residual.
 * Empty-rest-only security envelope is enforced on the Lean CLI path before this
 * export is called; C still accepts rest_a for ABI symmetry with other FS_PROC
 * commands (defense-in-depth fence deferred — do not expand CLAIMED).
 */
LEAN_EXPORT uint32_t slake_fs_run_lake_clean(b_lean_obj_arg pkg_s, b_lean_obj_arg lake_s,
                                             b_lean_obj_arg rest_a) {
  const char *pkg;
  const char *lake;
  char dirarg[4096];
  size_t argv[SLAKE_FS_MAX_ARGV];
  size_t argc = 0;
  size_t pid;
  uint32_t st;

  if (pkg_s == 0 || lake_s == 0)
    return SLAKE_FS_SPAWN_FAIL;
  pkg = lean_string_cstr(pkg_s);
  lake = lean_string_cstr(lake_s);
  if (slake_fs_fill_cmd_argv(pkg, lake, "clean", rest_a, dirarg, sizeof dirarg,
                             argv, SLAKE_FS_MAX_ARGV, &argc) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  pid = lean_fs_proc_spawn_argv((size_t)(uintptr_t)lake, (size_t)(uintptr_t)argv, argc);
  if (lean_fs_proc_pid_is_neg(pid) != 0u)
    return SLAKE_FS_SPAWN_FAIL;
  st = lean_fs_proc_wait(pid);
  if (st == LEAN_FS_PROC_WAIT_FAIL)
    return SLAKE_FS_WAIT_FAIL;
  return st;
}

/*
 * Run `lake --dir=<pkg> clean [rest…]` via freestanding multi-arg **pipe** spawn.
 * Demo/capture only — same residual honesty as build/test/exe/lint/script pipe path. W91.
 */
LEAN_EXPORT uint32_t slake_fs_run_lake_clean_pipe(b_lean_obj_arg pkg_s, b_lean_obj_arg lake_s,
                                                  b_lean_obj_arg rest_a) {
  const char *pkg;
  const char *lake;
  char dirarg[4096];
  size_t argv[SLAKE_FS_MAX_ARGV];
  size_t argc = 0;
  size_t pipe_fds[2];
  size_t pid;
  size_t rd, wr;
  uint32_t st;
  uint32_t pst;
  char buf[4096];
  size_t got;
  size_t total = 0;

  if (pkg_s == 0 || lake_s == 0)
    return SLAKE_FS_SPAWN_FAIL;
  pkg = lean_string_cstr(pkg_s);
  lake = lean_string_cstr(lake_s);
  if (slake_fs_fill_cmd_argv(pkg, lake, "clean", rest_a, dirarg, sizeof dirarg,
                             argv, SLAKE_FS_MAX_ARGV, &argc) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  pipe_fds[0] = 0;
  pipe_fds[1] = 0;
  pst = lean_fs_proc_pipe((size_t)(uintptr_t)pipe_fds);
  if (pst != 0u)
    return SLAKE_FS_SPAWN_FAIL;
  rd = pipe_fds[0];
  wr = pipe_fds[1];

  pid = lean_fs_proc_spawn_argv_pipe(
      (size_t)(uintptr_t)lake, (size_t)(uintptr_t)argv, argc,
      FS_PROC_FD_NONE, wr);
  (void)lean_fs_proc_close_raw(wr);
  if (lean_fs_proc_pid_is_neg(pid) != 0u) {
    (void)lean_fs_proc_close_raw(rd);
    return SLAKE_FS_SPAWN_FAIL;
  }

  for (;;) {
    got = lean_fs_read(rd, (size_t)(uintptr_t)buf, sizeof buf);
    if (got == (size_t)-1 || got == 0)
      break;
    total += got;
    if (fwrite(buf, 1, got, stdout) != got) {
      continue;
    }
  }
  (void)lean_fs_proc_close_raw(rd);
  fflush(stdout);
  fprintf(stderr, "slake fs_proc_pipe: captured %zu stdout byte(s) via freestanding pipe\n",
          total);

  st = lean_fs_proc_wait(pid);
  if (st == LEAN_FS_PROC_WAIT_FAIL)
    return SLAKE_FS_WAIT_FAIL;
  return st;
}

/*
 * Run `lake --dir=<pkg> update [rest…]` via freestanding multi-arg spawn + wait.
 * Same empty-child-env honesty as build/test/exe/lint/script/clean (W92 FS_PROC update path).
 * Outside CLAIMED (CLAIMED stays build/clean/env); thin-forward multi-arg rest plumbed.
 */
LEAN_EXPORT uint32_t slake_fs_run_lake_update(b_lean_obj_arg pkg_s, b_lean_obj_arg lake_s,
                                              b_lean_obj_arg rest_a) {
  const char *pkg;
  const char *lake;
  char dirarg[4096];
  size_t argv[SLAKE_FS_MAX_ARGV];
  size_t argc = 0;
  size_t pid;
  uint32_t st;

  if (pkg_s == 0 || lake_s == 0)
    return SLAKE_FS_SPAWN_FAIL;
  pkg = lean_string_cstr(pkg_s);
  lake = lean_string_cstr(lake_s);
  if (slake_fs_fill_cmd_argv(pkg, lake, "update", rest_a, dirarg, sizeof dirarg,
                             argv, SLAKE_FS_MAX_ARGV, &argc) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  pid = lean_fs_proc_spawn_argv((size_t)(uintptr_t)lake, (size_t)(uintptr_t)argv, argc);
  if (lean_fs_proc_pid_is_neg(pid) != 0u)
    return SLAKE_FS_SPAWN_FAIL;
  st = lean_fs_proc_wait(pid);
  if (st == LEAN_FS_PROC_WAIT_FAIL)
    return SLAKE_FS_WAIT_FAIL;
  return st;
}

/*
 * Run `lake --dir=<pkg> update [rest…]` via freestanding multi-arg **pipe** spawn.
 * Demo/capture only — same residual honesty as build/test/exe/lint/script/clean pipe path. W92.
 */
LEAN_EXPORT uint32_t slake_fs_run_lake_update_pipe(b_lean_obj_arg pkg_s, b_lean_obj_arg lake_s,
                                                   b_lean_obj_arg rest_a) {
  const char *pkg;
  const char *lake;
  char dirarg[4096];
  size_t argv[SLAKE_FS_MAX_ARGV];
  size_t argc = 0;
  size_t pipe_fds[2];
  size_t pid;
  size_t rd, wr;
  uint32_t st;
  uint32_t pst;
  char buf[4096];
  size_t got;
  size_t total = 0;

  if (pkg_s == 0 || lake_s == 0)
    return SLAKE_FS_SPAWN_FAIL;
  pkg = lean_string_cstr(pkg_s);
  lake = lean_string_cstr(lake_s);
  if (slake_fs_fill_cmd_argv(pkg, lake, "update", rest_a, dirarg, sizeof dirarg,
                             argv, SLAKE_FS_MAX_ARGV, &argc) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  pipe_fds[0] = 0;
  pipe_fds[1] = 0;
  pst = lean_fs_proc_pipe((size_t)(uintptr_t)pipe_fds);
  if (pst != 0u)
    return SLAKE_FS_SPAWN_FAIL;
  rd = pipe_fds[0];
  wr = pipe_fds[1];

  pid = lean_fs_proc_spawn_argv_pipe(
      (size_t)(uintptr_t)lake, (size_t)(uintptr_t)argv, argc,
      FS_PROC_FD_NONE, wr);
  (void)lean_fs_proc_close_raw(wr);
  if (lean_fs_proc_pid_is_neg(pid) != 0u) {
    (void)lean_fs_proc_close_raw(rd);
    return SLAKE_FS_SPAWN_FAIL;
  }

  for (;;) {
    got = lean_fs_read(rd, (size_t)(uintptr_t)buf, sizeof buf);
    if (got == (size_t)-1 || got == 0)
      break;
    total += got;
    if (fwrite(buf, 1, got, stdout) != got) {
      continue;
    }
  }
  (void)lean_fs_proc_close_raw(rd);
  fflush(stdout);
  fprintf(stderr, "slake fs_proc_pipe: captured %zu stdout byte(s) via freestanding pipe\n",
          total);

  st = lean_fs_proc_wait(pid);
  if (st == LEAN_FS_PROC_WAIT_FAIL)
    return SLAKE_FS_WAIT_FAIL;
  return st;
}

/*
 * Pack/cache/unpack/query dual-residual cwd honesty (W93 pack; W94 cache; W95 unpack; W96 query): classic IO.Process uses cwd=pkg so
 * relative archive args land under the package root. Freestanding spawn has no cwd
 * parameter, so pack FS_PROC/PIPE chdir(pkg) around spawn/wait (then restore) so
 * relative archive paths match classic. Single-threaded slake CLI only.
 * Returns 0 on success, -1 if getcwd/chdir fails (caller maps to SPAWN_FAIL).
 */
static int slake_fs_cmd_chdir_begin(const char *pkg, char *saved, size_t saved_sz) {
  if (pkg == 0 || pkg[0] == 0 || saved == 0 || saved_sz == 0)
    return -1;
  if (getcwd(saved, saved_sz) == 0)
    return -1;
  if (chdir(pkg) != 0)
    return -1;
  return 0;
}

/* Restore cwd after FS_PROC cmd spawn. Ignore restore failure (void): matches
 * pack/cache/unpack/query/shake/serve/upload/lean/scripts/setup-file/self-check/version-tags chdir set
 * (chdir is best-effort relative-path parity). */
static void slake_fs_cmd_chdir_end(const char *saved) {
  if (saved != 0 && saved[0] != 0)
    (void)chdir(saved);
}

/*
 * Run `lake --dir=<pkg> pack [rest…]` via freestanding multi-arg spawn + wait.
 * Same empty-child-env honesty as build/test/exe/lint/script/clean/update (W93 FS_PROC pack path).
 * Outside CLAIMED (CLAIMED stays build/clean/env); thin-forward multi-arg rest plumbed.
 * chdir(pkg) around spawn so relative archive args match classic cwd=pkg (see above).
 */
LEAN_EXPORT uint32_t slake_fs_run_lake_pack(b_lean_obj_arg pkg_s, b_lean_obj_arg lake_s,
                                            b_lean_obj_arg rest_a) {
  const char *pkg;
  const char *lake;
  char dirarg[4096];
  char saved_cwd[4096];
  size_t argv[SLAKE_FS_MAX_ARGV];
  size_t argc = 0;
  size_t pid;
  uint32_t st;

  if (pkg_s == 0 || lake_s == 0)
    return SLAKE_FS_SPAWN_FAIL;
  pkg = lean_string_cstr(pkg_s);
  lake = lean_string_cstr(lake_s);
  if (slake_fs_fill_cmd_argv(pkg, lake, "pack", rest_a, dirarg, sizeof dirarg,
                             argv, SLAKE_FS_MAX_ARGV, &argc) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  saved_cwd[0] = 0;
  if (slake_fs_cmd_chdir_begin(pkg, saved_cwd, sizeof saved_cwd) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  pid = lean_fs_proc_spawn_argv((size_t)(uintptr_t)lake, (size_t)(uintptr_t)argv, argc);
  if (lean_fs_proc_pid_is_neg(pid) != 0u) {
    slake_fs_cmd_chdir_end(saved_cwd);
    return SLAKE_FS_SPAWN_FAIL;
  }
  st = lean_fs_proc_wait(pid);
  slake_fs_cmd_chdir_end(saved_cwd);
  if (st == LEAN_FS_PROC_WAIT_FAIL)
    return SLAKE_FS_WAIT_FAIL;
  return st;
}

/*
 * Run `lake --dir=<pkg> pack [rest…]` via freestanding multi-arg **pipe** spawn.
 * Demo/capture only — same residual honesty as build/test/exe/lint/script/clean/update pipe path. W93.
 * chdir(pkg) around spawn like multi-arg pack (relative archive path parity with classic).
 */
LEAN_EXPORT uint32_t slake_fs_run_lake_pack_pipe(b_lean_obj_arg pkg_s, b_lean_obj_arg lake_s,
                                                 b_lean_obj_arg rest_a) {
  const char *pkg;
  const char *lake;
  char dirarg[4096];
  char saved_cwd[4096];
  size_t argv[SLAKE_FS_MAX_ARGV];
  size_t argc = 0;
  size_t pipe_fds[2];
  size_t pid;
  size_t rd, wr;
  uint32_t st;
  uint32_t pst;
  char buf[4096];
  size_t got;
  size_t total = 0;

  if (pkg_s == 0 || lake_s == 0)
    return SLAKE_FS_SPAWN_FAIL;
  pkg = lean_string_cstr(pkg_s);
  lake = lean_string_cstr(lake_s);
  if (slake_fs_fill_cmd_argv(pkg, lake, "pack", rest_a, dirarg, sizeof dirarg,
                             argv, SLAKE_FS_MAX_ARGV, &argc) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  pipe_fds[0] = 0;
  pipe_fds[1] = 0;
  pst = lean_fs_proc_pipe((size_t)(uintptr_t)pipe_fds);
  if (pst != 0u)
    return SLAKE_FS_SPAWN_FAIL;
  rd = pipe_fds[0];
  wr = pipe_fds[1];

  saved_cwd[0] = 0;
  if (slake_fs_cmd_chdir_begin(pkg, saved_cwd, sizeof saved_cwd) != 0) {
    (void)lean_fs_proc_close_raw(wr);
    (void)lean_fs_proc_close_raw(rd);
    return SLAKE_FS_SPAWN_FAIL;
  }

  pid = lean_fs_proc_spawn_argv_pipe(
      (size_t)(uintptr_t)lake, (size_t)(uintptr_t)argv, argc,
      FS_PROC_FD_NONE, wr);
  (void)lean_fs_proc_close_raw(wr);
  if (lean_fs_proc_pid_is_neg(pid) != 0u) {
    (void)lean_fs_proc_close_raw(rd);
    slake_fs_cmd_chdir_end(saved_cwd);
    return SLAKE_FS_SPAWN_FAIL;
  }

  for (;;) {
    got = lean_fs_read(rd, (size_t)(uintptr_t)buf, sizeof buf);
    if (got == (size_t)-1 || got == 0)
      break;
    total += got;
    if (fwrite(buf, 1, got, stdout) != got) {
      continue;
    }
  }
  (void)lean_fs_proc_close_raw(rd);
  fflush(stdout);
  fprintf(stderr, "slake fs_proc_pipe: captured %zu stdout byte(s) via freestanding pipe\n",
          total);

  st = lean_fs_proc_wait(pid);
  slake_fs_cmd_chdir_end(saved_cwd);
  if (st == LEAN_FS_PROC_WAIT_FAIL)
    return SLAKE_FS_WAIT_FAIL;
  return st;
}

/*
 * Run `lake --dir=<pkg> cache [rest…]` via freestanding multi-arg spawn + wait.
 * Same empty-child-env honesty as pack (W94 FS_PROC cache path). Outside CLAIMED.
 * chdir(pkg) around spawn so relative path args match classic cwd=pkg.
 */
LEAN_EXPORT uint32_t slake_fs_run_lake_cache(b_lean_obj_arg pkg_s, b_lean_obj_arg lake_s,
                                             b_lean_obj_arg rest_a) {
  const char *pkg;
  const char *lake;
  char dirarg[4096];
  char saved_cwd[4096];
  size_t argv[SLAKE_FS_MAX_ARGV];
  size_t argc = 0;
  size_t pid;
  uint32_t st;

  if (pkg_s == 0 || lake_s == 0)
    return SLAKE_FS_SPAWN_FAIL;
  pkg = lean_string_cstr(pkg_s);
  lake = lean_string_cstr(lake_s);
  if (slake_fs_fill_cmd_argv(pkg, lake, "cache", rest_a, dirarg, sizeof dirarg,
                             argv, SLAKE_FS_MAX_ARGV, &argc) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  saved_cwd[0] = 0;
  if (slake_fs_cmd_chdir_begin(pkg, saved_cwd, sizeof saved_cwd) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  pid = lean_fs_proc_spawn_argv((size_t)(uintptr_t)lake, (size_t)(uintptr_t)argv, argc);
  if (lean_fs_proc_pid_is_neg(pid) != 0u) {
    slake_fs_cmd_chdir_end(saved_cwd);
    return SLAKE_FS_SPAWN_FAIL;
  }
  st = lean_fs_proc_wait(pid);
  slake_fs_cmd_chdir_end(saved_cwd);
  if (st == LEAN_FS_PROC_WAIT_FAIL)
    return SLAKE_FS_WAIT_FAIL;
  return st;
}

/*
 * Run `lake --dir=<pkg> cache [rest…]` via freestanding multi-arg **pipe** spawn.
 * Demo/capture only — same residual honesty as pack pipe path. W94.
 * chdir(pkg) around spawn like multi-arg cache (relative path parity with classic).
 */
LEAN_EXPORT uint32_t slake_fs_run_lake_cache_pipe(b_lean_obj_arg pkg_s, b_lean_obj_arg lake_s,
                                                  b_lean_obj_arg rest_a) {
  const char *pkg;
  const char *lake;
  char dirarg[4096];
  char saved_cwd[4096];
  size_t argv[SLAKE_FS_MAX_ARGV];
  size_t argc = 0;
  size_t pipe_fds[2];
  size_t pid;
  size_t rd, wr;
  uint32_t st;
  uint32_t pst;
  char buf[4096];
  size_t got;
  size_t total = 0;

  if (pkg_s == 0 || lake_s == 0)
    return SLAKE_FS_SPAWN_FAIL;
  pkg = lean_string_cstr(pkg_s);
  lake = lean_string_cstr(lake_s);
  if (slake_fs_fill_cmd_argv(pkg, lake, "cache", rest_a, dirarg, sizeof dirarg,
                             argv, SLAKE_FS_MAX_ARGV, &argc) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  pipe_fds[0] = 0;
  pipe_fds[1] = 0;
  pst = lean_fs_proc_pipe((size_t)(uintptr_t)pipe_fds);
  if (pst != 0u)
    return SLAKE_FS_SPAWN_FAIL;
  rd = pipe_fds[0];
  wr = pipe_fds[1];

  saved_cwd[0] = 0;
  if (slake_fs_cmd_chdir_begin(pkg, saved_cwd, sizeof saved_cwd) != 0) {
    (void)lean_fs_proc_close_raw(wr);
    (void)lean_fs_proc_close_raw(rd);
    return SLAKE_FS_SPAWN_FAIL;
  }

  pid = lean_fs_proc_spawn_argv_pipe(
      (size_t)(uintptr_t)lake, (size_t)(uintptr_t)argv, argc,
      FS_PROC_FD_NONE, wr);
  (void)lean_fs_proc_close_raw(wr);
  if (lean_fs_proc_pid_is_neg(pid) != 0u) {
    (void)lean_fs_proc_close_raw(rd);
    slake_fs_cmd_chdir_end(saved_cwd);
    return SLAKE_FS_SPAWN_FAIL;
  }

  for (;;) {
    got = lean_fs_read(rd, (size_t)(uintptr_t)buf, sizeof buf);
    if (got == (size_t)-1 || got == 0)
      break;
    total += got;
    if (fwrite(buf, 1, got, stdout) != got) {
      continue;
    }
  }
  (void)lean_fs_proc_close_raw(rd);
  fflush(stdout);
  fprintf(stderr, "slake fs_proc_pipe: captured %zu stdout byte(s) via freestanding pipe\n",
          total);

  st = lean_fs_proc_wait(pid);
  slake_fs_cmd_chdir_end(saved_cwd);
  if (st == LEAN_FS_PROC_WAIT_FAIL)
    return SLAKE_FS_WAIT_FAIL;
  return st;
}

/*
 * Run `lake --dir=<pkg> unpack [rest…]` via freestanding multi-arg spawn + wait.
 * Same empty-child-env honesty as pack/cache (W95 FS_PROC unpack path). Outside CLAIMED.
 * chdir(pkg) around spawn so relative path args match classic cwd=pkg.
 */
LEAN_EXPORT uint32_t slake_fs_run_lake_unpack(b_lean_obj_arg pkg_s, b_lean_obj_arg lake_s,
                                              b_lean_obj_arg rest_a) {
  const char *pkg;
  const char *lake;
  char dirarg[4096];
  char saved_cwd[4096];
  size_t argv[SLAKE_FS_MAX_ARGV];
  size_t argc = 0;
  size_t pid;
  uint32_t st;

  if (pkg_s == 0 || lake_s == 0)
    return SLAKE_FS_SPAWN_FAIL;
  pkg = lean_string_cstr(pkg_s);
  lake = lean_string_cstr(lake_s);
  if (slake_fs_fill_cmd_argv(pkg, lake, "unpack", rest_a, dirarg, sizeof dirarg,
                             argv, SLAKE_FS_MAX_ARGV, &argc) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  saved_cwd[0] = 0;
  if (slake_fs_cmd_chdir_begin(pkg, saved_cwd, sizeof saved_cwd) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  pid = lean_fs_proc_spawn_argv((size_t)(uintptr_t)lake, (size_t)(uintptr_t)argv, argc);
  if (lean_fs_proc_pid_is_neg(pid) != 0u) {
    slake_fs_cmd_chdir_end(saved_cwd);
    return SLAKE_FS_SPAWN_FAIL;
  }
  st = lean_fs_proc_wait(pid);
  slake_fs_cmd_chdir_end(saved_cwd);
  if (st == LEAN_FS_PROC_WAIT_FAIL)
    return SLAKE_FS_WAIT_FAIL;
  return st;
}

/*
 * Run `lake --dir=<pkg> unpack [rest…]` via freestanding multi-arg **pipe** spawn.
 * Demo/capture only — same residual honesty as pack/cache pipe path. W95.
 * chdir(pkg) around spawn like multi-arg unpack (relative path parity with classic).
 */
LEAN_EXPORT uint32_t slake_fs_run_lake_unpack_pipe(b_lean_obj_arg pkg_s, b_lean_obj_arg lake_s,
                                                   b_lean_obj_arg rest_a) {
  const char *pkg;
  const char *lake;
  char dirarg[4096];
  char saved_cwd[4096];
  size_t argv[SLAKE_FS_MAX_ARGV];
  size_t argc = 0;
  size_t pipe_fds[2];
  size_t pid;
  size_t rd, wr;
  uint32_t st;
  uint32_t pst;
  char buf[4096];
  size_t got;
  size_t total = 0;

  if (pkg_s == 0 || lake_s == 0)
    return SLAKE_FS_SPAWN_FAIL;
  pkg = lean_string_cstr(pkg_s);
  lake = lean_string_cstr(lake_s);
  if (slake_fs_fill_cmd_argv(pkg, lake, "unpack", rest_a, dirarg, sizeof dirarg,
                             argv, SLAKE_FS_MAX_ARGV, &argc) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  pipe_fds[0] = 0;
  pipe_fds[1] = 0;
  pst = lean_fs_proc_pipe((size_t)(uintptr_t)pipe_fds);
  if (pst != 0u)
    return SLAKE_FS_SPAWN_FAIL;
  rd = pipe_fds[0];
  wr = pipe_fds[1];

  saved_cwd[0] = 0;
  if (slake_fs_cmd_chdir_begin(pkg, saved_cwd, sizeof saved_cwd) != 0) {
    (void)lean_fs_proc_close_raw(wr);
    (void)lean_fs_proc_close_raw(rd);
    return SLAKE_FS_SPAWN_FAIL;
  }

  pid = lean_fs_proc_spawn_argv_pipe(
      (size_t)(uintptr_t)lake, (size_t)(uintptr_t)argv, argc,
      FS_PROC_FD_NONE, wr);
  (void)lean_fs_proc_close_raw(wr);
  if (lean_fs_proc_pid_is_neg(pid) != 0u) {
    (void)lean_fs_proc_close_raw(rd);
    slake_fs_cmd_chdir_end(saved_cwd);
    return SLAKE_FS_SPAWN_FAIL;
  }

  for (;;) {
    got = lean_fs_read(rd, (size_t)(uintptr_t)buf, sizeof buf);
    if (got == (size_t)-1 || got == 0)
      break;
    total += got;
    if (fwrite(buf, 1, got, stdout) != got) {
      continue;
    }
  }
  (void)lean_fs_proc_close_raw(rd);
  fflush(stdout);
  fprintf(stderr, "slake fs_proc_pipe: captured %zu stdout byte(s) via freestanding pipe\n",
          total);

  st = lean_fs_proc_wait(pid);
  slake_fs_cmd_chdir_end(saved_cwd);
  if (st == LEAN_FS_PROC_WAIT_FAIL)
    return SLAKE_FS_WAIT_FAIL;
  return st;
}

/*
 * Run `lake --dir=<pkg> query [rest…]` via freestanding multi-arg spawn + wait.
 * Same empty-child-env honesty as pack/cache/unpack (W96 FS_PROC query path). Outside CLAIMED.
 * chdir(pkg) around spawn so relative path args match classic cwd=pkg.
 */
LEAN_EXPORT uint32_t slake_fs_run_lake_query(b_lean_obj_arg pkg_s, b_lean_obj_arg lake_s,
                                              b_lean_obj_arg rest_a) {
  const char *pkg;
  const char *lake;
  char dirarg[4096];
  char saved_cwd[4096];
  size_t argv[SLAKE_FS_MAX_ARGV];
  size_t argc = 0;
  size_t pid;
  uint32_t st;

  if (pkg_s == 0 || lake_s == 0)
    return SLAKE_FS_SPAWN_FAIL;
  pkg = lean_string_cstr(pkg_s);
  lake = lean_string_cstr(lake_s);
  if (slake_fs_fill_cmd_argv(pkg, lake, "query", rest_a, dirarg, sizeof dirarg,
                             argv, SLAKE_FS_MAX_ARGV, &argc) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  saved_cwd[0] = 0;
  if (slake_fs_cmd_chdir_begin(pkg, saved_cwd, sizeof saved_cwd) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  pid = lean_fs_proc_spawn_argv((size_t)(uintptr_t)lake, (size_t)(uintptr_t)argv, argc);
  if (lean_fs_proc_pid_is_neg(pid) != 0u) {
    slake_fs_cmd_chdir_end(saved_cwd);
    return SLAKE_FS_SPAWN_FAIL;
  }
  st = lean_fs_proc_wait(pid);
  slake_fs_cmd_chdir_end(saved_cwd);
  if (st == LEAN_FS_PROC_WAIT_FAIL)
    return SLAKE_FS_WAIT_FAIL;
  return st;
}

/*
 * Run `lake --dir=<pkg> query [rest…]` via freestanding multi-arg **pipe** spawn.
 * Demo/capture only — same residual honesty as pack/cache/unpack pipe path. W96.
 * chdir(pkg) around spawn like multi-arg query (relative path parity with classic).
 */
LEAN_EXPORT uint32_t slake_fs_run_lake_query_pipe(b_lean_obj_arg pkg_s, b_lean_obj_arg lake_s,
                                                   b_lean_obj_arg rest_a) {
  const char *pkg;
  const char *lake;
  char dirarg[4096];
  char saved_cwd[4096];
  size_t argv[SLAKE_FS_MAX_ARGV];
  size_t argc = 0;
  size_t pipe_fds[2];
  size_t pid;
  size_t rd, wr;
  uint32_t st;
  uint32_t pst;
  char buf[4096];
  size_t got;
  size_t total = 0;

  if (pkg_s == 0 || lake_s == 0)
    return SLAKE_FS_SPAWN_FAIL;
  pkg = lean_string_cstr(pkg_s);
  lake = lean_string_cstr(lake_s);
  if (slake_fs_fill_cmd_argv(pkg, lake, "query", rest_a, dirarg, sizeof dirarg,
                             argv, SLAKE_FS_MAX_ARGV, &argc) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  pipe_fds[0] = 0;
  pipe_fds[1] = 0;
  pst = lean_fs_proc_pipe((size_t)(uintptr_t)pipe_fds);
  if (pst != 0u)
    return SLAKE_FS_SPAWN_FAIL;
  rd = pipe_fds[0];
  wr = pipe_fds[1];

  saved_cwd[0] = 0;
  if (slake_fs_cmd_chdir_begin(pkg, saved_cwd, sizeof saved_cwd) != 0) {
    (void)lean_fs_proc_close_raw(wr);
    (void)lean_fs_proc_close_raw(rd);
    return SLAKE_FS_SPAWN_FAIL;
  }

  pid = lean_fs_proc_spawn_argv_pipe(
      (size_t)(uintptr_t)lake, (size_t)(uintptr_t)argv, argc,
      FS_PROC_FD_NONE, wr);
  (void)lean_fs_proc_close_raw(wr);
  if (lean_fs_proc_pid_is_neg(pid) != 0u) {
    (void)lean_fs_proc_close_raw(rd);
    slake_fs_cmd_chdir_end(saved_cwd);
    return SLAKE_FS_SPAWN_FAIL;
  }

  for (;;) {
    got = lean_fs_read(rd, (size_t)(uintptr_t)buf, sizeof buf);
    if (got == (size_t)-1 || got == 0)
      break;
    total += got;
    if (fwrite(buf, 1, got, stdout) != got) {
      continue;
    }
  }
  (void)lean_fs_proc_close_raw(rd);
  fflush(stdout);
  fprintf(stderr, "slake fs_proc_pipe: captured %zu stdout byte(s) via freestanding pipe\n",
          total);

  st = lean_fs_proc_wait(pid);
  slake_fs_cmd_chdir_end(saved_cwd);
  if (st == LEAN_FS_PROC_WAIT_FAIL)
    return SLAKE_FS_WAIT_FAIL;
  return st;
}

/*
 * Run `lake --dir=<pkg> shake [rest…]` via freestanding multi-arg spawn + wait.
 * Same empty-child-env honesty as pack/cache/unpack/query (W97 FS_PROC shake path). Outside CLAIMED.
 * chdir(pkg) around spawn so relative path args match classic cwd=pkg.
 */
LEAN_EXPORT uint32_t slake_fs_run_lake_shake(b_lean_obj_arg pkg_s, b_lean_obj_arg lake_s,
                                              b_lean_obj_arg rest_a) {
  const char *pkg;
  const char *lake;
  char dirarg[4096];
  char saved_cwd[4096];
  size_t argv[SLAKE_FS_MAX_ARGV];
  size_t argc = 0;
  size_t pid;
  uint32_t st;

  if (pkg_s == 0 || lake_s == 0)
    return SLAKE_FS_SPAWN_FAIL;
  pkg = lean_string_cstr(pkg_s);
  lake = lean_string_cstr(lake_s);
  if (slake_fs_fill_cmd_argv(pkg, lake, "shake", rest_a, dirarg, sizeof dirarg,
                             argv, SLAKE_FS_MAX_ARGV, &argc) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  saved_cwd[0] = 0;
  if (slake_fs_cmd_chdir_begin(pkg, saved_cwd, sizeof saved_cwd) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  pid = lean_fs_proc_spawn_argv((size_t)(uintptr_t)lake, (size_t)(uintptr_t)argv, argc);
  if (lean_fs_proc_pid_is_neg(pid) != 0u) {
    slake_fs_cmd_chdir_end(saved_cwd);
    return SLAKE_FS_SPAWN_FAIL;
  }
  st = lean_fs_proc_wait(pid);
  slake_fs_cmd_chdir_end(saved_cwd);
  if (st == LEAN_FS_PROC_WAIT_FAIL)
    return SLAKE_FS_WAIT_FAIL;
  return st;
}

/*
 * Run `lake --dir=<pkg> shake [rest…]` via freestanding multi-arg **pipe** spawn.
 * Demo/capture only — same residual honesty as pack/cache/unpack/query pipe path. W97.
 * chdir(pkg) around spawn like multi-arg shake (relative path parity with classic).
 */
LEAN_EXPORT uint32_t slake_fs_run_lake_shake_pipe(b_lean_obj_arg pkg_s, b_lean_obj_arg lake_s,
                                                   b_lean_obj_arg rest_a) {
  const char *pkg;
  const char *lake;
  char dirarg[4096];
  char saved_cwd[4096];
  size_t argv[SLAKE_FS_MAX_ARGV];
  size_t argc = 0;
  size_t pipe_fds[2];
  size_t pid;
  size_t rd, wr;
  uint32_t st;
  uint32_t pst;
  char buf[4096];
  size_t got;
  size_t total = 0;

  if (pkg_s == 0 || lake_s == 0)
    return SLAKE_FS_SPAWN_FAIL;
  pkg = lean_string_cstr(pkg_s);
  lake = lean_string_cstr(lake_s);
  if (slake_fs_fill_cmd_argv(pkg, lake, "shake", rest_a, dirarg, sizeof dirarg,
                             argv, SLAKE_FS_MAX_ARGV, &argc) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  pipe_fds[0] = 0;
  pipe_fds[1] = 0;
  pst = lean_fs_proc_pipe((size_t)(uintptr_t)pipe_fds);
  if (pst != 0u)
    return SLAKE_FS_SPAWN_FAIL;
  rd = pipe_fds[0];
  wr = pipe_fds[1];

  saved_cwd[0] = 0;
  if (slake_fs_cmd_chdir_begin(pkg, saved_cwd, sizeof saved_cwd) != 0) {
    (void)lean_fs_proc_close_raw(wr);
    (void)lean_fs_proc_close_raw(rd);
    return SLAKE_FS_SPAWN_FAIL;
  }

  pid = lean_fs_proc_spawn_argv_pipe(
      (size_t)(uintptr_t)lake, (size_t)(uintptr_t)argv, argc,
      FS_PROC_FD_NONE, wr);
  (void)lean_fs_proc_close_raw(wr);
  if (lean_fs_proc_pid_is_neg(pid) != 0u) {
    (void)lean_fs_proc_close_raw(rd);
    slake_fs_cmd_chdir_end(saved_cwd);
    return SLAKE_FS_SPAWN_FAIL;
  }

  for (;;) {
    got = lean_fs_read(rd, (size_t)(uintptr_t)buf, sizeof buf);
    if (got == (size_t)-1 || got == 0)
      break;
    total += got;
    if (fwrite(buf, 1, got, stdout) != got) {
      continue;
    }
  }
  (void)lean_fs_proc_close_raw(rd);
  fflush(stdout);
  fprintf(stderr, "slake fs_proc_pipe: captured %zu stdout byte(s) via freestanding pipe\n",
          total);

  st = lean_fs_proc_wait(pid);
  slake_fs_cmd_chdir_end(saved_cwd);
  if (st == LEAN_FS_PROC_WAIT_FAIL)
    return SLAKE_FS_WAIT_FAIL;
  return st;
}

/*
 * Run `lake --dir=<pkg> serve [rest…]` via freestanding multi-arg spawn + wait.
 * Same empty-child-env honesty as pack/cache/unpack/query/shake (W98 FS_PROC serve path). Outside CLAIMED.
 * chdir(pkg) around spawn so relative path args match classic cwd=pkg.
 */
LEAN_EXPORT uint32_t slake_fs_run_lake_serve(b_lean_obj_arg pkg_s, b_lean_obj_arg lake_s,
                                              b_lean_obj_arg rest_a) {
  const char *pkg;
  const char *lake;
  char dirarg[4096];
  char saved_cwd[4096];
  size_t argv[SLAKE_FS_MAX_ARGV];
  size_t argc = 0;
  size_t pid;
  uint32_t st;

  if (pkg_s == 0 || lake_s == 0)
    return SLAKE_FS_SPAWN_FAIL;
  pkg = lean_string_cstr(pkg_s);
  lake = lean_string_cstr(lake_s);
  if (slake_fs_fill_cmd_argv(pkg, lake, "serve", rest_a, dirarg, sizeof dirarg,
                             argv, SLAKE_FS_MAX_ARGV, &argc) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  saved_cwd[0] = 0;
  if (slake_fs_cmd_chdir_begin(pkg, saved_cwd, sizeof saved_cwd) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  pid = lean_fs_proc_spawn_argv((size_t)(uintptr_t)lake, (size_t)(uintptr_t)argv, argc);
  if (lean_fs_proc_pid_is_neg(pid) != 0u) {
    slake_fs_cmd_chdir_end(saved_cwd);
    return SLAKE_FS_SPAWN_FAIL;
  }
  st = lean_fs_proc_wait(pid);
  slake_fs_cmd_chdir_end(saved_cwd);
  if (st == LEAN_FS_PROC_WAIT_FAIL)
    return SLAKE_FS_WAIT_FAIL;
  return st;
}

/*
 * Run `lake --dir=<pkg> serve [rest…]` via freestanding multi-arg **pipe** spawn.
 * Demo/capture only — same residual honesty as pack/cache/unpack/query/shake pipe path. W98.
 * chdir(pkg) around spawn like multi-arg serve (relative path parity with classic).
 */
LEAN_EXPORT uint32_t slake_fs_run_lake_serve_pipe(b_lean_obj_arg pkg_s, b_lean_obj_arg lake_s,
                                                   b_lean_obj_arg rest_a) {
  const char *pkg;
  const char *lake;
  char dirarg[4096];
  char saved_cwd[4096];
  size_t argv[SLAKE_FS_MAX_ARGV];
  size_t argc = 0;
  size_t pipe_fds[2];
  size_t pid;
  size_t rd, wr;
  uint32_t st;
  uint32_t pst;
  char buf[4096];
  size_t got;
  size_t total = 0;

  if (pkg_s == 0 || lake_s == 0)
    return SLAKE_FS_SPAWN_FAIL;
  pkg = lean_string_cstr(pkg_s);
  lake = lean_string_cstr(lake_s);
  if (slake_fs_fill_cmd_argv(pkg, lake, "serve", rest_a, dirarg, sizeof dirarg,
                             argv, SLAKE_FS_MAX_ARGV, &argc) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  pipe_fds[0] = 0;
  pipe_fds[1] = 0;
  pst = lean_fs_proc_pipe((size_t)(uintptr_t)pipe_fds);
  if (pst != 0u)
    return SLAKE_FS_SPAWN_FAIL;
  rd = pipe_fds[0];
  wr = pipe_fds[1];

  saved_cwd[0] = 0;
  if (slake_fs_cmd_chdir_begin(pkg, saved_cwd, sizeof saved_cwd) != 0) {
    (void)lean_fs_proc_close_raw(wr);
    (void)lean_fs_proc_close_raw(rd);
    return SLAKE_FS_SPAWN_FAIL;
  }

  pid = lean_fs_proc_spawn_argv_pipe(
      (size_t)(uintptr_t)lake, (size_t)(uintptr_t)argv, argc,
      FS_PROC_FD_NONE, wr);
  (void)lean_fs_proc_close_raw(wr);
  if (lean_fs_proc_pid_is_neg(pid) != 0u) {
    (void)lean_fs_proc_close_raw(rd);
    slake_fs_cmd_chdir_end(saved_cwd);
    return SLAKE_FS_SPAWN_FAIL;
  }

  for (;;) {
    got = lean_fs_read(rd, (size_t)(uintptr_t)buf, sizeof buf);
    if (got == (size_t)-1 || got == 0)
      break;
    total += got;
    if (fwrite(buf, 1, got, stdout) != got) {
      continue;
    }
  }
  (void)lean_fs_proc_close_raw(rd);
  fflush(stdout);
  fprintf(stderr, "slake fs_proc_pipe: captured %zu stdout byte(s) via freestanding pipe\n",
          total);

  st = lean_fs_proc_wait(pid);
  slake_fs_cmd_chdir_end(saved_cwd);
  if (st == LEAN_FS_PROC_WAIT_FAIL)
    return SLAKE_FS_WAIT_FAIL;
  return st;
}

/*
 * Run `lake --dir=<pkg> upload [rest…]` via freestanding multi-arg spawn + wait.
 * Same empty-child-env honesty as pack/cache/unpack/query/shake/serve (W99 FS_PROC upload path). Outside CLAIMED.
 * chdir(pkg) around spawn so relative path args match classic cwd=pkg.
 */
LEAN_EXPORT uint32_t slake_fs_run_lake_upload(b_lean_obj_arg pkg_s, b_lean_obj_arg lake_s,
                                              b_lean_obj_arg rest_a) {
  const char *pkg;
  const char *lake;
  char dirarg[4096];
  char saved_cwd[4096];
  size_t argv[SLAKE_FS_MAX_ARGV];
  size_t argc = 0;
  size_t pid;
  uint32_t st;

  if (pkg_s == 0 || lake_s == 0)
    return SLAKE_FS_SPAWN_FAIL;
  pkg = lean_string_cstr(pkg_s);
  lake = lean_string_cstr(lake_s);
  if (slake_fs_fill_cmd_argv(pkg, lake, "upload", rest_a, dirarg, sizeof dirarg,
                             argv, SLAKE_FS_MAX_ARGV, &argc) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  saved_cwd[0] = 0;
  if (slake_fs_cmd_chdir_begin(pkg, saved_cwd, sizeof saved_cwd) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  pid = lean_fs_proc_spawn_argv((size_t)(uintptr_t)lake, (size_t)(uintptr_t)argv, argc);
  if (lean_fs_proc_pid_is_neg(pid) != 0u) {
    slake_fs_cmd_chdir_end(saved_cwd);
    return SLAKE_FS_SPAWN_FAIL;
  }
  st = lean_fs_proc_wait(pid);
  slake_fs_cmd_chdir_end(saved_cwd);
  if (st == LEAN_FS_PROC_WAIT_FAIL)
    return SLAKE_FS_WAIT_FAIL;
  return st;
}

/*
 * Run `lake --dir=<pkg> upload [rest…]` via freestanding multi-arg **pipe** spawn.
 * Demo/capture only — same residual honesty as pack/cache/unpack/query/shake/serve pipe path. W99.
 * chdir(pkg) around spawn like multi-arg upload (relative path parity with classic).
 */
LEAN_EXPORT uint32_t slake_fs_run_lake_upload_pipe(b_lean_obj_arg pkg_s, b_lean_obj_arg lake_s,
                                                   b_lean_obj_arg rest_a) {
  const char *pkg;
  const char *lake;
  char dirarg[4096];
  char saved_cwd[4096];
  size_t argv[SLAKE_FS_MAX_ARGV];
  size_t argc = 0;
  size_t pipe_fds[2];
  size_t pid;
  size_t rd, wr;
  uint32_t st;
  uint32_t pst;
  char buf[4096];
  size_t got;
  size_t total = 0;

  if (pkg_s == 0 || lake_s == 0)
    return SLAKE_FS_SPAWN_FAIL;
  pkg = lean_string_cstr(pkg_s);
  lake = lean_string_cstr(lake_s);
  if (slake_fs_fill_cmd_argv(pkg, lake, "upload", rest_a, dirarg, sizeof dirarg,
                             argv, SLAKE_FS_MAX_ARGV, &argc) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  pipe_fds[0] = 0;
  pipe_fds[1] = 0;
  pst = lean_fs_proc_pipe((size_t)(uintptr_t)pipe_fds);
  if (pst != 0u)
    return SLAKE_FS_SPAWN_FAIL;
  rd = pipe_fds[0];
  wr = pipe_fds[1];

  saved_cwd[0] = 0;
  if (slake_fs_cmd_chdir_begin(pkg, saved_cwd, sizeof saved_cwd) != 0) {
    (void)lean_fs_proc_close_raw(wr);
    (void)lean_fs_proc_close_raw(rd);
    return SLAKE_FS_SPAWN_FAIL;
  }

  pid = lean_fs_proc_spawn_argv_pipe(
      (size_t)(uintptr_t)lake, (size_t)(uintptr_t)argv, argc,
      FS_PROC_FD_NONE, wr);
  (void)lean_fs_proc_close_raw(wr);
  if (lean_fs_proc_pid_is_neg(pid) != 0u) {
    (void)lean_fs_proc_close_raw(rd);
    slake_fs_cmd_chdir_end(saved_cwd);
    return SLAKE_FS_SPAWN_FAIL;
  }

  for (;;) {
    got = lean_fs_read(rd, (size_t)(uintptr_t)buf, sizeof buf);
    if (got == (size_t)-1 || got == 0)
      break;
    total += got;
    if (fwrite(buf, 1, got, stdout) != got) {
      continue;
    }
  }
  (void)lean_fs_proc_close_raw(rd);
  fflush(stdout);
  fprintf(stderr, "slake fs_proc_pipe: captured %zu stdout byte(s) via freestanding pipe\n",
          total);

  st = lean_fs_proc_wait(pid);
  slake_fs_cmd_chdir_end(saved_cwd);
  if (st == LEAN_FS_PROC_WAIT_FAIL)
    return SLAKE_FS_WAIT_FAIL;
  return st;
}

/*
 * Run `lake --dir=<pkg> lean [rest…]` via freestanding multi-arg spawn + wait.
 * Same empty-child-env honesty as pack/cache/unpack/query/shake/serve/upload (W100 FS_PROC lean path). Outside CLAIMED.
 * chdir(pkg) around spawn so relative path args match classic cwd=pkg.
 */
LEAN_EXPORT uint32_t slake_fs_run_lake_lean(b_lean_obj_arg pkg_s, b_lean_obj_arg lake_s,
                                              b_lean_obj_arg rest_a) {
  const char *pkg;
  const char *lake;
  char dirarg[4096];
  char saved_cwd[4096];
  size_t argv[SLAKE_FS_MAX_ARGV];
  size_t argc = 0;
  size_t pid;
  uint32_t st;

  if (pkg_s == 0 || lake_s == 0)
    return SLAKE_FS_SPAWN_FAIL;
  pkg = lean_string_cstr(pkg_s);
  lake = lean_string_cstr(lake_s);
  if (slake_fs_fill_cmd_argv(pkg, lake, "lean", rest_a, dirarg, sizeof dirarg,
                             argv, SLAKE_FS_MAX_ARGV, &argc) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  saved_cwd[0] = 0;
  if (slake_fs_cmd_chdir_begin(pkg, saved_cwd, sizeof saved_cwd) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  pid = lean_fs_proc_spawn_argv((size_t)(uintptr_t)lake, (size_t)(uintptr_t)argv, argc);
  if (lean_fs_proc_pid_is_neg(pid) != 0u) {
    slake_fs_cmd_chdir_end(saved_cwd);
    return SLAKE_FS_SPAWN_FAIL;
  }
  st = lean_fs_proc_wait(pid);
  slake_fs_cmd_chdir_end(saved_cwd);
  if (st == LEAN_FS_PROC_WAIT_FAIL)
    return SLAKE_FS_WAIT_FAIL;
  return st;
}

/*
 * Run `lake --dir=<pkg> lean [rest…]` via freestanding multi-arg **pipe** spawn.
 * Demo/capture only — same residual honesty as pack/cache/unpack/query/shake/serve pipe path. W100.
 * chdir(pkg) around spawn like multi-arg lean (relative path parity with classic).
 */
LEAN_EXPORT uint32_t slake_fs_run_lake_lean_pipe(b_lean_obj_arg pkg_s, b_lean_obj_arg lake_s,
                                                   b_lean_obj_arg rest_a) {
  const char *pkg;
  const char *lake;
  char dirarg[4096];
  char saved_cwd[4096];
  size_t argv[SLAKE_FS_MAX_ARGV];
  size_t argc = 0;
  size_t pipe_fds[2];
  size_t pid;
  size_t rd, wr;
  uint32_t st;
  uint32_t pst;
  char buf[4096];
  size_t got;
  size_t total = 0;

  if (pkg_s == 0 || lake_s == 0)
    return SLAKE_FS_SPAWN_FAIL;
  pkg = lean_string_cstr(pkg_s);
  lake = lean_string_cstr(lake_s);
  if (slake_fs_fill_cmd_argv(pkg, lake, "lean", rest_a, dirarg, sizeof dirarg,
                             argv, SLAKE_FS_MAX_ARGV, &argc) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  pipe_fds[0] = 0;
  pipe_fds[1] = 0;
  pst = lean_fs_proc_pipe((size_t)(uintptr_t)pipe_fds);
  if (pst != 0u)
    return SLAKE_FS_SPAWN_FAIL;
  rd = pipe_fds[0];
  wr = pipe_fds[1];

  saved_cwd[0] = 0;
  if (slake_fs_cmd_chdir_begin(pkg, saved_cwd, sizeof saved_cwd) != 0) {
    (void)lean_fs_proc_close_raw(wr);
    (void)lean_fs_proc_close_raw(rd);
    return SLAKE_FS_SPAWN_FAIL;
  }

  pid = lean_fs_proc_spawn_argv_pipe(
      (size_t)(uintptr_t)lake, (size_t)(uintptr_t)argv, argc,
      FS_PROC_FD_NONE, wr);
  (void)lean_fs_proc_close_raw(wr);
  if (lean_fs_proc_pid_is_neg(pid) != 0u) {
    (void)lean_fs_proc_close_raw(rd);
    slake_fs_cmd_chdir_end(saved_cwd);
    return SLAKE_FS_SPAWN_FAIL;
  }

  for (;;) {
    got = lean_fs_read(rd, (size_t)(uintptr_t)buf, sizeof buf);
    if (got == (size_t)-1 || got == 0)
      break;
    total += got;
    if (fwrite(buf, 1, got, stdout) != got) {
      continue;
    }
  }
  (void)lean_fs_proc_close_raw(rd);
  fflush(stdout);
  fprintf(stderr, "slake fs_proc_pipe: captured %zu stdout byte(s) via freestanding pipe\n",
          total);

  st = lean_fs_proc_wait(pid);
  slake_fs_cmd_chdir_end(saved_cwd);
  if (st == LEAN_FS_PROC_WAIT_FAIL)
    return SLAKE_FS_WAIT_FAIL;
  return st;
}

/*
 * Run `lake --dir=<pkg> scripts [rest…]` via freestanding multi-arg spawn + wait.
 * Same empty-child-env honesty as pack/cache/unpack/query/shake/serve/upload/lean (W101 FS_PROC scripts path). Outside CLAIMED.
 * chdir(pkg) around spawn so relative path args match classic cwd=pkg.
 */
LEAN_EXPORT uint32_t slake_fs_run_lake_scripts(b_lean_obj_arg pkg_s, b_lean_obj_arg lake_s,
                                              b_lean_obj_arg rest_a) {
  const char *pkg;
  const char *lake;
  char dirarg[4096];
  char saved_cwd[4096];
  size_t argv[SLAKE_FS_MAX_ARGV];
  size_t argc = 0;
  size_t pid;
  uint32_t st;

  if (pkg_s == 0 || lake_s == 0)
    return SLAKE_FS_SPAWN_FAIL;
  pkg = lean_string_cstr(pkg_s);
  lake = lean_string_cstr(lake_s);
  if (slake_fs_fill_cmd_argv(pkg, lake, "scripts", rest_a, dirarg, sizeof dirarg,
                             argv, SLAKE_FS_MAX_ARGV, &argc) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  saved_cwd[0] = 0;
  if (slake_fs_cmd_chdir_begin(pkg, saved_cwd, sizeof saved_cwd) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  pid = lean_fs_proc_spawn_argv((size_t)(uintptr_t)lake, (size_t)(uintptr_t)argv, argc);
  if (lean_fs_proc_pid_is_neg(pid) != 0u) {
    slake_fs_cmd_chdir_end(saved_cwd);
    return SLAKE_FS_SPAWN_FAIL;
  }
  st = lean_fs_proc_wait(pid);
  slake_fs_cmd_chdir_end(saved_cwd);
  if (st == LEAN_FS_PROC_WAIT_FAIL)
    return SLAKE_FS_WAIT_FAIL;
  return st;
}

/*
 * Run `lake --dir=<pkg> scripts [rest…]` via freestanding multi-arg **pipe** spawn.
 * Demo/capture only — same residual honesty as pack/cache/unpack/query/shake/serve/upload/lean pipe path. W101.
 * chdir(pkg) around spawn like multi-arg scripts (relative path parity with classic).
 */
LEAN_EXPORT uint32_t slake_fs_run_lake_scripts_pipe(b_lean_obj_arg pkg_s, b_lean_obj_arg lake_s,
                                                   b_lean_obj_arg rest_a) {
  const char *pkg;
  const char *lake;
  char dirarg[4096];
  char saved_cwd[4096];
  size_t argv[SLAKE_FS_MAX_ARGV];
  size_t argc = 0;
  size_t pipe_fds[2];
  size_t pid;
  size_t rd, wr;
  uint32_t st;
  uint32_t pst;
  char buf[4096];
  size_t got;
  size_t total = 0;

  if (pkg_s == 0 || lake_s == 0)
    return SLAKE_FS_SPAWN_FAIL;
  pkg = lean_string_cstr(pkg_s);
  lake = lean_string_cstr(lake_s);
  if (slake_fs_fill_cmd_argv(pkg, lake, "scripts", rest_a, dirarg, sizeof dirarg,
                             argv, SLAKE_FS_MAX_ARGV, &argc) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  pipe_fds[0] = 0;
  pipe_fds[1] = 0;
  pst = lean_fs_proc_pipe((size_t)(uintptr_t)pipe_fds);
  if (pst != 0u)
    return SLAKE_FS_SPAWN_FAIL;
  rd = pipe_fds[0];
  wr = pipe_fds[1];

  saved_cwd[0] = 0;
  if (slake_fs_cmd_chdir_begin(pkg, saved_cwd, sizeof saved_cwd) != 0) {
    (void)lean_fs_proc_close_raw(wr);
    (void)lean_fs_proc_close_raw(rd);
    return SLAKE_FS_SPAWN_FAIL;
  }

  pid = lean_fs_proc_spawn_argv_pipe(
      (size_t)(uintptr_t)lake, (size_t)(uintptr_t)argv, argc,
      FS_PROC_FD_NONE, wr);
  (void)lean_fs_proc_close_raw(wr);
  if (lean_fs_proc_pid_is_neg(pid) != 0u) {
    (void)lean_fs_proc_close_raw(rd);
    slake_fs_cmd_chdir_end(saved_cwd);
    return SLAKE_FS_SPAWN_FAIL;
  }

  for (;;) {
    got = lean_fs_read(rd, (size_t)(uintptr_t)buf, sizeof buf);
    if (got == (size_t)-1 || got == 0)
      break;
    total += got;
    if (fwrite(buf, 1, got, stdout) != got) {
      continue;
    }
  }
  (void)lean_fs_proc_close_raw(rd);
  fflush(stdout);
  fprintf(stderr, "slake fs_proc_pipe: captured %zu stdout byte(s) via freestanding pipe\n",
          total);

  st = lean_fs_proc_wait(pid);
  slake_fs_cmd_chdir_end(saved_cwd);
  if (st == LEAN_FS_PROC_WAIT_FAIL)
    return SLAKE_FS_WAIT_FAIL;
  return st;
}

/*
 * Run `lake --dir=<pkg> setup-file [rest…]` via freestanding multi-arg spawn + wait.
 * Same empty-child-env honesty as pack/cache/unpack/query/shake/serve/upload/lean/scripts (W102 FS_PROC setup-file path). Outside CLAIMED.
 * chdir(pkg) around spawn so relative path args match classic cwd=pkg.
 */
LEAN_EXPORT uint32_t slake_fs_run_lake_setup_file(b_lean_obj_arg pkg_s, b_lean_obj_arg lake_s,
                                              b_lean_obj_arg rest_a) {
  const char *pkg;
  const char *lake;
  char dirarg[4096];
  char saved_cwd[4096];
  size_t argv[SLAKE_FS_MAX_ARGV];
  size_t argc = 0;
  size_t pid;
  uint32_t st;

  if (pkg_s == 0 || lake_s == 0)
    return SLAKE_FS_SPAWN_FAIL;
  pkg = lean_string_cstr(pkg_s);
  lake = lean_string_cstr(lake_s);
  if (slake_fs_fill_cmd_argv(pkg, lake, "setup-file", rest_a, dirarg, sizeof dirarg,
                             argv, SLAKE_FS_MAX_ARGV, &argc) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  saved_cwd[0] = 0;
  if (slake_fs_cmd_chdir_begin(pkg, saved_cwd, sizeof saved_cwd) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  pid = lean_fs_proc_spawn_argv((size_t)(uintptr_t)lake, (size_t)(uintptr_t)argv, argc);
  if (lean_fs_proc_pid_is_neg(pid) != 0u) {
    slake_fs_cmd_chdir_end(saved_cwd);
    return SLAKE_FS_SPAWN_FAIL;
  }
  st = lean_fs_proc_wait(pid);
  slake_fs_cmd_chdir_end(saved_cwd);
  if (st == LEAN_FS_PROC_WAIT_FAIL)
    return SLAKE_FS_WAIT_FAIL;
  return st;
}

/*
 * Run `lake --dir=<pkg> setup-file [rest…]` via freestanding multi-arg **pipe** spawn.
 * Demo/capture only — same residual honesty as pack/cache/unpack/query/shake/serve/upload/lean/scripts pipe path. W102.
 * chdir(pkg) around spawn like multi-arg setup-file (relative path parity with classic).
 */
LEAN_EXPORT uint32_t slake_fs_run_lake_setup_file_pipe(b_lean_obj_arg pkg_s, b_lean_obj_arg lake_s,
                                                   b_lean_obj_arg rest_a) {
  const char *pkg;
  const char *lake;
  char dirarg[4096];
  char saved_cwd[4096];
  size_t argv[SLAKE_FS_MAX_ARGV];
  size_t argc = 0;
  size_t pipe_fds[2];
  size_t pid;
  size_t rd, wr;
  uint32_t st;
  uint32_t pst;
  char buf[4096];
  size_t got;
  size_t total = 0;

  if (pkg_s == 0 || lake_s == 0)
    return SLAKE_FS_SPAWN_FAIL;
  pkg = lean_string_cstr(pkg_s);
  lake = lean_string_cstr(lake_s);
  if (slake_fs_fill_cmd_argv(pkg, lake, "setup-file", rest_a, dirarg, sizeof dirarg,
                             argv, SLAKE_FS_MAX_ARGV, &argc) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  pipe_fds[0] = 0;
  pipe_fds[1] = 0;
  pst = lean_fs_proc_pipe((size_t)(uintptr_t)pipe_fds);
  if (pst != 0u)
    return SLAKE_FS_SPAWN_FAIL;
  rd = pipe_fds[0];
  wr = pipe_fds[1];

  saved_cwd[0] = 0;
  if (slake_fs_cmd_chdir_begin(pkg, saved_cwd, sizeof saved_cwd) != 0) {
    (void)lean_fs_proc_close_raw(wr);
    (void)lean_fs_proc_close_raw(rd);
    return SLAKE_FS_SPAWN_FAIL;
  }

  pid = lean_fs_proc_spawn_argv_pipe(
      (size_t)(uintptr_t)lake, (size_t)(uintptr_t)argv, argc,
      FS_PROC_FD_NONE, wr);
  (void)lean_fs_proc_close_raw(wr);
  if (lean_fs_proc_pid_is_neg(pid) != 0u) {
    (void)lean_fs_proc_close_raw(rd);
    slake_fs_cmd_chdir_end(saved_cwd);
    return SLAKE_FS_SPAWN_FAIL;
  }

  for (;;) {
    got = lean_fs_read(rd, (size_t)(uintptr_t)buf, sizeof buf);
    if (got == (size_t)-1 || got == 0)
      break;
    total += got;
    if (fwrite(buf, 1, got, stdout) != got) {
      continue;
    }
  }
  (void)lean_fs_proc_close_raw(rd);
  fflush(stdout);
  fprintf(stderr, "slake fs_proc_pipe: captured %zu stdout byte(s) via freestanding pipe\n",
          total);

  st = lean_fs_proc_wait(pid);
  slake_fs_cmd_chdir_end(saved_cwd);
  if (st == LEAN_FS_PROC_WAIT_FAIL)
    return SLAKE_FS_WAIT_FAIL;
  return st;
}


/*
 * Run `lake --dir=<pkg> self-check [rest…]` via freestanding multi-arg spawn + wait.
 * Same empty-child-env honesty as pack/cache/unpack/query/shake/serve/upload/lean/scripts/setup-file (W103 FS_PROC self-check path). Outside CLAIMED.
 * chdir(pkg) around spawn so relative path args match classic cwd=pkg.
 */
LEAN_EXPORT uint32_t slake_fs_run_lake_self_check(b_lean_obj_arg pkg_s, b_lean_obj_arg lake_s,
                                              b_lean_obj_arg rest_a) {
  const char *pkg;
  const char *lake;
  char dirarg[4096];
  char saved_cwd[4096];
  size_t argv[SLAKE_FS_MAX_ARGV];
  size_t argc = 0;
  size_t pid;
  uint32_t st;

  if (pkg_s == 0 || lake_s == 0)
    return SLAKE_FS_SPAWN_FAIL;
  pkg = lean_string_cstr(pkg_s);
  lake = lean_string_cstr(lake_s);
  if (slake_fs_fill_cmd_argv(pkg, lake, "self-check", rest_a, dirarg, sizeof dirarg,
                             argv, SLAKE_FS_MAX_ARGV, &argc) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  saved_cwd[0] = 0;
  if (slake_fs_cmd_chdir_begin(pkg, saved_cwd, sizeof saved_cwd) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  pid = lean_fs_proc_spawn_argv((size_t)(uintptr_t)lake, (size_t)(uintptr_t)argv, argc);
  if (lean_fs_proc_pid_is_neg(pid) != 0u) {
    slake_fs_cmd_chdir_end(saved_cwd);
    return SLAKE_FS_SPAWN_FAIL;
  }
  st = lean_fs_proc_wait(pid);
  slake_fs_cmd_chdir_end(saved_cwd);
  if (st == LEAN_FS_PROC_WAIT_FAIL)
    return SLAKE_FS_WAIT_FAIL;
  return st;
}

/*
 * Run `lake --dir=<pkg> self-check [rest…]` via freestanding multi-arg **pipe** spawn.
 * Demo/capture only — same residual honesty as pack/cache/unpack/query/shake/serve/upload/lean/scripts/setup-file pipe path. W103.
 * chdir(pkg) around spawn like multi-arg self-check (relative path parity with classic).
 */
LEAN_EXPORT uint32_t slake_fs_run_lake_self_check_pipe(b_lean_obj_arg pkg_s, b_lean_obj_arg lake_s,
                                                   b_lean_obj_arg rest_a) {
  const char *pkg;
  const char *lake;
  char dirarg[4096];
  char saved_cwd[4096];
  size_t argv[SLAKE_FS_MAX_ARGV];
  size_t argc = 0;
  size_t pipe_fds[2];
  size_t pid;
  size_t rd, wr;
  uint32_t st;
  uint32_t pst;
  char buf[4096];
  size_t got;
  size_t total = 0;

  if (pkg_s == 0 || lake_s == 0)
    return SLAKE_FS_SPAWN_FAIL;
  pkg = lean_string_cstr(pkg_s);
  lake = lean_string_cstr(lake_s);
  if (slake_fs_fill_cmd_argv(pkg, lake, "self-check", rest_a, dirarg, sizeof dirarg,
                             argv, SLAKE_FS_MAX_ARGV, &argc) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  pipe_fds[0] = 0;
  pipe_fds[1] = 0;
  pst = lean_fs_proc_pipe((size_t)(uintptr_t)pipe_fds);
  if (pst != 0u)
    return SLAKE_FS_SPAWN_FAIL;
  rd = pipe_fds[0];
  wr = pipe_fds[1];

  saved_cwd[0] = 0;
  if (slake_fs_cmd_chdir_begin(pkg, saved_cwd, sizeof saved_cwd) != 0) {
    (void)lean_fs_proc_close_raw(wr);
    (void)lean_fs_proc_close_raw(rd);
    return SLAKE_FS_SPAWN_FAIL;
  }

  pid = lean_fs_proc_spawn_argv_pipe(
      (size_t)(uintptr_t)lake, (size_t)(uintptr_t)argv, argc,
      FS_PROC_FD_NONE, wr);
  (void)lean_fs_proc_close_raw(wr);
  if (lean_fs_proc_pid_is_neg(pid) != 0u) {
    (void)lean_fs_proc_close_raw(rd);
    slake_fs_cmd_chdir_end(saved_cwd);
    return SLAKE_FS_SPAWN_FAIL;
  }

  for (;;) {
    got = lean_fs_read(rd, (size_t)(uintptr_t)buf, sizeof buf);
    if (got == (size_t)-1 || got == 0)
      break;
    total += got;
    if (fwrite(buf, 1, got, stdout) != got) {
      continue;
    }
  }
  (void)lean_fs_proc_close_raw(rd);
  fflush(stdout);
  fprintf(stderr, "slake fs_proc_pipe: captured %zu stdout byte(s) via freestanding pipe\n",
          total);

  st = lean_fs_proc_wait(pid);
  slake_fs_cmd_chdir_end(saved_cwd);
  if (st == LEAN_FS_PROC_WAIT_FAIL)
    return SLAKE_FS_WAIT_FAIL;
  return st;
}

/*
 * Run `lake --dir=<pkg> version-tags [rest…]` via freestanding multi-arg spawn + wait.
 * Same empty-child-env honesty as pack/cache/unpack/query/shake/serve/upload/lean/scripts/setup-file/self-check (W104 FS_PROC version-tags path). Outside CLAIMED.
 * chdir(pkg) around spawn so relative path args match classic cwd=pkg.
 */
LEAN_EXPORT uint32_t slake_fs_run_lake_version_tags(b_lean_obj_arg pkg_s, b_lean_obj_arg lake_s,
                                              b_lean_obj_arg rest_a) {
  const char *pkg;
  const char *lake;
  char dirarg[4096];
  char saved_cwd[4096];
  size_t argv[SLAKE_FS_MAX_ARGV];
  size_t argc = 0;
  size_t pid;
  uint32_t st;

  if (pkg_s == 0 || lake_s == 0)
    return SLAKE_FS_SPAWN_FAIL;
  pkg = lean_string_cstr(pkg_s);
  lake = lean_string_cstr(lake_s);
  if (slake_fs_fill_cmd_argv(pkg, lake, "version-tags", rest_a, dirarg, sizeof dirarg,
                             argv, SLAKE_FS_MAX_ARGV, &argc) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  saved_cwd[0] = 0;
  if (slake_fs_cmd_chdir_begin(pkg, saved_cwd, sizeof saved_cwd) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  pid = lean_fs_proc_spawn_argv((size_t)(uintptr_t)lake, (size_t)(uintptr_t)argv, argc);
  if (lean_fs_proc_pid_is_neg(pid) != 0u) {
    slake_fs_cmd_chdir_end(saved_cwd);
    return SLAKE_FS_SPAWN_FAIL;
  }
  st = lean_fs_proc_wait(pid);
  slake_fs_cmd_chdir_end(saved_cwd);
  if (st == LEAN_FS_PROC_WAIT_FAIL)
    return SLAKE_FS_WAIT_FAIL;
  return st;
}

/*
 * Run `lake --dir=<pkg> version-tags [rest…]` via freestanding multi-arg **pipe** spawn.
 * Demo/capture only — same residual honesty as pack/cache/unpack/query/shake/serve/upload/lean/scripts/setup-file/self-check pipe path. W104.
 * chdir(pkg) around spawn like multi-arg version-tags (relative path parity with classic).
 */
LEAN_EXPORT uint32_t slake_fs_run_lake_version_tags_pipe(b_lean_obj_arg pkg_s, b_lean_obj_arg lake_s,
                                                   b_lean_obj_arg rest_a) {
  const char *pkg;
  const char *lake;
  char dirarg[4096];
  char saved_cwd[4096];
  size_t argv[SLAKE_FS_MAX_ARGV];
  size_t argc = 0;
  size_t pipe_fds[2];
  size_t pid;
  size_t rd, wr;
  uint32_t st;
  uint32_t pst;
  char buf[4096];
  size_t got;
  size_t total = 0;

  if (pkg_s == 0 || lake_s == 0)
    return SLAKE_FS_SPAWN_FAIL;
  pkg = lean_string_cstr(pkg_s);
  lake = lean_string_cstr(lake_s);
  if (slake_fs_fill_cmd_argv(pkg, lake, "version-tags", rest_a, dirarg, sizeof dirarg,
                             argv, SLAKE_FS_MAX_ARGV, &argc) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  pipe_fds[0] = 0;
  pipe_fds[1] = 0;
  pst = lean_fs_proc_pipe((size_t)(uintptr_t)pipe_fds);
  if (pst != 0u)
    return SLAKE_FS_SPAWN_FAIL;
  rd = pipe_fds[0];
  wr = pipe_fds[1];

  saved_cwd[0] = 0;
  if (slake_fs_cmd_chdir_begin(pkg, saved_cwd, sizeof saved_cwd) != 0) {
    (void)lean_fs_proc_close_raw(wr);
    (void)lean_fs_proc_close_raw(rd);
    return SLAKE_FS_SPAWN_FAIL;
  }

  pid = lean_fs_proc_spawn_argv_pipe(
      (size_t)(uintptr_t)lake, (size_t)(uintptr_t)argv, argc,
      FS_PROC_FD_NONE, wr);
  (void)lean_fs_proc_close_raw(wr);
  if (lean_fs_proc_pid_is_neg(pid) != 0u) {
    (void)lean_fs_proc_close_raw(rd);
    slake_fs_cmd_chdir_end(saved_cwd);
    return SLAKE_FS_SPAWN_FAIL;
  }

  for (;;) {
    got = lean_fs_read(rd, (size_t)(uintptr_t)buf, sizeof buf);
    if (got == (size_t)-1 || got == 0)
      break;
    total += got;
    if (fwrite(buf, 1, got, stdout) != got) {
      continue;
    }
  }
  (void)lean_fs_proc_close_raw(rd);
  fflush(stdout);
  fprintf(stderr, "slake fs_proc_pipe: captured %zu stdout byte(s) via freestanding pipe\n",
          total);

  st = lean_fs_proc_wait(pid);
  slake_fs_cmd_chdir_end(saved_cwd);
  if (st == LEAN_FS_PROC_WAIT_FAIL)
    return SLAKE_FS_WAIT_FAIL;
  return st;
}

/*
 * Run `lake --dir=<pkg> translate-config [rest…]` via freestanding multi-arg spawn + wait.
 * Same empty-child-env honesty as pack/cache/unpack/query/shake/serve/upload/lean/scripts/setup-file/self-check/version-tags (W105 FS_PROC translate-config path). Outside CLAIMED.
 * chdir(pkg) around spawn so relative path args match classic cwd=pkg.
 */
LEAN_EXPORT uint32_t slake_fs_run_lake_translate_config(b_lean_obj_arg pkg_s, b_lean_obj_arg lake_s,
                                              b_lean_obj_arg rest_a) {
  const char *pkg;
  const char *lake;
  char dirarg[4096];
  char saved_cwd[4096];
  size_t argv[SLAKE_FS_MAX_ARGV];
  size_t argc = 0;
  size_t pid;
  uint32_t st;

  if (pkg_s == 0 || lake_s == 0)
    return SLAKE_FS_SPAWN_FAIL;
  pkg = lean_string_cstr(pkg_s);
  lake = lean_string_cstr(lake_s);
  if (slake_fs_fill_cmd_argv(pkg, lake, "translate-config", rest_a, dirarg, sizeof dirarg,
                             argv, SLAKE_FS_MAX_ARGV, &argc) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  saved_cwd[0] = 0;
  if (slake_fs_cmd_chdir_begin(pkg, saved_cwd, sizeof saved_cwd) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  pid = lean_fs_proc_spawn_argv((size_t)(uintptr_t)lake, (size_t)(uintptr_t)argv, argc);
  if (lean_fs_proc_pid_is_neg(pid) != 0u) {
    slake_fs_cmd_chdir_end(saved_cwd);
    return SLAKE_FS_SPAWN_FAIL;
  }
  st = lean_fs_proc_wait(pid);
  slake_fs_cmd_chdir_end(saved_cwd);
  if (st == LEAN_FS_PROC_WAIT_FAIL)
    return SLAKE_FS_WAIT_FAIL;
  return st;
}

/*
 * Run `lake --dir=<pkg> translate-config [rest…]` via freestanding multi-arg **pipe** spawn.
 * Demo/capture only — same residual honesty as pack/cache/unpack/query/shake/serve/upload/lean/scripts/setup-file/self-check pipe path. W105.
 * chdir(pkg) around spawn like multi-arg translate-config (relative path parity with classic).
 */
LEAN_EXPORT uint32_t slake_fs_run_lake_translate_config_pipe(b_lean_obj_arg pkg_s, b_lean_obj_arg lake_s,
                                                   b_lean_obj_arg rest_a) {
  const char *pkg;
  const char *lake;
  char dirarg[4096];
  char saved_cwd[4096];
  size_t argv[SLAKE_FS_MAX_ARGV];
  size_t argc = 0;
  size_t pipe_fds[2];
  size_t pid;
  size_t rd, wr;
  uint32_t st;
  uint32_t pst;
  char buf[4096];
  size_t got;
  size_t total = 0;

  if (pkg_s == 0 || lake_s == 0)
    return SLAKE_FS_SPAWN_FAIL;
  pkg = lean_string_cstr(pkg_s);
  lake = lean_string_cstr(lake_s);
  if (slake_fs_fill_cmd_argv(pkg, lake, "translate-config", rest_a, dirarg, sizeof dirarg,
                             argv, SLAKE_FS_MAX_ARGV, &argc) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  pipe_fds[0] = 0;
  pipe_fds[1] = 0;
  pst = lean_fs_proc_pipe((size_t)(uintptr_t)pipe_fds);
  if (pst != 0u)
    return SLAKE_FS_SPAWN_FAIL;
  rd = pipe_fds[0];
  wr = pipe_fds[1];

  saved_cwd[0] = 0;
  if (slake_fs_cmd_chdir_begin(pkg, saved_cwd, sizeof saved_cwd) != 0) {
    (void)lean_fs_proc_close_raw(wr);
    (void)lean_fs_proc_close_raw(rd);
    return SLAKE_FS_SPAWN_FAIL;
  }

  pid = lean_fs_proc_spawn_argv_pipe(
      (size_t)(uintptr_t)lake, (size_t)(uintptr_t)argv, argc,
      FS_PROC_FD_NONE, wr);
  (void)lean_fs_proc_close_raw(wr);
  if (lean_fs_proc_pid_is_neg(pid) != 0u) {
    (void)lean_fs_proc_close_raw(rd);
    slake_fs_cmd_chdir_end(saved_cwd);
    return SLAKE_FS_SPAWN_FAIL;
  }

  for (;;) {
    got = lean_fs_read(rd, (size_t)(uintptr_t)buf, sizeof buf);
    if (got == (size_t)-1 || got == 0)
      break;
    total += got;
    if (fwrite(buf, 1, got, stdout) != got) {
      continue;
    }
  }
  (void)lean_fs_proc_close_raw(rd);
  fflush(stdout);
  fprintf(stderr, "slake fs_proc_pipe: captured %zu stdout byte(s) via freestanding pipe\n",
          total);

  st = lean_fs_proc_wait(pid);
  slake_fs_cmd_chdir_end(saved_cwd);
  if (st == LEAN_FS_PROC_WAIT_FAIL)
    return SLAKE_FS_WAIT_FAIL;
  return st;
}

/*
 * Run `lake --dir=<pkg> run [rest…]` via freestanding multi-arg spawn + wait.
 * Same empty-child-env honesty as pack/cache/unpack/query/shake/serve/upload/lean/scripts/setup-file/self-check/version-tags (W106 FS_PROC run path). Outside CLAIMED.
 * chdir(pkg) around spawn so relative path args match classic cwd=pkg.
 */
LEAN_EXPORT uint32_t slake_fs_run_lake_run(b_lean_obj_arg pkg_s, b_lean_obj_arg lake_s,
                                              b_lean_obj_arg rest_a) {
  const char *pkg;
  const char *lake;
  char dirarg[4096];
  char saved_cwd[4096];
  size_t argv[SLAKE_FS_MAX_ARGV];
  size_t argc = 0;
  size_t pid;
  uint32_t st;

  if (pkg_s == 0 || lake_s == 0)
    return SLAKE_FS_SPAWN_FAIL;
  pkg = lean_string_cstr(pkg_s);
  lake = lean_string_cstr(lake_s);
  if (slake_fs_fill_cmd_argv(pkg, lake, "run", rest_a, dirarg, sizeof dirarg,
                             argv, SLAKE_FS_MAX_ARGV, &argc) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  saved_cwd[0] = 0;
  if (slake_fs_cmd_chdir_begin(pkg, saved_cwd, sizeof saved_cwd) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  pid = lean_fs_proc_spawn_argv((size_t)(uintptr_t)lake, (size_t)(uintptr_t)argv, argc);
  if (lean_fs_proc_pid_is_neg(pid) != 0u) {
    slake_fs_cmd_chdir_end(saved_cwd);
    return SLAKE_FS_SPAWN_FAIL;
  }
  st = lean_fs_proc_wait(pid);
  slake_fs_cmd_chdir_end(saved_cwd);
  if (st == LEAN_FS_PROC_WAIT_FAIL)
    return SLAKE_FS_WAIT_FAIL;
  return st;
}

/*
 * Run `lake --dir=<pkg> run [rest…]` via freestanding multi-arg **pipe** spawn.
 * Demo/capture only — same residual honesty as pack/cache/unpack/query/shake/serve/upload/lean/scripts/setup-file/self-check pipe path. W106.
 * chdir(pkg) around spawn like multi-arg run (relative path parity with classic).
 */
LEAN_EXPORT uint32_t slake_fs_run_lake_run_pipe(b_lean_obj_arg pkg_s, b_lean_obj_arg lake_s,
                                                   b_lean_obj_arg rest_a) {
  const char *pkg;
  const char *lake;
  char dirarg[4096];
  char saved_cwd[4096];
  size_t argv[SLAKE_FS_MAX_ARGV];
  size_t argc = 0;
  size_t pipe_fds[2];
  size_t pid;
  size_t rd, wr;
  uint32_t st;
  uint32_t pst;
  char buf[4096];
  size_t got;
  size_t total = 0;

  if (pkg_s == 0 || lake_s == 0)
    return SLAKE_FS_SPAWN_FAIL;
  pkg = lean_string_cstr(pkg_s);
  lake = lean_string_cstr(lake_s);
  if (slake_fs_fill_cmd_argv(pkg, lake, "run", rest_a, dirarg, sizeof dirarg,
                             argv, SLAKE_FS_MAX_ARGV, &argc) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  pipe_fds[0] = 0;
  pipe_fds[1] = 0;
  pst = lean_fs_proc_pipe((size_t)(uintptr_t)pipe_fds);
  if (pst != 0u)
    return SLAKE_FS_SPAWN_FAIL;
  rd = pipe_fds[0];
  wr = pipe_fds[1];

  saved_cwd[0] = 0;
  if (slake_fs_cmd_chdir_begin(pkg, saved_cwd, sizeof saved_cwd) != 0) {
    (void)lean_fs_proc_close_raw(wr);
    (void)lean_fs_proc_close_raw(rd);
    return SLAKE_FS_SPAWN_FAIL;
  }

  pid = lean_fs_proc_spawn_argv_pipe(
      (size_t)(uintptr_t)lake, (size_t)(uintptr_t)argv, argc,
      FS_PROC_FD_NONE, wr);
  (void)lean_fs_proc_close_raw(wr);
  if (lean_fs_proc_pid_is_neg(pid) != 0u) {
    (void)lean_fs_proc_close_raw(rd);
    slake_fs_cmd_chdir_end(saved_cwd);
    return SLAKE_FS_SPAWN_FAIL;
  }

  for (;;) {
    got = lean_fs_read(rd, (size_t)(uintptr_t)buf, sizeof buf);
    if (got == (size_t)-1 || got == 0)
      break;
    total += got;
    if (fwrite(buf, 1, got, stdout) != got) {
      continue;
    }
  }
  (void)lean_fs_proc_close_raw(rd);
  fflush(stdout);
  fprintf(stderr, "slake fs_proc_pipe: captured %zu stdout byte(s) via freestanding pipe\n",
          total);

  st = lean_fs_proc_wait(pid);
  slake_fs_cmd_chdir_end(saved_cwd);
  if (st == LEAN_FS_PROC_WAIT_FAIL)
    return SLAKE_FS_WAIT_FAIL;
  return st;
}

/*
 * Run `lake --dir=<pkg> check-build [rest…]` via freestanding multi-arg spawn + wait.
 * Same empty-child-env honesty as pack/cache/unpack/query/shake/serve/upload/lean/scripts/setup-file/self-check/version-tags/run (W109 FS_PROC check-build path). Outside CLAIMED.
 * chdir(pkg) around spawn so relative path args match classic cwd=pkg.
 */
LEAN_EXPORT uint32_t slake_fs_run_lake_check_build(b_lean_obj_arg pkg_s, b_lean_obj_arg lake_s,
                                              b_lean_obj_arg rest_a) {
  const char *pkg;
  const char *lake;
  char dirarg[4096];
  char saved_cwd[4096];
  size_t argv[SLAKE_FS_MAX_ARGV];
  size_t argc = 0;
  size_t pid;
  uint32_t st;

  if (pkg_s == 0 || lake_s == 0)
    return SLAKE_FS_SPAWN_FAIL;
  pkg = lean_string_cstr(pkg_s);
  lake = lean_string_cstr(lake_s);
  if (slake_fs_fill_cmd_argv(pkg, lake, "check-build", rest_a, dirarg, sizeof dirarg,
                             argv, SLAKE_FS_MAX_ARGV, &argc) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  saved_cwd[0] = 0;
  if (slake_fs_cmd_chdir_begin(pkg, saved_cwd, sizeof saved_cwd) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  pid = lean_fs_proc_spawn_argv((size_t)(uintptr_t)lake, (size_t)(uintptr_t)argv, argc);
  if (lean_fs_proc_pid_is_neg(pid) != 0u) {
    slake_fs_cmd_chdir_end(saved_cwd);
    return SLAKE_FS_SPAWN_FAIL;
  }
  st = lean_fs_proc_wait(pid);
  slake_fs_cmd_chdir_end(saved_cwd);
  if (st == LEAN_FS_PROC_WAIT_FAIL)
    return SLAKE_FS_WAIT_FAIL;
  return st;
}

/*
 * Run `lake --dir=<pkg> check-build [rest…]` via freestanding multi-arg **pipe** spawn.
 * Demo/capture only — same residual honesty as pack/cache/unpack/query/shake/serve/upload/lean/scripts/setup-file/self-check pipe path. W109.
 * chdir(pkg) around spawn like multi-arg check-build (relative path parity with classic).
 */
LEAN_EXPORT uint32_t slake_fs_run_lake_check_build_pipe(b_lean_obj_arg pkg_s, b_lean_obj_arg lake_s,
                                                   b_lean_obj_arg rest_a) {
  const char *pkg;
  const char *lake;
  char dirarg[4096];
  char saved_cwd[4096];
  size_t argv[SLAKE_FS_MAX_ARGV];
  size_t argc = 0;
  size_t pipe_fds[2];
  size_t pid;
  size_t rd, wr;
  uint32_t st;
  uint32_t pst;
  char buf[4096];
  size_t got;
  size_t total = 0;

  if (pkg_s == 0 || lake_s == 0)
    return SLAKE_FS_SPAWN_FAIL;
  pkg = lean_string_cstr(pkg_s);
  lake = lean_string_cstr(lake_s);
  if (slake_fs_fill_cmd_argv(pkg, lake, "check-build", rest_a, dirarg, sizeof dirarg,
                             argv, SLAKE_FS_MAX_ARGV, &argc) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  pipe_fds[0] = 0;
  pipe_fds[1] = 0;
  pst = lean_fs_proc_pipe((size_t)(uintptr_t)pipe_fds);
  if (pst != 0u)
    return SLAKE_FS_SPAWN_FAIL;
  rd = pipe_fds[0];
  wr = pipe_fds[1];

  saved_cwd[0] = 0;
  if (slake_fs_cmd_chdir_begin(pkg, saved_cwd, sizeof saved_cwd) != 0) {
    (void)lean_fs_proc_close_raw(wr);
    (void)lean_fs_proc_close_raw(rd);
    return SLAKE_FS_SPAWN_FAIL;
  }

  pid = lean_fs_proc_spawn_argv_pipe(
      (size_t)(uintptr_t)lake, (size_t)(uintptr_t)argv, argc,
      FS_PROC_FD_NONE, wr);
  (void)lean_fs_proc_close_raw(wr);
  if (lean_fs_proc_pid_is_neg(pid) != 0u) {
    (void)lean_fs_proc_close_raw(rd);
    slake_fs_cmd_chdir_end(saved_cwd);
    return SLAKE_FS_SPAWN_FAIL;
  }

  for (;;) {
    got = lean_fs_read(rd, (size_t)(uintptr_t)buf, sizeof buf);
    if (got == (size_t)-1 || got == 0)
      break;
    total += got;
    if (fwrite(buf, 1, got, stdout) != got) {
      continue;
    }
  }
  (void)lean_fs_proc_close_raw(rd);
  fflush(stdout);
  fprintf(stderr, "slake fs_proc_pipe: captured %zu stdout byte(s) via freestanding pipe\n",
          total);

  st = lean_fs_proc_wait(pid);
  slake_fs_cmd_chdir_end(saved_cwd);
  if (st == LEAN_FS_PROC_WAIT_FAIL)
    return SLAKE_FS_WAIT_FAIL;
  return st;
}
/*
 * Run `lake --dir=<pkg> check-test [rest…]` via freestanding multi-arg spawn + wait.
 * Same empty-child-env honesty as pack/cache/unpack/query/shake/serve/upload/lean/scripts/setup-file/self-check/version-tags/run (W110 FS_PROC check-test path). Outside CLAIMED.
 * chdir(pkg) around spawn so relative path args match classic cwd=pkg.
 */
LEAN_EXPORT uint32_t slake_fs_run_lake_check_test(b_lean_obj_arg pkg_s, b_lean_obj_arg lake_s,
                                              b_lean_obj_arg rest_a) {
  const char *pkg;
  const char *lake;
  char dirarg[4096];
  char saved_cwd[4096];
  size_t argv[SLAKE_FS_MAX_ARGV];
  size_t argc = 0;
  size_t pid;
  uint32_t st;

  if (pkg_s == 0 || lake_s == 0)
    return SLAKE_FS_SPAWN_FAIL;
  pkg = lean_string_cstr(pkg_s);
  lake = lean_string_cstr(lake_s);
  if (slake_fs_fill_cmd_argv(pkg, lake, "check-test", rest_a, dirarg, sizeof dirarg,
                             argv, SLAKE_FS_MAX_ARGV, &argc) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  saved_cwd[0] = 0;
  if (slake_fs_cmd_chdir_begin(pkg, saved_cwd, sizeof saved_cwd) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  pid = lean_fs_proc_spawn_argv((size_t)(uintptr_t)lake, (size_t)(uintptr_t)argv, argc);
  if (lean_fs_proc_pid_is_neg(pid) != 0u) {
    slake_fs_cmd_chdir_end(saved_cwd);
    return SLAKE_FS_SPAWN_FAIL;
  }
  st = lean_fs_proc_wait(pid);
  slake_fs_cmd_chdir_end(saved_cwd);
  if (st == LEAN_FS_PROC_WAIT_FAIL)
    return SLAKE_FS_WAIT_FAIL;
  return st;
}

/*
 * Run `lake --dir=<pkg> check-test [rest…]` via freestanding multi-arg **pipe** spawn.
 * Demo/capture only — same residual honesty as pack/cache/unpack/query/shake/serve/upload/lean/scripts/setup-file/self-check pipe path. W110.
 * chdir(pkg) around spawn like multi-arg check-test (relative path parity with classic).
 */
LEAN_EXPORT uint32_t slake_fs_run_lake_check_test_pipe(b_lean_obj_arg pkg_s, b_lean_obj_arg lake_s,
                                                   b_lean_obj_arg rest_a) {
  const char *pkg;
  const char *lake;
  char dirarg[4096];
  char saved_cwd[4096];
  size_t argv[SLAKE_FS_MAX_ARGV];
  size_t argc = 0;
  size_t pipe_fds[2];
  size_t pid;
  size_t rd, wr;
  uint32_t st;
  uint32_t pst;
  char buf[4096];
  size_t got;
  size_t total = 0;

  if (pkg_s == 0 || lake_s == 0)
    return SLAKE_FS_SPAWN_FAIL;
  pkg = lean_string_cstr(pkg_s);
  lake = lean_string_cstr(lake_s);
  if (slake_fs_fill_cmd_argv(pkg, lake, "check-test", rest_a, dirarg, sizeof dirarg,
                             argv, SLAKE_FS_MAX_ARGV, &argc) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  pipe_fds[0] = 0;
  pipe_fds[1] = 0;
  pst = lean_fs_proc_pipe((size_t)(uintptr_t)pipe_fds);
  if (pst != 0u)
    return SLAKE_FS_SPAWN_FAIL;
  rd = pipe_fds[0];
  wr = pipe_fds[1];

  saved_cwd[0] = 0;
  if (slake_fs_cmd_chdir_begin(pkg, saved_cwd, sizeof saved_cwd) != 0) {
    (void)lean_fs_proc_close_raw(wr);
    (void)lean_fs_proc_close_raw(rd);
    return SLAKE_FS_SPAWN_FAIL;
  }

  pid = lean_fs_proc_spawn_argv_pipe(
      (size_t)(uintptr_t)lake, (size_t)(uintptr_t)argv, argc,
      FS_PROC_FD_NONE, wr);
  (void)lean_fs_proc_close_raw(wr);
  if (lean_fs_proc_pid_is_neg(pid) != 0u) {
    (void)lean_fs_proc_close_raw(rd);
    slake_fs_cmd_chdir_end(saved_cwd);
    return SLAKE_FS_SPAWN_FAIL;
  }

  for (;;) {
    got = lean_fs_read(rd, (size_t)(uintptr_t)buf, sizeof buf);
    if (got == (size_t)-1 || got == 0)
      break;
    total += got;
    if (fwrite(buf, 1, got, stdout) != got) {
      continue;
    }
  }
  (void)lean_fs_proc_close_raw(rd);
  fflush(stdout);
  fprintf(stderr, "slake fs_proc_pipe: captured %zu stdout byte(s) via freestanding pipe\n",
          total);

  st = lean_fs_proc_wait(pid);
  slake_fs_cmd_chdir_end(saved_cwd);
  if (st == LEAN_FS_PROC_WAIT_FAIL)
    return SLAKE_FS_WAIT_FAIL;
  return st;
}

/*
 * Run `lake --dir=<pkg> check-lint [rest…]` via freestanding multi-arg spawn + wait.
 * Same empty-child-env honesty as pack/cache/unpack/query/shake/serve/upload/lean/scripts/setup-file/self-check/version-tags/run/check-test (W111 FS_PROC check-lint path). Outside CLAIMED.
 * chdir(pkg) around spawn so relative path args match classic cwd=pkg.
 */
LEAN_EXPORT uint32_t slake_fs_run_lake_check_lint(b_lean_obj_arg pkg_s, b_lean_obj_arg lake_s,
                                              b_lean_obj_arg rest_a) {
  const char *pkg;
  const char *lake;
  char dirarg[4096];
  char saved_cwd[4096];
  size_t argv[SLAKE_FS_MAX_ARGV];
  size_t argc = 0;
  size_t pid;
  uint32_t st;

  if (pkg_s == 0 || lake_s == 0)
    return SLAKE_FS_SPAWN_FAIL;
  pkg = lean_string_cstr(pkg_s);
  lake = lean_string_cstr(lake_s);
  if (slake_fs_fill_cmd_argv(pkg, lake, "check-lint", rest_a, dirarg, sizeof dirarg,
                             argv, SLAKE_FS_MAX_ARGV, &argc) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  saved_cwd[0] = 0;
  if (slake_fs_cmd_chdir_begin(pkg, saved_cwd, sizeof saved_cwd) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  pid = lean_fs_proc_spawn_argv((size_t)(uintptr_t)lake, (size_t)(uintptr_t)argv, argc);
  if (lean_fs_proc_pid_is_neg(pid) != 0u) {
    slake_fs_cmd_chdir_end(saved_cwd);
    return SLAKE_FS_SPAWN_FAIL;
  }
  st = lean_fs_proc_wait(pid);
  slake_fs_cmd_chdir_end(saved_cwd);
  if (st == LEAN_FS_PROC_WAIT_FAIL)
    return SLAKE_FS_WAIT_FAIL;
  return st;
}

/*
 * Run `lake --dir=<pkg> check-lint [rest…]` via freestanding multi-arg **pipe** spawn.
 * Demo/capture only — same residual honesty as pack/cache/unpack/query/shake/serve/upload/lean/scripts/setup-file/self-check pipe path. W111.
 * chdir(pkg) around spawn like multi-arg check-lint (relative path parity with classic).
 */
LEAN_EXPORT uint32_t slake_fs_run_lake_check_lint_pipe(b_lean_obj_arg pkg_s, b_lean_obj_arg lake_s,
                                                   b_lean_obj_arg rest_a) {
  const char *pkg;
  const char *lake;
  char dirarg[4096];
  char saved_cwd[4096];
  size_t argv[SLAKE_FS_MAX_ARGV];
  size_t argc = 0;
  size_t pipe_fds[2];
  size_t pid;
  size_t rd, wr;
  uint32_t st;
  uint32_t pst;
  char buf[4096];
  size_t got;
  size_t total = 0;

  if (pkg_s == 0 || lake_s == 0)
    return SLAKE_FS_SPAWN_FAIL;
  pkg = lean_string_cstr(pkg_s);
  lake = lean_string_cstr(lake_s);
  if (slake_fs_fill_cmd_argv(pkg, lake, "check-lint", rest_a, dirarg, sizeof dirarg,
                             argv, SLAKE_FS_MAX_ARGV, &argc) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  pipe_fds[0] = 0;
  pipe_fds[1] = 0;
  pst = lean_fs_proc_pipe((size_t)(uintptr_t)pipe_fds);
  if (pst != 0u)
    return SLAKE_FS_SPAWN_FAIL;
  rd = pipe_fds[0];
  wr = pipe_fds[1];

  saved_cwd[0] = 0;
  if (slake_fs_cmd_chdir_begin(pkg, saved_cwd, sizeof saved_cwd) != 0) {
    (void)lean_fs_proc_close_raw(wr);
    (void)lean_fs_proc_close_raw(rd);
    return SLAKE_FS_SPAWN_FAIL;
  }

  pid = lean_fs_proc_spawn_argv_pipe(
      (size_t)(uintptr_t)lake, (size_t)(uintptr_t)argv, argc,
      FS_PROC_FD_NONE, wr);
  (void)lean_fs_proc_close_raw(wr);
  if (lean_fs_proc_pid_is_neg(pid) != 0u) {
    (void)lean_fs_proc_close_raw(rd);
    slake_fs_cmd_chdir_end(saved_cwd);
    return SLAKE_FS_SPAWN_FAIL;
  }

  for (;;) {
    got = lean_fs_read(rd, (size_t)(uintptr_t)buf, sizeof buf);
    if (got == (size_t)-1 || got == 0)
      break;
    total += got;
    if (fwrite(buf, 1, got, stdout) != got) {
      continue;
    }
  }
  (void)lean_fs_proc_close_raw(rd);
  fflush(stdout);
  fprintf(stderr, "slake fs_proc_pipe: captured %zu stdout byte(s) via freestanding pipe\n",
          total);

  st = lean_fs_proc_wait(pid);
  slake_fs_cmd_chdir_end(saved_cwd);
  if (st == LEAN_FS_PROC_WAIT_FAIL)
    return SLAKE_FS_WAIT_FAIL;
  return st;
}





/*
 * Run `lake --dir=<pkg> exec [rest…]` via freestanding multi-arg spawn + wait.
 * Same empty-child-env honesty as pack/cache/unpack/query/shake/serve/upload/lean/scripts/setup-file/self-check/version-tags/run/check-test/check-lint (W112 FS_PROC exec path). Outside CLAIMED.
 * chdir(pkg) around spawn so relative path args match classic cwd=pkg.
 */
LEAN_EXPORT uint32_t slake_fs_run_lake_exec(b_lean_obj_arg pkg_s, b_lean_obj_arg lake_s,
                                              b_lean_obj_arg rest_a) {
  const char *pkg;
  const char *lake;
  char dirarg[4096];
  char saved_cwd[4096];
  size_t argv[SLAKE_FS_MAX_ARGV];
  size_t argc = 0;
  size_t pid;
  uint32_t st;

  if (pkg_s == 0 || lake_s == 0)
    return SLAKE_FS_SPAWN_FAIL;
  pkg = lean_string_cstr(pkg_s);
  lake = lean_string_cstr(lake_s);
  if (slake_fs_fill_cmd_argv(pkg, lake, "exec", rest_a, dirarg, sizeof dirarg,
                             argv, SLAKE_FS_MAX_ARGV, &argc) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  saved_cwd[0] = 0;
  if (slake_fs_cmd_chdir_begin(pkg, saved_cwd, sizeof saved_cwd) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  pid = lean_fs_proc_spawn_argv((size_t)(uintptr_t)lake, (size_t)(uintptr_t)argv, argc);
  if (lean_fs_proc_pid_is_neg(pid) != 0u) {
    slake_fs_cmd_chdir_end(saved_cwd);
    return SLAKE_FS_SPAWN_FAIL;
  }
  st = lean_fs_proc_wait(pid);
  slake_fs_cmd_chdir_end(saved_cwd);
  if (st == LEAN_FS_PROC_WAIT_FAIL)
    return SLAKE_FS_WAIT_FAIL;
  return st;
}

/*
 * Run `lake --dir=<pkg> exec [rest…]` via freestanding multi-arg **pipe** spawn.
 * Demo/capture only — same residual honesty as pack/cache/unpack/query/shake/serve/upload/lean/scripts/setup-file/self-check pipe path. W112.
 * chdir(pkg) around spawn like multi-arg exec (relative path parity with classic).
 */
LEAN_EXPORT uint32_t slake_fs_run_lake_exec_pipe(b_lean_obj_arg pkg_s, b_lean_obj_arg lake_s,
                                                   b_lean_obj_arg rest_a) {
  const char *pkg;
  const char *lake;
  char dirarg[4096];
  char saved_cwd[4096];
  size_t argv[SLAKE_FS_MAX_ARGV];
  size_t argc = 0;
  size_t pipe_fds[2];
  size_t pid;
  size_t rd, wr;
  uint32_t st;
  uint32_t pst;
  char buf[4096];
  size_t got;
  size_t total = 0;

  if (pkg_s == 0 || lake_s == 0)
    return SLAKE_FS_SPAWN_FAIL;
  pkg = lean_string_cstr(pkg_s);
  lake = lean_string_cstr(lake_s);
  if (slake_fs_fill_cmd_argv(pkg, lake, "exec", rest_a, dirarg, sizeof dirarg,
                             argv, SLAKE_FS_MAX_ARGV, &argc) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  pipe_fds[0] = 0;
  pipe_fds[1] = 0;
  pst = lean_fs_proc_pipe((size_t)(uintptr_t)pipe_fds);
  if (pst != 0u)
    return SLAKE_FS_SPAWN_FAIL;
  rd = pipe_fds[0];
  wr = pipe_fds[1];

  saved_cwd[0] = 0;
  if (slake_fs_cmd_chdir_begin(pkg, saved_cwd, sizeof saved_cwd) != 0) {
    (void)lean_fs_proc_close_raw(wr);
    (void)lean_fs_proc_close_raw(rd);
    return SLAKE_FS_SPAWN_FAIL;
  }

  pid = lean_fs_proc_spawn_argv_pipe(
      (size_t)(uintptr_t)lake, (size_t)(uintptr_t)argv, argc,
      FS_PROC_FD_NONE, wr);
  (void)lean_fs_proc_close_raw(wr);
  if (lean_fs_proc_pid_is_neg(pid) != 0u) {
    (void)lean_fs_proc_close_raw(rd);
    slake_fs_cmd_chdir_end(saved_cwd);
    return SLAKE_FS_SPAWN_FAIL;
  }

  for (;;) {
    got = lean_fs_read(rd, (size_t)(uintptr_t)buf, sizeof buf);
    if (got == (size_t)-1 || got == 0)
      break;
    total += got;
    if (fwrite(buf, 1, got, stdout) != got) {
      continue;
    }
  }
  (void)lean_fs_proc_close_raw(rd);
  fflush(stdout);
  fprintf(stderr, "slake fs_proc_pipe: captured %zu stdout byte(s) via freestanding pipe\n",
          total);

  st = lean_fs_proc_wait(pid);
  slake_fs_cmd_chdir_end(saved_cwd);
  if (st == LEAN_FS_PROC_WAIT_FAIL)
    return SLAKE_FS_WAIT_FAIL;
  return st;
}

/*
 * Run `lake --dir=<pkg> query-kind [rest…]` via freestanding multi-arg spawn + wait.
 * Same empty-child-env honesty as pack/cache/unpack/query/shake/serve/upload/lean/scripts/setup-file/self-check/version-tags/run/check-test/check-lint/exec (W113 FS_PROC query-kind path). Outside CLAIMED.
 * chdir(pkg) around spawn so relative path args match classic cwd=pkg.
 */
LEAN_EXPORT uint32_t slake_fs_run_lake_query_kind(b_lean_obj_arg pkg_s, b_lean_obj_arg lake_s,
                                                    b_lean_obj_arg rest_a) {
  const char *pkg;
  const char *lake;
  char dirarg[4096];
  char saved_cwd[4096];
  size_t argv[SLAKE_FS_MAX_ARGV];
  size_t argc = 0;
  size_t pid;
  uint32_t st;

  if (pkg_s == 0 || lake_s == 0)
    return SLAKE_FS_SPAWN_FAIL;
  pkg = lean_string_cstr(pkg_s);
  lake = lean_string_cstr(lake_s);
  if (slake_fs_fill_cmd_argv(pkg, lake, "query-kind", rest_a, dirarg, sizeof dirarg,
                             argv, SLAKE_FS_MAX_ARGV, &argc) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  saved_cwd[0] = 0;
  if (slake_fs_cmd_chdir_begin(pkg, saved_cwd, sizeof saved_cwd) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  pid = lean_fs_proc_spawn_argv((size_t)(uintptr_t)lake, (size_t)(uintptr_t)argv, argc);
  if (lean_fs_proc_pid_is_neg(pid) != 0u) {
    slake_fs_cmd_chdir_end(saved_cwd);
    return SLAKE_FS_SPAWN_FAIL;
  }
  st = lean_fs_proc_wait(pid);
  slake_fs_cmd_chdir_end(saved_cwd);
  if (st == LEAN_FS_PROC_WAIT_FAIL)
    return SLAKE_FS_WAIT_FAIL;
  return st;
}

/*
 * Run `lake --dir=<pkg> query-kind [rest…]` via freestanding multi-arg **pipe** spawn.
 * Demo/capture only — same residual honesty as pack/cache/unpack/query/shake/serve/upload/lean/scripts/setup-file/self-check/exec pipe path. W113.
 * chdir(pkg) around spawn like multi-arg query-kind (relative path parity with classic).
 */
LEAN_EXPORT uint32_t slake_fs_run_lake_query_kind_pipe(b_lean_obj_arg pkg_s, b_lean_obj_arg lake_s,
                                                         b_lean_obj_arg rest_a) {
  const char *pkg;
  const char *lake;
  char dirarg[4096];
  char saved_cwd[4096];
  size_t argv[SLAKE_FS_MAX_ARGV];
  size_t argc = 0;
  size_t pipe_fds[2];
  size_t pid;
  size_t rd, wr;
  uint32_t st;
  uint32_t pst;
  char buf[4096];
  size_t got;
  size_t total = 0;

  if (pkg_s == 0 || lake_s == 0)
    return SLAKE_FS_SPAWN_FAIL;
  pkg = lean_string_cstr(pkg_s);
  lake = lean_string_cstr(lake_s);
  if (slake_fs_fill_cmd_argv(pkg, lake, "query-kind", rest_a, dirarg, sizeof dirarg,
                             argv, SLAKE_FS_MAX_ARGV, &argc) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  pipe_fds[0] = 0;
  pipe_fds[1] = 0;
  pst = lean_fs_proc_pipe((size_t)(uintptr_t)pipe_fds);
  if (pst != 0u)
    return SLAKE_FS_SPAWN_FAIL;
  rd = pipe_fds[0];
  wr = pipe_fds[1];

  saved_cwd[0] = 0;
  if (slake_fs_cmd_chdir_begin(pkg, saved_cwd, sizeof saved_cwd) != 0) {
    (void)lean_fs_proc_close_raw(wr);
    (void)lean_fs_proc_close_raw(rd);
    return SLAKE_FS_SPAWN_FAIL;
  }

  pid = lean_fs_proc_spawn_argv_pipe(
      (size_t)(uintptr_t)lake, (size_t)(uintptr_t)argv, argc,
      FS_PROC_FD_NONE, wr);
  (void)lean_fs_proc_close_raw(wr);
  if (lean_fs_proc_pid_is_neg(pid) != 0u) {
    (void)lean_fs_proc_close_raw(rd);
    slake_fs_cmd_chdir_end(saved_cwd);
    return SLAKE_FS_SPAWN_FAIL;
  }

  for (;;) {
    got = lean_fs_read(rd, (size_t)(uintptr_t)buf, sizeof buf);
    if (got == (size_t)-1 || got == 0)
      break;
    total += got;
    if (fwrite(buf, 1, got, stdout) != got) {
      continue;
    }
  }
  (void)lean_fs_proc_close_raw(rd);
  fflush(stdout);
  fprintf(stderr, "slake fs_proc_pipe: captured %zu stdout byte(s) via freestanding pipe\n",
          total);

  st = lean_fs_proc_wait(pid);
  slake_fs_cmd_chdir_end(saved_cwd);
  if (st == LEAN_FS_PROC_WAIT_FAIL)
    return SLAKE_FS_WAIT_FAIL;
  return st;
}

/*
 * Run `lake --dir=<pkg> resolve-deps [rest…]` via freestanding multi-arg spawn + wait.
 * Same empty-child-env honesty as pack/cache/unpack/query/shake/serve/upload/lean/scripts/setup-file/self-check/version-tags/run/check-test/check-lint/exec/query-kind (W114 FS_PROC resolve-deps path). Outside CLAIMED.
 * chdir(pkg) around spawn so relative path args match classic cwd=pkg.
 */
LEAN_EXPORT uint32_t slake_fs_run_lake_resolve_deps(b_lean_obj_arg pkg_s, b_lean_obj_arg lake_s,
                                                    b_lean_obj_arg rest_a) {
  const char *pkg;
  const char *lake;
  char dirarg[4096];
  char saved_cwd[4096];
  size_t argv[SLAKE_FS_MAX_ARGV];
  size_t argc = 0;
  size_t pid;
  uint32_t st;

  if (pkg_s == 0 || lake_s == 0)
    return SLAKE_FS_SPAWN_FAIL;
  pkg = lean_string_cstr(pkg_s);
  lake = lean_string_cstr(lake_s);
  if (slake_fs_fill_cmd_argv(pkg, lake, "resolve-deps", rest_a, dirarg, sizeof dirarg,
                             argv, SLAKE_FS_MAX_ARGV, &argc) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  saved_cwd[0] = 0;
  if (slake_fs_cmd_chdir_begin(pkg, saved_cwd, sizeof saved_cwd) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  pid = lean_fs_proc_spawn_argv((size_t)(uintptr_t)lake, (size_t)(uintptr_t)argv, argc);
  if (lean_fs_proc_pid_is_neg(pid) != 0u) {
    slake_fs_cmd_chdir_end(saved_cwd);
    return SLAKE_FS_SPAWN_FAIL;
  }
  st = lean_fs_proc_wait(pid);
  slake_fs_cmd_chdir_end(saved_cwd);
  if (st == LEAN_FS_PROC_WAIT_FAIL)
    return SLAKE_FS_WAIT_FAIL;
  return st;
}

/*
 * Run `lake --dir=<pkg> resolve-deps [rest…]` via freestanding multi-arg **pipe** spawn.
 * Demo/capture only — same residual honesty as pack/cache/unpack/query/shake/serve/upload/lean/scripts/setup-file/self-check/exec/query-kind pipe path. W114.
 * chdir(pkg) around spawn like multi-arg resolve-deps (relative path parity with classic).
 */
LEAN_EXPORT uint32_t slake_fs_run_lake_resolve_deps_pipe(b_lean_obj_arg pkg_s, b_lean_obj_arg lake_s,
                                                         b_lean_obj_arg rest_a) {
  const char *pkg;
  const char *lake;
  char dirarg[4096];
  char saved_cwd[4096];
  size_t argv[SLAKE_FS_MAX_ARGV];
  size_t argc = 0;
  size_t pipe_fds[2];
  size_t pid;
  size_t rd, wr;
  uint32_t st;
  uint32_t pst;
  char buf[4096];
  size_t got;
  size_t total = 0;

  if (pkg_s == 0 || lake_s == 0)
    return SLAKE_FS_SPAWN_FAIL;
  pkg = lean_string_cstr(pkg_s);
  lake = lean_string_cstr(lake_s);
  if (slake_fs_fill_cmd_argv(pkg, lake, "resolve-deps", rest_a, dirarg, sizeof dirarg,
                             argv, SLAKE_FS_MAX_ARGV, &argc) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  pipe_fds[0] = 0;
  pipe_fds[1] = 0;
  pst = lean_fs_proc_pipe((size_t)(uintptr_t)pipe_fds);
  if (pst != 0u)
    return SLAKE_FS_SPAWN_FAIL;
  rd = pipe_fds[0];
  wr = pipe_fds[1];

  saved_cwd[0] = 0;
  if (slake_fs_cmd_chdir_begin(pkg, saved_cwd, sizeof saved_cwd) != 0) {
    (void)lean_fs_proc_close_raw(wr);
    (void)lean_fs_proc_close_raw(rd);
    return SLAKE_FS_SPAWN_FAIL;
  }

  pid = lean_fs_proc_spawn_argv_pipe(
      (size_t)(uintptr_t)lake, (size_t)(uintptr_t)argv, argc,
      FS_PROC_FD_NONE, wr);
  (void)lean_fs_proc_close_raw(wr);
  if (lean_fs_proc_pid_is_neg(pid) != 0u) {
    (void)lean_fs_proc_close_raw(rd);
    slake_fs_cmd_chdir_end(saved_cwd);
    return SLAKE_FS_SPAWN_FAIL;
  }

  for (;;) {
    got = lean_fs_read(rd, (size_t)(uintptr_t)buf, sizeof buf);
    if (got == (size_t)-1 || got == 0)
      break;
    total += got;
    if (fwrite(buf, 1, got, stdout) != got) {
      continue;
    }
  }
  (void)lean_fs_proc_close_raw(rd);
  fflush(stdout);
  fprintf(stderr, "slake fs_proc_pipe: captured %zu stdout byte(s) via freestanding pipe\n",
          total);

  st = lean_fs_proc_wait(pid);
  slake_fs_cmd_chdir_end(saved_cwd);
  if (st == LEAN_FS_PROC_WAIT_FAIL)
    return SLAKE_FS_WAIT_FAIL;
  return st;
}

/*
 * Run `lake --dir=<pkg> reservoir-config [rest…]` via freestanding multi-arg spawn + wait.
 * Same empty-child-env honesty as pack/cache/unpack/query/shake/serve/upload/lean/scripts/setup-file/self-check/version-tags/run/check-test/check-lint/exec/query-kind/resolve-deps (W115 FS_PROC reservoir-config path). Outside CLAIMED.
 * chdir(pkg) around spawn so relative path args match classic cwd=pkg.
 */
LEAN_EXPORT uint32_t slake_fs_run_lake_reservoir_config(b_lean_obj_arg pkg_s, b_lean_obj_arg lake_s,
                                                       b_lean_obj_arg rest_a) {
  const char *pkg;
  const char *lake;
  char dirarg[4096];
  char saved_cwd[4096];
  size_t argv[SLAKE_FS_MAX_ARGV];
  size_t argc = 0;
  size_t pid;
  uint32_t st;

  if (pkg_s == 0 || lake_s == 0)
    return SLAKE_FS_SPAWN_FAIL;
  pkg = lean_string_cstr(pkg_s);
  lake = lean_string_cstr(lake_s);
  if (slake_fs_fill_cmd_argv(pkg, lake, "reservoir-config", rest_a, dirarg, sizeof dirarg,
                             argv, SLAKE_FS_MAX_ARGV, &argc) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  saved_cwd[0] = 0;
  if (slake_fs_cmd_chdir_begin(pkg, saved_cwd, sizeof saved_cwd) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  pid = lean_fs_proc_spawn_argv((size_t)(uintptr_t)lake, (size_t)(uintptr_t)argv, argc);
  if (lean_fs_proc_pid_is_neg(pid) != 0u) {
    slake_fs_cmd_chdir_end(saved_cwd);
    return SLAKE_FS_SPAWN_FAIL;
  }
  st = lean_fs_proc_wait(pid);
  slake_fs_cmd_chdir_end(saved_cwd);
  if (st == LEAN_FS_PROC_WAIT_FAIL)
    return SLAKE_FS_WAIT_FAIL;
  return st;
}

/*
 * Run `lake --dir=<pkg> reservoir-config [rest…]` via freestanding multi-arg **pipe** spawn.
 * Demo/capture only — same residual honesty as pack/cache/unpack/query/shake/serve/upload/lean/scripts/setup-file/self-check/exec/query-kind/resolve-deps pipe path. W115.
 * chdir(pkg) around spawn like multi-arg reservoir-config (relative path parity with classic).
 */
LEAN_EXPORT uint32_t slake_fs_run_lake_reservoir_config_pipe(b_lean_obj_arg pkg_s, b_lean_obj_arg lake_s,
                                                            b_lean_obj_arg rest_a) {
  const char *pkg;
  const char *lake;
  char dirarg[4096];
  char saved_cwd[4096];
  size_t argv[SLAKE_FS_MAX_ARGV];
  size_t argc = 0;
  size_t pipe_fds[2];
  size_t pid;
  size_t rd, wr;
  uint32_t st;
  uint32_t pst;
  char buf[4096];
  size_t got;
  size_t total = 0;

  if (pkg_s == 0 || lake_s == 0)
    return SLAKE_FS_SPAWN_FAIL;
  pkg = lean_string_cstr(pkg_s);
  lake = lean_string_cstr(lake_s);
  if (slake_fs_fill_cmd_argv(pkg, lake, "reservoir-config", rest_a, dirarg, sizeof dirarg,
                             argv, SLAKE_FS_MAX_ARGV, &argc) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  pipe_fds[0] = 0;
  pipe_fds[1] = 0;
  pst = lean_fs_proc_pipe((size_t)(uintptr_t)pipe_fds);
  if (pst != 0u)
    return SLAKE_FS_SPAWN_FAIL;
  rd = pipe_fds[0];
  wr = pipe_fds[1];

  saved_cwd[0] = 0;
  if (slake_fs_cmd_chdir_begin(pkg, saved_cwd, sizeof saved_cwd) != 0) {
    (void)lean_fs_proc_close_raw(wr);
    (void)lean_fs_proc_close_raw(rd);
    return SLAKE_FS_SPAWN_FAIL;
  }

  pid = lean_fs_proc_spawn_argv_pipe(
      (size_t)(uintptr_t)lake, (size_t)(uintptr_t)argv, argc,
      FS_PROC_FD_NONE, wr);
  (void)lean_fs_proc_close_raw(wr);
  if (lean_fs_proc_pid_is_neg(pid) != 0u) {
    (void)lean_fs_proc_close_raw(rd);
    slake_fs_cmd_chdir_end(saved_cwd);
    return SLAKE_FS_SPAWN_FAIL;
  }

  for (;;) {
    got = lean_fs_read(rd, (size_t)(uintptr_t)buf, sizeof buf);
    if (got == (size_t)-1 || got == 0)
      break;
    total += got;
    if (fwrite(buf, 1, got, stdout) != got) {
      continue;
    }
  }
  (void)lean_fs_proc_close_raw(rd);
  fflush(stdout);
  fprintf(stderr, "slake fs_proc_pipe: captured %zu stdout byte(s) via freestanding pipe\n",
          total);

  st = lean_fs_proc_wait(pid);
  slake_fs_cmd_chdir_end(saved_cwd);
  if (st == LEAN_FS_PROC_WAIT_FAIL)
    return SLAKE_FS_WAIT_FAIL;
  return st;
}

/*
 * Run `lake --dir=<pkg> upgrade [rest…]` via freestanding multi-arg spawn + wait.
 * Same empty-child-env honesty as pack/cache/unpack/query/shake/serve/upload/lean/scripts/setup-file/self-check/version-tags/run/check-test/check-lint/exec/query-kind/resolve-deps/reservoir-config (W116 FS_PROC upgrade path). Outside CLAIMED.
 * chdir(pkg) around spawn so relative path args match classic cwd=pkg.
 */
LEAN_EXPORT uint32_t slake_fs_run_lake_upgrade(b_lean_obj_arg pkg_s, b_lean_obj_arg lake_s,
                                              b_lean_obj_arg rest_a) {
  const char *pkg;
  const char *lake;
  char dirarg[4096];
  char saved_cwd[4096];
  size_t argv[SLAKE_FS_MAX_ARGV];
  size_t argc = 0;
  size_t pid;
  uint32_t st;

  if (pkg_s == 0 || lake_s == 0)
    return SLAKE_FS_SPAWN_FAIL;
  pkg = lean_string_cstr(pkg_s);
  lake = lean_string_cstr(lake_s);
  if (slake_fs_fill_cmd_argv(pkg, lake, "upgrade", rest_a, dirarg, sizeof dirarg,
                             argv, SLAKE_FS_MAX_ARGV, &argc) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  saved_cwd[0] = 0;
  if (slake_fs_cmd_chdir_begin(pkg, saved_cwd, sizeof saved_cwd) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  pid = lean_fs_proc_spawn_argv((size_t)(uintptr_t)lake, (size_t)(uintptr_t)argv, argc);
  if (lean_fs_proc_pid_is_neg(pid) != 0u) {
    slake_fs_cmd_chdir_end(saved_cwd);
    return SLAKE_FS_SPAWN_FAIL;
  }
  st = lean_fs_proc_wait(pid);
  slake_fs_cmd_chdir_end(saved_cwd);
  if (st == LEAN_FS_PROC_WAIT_FAIL)
    return SLAKE_FS_WAIT_FAIL;
  return st;
}

/*
 * Run `lake --dir=<pkg> upgrade [rest…]` via freestanding multi-arg **pipe** spawn.
 * Demo/capture only — same residual honesty as pack/cache/unpack/query/shake/serve/upload/lean/scripts/setup-file/self-check/exec/query-kind/resolve-deps/reservoir-config pipe path. W116.
 * chdir(pkg) around spawn like multi-arg upgrade (relative path parity with classic).
 */
LEAN_EXPORT uint32_t slake_fs_run_lake_upgrade_pipe(b_lean_obj_arg pkg_s, b_lean_obj_arg lake_s,
                                                   b_lean_obj_arg rest_a) {
  const char *pkg;
  const char *lake;
  char dirarg[4096];
  char saved_cwd[4096];
  size_t argv[SLAKE_FS_MAX_ARGV];
  size_t argc = 0;
  size_t pipe_fds[2];
  size_t pid;
  size_t rd, wr;
  uint32_t st;
  uint32_t pst;
  char buf[4096];
  size_t got;
  size_t total = 0;

  if (pkg_s == 0 || lake_s == 0)
    return SLAKE_FS_SPAWN_FAIL;
  pkg = lean_string_cstr(pkg_s);
  lake = lean_string_cstr(lake_s);
  if (slake_fs_fill_cmd_argv(pkg, lake, "upgrade", rest_a, dirarg, sizeof dirarg,
                             argv, SLAKE_FS_MAX_ARGV, &argc) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  pipe_fds[0] = 0;
  pipe_fds[1] = 0;
  pst = lean_fs_proc_pipe((size_t)(uintptr_t)pipe_fds);
  if (pst != 0u)
    return SLAKE_FS_SPAWN_FAIL;
  rd = pipe_fds[0];
  wr = pipe_fds[1];

  saved_cwd[0] = 0;
  if (slake_fs_cmd_chdir_begin(pkg, saved_cwd, sizeof saved_cwd) != 0) {
    (void)lean_fs_proc_close_raw(wr);
    (void)lean_fs_proc_close_raw(rd);
    return SLAKE_FS_SPAWN_FAIL;
  }

  pid = lean_fs_proc_spawn_argv_pipe(
      (size_t)(uintptr_t)lake, (size_t)(uintptr_t)argv, argc,
      FS_PROC_FD_NONE, wr);
  (void)lean_fs_proc_close_raw(wr);
  if (lean_fs_proc_pid_is_neg(pid) != 0u) {
    (void)lean_fs_proc_close_raw(rd);
    slake_fs_cmd_chdir_end(saved_cwd);
    return SLAKE_FS_SPAWN_FAIL;
  }

  for (;;) {
    got = lean_fs_read(rd, (size_t)(uintptr_t)buf, sizeof buf);
    if (got == (size_t)-1 || got == 0)
      break;
    total += got;
    if (fwrite(buf, 1, got, stdout) != got) {
      continue;
    }
  }
  (void)lean_fs_proc_close_raw(rd);
  fflush(stdout);
  fprintf(stderr, "slake fs_proc_pipe: captured %zu stdout byte(s) via freestanding pipe\n",
          total);

  st = lean_fs_proc_wait(pid);
  slake_fs_cmd_chdir_end(saved_cwd);
  if (st == LEAN_FS_PROC_WAIT_FAIL)
    return SLAKE_FS_WAIT_FAIL;
  return st;
}

/*
 * Run `lake --dir=<cwd> new [rest…]` via freestanding multi-arg spawn + wait.
 * Same empty-child-env honesty as pack/cache/…/run (W107 FS_PROC new path). Outside CLAIMED.
 * Bootstrap: uses process cwd (no package walk-up); chdir(cwd) around spawn so relative
 * path args match classic cwd bootstrap; --dir=<cwd> mirrors fill_cmd_argv peers.
 */
LEAN_EXPORT uint32_t slake_fs_run_lake_new(b_lean_obj_arg cwd_s, b_lean_obj_arg lake_s,
                                              b_lean_obj_arg rest_a) {
  const char *cwd;
  const char *lake;
  char dirarg[4096];
  char saved_cwd[4096];
  size_t argv[SLAKE_FS_MAX_ARGV];
  size_t argc = 0;
  size_t pid;
  uint32_t st;

  if (cwd_s == 0 || lake_s == 0)
    return SLAKE_FS_SPAWN_FAIL;
  cwd = lean_string_cstr(cwd_s);
  lake = lean_string_cstr(lake_s);
  if (slake_fs_fill_cmd_argv(cwd, lake, "new", rest_a, dirarg, sizeof dirarg,
                             argv, SLAKE_FS_MAX_ARGV, &argc) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  saved_cwd[0] = 0;
  if (slake_fs_cmd_chdir_begin(cwd, saved_cwd, sizeof saved_cwd) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  pid = lean_fs_proc_spawn_argv((size_t)(uintptr_t)lake, (size_t)(uintptr_t)argv, argc);
  if (lean_fs_proc_pid_is_neg(pid) != 0u) {
    slake_fs_cmd_chdir_end(saved_cwd);
    return SLAKE_FS_SPAWN_FAIL;
  }
  st = lean_fs_proc_wait(pid);
  slake_fs_cmd_chdir_end(saved_cwd);
  if (st == LEAN_FS_PROC_WAIT_FAIL)
    return SLAKE_FS_WAIT_FAIL;
  return st;
}

/*
 * Run `lake --dir=<cwd> new [rest…]` via freestanding multi-arg **pipe** spawn.
 * Demo/capture only — same residual honesty as run pipe path. W107.
 * Bootstrap cwd (no package walk-up); chdir(cwd) like multi-arg new FS_PROC.
 */
LEAN_EXPORT uint32_t slake_fs_run_lake_new_pipe(b_lean_obj_arg cwd_s, b_lean_obj_arg lake_s,
                                                   b_lean_obj_arg rest_a) {
  const char *cwd;
  const char *lake;
  char dirarg[4096];
  char saved_cwd[4096];
  size_t argv[SLAKE_FS_MAX_ARGV];
  size_t argc = 0;
  size_t pipe_fds[2];
  size_t pid;
  size_t rd, wr;
  uint32_t st;
  uint32_t pst;
  char buf[4096];
  size_t got;
  size_t total = 0;

  if (cwd_s == 0 || lake_s == 0)
    return SLAKE_FS_SPAWN_FAIL;
  cwd = lean_string_cstr(cwd_s);
  lake = lean_string_cstr(lake_s);
  if (slake_fs_fill_cmd_argv(cwd, lake, "new", rest_a, dirarg, sizeof dirarg,
                             argv, SLAKE_FS_MAX_ARGV, &argc) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  pipe_fds[0] = 0;
  pipe_fds[1] = 0;
  pst = lean_fs_proc_pipe((size_t)(uintptr_t)pipe_fds);
  if (pst != 0u)
    return SLAKE_FS_SPAWN_FAIL;
  rd = pipe_fds[0];
  wr = pipe_fds[1];

  saved_cwd[0] = 0;
  if (slake_fs_cmd_chdir_begin(cwd, saved_cwd, sizeof saved_cwd) != 0) {
    (void)lean_fs_proc_close_raw(wr);
    (void)lean_fs_proc_close_raw(rd);
    return SLAKE_FS_SPAWN_FAIL;
  }

  pid = lean_fs_proc_spawn_argv_pipe(
      (size_t)(uintptr_t)lake, (size_t)(uintptr_t)argv, argc,
      FS_PROC_FD_NONE, wr);
  (void)lean_fs_proc_close_raw(wr);
  if (lean_fs_proc_pid_is_neg(pid) != 0u) {
    (void)lean_fs_proc_close_raw(rd);
    slake_fs_cmd_chdir_end(saved_cwd);
    return SLAKE_FS_SPAWN_FAIL;
  }

  for (;;) {
    got = lean_fs_read(rd, (size_t)(uintptr_t)buf, sizeof buf);
    if (got == (size_t)-1 || got == 0)
      break;
    total += got;
    if (fwrite(buf, 1, got, stdout) != got) {
      continue;
    }
  }
  (void)lean_fs_proc_close_raw(rd);
  fflush(stdout);
  fprintf(stderr, "slake fs_proc_pipe: captured %zu stdout byte(s) via freestanding pipe\n",
          total);

  st = lean_fs_proc_wait(pid);
  slake_fs_cmd_chdir_end(saved_cwd);
  if (st == LEAN_FS_PROC_WAIT_FAIL)
    return SLAKE_FS_WAIT_FAIL;
  return st;
}


/*
 * Run `lake --dir=<cwd> init [rest…]` via freestanding multi-arg spawn + wait.
 * Same empty-child-env honesty as new (W108 FS_PROC init path). Outside CLAIMED.
 * Bootstrap: uses process cwd (no package walk-up); chdir(cwd) around spawn so relative
 * path args match classic cwd bootstrap; --dir=<cwd> mirrors fill_cmd_argv peers.
 * Honesty: `lake init` initializes the current directory (cwd bootstrap like `new`).
 */
LEAN_EXPORT uint32_t slake_fs_run_lake_init(b_lean_obj_arg cwd_s, b_lean_obj_arg lake_s,
                                              b_lean_obj_arg rest_a) {
  const char *cwd;
  const char *lake;
  char dirarg[4096];
  char saved_cwd[4096];
  size_t argv[SLAKE_FS_MAX_ARGV];
  size_t argc = 0;
  size_t pid;
  uint32_t st;

  if (cwd_s == 0 || lake_s == 0)
    return SLAKE_FS_SPAWN_FAIL;
  cwd = lean_string_cstr(cwd_s);
  lake = lean_string_cstr(lake_s);
  if (slake_fs_fill_cmd_argv(cwd, lake, "init", rest_a, dirarg, sizeof dirarg,
                             argv, SLAKE_FS_MAX_ARGV, &argc) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  saved_cwd[0] = 0;
  if (slake_fs_cmd_chdir_begin(cwd, saved_cwd, sizeof saved_cwd) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  pid = lean_fs_proc_spawn_argv((size_t)(uintptr_t)lake, (size_t)(uintptr_t)argv, argc);
  if (lean_fs_proc_pid_is_neg(pid) != 0u) {
    slake_fs_cmd_chdir_end(saved_cwd);
    return SLAKE_FS_SPAWN_FAIL;
  }
  st = lean_fs_proc_wait(pid);
  slake_fs_cmd_chdir_end(saved_cwd);
  if (st == LEAN_FS_PROC_WAIT_FAIL)
    return SLAKE_FS_WAIT_FAIL;
  return st;
}

/*
 * Run `lake --dir=<cwd> init [rest…]` via freestanding multi-arg **pipe** spawn.
 * Demo/capture only — same residual honesty as new pipe path. W108.
 * Bootstrap cwd (no package walk-up); chdir(cwd) like multi-arg init FS_PROC.
 */
LEAN_EXPORT uint32_t slake_fs_run_lake_init_pipe(b_lean_obj_arg cwd_s, b_lean_obj_arg lake_s,
                                                   b_lean_obj_arg rest_a) {
  const char *cwd;
  const char *lake;
  char dirarg[4096];
  char saved_cwd[4096];
  size_t argv[SLAKE_FS_MAX_ARGV];
  size_t argc = 0;
  size_t pipe_fds[2];
  size_t pid;
  size_t rd, wr;
  uint32_t st;
  uint32_t pst;
  char buf[4096];
  size_t got;
  size_t total = 0;

  if (cwd_s == 0 || lake_s == 0)
    return SLAKE_FS_SPAWN_FAIL;
  cwd = lean_string_cstr(cwd_s);
  lake = lean_string_cstr(lake_s);
  if (slake_fs_fill_cmd_argv(cwd, lake, "init", rest_a, dirarg, sizeof dirarg,
                             argv, SLAKE_FS_MAX_ARGV, &argc) != 0)
    return SLAKE_FS_SPAWN_FAIL;

  pipe_fds[0] = 0;
  pipe_fds[1] = 0;
  pst = lean_fs_proc_pipe((size_t)(uintptr_t)pipe_fds);
  if (pst != 0u)
    return SLAKE_FS_SPAWN_FAIL;
  rd = pipe_fds[0];
  wr = pipe_fds[1];

  saved_cwd[0] = 0;
  if (slake_fs_cmd_chdir_begin(cwd, saved_cwd, sizeof saved_cwd) != 0) {
    (void)lean_fs_proc_close_raw(wr);
    (void)lean_fs_proc_close_raw(rd);
    return SLAKE_FS_SPAWN_FAIL;
  }

  pid = lean_fs_proc_spawn_argv_pipe(
      (size_t)(uintptr_t)lake, (size_t)(uintptr_t)argv, argc,
      FS_PROC_FD_NONE, wr);
  (void)lean_fs_proc_close_raw(wr);
  if (lean_fs_proc_pid_is_neg(pid) != 0u) {
    (void)lean_fs_proc_close_raw(rd);
    slake_fs_cmd_chdir_end(saved_cwd);
    return SLAKE_FS_SPAWN_FAIL;
  }

  for (;;) {
    got = lean_fs_read(rd, (size_t)(uintptr_t)buf, sizeof buf);
    if (got == (size_t)-1 || got == 0)
      break;
    total += got;
    if (fwrite(buf, 1, got, stdout) != got) {
      continue;
    }
  }
  (void)lean_fs_proc_close_raw(rd);
  fflush(stdout);
  fprintf(stderr, "slake fs_proc_pipe: captured %zu stdout byte(s) via freestanding pipe\n",
          total);

  st = lean_fs_proc_wait(pid);
  slake_fs_cmd_chdir_end(saved_cwd);
  if (st == LEAN_FS_PROC_WAIT_FAIL)
    return SLAKE_FS_WAIT_FAIL;
  return st;
}
