/* Slake DepGraph wire dogfood.
 *
 * Links freestanding product extract and builds a small dep DAG
 * (A depends B depends C → edges C→B, B→A so C precedes B precedes A),
 * runs lean_fs_depgraph_topo, prints order. See doc/dev/slake.md.
 */
#define _POSIX_C_SOURCE 200809L
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern uint32_t lean_fs_depgraph_init(size_t degs, size_t node_cap);
extern uint32_t lean_fs_depgraph_add_edge(size_t adj, size_t degs, size_t node_cap,
                                         size_t max_deg, uint32_t src, uint32_t dst);
extern uint32_t lean_fs_depgraph_topo(size_t adj, size_t degs, size_t indeg, size_t queue,
                                     size_t out, size_t node_cap, size_t max_deg);
extern size_t lean_fs_depgraph_out_at(size_t out, size_t node_cap, size_t i);

/* Module ids: 0=A, 1=B, 2=C. Edge src→dst means src must precede dst. */
enum { MOD_A = 0, MOD_B = 1, MOD_C = 2, NCAP = 3, MDEG = 2 };

static int fail(const char *msg, int code) {
  fprintf(stderr, "slake depgraph_wire FAIL (%d): %s\n", code, msg);
  return code;
}

int main(void) {
  uint32_t adj[NCAP * MDEG];
  uint32_t degs[NCAP];
  uint32_t indeg[NCAP];
  uint32_t queue[NCAP];
  uint32_t out[NCAP];
  size_t pA = (size_t)-1, pB = (size_t)-1, pC = (size_t)-1;
  size_t i;

  memset(adj, 0, sizeof adj);
  if (lean_fs_depgraph_init((size_t)(uintptr_t)degs, NCAP) != 0)
    return fail("init", 1);

  /* C → B → A  (build C first, then B, then A) */
  if (lean_fs_depgraph_add_edge((size_t)(uintptr_t)adj, (size_t)(uintptr_t)degs,
                                NCAP, MDEG, MOD_C, MOD_B) != 0)
    return fail("edge C→B", 2);
  if (lean_fs_depgraph_add_edge((size_t)(uintptr_t)adj, (size_t)(uintptr_t)degs,
                                NCAP, MDEG, MOD_B, MOD_A) != 0)
    return fail("edge B→A", 3);

  if (lean_fs_depgraph_topo((size_t)(uintptr_t)adj, (size_t)(uintptr_t)degs,
                            (size_t)(uintptr_t)indeg, (size_t)(uintptr_t)queue,
                            (size_t)(uintptr_t)out, NCAP, MDEG) != 0)
    return fail("topo cycle/fail", 4);

  printf("depgraph_wire plan:");
  for (i = 0; i < NCAP; i++) {
    size_t v = lean_fs_depgraph_out_at((size_t)(uintptr_t)out, NCAP, i);
    const char *name = "?";
    if (v == MOD_A) { name = "A"; pA = i; }
    else if (v == MOD_B) { name = "B"; pB = i; }
    else if (v == MOD_C) { name = "C"; pC = i; }
    printf(" %s", name);
  }
  printf("\n");

  if (pA == (size_t)-1 || pB == (size_t)-1 || pC == (size_t)-1)
    return fail("missing node in order", 5);
  if (!(pC < pB && pB < pA))
    return fail("expected C before B before A", 6);

  printf("slake_depgraph_wire: ok\n");
  return 0;
}
