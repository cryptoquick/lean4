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

/-!
# Systems.Path (Systems Lean)

Path-**shaped** helpers over dual caller `addr`/`len` byte views — not full `System.FilePath`,
not Windows paths, not UTF-8 decode.

Ops:

* **isAbs** — leading `'/'` (`1`/`0`)
* **hasTrailingSlash** — last byte is `'/'` when non-empty
* **basenameOff** / **basenameLen** — last path component as dual offset/length view
* **joinNeed** / **joinOk** — capacity planning for POSIX-ish join (insert `'/'` when needed)

Honesty:

* **POSIX-ish byte views only** — separator is `'/'` (47). No drive letters, no `\`, no
  Unicode normalization, no symlink / existence checks.
* Basename after a trailing slash is the empty component (`len == 0`).
* Join helpers do **not** copy bytes; they only compute needed size / capacity status.
* Not claimed: full Path API, canonicalization, or OS path resolution.

## Intentional TCB (Path-local)

ASCII `'/'` is a freestanding `@[extern]` axiom kept **here**. Name-pinned on
ComplianceCorpus (`path name=Ident`).
-/

namespace Systems.Path

open Systems.Scalars
open Systems.Bytes
open Systems.Status

/-- ASCII `'/'` (47). -/
@[extern c inline "((uint8_t)47)"] public axiom sep : U8

/-- `1` if `n > 0` and first byte is `'/'`, else `0`. -/
public unsafe def isAbs (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq n USize.zero) U32.zero
    (bifU32 (U8.beq (U8.load addr) sep) U32.one U32.zero)

/-- `1` if `n > 0` and last byte is `'/'`, else `0`. -/
public unsafe def hasTrailingSlash (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq n USize.zero) U32.zero
    (bifU32 (U8.beq (U8.load (USize.add addr (USize.sub n USize.one))) sep) U32.one U32.zero)

/-- Scan for the last `'/'` index in `[0, n)`, starting at `i` with best-so-far `last`.

`last` is `USize.neg1` when no separator has been seen yet. -/
public unsafe def findLastSepGo (addr : USize) (i : USize) (n : USize) (last : USize) : USize :=
  bifUSize (USize.blt i n)
    (bifUSize (U8.beq (U8.load (USize.add addr i)) sep)
      (findLastSepGo addr (USize.add i USize.one) n i)
      (findLastSepGo addr (USize.add i USize.one) n last))
    last

/-- Offset of the last path component (0 if no `'/'`, or just after the last slash). -/
public unsafe def basenameOff (addr : USize) (n : USize) : USize :=
  let last := findLastSepGo addr USize.zero n USize.neg1
  bifUSize (USize.beq last USize.neg1) USize.zero (USize.add last USize.one)

/-- Length of the last path component (`n - basenameOff`; 0 for empty / trailing slash). -/
public unsafe def basenameLen (addr : USize) (n : USize) : USize :=
  let off := basenameOff addr n
  bifUSize (USize.blt n off) USize.zero (USize.sub n off)

/-- Bytes needed to join path `a` (`na` bytes, trailing-slash flag) with path `b` (`nb`).

Does not inspect `b` for absolute form (caller may short-circuit). Inserts one `'/'`
when `a` is non-empty, does not already trail with `'/'`, and `b` is non-empty. -/
public unsafe def joinNeed (na : USize) (aTrail : U32) (nb : USize) : USize :=
  bifUSize (USize.beq na USize.zero) nb
    (bifUSize (USize.beq nb USize.zero) na
      (bifUSize (U32.beq aTrail U32.one) (USize.add na nb)
        (USize.add (USize.add na USize.one) nb)))

/-- Capacity check for join: `0` ok if `cap ≥ joinNeed`, else `errBounds`. -/
public unsafe def joinOk (cap : USize) (na : USize) (aTrail : U32) (nb : USize) : U32 :=
  let need := joinNeed na aTrail nb
  bifU32 (USize.blt cap need) errBounds ok

end Systems.Path
