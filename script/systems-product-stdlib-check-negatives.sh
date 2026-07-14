#!/usr/bin/env bash
# Negative / positive cases for systems-product-stdlib-check.sh
# (B2 PRODUCT ↔ corpus + Phase E naming gate).
# Focus: corpus membership (PRODUCT_CORPUS_ALIGN_OK) + allowlist coverage (MODULES_OK)
#        + Phase E forbidden PRODUCT basenames (PRODUCT_NAMING_GATE_OK).
# Token split: ALIGN = membership only; allowlist FAIL can leave ALIGN=1 + MODULES_OK=0.
# Naming FAIL: MODULES_OK=0 + NAMING_GATE_OK=0 (may still leave ALIGN=1 or fail earlier).
# Does not require freestanding product IR artifacts (IR root points at missing tree).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
GATE="$ROOT/script/systems-product-stdlib-check.sh"
chmod +x "$GATE"

tmpdir="$(mktemp -d)"
cleanup() {
  rm -rf "$tmpdir"
}
trap cleanup EXIT

fail_case() {
  local name="$1"
  shift
  local out="$tmpdir/$name.out"
  set +e
  "$@" >"$out" 2>&1
  local ec=$?
  set -e
  # Gate must exit exactly 1 (not other non-zero).
  if [[ $ec -ne 1 ]]; then
    echo "FAIL: expected exit 1 for case $name (got $ec)" >&2
    cat "$out" >&2
    exit 1
  fi
  if grep -qx 'PRODUCT_STDLIB_MODULES_OK=1' "$out"; then
    echo "FAIL: case $name printed PRODUCT_STDLIB_MODULES_OK=1 on failure" >&2
    cat "$out" >&2
    exit 1
  fi
  if ! grep -qx 'PRODUCT_STDLIB_MODULES_OK=0' "$out"; then
    echo "FAIL: case $name missing PRODUCT_STDLIB_MODULES_OK=0" >&2
    cat "$out" >&2
    exit 1
  fi
  if ! grep -qE '^FAIL:' "$out"; then
    echo "FAIL: case $name: expected FAIL: line in output" >&2
    cat "$out" >&2
    exit 1
  fi
  echo "OK: negative case $name (exit $ec)"
}

pass_case() {
  local name="$1"
  shift
  local out="$tmpdir/$name.out"
  set +e
  "$@" >"$out" 2>&1
  local ec=$?
  set -e
  if [[ $ec -ne 0 ]]; then
    echo "FAIL: expected zero for case $name" >&2
    cat "$out" >&2
    exit 1
  fi
  if ! grep -qx 'PRODUCT_STDLIB_MODULES_OK=1' "$out"; then
    echo "FAIL: case $name missing PRODUCT_STDLIB_MODULES_OK=1" >&2
    cat "$out" >&2
    exit 1
  fi
  if ! grep -qx 'PRODUCT_CORPUS_ALIGN_OK=1' "$out"; then
    echo "FAIL: case $name missing PRODUCT_CORPUS_ALIGN_OK=1" >&2
    cat "$out" >&2
    exit 1
  fi
  echo "OK: positive case $name"
}

# Non-existent IR root: skip IR residual / Extract hard-requires
# (check only hard-requires Extract when IR_ROOT is an existing directory).
IR_SKIP="$tmpdir/no-such-ir-root"
# Missing lakefile ⇒ lake root check skipped.

# Use real Status.lean (PRODUCT module, zero axioms) for alignment fixtures.
# Manifest lists Status only so residual-policy matches a single-module product set.
cat >"$tmpdir/manifest-status.txt" <<'EOF'
# fixture single-module PRODUCT set
Status
EOF

# Corpus with Status present
cat >"$tmpdir/corpus-with-status.txt" <<'EOF'
# fixture corpus
src/Systems/Status.lean
EOF

# Corpus missing Status
cat >"$tmpdir/corpus-missing-status.txt" <<'EOF'
# fixture corpus without Status
src/Systems/Scalars.lean
EOF

