/* Slake freestanding Systems.Proc dogfood.
 *
 * Links against libfs_extract_bundle.a and spawns via lean_fs_proc_*.
 * argv0-only + multi-arg + pipe/stdout redirect spawn. Classic slake CLI
 * still uses IO.Process → lake. See src/slake/README.md.
 */
#define _POSIX_C_SOURCE 200809L
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

extern size_t lean_fs_proc_spawn(size_t path);
extern size_t lean_fs_proc_spawn_argv0(size_t path, size_t argv0);
extern size_t lean_fs_proc_spawn_argv(size_t path, size_t argv_base, size_t argc);
extern uint32_t lean_fs_proc_pipe(size_t pipe_fds);
extern size_t lean_fs_proc_spawn_argv_pipe(size_t path, size_t argv_base, size_t argc,
                                           size_t stdin_fd, size_t stdout_fd);
extern uint32_t lean_fs_proc_close_raw(size_t fd);
extern uint32_t lean_fs_proc_wait(size_t pid);
extern uint32_t lean_fs_proc_pid_is_neg(size_t pid);
extern size_t lean_fs_read(size_t fd, size_t buf, size_t len);
extern uint32_t lean_fs_close(size_t fd);

static int fail(const char *msg, int code) {
  fprintf(stderr, "slake proc_dogfood FAIL (%d): %s\n", code, msg);
  return code;
}

