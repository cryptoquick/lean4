/-
Copyright (c) 2026 Lean FRO, LLC. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Hunter Beast
-/
module

prelude
public import Init.Data.String.Basic
public import Init.Data.String.Legacy
public import Init.Data.String.Defs
public import Init.Data.List.Basic
public import Init.Data.List.Range
public import Init.Data.Nat.Basic
public import Init.System.FilePath
public import Lean.Data.Name
public import Lean.Compiler.LCNF.MemSafetyCert

/-!
# CompCert-oriented formal memory certificate (treat layer)

After freestanding QTT memory-safety certificates, Systems Lean can emit a second,
**CompCert-oriented** formal certificate for the same C body. This is **not** a full
[CompCert](https://compcert.org/) verified compilation proof (that would require a
verified C semantics and backend). It is a machine-checkable artifact that:

1. Is **bound** to the same C digest as `MemSafetyCert`
2. Asserts memory-safety obligations in language aligned with CompCert’s Clight /
   CompCert C memory model literature (no dangling pointer from certified resources,
   no out-of-bounds on certified blocks, separation of ownership)
3. **Requires** a valid freestanding `MemSafetyCert` (including QTT 0-quantity erasure)
   before it can be issued — so CompCert-layer claims rest on the QTT freestanding gate

Sidecar path: `foo.c.compcert.memcert`.
-/

namespace Lean.Compiler.LCNF.CompCertCert

public def version : Nat := 1

public def beginMarker : String := "/* SYSTEMS_LEAN_COMPCERT_MEMCERT begin"
public def endMarker : String := "SYSTEMS_LEAN_COMPCERT_MEMCERT end */"

/-- Claims phrased for CompCert / Clight-style memory-model consumers. -/
public def claimLines : List String :=
  [ "claim=compcert_compatible_memory_safety"
  , "claim=no_dangling_pointer_certified_blocks"
  , "claim=no_out_of_bounds_certified_blocks"
  , "claim=ownership_separation_linear_resources"
  , "claim=valid_freestanding_memsafe_cert_prerequisite"
  , "claim=qtt_zero_quantity_erased"
  , "model=compcert_clight_style_blocks"
  , "flags=compcert_oriented,requires_memsafe_v2,qtt"
  ]

open MemSafetyCert (fnv1a64 toHex16 normalizeCBody digestOfC nameToStr findSubstr takeN dropN
  extractNE strLen trimAsciiStr)

public def joinClaims : String :=
  String.intercalate "\n" claimLines

public def canonicalBody (mod : Name) (cDigest : String) (memsafeSig : String) : String :=
  "SYSTEMS_LEAN_COMPCERT_MEMCERT/" ++ toString version ++ "\nmodule=" ++ nameToStr mod ++
    "\nc_digest=" ++ cDigest ++ "\nmemsafe_sig=" ++ memsafeSig ++ "\n" ++ joinClaims ++ "\n"

public def signatureOf (mod : Name) (cDigest : String) (memsafeSig : String) : String :=
  toHex16 (fnv1a64 (canonicalBody mod cDigest memsafeSig))

public structure Certificate where
  module : Name
  cDigest : String
  memsafeSig : String
  deriving Inhabited, Repr, BEq

public def render (cert : Certificate) : String :=
  canonicalBody cert.module cert.cDigest cert.memsafeSig ++
    "sig=" ++ signatureOf cert.module cert.cDigest cert.memsafeSig ++ "\n"

/-- Append CompCert cert after a **already memsafe-sealed** C string. -/
public def appendToSealed (sealedMemsafe : String) (cert : Certificate) : String :=
  sealedMemsafe ++ beginMarker ++ "\n" ++ render cert ++ endMarker ++ "\n"

public def splitEmbedded? (c : String) : Option (String × String) :=
  match findSubstr c beginMarker with
  | none => none
  | some startIdx =>
    let after := dropN c startIdx
    match findSubstr after endMarker with
    | none => none
    | some relEnd =>
      let endIdx := startIdx + relEnd + strLen endMarker
      some (takeN c startIdx, extractNE c startIdx endIdx)

public def requireClaimLines (lines : List String) : Except String Unit := do
  for req in claimLines do
    unless lines.any (· == req) do
      throw ("compcert cert missing required claim line: " ++ req)

public def parse (text : String) : Except String Certificate := do
  let lines := text.splitOn "\n" |>.map trimAsciiStr |>.filter (fun l => !l.isEmpty)
  let mut mod? : Option Name := none
  let mut dig? : Option String := none
  let mut ms? : Option String := none
  let mut sig? : Option String := none
  let mut sawHeader := false
  for line in lines do
    if line.startsWith "SYSTEMS_LEAN_COMPCERT_MEMCERT/" then
      sawHeader := true
    else if line.startsWith "module=" then
      mod? := some (MemSafetyCert.parseModuleName (dropN line (strLen "module=")))
    else if line.startsWith "c_digest=" then
      dig? := some (dropN line (strLen "c_digest="))
    else if line.startsWith "memsafe_sig=" then
      ms? := some (dropN line (strLen "memsafe_sig="))
    else if line.startsWith "sig=" then
      sig? := some (dropN line (strLen "sig="))
  let some mod := mod? | throw "compcert cert missing module="
  let some dig := dig? | throw "compcert cert missing c_digest="
  let some ms := ms? | throw "compcert cert missing memsafe_sig="
  let some sig := sig? | throw "compcert cert missing sig="
  unless sawHeader do throw "compcert cert missing header"
  requireClaimLines lines
  let expect := signatureOf mod dig ms
  unless sig == expect do
    throw ("compcert cert signature mismatch (got " ++ sig ++ ", expected " ++ expect ++ ")")
  return { module := mod, cDigest := dig, memsafeSig := ms }

