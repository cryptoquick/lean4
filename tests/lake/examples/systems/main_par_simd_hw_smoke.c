/* Opt-in L1 hardware SIMD dogfood smoke (Track C / C3).
 *
 * NOT the product residual matrix consumer (that is main.c / out/main).
 * Built only by `make check-par-simd-hw`. Product L1 stays sequential chunked-4.
 * HW path uses SSE2 when available; force scalar with
 *   -DSYSTEMS_LEAN_PAR_SIMD_FORCE_SCALAR=1
 * Backend: 1 = SSE2; 2 = scalar fallback / force-scalar.
 */
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

/* Product sequential L1 (from freestanding.bundle). */
extern uint32_t lean_fs_par_map_fold(size_t dst, size_t src, size_t n, uint8_t addend);
extern uint32_t lean_fs_par_map_fold_chunk4(size_t dst, size_t src, size_t n, uint8_t addend);

/* Host dogfood (from par_simd_hw.c only). */
extern uint32_t lean_fs_par_map_add_u8_simd_hw(size_t dst, size_t src, size_t n, uint8_t addend);
extern uint32_t lean_fs_par_l1_backend_simd_hw(uint32_t unused);

static int check_buf_eq(const uint8_t *a, const uint8_t *b, size_t n, const char *tag) {
  size_t i;
  for (i = 0; i < n; i++) {
    if (a[i] != b[i]) {
      fprintf(stderr, "FAIL: %s mismatch at %zu: got %u want %u\n",
              tag, i, (unsigned)a[i], (unsigned)b[i]);
      return 0;
    }
  }
  return 1;
}

int main(void) {
  uint8_t src[20];
  uint8_t dst_hw[20];
  uint8_t dst_seq[20];
  uint8_t dst_c4[20];
  size_t i;
  uint32_t be;
  uint32_t expect_be;

  for (i = 0; i < 20; i++)
    src[i] = (uint8_t)(i + 1);

  be = lean_fs_par_l1_backend_simd_hw(0);
#if defined(SYSTEMS_LEAN_PAR_SIMD_FORCE_SCALAR) && SYSTEMS_LEAN_PAR_SIMD_FORCE_SCALAR
  expect_be = 2u;
#else
  /* 1 = SSE2 when host has it; 2 = portable scalar on non-SSE2 hosts. */
  expect_be = 0u; /* any of 1|2 */
#endif
  if (be != 1u && be != 2u) {
    fprintf(stderr, "FAIL: unexpected L1 HW backend id %u\n", (unsigned)be);
    return 1;
  }
#if defined(SYSTEMS_LEAN_PAR_SIMD_FORCE_SCALAR) && SYSTEMS_LEAN_PAR_SIMD_FORCE_SCALAR
  if (be != expect_be) {
    fprintf(stderr, "FAIL: force-scalar expected backend 2, got %u\n", (unsigned)be);
    return 1;
  }
#else
  (void)expect_be;
#endif
  printf("par_l1_backend_simd_hw: %u\n", (unsigned)be);

  memset(dst_hw, 0, sizeof(dst_hw));
  memset(dst_seq, 0, sizeof(dst_seq));
  memset(dst_c4, 0, sizeof(dst_c4));

  if (lean_fs_par_map_add_u8_simd_hw((size_t)(uintptr_t)dst_hw, (size_t)(uintptr_t)src, 20, 3) != 0u) {
    fprintf(stderr, "FAIL: simd_hw map\n");
    return 2;
  }
  (void)lean_fs_par_map_fold((size_t)(uintptr_t)dst_seq, (size_t)(uintptr_t)src, 20, 3);
  (void)lean_fs_par_map_fold_chunk4((size_t)(uintptr_t)dst_c4, (size_t)(uintptr_t)src, 20, 3);

  if (!check_buf_eq(dst_hw, dst_seq, 20, "hw vs sequential map"))
    return 3;
  if (!check_buf_eq(dst_hw, dst_c4, 20, "hw vs chunk4 map"))
    return 4;

  /* Odd length */
  {
    uint8_t s[5] = {10, 20, 30, 40, 50};
    uint8_t d[5] = {0};
    uint8_t e[5] = {0};
    if (lean_fs_par_map_add_u8_simd_hw((size_t)(uintptr_t)d, (size_t)(uintptr_t)s, 5, 1) != 0u)
      return 5;
    (void)lean_fs_par_map_fold((size_t)(uintptr_t)e, (size_t)(uintptr_t)s, 5, 1);
    if (!check_buf_eq(d, e, 5, "hw n=5"))
      return 6;
  }
  /* Greppable n=0 / n=1 edges */
  {
    uint8_t s[1] = {7};
    uint8_t d[1] = {0xee};
    if (lean_fs_par_map_add_u8_simd_hw((size_t)(uintptr_t)d, (size_t)(uintptr_t)s, 0, 1) != 0u)
      return 7;
    if (d[0] != 0xee)
      return 8;
    printf("par_map_add_u8_simd_hw_n0: ok\n");
  }
  {
    uint8_t s[1] = {7};
    uint8_t d[1] = {0};
    uint8_t e[1] = {0};
    if (lean_fs_par_map_add_u8_simd_hw((size_t)(uintptr_t)d, (size_t)(uintptr_t)s, 1, 3) != 0u)
      return 9;
    (void)lean_fs_par_map_fold((size_t)(uintptr_t)e, (size_t)(uintptr_t)s, 1, 3);
    if (d[0] != e[0] || d[0] != 10)
      return 10;
    printf("par_map_add_u8_simd_hw_n1: 10\n");
  }

  printf("par_map_add_u8_simd_hw: OK\n");
  printf("check-par-simd-hw: OK\n");
  return 0;
}