int main(void) {
  size_t pid;
  uint32_t st;

  /* /bin/true — argv0 = path */
  pid = lean_fs_proc_spawn((size_t)(uintptr_t)"/bin/true");
  if (lean_fs_proc_pid_is_neg(pid) != 0u)
    return fail("spawn /bin/true returned negative pid", 1);
  st = lean_fs_proc_wait(pid);
  if (st != 0u)
    return fail("wait /bin/true expected exit 0", 2);

  /* explicit argv0 */
  pid = lean_fs_proc_spawn_argv0((size_t)(uintptr_t)"/bin/true",
                                 (size_t)(uintptr_t)"true");
  if (lean_fs_proc_pid_is_neg(pid) != 0u)
    return fail("spawn_argv0 /bin/true returned negative pid", 3);
  st = lean_fs_proc_wait(pid);
  if (st != 0u)
    return fail("wait spawn_argv0 expected exit 0", 4);

  /* multi-arg: /bin/true with multi argv still ok (argc=2 includes ignored --help) */
  {
    size_t argv_true[2];
    argv_true[0] = (size_t)(uintptr_t)"true";
    argv_true[1] = (size_t)(uintptr_t)"--help"; /* /bin/true typically ignores */
    pid = lean_fs_proc_spawn_argv((size_t)(uintptr_t)"/bin/true",
                                  (size_t)(uintptr_t)argv_true, 2);
    if (lean_fs_proc_pid_is_neg(pid) != 0u)
      return fail("spawn_argv /bin/true argc=2 returned negative pid", 10);
    st = lean_fs_proc_wait(pid);
    if (st != 0u)
      return fail("wait spawn_argv /bin/true expected exit 0", 11);
  }

  /* multi-arg: /bin/sh -c true */
  {
    size_t argv_sh[3];
    argv_sh[0] = (size_t)(uintptr_t)"sh";
    argv_sh[1] = (size_t)(uintptr_t)"-c";
    argv_sh[2] = (size_t)(uintptr_t)"true";
    pid = lean_fs_proc_spawn_argv((size_t)(uintptr_t)"/bin/sh",
                                  (size_t)(uintptr_t)argv_sh, 3);
    if (lean_fs_proc_pid_is_neg(pid) != 0u)
      return fail("spawn_argv /bin/sh -c true returned negative pid", 12);
    st = lean_fs_proc_wait(pid);
    if (st != 0u)
      return fail("wait /bin/sh -c true expected exit 0", 13);
  }

  /* multi-arg fail-closed: argc == 0 → negative pid */
  {
    size_t dummy = 0;
    pid = lean_fs_proc_spawn_argv((size_t)(uintptr_t)"/bin/true",
                                  (size_t)(uintptr_t)&dummy, 0);
    if (lean_fs_proc_pid_is_neg(pid) != 1u)
      return fail("spawn_argv argc=0 expected negative pid", 14);
  }

  /* multi-arg fail-closed: argc >= maxArgc (4096) overflow fence */
  {
    size_t dummy = 0;
    pid = lean_fs_proc_spawn_argv((size_t)(uintptr_t)"/bin/true",
                                  (size_t)(uintptr_t)&dummy, (size_t)4096);
    if (lean_fs_proc_pid_is_neg(pid) != 1u)
      return fail("spawn_argv argc=4096 expected negative pid", 15);
  }

  /* LP64 waitpid cast safety: pid > INT_MAX → waitFail */
  {
    uint32_t wst = lean_fs_proc_wait((size_t)0x80000000u);
    if (wst != 0xFFFFFFFFu)
      return fail("wait(pid>INT_MAX) expected waitFail", 16);
  }

  /* optional: lake --version if absolute path known via which (soft) */
  {
    FILE *fp = popen("command -v lake 2>/dev/null", "r");
    if (fp != NULL) {
      char path[512];
      if (fgets(path, (int)sizeof path, fp) != NULL) {
        size_t len = strlen(path);
        while (len > 0 && (path[len - 1] == '\n' || path[len - 1] == '\r'))
          path[--len] = '\0';
        if (len > 0 && path[0] == '/') {
          size_t argv_lake[2];
          argv_lake[0] = (size_t)(uintptr_t)"lake";
          argv_lake[1] = (size_t)(uintptr_t)"--version";
          pid = lean_fs_proc_spawn_argv((size_t)(uintptr_t)path,
                                        (size_t)(uintptr_t)argv_lake, 2);
          if (lean_fs_proc_pid_is_neg(pid) == 0u) {
            st = lean_fs_proc_wait(pid);
            /* lake --version should exit 0; soft-fail only logs */
            if (st != 0u)
              fprintf(stderr, "slake proc_dogfood note: lake --version exit %u\n",
                      (unsigned)st);
          }
        }
      }
      pclose(fp);
    }
  }

  /* missing image: exec fails → child _exit(127) */
  pid = lean_fs_proc_spawn((size_t)(uintptr_t)"/no/such/slake_proc_dogfood_bin");
  if (lean_fs_proc_pid_is_neg(pid) != 0u)
    return fail("spawn missing path returned negative pid", 5);
  st = lean_fs_proc_wait(pid);
  if (st != 127u)
    return fail("wait missing path expected exit 127", 6);

  /* fail-closed wait on negative/zero pid */
  if (lean_fs_proc_pid_is_neg((size_t)-1) != 1u)
    return fail("pid_is_neg(-1) expected 1", 7);
  st = lean_fs_proc_wait((size_t)-1);
  if (st != 0xFFFFFFFFu)
    return fail("wait(-1) expected waitFail", 8);
  st = lean_fs_proc_wait(0);
  if (st != 0xFFFFFFFFu)
    return fail("wait(0) expected waitFail", 9);

  /* pipe + stdout redirect: /bin/echo hi → parent read */
  {
    size_t ends[2];
    char rbuf[64];
    size_t nr;
    size_t argv_echo[2];
    if (lean_fs_proc_pipe(0) != 1u)
      return fail("pipe(null) expected fail", 20);
    if (lean_fs_proc_pipe((size_t)(uintptr_t)ends) != 0u)
      return fail("pipe ends failed", 21);
    argv_echo[0] = (size_t)(uintptr_t)"echo";
    argv_echo[1] = (size_t)(uintptr_t)"hi";
    pid = lean_fs_proc_spawn_argv_pipe((size_t)(uintptr_t)"/bin/echo",
                                       (size_t)(uintptr_t)argv_echo, 2,
                                       (size_t)-1, ends[1]);
    if (lean_fs_proc_pid_is_neg(pid) != 0u)
      return fail("spawn_argv_pipe /bin/echo negative pid", 22);
    if (lean_fs_proc_close_raw(ends[1]) != 0u)
      return fail("close write end failed", 23);
    memset(rbuf, 0, sizeof rbuf);
    nr = lean_fs_read(ends[0], (size_t)(uintptr_t)rbuf, sizeof rbuf - 1);
    if ((ssize_t)nr < 2 || rbuf[0] != 'h' || rbuf[1] != 'i')
      return fail("read pipe expected hi", 24);
    st = lean_fs_proc_wait(pid);
    if (st != 0u)
      return fail("wait echo pipe expected 0", 25);
    if (lean_fs_close(ends[0]) != 0u)
      return fail("close read end failed", 26);
  }

  printf("slake_proc_dogfood: ok\n");
  return 0;
}
