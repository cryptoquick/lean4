/* Opt-in L1 hardware SIMD dogfood for Systems Lean Three-Layer Cake.
 *
 * NOT part of the freestanding product residual / ccomp matrix.
 * Product L1 stays sequential SIMD-**shaped** chunked-4 (Systems.Parallelism.Simd).
 * Link only via `make check-par-simd-hw` (host dogfood binary).
 *
 * Platform path: when SSE2 is available (__SSE2__ or __x86_64__) **and**
 * SYSTEMS_LEAN_PAR_SIMD_FORCE_SCALAR is not defined, process 16-byte windows
 * with _mm_add_epi8; otherwise fall back to a sequential chunk-4-compatible
 * scalar loop (same dual-param ABI / results).
 *
 * Force scalar dogfood (Issue 5):
 *   cc … -DSYSTEMS_LEAN_PAR_SIMD_FORCE_SCALAR=1 … par_simd_hw.c
 *   make check-par-simd-hw SYSTEMS_LEAN_PAR_SIMD_FORCE_SCALAR=1
 * Backend id: 1 = SSE2 compiled in; 2 = scalar fallback / force-scalar.
 *
 * ABI matches product map dual params:
 *   uint32_t lean_fs_par_map_add_u8_simd_hw(size_t dst, size_t src, size_t n, uint8_t addend);
 * Returns 0 on completion.
 */
#include <stddef.h>
#include <stdint.h>

/* Force-scalar compile define wins over host SSE2 (dogfood portable path). */
#if defined(SYSTEMS_LEAN_PAR_SIMD_FORCE_SCALAR) && SYSTEMS_LEAN_PAR_SIMD_FORCE_SCALAR
#define SYSTEMS_LEAN_PAR_SIMD_HW_SSE2 0
#elif defined(__SSE2__) || defined(__x86_64__) || defined(_M_X64)
#define SYSTEMS_LEAN_PAR_SIMD_HW_SSE2 1
#include <emmintrin.h>
#else
#define SYSTEMS_LEAN_PAR_SIMD_HW_SSE2 0
#endif

static void lean_fs_par_map_add_u8_scalar(uint8_t *dst, const uint8_t *src, size_t n, uint8_t addend) {
  size_t i = 0;
  /* Chunk-4 shape (same ILP structure as product mapAddU8Chunk4); no HW ops. */
  while (i + 4u <= n) {
    dst[i + 0] = (uint8_t)((uint8_t)src[i + 0] + (uint8_t)addend);
    dst[i + 1] = (uint8_t)((uint8_t)src[i + 1] + (uint8_t)addend);
    dst[i + 2] = (uint8_t)((uint8_t)src[i + 2] + (uint8_t)addend);
    dst[i + 3] = (uint8_t)((uint8_t)src[i + 3] + (uint8_t)addend);
    i += 4u;
  }
  for (; i < n; i++)
    dst[i] = (uint8_t)((uint8_t)src[i] + (uint8_t)addend);
}

#if SYSTEMS_LEAN_PAR_SIMD_HW_SSE2
static void lean_fs_par_map_add_u8_sse2(uint8_t *dst, const uint8_t *src, size_t n, uint8_t addend) {
  size_t i = 0;
  __m128i vadd = _mm_set1_epi8((char)addend);
  for (; i + 16u <= n; i += 16u) {
    __m128i v = _mm_loadu_si128((const __m128i *)(const void *)(src + i));
    v = _mm_add_epi8(v, vadd);
    _mm_storeu_si128((__m128i *)(void *)(dst + i), v);
  }
  /* Tail: scalar remainder (may use chunk-4 for mid tails). */
  lean_fs_par_map_add_u8_scalar(dst + i, src + i, n - i, addend);
}
#endif

/* Same dual-param ABI as product lean_fs_par_map_fold map phase. */
uint32_t lean_fs_par_map_add_u8_simd_hw(size_t dst, size_t src, size_t n, uint8_t addend) {
  uint8_t *d = (uint8_t *)(uintptr_t)dst;
  const uint8_t *s = (const uint8_t *)(uintptr_t)src;
#if SYSTEMS_LEAN_PAR_SIMD_HW_SSE2
  lean_fs_par_map_add_u8_sse2(d, s, n, addend);
#else
  lean_fs_par_map_add_u8_scalar(d, s, n, addend);
#endif
  return 0u;
}

/* Backend marker for the HW SIMD dogfood binary only.
 * Product L1 has no corresponding export; sequential chunked-4 is the residual path.
 * 1 = SSE2 path compiled in; 2 = portable / force-scalar fallback. */
uint32_t lean_fs_par_l1_backend_simd_hw(uint32_t unused) {
  (void)unused;
#if SYSTEMS_LEAN_PAR_SIMD_HW_SSE2
  return 1u;
#else
  return 2u;
#endif
}
