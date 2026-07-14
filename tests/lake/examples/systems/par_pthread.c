/* Opt-in L2 pthread backend for Systems Lean Three-Layer Cake.
 *
 * NOT part of the freestanding product residual / ccomp matrix.
 * Link only under compile define SYSTEMS_LEAN_PAR_PTHREAD=1
 * (see make check-par-pthread: -DSYSTEMS_LEAN_PAR_PTHREAD=1 -pthread).
 *
 * Ownership: left/right partitions are disjoint halves of [src,src+n) → [dst,dst+n).
 * Workers must not share a mutable cell. This is host dogfood — not a verified
 * concurrent runtime or CompCert-accepted product residual.
 *
 * ## Return contract (fail-closed)
 *
 * | Code | Meaning |
 * |------|---------|
 * | **0** | Partitions completed; buffers stable for caller use. |
 * | **2** | `pthread_join` failed after create succeeded. **Fail-closed:** |
 * |      | - Do **not** free the heap-allocated right-worker args (leak over UAF). |
 * |      | - Right worker may still be running and writing `dst`/`src` halves. |
 * |      | - Caller must treat **both** halves as **untrusted / incomplete**. |
 * |      | - No recoverable `pthread_t` is returned; cancel/detach is **not** |
 * |      |   promised (portable cancel is undefined for this dogfood API). |
 * |      | - Smoke tests must **not** assert buffer contents when return is 2. |
 *
 * Create failure falls back to sequential map (still return 0, results correct).
 * Empty L or R partition is sequential-only (return 0).
 *
 * ## Test-only join-fail induction
 *
 * Compile define `-DSYSTEMS_LEAN_PAR_PTHREAD_FORCE_JOIN_FAIL=1` (dogfood only;
 * `make check-par-pthread-join-fail`) forces the return-2 contract after a
 * successful create on non-empty L/R partitions so smokes can exercise
 * fail-closed handling without relying on host pthread_join errors.
 * Default `make check-par-pthread` must **not** set this define.
 */
#include <pthread.h>
#include <stddef.h>
#include <stdint.h>
#include <stdlib.h>

typedef struct {
  uint8_t *dst;
  const uint8_t *src;
  size_t n;
  uint8_t addend;
} lean_fs_par_map_args;

static void *lean_fs_par_map_worker(void *arg) {
  lean_fs_par_map_args *a = (lean_fs_par_map_args *)arg;
  size_t i;
  for (i = 0; i < a->n; i++)
    a->dst[i] = (uint8_t)((uint8_t)a->src[i] + (uint8_t)a->addend);
  return NULL;
}

static void lean_fs_par_map_run(uint8_t *dst, const uint8_t *src, size_t n, uint8_t addend) {
  lean_fs_par_map_args a;
  a.dst = dst;
  a.src = src;
  a.n = n;
  a.addend = addend;
  (void)lean_fs_par_map_worker(&a);
}

/* Same dual-param ABI as lean_fs_par_fork_join (sequential product export). */
uint32_t lean_fs_par_fork_join_pthread(size_t dst, size_t src, size_t n, uint8_t addend) {
  size_t mid = n / (size_t)2;
  size_t rLen = n - mid;
  uint8_t *d = (uint8_t *)(uintptr_t)dst;
  const uint8_t *s = (const uint8_t *)(uintptr_t)src;
  lean_fs_par_map_args *right;
  pthread_t th;
  int rc;

  /* Empty right: sequential left only. */
  if (rLen == 0) {
    lean_fs_par_map_run(d, s, mid, addend);
    return 0u;
  }
  /* Empty left: sequential right only. */
  if (mid == 0) {
    lean_fs_par_map_run(d + mid, s + mid, rLen, addend);
    return 0u;
  }

  /* Heap-allocate right worker args so a failed join cannot UAF stack. */
  right = (lean_fs_par_map_args *)malloc(sizeof(*right));
  if (right == NULL) {
    lean_fs_par_map_run(d, s, mid, addend);
    lean_fs_par_map_run(d + mid, s + mid, rLen, addend);
    return 0u;
  }
  right->dst = d + mid;
  right->src = s + mid;
  right->n = rLen;
  right->addend = addend;

  rc = pthread_create(&th, NULL, lean_fs_par_map_worker, right);
  if (rc != 0) {
    free(right);
    /* Create failure: sequential fallback (still correct ownership partition work). */
    lean_fs_par_map_run(d, s, mid, addend);
    lean_fs_par_map_run(d + mid, s + mid, rLen, addend);
    return 0u;
  }

  lean_fs_par_map_run(d, s, mid, addend);

#if defined(SYSTEMS_LEAN_PAR_PTHREAD_FORCE_JOIN_FAIL) && SYSTEMS_LEAN_PAR_PTHREAD_FORCE_JOIN_FAIL
  /* Test-only induction of the join-fail contract (return 2).
   * Join for real so the worker stops before process exit (smoke hygiene),
   * then **do not free** `right` (same leak-over-UAF policy as a real join
   * failure after create). Callers must not assert buffer contents. */
  (void)pthread_join(th, NULL);
  return 2u;
#else
  rc = pthread_join(th, NULL);
  if (rc != 0) {
    /* Fail closed: do not free `right` — worker may still run and write caller
     * dst/src. Leak over UAF. No cancel/detach promise. Caller must not trust
     * buffer contents (return 2). */
    return 2u;
  }
  free(right);
  return 0u;
#endif
}

/* Backend id for the pthread dogfood binary only (1 = pthread). Product export stays 0. */
uint32_t lean_fs_par_l2_backend_pthread(uint32_t unused) {
  (void)unused;
  return 1u;
}
