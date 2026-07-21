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
`Systems.TomlConfig` (package `name`, `defaultTargets` names, `[[lean_lib]]`
headers / names) but is pure Lean on the host path.

Used by CLAIMED `env`/`build` banners and by package-derived DepGraph plan nodes
(`SLAKE_DEPGRAPH` / `SLAKE_PLAN_ONLY` / `SLAKE_NATIVE_CHECK` / `SLAKE_NATIVE_OLEAN` /
`SLAKE_NATIVE_BUILD` / `SLAKE_NATIVE_C` / `SLAKE_NATIVE_OBJ` / `SLAKE_NATIVE_IRLINK` /
`SLAKE_NATIVE_AR` / `SLAKE_NATIVE_EXE` / `SLAKE_NATIVE_LINK` / `SLAKE_NATIVE_GRAPH` / `SLAKE_NATIVE_SEAL`).
Plan may apply an **import-scan DAG subset** among package plan nodes (top-level
`import` lines in resolved `.lean` files) when edges exist; otherwise
declaration-order chain. Module path resolution is a **srcDir + dotted-name
subset**: optional package-level `srcDir` from TOML, optional per-`[[lean_lib]]`
`srcDir` / `roots` (A16), `Foo.Bar` → `srcDir/Foo/Bar.lean`, with flat
package-root fallback for backward compat. Prefer per-lib `srcDir` when the
module matches that lib's `roots`, expanded `globs`, or `name`; else package-level
`srcDir`. A18: package `defaultTargets` and per-lib `roots` / `globs` accept
**multi-line** double-quoted string arrays (`takeBracketArray`) as well as
single-line. A24/A25: per-lib `globs` subset for plan expansion (ones + `.+` /
`.*` **recursive multi-level** submodule walk under confining srcDir, depth-
bounded — **not** full Lake Glob / faceting / package imports / freestanding
build TCB / CLAIMED). Roots still win when non-empty. A26: optional
`[[require]]` tables with `name` + safe relative `path` (no absolute; no `..`
except A29) for path-dep LEAN_PATH feed and path-dep native olean precompile —
**not** git/url requires / not Lake resolve-deps / not freestanding build TCB /
not CLAIMED. **A30:** when a root plan module imports a path-dep plan module
name, that path-dep module is folded into the root plan node list
(**package-transitive plan subset**, import-driven — not full Lake resolve-deps /
not every dep plan module unconditionally). **A31:** A30-folded path-dep plan
modules also participate in host C/OBJ emit under the path-require package and
feed those `.o` into NATIVE_IRLINK / AR / EXE (freestanding-adjacent path-dep
plan-module C/OBJ into IR products subset — not Lake lean_lib shared facet / not
every dep plan module). **A32:** A30-folded path-dep plan modules appear in
NATIVE_GRAPH with package-cwd-relative olean paths (under-pkg or A29 sibling `../dep/…`) and in NATIVE_SEAL with
path-dep olean_hash (freestanding-adjacent path-dep plan-module nodes in
NATIVE_GRAPH + NATIVE_SEAL subset — not Lake build graph TCB / not Lake
resolve-deps / not every dep plan module / not freestanding build TCB / not
CLAIMED). **A35:** plan-module C source inventory in NATIVE_GRAPH (`c_source <Mod>
<package-cwd-relative .c path>`) and NATIVE_SEAL (`module <Mod> c_hash` FNV-1a
64 of C file bytes) when regular-file `.c` exists for root or A30-folded path-dep
modules (soft-omit missing; banners only when ≥1 c_source/c_hash line; seal digest
folds sorted c_hash after olean_hash and before obj_hash — not freestanding build
TCB / not Lake lean_lib facet / not CLAIMED / not every dep plan module / not
changing C emit semantics). **A34:** plan-module object inventory in NATIVE_GRAPH (`object <Mod>
<package-cwd-relative .o path>`) and NATIVE_SEAL (`module <Mod> obj_hash` FNV-1a
64 of object bytes) when regular-file `.o` exists for root or A30-folded path-dep
modules (soft-omit missing; banners only when ≥1 object/obj_hash line — not
freestanding build TCB / not Lake lean_lib facet / not CLAIMED / not every dep
plan module / not name-table SO). **A33:** CLAIMED `clean` also wipes path-require packages’
`.slake-native/` (A26 under-pkg / A29 sibling confining; identity order; soft
missing OK; symlink fence — not git/url / not Lake resolve-deps / not multi-`..` /
not dep `.lake/build` / not CLAIMED token expansion). A29: sibling confining
`path = "../dep"` (exactly one leading `..` + ≥1 safe components; resolves under
package-parent confining root; refuse multi-`..` escape / bare `..` / absolute)
— monorepo-style sibling only; still not full Lake path require / workspace
walk-up. A27/A28 consumers use path-require inventory for path-dep → root olean
cascade and path-dep source-hash fold into A11 deps-line (CLI). Import-scan is
line-oriented (keyword+whitespace, optional `public`/`meta`/`all`, multi-line
block-comment open/close tracking, unique edges); not a full Lean parser. Not
full Lake import resolution / module faceting / package imports / not
freestanding build TCB. A8–A23 consumers walk the same plan for host-lean olean
compile (package-local `.slake-native/` + mtime/plan-edge cascade + FNV-1a 64
source content-hash + plan-node direct deps-hash + A28 path-dep import fold
(cascade multi-hop) sidecar skip;
NATIVE_BUILD skips lake on success; A19 NATIVE_C host lean C-output emit subset
after oleans; A20 NATIVE_OBJ host object compile of lean C after C emit; A21
NATIVE_IRLINK host leanc IR shared-lib link of plan-module objects + Lean
runtime via leanc; A22 NATIVE_AR host static archive of plan-module objects via
ar rcs; A23 NATIVE_EXE host leanc executable link of plan-module objects + stub
main + Lean runtime via leanc; A13 NATIVE_LINK host shared-lib link subset after
oleans; A14 NATIVE_GRAPH host package link graph subset artifact; A15
NATIVE_SEAL host freestanding-adjacent product seal subset artifact) — not
lake-equivalent TCB / not Lake shake/hash TCB / not Lake package-transitive
hash / not Lake shared-lib TCB / not Lake build graph TCB / not CLAIMED.

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

/-- One `[[lean_lib]]` table identity (A16/A24/A25 host subset).

`name` / optional safe `srcDir` / optional `roots` / optional `globs` string
lists. Not full Lake LeanLibConfig (full Glob.matches / needs / facets /
package imports) — residual honesty. -/
public structure LeanLibIdentity where
  /-- `name = "…"` under this `[[lean_lib]]` (first closed quote wins). -/
  name : String := ""
  /-- Optional lib-local `srcDir = "…"` (fail-closed like package `srcDir`). -/
  srcDir : Option String := none
  /-- Optional `roots = ["…", …]` plan module labels (order preserved). -/
  roots : List String := []
  /-- Optional `globs = ["…", …]` Lake-style glob strings (order preserved).

  Subset: ones (`"Foo"`), submodules (`"Foo.+"`), and-submodules (`"Foo.*"`).
  Pattern forms use **recursive multi-level** confining walk (A25), depth-
  bounded — not full Lake Glob / faceting / package imports. -/
  globs : List String := []
  deriving Repr, Inhabited

/-- One `[[require]]` table identity (A26/A29 host path-require subset).

