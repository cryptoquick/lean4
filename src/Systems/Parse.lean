/-
Copyright (c) 2026 Lean FRO, LLC. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Hunter Beast
-/
module
prelude
public import Systems.Scalars
public import Systems.Numerics
public import Systems.Status
public import Systems.Ascii

/-!
# Systems.Parse (Systems Lean)

Decimal integer parse over dual caller `addr`/`len` byte views — parse-**shaped**,
not full `strtol` / locale / hex / signed / width-prefix scanning.

Ops:

* **parseU32** / **parseU64** — value as `USize`/`U64`, or miss sentinel on failure
* **parseU32Status** / **parseU64Status** — status only (`0` ok, `1` empty/non-digit, `3` overflow)

Leading ASCII spaces (`Ascii.isSpace`) are skipped. At least one digit is required.
No trailing junk allowed: after digits, remaining bytes must be exhausted.

Honesty:

* **Decimal only** — not hex/octal/binary, not signed, not locale thousands separators.
* Not claimed: full C `strtoul`, scientific notation, or multi-field product returns.
* Miss sentinel for `parseU32` is `USize.neg1` (**LP64 harness**); overflow of a valid
  `UINT32_MAX` is status-failed so it never collides with a successful max value.
* `parseU64` miss uses `U64.neg1`; a successful parse of all-ones is therefore
  indistinguishable from miss on value alone — pair with `parseU64Status` when needed.

## Intentional TCB (Parse-local)

Decimal digit constants and overflow ceilings are freestanding `@[extern]` axioms kept
**here** (Ascii parity). Name-pinned on ComplianceCorpus (`path name=Ident`).
-/

namespace Systems.Parse

open Systems.Scalars
open Systems.Numerics
open Systems.Status
open Systems.Ascii

/-- ASCII `'0'` (48). -/
@[extern c inline "((uint32_t)48)"] public axiom c0 : U32
/-- Ten (decimal radix). -/
@[extern c inline "((uint32_t)10)"] public axiom tenU32 : U32
/-- Ten as `U64`. -/
@[extern c inline "((uint64_t)10)"] public axiom tenU64 : U64
/-- `UINT32_MAX / 10` (429496729). -/
@[extern c inline "((uint32_t)429496729)"] public axiom u32MaxDiv10 : U32
/-- `UINT32_MAX % 10` (5). -/
@[extern c inline "((uint32_t)5)"] public axiom u32MaxMod10 : U32
/-- `UINT64_MAX / 10` (1844674407370955161). -/
@[extern c inline "((uint64_t)1844674407370955161ULL)"] public axiom u64MaxDiv10 : U64
/-- `UINT64_MAX % 10` (5). -/
@[extern c inline "((uint64_t)5)"] public axiom u64MaxMod10 : U64
/-- Widen `U32` → `USize`. -/
@[extern c inline "((size_t)(uint32_t)(#1))"]
public axiom USize.ofU32 : U32 → USize
/-- Widen `U32` → `U64`. -/
@[extern c inline "((uint64_t)(uint32_t)(#1))"]
public axiom U64.ofU32 : U32 → U64

/-- Skip leading spaces starting at index `i`. Returns first non-space index (or `n`). -/
public unsafe def skipSpaces (addr : USize) (n : USize) (i : USize) : USize :=
  bifUSize (USize.blt i n)
    (bifUSize (U32.beq (isSpace (U32.ofU8 (U8.load (USize.add addr i)))) U32.one)
      (skipSpaces addr n (USize.add i USize.one))
      i)
    i

/-- Digit value of ASCII `c` (`c - '0'`); caller must ensure `isDigit c`. -/
@[inline] public def digitVal (c : U32) : U32 :=
  U32.sub c c0

/-- `1` if multiplying `acc` by 10 and adding `d` would overflow `U32`. -/
public def u32WouldOverflow (acc : U32) (d : U32) : U32 :=
  bifU32 (U32.blt u32MaxDiv10 acc) U32.one
    (bifU32 (U32.beq acc u32MaxDiv10)
      (bifU32 (U32.blt u32MaxMod10 d) U32.one U32.zero)
      U32.zero)

/-- `1` if multiplying `acc` by 10 and adding `d` would overflow `U64`. -/
public def u64WouldOverflow (acc : U64) (d : U64) : U32 :=
  bifU32 (U64.blt u64MaxDiv10 acc) U32.one
    (bifU32 (U64.beq acc u64MaxDiv10)
      (bifU32 (U64.blt u64MaxMod10 d) U32.one U32.zero)
      U32.zero)

