/-
Copyright (c) 2026 Lean FRO, LLC. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Hunter Beast
-/
module
prelude
public import Systems.Scalars
public import Systems.Bytes
public import Systems.Numerics
public import Systems.Status

/-!
# Systems.Fmt (Systems Lean)

Decimal integer format into a caller-owned `U8` buffer (`addr`/`cap`) — format-**shaped**,
not full `printf` / locale / float / width/precision flags.

Ops:

* **fmtU32** / **fmtU64** — write length as `USize`, or miss sentinel if buffer too small
* **fmtU32Status** / **fmtU64Status** — status only (`0` ok, `3` bounds)
* **digitCountU32** / **digitCountU64** — decimal width without writing

Honesty:

* **Decimal only** — not hex/octal, not signed, not locale thousands separators, not floats.
* Inverse shape of `Systems.Parse` (parse over dual `addr`/`len`).
* No NUL terminator is written; the write length is the return value.
* Miss sentinel for length APIs is `USize.neg1` (**LP64 harness**). Pair with status when needed.
* Store status is dataflow-used so EmitC cannot DCE digit writes.

## Intentional TCB (Fmt-local)

Decimal radix, digit base, and unsigned div/mod are freestanding `@[extern]` axioms kept
**here** (Parse parity). Name-pinned on ComplianceCorpus (`path name=Ident`).
-/

namespace Systems.Fmt

open Systems.Scalars
open Systems.Bytes
open Systems.Numerics
open Systems.Status

/-- ASCII `'0'` (48). -/
@[extern c inline "((uint32_t)48)"] public axiom c0 : U32
/-- Ten (decimal radix). -/
@[extern c inline "((uint32_t)10)"] public axiom tenU32 : U32
/-- Ten as `U64`. -/
@[extern c inline "((uint64_t)10)"] public axiom tenU64 : U64
/-- Unsigned `U32` divide. Caller must keep divisor ≠ 0. -/
@[extern c inline "((uint32_t)((uint32_t)(#1) / (uint32_t)(#2)))"]
public axiom U32.div : U32 → U32 → U32
/-- Unsigned `U32` modulo. Caller must keep divisor ≠ 0. -/
@[extern c inline "((uint32_t)((uint32_t)(#1) % (uint32_t)(#2)))"]
public axiom U32.mod : U32 → U32 → U32
/-- Unsigned `U64` divide. Caller must keep divisor ≠ 0. -/
@[extern c inline "((uint64_t)((uint64_t)(#1) / (uint64_t)(#2)))"]
public axiom U64.div : U64 → U64 → U64
/-- Unsigned `U64` modulo. Caller must keep divisor ≠ 0. -/
@[extern c inline "((uint64_t)((uint64_t)(#1) % (uint64_t)(#2)))"]
public axiom U64.mod : U64 → U64 → U64
/-- Widen `U32` → `USize`. -/
@[extern c inline "((size_t)(uint32_t)(#1))"]
public axiom USize.ofU32 : U32 → USize
/-- Narrow `U32` digit → `U8` (low byte; digit values are `0..9`). -/
@[extern c inline "((uint8_t)(uint32_t)(#1))"]
public axiom U8.ofU32 : U32 → U8
/-- Narrow `U64` digit → `U32` (low 32 bits; digit values are `0..9`). -/
@[extern c inline "((uint32_t)(uint64_t)(#1))"]
public axiom U32.ofU64 : U64 → U32

/-- Decimal digit count of `v` (at least 1 for `0`). Accumulator starts at `1`. -/
public unsafe def digitCountU32Go (v : U32) (n : USize) : USize :=
  bifUSize (U32.blt v tenU32) n
    (digitCountU32Go (U32.div v tenU32) (USize.add n USize.one))

/-- Decimal digit width of `v` as `USize` (`1` for zero). -/
public unsafe def digitCountU32 (v : U32) : USize :=
  digitCountU32Go v USize.one

/-- Decimal digit count of `v` (at least 1 for `0`). Accumulator starts at `1`. -/
public unsafe def digitCountU64Go (v : U64) (n : USize) : USize :=
  bifUSize (U64.blt v tenU64) n
    (digitCountU64Go (U64.div v tenU64) (USize.add n USize.one))

/-- Decimal digit width of `v` as `USize` (`1` for zero). -/
public unsafe def digitCountU64 (v : U64) : USize :=
  digitCountU64Go v USize.one

/-- Write decimal digits of `v` into `[addr, addr+pos)` right-aligned ending at `pos`.

`pos` is the exclusive end index (write length). Store status is dataflow-used. -/
public unsafe def fmtU32WriteGo (addr : USize) (pos : USize) (v : U32) : U32 :=
  let d := U32.mod v tenU32
  let ch := U8.ofU32 (U32.add c0 d)
  let st := U8.store (USize.add addr (USize.sub pos USize.one)) ch
  bifU32 (isOk st)
    (bifU32 (U32.blt v tenU32) ok
      (fmtU32WriteGo addr (USize.sub pos USize.one) (U32.div v tenU32)))
    st

/-- Status of decimal `U32` format: `0` ok, `3` if `cap` is too small. -/
public unsafe def fmtU32Status (addr : USize) (cap : USize) (v : U32) : U32 :=
  let need := digitCountU32 v
  bifU32 (USize.blt cap need) errBounds
    (fmtU32WriteGo addr need v)

/-- Decimal `U32` format: write length, or `USize.neg1` if buffer too small.

**LP64 only** for the miss sentinel. Pair with `fmtU32Status` when needed. -/
public unsafe def fmtU32 (addr : USize) (cap : USize) (v : U32) : USize :=
  let need := digitCountU32 v
  bifUSize (USize.blt cap need) USize.neg1
    (let st := fmtU32WriteGo addr need v
     bifUSize (isOk st) need USize.neg1)

/-- Write decimal digits of `v` into `[addr, addr+pos)` right-aligned ending at `pos`. -/
public unsafe def fmtU64WriteGo (addr : USize) (pos : USize) (v : U64) : U32 :=
  let d := U32.ofU64 (U64.mod v tenU64)
  let ch := U8.ofU32 (U32.add c0 d)
  let st := U8.store (USize.add addr (USize.sub pos USize.one)) ch
  bifU32 (isOk st)
    (bifU32 (U64.blt v tenU64) ok
      (fmtU64WriteGo addr (USize.sub pos USize.one) (U64.div v tenU64)))
    st

/-- Status of decimal `U64` format: `0` ok, `3` if `cap` is too small. -/
public unsafe def fmtU64Status (addr : USize) (cap : USize) (v : U64) : U32 :=
  let need := digitCountU64 v
  bifU32 (USize.blt cap need) errBounds
    (fmtU64WriteGo addr need v)

/-- Decimal `U64` format: write length, or `USize.neg1` if buffer too small. -/
public unsafe def fmtU64 (addr : USize) (cap : USize) (v : U64) : USize :=
  let need := digitCountU64 v
  bifUSize (USize.blt cap need) USize.neg1
    (let st := fmtU64WriteGo addr need v
     bifUSize (isOk st) need USize.neg1)

end Systems.Fmt
