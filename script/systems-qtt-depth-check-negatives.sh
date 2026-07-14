#!/usr/bin/env bash
# Negative / positive cases for systems-qtt-depth-check.sh (Track D, fail-closed).
#
# Ensures:
#   * Real product tree emits all three success tokens
#   * Missing / empty UseCheck or Systems product root → FAIL + all tokens =0
#   * Stripped pure-fvar same-fvar guard / mergeStates → FAIL
#   * Vacuous pureFvars.all (fun _ => true) → FAIL (Issue 1)
#   * Hollow marker soup (strings only) → FAIL (Issue 2)
#   * Exclusive pureFvars for/forM/mapM consume → FAIL
#   * Missing bifU8 / bifArena in allowlist while freestanding defines them → FAIL
#   * Comment/string phantom bif inventory → not counted (Issue 3)
#   * Empty FS / missing firstAlt → FAIL
#   * Path overrides require SYSTEMS_LEAN_QTT_DEPTH_ALLOW_OVERRIDE=1
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
GATE="$ROOT/script/systems-qtt-depth-check.sh"
chmod +x "$GATE" 2>/dev/null || true

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

SUCCESS_TOKENS=(
  QTT_USECHECK_DISTINCT_PURE_FVAR=1
  QTT_SPLITTER_BIF_COMPLETE=1
  QTT_DEPTH_OK=1
)
ZERO_TOKENS=(
  QTT_USECHECK_DISTINCT_PURE_FVAR=0
  QTT_SPLITTER_BIF_COMPLETE=0
  QTT_DEPTH_OK=0
)

assert_all_tokens_zero() {
  local name="$1" out="$2"
  local t
  for t in "${SUCCESS_TOKENS[@]}"; do
    if grep -qx "$t" "$out"; then
      echo "FAIL: case $name emitted success token $t on failure" >&2
      cat "$out" >&2
      exit 1
    fi
  done
  for t in "${ZERO_TOKENS[@]}"; do
    if ! grep -qx "$t" "$out"; then
      echo "FAIL: case $name missing fail-closed token $t" >&2
      cat "$out" >&2
      exit 1
    fi
  done
}

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
  if [[ $ec -ne 1 ]]; then
    echo "FAIL: expected exit 1 for case $name (got $ec)" >&2
    cat "$out" >&2
    exit 1
  fi
  if ! grep -qE '^FAIL:' "$out"; then
    echo "FAIL: case $name: expected FAIL: line" >&2
    cat "$out" >&2
    exit 1
  fi
  if [[ -n "$expect_re" ]] && ! grep -qE "$expect_re" "$out"; then
    echo "FAIL: case $name: expected FAIL matching /$expect_re/" >&2
    cat "$out" >&2
    exit 1
  fi
  assert_all_tokens_zero "$name" "$out"
  echo "OK: negative case $name (exit $ec)"
  # Show more FAIL context (all FAIL lines, capped) for reviewability.
  grep -E '^FAIL:' "$out" | head -n12 || true
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
    echo "FAIL: expected exit 0 for case $name (got $ec)" >&2
    cat "$out" >&2
    exit 1
  fi
  local t
  for t in "${SUCCESS_TOKENS[@]}"; do
    if ! grep -qx "$t" "$out"; then
      echo "FAIL: case $name missing success token $t" >&2
      cat "$out" >&2
      exit 1
    fi
  done
  for t in "${ZERO_TOKENS[@]}"; do
    if grep -qx "$t" "$out"; then
      echo "FAIL: case $name emitted fail token $t on success" >&2
      cat "$out" >&2
      exit 1
    fi
  done
  echo "OK: positive case $name"
}

# Minimal freestanding tree with a couple of bif* (for override cases).
mkdir -p "$tmpdir/fs_bytes" "$tmpdir/fs_empty" "$tmpdir/fs_comment_phantom" "$tmpdir/fs_arena"

cat >"$tmpdir/fs_bytes/Bytes.lean" <<'EOF'
module
prelude
namespace Systems
public def bifU8 (c : Bool) (t e : Nat) : Nat := if c then t else e
public def bifU32 (c : Bool) (t e : Nat) : Nat := if c then t else e
end Systems
EOF

cat >"$tmpdir/fs_arena/Sys.lean" <<'EOF'
module
prelude
namespace Systems
public def bifArena (c : Bool) (t e : Nat) : Nat := if c then t else e
public def bifMMap (c : Bool) (t e : Nat) : Nat := if c then t else e
end Systems
EOF

# Comment/string-only phantom bifGhost must not inventory.
cat >"$tmpdir/fs_comment_phantom/Ghost.lean" <<'EOF'
module
prelude
namespace Systems
-- public def bifGhost (c : Bool) (t e : Nat) : Nat := t
/- public def bifGhost2 (c : Bool) (t e : Nat) : Nat := t -/
def note : String := "public def bifGhost3 (c : Bool) (t e : Nat) : Nat := t"
public def bifU8 (c : Bool) (t e : Nat) : Nat := if c then t else e
end Systems
EOF

# Shared well-formed pure-fvar visitBranching body (for allowlist-only negatives).
GOOD_VB_BODY='
partial def visitBranching (alts : Array Expr) (s : Nat) : MetaM Nat := do
  let pureFvars := alts
  if pureFvars.size ≥ 2 then
    match pureFvars[0]? with
    | some f0 =>
      if pureFvars.all (· == f0) then
        consume s f0 "same pure-fvar on every control-flow arm"
      else
        let si ← visitRuntime (pureFvars[0]!) s
        let sj ← visitRuntime (pureFvars[1]!) s
        mergeStates s si sj
    | none => pure s
  else pure s