`name` + optional path: A26 safe relative (no absolute / no `..`) **or** A29
sibling confining `../dep` (one leading `..` + ≥1 safe components under package
parent). Git/url-only requires are not path-feedable — residual honesty. Not
Lake Dependency / resolve-deps / git clone TCB / freestanding build TCB /
CLAIMED. -/
public structure RequireIdentity where
  /-- `name = "…"` under this `[[require]]` (first closed quote wins). -/
  name : String := ""
  /-- Optional path (A26 under-pkg or A29 sibling confining; fail-closed). -/
  path : Option String := none
  deriving Repr, Inhabited

/-- Package identity extracted from `lakefile.toml` (host scan). -/
public structure PackageIdentity where
  /-- Top-level `name = "…"` value (quotes stripped), if found. -/
  name : Option String := none
  /-- Top-level `defaultTargets = ["…", …]` string elements (order preserved). -/
  defaultTargets : List String := []
  /-- Count of `"…"` elements in `defaultTargets` (equals `defaultTargets.length`). -/
  defaultTargetCount : Nat := 0
  /-- Number of `[[lean_lib]]` array-of-tables headers. -/
  leanLibCount : Nat := 0
  /-- `name = "…"` values under each `[[lean_lib]]` table (order of headers). -/
  leanLibNames : List String := []
  /-- Full per-lib identity list (A16/A24/A25: name + optional srcDir + roots + globs). -/
  leanLibs : List LeanLibIdentity := []
  /-- Number of `[[require]]` array-of-tables headers (A26). -/
  requireCount : Nat := 0
  /-- Full require identity list (A26: name + optional safe path). -/
  requires : List RequireIdentity := []
  /-- Top-level package `srcDir = "…"` (quotes stripped), if found.

  Used for import-scan module path resolution (`pkg/srcDir/Foo/Bar.lean`) when no
  matching per-lib `srcDir` applies. Per-lib roots/srcDir/globs are A16/A24/A25
  subset — not full Lake faceting / full Glob / package imports. A26 path
  requires are separate from plan module path resolution. -/
  srcDir : Option String := none
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

/-- True if line is exactly `[[require]]` (optional spaces). A26 path-require subset. -/
def isRequireHeader (line : String) : Bool :=
  trimAscii line == "[[require]]"

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
    some (v.drop 1 |>.dropEnd 1).copy
  else if v.startsWith "\"" then
    none -- unclosed
  else
    some v

/-- Extract `"…"` string elements inside a closed `[ … ]` array value.

Order preserved. Fail-closed: unclosed final quote is dropped. Accepts a
single-line body or a space-joined multi-line body (see `takeBracketArray`).
Not full TOML (no nested tables, no `]`-in-string line rules). -/
public def quotedStringsInArray (v : String) : List String :=
  let t := trimAscii v
  if !(t.startsWith "[") || !(t.endsWith "]") then []
  else
    let inner := (t.drop 1 |>.dropEnd 1).copy
    -- splitOn "\"" → [pre, s0, between, s1, between, …, post]; odd indices are strings
    let parts := inner.splitOn "\""
    let rec go (ps : List String) (odd : Bool) (acc : List String) : List String :=
      match ps with
      | [] => acc.reverse
      | p :: rest =>
        if odd then go rest false (p :: acc)
        else go rest true acc
    -- first part is before first quote (even); start odd=false
    go parts false []

/-- Count `"…"` string elements inside a closed `[ … ]` array value. -/
def countQuotedInArray (v : String) : Nat :=
  (quotedStringsInArray v).length

/-- Collect a closed `[…]` array of double-quoted strings from a key value + following lines.

`v` is the trimmed RHS after `key =`. Single-line `[…]` is handled immediately.
When `v` starts with `[` but does not end with `]`, subsequent lines are joined
(space-separated) until a line ends with `]` (A18 multi-line roots / defaultTargets).
Fail-closed: missing `[`, unclosed array (EOF or next table/array-of-tables header)
→ empty list; mid-array headers (`[…]` / `[[lean_lib]]`, which end with `]`) are
**not** treated as array close — reparsed by the walker. A bare close line `]` is
not a table header (`startsWith "["` is false), so closed multi-line arrays still
work. Not full TOML. -/
public def takeBracketArray (v : String) (rest : List String) : List String × List String :=
  let t := trimAscii v
  if !(t.startsWith "[") then
    ([], rest)
  else if t.endsWith "]" then
    (quotedStringsInArray t, rest)
  else
    -- Multi-line array body: reverse-accumulate until a non-header line ends with `]`.
    let rec go (ls : List String) (partsRev : List String) : List String × List String :=
      match ls with
      | [] =>
        -- Unclosed: empty list; nothing left to reparse.
        ([], [])
      | line :: more =>
        let bare := if line.endsWith "\r" then (line.dropEnd 1).copy else line
        let tb := trimAscii bare
        -- Any table / array-of-tables header mid-body → unclosed; reparse this line.
        -- Headers end with `]` (`[[lean_lib]]`, `[package]`), so must not use
        -- endsWith "]" as close (would silently accept partial roots and drop header).
        if isTableHeader bare then
          ([], line :: more)
        else if tb.endsWith "]" then
          let parts := partsRev.reverse
          let joined := " ".intercalate (t :: parts ++ [tb])
          (quotedStringsInArray joined, more)
        else
          go more (tb :: partsRev)
    go rest []

/-- True if character may appear in a Lean module name segment chain. -/
def isModNameChar (c : Char) : Bool :=
  c.isAlphanum || c == '.' || c == '_' || c == '\''

/-- True if `s` is one safe relative path component (not empty/`.`/`..`, no separators).

Used to fail-closed `srcDir` joins and module path segments so `FilePath.join`
cannot discard `pkg` via an absolute right-hand side or walk out via `..`. -/
public def isSafePathComponent (s : String) : Bool :=
  !s.isEmpty && s != "." && s != ".." &&
    !(s.any fun c => c == '/' || c == '\\' || c == '\x00')

/-- True if `d` is a safe package-relative source directory.

Rejects absolute paths, empty, and any empty/`.`/`..` component after splitting
on `/` or `\`. Fail-closed: unsafe values are ignored at parse and resolve. -/
public def isSafeSrcDir (d : String) : Bool :=
  if d.isEmpty then false
  else if (FilePath.mk d).isAbsolute then false
  else
    let norm := d.map fun c => if c == '\\' then '/' else c
    let parts := norm.splitOn "/"
    !parts.isEmpty && parts.all isSafePathComponent

/-- True if a plan-node / import module name is a safe Lean-style identifier chain.

Rejects empty, absolute paths, path separators, empty segments, and `.` / `..`
segments. Each segment may use alphanumerics / `_` / `'` only (dots are
separators between segments). -/
public def isSafeModName (modName : String) : Bool :=
  if modName.isEmpty then false
  else if (FilePath.mk modName).isAbsolute then false
  else if modName.any fun c => c == '/' || c == '\\' || c == '\x00' then false
  else
    let segs := modName.splitOn "."
    !segs.isEmpty &&
      segs.all fun s =>
        !s.isEmpty && s != "." && s != ".." &&
          s.all (fun c => c.isAlphanum || c == '_' || c == '\'')

/-- Lake-style glob kind for A24/A25 plan expansion (host subset). -/
public inductive GlobKind where
  /-- Exact module name (`"Foo"`). -/
  | one (mod : String)
  /-- Submodules only (`"Foo.+"`) — not self; recursive multi-level (A25). -/
  | submodules (base : String)
  /-- Module + submodules (`"Foo.*"`); recursive multi-level children (A25). -/
  | andSubmodules (base : String)
  deriving Repr, Inhabited

