#!/usr/bin/env bash
# Systems Lean Track D: QTT UseCheck depth + freestanding bif* splitter completeness.
#
# Verifies **source artifacts** (not log-only markers, not full elaborator completeness):
#   * UseCheck visitBranching same pure-fvar exclusive consume + distinct pure-fvar path merge
#   * Real same-fvar equality guard (`· == f0` / `== f0`) — vacuous `all (fun _ => true)` FAILS
#   * Every freestanding `def bif*` (comment+string stripped inventory) ⊆ splitterLayout? allowlist
#   * Fail-closed against exclusive pureFvars iterate-consume (for / forM / mapM / foldl / foldlM)
#   * Bif allowlist requires Name.str match arms (`.str _ "bifX"`), not mere quoted strings
#
# Greps run on comment-stripped code; structural/identifier greps also strip string literals
# (G2 style) so hollow marker soup cannot mint success tokens. Bif allowlist strings and
# consume path messages are matched on comment-stripped text with strings kept (real code form).
#
# Success tokens (stdout, exact-line; only after all checks pass):
#   QTT_USECHECK_DISTINCT_PURE_FVAR=1
#   QTT_SPLITTER_BIF_COMPLETE=1
#   QTT_DEPTH_OK=1
# Failure: exit ≠ 0, all tokens =0, FAIL: lines on stderr.
#
# Product paths (default / validate):
#   Always pin $ROOT/src/Lean/Compiler/QTT/UseCheck.lean and $ROOT/src/Systems
#   Ambient SYSTEMS_LEAN_QTT_DEPTH_{USECHECK,FREESTANDING} ignored unless
#   SYSTEMS_LEAN_QTT_DEPTH_ALLOW_OVERRIDE=1 (negatives / disposable trees).
#
# Honesty: residual surface hardening greps — **not** full elaborator completeness,
# **not** Mult algebra tables, **not** GC_FREE_ELABORATOR=1.
#
# Usage (lean4 root):
#   ./script/systems-qtt-depth-check.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

PRODUCT_USECHECK="$ROOT/src/Lean/Compiler/QTT/UseCheck.lean"
PRODUCT_FS_ROOT="$ROOT/src/Systems"

abspath() {
  local p="$1"
  if command -v realpath >/dev/null 2>&1 && [[ -e "$p" ]]; then
    realpath "$p"
  elif [[ -e "$p" ]]; then
    (cd "$(dirname "$p")" && echo "$(pwd)/$(basename "$p")")
  else
    echo "$p"
  fi
}

PRODUCT_USECHECK="$(abspath "$PRODUCT_USECHECK")"
PRODUCT_FS_ROOT="$(abspath "$PRODUCT_FS_ROOT")"

ALLOW_OVERRIDE="${SYSTEMS_LEAN_QTT_DEPTH_ALLOW_OVERRIDE:-0}"
if [[ "$ALLOW_OVERRIDE" == "1" ]]; then
  USECHECK="$(abspath "${SYSTEMS_LEAN_QTT_DEPTH_USECHECK:-$PRODUCT_USECHECK}")"
  FS_ROOT="$(abspath "${SYSTEMS_LEAN_QTT_DEPTH_FREESTANDING:-$PRODUCT_FS_ROOT}")"
else
  if [[ -n "${SYSTEMS_LEAN_QTT_DEPTH_USECHECK:-}" \
     || -n "${SYSTEMS_LEAN_QTT_DEPTH_FREESTANDING:-}" ]]; then
    echo "NOTE: ignoring SYSTEMS_LEAN_QTT_DEPTH_* overrides (set SYSTEMS_LEAN_QTT_DEPTH_ALLOW_OVERRIDE=1 for disposable trees)" >&2
  fi
  USECHECK="$PRODUCT_USECHECK"
  FS_ROOT="$PRODUCT_FS_ROOT"
fi

ok_pure_fvar=0
ok_bif=0
status=0

fail_line() {
  printf 'FAIL: %s\n' "$*" >&2
  status=1
}

ok_line() {
  printf 'OK: %s\n' "$*" >&2
}

SNAP_DIR=""
cleanup_snap() {
  if [[ -n "${SNAP_DIR:-}" && -d "$SNAP_DIR" ]]; then
    rm -rf "$SNAP_DIR"
  fi
}
trap cleanup_snap EXIT