public def verify (cert : Certificate) (pureCBody : String) : Except String Unit := do
  let dig := digestOfC pureCBody
  unless dig == cert.cDigest do
    throw ("compcert c_digest mismatch")
  pure ()

/--
Independent check: CompCert block present; **prerequisite** MemSafetyCert verifies;
digest matches pure C (without either cert footer).
-/
public def verifyEmbedded (c : String) : Except String Unit := do
  let some (beforeCc, certText) := splitEmbedded? c
    | throw "missing embedded SYSTEMS_LEAN_COMPCERT_MEMCERT block"
  let cert ← parse certText
  -- Prerequisite: freestanding memsafe cert (includes QTT 0-qty claims).
  MemSafetyCert.verifyEmbedded beforeCc
  let pureBody ←
    match MemSafetyCert.splitEmbedded? beforeCc with
    | some (b, _) => pure (normalizeCBody b)
    | none => throw "compcert cert: memsafe layer missing pure C body"
  verify cert pureBody

/--
Issue CompCert-oriented cert **only if** freestanding MemSafetyCert verifies.
Binds to the same pure-C digest and records the memsafe signature.
-/
public def issueFromMemsafe (mod : Name) (sealedMemsafeC : String) : Except String Certificate := do
  MemSafetyCert.verifyEmbedded sealedMemsafeC
  let some (b, certText) := MemSafetyCert.splitEmbedded? sealedMemsafeC
    | throw "compcert cert requires sealed freestanding MemSafetyCert"
  let mc ← MemSafetyCert.parse certText
  let body := MemSafetyCert.normalizeCBody b
  let memsafeSig := MemSafetyCert.signatureOf mc.module mc.cDigest
  if let some bad := MemSafetyCert.scanForbidden body then
    throw ("compcert cert: " ++ bad)
  let dig := digestOfC body
  unless dig == mc.cDigest do
    throw "compcert cert: digest mismatch with memsafe layer"
  let cert : Certificate := { module := mod, cDigest := dig, memsafeSig := memsafeSig }
  verify cert body
  return cert

public def sealCompCert (mod : Name) (sealedMemsafeC : String) : Except String String := do
  let cert ← issueFromMemsafe mod sealedMemsafeC
  let sealed := appendToSealed sealedMemsafeC cert
  verifyEmbedded sealed
  pure sealed

public def sidecarPath (cPath : System.FilePath) : System.FilePath :=
  ⟨cPath.toString ++ ".compcert.memcert"⟩

public def extractCertText? (sealed : String) : Option String :=
  match splitEmbedded? sealed with
  | some (_, t) => some t
  | none => none

-- Formal inventory: CompCert-oriented claim lines (incl. memsafe prerequisite + QTT 0-qty).
-- Not CompCert's verified compilation theorems — only the Lean obligation set is fixed here.
namespace Theorems
private theorem has_compcert_compatible_memory_safety :
    claimLines.any (fun s => s == "claim=compcert_compatible_memory_safety") = true := rfl
private theorem has_no_dangling_pointer_certified_blocks :
    claimLines.any (fun s => s == "claim=no_dangling_pointer_certified_blocks") = true := rfl
private theorem has_no_out_of_bounds_certified_blocks :
    claimLines.any (fun s => s == "claim=no_out_of_bounds_certified_blocks") = true := rfl
private theorem has_ownership_separation :
    claimLines.any (fun s => s == "claim=ownership_separation_linear_resources") = true := rfl
private theorem has_valid_freestanding_memsafe_prerequisite :
    claimLines.any (fun s => s == "claim=valid_freestanding_memsafe_cert_prerequisite") = true := rfl
private theorem has_qtt_zero_quantity_erased :
    claimLines.any (fun s => s == "claim=qtt_zero_quantity_erased") = true := rfl
private theorem has_model_clight_style_blocks :
    claimLines.any (fun s => s == "model=compcert_clight_style_blocks") = true := rfl
private theorem has_flags_line :
    claimLines.any (fun s => s == "flags=compcert_oriented,requires_memsafe_v2,qtt") = true := rfl
/-- Marker: full CompCert-oriented claim-line inventory typechecked (witnesses private lemmas). -/
public def claimInventoryChecked : Bool :=
  have _ := has_compcert_compatible_memory_safety
  have _ := has_no_dangling_pointer_certified_blocks
  have _ := has_no_out_of_bounds_certified_blocks
  have _ := has_ownership_separation
  have _ := has_valid_freestanding_memsafe_prerequisite
  have _ := has_qtt_zero_quantity_erased
  have _ := has_model_clight_style_blocks
  have _ := has_flags_line
  true
end Theorems


end Lean.Compiler.LCNF.CompCertCert


