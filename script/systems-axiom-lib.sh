# Shared Lean `axiom` declaration parsing for Systems Lean TCB gates.
# Sourced by systems-axiom-check.sh and systems-product-stdlib-check.sh.
# SSoT for attr/modifier strip + name extract (avoid dual-maintained parsers).
#
# Requires: bash with associative arrays available in the caller.
# Does not set -e/-u (caller owns shell options).

# Match Lean `axiom` keyword (not as part of a longer identifier).
# shellcheck disable=SC2034
SYSTEMS_LEAN_AXIOM_LINE_RE='(^|[^A-Za-z_])axiom([^A-Za-z_]|$)'

# Lean declaration modifiers that may precede `axiom` (order-insensitive; stacked OK).
# shellcheck disable=SC2034
SYSTEMS_LEAN_AXIOM_MOD_RE='^(public|protected|private|meta|noncomputable|unsafe|partial|local)[[:space:]]+(.*)$'

# Strip leading balanced @[…] attribute blocks (quote-aware brackets) then peel modifiers.
systems_lean_strip_attrs_and_modifiers() {
  local clean="$1"
  local depth i c found in_str q
  local mod_re="${SYSTEMS_LEAN_AXIOM_MOD_RE}"
  while true; do
    clean="${clean#"${clean%%[![:space:]]*}"}"
    if [[ "$clean" != @\[* ]]; then
      break
    fi
    depth=0
    found=0
    in_str=0
    q=""
    for ((i = 0; i < ${#clean}; i++)); do
      c="${clean:i:1}"
      if [[ "$in_str" -eq 1 ]]; then
        if [[ "$c" == '\' ]]; then
          i=$((i + 1))
          continue
        fi
        if [[ "$c" == "$q" ]]; then
          in_str=0
          q=""
        fi
        continue
      fi
      if [[ "$c" == '"' || "$c" == "'" ]]; then
        in_str=1
        q="$c"
        continue
      fi
      if [[ "$c" == '[' ]]; then
        depth=$((depth + 1))
      elif [[ "$c" == ']' ]]; then
        depth=$((depth - 1))
        if [[ "$depth" -eq 0 ]]; then
          clean="${clean:i+1}"
          found=1
          break
        fi
      fi
    done
    if [[ "$found" -ne 1 ]]; then
      break
    fi
  done
  clean="${clean#"${clean%%[![:space:]]*}"}"
  while [[ "$clean" =~ $mod_re ]]; do
    clean="${BASH_REMATCH[2]}"
    clean="${clean#"${clean%%[![:space:]]*}"}"
  done
  printf '%s' "$clean"
}

# If cleaned line is declaration-shaped `axiom Name …`, print name; else print nothing.
systems_lean_extract_axiom_name() {
  local clean rest name
  clean="$(systems_lean_strip_attrs_and_modifiers "$1")"
  if [[ ! "$clean" =~ ^axiom([[:space:]]|$) ]]; then
    return 0
  fi
  rest="${clean#axiom}"
  rest="${rest#"${rest%%[![:space:]]*}"}"
  if [[ -z "$rest" ]]; then
    printf '%s' ''
    return 0
  fi
  name=""
  # Dotted idents (Arena.free, U32.bswap). Apostrophe idents rare in FS TCB.
  if [[ "$rest" == «* ]]; then
    if [[ "$rest" =~ ^«([^»]+)» ]]; then
      name="${BASH_REMATCH[1]}"
    fi
  elif [[ "$rest" =~ ^([A-Za-z_][A-Za-z0-9_.]*) ]]; then
    name="${BASH_REMATCH[1]}"
  fi
  printf '%s' "$name"
}

# True when line is declaration-shaped after attr + modifier strip.
systems_lean_is_axiom_decl_line() {
  local clean
  clean="$(systems_lean_strip_attrs_and_modifiers "$1")"
  [[ "$clean" =~ ^axiom([[:space:]]|$) ]]
}