where
  consume (s : Nat) (_f : Nat) (_w : String) : MetaM Nat := pure s
  visitRuntime (_e : Nat) (s : Nat) : MetaM Nat := pure s
  mergeStates (_base _a _b : Nat) : MetaM Nat := pure 0
def _pathDisagreementMsg : String := "control-flow paths disagree on linear"
def layoutFirst : Nat :=
  let firstAlt := 1
  firstAlt
'

# --- 0) Product tree PASS ---
pass_case product_tree \
  env -u SYSTEMS_LEAN_QTT_DEPTH_USECHECK \
      -u SYSTEMS_LEAN_QTT_DEPTH_FREESTANDING \
      -u SYSTEMS_LEAN_QTT_DEPTH_ALLOW_OVERRIDE \
      "$GATE"

# --- 1) Missing UseCheck ---
fail_case missing_usecheck --expect 'missing UseCheck' \
  env SYSTEMS_LEAN_QTT_DEPTH_ALLOW_OVERRIDE=1 \
      SYSTEMS_LEAN_QTT_DEPTH_USECHECK="$tmpdir/no-usecheck.lean" \
      SYSTEMS_LEAN_QTT_DEPTH_FREESTANDING="$ROOT/src/Systems" \
      "$GATE"

# --- 2) Empty UseCheck ---
: >"$tmpdir/empty.lean"
fail_case empty_usecheck --expect 'empty after comment strip|missing UseCheck|comment-only' \
  env SYSTEMS_LEAN_QTT_DEPTH_ALLOW_OVERRIDE=1 \
      SYSTEMS_LEAN_QTT_DEPTH_USECHECK="$tmpdir/empty.lean" \
      SYSTEMS_LEAN_QTT_DEPTH_FREESTANDING="$ROOT/src/Systems" \
      "$GATE"

# --- 3) Comment-only UseCheck forge ---
cat >"$tmpdir/comment_only.lean" <<'EOF'
/-
pureFvars.all (· == f0)
mergeStates
same pure-fvar on every control-flow arm
control-flow paths disagree on linear
splitterLayout?
"bifU32" "bifU64" "bifUSize" "bifBool" "bifU8" "bifArena" "bifMMap"
firstAlt := 1
visitBranching
-/
-- pureFvars
EOF
fail_case comment_only_usecheck --expect 'empty after comment strip|missing pureFvars|comment-only|visitBranching' \
  env SYSTEMS_LEAN_QTT_DEPTH_ALLOW_OVERRIDE=1 \
      SYSTEMS_LEAN_QTT_DEPTH_USECHECK="$tmpdir/comment_only.lean" \
      SYSTEMS_LEAN_QTT_DEPTH_FREESTANDING="$ROOT/src/Systems" \
      "$GATE"

# --- 4) Hollow soup: greppable markers only inside strings / bare tokens without structure ---
cat >"$tmpdir/hollow_soup.lean" <<'EOF'
module
prelude
namespace Lean.Compiler.QTT
def markers : List String := [
  "partial def visitBranching",
  "pureFvars.all (· == f0)",
  "consume s f0",
  "mergeStates",
  "visitRuntime",
  "same pure-fvar on every control-flow arm",
  "control-flow paths disagree on linear",
  "splitterLayout?",
  "\"bifU32\" \"bifU64\" \"bifUSize\" \"bifBool\" \"bifU8\" \"bifArena\" \"bifMMap\"",
  "firstAlt := 1"
]
def pureFvars : Unit := ()
def visitBranching : Unit := ()
def mergeStates : Unit := ()
end Lean.Compiler.QTT
EOF
fail_case hollow_soup --expect 'equality-to-f0|same pure-fvar|visitRuntime|visitBranching missing|firstAlt|splitterLayout' \
  env SYSTEMS_LEAN_QTT_DEPTH_ALLOW_OVERRIDE=1 \
      SYSTEMS_LEAN_QTT_DEPTH_USECHECK="$tmpdir/hollow_soup.lean" \
      SYSTEMS_LEAN_QTT_DEPTH_FREESTANDING="$ROOT/src/Systems" \
      "$GATE"

# --- 5) Vacuous pureFvars.all (fun _ => true) ---
cat >"$tmpdir/vacuous_all.lean" <<EOF
module
prelude
namespace Lean.Compiler.QTT
private def splitterLayout? (fn : Name) : MetaM (Option Nat) := do
  match fn with
  | .str _ "bifU32" | .str _ "bifU64" | .str _ "bifUSize" | .str _ "bifBool" | .str _ "bifU8"
  | .str _ "bifArena" | .str _ "bifMMap" =>
    return some 1
  | _ => return none
partial def visitBranching (alts : Array Expr) (s : Nat) : MetaM Nat := do
  let pureFvars := alts
  if pureFvars.size ≥ 2 then
    match pureFvars[0]? with
    | some f0 =>
      if pureFvars.all (fun _ => true) then
        consume s f0 "same pure-fvar on every control-flow arm"
      else
        let si ← visitRuntime (pureFvars[0]!) s
        mergeStates s si si
    | none => pure s
  else pure s
where
  consume (s : Nat) (_f : Nat) (_w : String) : MetaM Nat := pure s
  visitRuntime (_e : Nat) (s : Nat) : MetaM Nat := pure s
  mergeStates (_base _a _b : Nat) : MetaM Nat := pure 0
def _pathDisagreementMsg : String := "control-flow paths disagree on linear"
def layoutFirst : Nat :=
  let firstAlt := 1
  firstAlt
end Lean.Compiler.QTT
EOF
fail_case vacuous_all --expect 'vacuous pureFvars\.all|equality-to-f0' \
  env SYSTEMS_LEAN_QTT_DEPTH_ALLOW_OVERRIDE=1 \
      SYSTEMS_LEAN_QTT_DEPTH_USECHECK="$tmpdir/vacuous_all.lean" \
      SYSTEMS_LEAN_QTT_DEPTH_FREESTANDING="$ROOT/src/Systems" \
      "$GATE"