/-- Parse loop status: `acc` is the running value, `i` the next index, `seen` if any digit.

Returns `0` ok (consumed to `n` with ≥1 digit), `1` empty/non-digit, `3` overflow. -/
public unsafe def parseU32Go (addr : USize) (n : USize) (i : USize) (acc : U32) (seen : U32) : U32 :=
  bifU32 (USize.blt i n)
    (let c := U32.ofU8 (U8.load (USize.add addr i))
     bifU32 (U32.beq (isDigit c) U32.one)
       (let d := digitVal c
        bifU32 (U32.beq (u32WouldOverflow acc d) U32.one) errBounds
          (parseU32Go addr n (USize.add i USize.one) (U32.add (U32.mul acc tenU32) d) U32.one))
       (bifU32 (U32.beq seen U32.one) err err))
    (bifU32 (U32.beq seen U32.one) ok err)

/-- Value-accumulating loop paired with `parseU32Go` (same control). -/
public unsafe def parseU32ValGo (addr : USize) (n : USize) (i : USize) (acc : U32) (seen : U32) : USize :=
  bifUSize (USize.blt i n)
    (let c := U32.ofU8 (U8.load (USize.add addr i))
     bifUSize (U32.beq (isDigit c) U32.one)
       (let d := digitVal c
        bifUSize (U32.beq (u32WouldOverflow acc d) U32.one) USize.neg1
          (parseU32ValGo addr n (USize.add i USize.one) (U32.add (U32.mul acc tenU32) d) U32.one))
       USize.neg1)
    (bifUSize (U32.beq seen U32.one) (USize.ofU32 acc) USize.neg1)

/-- Status of decimal `U32` parse: `0` ok, `1` empty/non-digit, `3` overflow. -/
public unsafe def parseU32Status (addr : USize) (n : USize) : U32 :=
  let i := skipSpaces addr n USize.zero
  parseU32Go addr n i U32.zero U32.zero

/-- Decimal `U32` parse as `USize` value, or `USize.neg1` on failure.

**LP64 only** for the miss sentinel. Pair with `parseU32Status` when distinguishing
empty vs overflow. -/
public unsafe def parseU32 (addr : USize) (n : USize) : USize :=
  let i := skipSpaces addr n USize.zero
  parseU32ValGo addr n i U32.zero U32.zero

/-- U64 parse loop (status). -/
public unsafe def parseU64Go (addr : USize) (n : USize) (i : USize) (acc : U64) (seen : U32) : U32 :=
  bifU32 (USize.blt i n)
    (let c := U32.ofU8 (U8.load (USize.add addr i))
     bifU32 (U32.beq (isDigit c) U32.one)
       (let d := U64.ofU32 (digitVal c)
        bifU32 (U32.beq (u64WouldOverflow acc d) U32.one) errBounds
          (parseU64Go addr n (USize.add i USize.one) (U64.add (U64.mul acc tenU64) d) U32.one))
       (bifU32 (U32.beq seen U32.one) err err))
    (bifU32 (U32.beq seen U32.one) ok err)

/-- U64 value loop. -/
public unsafe def parseU64ValGo (addr : USize) (n : USize) (i : USize) (acc : U64) (seen : U32) : U64 :=
  bifU64 (USize.blt i n)
    (let c := U32.ofU8 (U8.load (USize.add addr i))
     bifU64 (U32.beq (isDigit c) U32.one)
       (let d := U64.ofU32 (digitVal c)
        bifU64 (U32.beq (u64WouldOverflow acc d) U32.one) U64.neg1
          (parseU64ValGo addr n (USize.add i USize.one) (U64.add (U64.mul acc tenU64) d) U32.one))
       U64.neg1)
    (bifU64 (U32.beq seen U32.one) acc U64.neg1)

/-- Status of decimal `U64` parse: `0` ok, `1` empty/non-digit, `3` overflow. -/
public unsafe def parseU64Status (addr : USize) (n : USize) : U32 :=
  let i := skipSpaces addr n USize.zero
  parseU64Go addr n i U64.zero U32.zero

/-- Decimal `U64` parse, or `U64.neg1` on failure (pair with status when value may be all-ones). -/
public unsafe def parseU64 (addr : USize) (n : USize) : U64 :=
  let i := skipSpaces addr n USize.zero
  parseU64ValGo addr n i U64.zero U32.zero

end Systems.Parse