# Empty allowlist (Status has no axioms — coverage OK)
cat >"$tmpdir/allow-empty.txt" <<'EOF'
# empty allowlist — OK for axiom-free PRODUCT modules
EOF

# --- 1) PRODUCT module missing from ComplianceCorpus ⇒ FAIL + PRODUCT_CORPUS_ALIGN_OK=0 ---
fail_case product_missing_from_corpus \
  env SYSTEMS_LEAN_PRODUCT_STDLIB_MANIFEST="$tmpdir/manifest-status.txt" \
      SYSTEMS_LEAN_COMPLIANCE_CORPUS="$tmpdir/corpus-missing-status.txt" \
      SYSTEMS_LEAN_TCB_AXIOM_ALLOWLIST="$tmpdir/allow-empty.txt" \
      SYSTEMS_LEAN_PRODUCT_IR_ROOT="$IR_SKIP" \
      SYSTEMS_LEAN_PRODUCT_LAKEFILE="$tmpdir/no-such-lakefile.lean" \
      "$GATE"
out_miss="$tmpdir/product_missing_from_corpus.out"
if ! grep -qx 'PRODUCT_CORPUS_ALIGN_OK=0' "$out_miss"; then
  echo "FAIL: product_missing_from_corpus missing PRODUCT_CORPUS_ALIGN_OK=0" >&2
  cat "$out_miss" >&2
  exit 1
fi
if ! grep -q 'missing from ComplianceCorpus' "$out_miss"; then
  echo "FAIL: product_missing_from_corpus should mention ComplianceCorpus" >&2
  cat "$out_miss" >&2
  exit 1
fi

# --- 2) Missing corpus file ⇒ FAIL (fail-closed, no skip) ---
fail_case missing_corpus_file \
  env SYSTEMS_LEAN_PRODUCT_STDLIB_MANIFEST="$tmpdir/manifest-status.txt" \
      SYSTEMS_LEAN_COMPLIANCE_CORPUS="$tmpdir/no-such-corpus.txt" \
      SYSTEMS_LEAN_TCB_AXIOM_ALLOWLIST="$tmpdir/allow-empty.txt" \
      SYSTEMS_LEAN_PRODUCT_IR_ROOT="$IR_SKIP" \
      SYSTEMS_LEAN_PRODUCT_LAKEFILE="$tmpdir/no-such-lakefile.lean" \
      "$GATE"
out_cf="$tmpdir/missing_corpus_file.out"
if ! grep -qx 'PRODUCT_CORPUS_ALIGN_OK=0' "$out_cf"; then
  echo "FAIL: missing_corpus_file missing PRODUCT_CORPUS_ALIGN_OK=0" >&2
  cat "$out_cf" >&2
  exit 1
fi

# --- 3) Aligned Status (axiom-free) + empty allowlist ⇒ PASS ---
pass_case product_corpus_aligned_axiom_free \
  env SYSTEMS_LEAN_PRODUCT_STDLIB_MANIFEST="$tmpdir/manifest-status.txt" \
      SYSTEMS_LEAN_COMPLIANCE_CORPUS="$tmpdir/corpus-with-status.txt" \
      SYSTEMS_LEAN_TCB_AXIOM_ALLOWLIST="$tmpdir/allow-empty.txt" \
      SYSTEMS_LEAN_PRODUCT_IR_ROOT="$IR_SKIP" \
      SYSTEMS_LEAN_PRODUCT_LAKEFILE="$tmpdir/no-such-lakefile.lean" \
      "$GATE"

# --- 4) PRODUCT module with axiom but no allowlist coverage ⇒ FAIL ---
# ALIGN stays 1 (membership holds); MODULES_OK=0 (allowlist coverage).
cat >"$tmpdir/manifest-bitops.txt" <<'EOF'
BitOps
EOF
cat >"$tmpdir/corpus-bitops.txt" <<'EOF'
src/Systems/BitOps.lean
EOF
fail_case product_axiom_unallowlisted \
  env SYSTEMS_LEAN_PRODUCT_STDLIB_MANIFEST="$tmpdir/manifest-bitops.txt" \
      SYSTEMS_LEAN_COMPLIANCE_CORPUS="$tmpdir/corpus-bitops.txt" \
      SYSTEMS_LEAN_TCB_AXIOM_ALLOWLIST="$tmpdir/allow-empty.txt" \
      SYSTEMS_LEAN_PRODUCT_IR_ROOT="$IR_SKIP" \
      SYSTEMS_LEAN_PRODUCT_LAKEFILE="$tmpdir/no-such-lakefile.lean" \
      "$GATE"