# Strip Lean block comments then line comments (comment-only forges → empty).
strip_lean_comments() {
  local src="$1"
  if command -v perl >/dev/null 2>&1; then
    perl -0777 -pe 's{/\-.*?\-/}{}sg; s/--[^\n]*//g' -- "$src"
  else
    sed -e 's|--.*||g' "$src" \
      | awk '
        BEGIN { inblk=0 }
        {
          line = $0
          out = ""
          while (length(line) > 0) {
            if (inblk) {
              if (match(line, /\-\//)) {
                line = substr(line, RSTART + RLENGTH)
                inblk = 0
              } else {
                line = ""
              }
            } else {
              if (match(line, /\/\-/)) {
                out = out substr(line, 1, RSTART - 1)
                line = substr(line, RSTART + 2)
                inblk = 1
              } else {
                out = out line
                line = ""
              }
            }
          }
          print out
        }
      '
  fi
}

# Strip double- and single-quoted string literals (best-effort) so marker soup cannot stand in.
strip_string_literals() {
  if command -v perl >/dev/null 2>&1; then
    perl -pe 's/"(?:\\.|[^"\\])*"/""/g; s/'\''(?:\\.|[^'\''\\])*'\''/'\'''\''/g'
  else
    sed -E 's/"([^"\\]|\\.)*"/""/g; s/'\''([^'\''\\]|\\.)*'\''/'\'''\''/g'
  fi
}

# Extract def/partial def/theorem region for NAME from a snapshot (code lines only).
extract_region() {
  local snap="$1" name="$2"
  [[ -f "$snap" ]] || return 1
  awk -v name="$name" '
    BEGIN { take=0 }
    {
      if (!take) {
        if ($0 ~ "(public[[:space:]]+|private[[:space:]]+|protected[[:space:]]+|partial[[:space:]]+)*(def|theorem|abbrev)[[:space:]]+" name "([^A-Za-z0-9_]|$)") {
          take=1
          print
          next
        }
      } else {
        if ($0 ~ /^(public[[:space:]]+|private[[:space:]]+|protected[[:space:]]+|partial[[:space:]]+)*(def|theorem|abbrev)[[:space:]]+/ \
            || $0 ~ /^end([[:space:]]|$)/ \
            || $0 ~ /^namespace[[:space:]]/ \
            || $0 ~ /^section[[:space:]]/ \
            || $0 ~ /^#/) {
          exit
        }
        print
      }
    }
  ' "$snap"
}

emit_tokens() {
  local all_ok=0
  if [[ "$status" -eq 0 && "$ok_pure_fvar" -eq 1 && "$ok_bif" -eq 1 ]]; then
    all_ok=1
  fi
  if [[ "$all_ok" -eq 1 ]]; then
    echo "QTT_USECHECK_DISTINCT_PURE_FVAR=1"
    echo "QTT_SPLITTER_BIF_COMPLETE=1"
    echo "QTT_DEPTH_OK=1"
  else
    echo "QTT_USECHECK_DISTINCT_PURE_FVAR=0"
    echo "QTT_SPLITTER_BIF_COMPLETE=0"
    echo "QTT_DEPTH_OK=0"
  fi
}

echo "=== Systems Lean QTT depth (UseCheck pure-fvar + bif* SSoT) ===" >&2
echo "usecheck: $USECHECK" >&2
echo "freestanding: $FS_ROOT" >&2
echo "allow_override: $ALLOW_OVERRIDE" >&2

if ! command -v grep >/dev/null 2>&1; then
  fail_line "grep not found on PATH (tool/layout)"
  emit_tokens
  exit 1
fi

if [[ ! -f "$USECHECK" ]]; then
  fail_line "missing UseCheck source: $USECHECK"
  emit_tokens
  exit 1
fi
if [[ ! -d "$FS_ROOT" ]]; then
  fail_line "missing Systems product root: $FS_ROOT"
  emit_tokens
  exit 1
fi

SNAP_DIR="$(mktemp -d)"
SNAP_UC="$SNAP_DIR/usecheck.code"
SNAP_UC_IDS="$SNAP_DIR/usecheck.ids"
strip_lean_comments "$USECHECK" >"$SNAP_UC"
if [[ ! -s "$SNAP_UC" ]]; then
  fail_line "UseCheck is empty after comment strip (comment-only forge)"
  emit_tokens
  exit 1
fi
strip_string_literals <"$SNAP_UC" >"$SNAP_UC_IDS"
if [[ ! -s "$SNAP_UC_IDS" ]]; then
  fail_line "UseCheck is empty after string strip (string-only hollow soup)"
  emit_tokens
  exit 1
fi

# ---------------------------------------------------------------------------
# 1) Distinct pure-fvar residual: structured visitBranching region (string-stripped)
# ---------------------------------------------------------------------------
pure_bad=0

VB_REGION="$(extract_region "$SNAP_UC" visitBranching || true)"
if [[ -z "${VB_REGION//[[:space:]]/}" ]]; then
  fail_line "missing def visitBranching region (code lines)"
  pure_bad=1
  VB_IDS=""
  VB_FLAT=""
  VB_FLAT_IDS=""
else
  VB_IDS="$(printf '%s\n' "$VB_REGION" | strip_string_literals)"
  VB_FLAT="$(printf '%s\n' "$VB_REGION" | tr '\n' ' ' | tr -s ' ')"
  VB_FLAT_IDS="$(printf '%s\n' "$VB_IDS" | tr '\n' ' ' | tr -s ' ')"
fi

if [[ "$pure_bad" -eq 0 ]]; then
  # pureFvars collection (identifiers, not string soup).
  if ! printf '%s\n' "$VB_IDS" | grep -qE 'pureFvars'; then
    fail_line "visitBranching missing pureFvars collection (code, not strings)"
    pure_bad=1
  fi

  # Real same-fvar equality guard — require · == f0 / == f0 form (vacuous all FAILS).
  # Issue 1: pureFvars.all alone is not enough; pureFvars.all (fun _ => true) must FAIL.
  if ! printf '%s\n' "$VB_IDS" | grep -qE 'pureFvars\.all[[:space:]]*\(·[[:space:]]*==[[:space:]]*f0\)' \
    && ! printf '%s\n' "$VB_IDS" | grep -qE 'pureFvars\.all[[:space:]]*\([^)]*==[[:space:]]*f0' \
    && ! printf '%s\n' "$VB_IDS" | grep -qE 'pureFvars\.all[[:space:]]+fun[[:space:]]+[^[:space:]]+[[:space:]]*=>[[:space:]]*[^[:space:]]+[[:space:]]*==[[:space:]]*f0'; then
    fail_line "visitBranching missing real pureFvars.all equality-to-f0 guard (· == f0 / == f0)"
    pure_bad=1
  fi

  # Vacuous all predicates are an explicit FAIL even if some other equality form exists.
  if printf '%s\n' "$VB_IDS" | grep -qE 'pureFvars\.all[[:space:]]*\([[:space:]]*fun[[:space:]]+_[[:space:]]*=>[[:space:]]*true[[:space:]]*\)' \
    || printf '%s\n' "$VB_IDS" | grep -qE 'pureFvars\.all[[:space:]]+fun[[:space:]]+_[[:space:]]*=>[[:space:]]*true' \
    || printf '%s\n' "$VB_IDS" | grep -qE 'pureFvars\.all[[:space:]]*\([[:space:]]*fun[[:space:]]*[^)]*=>[[:space:]]*true[[:space:]]*\)'; then
    fail_line "visitBranching has vacuous pureFvars.all (fun _ => true) (not a real same-fvar guard)"
    pure_bad=1
  fi

  # Same pure-fvar exclusive consume message (real string in comment-stripped source).
  if ! printf '%s\n' "$VB_REGION" | grep -qF 'same pure-fvar on every control-flow arm'; then
    fail_line "visitBranching missing same pure-fvar consume message (exclusive same-fvar path)"
    pure_bad=1
  fi
  # Consume must target f0 (same-fvar path), not a loop binder over pureFvars.
  if ! printf '%s\n' "$VB_IDS" | grep -qE 'consume[[:space:]]+s[[:space:]]+f0' \
    && ! printf '%s\n' "$VB_FLAT_IDS" | grep -qE 'consume[[:space:]]+s[[:space:]]+f0'; then
    fail_line "visitBranching missing consume s f0 on same pure-fvar path"
    pure_bad=1
  fi

  # Distinct pure-fvar arms must path-merge via mergeStates + visitRuntime on alts.
  if ! printf '%s\n' "$VB_IDS" | grep -qE 'mergeStates'; then
    fail_line "visitBranching missing mergeStates (distinct pure-fvar path merge)"
    pure_bad=1
  fi
  if ! printf '%s\n' "$VB_IDS" | grep -qE 'visitRuntime'; then
    fail_line "visitBranching missing visitRuntime on control-flow arms"
    pure_bad=1
  fi

  # File-level mergeStates def must exist (not only a string token).
  if ! grep -qE '(def|partial[[:space:]]+def)[[:space:]]+mergeStates' "$SNAP_UC_IDS" \
    && ! grep -qE 'mergeStates' "$SNAP_UC_IDS"; then
    fail_line "UseCheck missing mergeStates in code (string-stripped)"
    pure_bad=1
  fi

  # Exclusive pureFvars iterate/fold/sequential multi-consume ban — multi-distinct residual leak.
  # Covers pureFvars, transitive rename aliases (let arms := pureFvars; let xs := arms; xs.foldl…),
  # and collection-in-any-arg forms (Array.foldlM f s pureFvars).
  # Match on string-stripped flattened visitBranching + whole-file code.
  exclusive_hit=0
  exclusive_kind=""
  # Transitive pureFvars aliases: pureFvars ∪ { y | let/have y := x, x already alias } (fixpoint).
  collect_pf_aliases() {
    local hay="$1"
    local aliases="pureFvars"
    local pass nm line lhs
    # Up to 12 hops for multi-rename chains.
    for pass in 1 2 3 4 5 6 7 8 9 10 11 12; do
      local prev="$aliases"
      for nm in $aliases; do
        # Match: let NAME := nm  /  let mut NAME := nm  /  have NAME := nm
        # Use grep -o then bash-only parse (avoid fragile sed under set -e).
        while IFS= read -r line; do
          [[ -z "$line" ]] && continue
          # Strip leading let/have and trailing := nm
          lhs="${line#let }"
          lhs="${lhs#mut }"
          lhs="${lhs#have }"
          lhs="${lhs%%:=*}"
          lhs="${lhs// /}"
          lhs="${lhs//$'\t'/}"
          [[ -z "$lhs" || "$lhs" == "pureFvars" ]] && continue
          case " $aliases " in
            *" $lhs "*) ;;
            *) aliases="$aliases $lhs" ;;
          esac
        done < <(printf '%s' "$hay" | grep -oE 'let[[:space:]]+(mut[[:space:]]+)?[A-Za-z_][A-Za-z0-9_]*[[:space:]]*:=[[:space:]]*'"${nm}"'([^A-Za-z0-9_]|$)' \
          || printf '%s' "$hay" | grep -oE 'have[[:space:]]+[A-Za-z_][A-Za-z0-9_]*[[:space:]]*:=[[:space:]]*'"${nm}"'([^A-Za-z0-9_]|$)' \
          || true)
        # let NAME ← pure nm / let NAME ← nm
        while IFS= read -r line; do
          [[ -z "$line" ]] && continue
          lhs="${line#let }"
          lhs="${lhs%%←*}"
          lhs="${lhs// /}"
          [[ -z "$lhs" || "$lhs" == "pureFvars" ]] && continue
          case " $aliases " in
            *" $lhs "*) ;;
            *) aliases="$aliases $lhs" ;;
          esac
        done < <(printf '%s' "$hay" | grep -oE 'let[[:space:]]+[A-Za-z_][A-Za-z0-9_]*[[:space:]]*←[[:space:]]*(pure[[:space:]]+)?'"${nm}"'([^A-Za-z0-9_]|$)' || true)
      done
      [[ "$aliases" == "$prev" ]] && break
    done
    printf '%s' "$aliases"
  }
  # True if name is the iterated collection (any arg position) with consume in the same fold/iter window.
  name_exclusive_consume() {
    local hay="$1" name="$2"
    # Identifiers only (bash param expand — avoid sed delimiter issues).
    local nre="${name//[^A-Za-z0-9_]/}"
    [[ "$nre" =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]] || return 1
    # for x in name … consume
    if printf '%s' "$hay" | grep -qE 'for[[:space:]]+[^[:space:]]+[[:space:]]+in[[:space:]]+'"${nre}"'([^A-Za-z0-9_]|$).{0,200}consume'; then
      exclusive_kind="for ${name}"
      return 0
    fi
    # Method form: name.forM / name.mapM / name.foldlM / name.foldM / …
    if printf '%s' "$hay" | grep -qE "${nre}"'\.(forM|mapM|foldlM|foldl|foldrM|foldr|foldM).{0,280}consume'; then
      exclusive_kind="method-iter ${name}"
      return 0
    fi
    # Prefix form with name as first collection-ish arg: forM name / mapM name / foldlM name
    if printf '%s' "$hay" | grep -qE '(forM|mapM|foldlM|foldl|foldrM|foldr|foldM)[[:space:]]+'"${nre}"'([^A-Za-z0-9_]|$).{0,280}consume'; then
      exclusive_kind="prefix-iter ${name}"
      return 0
    fi
    # Collection in ANY argument position (e.g. Array.foldlM f s pureFvars):
    # combinator window contains both consume and name (either order).
    # Covers: Array.foldlM (fun s f => consume …) s pureFvars
    #         foldlM f init pureFvars with consume in f
    if printf '%s' "$hay" | grep -qE '(Array\.)?(foldlM|foldl|foldrM|foldr|foldM|forM|mapM)[[:space:]\.(]'; then
      if printf '%s' "$hay" | grep -qE '(Array\.)?(foldlM|foldl|foldrM|foldr|foldM|forM|mapM).{0,360}(consume.{0,360}([^A-Za-z0-9_]|^)'"${nre}"'([^A-Za-z0-9_]|$)|([^A-Za-z0-9_]|^)'"${nre}"'([^A-Za-z0-9_]|$).{0,360}consume)'; then
        # Avoid false positive when name only appears in unrelated far context: require
        # a tighter sub-window of 320 chars containing combinator, name, and consume.
        if printf '%s' "$hay" | grep -qE '(Array\.)?(foldlM|foldl|foldrM|foldr|foldM|forM|mapM).{0,320}'"${nre}"'.{0,320}consume' \
          || printf '%s' "$hay" | grep -qE '(Array\.)?(foldlM|foldl|foldrM|foldr|foldM|forM|mapM).{0,320}consume.{0,320}'"${nre}"; then
          exclusive_kind="any-arg fold/iter ${name}"
          return 0
        fi
      fi
    fi
    return 1
  }
  for hay in "$VB_FLAT_IDS" "$(tr '\n' ' ' <"$SNAP_UC_IDS" | tr -s ' ')"; do
    [[ -z "$hay" ]] && continue
    pf_aliases="$(collect_pf_aliases "$hay")"
    for nm in $pf_aliases; do
      if name_exclusive_consume "$hay" "$nm"; then
        exclusive_hit=1
      fi
    done
    # Sequential dual-consume of pureFvars elements (no loop): two consume of pureFvars[i] indices.
    if printf '%s' "$hay" | grep -qE 'consume[[:space:]]+s[[:space:]]+pureFvars(\[[0-9]+\]|\.get!|\.getD|\[[[:space:]]*0)' \
      && printf '%s' "$hay" | grep -qE 'consume[[:space:]]+s[[:space:]]+pureFvars(\[[0-9]+\]|\.get!|\.getD|\[[[:space:]]*1)'; then
      exclusive_hit=1
      exclusive_kind="sequential dual pureFvars consume"
    fi
    # Sequential dual consume of two different pure-fvar arm binders without merge (greppable).
    if printf '%s' "$hay" | grep -qE 'consume[[:space:]]+s[[:space:]]+[^f[:space:]][^[:space:]]*.{0,120}consume[[:space:]]+s[[:space:]]+[^f[:space:]]'; then
      if printf '%s' "$hay" | grep -qE 'pureFvars' \
        && ! printf '%s' "$hay" | grep -qE 'consume[[:space:]]+s[[:space:]]+f0'; then
        if printf '%s' "$hay" | grep -oE 'consume[[:space:]]+s[[:space:]]+[A-Za-z_][A-Za-z0-9_]*' \
          | grep -vE 'consume[[:space:]]+s[[:space:]]+f0' | sort -u | wc -l | grep -qE '^[2-9]'; then
          exclusive_hit=1
          exclusive_kind="sequential multi-consume of pure-fvar arms"
        fi
      fi
    fi
  done

  # Named-function call-arg / pipe ban (visitBranching region only, fail-closed):
  # Passing pureFvars (or a let-alias) as a non-method argument to a *named function* is an
  # exclusive-helper risk even when fold+consume live in a sibling def outside this region:
  #   exclusiveGo pureFvars s   -- FAIL (juxtaposition)
  #   pureFvars |> exclusiveGo s -- FAIL (pipe)
  # Allowed: Array field/method uses — pureFvars.size / .all / [0]? / .filterMap / |>.field / := bind.
  # Keywords (let pureFvars / if / match) are NOT call-args.
  is_call_arg_of() {
    local hay="$1" coll="$2"
    local line callee
    [[ "$coll" =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]] || return 1
    # Bare collection only: coll must NOT be followed by .field or [index] (method/property uses OK).
    # Trailing allowed: space, comma, ')', end — not '.' or '[' or alnum.
    local bare_after='([^A-Za-z0-9_.\[]|$)'
    while IFS= read -r line; do
      [[ -z "$line" ]] && continue
      callee="$(printf '%s' "$line" | awk '{print $1}')"
      case "$callee" in
        let|have|if|match|return|pure|do|else|then|where|for|fun|with|show|open|namespace|end|def|theorem|partial|private|public|protected|mut|some|none|true|false|not|and|or|in|at|by|from|deriving|structure|class|instance|inductive|abbrev|section|variable|example|set_option|import|export|prelude|module|consume|visitRuntime|mergeStates|visitArgs|visitBranching|visitTop|checkNotDropped|introduce|forget)
          continue ;;
        *) return 0 ;;
      esac
    done < <(printf '%s' "$hay" | grep -oE '[A-Za-z_][A-Za-z0-9_]*[[:space:]]+'"${coll}""${bare_after}" || true)
    # Parenthesized app with bare coll: go (pureFvars) / go (s, pureFvars) / go (pureFvars, s)
    # NOT visitRuntime (pureFvars[0]!) — '[' after coll excluded by bare_after.
    while IFS= read -r line; do
      [[ -z "$line" ]] && continue
      callee="${line%%(*}"
      callee="${callee// /}"
      case "$callee" in
        let|have|if|match|return|pure|do|else|then|where|for|fun|with|some|none|not|consume|visitRuntime|mergeStates|visitArgs)
          continue ;;
        *) return 0 ;;
      esac
    done < <(printf '%s' "$hay" | grep -oE '[A-Za-z_][A-Za-z0-9_]*[[:space:]]*\([^)]*'"${coll}""${bare_after}" || true)
    return 1
  }
  # Pipe into named function: pureFvars |> exclusiveGo  (NOT pureFvars |>.all method form).
  is_pipe_to_named_fn() {
    local hay="$1" coll="$2"
    [[ "$coll" =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]] || return 1
    # coll |> Ident  or  coll|>Ident — require Ident after |>, not '.'
    if printf '%s' "$hay" | grep -qE '(^|[^A-Za-z0-9_])'"${coll}"'[[:space:]]*\|>[[:space:]]*[A-Za-z_]'; then
      return 0
    fi
    return 1
  }
  if [[ -n "${VB_FLAT_IDS:-}" ]]; then
    # Fail-closed: any non-method named call/pipe with pureFvars/alias in visitBranching.
    # Does NOT require fold/consume in-region (sibling helpers live outside the extract).
    if is_call_arg_of "$VB_FLAT_IDS" pureFvars; then
      exclusive_hit=1
      exclusive_kind="named-fn call-arg pureFvars (sibling/helper exclusive risk)"
    fi
    if is_pipe_to_named_fn "$VB_FLAT_IDS" pureFvars; then
      exclusive_hit=1
      exclusive_kind="pipe pureFvars |> named-fn (sibling/helper exclusive risk)"
    fi
    for nm in $(collect_pf_aliases "$VB_FLAT_IDS"); do
      [[ "$nm" == "pureFvars" ]] && continue
      if is_call_arg_of "$VB_FLAT_IDS" "$nm"; then
        exclusive_hit=1
        exclusive_kind="named-fn call-arg alias ${nm} (sibling/helper exclusive risk)"
      fi
      if is_pipe_to_named_fn "$VB_FLAT_IDS" "$nm"; then
        exclusive_hit=1
        exclusive_kind="pipe alias ${nm} |> named-fn (sibling/helper exclusive risk)"
      fi
    done
  fi

  if [[ "$exclusive_hit" -eq 1 ]]; then
    fail_line "UseCheck exclusive pureFvars iterate-consume (${exclusive_kind:-for/forM/mapM/fold/any-arg/rename/helper-hop} multi-distinct residual leak)"
    pure_bad=1
  fi

  # Path-disagreement fail surface (message string is real code form).
  if ! grep -qF 'control-flow paths disagree on linear' "$SNAP_UC"; then
    fail_line "UseCheck missing path-disagreement error for distinct pure-fvar remainders"
    pure_bad=1
  fi