/-- Classify a quoted glob string. Fail-closed on unsafe base / ones. -/
public def classifyGlob (g : String) : Option GlobKind :=
  if g.endsWith ".+" then
    let base := (g.dropEnd 2).copy
    if base.isEmpty || !isSafeModName base then none
    else some (.submodules base)
  else if g.endsWith ".*" then
    let base := (g.dropEnd 2).copy
    if base.isEmpty || !isSafeModName base then none
    else some (.andSubmodules base)
  else if isSafeModName g then
    some (.one g)
  else
    none

/-- True when a TOML glob string is safe to store (ones / pattern bases). -/
public def isSafeGlobString (g : String) : Bool :=
  (classifyGlob g).isSome

/-- Insert `x` into ascending sorted list (stable determinism for child modules). -/
def insertSortedString (x : String) (xs : List String) : List String :=
  match xs with
  | [] => [x]
  | y :: ys =>
    if x <= y then x :: xs else y :: insertSortedString x ys

/-- Ascending sort of module labels. -/
def sortStringsAsc (xs : List String) : List String :=
  xs.foldl (fun acc x => insertSortedString x acc) []

/-- Append `x` if not already present (first-wins order). -/
def appendUniqueMod (acc : List String) (x : String) : List String :=
  if acc.any (· == x) then acc else acc ++ [x]

/-- Append all of `xs` with first-wins dedup into `acc`. -/
def appendUniqueMods (acc : List String) (xs : List String) : List String :=
  xs.foldl appendUniqueMod acc

/-- Pure expand of globs that do not need a directory walk.

* ones → label if safe
* `M.*` → `[M]` only (children need IO)
* `M.+` → `[]` pure (children need IO)

Dedup first-wins. Not full Lake Glob — residual honesty. -/
public def expandGlobsPure (globs : List String) : List String :=
  let rec go (gs : List String) (acc : List String) : List String :=
    match gs with
    | [] => acc
    | g :: rest =>
      match classifyGlob g with
      | none => go rest acc
      | some (.one m) => go rest (appendUniqueMod acc m)
      | some (.andSubmodules m) => go rest (appendUniqueMod acc m)
      | some (.submodules _) => go rest acc
  go globs []

/-- Relative directory for immediate children of module `base`: `Foo.Bar` → `Foo/Bar`.

Returns `none` when `base` fails `isSafeModName`. -/
public def moduleSubmoduleRelDir (base : String) : Option FilePath :=
  if !isSafeModName base then none
  else some (FilePath.mk ("/".intercalate (base.splitOn ".")))

/-- Preferred directory of submodules of `base` under confining srcDir.

`pkg[/srcDir]/BasePath/` — walk root for immediate or recursive listing.
Soft callers treat missing dir as empty. -/
public def moduleSubmoduleDir (pkg : FilePath) (base : String)
    (srcDir : Option String := none) : Option FilePath :=
  match moduleSubmoduleRelDir base with
  | none => none
  | some rel =>
    let dSafe :=
      match srcDir with
      | some d => if isSafeSrcDir d then some d else none
      | none => none
    match dSafe with
    | some d => some (pkg / d / rel)
    | none => some (pkg / rel)

/-- Max directory recursion levels below the base module dir for recursive glob
walk (A25). Fail-closed: deeper dirs are not entered. Aligns with plan node
cap scale (1…16). -/
public def maxGlobWalkDirDepth : Nat := 16

/-- Max module name segments accepted during recursive glob walk (A25).

Children whose full name would exceed this are skipped (not entered). -/
public def maxGlobWalkModSegments : Nat := 16

/-- List immediate child module names of `base` under confining srcDir (IO).

Non-recursive: only regular `*.lean` **files** in `pkg[/srcDir]/basePath/`
(lstat; refuses symlinks). Child file `Bar.lean` → `base.Bar` when
`isSafeModName`. Soft-empty if dir missing / unreadable. Results sorted
ascending by full module name.

Retained immediate-only helper (unused by plan expand; A25 uses
`listSubmodulesRecursive`). -/
public def listImmediateSubmodules (pkg : FilePath) (base : String)
    (srcDir : Option String := none) : IO (List String) := do
  if !isSafeModName base then
    return []
  match moduleSubmoduleDir pkg base srcDir with
  | none => pure []
  | some dir =>
    match ← dir.symlinkMetadata.toBaseIO with
    | .error _ => pure []
    | .ok st =>
      if st.type != .dir then pure []
      else
        match ← dir.readDir.toBaseIO with
        | .error _ => pure []
        | .ok ents =>
          let rec collect (i : Nat) (acc : List String) : IO (List String) := do
            if h : i < ents.size then
              let e := ents[i]
              let name := e.fileName
              if name.endsWith ".lean" && name.length > 5 then
                -- lstat: refuse symlink / non-file (isDir follows links).
                match ← e.path.symlinkMetadata.toBaseIO with
                | .error _ => collect (i + 1) acc
                | .ok est =>
                  if est.type != .file then
                    collect (i + 1) acc
                  else
                    let stem := (name.dropEnd 5).copy
                    let child := base ++ "." ++ stem
                    if isSafeModName child && isSafePathComponent stem then
                      collect (i + 1) (child :: acc)
                    else
                      collect (i + 1) acc
              else
                collect (i + 1) acc
            else
              pure (sortStringsAsc acc)
          collect 0 []

/-- List all descendant module names of `base` under confining srcDir (IO, A25).

Lake-style recursive walk of `pkg[/srcDir]/basePath/`:
* regular `*.lean` files → `base.Stem`
* nested **real** directories that hold further `.lean` modules → recurse
  (e.g. `Nested/Deep.lean` → `base.Nested.Deep`)

Soft-empty if dir missing / unreadable. Path confinement: only safe path
components / safe module names; joins stay under `moduleSubmoduleDir`; **refuse
directory and file symlinks** via `symlinkMetadata` (best-effort lstat fence —
does not follow links into foreign trees; TOCTOU residual honesty, same class as
A17 clean). Bounds: `maxGlobWalkDirDepth` (16 dir levels below base) and
`maxGlobWalkModSegments` (16 name segments). Results sorted ascending by full
module name. Not full Lake Glob.matches / package imports. -/
public def listSubmodulesRecursive (pkg : FilePath) (base : String)
    (srcDir : Option String := none) : IO (List String) := do
  if !isSafeModName base then
    return []
  let baseSegs := (base.splitOn ".").length
  if baseSegs > maxGlobWalkModSegments then
    return []
  match moduleSubmoduleDir pkg base srcDir with
  | none => pure []
  | some rootDir =>
    -- Fence root: only a real directory (not a symlink outside pkg).
    match ← rootDir.symlinkMetadata.toBaseIO with
    | .error _ => pure []
    | .ok rst =>
      if rst.type != .dir then pure []
      else
        -- Fuel on dir depth keeps recursion fail-closed under monadic binds.
        let rec walk (d : FilePath) (modPrefix : String) (depthLeft : Nat)
            (acc : List String) : IO (List String) := do
          match depthLeft with
          | 0 => pure acc
          | depthLeft' + 1 =>
            match ← d.readDir.toBaseIO with
            | .error _ => pure acc
            | .ok ents =>
              let rec collect (i : Nat) (acc : List String) : IO (List String) := do
                if h : i < ents.size then
                  let e := ents[i]
                  let name := e.fileName
                  -- Refuse empty / `.` / `..` / separators before any join or recurse.
                  if name.isEmpty || name == "." || name == ".." ||
                      name.any (fun c => c == '/' || c == '\\' || c == '\x00') then
                    collect (i + 1) acc
                  else
                    -- lstat fence: never follow dir/file symlinks (isDir would).
                    match ← e.path.symlinkMetadata.toBaseIO with
                    | .error _ => collect (i + 1) acc
                    | .ok est =>
                      match est.type with
                      | .dir =>
                        if !isSafePathComponent name then
                          collect (i + 1) acc
                        else
                          let childPrefix := modPrefix ++ "." ++ name
                          if !isSafeModName childPrefix then
                            collect (i + 1) acc
                          else
                            let childSegs := (childPrefix.splitOn ".").length
                            if childSegs > maxGlobWalkModSegments then
                              collect (i + 1) acc
                            else
                              let acc' ← walk e.path childPrefix depthLeft' acc
                              collect (i + 1) acc'
                      | .file =>
                        if name.endsWith ".lean" && name.length > 5 then
                          let stem := (name.dropEnd 5).copy
                          let child := modPrefix ++ "." ++ stem
                          if isSafeModName child && isSafePathComponent stem then
                            let childSegs := (child.splitOn ".").length
                            if childSegs <= maxGlobWalkModSegments then
                              collect (i + 1) (child :: acc)
                            else
                              collect (i + 1) acc
                          else
                            collect (i + 1) acc
                        else
                          collect (i + 1) acc
                      | .symlink | .other =>
                        -- Soft-skip symlinks / special files (path confinement).
                        collect (i + 1) acc
                else
                  pure acc
              collect 0 acc
        let raw ← walk rootDir base maxGlobWalkDirDepth []
        pure (sortStringsAsc raw)

