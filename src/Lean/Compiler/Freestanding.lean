/-
Copyright (c) 2026 Lean FRO, LLC. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Hunter Beast
-/
module

prelude
public import Lean.Environment
public import Lean.Compiler.ModPkgExt
public import Lean.Compiler.Options

public section

namespace Lean.Compiler

/-- Impure scalar kind for freestanding type-table mapping (K18). -/
public inductive FreestandingScalarKind where
  | uint8 | uint16 | uint32 | uint64 | usize
  deriving Inhabited, BEq, Repr

/-- Persistent per-module freestanding bit (K20). Set when compiling with `compiler.freestanding`. -/
builtin_initialize freestandingModExt : ModuleEnvExtension Bool ←
  registerModuleEnvExtension (pure false)

/-- Map freestanding scalar type names to scalar kinds (K18).
Includes single-field affine handles that unbox to the same C ABI
(`Fd` / `Arena` / `BytePtr` / `MallocBuf` → `size_t`). -/
public def freestandingScalarKind? : Name → Option FreestandingScalarKind
  | .str (.str (.str .anonymous "Systems") "Scalars") "U8" => some .uint8
  | .str (.str (.str .anonymous "Systems") "Scalars") "U16" => some .uint16
  | .str (.str (.str .anonymous "Systems") "Scalars") "U32" => some .uint32
  | .str (.str (.str .anonymous "Systems") "Scalars") "U64" => some .uint64
  | .str (.str (.str .anonymous "Systems") "Scalars") "USize" => some .usize
  | .str (.str (.str .anonymous "Systems") "Scalars") "Bool" => some .uint8
  -- S2: affine Fd is a single-field wrapper over a POSIX int; C ABI is size_t (K23).
  | .str (.str (.str .anonymous "Systems") "Sys") "Fd" => some .usize
  -- S3: single-field affine arena / buffer / malloc owner (K19 trivial structure → size_t).
  | .str (.str (.str .anonymous "Systems") "Sys") "Arena" => some .usize
  | .str (.str (.str .anonymous "Systems") "Sys") "BytePtr" => some .usize
  | .str (.str (.str .anonymous "Systems") "Sys") "MallocBuf" => some .usize
  -- S4: single-file append log handle (affine owner over a POSIX fd; C ABI size_t).
  | .str (.str (.str .anonymous "Systems") "Sys") "Log" => some .usize
  -- S5: single-field affine mmap address (size tracked as separate USize param; K19).
  | .str (.str (.str .anonymous "Systems") "Sys") "MMap" => some .usize
  -- S6: affine process id (POSIX pid_t as size_t; Systems.Proc).
  | .str (.str (.str .anonymous "Systems") "Proc") "Pid" => some .usize
  | _ => none

/-- True if `name` is a freestanding scalar type. -/
public def isFreestandingScalarTypeName (name : Name) : Bool :=
  (freestandingScalarKind? name).isSome

/-- Walk a kernel type and accept only freestanding scalars (S0 ABI).
S0: freestanding scalars only — no `Unit`/`PUnit` export_c results yet (add when needed). -/
public partial def isFreestandingExportType (type : Expr) : Bool :=
  match type with
  | .forallE _ d b _ => isFreestandingExportType d && isFreestandingExportType b
  | .const n _ => isFreestandingScalarTypeName n
  | .mdata _ b => isFreestandingExportType b
  | .app f _ =>
    match f.getAppFn with
    | .const n _ => isFreestandingScalarTypeName n
    | _ => false
  | _ => false

/-- Freestanding emit / affine check is active when the persisted module bit (K20) **or**
`compiler.freestanding` is set. Shared by EmitC, AffineCheck, and related gates. -/
public def isFreestandingEmit (env : Environment) (opts : Options) : Bool :=
  freestandingModExt.getState env || compiler.freestanding.get opts

/--
S2–S5 tight **named** libc / POSIX allowlist for freestanding `@[extern "…"]` (standard form)
and for recognizing effectful inline patterns. Fail-closed: do not broaden without review.

* S2: `open` / `close` / `read` / `write`
* S3: `malloc` / `free` for typed affine arena/buffer APIs (never invisible Lean objects);
  `memset` for buffer fill (also emitted by C compilers for fill loops)
* S4: `fsync` (durability) / `lseek` (append-log scan / end seek)
* S5: `mmap` / `munmap` / `msync` / `ftruncate` — named only; still reject `socket`/`dlopen`/…
* S6: `fork` / `execve` / `_exit` / `waitpid` — process spawn/wait for `Systems.Proc`
* S6b: `pipe` / `dup2` / `fcntl` — pipe ends + stdio redirect; `FD_CLOEXEC` on pipe ends
  so unused opposite ends close on child `execve` (no hang on stdin-from-pipe EOF)
-/
public def isAllowlistedFreestandingLibcSymbol (fnName : String) : Bool :=
  fnName == "open" || fnName == "close" || fnName == "read" || fnName == "write" ||
  fnName == "malloc" || fnName == "free" || fnName == "memset" ||
  fnName == "fsync" || fnName == "lseek" ||
  fnName == "mmap" || fnName == "munmap" || fnName == "msync" || fnName == "ftruncate" ||
  fnName == "fork" || fnName == "execve" || fnName == "_exit" || fnName == "waitpid" ||
  fnName == "pipe" || fnName == "dup2" || fnName == "fcntl"

end Lean.Compiler

namespace Lean

/-- Whether the current module is freestanding. -/
public def Environment.isFreestandingModule (env : Environment) : Bool :=
  Compiler.freestandingModExt.getState env

/-- Whether imported module `idx` was compiled freestanding. -/
public def Environment.isFreestandingModuleByIdx? (env : Environment) (idx : ModuleIdx) : Option Bool :=
  Compiler.freestandingModExt.getStateByIdx? env idx

/-- Mark the current module as freestanding. -/
public def Environment.setFreestandingModule (env : Environment) (v : Bool := true) : Environment :=
  Compiler.freestandingModExt.setState env v

/-- Reject non-freestanding imports when compiling a freestanding module (I1/K20). -/
public def checkFreestandingImports (env : Environment) (imports : Array Import) : Except String Unit := do
  for imp in imports do
    if let some idx := env.getModuleIdx? imp.module then
      let isFs := env.isFreestandingModuleByIdx? idx |>.getD false
      unless isFs do
        throw s!"freestanding module cannot import non-freestanding module `{imp.module}`"
  return ()

end Lean
