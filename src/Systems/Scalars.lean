/-
Copyright (c) 2026 Lean FRO, LLC. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Hunter Beast
-/
module
prelude

/-!
# Systems.Scalars (Systems Lean)

Closed freestanding scalar prelude for **Systems Lean** extracts.
Canonical docs: `doc/dev/systems-lean.md`. In-tree optional library (`lake build Systems`).
Prefer Lake `freestanding := true` (forces `compiler.freestanding=true`; see `LeanLib.freestandingFacet`).
No `Init` import.

Uses `axiom` (not `opaque`) so we need no `Inhabited`/`Nonempty` instances from Init.
The compiler type table maps these names to unboxed impure scalars; LCNF preserves the axiom
names (so no `lcAny`/`Init.Prelude` pseudo-constants are required — I6 host import stays open).

## ABI + control flow (summary)

* Dual scalar params for buffer access (`addr`/`len` as `USize`) — no freestanding multi-field products.
* Pointer byte load (`U8.load`) is a first-class freestanding op.
* Control flow: freestanding `Bool` (inductive, unboxed `uint8_t`) + specialized `bifU32` /
  `bifU64` / `bifUSize` / `bifBool` via `.casesOn` (no Init `ite`/`Decidable`/`match`/`PProd`).
  Loops use recursive `unsafe` helpers whose LCNF lowers to C locals + `if`/`goto`.
* Public **non-inline** Lean helpers in this module (e.g. `checksumGo`, `memEqGo`) are freestanding
  emit roots — emitted into this module's `.c` with external mangled linkage. `@[inline]` ops are
  not package roots. Callers in other freestanding modules may `extern`-call them; consumers link
  contributing archives (happy path: one `freestanding.bundle`).

### Supported control-flow surface

| Feature | Status |
|---------|--------|
| `Bool` / `Bool.true` / `Bool.false` | yes (unboxed `uint8_t`, tags 0/1; not auto-exported) |
| `USize.blt` / `USize.beq` / `U8.beq` → `Bool` | yes |
| `bifU32` / `bifU64` / `bifUSize` / `bifBool` / `Bool.casesOn` | yes (`@[macro_inline]`; specialized) |
| Tail-recursive scalar loops (`unsafe`) | yes → C `if` + `goto` + param reassignment |
| Cross-module public Lean helpers | yes (defining module emits body) |
| Init `if` / `ite` / `Decidable` | **no** (no Init import) |
| Init `match` elaborator | **no** (needs root `PProd`/`PUnit`; host clash) |
| `do` / surface `mut` syntax | **no** (needs monads / Init); use recursive SSA / TCO instead |
| Full ML refs / `IO.Ref` | **no** (out of scope) |

### Still C-inline (tiny primops)

Arena create/alloc, write-all, mmap helpers, and log temps use Lean freestanding control-flow
and/or ISO C11 expressions (casts, comma, ternary, C99 compound literals). Residual short
`@[extern c inline]` fragments remain for single libc calls and header field load/store —
**no** GNU statement expressions `({…})`.
-/

namespace Systems.Scalars

/-- 8-bit word for freestanding extract. -/
public axiom U8 : Type

/-- 16-bit word for freestanding extract. -/
public axiom U16 : Type

/-- 32-bit word. -/
public axiom U32 : Type

/-- 64-bit word for freestanding extract. Not host `UInt64`. -/
public axiom U64 : Type

/-- Pointer-sized word. EmitC maps this to C `size_t` (same width as a pointer on LP64/LLP64).
Addresses passed from C are pointer bitcasts into `size_t`. -/
public axiom USize : Type

/-! ## Freestanding Bool

Inductive so `.casesOn` exists under freestanding (compiler generates it without root `PUnit`).
Mapped to unboxed `uint8_t` (false=0, true=1). Not host `Bool`.
-/

/-- Freestanding boolean. EmitC / impure type table: `uint8_t`.

Constructors are **not** `export`ed as bare `false`/`true` so host modules that
`open Systems.Scalars` do not shadow Init `Bool` constructors. Use `Bool.false` /
`Bool.true` (or stay under this namespace). -/
public inductive Bool : Type where
  | false : Bool
  | true : Bool

/-! ## U8 -/

/-- Load one byte at address `addr` (`*((const uint8_t*)addr)`). Exercised by `lean_fs_load_u8`. -/
@[extern c inline "*((const uint8_t*)(#1))"] public axiom U8.load : USize → U8

/-- Widen `U8` → `USize` (ISO C cast). -/
@[extern c inline "((size_t)(uint8_t)(#1))"] public axiom USize.ofU8 : U8 → USize