# --- 6) Stripped pure-fvar path ---
cat >"$tmpdir/stripped_pure.lean" <<'EOF'
module
prelude
namespace Lean.Compiler.QTT
private def splitterLayout? (fn : Name) : MetaM (Option Nat) := do
  match fn with
  | .str _ "bifU32" | .str _ "bifU64" | .str _ "bifUSize" | .str _ "bifBool" | .str _ "bifU8"
  | .str _ "bifArena" | .str _ "bifMMap" =>
    return some 1
  | _ => return none
partial def visitBranching (alts : Array Expr) (s : Nat) : MetaM Nat := do
  let pureFvars := alts
  for f in pureFvars do
    discard (pure f)
  pure s
def layoutFirst : Nat :=
  let firstAlt := 1
  firstAlt
end Lean.Compiler.QTT
EOF
fail_case stripped_pure_fvar --expect 'equality-to-f0|mergeStates|path-disagreement|same pure-fvar|pureFvars\.all' \
  env SYSTEMS_LEAN_QTT_DEPTH_ALLOW_OVERRIDE=1 \
      SYSTEMS_LEAN_QTT_DEPTH_USECHECK="$tmpdir/stripped_pure.lean" \
      SYSTEMS_LEAN_QTT_DEPTH_FREESTANDING="$ROOT/src/Systems" \
      "$GATE"

# --- 7) Missing bifU8 in allowlist while Systems defines bifU8 ---
cat >"$tmpdir/no_bifu8.lean" <<EOF
module
prelude
namespace Lean.Compiler.QTT
private def splitterLayout? (fn : Name) : MetaM (Option Nat) := do
  match fn with
  | .str _ "bifU32" | .str _ "bifU64" | .str _ "bifUSize" | .str _ "bifBool"
  | .str _ "bifArena" | .str _ "bifMMap" =>
    return some 1
  | _ => return none
${GOOD_VB_BODY}
end Lean.Compiler.QTT
EOF
fail_case missing_bifu8_allowlist --expect 'missing freestanding bif|bifU8' \
  env SYSTEMS_LEAN_QTT_DEPTH_ALLOW_OVERRIDE=1 \
      SYSTEMS_LEAN_QTT_DEPTH_USECHECK="$tmpdir/no_bifu8.lean" \
      SYSTEMS_LEAN_QTT_DEPTH_FREESTANDING="$tmpdir/fs_bytes" \
      "$GATE"

# --- 8) Missing bifArena in allowlist while freestanding defines bifArena ---
cat >"$tmpdir/no_bifarena.lean" <<EOF
module
prelude
namespace Lean.Compiler.QTT
private def splitterLayout? (fn : Name) : MetaM (Option Nat) := do
  match fn with
  | .str _ "bifU32" | .str _ "bifU64" | .str _ "bifUSize" | .str _ "bifBool" | .str _ "bifU8"
  | .str _ "bifMMap" =>
    return some 1
  | _ => return none
${GOOD_VB_BODY}
end Lean.Compiler.QTT
EOF
fail_case missing_bifarena_allowlist --expect 'missing freestanding bif|bifArena' \
  env SYSTEMS_LEAN_QTT_DEPTH_ALLOW_OVERRIDE=1 \
      SYSTEMS_LEAN_QTT_DEPTH_USECHECK="$tmpdir/no_bifarena.lean" \
      SYSTEMS_LEAN_QTT_DEPTH_FREESTANDING="$tmpdir/fs_arena" \
      "$GATE"

# --- 9) Exclusive pureFvars for-loop consume ---
cat >"$tmpdir/leak_exclusive.lean" <<'EOF'
module
prelude
namespace Lean.Compiler.QTT
private def splitterLayout? (fn : Name) : MetaM (Option Nat) := do
  match fn with
  | .str _ "bifU32" | .str _ "bifU64" | .str _ "bifUSize" | .str _ "bifBool" | .str _ "bifU8"
  | .str _ "bifArena" | .str _ "bifMMap" =>
    return some { firstAlt := 1, numAlts? := some 2 }
  | _ => pure none
partial def visitBranching (s : Nat) (pureFvars : Array Nat) : MetaM Nat := do
  if pureFvars.all (· == f0) then
    consume s f0 "same pure-fvar on every control-flow arm"
  else
    for f in pureFvars do
      let s ← consume s f "exclusive multi arm"
    pure s
where
  f0 : Nat := 0
  consume (s : Nat) (_f : Nat) (_w : String) : MetaM Nat := pure s
  visitRuntime (_e : Nat) (s : Nat) : MetaM Nat := pure s
private def mergeStates : Nat := 0
def msg : String := "control-flow paths disagree on linear"
end Lean.Compiler.QTT
EOF
fail_case exclusive_purefvar_loop --expect 'exclusive pureFvars|iterate-consume|for pureFvars' \
  env SYSTEMS_LEAN_QTT_DEPTH_ALLOW_OVERRIDE=1 \
      SYSTEMS_LEAN_QTT_DEPTH_USECHECK="$tmpdir/leak_exclusive.lean" \
      SYSTEMS_LEAN_QTT_DEPTH_FREESTANDING="$ROOT/src/Systems" \
      "$GATE"

# --- 10) Exclusive pureFvars.mapM consume ---
cat >"$tmpdir/leak_mapm.lean" <<'EOF'
module
prelude
namespace Lean.Compiler.QTT
private def splitterLayout? (fn : Name) : MetaM (Option Nat) := do
  match fn with
  | .str _ "bifU32" | .str _ "bifU64" | .str _ "bifUSize" | .str _ "bifBool" | .str _ "bifU8"
  | .str _ "bifArena" | .str _ "bifMMap" => pure (some 1)
  | _ => pure none
