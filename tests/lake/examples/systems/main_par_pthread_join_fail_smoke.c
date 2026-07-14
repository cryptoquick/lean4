/* Opt-in L2 pthread join-fail induction smoke (Track C review).
 *
 * Built only by `make check-par-pthread-join-fail` with:
 *   -DSYSTEMS_LEAN_PAR_PTHREAD=1
 *   -DSYSTEMS_LEAN_PAR_PTHREAD_FORCE_JOIN_FAIL=1
 *   -pthread
 *
 * Expects lean_fs_par_fork_join_pthread to return 2 on a non-empty dual partition
 * and **must not** assert buffer contents (fail-closed contract).
 * Default `make check-par-pthread` does not use this binary.
 */
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#ifndef SYSTEMS_LEAN_PAR_PTHREAD
#error "requires -DSYSTEMS_LEAN_PAR_PTHREAD=1"
#endif
#ifndef SYSTEMS_LEAN_PAR_PTHREAD_FORCE_JOIN_FAIL
#error "requires -DSYSTEMS_LEAN_PAR_PTHREAD_FORCE_JOIN_FAIL=1"
#endif

extern uint32_t lean_fs_par_l2_backend_pthread(uint32_t unused);
extern uint32_t lean_fs_par_fork_join_pthread(size_t dst, size_t src, size_t n, uint8_t addend);

int main(void) {
  uint8_t src[4] = {1, 2, 3, 4};
  /* Deliberately poison dst so a buggy smoke that grepped contents would be obvious;
   * we still must not assert dst values after rc=2. */
  uint8_t dst[4] = {0xaa, 0xbb, 0xcc, 0xdd};
  uint32_t rc;

  if (lean_fs_par_l2_backend_pthread(0) != 1u) {
    fprintf(stderr, "FAIL: backend pthread id != 1\n");
    return 1;
  }

  /* n=4 → non-empty L/R so create path runs and FORCE_JOIN_FAIL returns 2. */
  rc = lean_fs_par_fork_join_pthread((size_t)(uintptr_t)dst, (size_t)(uintptr_t)src, 4, 1);
  if (rc != 2u) {
    fprintf(stderr, "FAIL: expected join-fail rc=2, got %u\n", (unsigned)rc);
    return 2;
  }
  /* Intentionally no buffer content asserts / greps of dst values. */
  printf("par_fork_join_pthread_join_fail: 2\n");
  printf("par_fork_join_pthread_join_fail_buffers: untrusted\n");
  (void)dst;
  (void)src;

  /* n=0 / n=1 never spawn (no join path) — must still return 0, not forced 2. */
  {
    uint8_t s1[1] = {9};
    uint8_t d1[1] = {0};
    rc = lean_fs_par_fork_join_pthread((size_t)(uintptr_t)d1, (size_t)(uintptr_t)s1, 1, 1);
    if (rc != 0u) {
      fprintf(stderr, "FAIL: n=1 should not force join-fail, rc=%u\n", (unsigned)rc);
      return 3;
    }
    /* n=1 is sequential-only (no create); contents may be trusted. */
    if (d1[0] != 10) {
      fprintf(stderr, "FAIL: n=1 sequential map\n");
      return 4;
    }
    printf("par_fork_join_pthread_join_fail_n1_ok: 0\n");
  }

  printf("check-par-pthread-join-fail: OK\n");
  return 0;
}