/-- Load host-endian `uint32_t` at `addr`, promoted to `size_t` (ISO C; no GNU stmt expr). -/
@[extern c inline "((size_t)(*((const uint32_t*)(#1))))"] public axiom USize.loadU32 : USize → USize

/-- Byte equality as raw `uint8_t` 0/1. -/
@[extern c inline "(uint8_t)((uint8_t)(#1) == (uint8_t)(#2))"] public axiom U8.beqU8 : U8 → U8 → U8

/-! ## U32 -/

@[extern c inline "#1 + #2"] public axiom U32.add : U32 → U32 → U32
@[extern c inline "#1 - #2"] public axiom U32.sub : U32 → U32 → U32
@[extern c inline "#1 * #2"] public axiom U32.mul : U32 → U32 → U32
@[extern c inline "#1 ^ #2"] public axiom U32.xor : U32 → U32 → U32
/-- Zero constant (digit-only pattern; type fixed by freestanding C assignment). -/
@[extern c inline "0"] public axiom U32.zero : U32
/-- One constant. -/
@[extern c inline "1"] public axiom U32.one : U32
/-- Multiplier constant for documentation / freestanding checksum folds. -/
@[extern c inline "31"] public axiom U32.k31 : U32
/-- Widen `U8` → `U32` via C integer conversion on assignment. -/
@[extern c inline "(#1)"] public axiom U32.ofU8 : U8 → U32
/-- Narrow `USize` → `U8` (low byte). -/
@[extern c inline "((uint8_t)(#1))"] public axiom U8.ofUSize : USize → U8
/-- Equality as raw `uint8_t` 0/1. -/
@[extern c inline "(uint8_t)((uint32_t)(#1) == (uint32_t)(#2))"] public axiom U32.beqU8 : U32 → U32 → U8
/-- Status constant 2 (e.g. log put seek failure / key-cmp IO). -/
@[extern c inline "2"] public axiom U32.two : U32
/-- Status constant 3 (e.g. log put write failure). -/
@[extern c inline "3"] public axiom U32.three : U32

/-! ## U64 -/

@[extern c inline "#1 + #2"] public axiom U64.add : U64 → U64 → U64
@[extern c inline "#1 - #2"] public axiom U64.sub : U64 → U64 → U64
@[extern c inline "#1 * #2"] public axiom U64.mul : U64 → U64 → U64

/-! ## USize -/

@[extern c inline "#1 + #2"] public axiom USize.add : USize → USize → USize
@[extern c inline "#1 - #2"] public axiom USize.sub : USize → USize → USize
@[extern c inline "0"] public axiom USize.zero : USize
@[extern c inline "1"] public axiom USize.one : USize
@[extern c inline "4"] public axiom USize.four : USize
@[extern c inline "8"] public axiom USize.eight : USize
/-- All-bits-one `size_t` (not-found / error sentinel on LP64). -/
@[extern c inline "((size_t)-1)"] public axiom USize.neg1 : USize
/-- `(size_t)-2` IO/corrupt sentinel. -/
@[extern c inline "((size_t)-2)"] public axiom USize.neg2 : USize
/-- `(size_t)-3` buffer-too-small / EOF-mid-header sentinel. -/
@[extern c inline "((size_t)-3)"] public axiom USize.neg3 : USize
/-- Unsigned `<` as raw `uint8_t` 0/1 (C comparison). Prefer `USize.blt` for Lean branches. -/
@[extern c inline "(uint8_t)(#1 < #2)"] public axiom USize.bltU8 : USize → USize → U8
/-- Equality as raw `uint8_t` 0/1. -/
@[extern c inline "(uint8_t)((size_t)(#1) == (size_t)(#2))"] public axiom USize.beqU8 : USize → USize → U8
/-- Unsigned `>` as raw `uint8_t` 0/1. -/
@[extern c inline "(uint8_t)((size_t)(#1) > (size_t)(#2))"] public axiom USize.bgtU8 : USize → USize → U8
/-- Narrow check: `x == (size_t)(uint32_t)x` (overflow gate before uint32 store). -/
@[extern c inline "(uint8_t)((size_t)(#1) == (size_t)(uint32_t)(#1))"] public axiom USize.fitsU32U8 : USize → U8
/-- `a > (size_t)-1 - b` style overflow test: `(uint8_t)(a > ~ (size_t)0 - b)`. -/
@[extern c inline "(uint8_t)((size_t)(#1) > ((size_t)-1 - (size_t)(#2)))"] public axiom USize.uaddOverflowU8 : USize → USize → U8