out_ua="$tmpdir/product_axiom_unallowlisted.out"
if ! grep -q 'name=U32.bswap' "$out_ua"; then
  echo "FAIL: product_axiom_unallowlisted should report name=U32.bswap" >&2
  cat "$out_ua" >&2
  exit 1
fi
if ! grep -qx 'PRODUCT_CORPUS_ALIGN_OK=1' "$out_ua"; then
  echo "FAIL: product_axiom_unallowlisted should keep PRODUCT_CORPUS_ALIGN_OK=1 (membership only)" >&2
  cat "$out_ua" >&2
  exit 1
fi
if ! grep -qx 'PRODUCT_STDLIB_MODULES_OK=0' "$out_ua"; then
  echo "FAIL: product_axiom_unallowlisted missing PRODUCT_STDLIB_MODULES_OK=0" >&2
  cat "$out_ua" >&2
  exit 1
fi

# --- 5) PRODUCT module with axiom + name= pin ⇒ PASS ---
printf 'src/Systems/BitOps.lean name=U32.bswap\n' >"$tmpdir/allow-bitops.txt"
pass_case product_axiom_name_pinned \
  env SYSTEMS_LEAN_PRODUCT_STDLIB_MANIFEST="$tmpdir/manifest-bitops.txt" \
      SYSTEMS_LEAN_COMPLIANCE_CORPUS="$tmpdir/corpus-bitops.txt" \
      SYSTEMS_LEAN_TCB_AXIOM_ALLOWLIST="$tmpdir/allow-bitops.txt" \
      SYSTEMS_LEAN_PRODUCT_IR_ROOT="$IR_SKIP" \
      SYSTEMS_LEAN_PRODUCT_LAKEFILE="$tmpdir/no-such-lakefile.lean" \
      "$GATE"

# --- 6) PRODUCT module with axiom + path-only allow ⇒ PASS ---
printf 'src/Systems/BitOps.lean\n' >"$tmpdir/allow-bitops-path.txt"
pass_case product_axiom_path_allow \
  env SYSTEMS_LEAN_PRODUCT_STDLIB_MANIFEST="$tmpdir/manifest-bitops.txt" \
      SYSTEMS_LEAN_COMPLIANCE_CORPUS="$tmpdir/corpus-bitops.txt" \
      SYSTEMS_LEAN_TCB_AXIOM_ALLOWLIST="$tmpdir/allow-bitops-path.txt" \
      SYSTEMS_LEAN_PRODUCT_IR_ROOT="$IR_SKIP" \
      SYSTEMS_LEAN_PRODUCT_LAKEFILE="$tmpdir/no-such-lakefile.lean" \
      "$GATE"

# --- 7) Wrong name= pin ⇒ FAIL; ALIGN=1 MODULES_OK=0 token split ---
printf 'src/Systems/BitOps.lean name=U32.wrongName\n' >"$tmpdir/allow-bitops-wrong.txt"
fail_case product_axiom_wrong_name \
  env SYSTEMS_LEAN_PRODUCT_STDLIB_MANIFEST="$tmpdir/manifest-bitops.txt" \
      SYSTEMS_LEAN_COMPLIANCE_CORPUS="$tmpdir/corpus-bitops.txt" \
      SYSTEMS_LEAN_TCB_AXIOM_ALLOWLIST="$tmpdir/allow-bitops-wrong.txt" \
      SYSTEMS_LEAN_PRODUCT_IR_ROOT="$IR_SKIP" \
      SYSTEMS_LEAN_PRODUCT_LAKEFILE="$tmpdir/no-such-lakefile.lean" \
      "$GATE"