partial def visitBranching (s : Nat) (pureFvars : Array Nat) : MetaM Nat := do
  if pureFvars.all (· == f0) then
    consume s f0 "same pure-fvar on every control-flow arm"
  else
    let _ ← pureFvars.mapM fun f => consume s f "mapM exclusive"
    pure s
where
  f0 : Nat := 0
  consume (s : Nat) (_f : Nat) (_w : String) : MetaM Nat := pure s
  visitRuntime (_e : Nat) (s : Nat) : MetaM Nat := pure s
private def mergeStates : Nat := 0
def msg : String := "control-flow paths disagree on linear"
def layout : Nat :=
  let firstAlt := 1
  firstAlt
end Lean.Compiler.QTT
EOF
fail_case exclusive_purefvar_mapm --expect 'exclusive pureFvars|iterate-consume|mapM' \
  env SYSTEMS_LEAN_QTT_DEPTH_ALLOW_OVERRIDE=1 \
      SYSTEMS_LEAN_QTT_DEPTH_USECHECK="$tmpdir/leak_mapm.lean" \
      SYSTEMS_LEAN_QTT_DEPTH_FREESTANDING="$ROOT/src/Systems" \
      "$GATE"

# --- 11) Exclusive pureFvars.forM consume ---
cat >"$tmpdir/leak_form.lean" <<'EOF'
module
prelude
namespace Lean.Compiler.QTT
private def splitterLayout? (fn : Name) : MetaM (Option Nat) := do
  match fn with
  | .str _ "bifU32" | .str _ "bifU64" | .str _ "bifUSize" | .str _ "bifBool" | .str _ "bifU8"
  | .str _ "bifArena" | .str _ "bifMMap" => pure (some 1)
  | _ => pure none
partial def visitBranching (s : Nat) (pureFvars : Array Nat) : MetaM Nat := do
  if pureFvars.all (· == f0) then
    consume s f0 "same pure-fvar on every control-flow arm"
  else
    pureFvars.forM fun f => do
      discard <| consume s f "forM exclusive"
    pure s
where
  f0 : Nat := 0
  consume (s : Nat) (_f : Nat) (_w : String) : MetaM Nat := pure s
  visitRuntime (_e : Nat) (s : Nat) : MetaM Nat := pure s
private def mergeStates : Nat := 0
def msg : String := "control-flow paths disagree on linear"
def layout : Nat :=
  let firstAlt := 1
  firstAlt
end Lean.Compiler.QTT
EOF
fail_case exclusive_purefvar_form --expect 'exclusive pureFvars|iterate-consume|forM' \
  env SYSTEMS_LEAN_QTT_DEPTH_ALLOW_OVERRIDE=1 \
      SYSTEMS_LEAN_QTT_DEPTH_USECHECK="$tmpdir/leak_form.lean" \
      SYSTEMS_LEAN_QTT_DEPTH_FREESTANDING="$ROOT/src/Systems" \
      "$GATE"

# --- 11b) Exclusive pureFvars.foldlM consume ---
cat >"$tmpdir/leak_foldlm.lean" <<'EOF'
module
prelude
namespace Lean.Compiler.QTT
private def splitterLayout? (fn : Name) : MetaM (Option Nat) := do
  match fn with
  | .str _ "bifU32" | .str _ "bifU64" | .str _ "bifUSize" | .str _ "bifBool" | .str _ "bifU8"
  | .str _ "bifArena" | .str _ "bifMMap" => pure (some 1)
  | _ => pure none
partial def visitBranching (s : Nat) (pureFvars : Array Nat) : MetaM Nat := do
  if pureFvars.all (· == f0) then
    consume s f0 "same pure-fvar on every control-flow arm"
  else
    pureFvars.foldlM (fun s f => consume s f "foldlM exclusive") s
where
  f0 : Nat := 0
  consume (s : Nat) (_f : Nat) (_w : String) : MetaM Nat := pure s
  visitRuntime (_e : Nat) (s : Nat) : MetaM Nat := pure s
private def mergeStates : Nat := 0
def msg : String := "control-flow paths disagree on linear"
def layout : Nat :=
  let firstAlt := 1
  firstAlt
end Lean.Compiler.QTT
EOF
fail_case exclusive_purefvar_foldlm --expect 'exclusive pureFvars|iterate-consume|foldl|fold' \
  env SYSTEMS_LEAN_QTT_DEPTH_ALLOW_OVERRIDE=1 \
      SYSTEMS_LEAN_QTT_DEPTH_USECHECK="$tmpdir/leak_foldlm.lean" \
      SYSTEMS_LEAN_QTT_DEPTH_FREESTANDING="$ROOT/src/Systems" \
      "$GATE"

# --- 11b2) Exclusive pureFvars.foldM consume ---
cat >"$tmpdir/leak_foldm.lean" <<'EOF'
module
prelude
namespace Lean.Compiler.QTT
private def splitterLayout? (fn : Name) : MetaM (Option Nat) := do
  match fn with
  | .str _ "bifU32" | .str _ "bifU64" | .str _ "bifUSize" | .str _ "bifBool" | .str _ "bifU8"
  | .str _ "bifArena" | .str _ "bifMMap" =>
    return some { firstAlt := 1, numAlts? := some 2 }
  | _ => pure none
partial def visitBranching (s : Nat) (pureFvars : Array Nat) : MetaM Nat := do
  if pureFvars.all (· == f0) then
    consume s f0 "same pure-fvar on every control-flow arm"
  else
    pureFvars.foldM (fun s f => consume s f "foldM exclusive") s
