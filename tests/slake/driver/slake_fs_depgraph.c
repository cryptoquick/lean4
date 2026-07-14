/* Classic-host slake helper: freestanding DepGraph Kahn topo plan (Option C).
 *
 * Linked into the slake driver with libfs_extract_bundle.a (same pattern as
 * slake_fs_proc.c). Lean ABI: no Lean objects — plan is printed from C.
 *
 * Env: SLAKE_DEPGRAPH=1 selects this path from Slake.CLI before lake build.
 * Demo graph honesty: fixed multi-module C→B→A (same as depgraph_wire dogfood).
 * Real lakefile multi-module parse remains residual.
 */
#define _POSIX_C_SOURCE 200809L
#include <lean/lean.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

extern uint32_t lean_fs_depgraph_init(size_t degs, size_t node_cap);
extern uint32_t lean_fs_depgraph_add_edge(size_t adj, size_t degs, size_t node_cap,
                                         size_t max_deg, uint32_t src, uint32_t dst);
extern uint32_t lean_fs_depgraph_topo(size_t adj, size_t degs, size_t indeg, size_t queue,
                                     size_t out, size_t node_cap, size_t max_deg);
extern size_t lean_fs_depgraph_out_at(size_t out, size_t node_cap, size_t i);

/* Module ids: 0=A, 1=B, 2=C. Edge src→dst means src must precede dst. */
enum { MOD_A = 0, MOD_B = 1, MOD_C = 2, NCAP = 3, MDEG = 2 };

/*
 * Build demo multi-module plan (C before B before A) via freestanding DepGraph.
 *
 * Prints:  slake depgraph plan: C B A
 * Returns: 0 on success, 1 on init/edge/topo/order failure.
 */
LEAN_EXPORT uint32_t slake_fs_depgraph_print_plan(void) {
  uint32_t adj[NCAP * MDEG];
  uint32_t degs[NCAP];
  uint32_t indeg[NCAP];
  uint32_t queue[NCAP];
  uint32_t out[NCAP];
  size_t pA = (size_t)-1, pB = (size_t)-1, pC = (size_t)-1;
  size_t i;

  memset(adj, 0, sizeof adj);
  if (lean_fs_depgraph_init((size_t)(uintptr_t)degs, NCAP) != 0)
    return 1u;

  /* C → B → A  (build C first, then B, then A) */
  if (lean_fs_depgraph_add_edge((size_t)(uintptr_t)adj, (size_t)(uintptr_t)degs,
                                NCAP, MDEG, MOD_C, MOD_B) != 0)
    return 1u;
  if (lean_fs_depgraph_add_edge((size_t)(uintptr_t)adj, (size_t)(uintptr_t)degs,
                                NCAP, MDEG, MOD_B, MOD_A) != 0)
    return 1u;

  if (lean_fs_depgraph_topo((size_t)(uintptr_t)adj, (size_t)(uintptr_t)degs,
                            (size_t)(uintptr_t)indeg, (size_t)(uintptr_t)queue,
                            (size_t)(uintptr_t)out, NCAP, MDEG) != 0)
    return 1u;

  printf("slake depgraph plan:");
  for (i = 0; i < NCAP; i++) {
    size_t v = lean_fs_depgraph_out_at((size_t)(uintptr_t)out, NCAP, i);
    const char *name = "?";
    if (v == MOD_A) {
      name = "A";
      pA = i;
    } else if (v == MOD_B) {
      name = "B";
      pB = i;
    } else if (v == MOD_C) {
      name = "C";
      pC = i;
    }
    printf(" %s", name);
  }
  printf("\n");
  fflush(stdout);

  if (pA == (size_t)-1 || pB == (size_t)-1 || pC == (size_t)-1)
    return 1u;
  if (!(pC < pB && pB < pA))
    return 1u;
  return 0u;
}

/* Probe for env reporting: depgraph shim linked + callable. */
LEAN_EXPORT uint32_t slake_fs_depgraph_linked(void) {
  return 1u;
}