/-- Expand one glob string to plan module labels (IO for `.+` / `.*` children).

Dedup is the caller's responsibility across multiple globs; this returns the
labels for this glob only (self then sorted children for `.*`). A25: `.+` /
`.*` use recursive multi-level walk (`listSubmodulesRecursive`). -/
public def expandOneGlobIO (pkg : FilePath) (g : String)
    (srcDir : Option String := none) : IO (List String) := do
  match classifyGlob g with
  | none => pure []
  | some (.one m) => pure [m]
  | some (.submodules m) => listSubmodulesRecursive pkg m srcDir
  | some (.andSubmodules m) =>
    let kids ← listSubmodulesRecursive pkg m srcDir
    pure (appendUniqueMods [m] kids)

/-- Expand plan module labels from lean libs (pure; A16 roots + A24 ones-only globs).

For each lib in order:
1. if `roots` non-empty → safe root labels (roots win over globs)
2. else if `globs` non-empty → pure expand (ones + `M.*` base only; `.+` empty pure)
3. else if lib `name` is a safe mod name → name (A3 fallback)

Skips empty / unsafe labels so they do not consume the 1…16 node budget.
Does **not** dedup across libs (caller filters package-name dup only).
Submodule children require `planTargetsFromLeanLibsIO` / `planNodesIO`. -/
public def planTargetsFromLeanLibs (libs : List LeanLibIdentity) : List String :=
  let rec go (ls : List LeanLibIdentity) (acc : List String) : List String :=
    match ls with
    | [] => acc.reverse
    | lib :: rest =>
      if !lib.roots.isEmpty then
        let safeRoots := lib.roots.filter isSafeModName
        go rest (safeRoots.reverse ++ acc)
      else if !lib.globs.isEmpty then
        let expanded := expandGlobsPure lib.globs
        go rest (expanded.reverse ++ acc)
      else if !lib.name.isEmpty && isSafeModName lib.name then
        go rest (lib.name :: acc)
      else
        go rest acc
  go libs []

/-- Build DepGraph plan node labels from package identity (pure).

Order: package `name` (if present), then `defaultTargets` (skipping duplicates of
the package name), else if no targets expand lean-lib **roots** (A16) / pure
**globs** ones (A24) or fall back to each lib `name` / `leanLibNames`, else
`["(unknown)"]`. Submodule glob children need `planNodesIO`. Import-scan may
reorder when package-local import edges exist; not a full lakefile / Lake module
DAG / full Glob — residual honesty. -/
public def planNodes (id : PackageIdentity) : List String :=
  let pkg := id.name
  let targets :=
    if !id.defaultTargets.isEmpty then id.defaultTargets
    else
      let fromLibs := planTargetsFromLeanLibs id.leanLibs
      if !fromLibs.isEmpty then fromLibs else id.leanLibNames
  match pkg with
  | none =>
    if targets.isEmpty then ["(unknown)"] else targets
  | some n =>
    let rest := targets.filter (· != n)
    n :: rest

/-- Format plan nodes as a single space-separated line (no trailing space). -/
public def formatPlanNodes (nodes : List String) : String :=
  " ".intercalate nodes

/-- Relative `.lean` path for a module name: `Foo.Bar` → `Foo/Bar.lean`.

Single segment `Core` → `Core.lean`. Dots become path separators (Lake-style).
Returns `none` when `modName` fails `isSafeModName` (path-escape fail-closed). -/
public def moduleRelFile (modName : String) : Option FilePath :=
  if !isSafeModName modName then none
  else some (FilePath.mk (("/".intercalate (modName.splitOn ".")) ++ ".lean"))

/-- Preferred Lake-style module path for a plan node label.

With safe `srcDir = some "src"` and `modName = "Core"` → `pkg/src/Core.lean`.
With `modName = "Foo.Bar"` → `pkg[/srcDir]/Foo/Bar.lean`.
Without `srcDir` → `pkg/Core.lean` / `pkg/Foo/Bar.lean`.

Returns `none` when `modName` is unsafe. Unsafe `srcDir` is treated as absent
(flat under `pkg` only) so joins never escape the package prefix.
Does **not** check existence (pure preferred path). Prefer `resolveModulePath`
for first-existing among preferred + flat package-root fallback.
Not full Lake faceted roots / globs — residual honesty. -/
public def moduleRootPath (pkg : FilePath) (modName : String)
    (srcDir : Option String := none) : Option FilePath :=
  match moduleRelFile modName with
  | none => none
  | some rel =>
    let dSafe :=
      match srcDir with
      | some d => if isSafeSrcDir d then some d else none
      | none => none
    match dSafe with
    | some d => some (pkg / d / rel)
    | none => some (pkg / rel)

/-- Safe package-level `srcDir` only (fail-closed). -/
public def packageSrcDir (id : PackageIdentity) : Option String :=
  match id.srcDir with
  | some d => if isSafeSrcDir d then some d else none
  | none => none

/-- Preferred srcDir for expanding a lib's globs: safe per-lib then package. -/
public def srcDirForLib (id : PackageIdentity) (lib : LeanLibIdentity) : Option String :=
  match lib.srcDir with
  | some d => if isSafeSrcDir d then some d else packageSrcDir id
  | none => packageSrcDir id

/-- Expand a lib's globs list (order preserved, first-wins dedup within lib). -/
public def expandLibGlobsIO (pkg : FilePath) (id : PackageIdentity)
    (lib : LeanLibIdentity) : IO (List String) := do
  let srcDir := srcDirForLib id lib
  let rec go (gs : List String) (acc : List String) : IO (List String) := do
    match gs with
    | [] => pure acc
    | g :: rest =>
      let labs ← expandOneGlobIO pkg g srcDir
      go rest (appendUniqueMods acc labs)
  go lib.globs []

/-- Expand plan module labels from lean libs with IO glob walk (A24/A25).

