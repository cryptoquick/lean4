/-
Copyright (c) 2026 Lean FRO, LLC. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Hunter Beast
-/
module

prelude
public import Lean.Attributes
public import Lean.Compiler.Options
public import Lean.Compiler.Freestanding

public section

namespace Lean

private def isValidCppId (id : String) : Bool :=
  let first := id.front;
  first.isAlpha  && (id.toRawSubstring.drop 1).all (fun c => c.isAlpha || c.isDigit || c == '_')

private def isValidCppName : Name → Bool
  | .str .anonymous s => isValidCppId s
  | .str p s          => isValidCppId s && isValidCppName p
  | _                 => false

/--
Exports a freestanding function under an unmangled C symbol with a C ABI of unboxed scalars only.
Requires `compiler.freestanding = true` (K12). Distinct from `@[export]`, which uses the Lean ABI.
-/
@[builtin_doc]
builtin_initialize exportCAttr : ParametricAttribute Name ←
  registerParametricAttribute {
    name := `export_c
    descr := "freestanding C export name (requires compiler.freestanding)"
    getParam := fun declName stx => do
      unless Compiler.compiler.freestanding.get (← getOptions) do
        throwError "Invalid `export_c` on `{declName}`: `compiler.freestanding` must be true \
          (freestanding modules only; see K12)"
      let exportName ← Attribute.Builtin.getId stx
      unless isValidCppName exportName do
        throwError "Invalid `export_c` function name: `{exportName}` is not a valid C identifier"
      let env ← getEnv
      let some info := env.find? declName
        | throwError "Invalid `export_c` on `{declName}`: declaration not found"
      unless Compiler.isFreestandingExportType info.type do
        throwError "Invalid `export_c` on `{declName}`: signature must use only freestanding \
          scalar types (Systems.Scalars.U64/USize/…)"
      return exportName
  }

@[export lean_get_export_c_name_for]
def getExportCNameFor? (env : Environment) (n : Name) : Option Name :=
  exportCAttr.getParam? env n

def isExportC (env : Environment) (n : Name) : Bool :=
  (getExportCNameFor? env n).isSome

/-- Local declarations marked `@[export_c]` in the current module. -/
def getLocalExportCDeclNames (env : Environment) : Array Name :=
  (exportCAttr.ext.getState env).1.toArray.reverse

end Lean
