#!/usr/bin/env bash
# Systems Lean R7 — machine-generated Init/Std/(Lean) freestanding inventory.
#
# Walks src/Init, src/Std, optionally src/Lean and src/Systems; classifies each
# module into status buckets (fs-ready / fs-planned / dual-host / host-only).
#
# Usage (from lean4 root):
#   ./script/systems-stdlib-inventory.sh
#   ./script/systems-stdlib-inventory.sh --write   # refresh inventory doc section
#   ./script/systems-stdlib-inventory.sh --lean    # include Lean library modules
#   ./script/systems-stdlib-inventory.sh --require # fail if live fs count ≠ doc fs-ready
#   ./script/systems-stdlib-inventory.sh --write --require  # refresh then drift-check
#
# Fail-closed: missing src tree / missing python3 (for --write) → exit ≠ 0.
# Classic Init/Std/Lean sources are not modified.
#
# Classification is **name-prefix heuristic planning labels**, not a machine-checked
# freestanding proof. Renames can change buckets; import-graph analysis is not done here.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

WRITE=0
INCLUDE_LEAN=0
REQUIRE=0
OUT_DOC="$ROOT/doc/dev/systems-lean-stdlib-inventory.md"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --write) WRITE=1; shift ;;
    --lean) INCLUDE_LEAN=1; shift ;;
    --require) REQUIRE=1; shift ;;
    --out)
      OUT_DOC="${2:?--out needs path}"
      WRITE=1
      shift 2
      ;;
    -h|--help)
      cat <<'EOF'
systems-stdlib-inventory.sh — classify Init/Std/(Lean) for Systems Lean R7

  (default)   print markdown inventory to stdout
  --write     update doc/dev/systems-lean-stdlib-inventory.md generated section
  --lean      include src/Lean modules (large)
  --out PATH  write/update PATH (generated section replace when markers exist)
  --require   fail closed if live Systems .lean count ≠ inventory doc fs-ready
              (and ≠ this run's fs-ready). Safe with --write (checks after write).
  --help      this help

Buckets are heuristic planning labels (module-name prefixes), not freestanding proofs.
--write requires python3 on PATH.
EOF
      exit 0
      ;;
    *)
      echo "error: unknown argument: $1 (try --help)" >&2
      exit 1
      ;;
  esac
done

for d in src/Init src/Std src/Systems; do
  if [[ ! -d "$ROOT/$d" ]]; then
    echo "FAIL: missing $ROOT/$d" >&2
    exit 1
  fi
done

if [[ "$WRITE" -eq 1 ]]; then
  if ! command -v python3 >/dev/null 2>&1; then
    echo "FAIL: python3 required for --write (not found on PATH)" >&2
    echo "hint: nix develop .#systems includes python3, or install python3; omit --write to print inventory to stdout" >&2
    exit 1
  fi
fi

if [[ "$INCLUDE_LEAN" -eq 1 && ! -d "$ROOT/src/Lean" ]]; then
  echo "FAIL: --lean requested but missing $ROOT/src/Lean" >&2
  exit 1
fi

# Classify a Lean module name (dotted) into a status bucket.
classify_module() {
  local mod="$1"
  case "$mod" in
    Systems|Systems.*)
      echo fs-ready
      return
      ;;
  esac
  case "$mod" in
    Init.Tactic*|Init.Tactics*|Init.Meta*|Init.MetaTypes*|Init.Conv*|Init.Grind*|Init.GrindInstances*|\
Init.Simp*|Init.Simproc*|Init.CbvSimproc*|Init.RCases*|Init.ByCases*|Init.MacroTrace*|\
Init.Guard*|Init.Hints*|Init.Notation*|Init.Ext*|Init.ShareCommon*|Init.MethodSpecsSimp*|\
Init.LawfulBEqTactics*|Init.Omega*|Init.Sym*|Init.Classical*|Init.PropLemmas*|\
Init.Task|Init.Task.*|Init.System|Init.System.*|\
Std.Tactic*|Std.Async*|Std.Http*|Std.Net*|Std.Sync*|Std.Do*|Std.Time*|Std.Internal*|\
Lean.Elab*|Lean.Meta*|Lean.Server*|Lean.Widget*|Lean.Data.Lsp*|Lean.PrettyPrinter*|\
Lean.Parser*|Lean.Tactic*)
      echo host-only
      return
      ;;
  esac
  case "$mod" in
    Init.Data.UInt*|Init.Data.SInt*|Init.Data.BitVec*|Init.Data.ByteArray*|\