where
  f0 : Nat := 0
  consume (s : Nat) (_f : Nat) (_w : String) : MetaM Nat := pure s
  visitRuntime (_e : Nat) (s : Nat) : MetaM Nat := pure s
private def mergeStates : Nat := 0
def msg : String := "control-flow paths disagree on linear"
end Lean.Compiler.QTT
EOF
fail_case exclusive_purefvar_foldm --expect 'exclusive pureFvars|iterate-consume|foldM|fold' \
  env SYSTEMS_LEAN_QTT_DEPTH_ALLOW_OVERRIDE=1 \
      SYSTEMS_LEAN_QTT_DEPTH_USECHECK="$tmpdir/leak_foldm.lean" \
      SYSTEMS_LEAN_QTT_DEPTH_FREESTANDING="$ROOT/src/Systems" \
      "$GATE"

# --- 11b3) Rename-then-fold: let arms := pureFvars; arms.foldl … consume ---
cat >"$tmpdir/leak_rename_foldl.lean" <<'EOF'
module
prelude
namespace Lean.Compiler.QTT
private def splitterLayout? (fn : Name) : MetaM (Option Nat) := do
  match fn with
  | .str _ "bifU32" | .str _ "bifU64" | .str _ "bifUSize" | .str _ "bifBool" | .str _ "bifU8"
  | .str _ "bifArena" | .str _ "bifMMap" =>
    return some { firstAlt := 1, numAlts? := some 2 }
  | _ => pure none
partial def visitBranching (s : Nat) (pureFvars : Array Nat) : MetaM Nat := do
  if pureFvars.all (· == f0) then
    consume s f0 "same pure-fvar on every control-flow arm"
  else
    let arms := pureFvars
    arms.foldl (fun s f => Id.run (consume s f "rename foldl exclusive")) s
where
  f0 : Nat := 0
  consume (s : Nat) (_f : Nat) (_w : String) : Id Nat := pure s
  visitRuntime (_e : Nat) (s : Nat) : MetaM Nat := pure s
private def mergeStates : Nat := 0
def msg : String := "control-flow paths disagree on linear"
end Lean.Compiler.QTT
EOF
fail_case exclusive_rename_foldl --expect 'exclusive pureFvars|iterate-consume|fold|rename|method-iter|any-arg' \
  env SYSTEMS_LEAN_QTT_DEPTH_ALLOW_OVERRIDE=1 \
      SYSTEMS_LEAN_QTT_DEPTH_USECHECK="$tmpdir/leak_rename_foldl.lean" \
      SYSTEMS_LEAN_QTT_DEPTH_FREESTANDING="$ROOT/src/Systems" \
      "$GATE"

# --- 11b3b) Array.foldlM f s pureFvars (collection as trailing arg) ---
cat >"$tmpdir/leak_array_foldlm_trailing.lean" <<'EOF'
module
prelude
namespace Lean.Compiler.QTT
private def splitterLayout? (fn : Name) : MetaM (Option Nat) := do
  match fn with
  | .str _ "bifU32" | .str _ "bifU64" | .str _ "bifUSize" | .str _ "bifBool" | .str _ "bifU8"
  | .str _ "bifArena" | .str _ "bifMMap" =>
    return some { firstAlt := 1, numAlts? := some 2 }
  | _ => pure none
partial def visitBranching (s : Nat) (pureFvars : Array Nat) : MetaM Nat := do
  if pureFvars.all (· == f0) then
    consume s f0 "same pure-fvar on every control-flow arm"
  else
    -- Collection pureFvars is trailing arg (not method receiver)
    Array.foldlM (fun s f => consume s f "Array.foldlM trailing exclusive") s pureFvars
where
  f0 : Nat := 0
  consume (s : Nat) (_f : Nat) (_w : String) : MetaM Nat := pure s
  visitRuntime (_e : Nat) (s : Nat) : MetaM Nat := pure s
private def mergeStates : Nat := 0
def msg : String := "control-flow paths disagree on linear"
end Lean.Compiler.QTT
EOF
fail_case exclusive_array_foldlm_trailing --expect 'exclusive pureFvars|iterate-consume|any-arg|fold' \
  env SYSTEMS_LEAN_QTT_DEPTH_ALLOW_OVERRIDE=1 \
      SYSTEMS_LEAN_QTT_DEPTH_USECHECK="$tmpdir/leak_array_foldlm_trailing.lean" \
      SYSTEMS_LEAN_QTT_DEPTH_FREESTANDING="$ROOT/src/Systems" \
      "$GATE"

# --- 11b3c) Transitive rename: let arms := pureFvars; let xs := arms; xs.foldl … consume ---
cat >"$tmpdir/leak_rename_transitive.lean" <<'EOF'
module
prelude
namespace Lean.Compiler.QTT
private def splitterLayout? (fn : Name) : MetaM (Option Nat) := do
  match fn with
  | .str _ "bifU32" | .str _ "bifU64" | .str _ "bifUSize" | .str _ "bifBool" | .str _ "bifU8"
  | .str _ "bifArena" | .str _ "bifMMap" =>
    return some { firstAlt := 1, numAlts? := some 2 }
  | _ => pure none
partial def visitBranching (s : Nat) (pureFvars : Array Nat) : MetaM Nat := do
  if pureFvars.all (· == f0) then
    consume s f0 "same pure-fvar on every control-flow arm"
  else
    let arms := pureFvars
    let xs := arms
    xs.foldl (fun s f => Id.run (consume s f "transitive rename foldl exclusive")) s
where
  f0 : Nat := 0
  consume (s : Nat) (_f : Nat) (_w : String) : Id Nat := pure s
  visitRuntime (_e : Nat) (s : Nat) : MetaM Nat := pure s
