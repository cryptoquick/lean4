/* Opt-in L2 pthread dogfood smoke (Track C / C2).
 *
 * NOT the product residual matrix consumer (that is main.c / out/main).
 * Built only by `make check-par-pthread` with:
 *   -DSYSTEMS_LEAN_PAR_PTHREAD=1 -pthread
 * Links par_pthread.c + freestanding.bundle (product sequential archive still linked
 * for residual-free product symbols; pthread symbols come only from par_pthread.c).
 *
 * Compile define (not env) selects this host path. Default `make check` does not
 * build or run this binary and must not require libpthread.
 *
 * Join-fail honesty: if lean_fs_par_fork_join_pthread returns 2, buffers are
 * untrusted (worker may still write); this smoke treats return 2 as FAIL and
 * never greps buffer contents on that path.
 */
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#ifndef SYSTEMS_LEAN_PAR_PTHREAD
#error "main_par_pthread_smoke.c requires -DSYSTEMS_LEAN_PAR_PTHREAD=1"
#endif

/* Product sequential exports (from freestanding.bundle) — backend must stay 0. */
extern uint32_t lean_fs_par_l2_backend(uint32_t unused);
extern uint32_t lean_fs_par_fork_join(size_t dst, size_t src, size_t n, uint8_t addend);

/* Host dogfood exports (from par_pthread.c only). */
extern uint32_t lean_fs_par_fork_join_pthread(size_t dst, size_t src, size_t n, uint8_t addend);
extern uint32_t lean_fs_par_l2_backend_pthread(uint32_t unused);

int main(void) {
  uint8_t src[4] = {1, 2, 3, 4};
  uint8_t dst[4] = {0};
  uint8_t dst_seq[4] = {0};
  uint32_t rc;

  /* Product sequential path still present and reports backend 0. */
  if (lean_fs_par_l2_backend(0) != 0u) {
    fprintf(stderr, "FAIL: product lean_fs_par_l2_backend != 0\n");
    return 1;
  }
  printf("par_l2_backend: 0\n");

  if (lean_fs_par_fork_join((size_t)(uintptr_t)dst_seq, (size_t)(uintptr_t)src, 4, 1) != 0u) {
    fprintf(stderr, "FAIL: sequential fork_join\n");
    return 2;
  }
  if (dst_seq[0] != 2 || dst_seq[1] != 3 || dst_seq[2] != 4 || dst_seq[3] != 5) {
    fprintf(stderr, "FAIL: sequential map-add values\n");
    return 3;
  }

  /* Pthread dogfood backend id = 1. */
  if (lean_fs_par_l2_backend_pthread(0) != 1u) {
    fprintf(stderr, "FAIL: lean_fs_par_l2_backend_pthread != 1\n");
    return 4;
  }
  printf("par_l2_backend_pthread: 1\n");

  rc = lean_fs_par_fork_join_pthread((size_t)(uintptr_t)dst, (size_t)(uintptr_t)src, 4, 1);
  if (rc == 2u) {
    /* Fail-closed join: buffers untrusted — do not assert contents. */
    fprintf(stderr, "FAIL: pthread join failure (return 2; buffers untrusted, no content assert)\n");
    return 5;
  }
  if (rc != 0u) {
    fprintf(stderr, "FAIL: lean_fs_par_fork_join_pthread rc=%u\n", (unsigned)rc);
    return 6;
  }
  /* Only after return 0 may buffer contents be grepped. */
  printf("par_fork_join_pthread: %u %u %u %u\n", dst[0], dst[1], dst[2], dst[3]);
  if (dst[0] != 2 || dst[1] != 3 || dst[2] != 4 || dst[3] != 5) {
    fprintf(stderr, "FAIL: pthread map-add values\n");
    return 7;
  }

  /* Greppable edges: n=1 and n=0 (empty right/left partition paths). */
  {
    uint8_t s1[1] = {9};
    uint8_t d1[1] = {0};
    rc = lean_fs_par_fork_join_pthread((size_t)(uintptr_t)d1, (size_t)(uintptr_t)s1, 1, 1);
    if (rc == 2u) {
      fprintf(stderr, "FAIL: join fail on n=1 (buffers untrusted)\n");
      return 8;
    }
    if (rc != 0u || d1[0] != 10) {
      fprintf(stderr, "FAIL: n=1 map-add\n");
      return 9;
    }
    printf("par_fork_join_pthread_n1: 10\n");
  }
  {
    uint8_t s0[1] = {0};
    uint8_t d0[1] = {0xab};
    rc = lean_fs_par_fork_join_pthread((size_t)(uintptr_t)d0, (size_t)(uintptr_t)s0, 0, 1);
    if (rc == 2u) {
      fprintf(stderr, "FAIL: join fail on n=0 (buffers untrusted)\n");
      return 10;
    }
    if (rc != 0u || d0[0] != 0xab) {
      fprintf(stderr, "FAIL: n=0 must be no-op on dst\n");
      return 11;
    }
    printf("par_fork_join_pthread_n0: ok\n");
  }

  /* Product sequential n=0 / n=1 edges (same ABI). */
  {
    uint8_t s1[1] = {3};
    uint8_t d1[1] = {0};
    uint8_t d0[1] = {0xcd};
    if (lean_fs_par_fork_join((size_t)(uintptr_t)d1, (size_t)(uintptr_t)s1, 1, 2) != 0u || d1[0] != 5)
      return 12;
    printf("par_fork_join_n1: 5\n");
    if (lean_fs_par_fork_join((size_t)(uintptr_t)d0, (size_t)(uintptr_t)s1, 0, 2) != 0u || d0[0] != 0xcd)
      return 13;
    printf("par_fork_join_n0: ok\n");
  }

  printf("check-par-pthread: OK\n");
  return 0;
}