fi

if [[ "$pure_bad" -eq 0 ]]; then
  ok_pure_fvar=1
  ok_line "UseCheck distinct pure-fvar residual: real ·==f0 same-fvar consume + mergeStates (no multi-arm exclusive leak)"
fi

# ---------------------------------------------------------------------------
# 2) Systems bif* ⊆ UseCheck splitterLayout? allowlist (greppable SSoT)
# ---------------------------------------------------------------------------
bif_bad=0

# Inventory: def bifX under Systems after comment + string strip (no phantom comment/string defs).
FS_SNAP="$SNAP_DIR/fs_all.code"
: >"$FS_SNAP"
if command -v find >/dev/null 2>&1; then
  while IFS= read -r -d '' f; do
    strip_lean_comments "$f" | strip_string_literals >>"$FS_SNAP"
    printf '\n' >>"$FS_SNAP"
  done < <(find "$FS_ROOT" -type f -name '*.lean' -print0 2>/dev/null)
else
  # Portable fallback
  for f in "$FS_ROOT"/*.lean "$FS_ROOT"/*/*.lean; do
    [[ -f "$f" ]] || continue
    strip_lean_comments "$f" | strip_string_literals >>"$FS_SNAP"
    printf '\n' >>"$FS_SNAP"
  done
fi

