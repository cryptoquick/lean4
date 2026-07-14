#!/usr/bin/env bash
# Negative cases for systems-selfhost-link-check.sh (fail-closed).
# Ensures the gate rejects missing artifacts and Lean runtime / dynlib residues.
#
# Split coverage:
#   * Artifact cases (missing/empty) always run — no C compiler required.
#   * Object residual cases need a C compiler (CC, else cc, else gcc).
#     Without a compiler, object cases are SKIPPED (exit 0 after artifact cases)
#     so validate can still exercise G1 no-success-token checks on FAIL artifacts.
#   * SYSTEMS_LEAN_LINK_CHECK_NEG_ARTIFACT_ONLY=1 forces artifact-only (skip objects).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
GATE="$ROOT/script/systems-selfhost-link-check.sh"
if [[ ! -x "$GATE" ]]; then
  chmod +x "$GATE" 2>/dev/null || true
fi

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

# Resolve C compiler once (align with systems-validate.sh discovery).
CC_BIN="${CC:-}"
if [[ -z "$CC_BIN" ]]; then
  if command -v cc >/dev/null 2>&1; then
    CC_BIN="$(command -v cc)"
  elif command -v gcc >/dev/null 2>&1; then
    CC_BIN="$(command -v gcc)"
  fi
fi

# fail_case name [--expect RE] cmd...
# --expect: require a FAIL: line matching RE (wrong failure class must not pass).
fail_case() {
  local name="$1"
  shift
  local expect_re=""
  if [[ "${1:-}" == "--expect" ]]; then
    expect_re="$2"
    shift 2
  fi
  local out="$tmpdir/$name.out"
  set +e
  "$@" >"$out" 2>&1
  local ec=$?
  set -e
  if [[ $ec -eq 0 ]]; then
    echo "FAIL: expected non-zero for case $name" >&2
    cat "$out" >&2
    exit 1
  fi
  if ! grep -qE '^FAIL:' "$out"; then
    echo "FAIL: case $name: expected FAIL: line in output" >&2
    cat "$out" >&2
    exit 1
  fi
  if [[ -n "$expect_re" ]] && ! grep -qE "$expect_re" "$out"; then
    echo "FAIL: case $name: expected FAIL matching /$expect_re/" >&2
    cat "$out" >&2
    exit 1
  fi
  # Success tokens must never appear on residual failure (product GC-free claim).
  if grep -qE '^PRODUCT_GC_FREE=1$' "$out" || grep -qE '^PRODUCT_NO_LEANSHARED=1$' "$out"; then
    echo "FAIL: case $name: residual FAIL must not emit PRODUCT_GC_FREE=1 / PRODUCT_NO_LEANSHARED=1" >&2
    cat "$out" >&2
    exit 1
  fi
  echo "OK: negative case $name (exit $ec)"
  # Diagnostic only: avoid SIGPIPE→exit 141 under `set -o pipefail` when head closes early.
  grep -E '^FAIL:' "$out" | head -n2 || true
}

# 1) Missing artifact → fail closed (not a silent OK)
fail_case missing_artifact --expect 'missing product artifact' \
  "$GATE" "$tmpdir/no-such-product.a"

# 2) Empty file → fail closed
: >"$tmpdir/empty.a"
fail_case empty_artifact --expect 'empty' \
  "$GATE" "$tmpdir/empty.a"

# Object residual cases require a C compiler. Without one (or when ARTIFACT_ONLY=1),
# artifact cases above still provide G1 no-success-token coverage; exit 0 so
# validate is not blocked.
if [[ "${SYSTEMS_LEAN_LINK_CHECK_NEG_ARTIFACT_ONLY:-0}" == "1" || -z "$CC_BIN" ]]; then
  if [[ "${SYSTEMS_LEAN_LINK_CHECK_NEG_ARTIFACT_ONLY:-0}" == "1" ]]; then
    echo "OK: skip object residual cases (SYSTEMS_LEAN_LINK_CHECK_NEG_ARTIFACT_ONLY=1; artifact cases already ran)"
  else
    echo "OK: skip object residual cases (no C compiler; artifact cases already ran)"
    echo "hint: set CC= or install cc/gcc for full residual-object negative coverage" >&2
  fi
  echo "OK: systems-selfhost-link-check negatives passed (artifact-only)"
  exit 0
fi