Same priority as pure path, but `globs` use **recursive multi-level** submodule
directory walk under confining per-lib then package `srcDir` (depth-bounded).
Not full Lake Glob.matches / package imports / freestanding build TCB. -/
public def planTargetsFromLeanLibsIO (pkg : FilePath) (id : PackageIdentity)
    : IO (List String) := do
  let rec go (ls : List LeanLibIdentity) (acc : List String) : IO (List String) := do
    match ls with
    | [] => pure acc.reverse
    | lib :: rest =>
      if !lib.roots.isEmpty then
        let safeRoots := lib.roots.filter isSafeModName
        go rest (safeRoots.reverse ++ acc)
      else if !lib.globs.isEmpty then
        let expanded ← expandLibGlobsIO pkg id lib
        go rest (expanded.reverse ++ acc)
      else if !lib.name.isEmpty && isSafeModName lib.name then
        go rest (lib.name :: acc)
      else
        go rest acc
  go id.leanLibs []

/-- Build plan nodes with IO expansion of per-lib globs (A24/A25).

Prefer this on CLAIMED build plan paths so `"M.*"` / `"M.+"` include recursive
multi-level submodules. Same order/cap story as pure `planNodes`. -/
public def planNodesIO (pkg : FilePath) (id : PackageIdentity) : IO (List String) := do
  let pkgName := id.name
  let targets ← do
    if !id.defaultTargets.isEmpty then
      pure id.defaultTargets
    else
      let fromLibs ← planTargetsFromLeanLibsIO pkg id
      if !fromLibs.isEmpty then pure fromLibs else pure id.leanLibNames
  match pkgName with
  | none =>
    if targets.isEmpty then pure ["(unknown)"] else pure targets
  | some n =>
    pure (n :: targets.filter (· != n))

/-- True when glob `g` owns module `modName` for path resolution (pure prefix match).

* one `M` → exact
* `M.*` → `M` or `M.<child…>` prefix (any depth)
* `M.+` → strict `M.<child…>` prefix only (any depth)

Not full Lake Glob.matches (no package imports / needs / facets). -/
public def globMatchesModule (g : String) (modName : String) : Bool :=
  if !isSafeModName modName then false
  else
    match classifyGlob g with
    | none => false
    | some (.one m) => m == modName
    | some (.submodules m) =>
      modName.startsWith (m ++ ".")
    | some (.andSubmodules m) =>
      m == modName || modName.startsWith (m ++ ".")

/-- True when this lean_lib "owns" module `modName` for path resolution.

Match if `modName` is in `roots`, or (when roots empty and globs non-empty) any
glob owns the module (A24/A25 prefix, multi-level children), or (when both empty)
lib `name` equals `modName`. Non-empty roots do not fall back to globs/name —
plan nodes are the roots list. -/
public def leanLibOwnsModule (lib : LeanLibIdentity) (modName : String) : Bool :=
  if !lib.roots.isEmpty then lib.roots.any (· == modName)
  else if !lib.globs.isEmpty then lib.globs.any (fun g => globMatchesModule g modName)
  else !lib.name.isEmpty && lib.name == modName

/-- Preferred source directory for resolving module `modName` (A16/A24/A25).

1. First lean_lib that owns `modName` and has a **safe** `srcDir` → that dir
2. Else if a owning lib exists without safe srcDir → package-level `srcDir`
3. Else package-level `srcDir`

Unsafe lib/package `srcDir` values are ignored (fail-closed; no `..` / absolute).
Not full Lake multi-lib faceting — residual honesty. -/
public def srcDirForModule (id : PackageIdentity) (modName : String) : Option String :=
  let rec find (libs : List LeanLibIdentity) : Option (Option String) :=
    match libs with
    | [] => none
    | lib :: rest =>
      if leanLibOwnsModule lib modName then
        -- Found owner: use its safe srcDir, else `some none` → package fallback.
        match lib.srcDir with
        | some d =>
          if isSafeSrcDir d then some (some d) else some none
        | none => some none
      else
        find rest
  match find id.leanLibs with
  | some (some d) => some d
  | some none => packageSrcDir id
  | none => packageSrcDir id

/-- True when identity carries any per-lib `roots` or per-lib `srcDir` (A16 honesty). -/
public def hasPerLibRootsOrSrcDir (id : PackageIdentity) : Bool :=
  id.leanLibs.any fun lib => !lib.roots.isEmpty || lib.srcDir.isSome

/-- True when identity carries any per-lib `globs` (A24/A25 honesty). -/
public def hasPerLibGlobs (id : PackageIdentity) : Bool :=
  id.leanLibs.any fun lib => !lib.globs.isEmpty

/-- True when globs drive plan targets for at least one lib (A24/A25).

Requires empty package `defaultTargets` and a lib with empty `roots` and non-empty
`globs` (roots still win when set). -/
public def usesPerLibGlobs (id : PackageIdentity) : Bool :=
  id.defaultTargets.isEmpty &&
    id.leanLibs.any fun lib => lib.roots.isEmpty && !lib.globs.isEmpty

/-- True when identity carries any `[[require]]` with a safe relative path (A26/A29). -/
public def hasPathRequires (id : PackageIdentity) : Bool :=
  id.requires.any fun r => r.path.isSome

/-- Path requires only (safe relative / sibling confining `path` present). Order preserved. -/
public def pathRequires (id : PackageIdentity) : List RequireIdentity :=
  id.requires.filter fun r => r.path.isSome

/-- A29 monorepo sibling form: exactly one leading `..` then ≥1 safe components.

Examples accepted: `../dep`, `../packages/foo`. Rejected: `..`, `../../x`,
`foo/../bar`, absolute, empty, mid-path `..`. Confining root at resolve is the
**package parent** (not full workspace walk-up / not multi-`..` escape). -/
public def isSiblingConfiningRequirePath (d : String) : Bool :=
  if d.isEmpty then false
  else if (FilePath.mk d).isAbsolute then false
  else
    let norm := d.map fun c => if c == '\\' then '/' else c
    let parts := norm.splitOn "/"
    match parts with
    | ".." :: rest =>
      -- ≥1 trailing component; each must be a safe path component (no further `..`).
      !rest.isEmpty && rest.all isSafePathComponent
    | _ => false

/-- Drop leading `../` from an A29 sibling path; return the remainder under parent.

`none` when not sibling form. Rest may contain `/` (e.g. `packages/foo`). -/
public def siblingRequireRest (d : String) : Option String :=
  if !isSiblingConfiningRequirePath d then none
  else
    let norm := d.map fun c => if c == '\\' then '/' else c
    -- `../` is three chars; bare `..` alone already rejected by isSibling…
    if norm.startsWith "../" then some (norm.drop 3).copy
    else none

/-- Safe require path = A26 under-package dir **or** A29 sibling confining `../…`.

A26: same confinement as package `srcDir` (relative, no `..`).
A29: exactly one leading `..` + ≥1 safe components (package-parent confining).
Rejects absolute / empty / multi-`..` / bare `..` / mid-path `..`. Not full Lake
path require / not workspace multi-level walk-up. -/
public def isSafeRequirePath (d : String) : Bool :=
  isSafeSrcDir d || isSiblingConfiningRequirePath d

/-- Resolve a path-require directory under the consumer package (A26) or its parent (A29).

- A26 safe relative: `pkg / path`
- A29 sibling confining: `pkg.parent / rest` after stripping one leading `..`
  (fails closed when package has no parent, or rest missing)

Returns `none` when path is missing/unsafe/unresolvable. Does **not** check
filesystem existence (caller may soft-skip or fail-closed; real-dir lstat fence
is CLI-side). -/
public def resolveRequirePath (pkg : FilePath) (r : RequireIdentity) : Option FilePath :=
  match r.path with
  | none => none
  | some p =>
    if isSafeSrcDir p then
      some (pkg / p)
    else if isSiblingConfiningRequirePath p then
      match siblingRequireRest p, pkg.parent with
      | some rest, some parent =>
        if rest.isEmpty then none else some (parent / rest)
      | _, _ => none
    else
      none