private def mergeStates : Nat := 0
def msg : String := "control-flow paths disagree on linear"
end Lean.Compiler.QTT
EOF
fail_case exclusive_rename_transitive --expect 'exclusive pureFvars|iterate-consume|fold|method-iter|any-arg' \
  env SYSTEMS_LEAN_QTT_DEPTH_ALLOW_OVERRIDE=1 \
      SYSTEMS_LEAN_QTT_DEPTH_USECHECK="$tmpdir/leak_rename_transitive.lean" \
      SYSTEMS_LEAN_QTT_DEPTH_FREESTANDING="$ROOT/src/Systems" \
      "$GATE"

# --- 11b3d) Helper/param hop: go pureFvars where go xs := xs.foldl … consume ---
cat >"$tmpdir/leak_helper_hop.lean" <<'EOF'
module
prelude
namespace Lean.Compiler.QTT
private def splitterLayout? (fn : Name) : MetaM (Option Nat) := do
  match fn with
  | .str _ "bifU32" | .str _ "bifU64" | .str _ "bifUSize" | .str _ "bifBool" | .str _ "bifU8"
  | .str _ "bifArena" | .str _ "bifMMap" =>
    return some { firstAlt := 1, numAlts? := some 2 }
  | _ => pure none
partial def visitBranching (s : Nat) (pureFvars : Array Nat) : MetaM Nat := do
  if pureFvars.all (· == f0) then
    consume s f0 "same pure-fvar on every control-flow arm"
  else
    -- pureFvars passed as helper arg; param xs is folded+consumed (alias tracker misses params)
    go pureFvars s
where
  f0 : Nat := 0
  go (xs : Array Nat) (s : Nat) : MetaM Nat :=
    xs.foldlM (fun s f => consume s f "helper hop exclusive") s
  consume (s : Nat) (_f : Nat) (_w : String) : MetaM Nat := pure s
  visitRuntime (_e : Nat) (s : Nat) : MetaM Nat := pure s
private def mergeStates : Nat := 0
def msg : String := "control-flow paths disagree on linear"
end Lean.Compiler.QTT
EOF
fail_case exclusive_helper_hop --expect 'exclusive pureFvars|helper|named-fn call-arg|iterate-consume' \
  env SYSTEMS_LEAN_QTT_DEPTH_ALLOW_OVERRIDE=1 \
      SYSTEMS_LEAN_QTT_DEPTH_USECHECK="$tmpdir/leak_helper_hop.lean" \
      SYSTEMS_LEAN_QTT_DEPTH_FREESTANDING="$ROOT/src/Systems" \
      "$GATE"

# --- 11b3e) Sibling top-level helper: fold+consume outside visitBranching ---
cat >"$tmpdir/leak_sibling_helper.lean" <<'EOF'
module
prelude
namespace Lean.Compiler.QTT
private def splitterLayout? (fn : Name) : MetaM (Option Nat) := do
  match fn with
  | .str _ "bifU32" | .str _ "bifU64" | .str _ "bifUSize" | .str _ "bifBool" | .str _ "bifU8"
  | .str _ "bifArena" | .str _ "bifMMap" =>
    return some { firstAlt := 1, numAlts? := some 2 }
  | _ => pure none
-- Sibling: exclusive multi-arm consume lives outside visitBranching extract
private def exclusiveGo (pureFvars : Array Nat) (s : Nat) : MetaM Nat :=
  pureFvars.foldlM (fun s f => consume s f "sibling exclusive") s
where
  consume (s : Nat) (_f : Nat) (_w : String) : MetaM Nat := pure s
partial def visitBranching (s : Nat) (pureFvars : Array Nat) : MetaM Nat := do
  if pureFvars.all (· == f0) then
    consume s f0 "same pure-fvar on every control-flow arm"
  else
    -- Only call-arg remains in visitBranching; fold+consume is sibling (must still FAIL)
    exclusiveGo pureFvars s
where
  f0 : Nat := 0
  consume (s : Nat) (_f : Nat) (_w : String) : MetaM Nat := pure s
  visitRuntime (_e : Nat) (s : Nat) : MetaM Nat := pure s
private def mergeStates : Nat := 0
def msg : String := "control-flow paths disagree on linear"
end Lean.Compiler.QTT
EOF
fail_case exclusive_sibling_helper --expect 'exclusive pureFvars|named-fn call-arg|sibling|helper' \
  env SYSTEMS_LEAN_QTT_DEPTH_ALLOW_OVERRIDE=1 \
      SYSTEMS_LEAN_QTT_DEPTH_USECHECK="$tmpdir/leak_sibling_helper.lean" \
      SYSTEMS_LEAN_QTT_DEPTH_FREESTANDING="$ROOT/src/Systems" \
      "$GATE"

# --- 11b3f) Pipe form: pureFvars |> exclusiveGo (sibling fold+consume) ---
cat >"$tmpdir/leak_pipe_helper.lean" <<'EOF'
module
prelude
namespace Lean.Compiler.QTT
private def splitterLayout? (fn : Name) : MetaM (Option Nat) := do
  match fn with
  | .str _ "bifU32" | .str _ "bifU64" | .str _ "bifUSize" | .str _ "bifBool" | .str _ "bifU8"
  | .str _ "bifArena" | .str _ "bifMMap" =>
    return some { firstAlt := 1, numAlts? := some 2 }
  | _ => pure none
private def exclusiveGo (pureFvars : Array Nat) (s : Nat) : MetaM Nat :=
  pureFvars.foldlM (fun s f => consume s f "pipe sibling exclusive") s
where
  consume (s : Nat) (_f : Nat) (_w : String) : MetaM Nat := pure s
