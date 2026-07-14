/-
Copyright (c) 2026 Lean FRO, LLC. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Hunter Beast
-/
module
prelude
public import Systems.Scalars
public import Systems.Bytes
public import Systems.Status
public import Systems.Numerics

/-!
# Systems.YamlQuery (Systems Lean)

YAML-**shaped** key lookup scan over dual caller `addr`/`len` byte views — not full
YAML 1.2, not a typed document graph, not table-scoped path queries, not
malloc-backed maps of keys. Twin of `TomlQuery` for `key: value` lines.

Ops (query-focused residual-clean surface):

* **validate** / **scan** — `0` if `n ≥ 1`, else `1` (too short); when long enough,
  probes first byte and folds it with `land 0` so dual-param `addr` is live
* **findKey** — value-start offset after matching `key:` plus optional spaces, or miss
* **hasKey** — presence helper
* **spanEq** / **findKeyEq** — byte-span equality helpers used by lookup

Honesty:

* **Simple byte scan** — finds the first occurrence of exact key bytes followed by
  `:` (not line-oriented full YAML structure, no multi-document `---`, no anchors,
  no flow collections, no multi-line scalars, no typed tags).
* **validate status is length-class only** (`ok`/`err`); the first-byte probe never
  changes the status value (`land` with zero) but keeps `addr` on the EmitC result path
  when `n ≥ 1`. Key/colon legality beyond the min fence is not enforced by validate.
* Miss sentinel is `USize.neg1` (**LP64 harness**).

## Intentional TCB (YamlQuery-local)

Structural ASCII markers and min-1 fence are freestanding `@[extern]` axioms kept
**here**. Name-pinned on ComplianceCorpus (`path name=Ident`).
-/

namespace Systems.YamlQuery

open Systems.Scalars
open Systems.Bytes
open Systems.Status
open Systems.Numerics

/-- Minimum non-empty document length for validate/scan (1). -/
@[extern c inline "((size_t)1)"] public axiom minLen : USize
/-- ASCII `':'` (58). -/
@[extern c inline "((uint32_t)58)"] public axiom cColon : U32
/-- ASCII space (32). -/
@[extern c inline "((uint32_t)32)"] public axiom cSp : U32
/-- ASCII tab (9). -/
@[extern c inline "((uint32_t)9)"] public axiom cTab : U32

/-- Load byte at index as `U32`. Caller ensures bounds. -/
public unsafe def loadAt (addr : USize) (i : USize) : U32 :=
  U32.ofU8 (U8.load (USize.add addr i))

/-- `1` if `c` is space or tab. -/
public unsafe def isWs (c : U32) : U32 :=
  bifU32 (U32.beq c cSp) U32.one
    (bifU32 (U32.beq c cTab) U32.one U32.zero)

/-- Skip leading spaces/tabs in `[i, hi)`. -/
public unsafe def skipWs (addr : USize) (i : USize) (hi : USize) : USize :=
  bifUSize (USize.blt i hi)
    (bifUSize (U32.beq (isWs (loadAt addr i)) U32.one)
      (skipWs addr (USize.add i USize.one) hi) i)
    i

/-- `1` if spans `[a,a+n)` and `[b,b+n)` are equal. -/
public unsafe def spanEqGo (a : USize) (b : USize) (i : USize) (n : USize) : U32 :=
  bifU32 (USize.blt i n)
    (bifU32 (U8.beq (U8.load (USize.add a i)) (U8.load (USize.add b i)))
      (spanEqGo a b (USize.add i USize.one) n)
      U32.zero)
    U32.one

/-- `1` if equal length-`n` spans match. -/
public unsafe def spanEq (a : USize) (b : USize) (n : USize) : U32 :=
  spanEqGo a b USize.zero n

/-- Alias of `spanEq` (findKey key-equality helper). -/
public unsafe def findKeyEq (a : USize) (b : USize) (n : USize) : U32 :=
  spanEq a b n

/-- `0` if `n ≥ 1`, else `1`.

When `n ≥ 1`, loads first byte and folds it with `U32.land _ U32.zero` so dual-param
`addr` stays on the EmitC result path. Status remains length-class only (probe never
contributes a nonzero bit). Does not inspect `key:` structure. -/
public unsafe def validate (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n minLen) err
    (U32.land (loadAt addr USize.zero) U32.zero)

/-- Alias of `validate`. -/
public unsafe def scan (addr : USize) (n : USize) : U32 :=
  validate addr n

/-- Scan from `i` for exact key + `:` match; return value start (after colon+ws), or miss.

Requires `i + keyLen < n` so the colon index is in range. -/
public unsafe def findKeyGo (addr : USize) (i : USize) (n : USize)
    (keyAddr : USize) (keyLen : USize) : USize :=
  bifUSize (USize.blt (USize.add i keyLen) n)
    (bifUSize (U32.beq (findKeyEq (USize.add addr i) keyAddr keyLen) U32.one)
      (let colonAt := USize.add i keyLen
       bifUSize (U32.beq (loadAt addr colonAt) cColon)
         (skipWs addr (USize.add colonAt USize.one) n)
         (findKeyGo addr (USize.add i USize.one) n keyAddr keyLen))
      (findKeyGo addr (USize.add i USize.one) n keyAddr keyLen))
    USize.neg1

/-- Value-start offset of first matching `key:` (after colon + optional spaces), or miss.

Empty keys miss. First match wins (no document scoping). **LP64 miss.** -/
public unsafe def findKey (addr : USize) (n : USize)
    (keyAddr : USize) (keyLen : USize) : USize :=
  bifUSize (USize.beq keyLen USize.zero) USize.neg1
    (findKeyGo addr USize.zero n keyAddr keyLen)

/-- `1` if a matching `key:` exists, else `0`. -/
public unsafe def hasKey (addr : USize) (n : USize)
    (keyAddr : USize) (keyLen : USize) : U32 :=
  bifU32 (USize.beq (findKey addr n keyAddr keyLen) USize.neg1) U32.zero U32.one

end Systems.YamlQuery