Init.Data.Bool*|Init.Data.UInt|Init.Data.BitVec|Init.Data.ByteArray|\
Std.Data.HashMap*|Std.Data.HashSet*|Std.Data.TreeMap*|Std.Data.TreeSet*|\
Std.Data.DHashMap*|Std.Data.DTreeMap*|Std.Data.ExtHashMap*|Std.Data.ExtHashSet*|\
Std.Data.ExtTreeMap*|Std.Data.ExtTreeSet*|Std.Data.ExtDHashMap*|Std.Data.ExtDTreeMap*|\
Std.Data.Internal*|Std.Data.String*|Std.Data.Iterators*|Std.Data|\
Std.Sat*)
      echo fs-planned
      return
      ;;
  esac
  echo dual-host
}

mapfile -t FS_FILES < <(find "$ROOT/src/Systems" -name '*.lean' | sort)
mapfile -t INIT_FILES < <(find "$ROOT/src/Init" -name '*.lean' | sort)
mapfile -t STD_FILES < <(find "$ROOT/src/Std" -name '*.lean' | sort)
LEAN_FILES=()
if [[ "$INCLUDE_LEAN" -eq 1 ]]; then
  mapfile -t LEAN_FILES < <(find "$ROOT/src/Lean" -name '*.lean' | sort)
fi

path_to_mod() {
  local p="$1"
  p="${p#"$ROOT/src/"}"
  p="${p%.lean}"
  echo "${p//\//.}"
}

declare -a MODS=()
declare -a STATUSES=()

add_file() {
  local f="$1"
  local mod status
  mod="$(path_to_mod "$f")"
  status="$(classify_module "$mod")"
  MODS+=("$mod")
  STATUSES+=("$status")
}

for f in "${FS_FILES[@]}"; do add_file "$f"; done
for f in "${INIT_FILES[@]}"; do add_file "$f"; done
for f in "${STD_FILES[@]}"; do add_file "$f"; done
for f in "${LEAN_FILES[@]+"${LEAN_FILES[@]}"}"; do add_file "$f"; done

n_fs=${#FS_FILES[@]}
n_init=${#INIT_FILES[@]}
n_std=${#STD_FILES[@]}
n_lean=${#LEAN_FILES[@]}
n_total=$((n_fs + n_init + n_std + n_lean))

n_ready=0 n_planned=0 n_dual=0 n_host=0
for s in "${STATUSES[@]}"; do
  case "$s" in
    fs-ready) n_ready=$((n_ready + 1)) ;;
    fs-planned) n_planned=$((n_planned + 1)) ;;
    dual-host) n_dual=$((n_dual + 1)) ;;
    host-only) n_host=$((n_host + 1)) ;;
  esac
done

declare -A CAT_READY=() CAT_PLANNED=() CAT_DUAL=() CAT_HOST=()
for i in "${!MODS[@]}"; do
  mod="${MODS[$i]}"
  st="${STATUSES[$i]}"
  cat="$mod"
  if [[ "$mod" != Systems.* && "$mod" =~ ^([^.]+)\.([^.]+) ]]; then
    cat="${BASH_REMATCH[1]}.${BASH_REMATCH[2]}"
  fi
  case "$st" in
    fs-ready) CAT_READY["$cat"]=1 ;;
    fs-planned) CAT_PLANNED["$cat"]=1 ;;
    dual-host) CAT_DUAL["$cat"]=1 ;;
    host-only) CAT_HOST["$cat"]=1 ;;
  esac
done

