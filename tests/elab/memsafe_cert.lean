module
public meta import Lean.Compiler.LCNF.MemSafetyCert
public meta import Lean.Compiler.LCNF.CompCertCert
public meta import Lean.Compiler.Multiplicity

/-!
# QTT multiplicities + memory-safety / CompCert-oriented certificates
-/

open Lean.Compiler (Multiplicity)
open Lean.Compiler.LCNF

def sampleC : String :=
  "/* freestanding extract */\n#include <stddef.h>\nuint32_t lean_fs_add(uint64_t x, uint64_t y) { return (uint32_t)(x + y); }\n"

def sampleCNoNL : String :=
  "/* freestanding extract */\n#include <stddef.h>\nuint32_t lean_fs_add(uint64_t x, uint64_t y) { return (uint32_t)(x + y); }"

def badC : String :=
  "lean_object* foo(void) { return lean_box(0); }\n"

def check (label : String) (ok : Bool) : IO Unit := do
  if !ok then throw <| .userError s!"FAIL: {label}"
  IO.println s!"OK: {label}"

#eval show IO Unit from do
  check "QTT 1+1=ω" (Multiplicity.add .one .one == Multiplicity.omega)
  check "QTT 0*ω=0" (Multiplicity.mul .zero .omega == Multiplicity.zero)
  check "QTT 1*ω=ω" (Multiplicity.mul .one .omega == Multiplicity.omega)
  check "QTT 0≤1≤ω" (Multiplicity.le .zero .one && Multiplicity.le .one .omega)
  check "QTT linear may not discard" (!Multiplicity.mayDiscard .one)
  check "QTT ω may discard" (Multiplicity.mayDiscard .omega)
  check "QTT 0 not runtime" (!Multiplicity.isRuntime .zero)

  match MemSafetyCert.sealCertificate `Test.Mod sampleC with
  | Except.error e => throw <| .userError s!"seal failed: {e}"
  | Except.ok sealed =>
    match MemSafetyCert.verifyEmbedded sealed with
    | Except.error e => throw <| .userError s!"verifyEmbedded: {e}"
    | Except.ok () => check "positive memsafe verifyEmbedded" true
    check "positive has qtt_zero_quantity_erased claim"
      (MemSafetyCert.findSubstr sealed "claim=qtt_zero_quantity_erased").isSome
    check "positive has qtt_linear_resources claim"
      (MemSafetyCert.findSubstr sealed "claim=qtt_linear_resources_exact_once").isSome
    match CompCertCert.sealCompCert `Test.Mod sealed with
    | Except.error e => throw <| .userError s!"compcert seal: {e}"
    | Except.ok both =>
      match CompCertCert.verifyEmbedded both with
      | Except.error e => throw <| .userError s!"compcert verify: {e}"
      | Except.ok () => check "positive CompCert-oriented verifyEmbedded" true
      check "positive CompCert requires memsafe"
        (MemSafetyCert.findSubstr both "claim=valid_freestanding_memsafe_cert_prerequisite").isSome

  match MemSafetyCert.sealCertificate `Test.Mod sampleCNoNL with
  | Except.error e => throw <| .userError s!"seal no-NL: {e}"
  | Except.ok sealed =>
    match MemSafetyCert.verifyEmbedded sealed with
    | Except.error e => throw <| .userError e
    | Except.ok () => check "positive seal without trailing newline" true

  match MemSafetyCert.verifyEmbedded sampleC with
  | Except.ok () => throw <| .userError "expected missing cert"
  | Except.error _ => check "negative missing memsafe cert" true

  match MemSafetyCert.issue `Test.Bad badC with
  | Except.ok _ => throw <| .userError "expected reject lean_object"
  | Except.error _ => check "negative cannot certify lean_object" true

  match MemSafetyCert.issue `Test.Mod sampleC with
  | Except.error e => throw <| .userError e
  | Except.ok cert =>
    match MemSafetyCert.verify cert (sampleC ++ "/* tamper */\n") with
    | Except.ok () => throw <| .userError "expected digest mismatch"
    | Except.error _ => check "negative c_digest mismatch" true
    let good := MemSafetyCert.embed sampleC cert
    let bad := good.replace
      ("sig=" ++ MemSafetyCert.signatureOf `Test.Mod cert.cDigest)
      ("sig=0000000000000000")
    match MemSafetyCert.verifyEmbedded bad with
    | Except.ok () => throw <| .userError "expected bad sig"
    | Except.error _ => check "negative bad memsafe sig" true

  let dig := MemSafetyCert.digestOfC sampleC
  let stripped :=
    "SYSTEMS_LEAN_MEMSAFE_CERT/2\nmodule=Test.Mod\nc_digest=" ++ dig ++ "\n" ++
    "claim=full_memory_safety_freestanding_model\nclaim=no_use_after_free\n" ++
    "claim=no_double_free\nclaim=no_invalid_free\nclaim=no_oob_certified_buffers\n" ++
    "claim=no_managed_lean_runtime\nclaim=libc_allowlist_only\n" ++
    "flags=freestanding\nsig=0000000000000000\n"
  match MemSafetyCert.parse stripped with
  | Except.ok _ => throw <| .userError "expected reject stripped QTT claims"
  | Except.error e =>
    check "negative missing qtt_zero_quantity_erased"
      (e.contains "qtt_zero_quantity_erased")

  match CompCertCert.issueFromMemsafe `Test.Mod sampleC with
  | Except.ok _ => throw <| .userError "expected compcert require memsafe"
  | Except.error _ => check "negative CompCert requires MemSafetyCert" true

  IO.println "memsafe_cert: all cases passed (QTT + CompCert)"