/-- Coerce nonzero `U8` to freestanding `Bool.true` (else `false`). -/
@[extern c inline "((uint8_t)(#1) != 0)"] public axiom Bool.ofU8 : U8 → Bool

/-- Unsigned `<` as freestanding `Bool` for `bif*` / loops. -/
@[inline] public def USize.blt (a b : USize) : Bool :=
  Bool.ofU8 (USize.bltU8 a b)

/-- Equality as freestanding `Bool`. -/
@[inline] public def USize.beq (a b : USize) : Bool :=
  Bool.ofU8 (USize.beqU8 a b)

/-- Unsigned `>` as freestanding `Bool`. -/
@[inline] public def USize.bgt (a b : USize) : Bool :=
  Bool.ofU8 (USize.bgtU8 a b)

/-- True when `x` fits in `uint32_t` without truncation. -/
@[inline] public def USize.fitsU32 (x : USize) : Bool :=
  Bool.ofU8 (USize.fitsU32U8 x)

/-- True when `a + b` would overflow `size_t` (i.e. `a > SIZE_MAX - b`). -/
@[inline] public def USize.uaddWouldOverflow (a b : USize) : Bool :=
  Bool.ofU8 (USize.uaddOverflowU8 a b)

/-- Byte equality as freestanding `Bool`. -/
@[inline] public def U8.beq (a b : U8) : Bool :=
  Bool.ofU8 (U8.beqU8 a b)

/-- U32 equality as freestanding `Bool`. -/
@[inline] public def U32.beq (a b : U32) : Bool :=
  Bool.ofU8 (U32.beqU8 a b)

/-- Branch on freestanding `Bool` for `U32` results via `.casesOn`.

Specialized (not polymorphic): freestanding LCNF rejects polymorphic `lcAny` motives.
Not Init `ite`/`cond` — both of those need Init.

`@[macro_inline]` (like host `cond`/`ite`): applications unfold **before** ANF so arms are not
evaluated until after the branch. Plain `@[inline]` alone can ANF-evaluate both `U32` args first
and turn a recursive loop into always-recurse. -/
@[macro_inline, expose] public def bifU32 (c : Bool) (t e : U32) : U32 :=
  Bool.casesOn (motive := fun _ => U32) c e t

/-- Branch on freestanding `Bool` for `U64` results (BitVec width/mask helpers). -/
@[macro_inline, expose] public def bifU64 (c : Bool) (t e : U64) : U64 :=
  Bool.casesOn (motive := fun _ => U64) c e t

/-- Branch on freestanding `Bool` for `USize` results (log get status / lengths). -/
@[macro_inline, expose] public def bifUSize (c : Bool) (t e : USize) : USize :=
  Bool.casesOn (motive := fun _ => USize) c e t

/-- Branch on freestanding `Bool` for `Bool` results (key-equality scan). -/
@[macro_inline, expose] public def bifBool (c : Bool) (t e : Bool) : Bool :=
  Bool.casesOn (motive := fun _ => Bool) c e t

/-- One polynomial checksum step: `acc * 31 + byte` (freestanding scalar ops only). -/
@[inline] public def checksumStep (acc : U32) (byte : U8) : U32 :=
  U32.add (U32.mul acc U32.k31) (U32.ofU8 byte)

/-! ## multi-module Lean helpers (emitted in this module's .c)

Public non-inline helpers are packaged for cross-module freestanding calls .
-/

/-- Byte-range equality over two addresses (Lean loop + `U8.load`).

`unsafe` — freestanding has no WF/`Nat` termination; runtime stops when `i` reaches `n`. -/
public unsafe def memEqGo (a : USize) (b : USize) (i : USize) (n : USize) : Bool :=
  bifBool (USize.blt i n)
    (bifBool (U8.beq (U8.load (USize.add a i)) (U8.load (USize.add b i)))
      (memEqGo a b (USize.add i USize.one) n)
      Bool.false)
    Bool.true

/-- Loop body for polynomial checksum (freestanding control-flow).

Public so other freestanding modules (e.g. `Extract`) can call it; EmitC emits an external
mangled symbol in this module's `.c` (not part of the documented `lean_fs_*` ABI).
`unsafe` — no freestanding WF; terminates when `i` reaches `len` (unsigned). -/
public unsafe def checksumGo (addr : USize) (len : USize) (i : USize) (acc : U32) : U32 :=
  bifU32 (USize.blt i len)
    (checksumGo addr len (USize.add i USize.one)
      (checksumStep acc (U8.load (USize.add addr i))))
    acc

end Systems.Scalars