/-- Collect unique safe package + per-lib source directories (order: package first,
then libs). Used for LEAN_PATH multi-root feed — not Lake full search path. -/
public def allSafeSrcDirs (id : PackageIdentity) : List String :=
  let pkg :=
    match packageSrcDir id with
    | some d => [d]
    | none => []
  let rec libs (ls : List LeanLibIdentity) (acc : List String) : List String :=
    match ls with
    | [] => acc.reverse
    | lib :: rest =>
      match lib.srcDir with
      | some d =>
        if isSafeSrcDir d && !(acc.any (· == d)) && !(pkg.any (· == d)) then
          libs rest (d :: acc)
        else
          libs rest acc
      | none => libs rest acc
  pkg ++ libs id.leanLibs []

/-- First existing module path among srcDir/dotted preferred and flat fallbacks.

Order (first hit wins), only for `isSafeModName` labels:
1. `pkg / srcDir / Foo/Bar.lean` when safe `srcDir` present
2. `pkg / Foo/Bar.lean` (dotted under package root; also undotted `Core.lean`)
3. `pkg / Name.lean` with **literal dots preserved** (e.g. `pkg/Foo.Bar.lean`) when
   that path differs from preferred and underPkg (legacy flat dotted filename)

Returns `none` when `modName` is unsafe (caller must not `readFile` outside pkg).
When safe but nothing exists, returns preferred so callers can soft-skip.
Pass per-module `srcDir` via `srcDirForModule id modName` for A16 per-lib roots. -/
public def resolveModulePath (pkg : FilePath) (modName : String)
    (srcDir : Option String := none) : IO (Option FilePath) := do
  if !isSafeModName modName then
    return none
  match moduleRelFile modName, moduleRootPath pkg modName srcDir with
  | none, _ => return none
  | _, none => return none
  | some rel, some preferred =>
    let underPkg := pkg / rel
    let flatLegacy := pkg / s!"{modName}.lean"
    let candidates : List FilePath :=
      let base :=
        if preferred != underPkg then [preferred, underPkg] else [preferred]
      if flatLegacy != preferred && flatLegacy != underPkg then
        base ++ [flatLegacy]
      else base
    let rec first (cs : List FilePath) : IO FilePath :=
      match cs with
      | [] => pure preferred
      | c :: rest => do
        if ← c.pathExists then pure c else first rest
    return some (← first candidates)

/-- Resolve module path using package identity (A16 per-lib `srcDir` + package). -/
public def resolveModulePathFor (pkg : FilePath) (id : PackageIdentity)
    (modName : String) : IO (Option FilePath) :=
  resolveModulePath pkg modName (srcDirForModule id modName)

/-- True if line is a Lean line/block comment start (after trim). -/
def isLeanCommentLine (line : String) : Bool :=
  let t := trimAscii line
  t.startsWith "--" || t.startsWith "/-"

/-- True if `s` contains the Lean block-comment close token (hyphen + slash). -/
def containsBlockClose (s : String) : Bool :=
  (s.splitOn "-/").length > 1

/-- True if line opens a multi-line block comment that does not close on the same line. -/
def opensUnclosedBlock (line : String) : Bool :=
  let t := trimAscii line
  t.startsWith "/-" && !containsBlockClose t

/-- Drop keyword `kw` only when followed by whitespace; return trimmed remainder.

Fail-closed: no match, or keyword without a following whitespace-separated token. -/
def afterKeyword (s : String) (kw : String) : Option String :=
  if !s.startsWith kw then none
  else
    let rest := (s.drop kw.length).copy
    let trimmed := (rest.dropWhile Char.isWhitespace).copy
    -- Require at least one whitespace char after the keyword (tab/space/…).
    if trimmed.length == rest.length then none
    else if trimmed.isEmpty then none
    else some trimmed

/-- Parse a top-level import target from one source line.

Accepts fail-closed prefixes only (keyword + whitespace, not a full Lean parser):
* `import X` / `import\tX`
* `public import X`
* `meta import X`
* `public meta import X`
* `import all X`
* `public import all X`
* `meta import all X` / `public meta import all X`

Returns the module name token (may contain `.`). -/
public def parseImportTarget (line : String) : Option String :=
  let t0 := trimAscii line
  if t0.isEmpty || t0.startsWith "#" || isLeanCommentLine t0 then
    none
  else
    -- Optional `public` + whitespace.
    let t1 := match afterKeyword t0 "public" with
      | some t => t
      | none => t0
    -- Optional `meta` + whitespace (after public, before import).
    let t1b := match afterKeyword t1 "meta" with
      | some t => t
      | none => t1
    match afterKeyword t1b "import" with
    | none => none
    | some t2 =>
      -- Optional `all` keyword (only when followed by whitespace).
      let t3 := match afterKeyword t2 "all" with
        | some t => t
        | none => t2
      let name := (t3.takeWhile isModNameChar).copy
      if name.isEmpty then none else some name

/-- True if line is a module preamble token we skip while scanning imports. -/
def isPreambleLine (line : String) : Bool :=
  let t := trimAscii line
  t == "module" || t == "prelude" || t.startsWith "module " || t.startsWith "prelude "

/-- Scan Lean source for top-level import targets (order preserved).

Stops at the first non-blank, non-comment, non-preamble, non-import line.
Tracks multi-line block-comment open/close so mid-comment lines are not treated
as imports and imports after a close are still seen. Still not a full Lean
parser (nested block comments, same-line code+comment mixes remain residual). -/
public def scanModuleImports (text : String) : List String :=
  let lines := text.splitOn "\n"
  let rec go (ls : List String) (acc : List String) (inBlock : Bool) : List String :=
    match ls with
    | [] => acc.reverse
    | line :: rest =>
      let bare := if line.endsWith "\r" then (line.dropEnd 1).copy else line
      if inBlock then
        if containsBlockClose bare then go rest acc false
        else go rest acc true
      else if isBlankOrComment bare || isPreambleLine bare then
        go rest acc false
      else if opensUnclosedBlock bare then
        go rest acc true
      else if isLeanCommentLine bare then
        -- Full-line line-comment or same-line block comment open+close
        go rest acc false
      else
        match parseImportTarget bare with
        | some name => go rest (name :: acc) false
        | none => acc.reverse
  go lines [] false

/-- Index of `name` in `nodes`, if any. -/
def nodeIndex (nodes : List String) (name : String) : Option Nat :=
  let rec go (ns : List String) (i : Nat) : Option Nat :=
    match ns with
    | [] => none
    | n :: rest => if n == name then some i else go rest (i + 1)
  go nodes 0

/-- True if edge `e` is already in `es` (exact `(src,dst)` pair). -/
def hasEdge (es : List (Nat × Nat)) (e : Nat × Nat) : Bool :=
  match es with
  | [] => false
  | x :: xs => x == e || hasEdge xs e

/-- Resolve a plan module source: package-local first, then optional A30 path-dep map.

