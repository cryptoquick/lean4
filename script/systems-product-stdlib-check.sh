#!/usr/bin/env bash
# Systems Lean: PRODUCT_STDLIB_MODULES manifest gate.
#
# Proves (operationally) that the closed freestanding product stdlib set is:
#   - listed in script/systems-product-stdlib-modules.txt
#   - present as Lean sources under src/Systems/
#   - wired into freestanding lakefile roots (when that package exists)
#   - residual-policy module list matches the manifest (single source of truth)
#   - optional: product IR companions exist when IR_ROOT is set / default path present
#   - ComplianceCorpus covers every manifest module (B2 fail-closed; corpus required)
#   - PRODUCT modules with Lean `axiom` decls have TCB allowlist coverage
#   - Phase E naming gate: no *Lite / pure V[0-9]+ / pure G7*Nb / thesaurus-heap fashion basenames
#
# SSoT direction (intentional, one-way):
#   The **manifest is the product set**. This gate requires
#     manifest ⊆ (sources ∩ lakefile roots ∩ residual-policy ∩ corpus [∩ IR if present]).
#   It does **not** fail if the lakefile lists extra exploratory roots outside the
#   manifest (lake-only modules are not product residual matrix members until listed).
#   Grow PRODUCT only by appending to the manifest after residual + certs are green.
#
# Success (stdout, greppable):
#   PRODUCT_STDLIB_MODULES_OK=1
#   PRODUCT_STDLIB_MODULES_COUNT=N   # authoritative length of the closed set; grows with the manifest
#   PRODUCT_STDLIB_MODULES_LIST=...  # space-separated module paths
#   PRODUCT_CORPUS_ALIGN_OK=1        # PRODUCT ⊆ ComplianceCorpus membership only (B2)
#   PRODUCT_NAMING_GATE_OK=1         # Phase E: no forbidden PRODUCT basename patterns
# Failure: PRODUCT_STDLIB_MODULES_OK=0 (and PRODUCT_CORPUS_ALIGN_OK=0 when membership failed), exit ≠ 0
#
# Token split (honest):
#   PRODUCT_CORPUS_ALIGN_OK=1  ⇒ every PRODUCT module path is listed on ComplianceCorpus.
#     Does **not** imply name-pin completeness or allowlist coverage.
#   Allowlist coverage failures leave ALIGN=1 (when membership holds) but MODULES_OK=0.
#   PRODUCT_NAMING_GATE_OK=1  ⇒ every manifest basename passes Phase E forbidden-pattern checks.
#     Naming failures set MODULES_OK=0 + NAMING_GATE_OK=0 (may still leave ALIGN=1).
#
# Phase E forbidden PRODUCT basenames (last path segment; case-sensitive):
#   - ends with `Lite` (unless listed in optional empty allowlist SYSTEMS_LEAN_PRODUCT_LITE_ALLOWLIST;
#     post-D21 allowlist is empty — zero exceptions)
#   - pure `V[0-9]+` (e.g. V45); does **not** match V5ua / Vorbis / Vector
#   - pure `G7[0-9]+Nb` or `G7[0-9]+[a-zA-Z]+Nb` (magic annex toy names)
#   - thesaurus fashion: exact Yarn|Cable|…|Ply, or those + Heap (YarnHeap), or HeapSet
#     Does **not** ban BinaryHeap / bare Heap / legitimate algorithm names
# Policy: doc/dev/systems-naming.md
#
# COUNT is intentionally not pinned to a constant in validate: OK=1 already
# requires a non-empty manifest, lake/source/IR/corpus parity, residual-policy match,
# and Phase E naming patterns.
# Grep COUNT/LIST when a snapshot needs an exact size (live product is 149 modules → 150 TUs with Extract; authoritative list = systems-product-stdlib-modules.txt).
#
# B2 PRODUCT ↔ corpus alignment (fail-closed):
#   Every path in systems-product-stdlib-modules.txt maps to
#   src/Systems/<path>.lean present in ComplianceCorpus. Missing corpus file
#   or missing membership ⇒ FAIL (no silent skip). Separately, PRODUCT modules that
#   contain Lean `axiom` decls must have allowlist coverage (path-only or name= pins).
#
# Usage (lean4 root):
#   ./script/systems-product-stdlib-check.sh
#   SYSTEMS_LEAN_PRODUCT_IR_ROOT=path/to/ir ./script/systems-product-stdlib-check.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
MANIFEST="${SYSTEMS_LEAN_PRODUCT_STDLIB_MANIFEST:-$ROOT/script/systems-product-stdlib-modules.txt}"
IR_ROOT="${SYSTEMS_LEAN_PRODUCT_IR_ROOT:-$ROOT/tests/lake/examples/systems/lib/.lake/build/ir}"
LAKEFILE="${SYSTEMS_LEAN_PRODUCT_LAKEFILE:-$ROOT/tests/lake/examples/systems/lib/lakefile.lean}"
# Optional in-tree freestanding Systems package roots (CMake → build lakefile.toml).
SRC_LAKEFILE_IN="${SYSTEMS_LEAN_SRC_LAKEFILE_IN:-$ROOT/src/lakefile.toml.in}"
CORPUS="${SYSTEMS_LEAN_COMPLIANCE_CORPUS:-$ROOT/script/systems-compliance-corpus.txt}"
ALLOWLIST="${SYSTEMS_LEAN_TCB_AXIOM_ALLOWLIST:-$ROOT/script/systems-tcb-axiom-allowlist.txt}"
# Optional *Lite basename exceptions (one basename per line). Empty/unset = zero exceptions (post-D21).
LITE_ALLOWLIST_FILE="${SYSTEMS_LEAN_PRODUCT_LITE_ALLOWLIST:-}"
SRC_FS="$ROOT/src/Systems"
# shellcheck source=systems-axiom-lib.sh
source "$ROOT/script/systems-axiom-lib.sh"

