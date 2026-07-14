#!/usr/bin/env python3
"""Fail-closed: Map/Set rehash bodies must call clear (DCE regress guard).

A discarded `let _c := clear …` is freestanding-EmitC-DCE'd; rehash then skips
zeroing dirty destination tags. Product IR must keep the clear call in the
rehash function body (dataflow-used clear status).
"""
from __future__ import annotations

import pathlib
import re
import sys


def rehash_body(text: str, name: str) -> str:
  # Skip prototype `rehash(...);` — match definition only (`){` after params).
  m = re.search(
    rf"uint32_t\s+lp_systems_Systems_{name}_rehash\s*\([^;]*?\)\s*\{{",
    text,
    re.S,
  )
  if not m:
    raise SystemExit(f"FAIL: missing {name}.rehash definition")
  i = m.end() - 1  # position of opening '{'
  depth = 0
  j = i
  while j < len(text):
    c = text[j]
    if c == "{":
      depth += 1
    elif c == "}":
      depth -= 1
      if depth == 0:
        return text[i : j + 1]
    j += 1
  raise SystemExit(f"FAIL: unclosed {name}.rehash body")


def check(path: pathlib.Path, name: str) -> None:
  if not path.is_file():
    raise SystemExit(f"FAIL: missing {path}")
  body = rehash_body(path.read_text(), name)
  if f"{name}_clear" not in body and "clearGo" not in body:
    raise SystemExit(
      f"FAIL: {name}.rehash IR does not call clear (DCE regress) in {path}"
    )
  print(f"OK: {name}.rehash calls clear")


def main(argv: list[str]) -> int:
  if len(argv) != 5:
    print(
      f"usage: {argv[0]} Map.c Map Set.c Set",
      file=sys.stderr,
    )
    return 2
  check(pathlib.Path(argv[1]), argv[2])
  check(pathlib.Path(argv[3]), argv[4])
  return 0


if __name__ == "__main__":
  raise SystemExit(main(sys.argv))