mapfile -t BIF_DEFS < <(
  if [[ -s "$FS_SNAP" ]]; then
    if command -v rg >/dev/null 2>&1; then
      rg -N --no-heading --no-filename -o --pcre2 \
        '(?:^|[^A-Za-z0-9_])def\s+(bif[A-Za-z0-9_]+)' \
        -r '$1' \
        "$FS_SNAP" 2>/dev/null | sort -u || true
    else
      grep -Eo '(^|[[:space:]])def[[:space:]]+bif[A-Za-z0-9_]+' "$FS_SNAP" 2>/dev/null \
        | sed -E 's/.*def[[:space:]]+//' | sort -u || true
    fi
  fi
)

if [[ "${#BIF_DEFS[@]}" -eq 0 || -z "${BIF_DEFS[0]:-}" ]]; then
  fail_line "no freestanding def bif* found under $FS_ROOT (after comment/string strip)"
  bif_bad=1
fi

# splitterLayout? must exist as code (string-stripped).
if ! grep -qE 'splitterLayout\?' "$SNAP_UC_IDS"; then
  fail_line "UseCheck missing splitterLayout? (code, not strings)"
  bif_bad=1
fi

# Bif allowlist requires Name.str **match-arm** form **inside splitterLayout? region only**
# (no whole-file fallback — decoy defs elsewhere must not mint QTT_SPLITTER_BIF_COMPLETE).
#   .str _ "bifU32"   (product form in splitterLayout?)
# Optional alt: `` `bifU32 `` name-literal match arm.
# Hollow List String of names must FAIL (quoted-only decoy).
has_bif_str_arm() {
  local snap="$1" bif="$2"
  # Comment-stripped source keeps the string literal inside the .str arm.
  if grep -qE '\.str[[:space:]]+_[[:space:]]*"'"${bif}"'"' "$snap"; then
    return 0
  fi
  # Name literal form (rare): | ``bifU8 or | `bifU8
  if grep -qE '``'"${bif}"'``|`'"${bif}"'`' "$snap"; then
    return 0
  fi
  return 1
}