out_wn="$tmpdir/product_axiom_wrong_name.out"
if ! grep -q 'name=U32.bswap' "$out_wn"; then
  echo "FAIL: product_axiom_wrong_name should report name=U32.bswap" >&2
  cat "$out_wn" >&2
  exit 1
fi
if ! grep -qx 'PRODUCT_CORPUS_ALIGN_OK=1' "$out_wn"; then
  echo "FAIL: product_axiom_wrong_name should keep PRODUCT_CORPUS_ALIGN_OK=1" >&2
  cat "$out_wn" >&2
  exit 1
fi
if ! grep -qx 'PRODUCT_STDLIB_MODULES_OK=0' "$out_wn"; then
  echo "FAIL: product_axiom_wrong_name missing PRODUCT_STDLIB_MODULES_OK=0" >&2
  cat "$out_wn" >&2
  exit 1
fi

# --- 8) Multi-axiom partial name pins (Hash: pin one of six) ⇒ FAIL ---
cat >"$tmpdir/manifest-hash.txt" <<'EOF'
Hash
EOF
cat >"$tmpdir/corpus-hash.txt" <<'EOF'
src/Systems/Hash.lean
EOF
# Only pin fnvOffsetBasis; other Hash axioms uncovered.
printf 'src/Systems/Hash.lean name=fnvOffsetBasis\n' >"$tmpdir/allow-hash-partial.txt"
fail_case product_multi_axiom_partial_pin \
  env SYSTEMS_LEAN_PRODUCT_STDLIB_MANIFEST="$tmpdir/manifest-hash.txt" \
      SYSTEMS_LEAN_COMPLIANCE_CORPUS="$tmpdir/corpus-hash.txt" \
      SYSTEMS_LEAN_TCB_AXIOM_ALLOWLIST="$tmpdir/allow-hash-partial.txt" \
      SYSTEMS_LEAN_PRODUCT_IR_ROOT="$IR_SKIP" \
      SYSTEMS_LEAN_PRODUCT_LAKEFILE="$tmpdir/no-such-lakefile.lean" \
      "$GATE"
out_mp="$tmpdir/product_multi_axiom_partial_pin.out"
if ! grep -q 'name=fnvPrime' "$out_mp"; then
  echo "FAIL: product_multi_axiom_partial_pin should report an unpinned Hash axiom (e.g. fnvPrime)" >&2
  cat "$out_mp" >&2
  exit 1
fi
if ! grep -qx 'PRODUCT_CORPUS_ALIGN_OK=1' "$out_mp"; then
  echo "FAIL: product_multi_axiom_partial_pin should keep PRODUCT_CORPUS_ALIGN_OK=1" >&2
  cat "$out_mp" >&2
  exit 1
fi
if ! grep -qx 'PRODUCT_STDLIB_MODULES_OK=0' "$out_mp"; then
  echo "FAIL: product_multi_axiom_partial_pin missing PRODUCT_STDLIB_MODULES_OK=0" >&2
  cat "$out_mp" >&2
  exit 1
fi

# --- 9) Dual path-only + name= for same path ⇒ FAIL ---
{
  printf 'src/Systems/BitOps.lean\n'
  printf 'src/Systems/BitOps.lean name=U32.bswap\n'
} >"$tmpdir/allow-bitops-dual.txt"
fail_case product_dual_path_and_name \
  env SYSTEMS_LEAN_PRODUCT_STDLIB_MANIFEST="$tmpdir/manifest-bitops.txt" \
      SYSTEMS_LEAN_COMPLIANCE_CORPUS="$tmpdir/corpus-bitops.txt" \
      SYSTEMS_LEAN_TCB_AXIOM_ALLOWLIST="$tmpdir/allow-bitops-dual.txt" \
      SYSTEMS_LEAN_PRODUCT_IR_ROOT="$IR_SKIP" \
      SYSTEMS_LEAN_PRODUCT_LAKEFILE="$tmpdir/no-such-lakefile.lean" \
      "$GATE"
