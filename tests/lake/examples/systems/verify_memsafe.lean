module
public meta import Lean.Compiler.LCNF.MemSafetyCert
public meta import Lean.Compiler.LCNF.CompCertCert

/-!
# Verify QTT memsafe + CompCert-oriented certificates on freestanding C

Uses shipped `MemSafetyCert.verifyEmbedded` / `CompCertCert.verifyEmbedded` only
(no reimplementation of digests or parsers).

File list:
* If env `SYSTEMS_LEAN_VERIFY_C_FILES` is set (newline-separated absolute or relative paths),
  **every** listed path must exist and verify (fail-closed; no skip). Used by the proof receipt.
* Otherwise default dogfood candidates under this directory (skip missing companions).
-/

open Lean.Compiler.LCNF

def defaultCandidates : Array System.FilePath :=
  #[ "lib/.lake/build/ir/Extract.c"
   , "lib/.lake/build/ir/Systems/Scalars.c"
   , "lib/.lake/build/ir/Systems/Sys.c"
   ]

/-- Split env payload on newlines; drop empty lines. -/
def pathsFromEnv (s : String) : Array System.FilePath :=
  (s.splitOn "\n").foldl (init := #[]) fun acc line =>
    if line.isEmpty then acc else acc.push ⟨line⟩

#eval show IO Unit from do
  let explicit? ← IO.getEnv "SYSTEMS_LEAN_VERIFY_C_FILES"
  let (files, requireAll, requireSidecars) :=
    match explicit? with
    | some s =>
      let ps := pathsFromEnv s
      -- Receipt path: verify listed bodies only (sidecars optional for non-dogfood paths).
      (ps, true, false)
    | none => (defaultCandidates, false, true)
  if files.isEmpty then
    throw <| IO.userError "FAIL: empty SYSTEMS_LEAN_VERIFY_C_FILES / no candidates"
  let mut n := 0
  for f in files do
    if !requireAll then
      unless (← System.FilePath.pathExists f) do
        continue
    unless (← System.FilePath.pathExists f) do
      throw <| IO.userError s!"FAIL missing C file {f}"
    let c ← IO.FS.readFile f
    match MemSafetyCert.verifyEmbedded c with
    | Except.error e => throw <| IO.userError s!"FAIL memsafe {f}: {e}"
    | Except.ok () =>
      IO.println s!"OK: MemSafetyCert (QTT) verified {f}"
    match CompCertCert.verifyEmbedded c with
    | Except.error e => throw <| IO.userError s!"FAIL compcert {f}: {e}"
    | Except.ok () =>
      IO.println s!"OK: CompCert-oriented cert verified {f}"
    if requireSidecars then
      unless (← System.FilePath.pathExists (MemSafetyCert.sidecarPath f)) do
        throw <| IO.userError s!"FAIL missing {MemSafetyCert.sidecarPath f}"
      unless (← System.FilePath.pathExists (CompCertCert.sidecarPath f)) do
        throw <| IO.userError s!"FAIL missing {CompCertCert.sidecarPath f}"
    n := n + 1
  if n == 0 then
    throw <| IO.userError "FAIL: no freestanding .c files found"
  IO.println s!"OK: verified {n} freestanding C file(s) (QTT memsafe + CompCert)"