`extraSrc` maps module name → readable `.lean` under a path-require package
(A30 package-transitive plan subset). Package-local wins on flat-name collision
with a path-dep inventory entry (root `Lib` not shadowed by path-dep `Lib`).
Path-dep-only names (e.g. `Dep`) fall through to `extraSrc`. Not full Lake search. -/
public def resolveModulePathForWithExtra (pkg : FilePath) (id : PackageIdentity)
    (modName : String) (extraSrc : List (String × FilePath) := [])
    : IO (Option FilePath) := do
  -- `resolveModulePathFor` may return a preferred path that does not exist
  -- (flat-fallback residual). Only treat package-local as a hit when the file is
  -- present so path-dep-only names (e.g. `Dep`) fall through to `extraSrc`.
  match ← resolveModulePathFor pkg id modName with
  | some p =>
    if ← p.pathExists then pure (some p)
    else
      match extraSrc.find? (fun p => p.1 == modName) with
      | some (_, src) => pure (some src)
      | none => pure none
  | none =>
    match extraSrc.find? (fun p => p.1 == modName) with
    | some (_, src) => pure (some src)
    | none => pure none

/-- Collect directed import edges among plan nodes.

For each plan node, resolve a readable `.lean` via `resolveModulePathFor`
(A16/A24: per-lib `srcDir` when the module is owned by that lib via `roots`,
expanded `globs` ownership — ones / `.+` / `.*` prefix match — or lib `name`;
else package `srcDir`; + dotted `Foo/Bar.lean`, flat package-root fallback),
or via optional `extraSrc` map (A30 path-dep plan modules under path-require
packages), then parse top-level imports. When import target `T` is also a plan
node and differs from importer `M`, emit edge `T → M` (T must precede M).
External imports (e.g. `Init`) ignored. Self-imports ignored. **Duplicate
`(src,dst)` pairs are dropped** so capacity (`PKG_MDEG` / `PKG_MAX_EDGES`)
reflects unique constraints.

Returns unique `(srcIdx, dstIdx)` pairs (first-seen order). Nested/srcDir /
per-lib roots + globs ownership subset + A30 path-dep src map — not full Lake
import resolution / faceting / package imports. -/
public def collectImportEdges (pkg : FilePath) (nodes : List String)
    (id : PackageIdentity := {})
    (extraSrc : List (String × FilePath) := []) : IO (List (Nat × Nat)) := do
  let rec scanNode (ns : List String) (i : Nat) (acc : List (Nat × Nat))
      : IO (List (Nat × Nat)) := do
    match ns with
    | [] => return acc.reverse
    | name :: rest =>
      match ← resolveModulePathForWithExtra pkg id name extraSrc with
      | none =>
        -- Unsafe/unresolved names skipped; path-dep sources may be opened only
        -- via confining `extraSrc` inventory from path-require resolve (A26/A30).
        scanNode rest (i + 1) acc
      | some path =>
        if !(← path.pathExists) then
          scanNode rest (i + 1) acc
        else
          try
            let text ← IO.FS.readFile path
            let imps := scanModuleImports text
            let rec addImps (ts : List String) (a : List (Nat × Nat)) : List (Nat × Nat) :=
              match ts with
              | [] => a
              | t :: tr =>
                -- Only match import targets that are safe plan-node labels.
                if !isSafeModName t then addImps tr a
                else
                  match nodeIndex nodes t with
                  | none => addImps tr a
                  | some j =>
                    if j == i then addImps tr a
                    else
                      let e := (j, i)
                      if hasEdge a e then addImps tr a
                      else addImps tr (e :: a)
            scanNode rest (i + 1) (addImps imps acc)
          catch _ =>
            scanNode rest (i + 1) acc
  scanNode nodes 0 []

/-- Host-side Kahn topo for PLAN_ONLY when freestanding DepGraph is unlinked.