out_pd="$tmpdir/product_dual_path_and_name.out"
if ! grep -q 'dual allowlist entry' "$out_pd"; then
  echo "FAIL: product_dual_path_and_name should report dual allowlist entry" >&2
  cat "$out_pd" >&2
  exit 1
fi

# --- 10) Missing allowlist file ⇒ FAIL (fail-closed) ---
fail_case product_missing_allowlist \
  env SYSTEMS_LEAN_PRODUCT_STDLIB_MANIFEST="$tmpdir/manifest-status.txt" \
      SYSTEMS_LEAN_COMPLIANCE_CORPUS="$tmpdir/corpus-with-status.txt" \
      SYSTEMS_LEAN_TCB_AXIOM_ALLOWLIST="$tmpdir/no-such-allowlist.txt" \
      SYSTEMS_LEAN_PRODUCT_IR_ROOT="$IR_SKIP" \
      SYSTEMS_LEAN_PRODUCT_LAKEFILE="$tmpdir/no-such-lakefile.lean" \
      "$GATE"
out_ma="$tmpdir/product_missing_allowlist.out"
if ! grep -qE 'missing TCB axiom allowlist|allowlist' "$out_ma"; then
  echo "FAIL: product_missing_allowlist should mention missing allowlist" >&2
  cat "$out_ma" >&2
  exit 1
fi

# --- 11) Nested Par/* PRODUCT path on corpus + name pins ⇒ PASS ---
# Real Parallelism/Simd (nested path) with single U8.add name pin.
cat >"$tmpdir/manifest-par-simd.txt" <<'EOF'
Parallelism/Simd
EOF
cat >"$tmpdir/corpus-par-simd.txt" <<'EOF'
src/Systems/Parallelism/Simd.lean
EOF
printf 'src/Systems/Parallelism/Simd.lean name=U8.add\n' >"$tmpdir/allow-par-simd.txt"
pass_case product_nested_par_simd_aligned \
  env SYSTEMS_LEAN_PRODUCT_STDLIB_MANIFEST="$tmpdir/manifest-par-simd.txt" \
      SYSTEMS_LEAN_COMPLIANCE_CORPUS="$tmpdir/corpus-par-simd.txt" \
      SYSTEMS_LEAN_TCB_AXIOM_ALLOWLIST="$tmpdir/allow-par-simd.txt" \
      SYSTEMS_LEAN_PRODUCT_IR_ROOT="$IR_SKIP" \
      SYSTEMS_LEAN_PRODUCT_LAKEFILE="$tmpdir/no-such-lakefile.lean" \
      "$GATE"
out_ps="$tmpdir/product_nested_par_simd_aligned.out"
if ! grep -q 'OK corpus: src/Systems/Parallelism/Simd.lean' "$out_ps"; then
  echo "FAIL: product_nested_par_simd_aligned should OK corpus nested Parallelism/Simd path" >&2
  cat "$out_ps" >&2
  exit 1
fi

# --- 12) Nested Par/* missing from corpus ⇒ FAIL + ALIGN=0 ---
cat >"$tmpdir/corpus-no-par.txt" <<'EOF'
src/Systems/Status.lean
EOF
fail_case product_nested_par_missing_from_corpus \
  env SYSTEMS_LEAN_PRODUCT_STDLIB_MANIFEST="$tmpdir/manifest-par-simd.txt" \
      SYSTEMS_LEAN_COMPLIANCE_CORPUS="$tmpdir/corpus-no-par.txt" \
      SYSTEMS_LEAN_TCB_AXIOM_ALLOWLIST="$tmpdir/allow-par-simd.txt" \
      SYSTEMS_LEAN_PRODUCT_IR_ROOT="$IR_SKIP" \
      SYSTEMS_LEAN_PRODUCT_LAKEFILE="$tmpdir/no-such-lakefile.lean" \
      "$GATE"
