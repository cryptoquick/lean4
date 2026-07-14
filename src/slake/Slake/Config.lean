/-
Copyright (c) 2026 Hunter Beast. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Hunter Beast
-/
module

import Init.System.FilePath
import Init.Data.String.Basic
import Init.Data.String.TakeDrop
import Init.Data.String.Extra

/-!
# Slake.Config

Classic-host config helpers for the Slake driver.

Reads a **small** `lakefile.toml` subset so `slake env` / `slake build` can show
package identity without calling Lake. Matches the intent of freestanding
`Systems.TomlConfig` (package `name`, `defaultTargets` quote count, `[[lean_lib]]`
headers) but is pure Lean on the host path.

Not full TOML. Not Lean DSL. Not freestanding product TCB.
-/

namespace Slake.Config

open System

/-- Default package config file name (Lake-compatible). -/
public def defaultTomlName : String := "lakefile.toml"

/-- Default Lean DSL config file name (host elab path; deferred). -/
public def defaultLeanName : String := "lakefile.lean"

/-- Freestanding TOML subset core (product / extract path). -/
public def freestandingTomlCore : String := "Systems.TomlConfig"

/-- Freestanding manifest scan core. -/
public def freestandingManifestCore : String := "Systems.Manifest"

/-- Package identity extracted from `lakefile.toml` (host scan). -/
public structure PackageIdentity where
  /-- Top-level `name = "…"` value (quotes stripped), if found. -/
  name : Option String := none
  /-- Count of `"…"` elements in `defaultTargets = […]`, or `0`. -/
  defaultTargetCount : Nat := 0
  /-- Number of `[[lean_lib]]` array-of-tables headers. -/
  leanLibCount : Nat := 0
  deriving Repr, Inhabited

/-- Trim ASCII spaces/tabs from both ends. -/
def trimAscii (s : String) : String :=
  s.trimAscii.toString

/-- True if line is blank or a `#` comment (after trim). -/
def isBlankOrComment (line : String) : Bool :=
  let t := trimAscii line
  t.isEmpty || t.startsWith "#"

/-- True if line starts a TOML table or array-of-tables (`[` …). -/
def isTableHeader (line : String) : Bool :=
  (trimAscii line).startsWith "["

/-- True if line is exactly `[[lean_lib]]` (optional spaces). -/
def isLeanLibHeader (line : String) : Bool :=
  trimAscii line == "[[lean_lib]]"

/-- Parse `key = value` at start of line; key must be exact (trimmed left of `=`). -/
def lineKeyValue (line : String) : Option (String × String) :=
  let t := trimAscii line
  if t.isEmpty || t.startsWith "#" || t.startsWith "[" then none
  else
    match t.splitOn "=" with
    | key :: rest =>
      if rest.isEmpty then none
      else
        let k := trimAscii key
        let v := trimAscii ("=".intercalate rest)
        if k.isEmpty then none else some (k, v)
    | _ => none

/-- Strip one pair of surrounding double quotes if both present and closed. -/
def stripQuotes (v : String) : Option String :=
  if v.startsWith "\"" && v.endsWith "\"" && v.length >= 2 then
    some (v.drop 1 |>.dropRight 1)
  else if v.startsWith "\"" then
    none -- unclosed
  else
    some v

/-- Count `"…"` string elements inside a single-line `[ … ]` array value.

Fail-closed: unclosed quote yields floor of complete pairs only
(`splitOn "\""` length arithmetic). Not multi-line. -/
def countQuotedInArray (v : String) : Nat :=
  let t := trimAscii v
  if !(t.startsWith "[") || !(t.endsWith "]") then 0
  else
    let inner := t.drop 1 |>.dropRight 1
    -- n complete `"…"` pairs → split length `2*n+1`; floor for unclosed.
    (inner.splitOn "\"").length.sub 1 / 2

/-- Scan full TOML text for package identity (first top-level `name` only). -/
public def scanTomlText (text : String) : PackageIdentity :=
  let lines := text.splitOn "\n"
  let rec go (ls : List String) (inTable : Bool) (id : PackageIdentity) : PackageIdentity :=
    match ls with
    | [] => id
    | line :: rest =>
      let bare := if line.endsWith "\r" then line.dropRight 1 else line
      if isBlankOrComment bare then
        go rest inTable id
      else if isTableHeader bare then
        let nextIn := true
        let id :=
          if isLeanLibHeader bare then
            { id with leanLibCount := id.leanLibCount + 1 }
          else id
        go rest nextIn id
      else if inTable then
        -- Skip key/values inside tables for package-level name / defaultTargets.
        go rest inTable id
      else
        match lineKeyValue bare with
        | none => go rest inTable id
        | some (k, v) =>
          let id :=
            if k == "name" && id.name.isNone then
              match stripQuotes v with
              | some n => { id with name := some n }
              | none => id
            else if k == "defaultTargets" then
              { id with defaultTargetCount := countQuotedInArray v }
            else id
          go rest inTable id
  go lines false {}

/-- Read `pkg/lakefile.toml` and scan package identity. Missing file → empty. -/
public def readPackageIdentity (pkg : FilePath) : IO PackageIdentity := do
  let path := pkg / defaultTomlName
  if !(← path.pathExists) then
    return {}
  try
    let text ← IO.FS.readFile path
    return scanTomlText text
  catch _ =>
    return {}

/-- One-line human summary for `slake env` / build banners. -/
public def formatIdentity (id : PackageIdentity) : String :=
  let name := id.name.getD "(missing name)"
  s!"name={name} defaultTargets={id.defaultTargetCount} lean_lib={id.leanLibCount}"

end Slake.Config