# Extract splitterLayout? body only (name may include trailing ?; match splitterLayout prefix).
# Fail closed if region cannot be extracted — do not fall back to whole-file bif greps.
SL_REGION="$(extract_region "$SNAP_UC" splitterLayout || true)"
if [[ -z "${SL_REGION//[[:space:]]/}" ]]; then
  # Some snapshots keep the ? in the def name line only; try awk line-range from private def.
  SL_REGION="$(awk '
    BEGIN { take=0 }
    {
      if (!take) {
        if ($0 ~ /def[[:space:]]+splitterLayout\?/) { take=1; print; next }
      } else {
        if ($0 ~ /^(public[[:space:]]+|private[[:space:]]+|protected[[:space:]]+|partial[[:space:]]+)*(def|theorem|abbrev)[[:space:]]+/ \
            || $0 ~ /^end([[:space:]]|$)/ \
            || $0 ~ /^namespace[[:space:]]/) { exit }
        print
      }
    }
  ' "$SNAP_UC" || true)"
fi
if [[ -z "${SL_REGION//[[:space:]]/}" ]]; then
  fail_line "missing def splitterLayout? region (cannot verify bif* Name.str arms in SSoT)"
  bif_bad=1
  SL_CHECK_SNAP=""
else
  SL_CHECK_FILE="$SNAP_DIR/splitterLayout.region"
  printf '%s\n' "$SL_REGION" >"$SL_CHECK_FILE"
  SL_CHECK_SNAP="$SL_CHECK_FILE"
  # Region must itself mention splitterLayout (sanity).
  if ! grep -qE 'splitterLayout' "$SL_CHECK_SNAP"; then
    fail_line "splitterLayout? region extract is hollow (no splitterLayout identifier)"
    bif_bad=1
  fi