out_pmiss="$tmpdir/product_nested_par_missing_from_corpus.out"
if ! grep -qx 'PRODUCT_CORPUS_ALIGN_OK=0' "$out_pmiss"; then
  echo "FAIL: product_nested_par_missing_from_corpus missing PRODUCT_CORPUS_ALIGN_OK=0" >&2
  cat "$out_pmiss" >&2
  exit 1
fi
if ! grep -q 'Parallelism/Simd' "$out_pmiss"; then
  echo "FAIL: product_nested_par_missing_from_corpus should mention Parallelism/Simd" >&2
  cat "$out_pmiss" >&2
  exit 1
fi

# --- Phase E naming gate: forbidden PRODUCT basenames fail closed (early; no source required) ---
# Naming checks run before source existence, so a pure-manifest forbidden name fails with
# an explicit naming FAIL even when the source is also missing.

# --- 13) *Lite basename ⇒ FAIL naming (*Lite residual empty after D21) ---
cat >"$tmpdir/manifest-toylite.txt" <<'EOF'
ToyLite
EOF
cat >"$tmpdir/corpus-toylite.txt" <<'EOF'
src/Systems/ToyLite.lean
EOF
fail_case product_naming_lite_forbidden \
  env SYSTEMS_LEAN_PRODUCT_STDLIB_MANIFEST="$tmpdir/manifest-toylite.txt" \
      SYSTEMS_LEAN_COMPLIANCE_CORPUS="$tmpdir/corpus-toylite.txt" \
      SYSTEMS_LEAN_TCB_AXIOM_ALLOWLIST="$tmpdir/allow-empty.txt" \
      SYSTEMS_LEAN_PRODUCT_IR_ROOT="$IR_SKIP" \
      SYSTEMS_LEAN_PRODUCT_LAKEFILE="$tmpdir/no-such-lakefile.lean" \
      "$GATE"
out_lite="$tmpdir/product_naming_lite_forbidden.out"
if ! grep -qE 'forbidden PRODUCT name pattern \(\*Lite\): ToyLite' "$out_lite"; then
  echo "FAIL: product_naming_lite_forbidden should report *Lite pattern for ToyLite" >&2
  cat "$out_lite" >&2
  exit 1
fi
if ! grep -qx 'PRODUCT_NAMING_GATE_OK=0' "$out_lite"; then
  echo "FAIL: product_naming_lite_forbidden missing PRODUCT_NAMING_GATE_OK=0" >&2
  cat "$out_lite" >&2
  exit 1
fi

# --- 14) pure V[0-9]+ (V99) ⇒ FAIL naming ---
cat >"$tmpdir/manifest-v99.txt" <<'EOF'
V99
EOF
cat >"$tmpdir/corpus-v99.txt" <<'EOF'
src/Systems/V99.lean
EOF
fail_case product_naming_v_series_forbidden \
  env SYSTEMS_LEAN_PRODUCT_STDLIB_MANIFEST="$tmpdir/manifest-v99.txt" \
      SYSTEMS_LEAN_COMPLIANCE_CORPUS="$tmpdir/corpus-v99.txt" \
      SYSTEMS_LEAN_TCB_AXIOM_ALLOWLIST="$tmpdir/allow-empty.txt" \
      SYSTEMS_LEAN_PRODUCT_IR_ROOT="$IR_SKIP" \
      SYSTEMS_LEAN_PRODUCT_LAKEFILE="$tmpdir/no-such-lakefile.lean" \
      "$GATE"
out_v="$tmpdir/product_naming_v_series_forbidden.out"
if ! grep -qE 'forbidden PRODUCT name pattern \(pure V\[0-9\]\+\): V99' "$out_v"; then
  echo "FAIL: product_naming_v_series_forbidden should report pure V[0-9]+ for V99" >&2
  cat "$out_v" >&2
  exit 1
fi
if ! grep -qx 'PRODUCT_NAMING_GATE_OK=0' "$out_v"; then
  echo "FAIL: product_naming_v_series_forbidden missing PRODUCT_NAMING_GATE_OK=0" >&2
  cat "$out_v" >&2
  exit 1
fi