`edges` are `(src, dst)` with src preceding dst. Returns `none` on cycle /
bounds. Seeds zero-indegree nodes in ascending index order (matches freestanding
`seedZeroGo`). -/
public def hostKahnTopo (n : Nat) (edges : List (Nat × Nat)) : Option (List Nat) :=
  if n == 0 then none
  else
    -- indeg array as List Nat of length n
    let indeg0 := List.replicate n 0
    let rec addEdge (indeg : List Nat) (e : Nat × Nat) : Option (List Nat) :=
      let (s, d) := e
      if s >= n || d >= n then none
      else
        match indeg[d]? with
        | none => none
        | some v => some (indeg.set d (v + 1))
    let rec fill (es : List (Nat × Nat)) (indeg : List Nat) : Option (List Nat) :=
      match es with
      | [] => some indeg
      | e :: rest =>
        match addEdge indeg e with
        | none => none
        | some indeg' => fill rest indeg'
    match fill edges indeg0 with
    | none => none
    | some indeg =>
      -- adjacency: src → list of dst
      let adj0 := List.replicate n ([] : List Nat)
      let rec addAdj (adj : List (List Nat)) (e : Nat × Nat) : Option (List (List Nat)) :=
        let (s, d) := e
        if s >= n || d >= n then none
        else
          match adj[s]? with
          | none => none
          | some outs => some (adj.set s (outs ++ [d]))
      let rec fillAdj (es : List (Nat × Nat)) (adj : List (List Nat))
          : Option (List (List Nat)) :=
        match es with
        | [] => some adj
        | e :: rest =>
          match addAdj adj e with
          | none => none
          | some adj' => fillAdj rest adj'
      match fillAdj edges adj0 with
      | none => none
      | some adj =>
        let rec seed (i : Nat) (indeg : List Nat) (q : List Nat) : List Nat :=
          if i >= n then q.reverse
          else
            match indeg[i]? with
            | some 0 => seed (i + 1) indeg (i :: q)
            | _ => seed (i + 1) indeg q
        let q0 := seed 0 indeg []
        -- Fuel bounds steps (n nodes max); avoids non-structural recursion on queue.
        let rec kahn (fuel : Nat) (q : List Nat) (indeg : List Nat) (out : List Nat) (left : Nat)
            : Option (List Nat) :=
          match fuel with
          | 0 => none
          | fuel' + 1 =>
            match q with
            | [] =>
              if left == 0 then some out.reverse else none
            | u :: qs =>
              match adj[u]? with
              | none => none
              | some outs =>
                let rec relax (ds : List Nat) (indeg : List Nat) (qacc : List Nat)
                    : Option (List Nat × List Nat) :=
                  match ds with
                  | [] => some (indeg, qacc)
                  | d :: dr =>
                    match indeg[d]? with
                    | none => none
                    | some v =>
                      if v == 0 then none
                      else
                        let v' := v - 1
                        let indeg' := indeg.set d v'
                        if v' == 0 then relax dr indeg' (qacc ++ [d])
                        else relax dr indeg' qacc
                match relax outs indeg [] with
                | none => none
                | some (indeg', newq) =>
                  kahn fuel' (qs ++ newq) indeg' (u :: out) (left - 1)
        kahn (n + 1) q0 indeg [] n

/-- Commit in-progress lean_lib into package identity (A16). -/
def commitLeanLib (id : PackageIdentity) (cur : Option LeanLibIdentity) : PackageIdentity :=
  match cur with
  | none => id
  | some lib =>
    { id with
      leanLibs := id.leanLibs ++ [lib]
      leanLibNames :=
        if lib.name.isEmpty then id.leanLibNames else id.leanLibNames ++ [lib.name] }

/-- Max stored `[[require]]` identities (A26). Headers beyond this still increment
`requireCount` for banner honesty (`require-cap=16` when truncated). -/
public def requireIdentityCap : Nat := 16

/-- True when TOML had more `[[require]]` headers than stored identities (A26 cap). -/
public def requiresTruncated (id : PackageIdentity) : Bool :=
  id.requireCount > id.requires.length

/-- Commit in-progress require into package identity (A26). Cap at `requireIdentityCap`.

Headers beyond the cap still count in `requireCount` (scan) but are not stored —
banner shows `require-cap=16` when truncated. -/
def commitRequire (id : PackageIdentity) (cur : Option RequireIdentity) : PackageIdentity :=
  match cur with
  | none => id
  | some r =>
    if id.requires.length >= requireIdentityCap then id
    else { id with requires := id.requires ++ [r] }

/-- Commit both in-progress lean_lib and require (table transition). -/
def commitOpenTables (id : PackageIdentity) (curLib : Option LeanLibIdentity)
    (curReq : Option RequireIdentity) : PackageIdentity :=
  commitRequire (commitLeanLib id curLib) curReq

/-- Scan full TOML text for package identity (first top-level `name` only).

Under each `[[lean_lib]]`: optional `name`, safe `srcDir`, `roots` / `globs`
arrays of double-quoted strings (single- or multi-line via `takeBracketArray`;
same quote-scan as package `defaultTargets`). First `roots` / first `globs`
assignment each wins. Unsafe per-lib `srcDir` / unsafe root labels / unsafe glob
strings ignored fail-closed.

Under each `[[require]]` (A26/A29): optional `name`, optional path — A26 safe
relative (no absolute / no `..`) **or** A29 sibling confining `../dep` (one
leading `..` + ≥1 safe components). First assignment each wins. Git/url keys
ignored (path-only subset). Cap 16 requires. Not Lake resolve-deps / not git
clone TCB. -/
public def scanTomlText (text : String) : PackageIdentity :=
  let lines := text.splitOn "\n"
  -- Fuel bounds recursion: multi-line array consume jumps `rest'` (not always
  -- a structural suffix Lean can see), so decrease on Nat fuel.
  let rec go (fuel : Nat) (ls : List String) (inTable : Bool) (inLeanLib : Bool)
      (inRequire : Bool) (curLib : Option LeanLibIdentity)
      (curReq : Option RequireIdentity) (id : PackageIdentity) : PackageIdentity :=
    match fuel with
    | 0 => commitOpenTables id curLib curReq
    | fuel' + 1 =>
      match ls with
      | [] => commitOpenTables id curLib curReq
      | line :: rest =>
        let bare := if line.endsWith "\r" then (line.dropEnd 1).copy else line
        if isBlankOrComment bare then
          go fuel' rest inTable inLeanLib inRequire curLib curReq id
        else if isTableHeader bare then
          let id := commitOpenTables id curLib curReq
          if isLeanLibHeader bare then
            go fuel' rest true true false (some {}) none
              { id with leanLibCount := id.leanLibCount + 1 }
          else if isRequireHeader bare then
            go fuel' rest true false true none (some {})
              { id with requireCount := id.requireCount + 1 }
          else
            go fuel' rest true false false none none id
        else if inLeanLib then
          match curLib, lineKeyValue bare with
          | some lib, some ("name", v) =>
            match stripQuotes v with
            | some n =>
              -- First closed name wins on the structure; leanLibNames filled at commit.
              let lib := if lib.name.isEmpty then { lib with name := n } else lib
              go fuel' rest inTable inLeanLib inRequire (some lib) none id
            | none => go fuel' rest inTable inLeanLib inRequire curLib none id
          | some lib, some ("srcDir", v) =>
            match stripQuotes v with
            | some d =>
              -- Fail-closed: empty / absolute / `..` → leave absent (no path escape).
              let lib :=
                if lib.srcDir.isNone && isSafeSrcDir d then { lib with srcDir := some d }
                else lib
              go fuel' rest inTable inLeanLib inRequire (some lib) none id
            | none => go fuel' rest inTable inLeanLib inRequire curLib none id
          | some lib, some ("roots", v) =>
            -- First `roots = [...]` wins (single- or multi-line; A16/A18).
            -- Always consume multi-line body so mid-array lines are not reparsed.
            -- Drop labels that fail `isSafeModName` so unsafe tokens never enter plan
            -- expansion or own-module path matching (A16 hygiene).
            let (ts, rest') := takeBracketArray v rest
            let lib :=
              if lib.roots.isEmpty then
                { lib with roots := ts.filter isSafeModName }
              else lib
            go fuel' rest' inTable inLeanLib inRequire (some lib) none id
          | some lib, some ("globs", v) =>
            -- First `globs = [...]` wins (single- or multi-line; A24/A18).
            -- Always consume multi-line body; filter unsafe ones / pattern bases.
            let (ts, rest') := takeBracketArray v rest
            let lib :=
              if lib.globs.isEmpty then
                { lib with globs := ts.filter isSafeGlobString }
              else lib
            go fuel' rest' inTable inLeanLib inRequire (some lib) none id
          | _, _ => go fuel' rest inTable inLeanLib inRequire curLib none id
        else if inRequire then
          match curReq, lineKeyValue bare with
          | some r, some ("name", v) =>
            match stripQuotes v with
            | some n =>
              let r := if r.name.isEmpty then { r with name := n } else r
              go fuel' rest inTable false inRequire none (some r) id
            | none => go fuel' rest inTable false inRequire none curReq id
          | some r, some ("path", v) =>
            match stripQuotes v with
            | some p =>
              -- Fail-closed: absolute / multi-`..` escape / bare `..` / empty → absent.
              -- A26 under-pkg and A29 sibling confining `../dep` accepted.
              let r :=
                if r.path.isNone && isSafeRequirePath p then { r with path := some p }
                else r
              go fuel' rest inTable false inRequire none (some r) id
            | none => go fuel' rest inTable false inRequire none curReq id
          | _, _ => go fuel' rest inTable false inRequire none curReq id
        else if inTable then
          -- Other tables: skip key/values for package-level identity.
          go fuel' rest inTable false false none none id
        else
          match lineKeyValue bare with
          | none => go fuel' rest inTable false false none none id
          | some (k, v) =>
            if k == "name" && id.name.isNone then
              match stripQuotes v with
              | some n => go fuel' rest inTable false false none none { id with name := some n }
              | none => go fuel' rest inTable false false none none id
            else if k == "defaultTargets" then
              -- Single- or multi-line double-quoted array (A18); last assignment wins
              -- (same as pre-A18 single-line overwrite).
              let (ts, rest') := takeBracketArray v rest
              go fuel' rest' inTable false false none none
                { id with defaultTargets := ts, defaultTargetCount := ts.length }
            else if k == "srcDir" && id.srcDir.isNone then
              match stripQuotes v with
              | some d =>
                -- Fail-closed: empty / absolute / `..` components → absent (no path escape).
                if !isSafeSrcDir d then go fuel' rest inTable false false none none id
                else go fuel' rest inTable false false none none { id with srcDir := some d }
              | none => go fuel' rest inTable false false none none id
            else
              go fuel' rest inTable false false none none id
  go (lines.length + 1) lines false false false none none {}

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
  let src := match id.srcDir with
    | some d => s!" srcDir={d}"
    | none => ""
  let perLib :=
    if hasPerLibRootsOrSrcDir id then " per-lib-roots/srcDir" else ""
  let globs :=
    if hasPerLibGlobs id then " per-lib-globs" else ""
  let req :=
    if id.requireCount > 0 then
      let pathN := (pathRequires id).length
      let cap :=
        if requiresTruncated id then s!" require-cap={requireIdentityCap}" else ""
      s!" require={id.requireCount} path-require={pathN}{cap}"
    else ""
  s!"name={name} defaultTargets={id.defaultTargetCount} lean_lib={id.leanLibCount}{src}{perLib}{globs}{req}"

end Slake.Config