partial def visitBranching (s : Nat) (pureFvars : Array Nat) : MetaM Nat := do
  if pureFvars.all (· == f0) then
    consume s f0 "same pure-fvar on every control-flow arm"
  else
    -- Pipe into sibling helper (must FAIL; juxtaform ban alone is insufficient)
    pureFvars |> exclusiveGo s
where
  f0 : Nat := 0
  consume (s : Nat) (_f : Nat) (_w : String) : MetaM Nat := pure s
  visitRuntime (_e : Nat) (s : Nat) : MetaM Nat := pure s
private def mergeStates : Nat := 0
def msg : String := "control-flow paths disagree on linear"
end Lean.Compiler.QTT
EOF
fail_case exclusive_pipe_helper --expect 'exclusive pureFvars|pipe pureFvars|named-fn|sibling|helper' \
  env SYSTEMS_LEAN_QTT_DEPTH_ALLOW_OVERRIDE=1 \
      SYSTEMS_LEAN_QTT_DEPTH_USECHECK="$tmpdir/leak_pipe_helper.lean" \
      SYSTEMS_LEAN_QTT_DEPTH_FREESTANDING="$ROOT/src/Systems" \
      "$GATE"

# --- 11b4) Decoy .str arms outside splitterLayout? must not mint PASS ---
cat >"$tmpdir/decoy_str_outside.lean" <<EOF
module
prelude
namespace Lean.Compiler.QTT
-- Real splitterLayout? has NO bif arms
private def splitterLayout? (fn : Name) : MetaM (Option Nat) := do
  match fn with
  | ``ite => return some { firstAlt := 3, numAlts? := some 2 }
  | _ => return none
-- Decoy: bif Name.str arms live in an unrelated def (must not count)
private def decoyBifNames (fn : Name) : Bool :=
  match fn with
  | .str _ "bifU32" | .str _ "bifU64" | .str _ "bifUSize" | .str _ "bifBool" | .str _ "bifU8"
  | .str _ "bifArena" | .str _ "bifMMap" => true
  | _ => false
${GOOD_VB_BODY}
end Lean.Compiler.QTT
EOF
fail_case decoy_str_outside_splitter --expect 'splitterLayout\? region missing|Name\.str match arms|missing freestanding bif' \
  env SYSTEMS_LEAN_QTT_DEPTH_ALLOW_OVERRIDE=1 \
      SYSTEMS_LEAN_QTT_DEPTH_USECHECK="$tmpdir/decoy_str_outside.lean" \
      SYSTEMS_LEAN_QTT_DEPTH_FREESTANDING="$tmpdir/fs_bytes" \
      "$GATE"

# --- 11c) Sequential dual-consume of pureFvars[0] and pureFvars[1] ---
cat >"$tmpdir/leak_seq_dual.lean" <<'EOF'
module
prelude
namespace Lean.Compiler.QTT
private def splitterLayout? (fn : Name) : MetaM (Option Nat) := do
  match fn with
  | .str _ "bifU32" | .str _ "bifU64" | .str _ "bifUSize" | .str _ "bifBool" | .str _ "bifU8"
  | .str _ "bifArena" | .str _ "bifMMap" => pure (some 1)
  | _ => pure none
partial def visitBranching (s : Nat) (pureFvars : Array Nat) : MetaM Nat := do
  if pureFvars.all (· == f0) then
    consume s f0 "same pure-fvar on every control-flow arm"
  else
    let s ← consume s pureFvars[0]!
    let s ← consume s pureFvars[1]!
    pure s
where
  f0 : Nat := 0
  consume (s : Nat) (_f : Nat) : MetaM Nat := pure s
  visitRuntime (_e : Nat) (s : Nat) : MetaM Nat := pure s
private def mergeStates : Nat := 0
def msg : String := "control-flow paths disagree on linear"
def layout : Nat :=
  let firstAlt := 1
  firstAlt
end Lean.Compiler.QTT
EOF
fail_case exclusive_seq_dual_purefvars --expect 'exclusive pureFvars|sequential|iterate-consume' \
  env SYSTEMS_LEAN_QTT_DEPTH_ALLOW_OVERRIDE=1 \
      SYSTEMS_LEAN_QTT_DEPTH_USECHECK="$tmpdir/leak_seq_dual.lean" \
      SYSTEMS_LEAN_QTT_DEPTH_FREESTANDING="$ROOT/src/Systems" \
      "$GATE"

# --- 11d) Quoted-only bif decoy (List String of names, no .str _ "bif…" arms) ---
cat >"$tmpdir/quoted_only_bif.lean" <<EOF
module
prelude
namespace Lean.Compiler.QTT
private def splitterLayout? (fn : Name) : MetaM (Option Nat) := do
  -- Hollow decoy: bif names only as strings, not Name.str match arms
  let _names : List String :=
    ["bifU32", "bifU64", "bifUSize", "bifBool", "bifU8", "bifArena", "bifMMap"]
  pure none
${GOOD_VB_BODY}
end Lean.Compiler.QTT
EOF
fail_case quoted_only_bif_decoy --expect 'quoted-only decoy|\.str _|Name\.str match arms|missing freestanding bif' \
  env SYSTEMS_LEAN_QTT_DEPTH_ALLOW_OVERRIDE=1 \
      SYSTEMS_LEAN_QTT_DEPTH_USECHECK="$tmpdir/quoted_only_bif.lean" \
      SYSTEMS_LEAN_QTT_DEPTH_FREESTANDING="$tmpdir/fs_bytes" \
      "$GATE"

# --- 12) Missing firstAlt := 1 ---
cat >"$tmpdir/no_firstalt.lean" <<EOF
module
prelude
namespace Lean.Compiler.QTT
private def splitterLayout? (fn : Name) : MetaM (Option Nat) := do
  match fn with
  | .str _ "bifU32" | .str _ "bifU64" | .str _ "bifUSize" | .str _ "bifBool" | .str _ "bifU8"
  | .str _ "bifArena" | .str _ "bifMMap" =>
    return some 2
  | _ => return none