fi

missing_list=()
if [[ -n "$SL_CHECK_SNAP" && -f "$SL_CHECK_SNAP" ]]; then
  for bif in "${BIF_DEFS[@]}"; do
    [[ -z "$bif" ]] && continue
    if ! has_bif_str_arm "$SL_CHECK_SNAP" "$bif"; then
      missing_list+=("$bif")
    fi
  done
fi

if [[ "${#missing_list[@]}" -gt 0 ]]; then
  fail_line "UseCheck splitterLayout? region missing freestanding bif* Name.str match arms (.str _ \"bif…\"): ${missing_list[*]}"
  bif_bad=1
elif [[ -n "$SL_CHECK_SNAP" && -f "$SL_CHECK_SNAP" ]]; then
  # Known product set must still be present when freestanding inventory is full product.
  # When override trees define a subset, only inventory completeness is required above.
  if [[ "$ALLOW_OVERRIDE" != "1" || "$FS_ROOT" == "$PRODUCT_FS_ROOT" ]]; then
    for need in bifU32 bifU64 bifUSize bifBool bifU8 bifArena bifMMap; do
      if ! has_bif_str_arm "$SL_CHECK_SNAP" "$need"; then
        fail_line "UseCheck splitterLayout? region missing expected product bif Name.str arm ${need}"
        bif_bad=1
      fi
      # Also require product freestanding actually defines each (D2 allowlist completeness).
      if ! printf '%s\n' "${BIF_DEFS[@]}" | grep -qx "$need"; then
        fail_line "product freestanding missing def ${need} (Track D D2 allowlist completeness)"
        bif_bad=1
      fi
    done
  fi