# Fashion thesaurus words (Track L / B1 heap clones). Conservative; not BinaryHeap.
# shellcheck disable=SC2034  # used in [[ =~ ]] patterns below
SYSTEMS_LEAN_PRODUCT_FASHION_WORDS='Yarn|Cable|Weave|Plait|Braid|Twine|Rope|Skein|Coil|Strand|Thread|Cord|Fiber|Fibre|Fleece|Spool|Hank|Ply'

fail() {
  echo "FAIL: $*" >&2
  echo "PRODUCT_STDLIB_MODULES_OK=0"
  echo "PRODUCT_CORPUS_ALIGN_OK=0"
  echo "PRODUCT_NAMING_GATE_OK=0"
  exit 1
}

if [[ ! -f "$MANIFEST" ]]; then
  fail "missing PRODUCT_STDLIB_MODULES manifest: $MANIFEST"
fi

# Load modules (no comments/blanks).
mapfile -t MODULES < <(grep -vE '^\s*(#|$)' "$MANIFEST" | sed 's/[[:space:]]*$//' | sed '/^$/d')
if [[ "${#MODULES[@]}" -eq 0 ]]; then
  fail "manifest has no modules: $MANIFEST"
fi

# shellcheck source=systems-residual-policy.sh
source "$ROOT/script/systems-residual-policy.sh"

bad=0
naming_bad=0
declare -A seen=()
declare -A LITE_ALLOW=()