${GOOD_VB_BODY}
end Lean.Compiler.QTT
EOF
# GOOD_VB_BODY still has firstAlt := 1 — make a version without it.
cat >"$tmpdir/no_firstalt.lean" <<'EOF'
module
prelude
namespace Lean.Compiler.QTT
private def splitterLayout? (fn : Name) : MetaM (Option Nat) := do
  match fn with
  | .str _ "bifU32" | .str _ "bifU64" | .str _ "bifUSize" | .str _ "bifBool" | .str _ "bifU8"
  | .str _ "bifArena" | .str _ "bifMMap" =>
    return some 2
  | _ => return none
partial def visitBranching (alts : Array Expr) (s : Nat) : MetaM Nat := do
  let pureFvars := alts
  if pureFvars.size ≥ 2 then
    match pureFvars[0]? with
    | some f0 =>
      if pureFvars.all (· == f0) then
        consume s f0 "same pure-fvar on every control-flow arm"
      else
        let si ← visitRuntime (pureFvars[0]!) s
        let sj ← visitRuntime (pureFvars[1]!) s
        mergeStates s si sj
    | none => pure s
  else pure s
where
  consume (s : Nat) (_f : Nat) (_w : String) : MetaM Nat := pure s
  visitRuntime (_e : Nat) (s : Nat) : MetaM Nat := pure s
  mergeStates (_base _a _b : Nat) : MetaM Nat := pure 0
def _pathDisagreementMsg : String := "control-flow paths disagree on linear"
end Lean.Compiler.QTT
EOF
fail_case missing_firstalt --expect 'firstAlt' \
  env SYSTEMS_LEAN_QTT_DEPTH_ALLOW_OVERRIDE=1 \
      SYSTEMS_LEAN_QTT_DEPTH_USECHECK="$tmpdir/no_firstalt.lean" \
      SYSTEMS_LEAN_QTT_DEPTH_FREESTANDING="$tmpdir/fs_bytes" \
      "$GATE"

# --- 13) Empty freestanding directory (no bif defs) ---
fail_case empty_freestanding --expect 'no freestanding def bif' \
  env SYSTEMS_LEAN_QTT_DEPTH_ALLOW_OVERRIDE=1 \
      SYSTEMS_LEAN_QTT_DEPTH_USECHECK="$ROOT/src/Lean/Compiler/QTT/UseCheck.lean" \
      SYSTEMS_LEAN_QTT_DEPTH_FREESTANDING="$tmpdir/fs_empty" \
      "$GATE"

# --- 14) Comment/string phantom bifGhost not inventory'd; real bifU8 still checked ---
# Product UseCheck has bifU8; phantom bifGhost in comments/strings must not force FAIL for missing allowlist.
pass_case comment_string_phantom_bif_ignored \
  env SYSTEMS_LEAN_QTT_DEPTH_ALLOW_OVERRIDE=1 \
      SYSTEMS_LEAN_QTT_DEPTH_USECHECK="$ROOT/src/Lean/Compiler/QTT/UseCheck.lean" \
      SYSTEMS_LEAN_QTT_DEPTH_FREESTANDING="$tmpdir/fs_comment_phantom" \
      "$GATE"

# --- 15) Override without ALLOW_OVERRIDE is ignored (still product PASS) ---
pass_case override_ignored_without_allow \
  env -u SYSTEMS_LEAN_QTT_DEPTH_ALLOW_OVERRIDE \
      SYSTEMS_LEAN_QTT_DEPTH_USECHECK="$tmpdir/empty.lean" \
      SYSTEMS_LEAN_QTT_DEPTH_FREESTANDING="$tmpdir/fs_bytes" \
      "$GATE"

# --- 16) Missing freestanding root ---
fail_case missing_fs_root --expect 'missing Systems product root' \
  env SYSTEMS_LEAN_QTT_DEPTH_ALLOW_OVERRIDE=1 \
      SYSTEMS_LEAN_QTT_DEPTH_USECHECK="$ROOT/src/Lean/Compiler/QTT/UseCheck.lean" \
      SYSTEMS_LEAN_QTT_DEPTH_FREESTANDING="$tmpdir/no_such_fs_dir" \
      "$GATE"

# --- 17) Proof-receipt SKIP_QTT_DEPTH emits greppable incomplete tokens (cheap) ---
# Dry-run the skip branch by grepping the receipt script contract + a minimal env simulation:
# we only assert the receipt script source always emits QTT_DEPTH_INCOMPLETE=1 on SKIP
# (full receipt needs freestanding build; this is a greppable contract check).
if [[ -f "$ROOT/script/systems-proof-receipt.sh" ]]; then
  if ! grep -qF 'QTT_DEPTH_SKIPPED=1' "$ROOT/script/systems-proof-receipt.sh" \
    || ! grep -qF 'QTT_DEPTH_INCOMPLETE=1' "$ROOT/script/systems-proof-receipt.sh" \
    || ! grep -qF 'SYSTEMS_LEAN_PROOF_RECEIPT_SKIP_QTT_DEPTH' "$ROOT/script/systems-proof-receipt.sh"; then
    echo "FAIL: systems-proof-receipt.sh missing SKIP_QTT_DEPTH greppable incomplete tokens" >&2
    exit 1
  fi
  echo "OK: proof-receipt SKIP_QTT_DEPTH greppable incomplete contract present"
fi

echo "OK: systems-qtt-depth-check negatives (fail-closed; pure-fvar strip; hollow soup; vacuous all; for/forM/mapM/foldl; quoted-only bif decoy; bif allowlist)"