# --- 15) thesaurus YarnHeap ⇒ FAIL naming ---
cat >"$tmpdir/manifest-yarnheap.txt" <<'EOF'
YarnHeap
EOF
cat >"$tmpdir/corpus-yarnheap.txt" <<'EOF'
src/Systems/YarnHeap.lean
EOF
fail_case product_naming_fashion_heap_forbidden \
  env SYSTEMS_LEAN_PRODUCT_STDLIB_MANIFEST="$tmpdir/manifest-yarnheap.txt" \
      SYSTEMS_LEAN_COMPLIANCE_CORPUS="$tmpdir/corpus-yarnheap.txt" \
      SYSTEMS_LEAN_TCB_AXIOM_ALLOWLIST="$tmpdir/allow-empty.txt" \
      SYSTEMS_LEAN_PRODUCT_IR_ROOT="$IR_SKIP" \
      SYSTEMS_LEAN_PRODUCT_LAKEFILE="$tmpdir/no-such-lakefile.lean" \
      "$GATE"
out_yh="$tmpdir/product_naming_fashion_heap_forbidden.out"
if ! grep -qE 'forbidden PRODUCT name pattern \(thesaurus fashion/heap\): YarnHeap' "$out_yh"; then
  echo "FAIL: product_naming_fashion_heap_forbidden should report fashion/heap for YarnHeap" >&2
  cat "$out_yh" >&2
  exit 1
fi
if ! grep -qx 'PRODUCT_NAMING_GATE_OK=0' "$out_yh"; then
  echo "FAIL: product_naming_fashion_heap_forbidden missing PRODUCT_NAMING_GATE_OK=0" >&2
  cat "$out_yh" >&2
  exit 1
fi

# --- 16) pure G7*Nb (G707Nb) ⇒ FAIL naming ---
cat >"$tmpdir/manifest-g7.txt" <<'EOF'
G707Nb
EOF
cat >"$tmpdir/corpus-g7.txt" <<'EOF'
src/Systems/G707Nb.lean
EOF
fail_case product_naming_g7nb_forbidden \
  env SYSTEMS_LEAN_PRODUCT_STDLIB_MANIFEST="$tmpdir/manifest-g7.txt" \
      SYSTEMS_LEAN_COMPLIANCE_CORPUS="$tmpdir/corpus-g7.txt" \
      SYSTEMS_LEAN_TCB_AXIOM_ALLOWLIST="$tmpdir/allow-empty.txt" \
      SYSTEMS_LEAN_PRODUCT_IR_ROOT="$IR_SKIP" \
      SYSTEMS_LEAN_PRODUCT_LAKEFILE="$tmpdir/no-such-lakefile.lean" \
      "$GATE"
out_g7="$tmpdir/product_naming_g7nb_forbidden.out"
if ! grep -qE 'forbidden PRODUCT name pattern \(pure G7\*Nb\): G707Nb' "$out_g7"; then
  echo "FAIL: product_naming_g7nb_forbidden should report pure G7*Nb for G707Nb" >&2
  cat "$out_g7" >&2
  exit 1
fi
if ! grep -qx 'PRODUCT_NAMING_GATE_OK=0' "$out_g7"; then
  echo "FAIL: product_naming_g7nb_forbidden missing PRODUCT_NAMING_GATE_OK=0" >&2
  cat "$out_g7" >&2
  exit 1
fi

# --- 17) HeapSet ordered-leaf synonym ⇒ FAIL naming ---
cat >"$tmpdir/manifest-heapset.txt" <<'EOF'
HeapSet
EOF
cat >"$tmpdir/corpus-heapset.txt" <<'EOF'
src/Systems/HeapSet.lean
EOF
fail_case product_naming_heapset_forbidden \
  env SYSTEMS_LEAN_PRODUCT_STDLIB_MANIFEST="$tmpdir/manifest-heapset.txt" \
      SYSTEMS_LEAN_COMPLIANCE_CORPUS="$tmpdir/corpus-heapset.txt" \
      SYSTEMS_LEAN_TCB_AXIOM_ALLOWLIST="$tmpdir/allow-empty.txt" \
      SYSTEMS_LEAN_PRODUCT_IR_ROOT="$IR_SKIP" \
      SYSTEMS_LEAN_PRODUCT_LAKEFILE="$tmpdir/no-such-lakefile.lean" \
      "$GATE"