now="$(date -u +%Y-%m-%dT%H:%MZ 2>/dev/null || date -u)"
TMP_REPORT="$(mktemp)"
{
  cat <<EOF
<!-- GENERATED-BY script/systems-stdlib-inventory.sh — do not hand-edit this section -->
## Generated inventory (scripted)

Generated: \`$now\`
Command: \`./script/systems-stdlib-inventory.sh\`
Include Lean library: \`$INCLUDE_LEAN\`

**Heuristic honesty:** buckets below are **name-prefix planning labels** (not import-graph
analysis and not machine-checked freestanding proofs). e.g. \`Init.Data.List\` may be
\`dual-host\` while UInt/BitVec/HashMap roots are \`fs-planned\`; renames can change buckets.
Only \`fs-ready\` lists real \`src/Systems/*.lean\` modules.

### Counts

| Bucket | Meaning | Count |
|--------|---------|------:|
| \`fs-ready\` | Exists as freestanding module under \`src/Systems/\` | $n_ready |
| \`fs-planned\` | Heuristic: product-critical name prefixes (port candidates) | $n_planned |
| \`dual-host\` | Heuristic: host proofs/tools; not flagged as product hot path | $n_dual |
| \`host-only\` | Heuristic: tactics / meta / IO / async-style prefixes | $n_host |
| **Total scanned** | | **$n_total** |

### Tree sizes

| Layer | \`.lean\` files |
|-------|---------------:|
| Systems | $n_fs |
| Init | $n_init |
| Std | $n_std |
| Lean (optional) | $n_lean |

### \`fs-ready\` modules (Systems product surface)

EOF
  for i in "${!MODS[@]}"; do
    if [[ "${STATUSES[$i]}" == "fs-ready" ]]; then
      echo "- \`${MODS[$i]}\`"
    fi
  done

  cat <<'EOF'

### Category roots by status

Categories are `Layer.Top` (or full `Systems.*` module names). Full per-file status
is reproducible by re-running this script; the lists below are the **roots** used for
planning (not a hand-waved count-only inventory).

#### fs-planned roots (product port backlog)

EOF
  if [[ ${#CAT_PLANNED[@]} -eq 0 ]]; then
    echo "- _(none)_"
  else
    printf '%s\n' "${!CAT_PLANNED[@]}" | sort | while read -r c; do
      echo "- \`$c\`"
    done
  fi

  cat <<'EOF'

#### host-only roots (stay classic)

EOF
  if [[ ${#CAT_HOST[@]} -eq 0 ]]; then
    echo "- _(none)_"
  else
    printf '%s\n' "${!CAT_HOST[@]}" | sort | while read -r c; do
      echo "- \`$c\`"
    done
  fi

  cat <<'EOF'

#### dual-host roots (host proofs/tools; not embed hot path)

EOF
  n_dual_cat=${#CAT_DUAL[@]}
  if [[ "$n_dual_cat" -eq 0 ]]; then
    echo "- _(none)_"
  else
    printf '%s\n' "${!CAT_DUAL[@]}" | sort | head -n 80 | while read -r c; do
      echo "- \`$c\`"
    done
    if [[ "$n_dual_cat" -gt 80 ]]; then
      echo "- … ($((n_dual_cat - 80)) more dual-host category roots; re-run script for full list)"
    fi
  fi

  cat <<'EOF'

### Dual-path rules (product vs host)

| Path | Modules | Runtime |
|------|---------|---------|
| **Product extract** | `Systems.*` only (`compiler.freestanding=true`) | No GC / no `lean_object` on the link line |
| **Host proofs/tools** | Classic `Init` / `Std` / `Lean` | Full stage1 + `libleanshared` |

Promotion: `host-only` or `dual-host` → `fs-planned` (product need) → implement under
`src/Systems/` → `fs-ready`. Classic `src/Init` / `src/Std` remain **unchanged**
and classic-default.

<!-- END GENERATED inventory -->
EOF
} >"$TMP_REPORT"

if [[ "$WRITE" -eq 1 ]]; then
  if [[ ! -f "$OUT_DOC" ]]; then
    echo "FAIL: inventory doc missing: $OUT_DOC" >&2
    rm -f "$TMP_REPORT"
    exit 1
  fi
  python3 - "$OUT_DOC" "$TMP_REPORT" <<'PY'
import sys
from pathlib import Path
path = Path(sys.argv[1])
report = Path(sys.argv[2]).read_text(encoding="utf-8")
if not report.endswith("\n"):
    report += "\n"
text = path.read_text(encoding="utf-8")
start = "<!-- GENERATED-BY script/systems-stdlib-inventory.sh"
end = "<!-- END GENERATED inventory -->"
if start in text and end in text:
    i = text.index(start)
    j = text.index(end) + len(end)
    if j < len(text) and text[j] == "\n":
        j += 1
    path.write_text(text[:i] + report + text[j:], encoding="utf-8")
else:
    if not text.endswith("\n"):
        text += "\n"
    path.write_text(text + "\n" + report, encoding="utf-8")
print(f"OK: wrote generated inventory into {path}")
PY
  echo "OK: inventory updated → $OUT_DOC"
else
  cat "$TMP_REPORT"
fi

rm -f "$TMP_REPORT"

# Live Systems file count is the SSoT for fs-ready (classify maps Systems.* → fs-ready).
if [[ "$n_fs" -ne "$n_ready" ]]; then
  echo "FAIL: freestanding disk count ($n_fs) ≠ classified fs-ready ($n_ready)" >&2
  exit 1
fi

if [[ "$REQUIRE" -eq 1 ]]; then
  # Drift: documented generated inventory fs-ready must match live freestanding count.
  if ! command -v python3 >/dev/null 2>&1; then
    echo "FAIL: --require needs python3 on PATH (nix develop .#systems includes python3)" >&2
    exit 1
  fi
  if [[ ! -f "$OUT_DOC" ]]; then
    echo "FAIL: --require needs inventory doc: $OUT_DOC" >&2
    exit 1
  fi
  doc_ready="$(python3 - "$OUT_DOC" <<'PY'
import re, sys
from pathlib import Path
text = Path(sys.argv[1]).read_text(encoding="utf-8")
start = "<!-- GENERATED-BY script/systems-stdlib-inventory.sh"
end = "<!-- END GENERATED inventory -->"
if start not in text or end not in text:
    print("MISSING", end="")
    raise SystemExit(0)
section = text[text.index(start):text.index(end)]
# Prefer the Counts table row for fs-ready.
m = re.search(r"`fs-ready`[^|]*\|\s*(\d+)\s*\|", section)
if not m:
    m = re.search(r"\|\s*`fs-ready`\s*\|[^|]*\|\s*(\d+)\s*\|", section)
if not m:
    # Fallback: Systems tree size row.
    m = re.search(r"\|\s*Systems\s*\|\s*(\d+)\s*\|", section)
print(m.group(1) if m else "MISSING", end="")
PY
)"
  if [[ "$doc_ready" == "MISSING" || -z "$doc_ready" ]]; then
    echo "FAIL: --require could not parse fs-ready count from $OUT_DOC" >&2
    echo "hint: run ./script/systems-stdlib-inventory.sh --write first" >&2
    exit 1
  fi
  if [[ "$doc_ready" != "$n_ready" ]]; then
    echo "FAIL: inventory doc fs-ready=$doc_ready drifts from live fs-ready=$n_ready (disk Systems=$n_fs)" >&2
    echo "hint: ./script/systems-stdlib-inventory.sh --write" >&2
    exit 1
  fi
  # Cheap PRODUCT_STDLIB length check (manifest lines == fs-ready when product = full FS surface).
  # Fail-closed: missing or empty PRODUCT under --require is not OK.
  PRODUCT_MANIFEST="${SYSTEMS_LEAN_PRODUCT_STDLIB_MANIFEST:-$ROOT/script/systems-product-stdlib-modules.txt}"
  if [[ ! -f "$PRODUCT_MANIFEST" ]]; then
    echo "FAIL: --require needs PRODUCT_STDLIB manifest: $PRODUCT_MANIFEST" >&2
    exit 1
  fi
  # grep exit 1 on zero matches must not abort under pipefail before we emit FAIL.
  product_n="$(grep -vE '^(#|[[:space:]]*$)' "$PRODUCT_MANIFEST" 2>/dev/null | wc -l | tr -d ' ' || true)"
  product_n="${product_n:-0}"
  if [[ "$product_n" -eq 0 ]]; then
    echo "FAIL: PRODUCT_STDLIB manifest empty (comment-only or blank): $PRODUCT_MANIFEST" >&2
    exit 1
  fi
  if [[ "$product_n" != "$n_ready" ]]; then
    echo "FAIL: PRODUCT_STDLIB count=$product_n drifts from live fs-ready=$n_ready" >&2
    echo "hint: grow/shrink script/systems-product-stdlib-modules.txt with Systems ports" >&2
    exit 1
  fi
  echo "OK: inventory drift check (fs-ready=$n_ready PRODUCT_STDLIB=$product_n doc=$doc_ready)" >&2
fi

echo "OK: systems-stdlib inventory ($n_total modules; fs-ready=$n_ready fs-planned=$n_planned dual-host=$n_dual host-only=$n_host)" >&2
exit 0
