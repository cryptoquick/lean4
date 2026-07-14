#!/usr/bin/env bash
set -euo pipefail

# Prefer LAKE from the environment; else stage1 lake in this lean4 tree; else plain `lake` on PATH.
# This script lives at tests/lake/examples/systems/ — four parents reach lean4 root
# (lib/lakefile.lean uses five parents from lib/). Do not add a fifth `..` here.
if [[ -z "${LAKE:-}" ]]; then
  root="$(cd "$(dirname "$0")/../../../.." && pwd)"
  if [[ -x "$root/build/release/stage1/bin/lake" ]]; then
    LAKE="$root/build/release/stage1/bin/lake"
    # Gate tests invoke bare `lean`; put stage1 bin first so discovery is self-contained.
    export PATH="$root/build/release/stage1/bin:$PATH"
  elif command -v lake >/dev/null 2>&1; then
    LAKE=lake
  else
    echo "error: lake not found; set LAKE= or build stage1" >&2
    exit 1
  fi
fi

./clean.sh

# S0–S13 freestanding extract + S6 host erased proofs (K9 dual pipeline)
LAKE=$LAKE make run check