fi

# Reject hollow quoted-only decoy **inside splitterLayout? region** (or region missing arms).
if [[ -n "$SL_CHECK_SNAP" && -f "$SL_CHECK_SNAP" ]]; then
  if grep -qE '"bif[A-Za-z0-9_]+"' "$SL_CHECK_SNAP"; then
    if ! grep -qE '\.str[[:space:]]+_[[:space:]]*"bif[A-Za-z0-9_]+"' "$SL_CHECK_SNAP"; then
      fail_line "splitterLayout? region has quoted bif* strings but no .str _ \"bif…\" match arms (quoted-only decoy)"
      bif_bad=1
    fi
  fi
  # Layout for bif* is Bool → τ → τ → τ (alts start at 1) — must appear in region SSoT.
  if ! grep -qE 'firstAlt[[:space:]]*:=[[:space:]]*1' "$SL_CHECK_SNAP"; then
    # firstAlt may only appear after string strip of comments; region still has code.
    if ! printf '%s\n' "$SL_REGION" | strip_string_literals | grep -qE 'firstAlt[[:space:]]*:=[[:space:]]*1'; then
      fail_line "splitterLayout? region missing firstAlt := 1 (freestanding bif* layout)"
      bif_bad=1
    fi
  fi
else
  # Already failed missing region; still require product firstAlt somewhere as secondary signal only when region present.
  :
fi

if [[ "$bif_bad" -eq 0 ]]; then
  ok_bif=1
  ok_line "freestanding bif* complete vs UseCheck splitterLayout (${#BIF_DEFS[@]} defs: ${BIF_DEFS[*]})"
fi

if [[ "$ok_pure_fvar" -ne 1 || "$ok_bif" -ne 1 ]]; then
  status=1
fi

emit_tokens
exit "$status"