compile_o() {
  local name="$1"
  local src="$tmpdir/$name.c"
  local obj="$tmpdir/$name.o"
  shift
  cat >"$src"
  if ! "$CC_BIN" -c -o "$obj" "$src" 2>"$tmpdir/$name.cc.err"; then
    echo "FAIL: $CC_BIN could not build negative fixture $name.o (tool discovery / compile error)" >&2
    cat "$tmpdir/$name.cc.err" >&2
    exit 1
  fi
  printf '%s\n' "$obj"
}

# 3) U lean_inc (narrow RC residual) → fail closed
obj=$(compile_o bad_rc <<'C'
extern void lean_inc(void *);
void product_entry(void *o) { lean_inc(o); }
C
)
fail_case rc_undef --expect 'Lean runtime / mangled undefs' \
  "$GATE" "$obj"

# 4) Broader Lean runtime undefs (gate must not blocklist-only lean_inc)
obj=$(compile_o bad_ctor <<'C'
extern void *lean_ctor_get(void *o, unsigned i);
void *product_get(void *o) { return lean_ctor_get(o, 0); }
C
)
fail_case ctor_get_undef --expect 'Lean runtime / mangled undefs' \
  "$GATE" "$obj"

obj=$(compile_o bad_apply <<'C'
extern void *lean_apply_1(void *f, void *a);
void *product_apply(void *f, void *a) { return lean_apply_1(f, a); }
C
)
fail_case apply_undef --expect 'Lean runtime / mangled undefs' \
  "$GATE" "$obj"

obj=$(compile_o bad_io <<'C'
extern void *lean_io_mk_world(void);
void *product_world(void) { return lean_io_mk_world(); }
C
)
fail_case io_undef --expect 'Lean runtime / mangled undefs' \
  "$GATE" "$obj"

obj=$(compile_o bad_mangle <<'C'
/* Mangled Lean-style symbol (U l_* policy). */
extern void l_List_map___rarg(void);
void product_map(void) { l_List_map___rarg(); }
C
)
fail_case mangle_l_undef --expect 'Lean runtime / mangled undefs' \
  "$GATE" "$obj"

# 5) Shared-lib name residues
obj=$(compile_o bad_shared <<'C'
/* Force a symbol name that the gate greps for in nm output. */
void Init_shared_bogus(void) {}
void leanshared_bogus(void) {}
C
)
fail_case shared_lib_residue --expect 'Init_shared|leanshared' \
  "$GATE" "$obj"

# 5b) Defined residual RC entry point (T lean_inc) — not undef-only policy
obj=$(compile_o bad_rc_def <<'C'
/* Define a residual RC entry point; must not emit PRODUCT_GC_FREE=1. */
void lean_inc(void *o) { (void)o; }
void product_entry(void *o) { lean_inc(o); }
C
)
fail_case rc_def --expect 'defines Lean RC/runtime' \
  "$GATE" "$obj"

# 6) Clean freestanding-shaped object must emit greppable product GC-free tokens
obj=$(compile_o clean_fs <<'C'
/* No Lean runtime; pure C entry. */
unsigned lean_fs_add_u(unsigned a, unsigned b) { return a + b; }
C
)
set +e
"$GATE" "$obj" >"$tmpdir/clean_fs.out" 2>&1
ec=$?
set -e
if [[ $ec -ne 0 ]]; then
  echo "FAIL: clean product object should pass link-check" >&2
  cat "$tmpdir/clean_fs.out" >&2
  exit 1
fi
if ! grep -qx 'PRODUCT_GC_FREE=1' "$tmpdir/clean_fs.out" \
  || ! grep -qx 'PRODUCT_NO_LEANSHARED=1' "$tmpdir/clean_fs.out"; then
  echo "FAIL: clean product object must emit PRODUCT_GC_FREE=1 and PRODUCT_NO_LEANSHARED=1" >&2
  cat "$tmpdir/clean_fs.out" >&2
  exit 1
fi
# No dual 0/1 product GC tokens on success path.
if grep -qx 'PRODUCT_GC_FREE=0' "$tmpdir/clean_fs.out" \
  || grep -qx 'PRODUCT_NO_LEANSHARED=0' "$tmpdir/clean_fs.out"; then
  echo "FAIL: clean_fs must not emit PRODUCT_GC_FREE=0 / PRODUCT_NO_LEANSHARED=0 alongside =1" >&2
  cat "$tmpdir/clean_fs.out" >&2
  exit 1
fi
echo "OK: positive case clean_fs emits PRODUCT_GC_FREE=1 PRODUCT_NO_LEANSHARED=1"

echo "OK: systems-selfhost-link-check negatives passed"