# Optional shrinking *Lite allowlist (post-D21: empty = zero exceptions).
if [[ -n "$LITE_ALLOWLIST_FILE" ]]; then
  if [[ ! -f "$LITE_ALLOWLIST_FILE" ]]; then
    fail "missing PRODUCT *Lite allowlist: $LITE_ALLOWLIST_FILE"
  fi
  while IFS= read -r line || [[ -n "$line" ]]; do
    [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue
    line="${line#"${line%%[![:space:]]*}"}"
    line="${line%"${line##*[![:space:]]}"}"
    [[ -z "$line" ]] && continue
    LITE_ALLOW["$line"]=1
  done <"$LITE_ALLOWLIST_FILE"
fi

# Phase E: fail-closed forbidden PRODUCT basename patterns (runs early; before source existence).
# Basename = last path segment of manifest entry. Does not ban BinaryHeap / V5ua / legitimate names.
systems_lean_product_naming_check() {
  local m="$1"
  local base="${m##*/}"
  local fashion="$SYSTEMS_LEAN_PRODUCT_FASHION_WORDS"

  # *Lite suffix (case-sensitive). Optional empty allowlist for legacy exceptions.
  if [[ "$base" == *Lite ]]; then
    if [[ -z "${LITE_ALLOW[$base]:-}" ]]; then
      echo "FAIL: forbidden PRODUCT name pattern (*Lite): $m" >&2
      return 1
    fi
  fi

  # Pure V-series number toys (V1, V45). Not V5ua / Vorbis / Vector.
  if [[ "$base" =~ ^V[0-9]+$ ]]; then
    echo "FAIL: forbidden PRODUCT name pattern (pure V[0-9]+): $m" >&2
    return 1
  fi

  # Pure G7*Nb magic annex toys (G707Nb, G729aNb). Not real multi-field codecs.
  if [[ "$base" =~ ^G7[0-9]+Nb$ ]] || [[ "$base" =~ ^G7[0-9]+[a-zA-Z]+Nb$ ]]; then
    echo "FAIL: forbidden PRODUCT name pattern (pure G7*Nb): $m" >&2
    return 1
  fi

  # Thesaurus fashion heap / bare fashion product basenames (B1). Not BinaryHeap.
  # HeapSet = ordered-leaf set synonym deleted in Phase C.
  if [[ "$base" =~ ^($fashion)Heap$ ]] \
    || [[ "$base" =~ ^($fashion)$ ]] \
    || [[ "$base" == "HeapSet" ]]; then
    echo "FAIL: forbidden PRODUCT name pattern (thesaurus fashion/heap): $m" >&2
    return 1
  fi

  return 0
}

echo "=== PRODUCT_STDLIB_MODULES check ==="
echo "manifest: $MANIFEST"
echo "modules:  ${#MODULES[@]}"
if [[ ${#LITE_ALLOW[@]} -gt 0 ]]; then
  echo "lite allowlist exceptions: ${#LITE_ALLOW[@]}"
else
  echo "lite allowlist exceptions: 0 (empty; post-D21 zero *Lite)"
fi

for m in "${MODULES[@]}"; do
  if [[ -n "${seen[$m]:-}" ]]; then
    echo "FAIL: duplicate module in manifest: $m" >&2
    bad=1
    continue
  fi
  seen["$m"]=1

  # Naming patterns first so fixture manifests fail closed without a real source file.
  if ! systems_lean_product_naming_check "$m"; then
    bad=1
    naming_bad=1
    # Still scan source/lake when present, but do not skip remaining checks for this entry.
  else
    echo "OK naming: $m"
  fi

  lean_src="$SRC_FS/${m}.lean"
  if [[ ! -f "$lean_src" ]]; then
    echo "FAIL: missing freestanding source $lean_src" >&2
    bad=1
  else
    echo "OK source: Systems/${m}.lean"
  fi

  # Lean root name Systems.Parallelism.Simd for Parallelism/Simd
  lean_name="Systems.${m//\//.}"
  if [[ -f "$LAKEFILE" ]]; then
    if command -v rg >/dev/null 2>&1; then
      if ! rg -q --fixed-strings "\`${lean_name}" "$LAKEFILE" && ! rg -q --fixed-strings "$lean_name" "$LAKEFILE"; then
        echo "FAIL: lakefile missing root $lean_name ($LAKEFILE)" >&2
        bad=1
      else
        echo "OK lake:  $lean_name"
      fi
    else
      if ! grep -qF "$lean_name" "$LAKEFILE"; then
        echo "FAIL: lakefile missing root $lean_name ($LAKEFILE)" >&2
        bad=1
      else
        echo "OK lake:  $lean_name"
      fi
    fi
  else
    echo "NOTE: lakefile not found ($LAKEFILE); skip lake root check"
  fi

  # Fail-closed: src/lakefile.toml.in freestanding Systems roots (hand-maintained; CMake SSoT input).
  if [[ -f "$SRC_LAKEFILE_IN" ]]; then
    if ! grep -qF "\"$lean_name\"" "$SRC_LAKEFILE_IN"; then
      echo "FAIL: src lakefile.toml.in missing root $lean_name ($SRC_LAKEFILE_IN)" >&2
      bad=1
    else
      echo "OK src-lake: $lean_name"
    fi
  fi

  if [[ -d "$IR_ROOT/Systems" ]]; then
    irf="$IR_ROOT/Systems/${m}.c"
    if [[ ! -f "$irf" ]]; then
      echo "FAIL: missing product IR $irf" >&2
      bad=1
    else
      if systems_lean_ir_file_has_residual "$irf"; then
        echo "FAIL: residual markers in product IR $irf" >&2
        bad=1
      else
        echo "OK ir:    Systems/${m}.c"
      fi
    fi
  fi
done

# Residual-policy array must match manifest (single source of truth).
if ! systems_lean_require_product_fs_modules; then
  echo "FAIL: residual-policy product module load empty/failed" >&2
  bad=1
fi
policy_list=("${SYSTEMS_LEAN_PRODUCT_FS_MODULES[@]}")
if [[ "${#policy_list[@]}" -ne "${#MODULES[@]}" ]]; then
  echo "FAIL: residual-policy module count ${#policy_list[@]} != manifest ${#MODULES[@]}" >&2
  echo "  policy: ${policy_list[*]}" >&2
  echo "  manifest: ${MODULES[*]}" >&2
  bad=1
else
  for i in "${!MODULES[@]}"; do
    if [[ "${MODULES[$i]}" != "${policy_list[$i]}" ]]; then
      echo "FAIL: residual-policy mismatch at index $i: manifest=${MODULES[$i]} policy=${policy_list[$i]}" >&2
      bad=1
    fi
  done
  if [[ "$bad" -eq 0 ]]; then
    echo "OK policy: SYSTEMS_LEAN_PRODUCT_FS_MODULES matches manifest"
  fi
fi

# B2: ComplianceCorpus must cover every PRODUCT_STDLIB module (fail-closed).
corpus_align_ok=1
if [[ ! -f "$CORPUS" ]]; then
  echo "FAIL: missing ComplianceCorpus list $CORPUS (PRODUCT ↔ corpus alignment)" >&2
  bad=1
  corpus_align_ok=0
else
  for m in "${MODULES[@]}"; do
    corp_path="src/Systems/${m}.lean"
    # Avoid `grep -q` in a pipeline under `pipefail`: early exit SIGPIPEs the
    # producer and can false-fail even when the line is present.
    if ! grep -vE '^\s*(#|$)' "$CORPUS" | grep -xF -- "$corp_path" >/dev/null; then
      echo "FAIL: PRODUCT_STDLIB module missing from ComplianceCorpus: $corp_path" >&2
      bad=1
      corpus_align_ok=0
    else
      echo "OK corpus: $corp_path"
    fi
  done
fi

# B2: PRODUCT modules with Lean `axiom` decls need allowlist coverage (path or name=).
# Same grammar as systems-axiom-check.sh; dual path-only + name= for one path rejected.
# Parser SSoT: systems-axiom-lib.sh.
declare -A PROD_ALLOW_PATH=()
declare -A PROD_ALLOW_NAME=()  # key: "path"$'\t'"name"
declare -A PROD_ALLOW_NAME_PATHS=()
if [[ ! -f "$ALLOWLIST" ]]; then
  echo "FAIL: missing TCB axiom allowlist $ALLOWLIST (PRODUCT axiom coverage)" >&2
  bad=1
else
  while IFS= read -r line || [[ -n "$line" ]]; do
    [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue
    line="${line#"${line%%[![:space:]]*}"}"
    line="${line%"${line##*[![:space:]]}"}"
    [[ -z "$line" ]] && continue
    if [[ "$line" =~ ^([^[:space:]]+)[[:space:]]+name=([^[:space:]]+)$ ]]; then
      PROD_ALLOW_NAME["${BASH_REMATCH[1]}"$'\t'"${BASH_REMATCH[2]}"]=1
      PROD_ALLOW_NAME_PATHS["${BASH_REMATCH[1]}"]=1
    elif [[ "$line" =~ [[:space:]] ]]; then
      echo "FAIL: bad allowlist entry (expected 'path' or 'path name=Ident'): $line" >&2
      bad=1
    else
      PROD_ALLOW_PATH["$line"]=1
    fi
  done <"$ALLOWLIST"
  for p in "${!PROD_ALLOW_NAME_PATHS[@]}"; do
    if [[ -n "${PROD_ALLOW_PATH[$p]:-}" ]]; then
      echo "FAIL: dual allowlist entry for $p (path-only + name=); remove one mode" >&2
      bad=1
    fi
  done
fi

# For each PRODUCT source with axiom decls: path-only OR every name pinned.
for m in "${MODULES[@]}"; do
  lean_src="$SRC_FS/${m}.lean"
  [[ -f "$lean_src" ]] || continue
  corp_path="src/Systems/${m}.lean"
  set +e
  hits="$(grep -nE "$SYSTEMS_LEAN_AXIOM_LINE_RE" "$lean_src" 2>/dev/null)"
  grc=$?
  set -e
  if [[ "$grc" -ne 0 && "$grc" -ne 1 ]]; then
    echo "FAIL: grep scan failed for $corp_path (PRODUCT axiom coverage)" >&2
    bad=1
    continue
  fi
  [[ "$grc" -eq 1 || -z "${hits:-}" ]] && continue

  axiom_names=()
  while IFS= read -r hit || [[ -n "${hit:-}" ]]; do
    [[ -z "${hit:-}" ]] && continue
    content="${hit#*:}"
    if [[ "$content" =~ ^[[:space:]]*-- ]]; then
      continue
    fi
    if ! systems_lean_is_axiom_decl_line "$content"; then
      continue
    fi
    name="$(systems_lean_extract_axiom_name "$content")"
    axiom_names+=("$name")
  done <<<"$hits"

  if [[ "${#axiom_names[@]}" -eq 0 ]]; then
    continue
  fi

  # Path-only INTENTIONAL_TCB_PATH_ALLOW covers all axioms in the file.
  if [[ -n "${PROD_ALLOW_PATH[$corp_path]:-}" ]]; then
    echo "OK allowlist path: $corp_path (${#axiom_names[@]} axiom(s); INTENTIONAL_TCB_PATH_ALLOW)"
    continue
  fi

  # Otherwise every axiom name must be name-pinned.
  uncovered=0
  for name in "${axiom_names[@]}"; do
    if [[ -z "$name" ]]; then
      echo "FAIL: PRODUCT module $corp_path has unparsed axiom name (cannot verify allowlist)" >&2
      uncovered=1
      continue
    fi
    if [[ -z "${PROD_ALLOW_NAME[$corp_path$'\t'$name]:-}" ]]; then
      echo "FAIL: PRODUCT axiom missing allowlist coverage: $corp_path name=$name" >&2
      uncovered=1
    fi
  done
  if [[ "$uncovered" -ne 0 ]]; then
    bad=1
  else
    echo "OK allowlist names: $corp_path (${#axiom_names[@]} name pin(s))"
  fi
done

# Extract always required when IR tree present.
if [[ -d "$IR_ROOT" ]]; then
  if [[ ! -f "$IR_ROOT/Extract.c" ]]; then
    echo "FAIL: missing product Extract.c under $IR_ROOT" >&2
    bad=1
  else
    echo "OK extract: Extract.c"
  fi
fi

if [[ "$bad" -ne 0 ]]; then
  echo "PRODUCT_STDLIB_MODULES_OK=0"
  if [[ "$corpus_align_ok" -eq 1 ]]; then
    echo "PRODUCT_CORPUS_ALIGN_OK=1"
  else
    echo "PRODUCT_CORPUS_ALIGN_OK=0"
  fi
  if [[ "$naming_bad" -eq 0 ]]; then
    echo "PRODUCT_NAMING_GATE_OK=1"
  else
    echo "PRODUCT_NAMING_GATE_OK=0"
  fi
  echo "PRODUCT_STDLIB_MODULES_COUNT=${#MODULES[@]}"
  exit 1
fi

echo "PRODUCT_STDLIB_MODULES_OK=1"
echo "PRODUCT_CORPUS_ALIGN_OK=1"
echo "PRODUCT_NAMING_GATE_OK=1"
echo "PRODUCT_STDLIB_MODULES_COUNT=${#MODULES[@]}"
# Space-separated for easy rg/cut
echo "PRODUCT_STDLIB_MODULES_LIST=${MODULES[*]}"
exit 0
