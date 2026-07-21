/* Classic-host slake helper: freestanding DepGraph Kahn topo plan (Option C).
 *
 * Linked into the slake driver with libfs_extract_bundle.a (same pattern as
 * slake_fs_proc.c). Lean ABI: no Lean objects for demo plan; package plan order
 * is produced here and labels are printed by Lean.
 *
 * Env (from Slake.CLI):
 *   SLAKE_DEPGRAPH=1   freestanding package-derived (or demo) plan before lake
 *   SLAKE_PLAN_ONLY=1  print plan and skip lake spawn
 *
 * Package plan:
 *   - chain_topo(n): nodes 0→1→…→n-1 (declaration-order fallback)
 *   - edge_clear / edge_add / edges_topo(n): import-scan DAG edges among plan
 *     nodes (src precedes dst). Order via chain_out_at.
 * Demo print_plan remains for depgraph_wire parity (fixed C→B→A).
 * Honesty: import-scan is a fail-closed line subset — not full Lake module
 * faceting, not freestanding build TCB.
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

/* Module ids for demo: 0=A, 1=B, 2=C. Edge src→dst means src must precede dst. */
enum { MOD_A = 0, MOD_B = 1, MOD_C = 2, NCAP = 3, MDEG = 2 };

/* Package-derived plan capacity (fixed stack; matches Lean max). */
enum { PKG_MAX = 16, PKG_MDEG = 8, PKG_MAX_EDGES = 64 };

static uint32_t g_chain_out[PKG_MAX];
static uint32_t g_chain_n;

/* Staging buffer for import-scan edges (src,dst pairs) before edges_topo. */
static uint32_t g_edge_src[PKG_MAX_EDGES];
static uint32_t g_edge_dst[PKG_MAX_EDGES];
static uint32_t g_edge_n;

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

/*
 * Package-derived chain: nodes 0..n-1 with edges i→i+1 (declaration order).
 * Runs freestanding DepGraph Kahn; stores topo in g_chain_out for chain_out_at.
 * n==0 or n>PKG_MAX → fail. Single node (n==1) is a valid empty-edge topo.
 * Returns 0 on success, 1 on failure.
 */
LEAN_EXPORT uint32_t slake_fs_depgraph_chain_topo(uint32_t n) {
  uint32_t adj[PKG_MAX * PKG_MDEG];
  uint32_t degs[PKG_MAX];
  uint32_t indeg[PKG_MAX];
  uint32_t queue[PKG_MAX];
  uint32_t out[PKG_MAX];
  uint32_t i;

  g_chain_n = 0;
  if (n == 0 || n > PKG_MAX)
    return 1u;

  memset(adj, 0, sizeof adj);
  if (lean_fs_depgraph_init((size_t)(uintptr_t)degs, (size_t)n) != 0)
    return 1u;

  for (i = 0; i + 1 < n; i++) {
    if (lean_fs_depgraph_add_edge((size_t)(uintptr_t)adj, (size_t)(uintptr_t)degs,
                                  (size_t)n, PKG_MDEG, i, i + 1) != 0)
      return 1u;
  }

  if (lean_fs_depgraph_topo((size_t)(uintptr_t)adj, (size_t)(uintptr_t)degs,
                            (size_t)(uintptr_t)indeg, (size_t)(uintptr_t)queue,
                            (size_t)(uintptr_t)out, (size_t)n, PKG_MDEG) != 0)
    return 1u;

  for (i = 0; i < n; i++) {
    size_t v = lean_fs_depgraph_out_at((size_t)(uintptr_t)out, (size_t)n, (size_t)i);
    if (v >= (size_t)n)
      return 1u;
    g_chain_out[i] = (uint32_t)v;
  }
  g_chain_n = n;

  /* Chain must preserve declaration order: 0,1,2,...,n-1 */
  for (i = 0; i < n; i++) {
    if (g_chain_out[i] != i)
      return 1u;
  }
  return 0u;
}

/* Clear staged import-scan edges (call before edge_add sequence). */
LEAN_EXPORT uint32_t slake_fs_depgraph_edge_clear(void) {
  g_edge_n = 0;
  return 0u;
}

/*
 * Stage one directed edge src→dst (src precedes dst). Bounds-checked against
 * PKG_MAX node ids and PKG_MAX_EDGES. Returns 0 ok, 1 full/OOB.
 */
LEAN_EXPORT uint32_t slake_fs_depgraph_edge_add(uint32_t src, uint32_t dst) {
  if (g_edge_n >= PKG_MAX_EDGES)
    return 1u;
  if (src >= PKG_MAX || dst >= PKG_MAX)
    return 1u;
  g_edge_src[g_edge_n] = src;
  g_edge_dst[g_edge_n] = dst;
  g_edge_n++;
  return 0u;
}

/*
 * Kahn topo on staged edges for n nodes. Empty edge set is valid (order =
 * seed order 0..n-1). Stores result in g_chain_out for chain_out_at.
 * Returns 0 success, 1 init/edge/topo/cycle failure.
 */
LEAN_EXPORT uint32_t slake_fs_depgraph_edges_topo(uint32_t n) {
  uint32_t adj[PKG_MAX * PKG_MDEG];
  uint32_t degs[PKG_MAX];
  uint32_t indeg[PKG_MAX];
  uint32_t queue[PKG_MAX];
  uint32_t out[PKG_MAX];
  uint32_t i;

  g_chain_n = 0;
  if (n == 0 || n > PKG_MAX)
    return 1u;

  memset(adj, 0, sizeof adj);
  if (lean_fs_depgraph_init((size_t)(uintptr_t)degs, (size_t)n) != 0)
    return 1u;

  for (i = 0; i < g_edge_n; i++) {
    uint32_t s = g_edge_src[i];
    uint32_t d = g_edge_dst[i];
    if (s >= n || d >= n)
      return 1u;
    if (lean_fs_depgraph_add_edge((size_t)(uintptr_t)adj, (size_t)(uintptr_t)degs,
                                  (size_t)n, PKG_MDEG, s, d) != 0)
      return 1u;
  }

  if (lean_fs_depgraph_topo((size_t)(uintptr_t)adj, (size_t)(uintptr_t)degs,
                            (size_t)(uintptr_t)indeg, (size_t)(uintptr_t)queue,
                            (size_t)(uintptr_t)out, (size_t)n, PKG_MDEG) != 0)
    return 1u;

  for (i = 0; i < n; i++) {
    size_t v = lean_fs_depgraph_out_at((size_t)(uintptr_t)out, (size_t)n, (size_t)i);
    if (v >= (size_t)n)
      return 1u;
    g_chain_out[i] = (uint32_t)v;
  }
  g_chain_n = n;
  return 0u;
}

/* Index into last successful chain_topo / edges_topo result; UINT32_MAX on OOB. */
LEAN_EXPORT uint32_t slake_fs_depgraph_chain_out_at(uint32_t i) {
  if (i >= g_chain_n)
    return 0xffffffffu;
  return g_chain_out[i];
}

/* Probe for env reporting: depgraph shim linked + callable. */
LEAN_EXPORT uint32_t slake_fs_depgraph_linked(void) {
  return 1u;
}