out_hs="$tmpdir/product_naming_heapset_forbidden.out"
if ! grep -qE 'forbidden PRODUCT name pattern \(thesaurus fashion/heap\): HeapSet' "$out_hs"; then
  echo "FAIL: product_naming_heapset_forbidden should report fashion/heap for HeapSet" >&2
  cat "$out_hs" >&2
  exit 1
fi
if ! grep -qx 'PRODUCT_NAMING_GATE_OK=0' "$out_hs"; then
  echo "FAIL: product_naming_heapset_forbidden missing PRODUCT_NAMING_GATE_OK=0" >&2
  cat "$out_hs" >&2
  exit 1
fi

# --- 18) Positive: plain-name honesty fixtures must not false-positive naming ---
# Status + BinaryHeap / TomlConfig / OrderedU32Set / V5ua real sources.
# Path-only allowlist covers axiom-bearing modules (naming is under test, not TCB pins).
cat >"$tmpdir/manifest-plain-ok.txt" <<'EOF'
Status
BinaryHeap
TomlConfig
OrderedU32Set
V5ua
EOF
cat >"$tmpdir/corpus-plain-ok.txt" <<'EOF'
src/Systems/Status.lean
src/Systems/BinaryHeap.lean
src/Systems/TomlConfig.lean
src/Systems/OrderedU32Set.lean
src/Systems/V5ua.lean
EOF
cat >"$tmpdir/allow-plain-ok.txt" <<'EOF'
# path-only INTENTIONAL_TCB for axiom-bearing plain names in this fixture
src/Systems/BinaryHeap.lean
src/Systems/TomlConfig.lean
src/Systems/OrderedU32Set.lean
src/Systems/V5ua.lean
EOF
pass_case product_naming_plain_names_ok \
  env SYSTEMS_LEAN_PRODUCT_STDLIB_MANIFEST="$tmpdir/manifest-plain-ok.txt" \
      SYSTEMS_LEAN_COMPLIANCE_CORPUS="$tmpdir/corpus-plain-ok.txt" \
      SYSTEMS_LEAN_TCB_AXIOM_ALLOWLIST="$tmpdir/allow-plain-ok.txt" \
      SYSTEMS_LEAN_PRODUCT_IR_ROOT="$IR_SKIP" \
      SYSTEMS_LEAN_PRODUCT_LAKEFILE="$tmpdir/no-such-lakefile.lean" \
      "$GATE"
out_plain="$tmpdir/product_naming_plain_names_ok.out"
if ! grep -qx 'PRODUCT_NAMING_GATE_OK=1' "$out_plain"; then
  echo "FAIL: product_naming_plain_names_ok missing PRODUCT_NAMING_GATE_OK=1" >&2
  cat "$out_plain" >&2
  exit 1
fi
if ! grep -q 'OK naming: BinaryHeap' "$out_plain"; then
  echo "FAIL: product_naming_plain_names_ok should OK naming BinaryHeap" >&2
  cat "$out_plain" >&2
  exit 1
fi
if ! grep -q 'OK naming: V5ua' "$out_plain"; then
  echo "FAIL: product_naming_plain_names_ok should OK naming V5ua (not pure V[0-9]+)" >&2
  cat "$out_plain" >&2
  exit 1
fi

# Status-only positive must also print NAMING_GATE_OK=1
out_status="$tmpdir/product_corpus_aligned_axiom_free.out"
if ! grep -qx 'PRODUCT_NAMING_GATE_OK=1' "$out_status"; then
  echo "FAIL: product_corpus_aligned_axiom_free missing PRODUCT_NAMING_GATE_OK=1" >&2
  cat "$out_status" >&2
  exit 1
fi

echo "OK: systems-product-stdlib-check negatives (PRODUCT_CORPUS_ALIGN; allowlist; Phase E naming; exit 1)"
exit 0
