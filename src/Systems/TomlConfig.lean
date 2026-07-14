/-
Copyright (c) 2026 Hunter Beast. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Hunter Beast
-/
module
prelude
public import Systems.Scalars
public import Systems.Bytes
public import Systems.Status

/-!
# Systems.TomlConfig (Systems Lean)

lakefile.toml-**subset** decode over dual caller `addr`/`len` byte views — Slake
config-shaped scan (package `name` / `version`, `[[lean_lib]]` / `[[lean_exe]]` /
`[[require]]` counts, `srcDir` / `defaultTargets` / `buildType` helpers,
`path =` count for require-shaped deps, key lookup). **Not** full TOML 1.0,
**not** Lean DSL, **not** Toml line API alone, **not** TomlQuery key-only
query.

Recognized line shapes (ASCII bytes; `\n` / `\r\n` line ends):

* **blank** — empty line (optional trailing `\r`)
* **comment** — line whose first non-space byte is `#`
* **table** — `[name]` with non-empty `name` (no `]` inside name)
* **array-of-tables** — `[[name]]` with non-empty `name` (accepted; distinct from
  Toml/TomlQuery which **reject** `[[…]]`)
* **key = value** — first `=` splits key from value; optional spaces around `=`

Ops (config-focused surface):

* **validate** / **scan** — structural scan; `0` ok, `1` invalid (fail-closed subset)
* **packageNameOff** / **packageNameLen** — top-level `name = …` value span
  (optional surrounding `"` stripped)
* **versionOff** / **versionLen** — top-level `version = …` value span (quotes stripped)
* **leanLibCount** — number of well-formed `[[lean_lib]]` headers
* **leanExeCount** — number of well-formed `[[lean_exe]]` headers
* **requireCount** — number of well-formed `[[require]]` headers
* **requirePathCount** — global count of well-formed `path = …` keys (require-shaped)
* **requirePathScopedCount** — count of `path = …` only while the current table
  context is a well-formed `[[require]]` (fail-closed; other tables clear scope)
* **defaultTargetsCount** — fail-closed count of `"…"` elements in a
  `defaultTargets = […]` value (non-array / unclosed → `0`)
* **hasDefaultTargets** — top-level `defaultTargets = …` presence
* **moreLeanArgsCount** — quote-count style for `moreLeanArgs = […]` (same policy as
  `defaultTargetsCount`)
* **hasBackend** — top-level `backend = …` presence
* **hasTestDriver** / **hasLintDriver** — top-level driver key presence (W68 more3)
* **weakLeanArgsCount** — quote-count style for `weakLeanArgs = […]` (W68 more3)
* **firstLeanLibNameOff** / **firstLeanLibNameLen** — first `name = …` under the
  first well-formed `[[lean_lib]]` scope (quotes stripped; W68 more3)
* **hasPlatformIndependent** / **hasPreferReleaseBuild** — first non-comment
  key match for those names (W69 more4; **not** true top-level-only — table
  bodies are not excluded; same global first-match policy as more2/3)
* **leanArgsCount** — quote-count style for `leanArgs = […]` (W69 more4)
* **firstLeanExeNameOff** / **firstLeanExeNameLen** — first `name = …` under the
  first well-formed `[[lean_exe]]` scope (quotes stripped; W69 more4)
* **moreLinkArgsCount** — quote-count style for `moreLinkArgs = […]` (W70 more5)
* **hasBuildArchive** / **hasSupportInterpreter** — first non-comment key match
  (W70 more5; table bodies not excluded — same global first-match as more4)
* **firstRequireNameOff** / **firstRequireNameLen** — first `name = …` under the
  first well-formed `[[require]]` scope (quotes stripped; W70 more5)
* **weakLinkArgsCount** — quote-count style for `weakLinkArgs = […]` (W71 more6)
* **hasEnableArtifactCache** / **hasPrecompileModules** — first non-comment key match
  (W71 more6; table bodies not excluded — same global first-match as more5)
* **firstLeanLibRootOff** / **firstLeanLibRootLen** — first `root = …` under the
  first well-formed `[[lean_lib]]` scope (quotes stripped; W71 more6)
* **hasPackagesDir** / **hasReservoir** — first non-comment key match
  (W72 more7; table bodies not excluded — same global first-match as more6)
* **firstLeanExeRootOff** / **firstLeanExeRootLen** — first `root = …` under the
  first well-formed `[[lean_exe]]` scope (quotes stripped; W72 more7)
* **hasBuildDir** / **hasWrappersDir** — first non-comment key match
  (W73 more8; table bodies not excluded — same global first-match as more7)
* **firstRequirePathOff** / **firstRequirePathLen** — first `path = …` under the
  first well-formed `[[require]]` scope (quotes stripped; W73 more8)
* **hasNativeLibDir** / **hasTestDriverArgs** — first non-comment key match
  (W74 more9; table bodies not excluded — same global first-match as more8)
* **firstRequireRevOff** / **firstRequireRevLen** — first `rev = …` under the
  first well-formed `[[require]]` scope (quotes stripped; W74 more9)
* **hasLintDriverArgs** / **hasMoreLinkArgs** — first non-comment key match
  (W75 more10; table bodies not excluded — same global first-match as more9)
* **firstRequireGitOff** / **firstRequireGitLen** — first `git = …` under the
  first well-formed `[[require]]` scope (quotes stripped; W75 more10)
* **hasLeanOptions** / **hasMoreServerOptions** — first non-comment key match
  (W76 more11; table bodies not excluded — same global first-match as more10)
* **firstRequireUrlOff** / **firstRequireUrlLen** — first `url = …` under the
  first well-formed `[[require]]` scope (quotes stripped; W76 more11)
* **hasManifest** / **hasVersionTags** — first non-comment key match
  (W77 more12; table bodies not excluded — same global first-match as more11;
  **shaped presence scan only** — `manifest` is not claimed as a real Lake
  `PackageConfig` TOML field; `versionTags` is a real Lake key; both are fail-closed
  byte-key presence, not typed config decode)
* **firstRequireVersionOff** / **firstRequireVersionLen** — first `version = …` under the
  first well-formed `[[require]]` scope (quotes stripped; W77 more12; reuses `isVersionKey`)
* **hasDescription** / **hasKeywords** — first non-comment key match
  (W78 more13; table bodies not excluded — same global first-match as more12;
  real Lake `PackageConfig` keys; **shaped presence scan only**, not typed decode)
* **firstRequireScopeOff** / **firstRequireScopeLen** — first `scope = …` under the
  first well-formed `[[require]]` scope (quotes stripped; W78 more13)
* **hasHomepage** / **hasLicense** — first non-comment key match
  (W79 more14; table bodies not excluded — same global first-match as more13;
  real Lake `PackageConfig` keys; **shaped presence scan only**, not typed decode)
* **firstRequireSubDirOff** / **firstRequireSubDirLen** — first `subDir = …` under the
  first well-formed `[[require]]` scope (quotes stripped; W79 more14; real Lake
  Dependency git `subDir` field)
* **hasReadmeFile** / **hasLicenseFiles** — first non-comment key match
  (W80 more15; table bodies not excluded — same global first-match as more14;
  real Lake `PackageConfig` keys `readmeFile` / `licenseFiles`; **shaped presence
  scan only**, not typed decode)
* **firstRequireOptsOff** / **firstRequireOptsLen** — first `opts = …` under the
  first well-formed `[[require]]` scope (quotes stripped; W80 more15; real Lake
  Dependency `opts` field presence/value span — not NameMap decode)
* **hasBootstrap** / **hasMoreServerArgs** / **hasReleaseRepo** — first non-comment key match
  (W81 more16; table bodies not excluded — same global first-match as more15;
  real Lake `PackageConfig` keys `bootstrap` / `moreServerArgs` / `releaseRepo`;
  **shaped presence scan only**, not typed decode; three package presence keys —
  Dependency field surface already covered through more15)
* **hasLeanLibDir** / **hasBinDir** / **hasIrDir** — first non-comment key match
  (W82 more17; table bodies not excluded — same global first-match as more16;
  real Lake `PackageConfig` keys `leanLibDir` / `binDir` / `irDir`;
  **shaped presence scan only**, not typed decode; three package presence keys)
* **hasExtraDepTargets** / **hasRestoreAllArtifacts** / **hasLibPrefixOnWindows** — first non-comment key match
  (W83 more18; table bodies not excluded — same global first-match as more17;
  real Lake `PackageConfig` keys `extraDepTargets` / `restoreAllArtifacts` / `libPrefixOnWindows`;
  **shaped presence scan only**, not typed decode; three package presence keys;
  `restoreAllArtifacts` prefers the non-`?` form users write in TOML)
* **hasAllowImportAll** / **hasFixedToolchain** / **hasVersion** — first non-comment key match
  (W84 more19; table bodies not excluded — same global first-match as more18;
  real Lake `PackageConfig` keys `allowImportAll` / `fixedToolchain` / `version`;
  **shaped presence scan only**, not typed decode / not SemVer decode; three package presence keys;
  `hasVersion` is presence-only complement of existing `versionOff`/`versionLen` value spans)
* **hasBuiltinLint** / **hasMoreLeancArgs** / **hasAllowNonModules** — first non-comment key match
  (W85 more20; table bodies not excluded — same global first-match as more19;
  real Lake keys `builtinLint` (PackageConfig) / `moreLeancArgs` (LeanConfig) / `allowNonModules` (LeanConfig);
  **shaped presence scan only**, not typed decode / not arg-array decode; three presence keys;
  `moreLeancArgs` is distinct from existing `moreLeanArgs` / `moreLinkArgs` quote-count walkers)
* **hasRequiresModuleSystem** / **hasWeakLeancArgs** / **hasMoreLinkObjs** — first non-comment key match
  (W86 more21; table bodies not excluded — same global first-match as more20;
  real Lake keys `requiresModuleSystem` (LeanConfig/Package) / `weakLeancArgs` (LeanConfig) / `moreLinkObjs` (LeanConfig);
  **shaped presence scan only**, not typed decode / not arg-array decode; three presence keys;
  `weakLeancArgs` is distinct from existing `weakLeanArgsCount` quote-count walker;
  `moreLinkObjs` is distinct from `moreLinkArgs` / `hasMoreLinkArgs`)
* **hasMoreLinkLibs** / **hasDynlibs** / **hasPlugins** — first non-comment key match
  (W87 more22; table bodies not excluded — same global first-match as more21;
  real Lake keys `moreLinkLibs` (LeanConfig) / `dynlibs` (LeanConfig/Package) / `plugins` (LeanConfig/Package);
  `moreLinkLibs` is distinct from `moreLinkArgs` / `moreLinkObjs` / `moreLeancArgs`;
  `dynlibs` / `plugins` are distinct from each other and from `moreLinkLibs`)
* **hasDefaultFacets** / **hasMoreGlobalServerArgs** / **hasLibName** — first non-comment key match
  (W88 more23; table bodies not excluded — same global first-match as more22;
  real Lake keys `defaultFacets` (LeanLibConfig) / `moreGlobalServerArgs` (PackageConfig) / `libName` (LeanLibConfig);
  `moreGlobalServerArgs` is distinct from `moreServerArgs` / `moreServerOptions`;
  `libName` is distinct from `nativeLibDir` / `leanLibDir`)
* **hasScope** / **hasRemoteUrl** / **hasWeakLeanArgs** — first non-comment key match
  (W89 more24; table bodies not excluded — same global first-match as more23;
  real Lake keys `scope` (PackageConfig) / `remoteUrl` (DependencyConfig) / `weakLeanArgs` (LeanConfig);
  `hasWeakLeanArgs` is presence-only (reuses more3 key finder); distinct from `weakLeanArgsCount` quote-count
  and from `hasWeakLeancArgs` (`weakLeancArgs`))
* **hasFreestanding** / **hasRoots** / **hasGlobs** — first non-comment key match
  (W90 more25; table bodies not excluded — same global first-match as more24;
  real Lake keys `freestanding` / `roots` / `globs` (LeanLibConfig);
  presence-only; not value decode)
* **hasNeeds** / **hasWeakLinkArgs** / **hasExeName** — first non-comment key match
  (W91 more26; table bodies not excluded — same global first-match as more25;
  real Lake keys `needs` (LeanLibConfig/LeanExeConfig) / `weakLinkArgs` (LeanConfig; presence-only —
  reuses more6 key finder; distinct from `weakLinkArgsCount` quote-count and from `hasWeakLeanArgs` /
  `hasWeakLeancArgs` / `hasMoreLinkArgs`) / `exeName` (LeanExeConfig);
  presence-only; not value decode)
* **hasMoreLeanArgs** / **hasNativeFacets** / **hasRoot** — first non-comment key match
  (W92 more27; table bodies not excluded — same global first-match as more26;
  real Lake keys `moreLeanArgs` (LeanConfig; presence-only — reuses more3 key finder; distinct from
  `moreLeanArgsCount` quote-count and from `hasMoreLeancArgs` / `hasMoreLinkArgs`) /
  `nativeFacets` (LeanLibConfig/LeanExeConfig; presence-only; TOML may exclude decode but key is real) /
  `root` (LeanExeConfig; presence-only; distinct from `hasRoots` / `hasSrcDir`);
  presence-only; not value decode)
* **hasName** / **hasLeanArgs** / **hasTestRunner** — first non-comment key match
  (W93 more28; table bodies not excluded — same global first-match as more27;
  real Lake keys `name` (PackageConfig / lean_lib / lean_exe; presence-only — reuses package name finder;
  distinct from `packageNameOff` / `packageNameLen` value spans) /
  `leanArgs` (presence-only — reuses more4 `leanArgs` key finder; distinct from `leanArgsCount` quote-count
  and from `hasMoreLeanArgs` / `hasWeakLeanArgs`) /
  `testRunner` (PackageConfig alias of `testDriver`; presence-only; distinct from `hasTestDriver`);
  presence-only; not value decode)
* **hasServerOptions** / **hasLeancArgs** / **hasBaseName** — first non-comment key match
  (W94 more29; table bodies not excluded — same global first-match as more28;
  literal-byte keys `serverOptions` / `leancArgs` / `baseName` — **not** PackageConfig TOML schema
  fields (Lake TOML uses `moreServerOptions` / `moreLeancArgs`; `baseName` is load-derived from
  package `name`; runtime `*.serverOptions` / `*.leancArgs` are derived accumulations); reverse peers
  vs `hasMoreServerOptions` / `hasMoreLeancArgs` / `hasName`; presence-only; not value decode)
* **hasLinkArgs** / **hasServerArgs** / **hasGlobalServerArgs** — first non-comment key match
  (W95 more30; table bodies not excluded — same global first-match as more29;
  literal-byte keys `linkArgs` / `serverArgs` / `globalServerArgs` — **not** PackageConfig TOML schema
  fields (Lake TOML uses `moreLinkArgs` / `moreServerArgs` / `moreGlobalServerArgs`; runtime
  `*.linkArgs` / server arg lists are derived accumulations); reverse peers vs `hasMoreLinkArgs` /
  `hasMoreServerArgs` / `hasMoreGlobalServerArgs`; presence-only; not value decode)
* **hasType** / **hasDir** / **hasSource** — first non-comment key match
  (W99 more34; DependencySrc table-form `type`/`dir` + Dependency `source` fallback)
* **hasKind** / **hasPreset** / **hasExtension** — first non-comment key match
  (W100 more35; table bodies not excluded — same global first-match as more34;
  real Lake keys `kind` (cache/service/custom-data) / `preset` (Pattern.decodeToml named presets) /
  `extension` (PathPatDescr path pattern); presence-only; not value decode; reverse peers across
  kind/preset/extension/type/source)
* **hasFilter** / **hasText** / **hasFileName** — first non-comment key match
  (W101 more36; table bodies not excluded — same global first-match as more35;
  real Lake keys `filter` (InputDir filter pattern) / `text` (InputFile/InputDir text mode) /
  `fileName` (PathPatDescr file-name pattern); presence-only; not value decode; reverse peers across
  filter/text/fileName/extension/kind)
* **hasStartsWith** / **hasEndsWith** / **hasNot** — first non-comment key match
  (W102 more37; table bodies not excluded — same global first-match as more36;
  real Lake keys `startsWith`/`endsWith` (StrPatDescr) / `not` (PatternDescr negation);
  presence-only; not value decode; reverse peers across startsWith/endsWith/not/filter/fileName)
* **hasAny** / **hasAll** / **hasApiEndpoint** — first non-comment key match
  (W103 more38; table bodies not excluded — same global first-match as more37;
  real Lake keys `any`/`all` (PatternDescr disjunction/conjunction) / `apiEndpoint` (LakeConfig cache service URL);
  presence-only; not value decode; reverse peers across any/all/apiEndpoint/not/startsWith)
* **hasArtifactEndpoint** / **hasRevisionEndpoint** / **hasDefaultService** — first non-comment key match
  (W104 more39; table bodies not excluded — same global first-match as more38;
  real Lake keys `artifactEndpoint`/`revisionEndpoint` (CacheServiceConfig S3 endpoints) /
  `defaultService` (CacheConfig default cache service name); presence-only; not value decode;
  reverse peers across artifactEndpoint/revisionEndpoint/defaultService/apiEndpoint/url)
* **hasService** / **hasRepo** / **hasSchemaVersion** — first non-comment key match
  (W105 more40; table bodies not excluded — same global first-match as more39;
  real Lake CacheOutput JSON/TOML keys `service` / `repo` / `schemaVersion`; presence-only; not value decode;
  reverse peers across service/repo/schemaVersion/defaultService/artifactEndpoint)
* **hasData** / **hasManifestFile** / **hasLakeDir** — first non-comment key match
  (W106 more41; table bodies not excluded — same global first-match as more40;
  real Lake CacheOutput JSON key `data` / Manifest entry `manifestFile` / Manifest `lakeDir`;
  presence-only; not value decode; reverse peers across data/manifestFile/lakeDir/service/repo/schemaVersion)
* **hasConfigFile** / **hasInputRev** / **hasPackages** — first non-comment key match
  (W107 more42; table bodies not excluded — same global first-match as more41;
  real Lake Manifest / package keys `configFile` / `inputRev` / `packages`;
  presence-only; not value decode; reverse peers across configFile/inputRev/packages/data/manifestFile/lakeDir)
* **hasInherited** / **hasGitUrl** / **hasFullName** — first non-comment key match
  (W108 more43; table bodies not excluded — same global first-match as more42;
  real Lake Manifest PackageEntry `inherited` + Reservoir RegistrySrc `gitUrl` +
  Reservoir RegistryPkg `fullName`; presence-only; not value decode; reverse peers across
  inherited/gitUrl/fullName/configFile/inputRev/packages)
* **hasDefaultBranch** / **hasRepoUrl** / **hasSources** — first non-comment key match
  (W109 more44; table bodies not excluded — same global first-match as more43;
  real Lake Reservoir RegistrySrc `defaultBranch` + Reservoir RegistrySrc `repoUrl` +
  Reservoir RegistryPkg `sources`; presence-only; not value decode; reverse peers across
  defaultBranch/repoUrl/sources/inherited/gitUrl/fullName)
* **hasRevision** / **hasHost** / **hasHash** — first non-comment key match
  (W110 more45; table bodies not excluded — same global first-match as more44;
  real Lake Reservoir RegistryVer `revision` + Reservoir RegistrySrc `host` +
  Lake Module unpack JSON `hash`; presence-only; not value decode; reverse peers across
  revision/host/hash/defaultBranch/repoUrl/sources)
* **hasDepHash** / **hasFile** / **hasInputs** — first non-comment key match
  (W111 more46; table bodies not excluded — same global first-match as more45;
  real Lake Build JSON `depHash` + Module unpackLtar `file` + Build JSON `inputs`;
  presence-only; not value decode; reverse peers across
  depHash/file/inputs/revision/host/hash)
* **hasOutputs** / **hasStatus** / **hasLog** — first non-comment key match
  (W112 more47; table bodies not excluded — same global first-match as more46;
  real Lake Build JSON `outputs` + Reservoir err JSON `status` + Build JSON `log`;
  presence-only; not value decode; reverse peers across
  outputs/status/log/depHash/file/inputs)
* **hasSynthetic** / **hasMessage** / **hasError** — first non-comment key match
  (W113 more48; table bodies not excluded — same global first-match as more47;
  real Lake Build JSON `synthetic` + Reservoir err JSON `message` + Reservoir response `error`;
  presence-only; not value decode; reverse peers across
  synthetic/message/error/outputs/status/log)
* **hasHttpCode** / **hasResponseCode** / **hasErrormsg** — first non-comment key match
  (W114 more49; table bodies not excluded — same global first-match as more48;
  real Lake curl JSON `http_code` + `response_code` + `errormsg`;
  presence-only; not value decode; reverse peers across
  http_code/response_code/errormsg/synthetic/message/error)
* **hasContentType** / **hasUrlnum** / **hasSizeDownload** — first non-comment key match
  (W115 more50; table bodies not excluded — same global first-match as more49;
  real Lake curl JSON `content_type` + `urlnum` + `size_download`;
  presence-only; not value decode; reverse peers across
  content_type/urlnum/size_download/http_code/response_code/errormsg)
* **hasRs** / **hasO** / **hasI** — first non-comment key match
  (W116 more51; table bodies not excluded — same global first-match as more50;
  real Lake ModuleOutputDescrs JSON single/short keys `rs` + `o` + `i`
  (`Build/ModuleArtifacts.lean`); presence-only; not value decode; reverse peers
  across rs/o/i/content_type/urlnum/size_download; single-letter keys are
  intentional Lake JSON field names — exact key-length match before `=`)
* **hasM** / **hasC** / **hasB** — first non-comment key match
  (W117 more52; table bodies not excluded — same global first-match as more51;
  real Lake ModuleOutputDescrs JSON single-letter keys `m` + `c` + `b`
  (`Build/ModuleArtifacts.lean` isModule / c artifact / bc); presence-only; not
  value decode; reverse peers across m/c/b/rs/o/i; single-letter keys are
  intentional Lake JSON field names — exact key-length match before `=`)
* **hasL** / **hasR** / **hasRequire** — first non-comment key match
  (W118 more53; table bodies not excluded — same global first-match as more52;
  real Lake ModuleOutputDescrs JSON single-letter keys `l` + `r` (ltar / ir from
  `Build/ModuleArtifacts.lean`) + package-table `require` (`Load/Toml.lean`);
  presence-only; not value decode; reverse peers across l/r/require/m/c/b/rs;
  `hasR` is distinct from more51 `hasRs` (`rs`); single-letter keys intentional;
  ModuleArtifacts short keys complete after more53: m,o,i,rs,r,c,b,l)
* **hasValue** / **hasMajor** / **hasMinor** — first non-comment key match
  (W119 more54; table bodies not excluded — same global first-match as more53;
  after ModuleArtifacts short-key completion: real Lake TOML object key `value`
  from `Load/Toml.lean` LeanOption table decode (`t.tryDecode` of `value`); plus
  residual literal key-text `major` / `minor` inspired by `Util/Version.lean`
  parseVerNat **error-message labels** (not lakefile object keys — honesty);
  presence-only; not value decode; reverse peers across value/major/minor/
  version/manifest/m; exact key-length match before `=`; prefix peers
  `values`/`majorX`/`minorX` must not match; distinct from more20 `hasVersion`;
  more55+ prefer greppable `tryDecode` / JSON-insert object keys only)
* **hasArt** / **hasOlean** / **hasLtar** — first non-comment key match
  (W120 more55; table bodies not excluded — same global first-match as more54;
  Lake greppable cache/artifact extension identity tokens `art` + `olean` +
  `ltar` — `Config/Artifact.lean` / `Config/Cache.lean` default `ext := "art"`;
  `Build/Module.lean` cache/compute facet ext `"olean"` / `"ltar"`; **not**
  PackageConfig TOML fields — residual intentionally includes them after
  tryDecode/JSON-insert inventory is largely exhausted; presence-only; not
  value decode; reverse peers across art/olean/ltar/o/l; exact key-length
  match before `=`; prefix peers `artifact`/`arts`/`oleans`/`ltars` must not
  match; more56+ continues other Lake JSON/TOML keys)
* **hasIr** / **hasTraceArgs** / **hasDebugAssertions** — first non-comment key match
  (W121 more56; table bodies not excluded — same global first-match as more55;
  Lake greppable identity tokens `ir` + `traceArgs` + `debugAssertions` —
  `Build/Module.lean` cache/compute facet ext `"ir"` / `Config/Defaults.lean`
  `defaultIrDir := "ir"`; `Build/Common.lean` `addPureTrace traceArgs "traceArgs"`
  build-trace caption; `Config/LeanConfig.lean` BuildType.leanOptions NameMap
  key `` `debugAssertions ``; **not** Version parse labels; presence-only; not
  value decode; reverse peers across ir/i/traceArgs/leanArgs; exact key-length
  match before `=`; prefix peers `irDir`/`irs`/`traceArg`/`debugAssertion` must
  not match; more57+ continues other Lake JSON/TOML keys)
* **hasVerLike** / **hasMappings** / **hasDefault** — first non-comment key match
  (W122 more57; table bodies not excluded — same global first-match as more56;
  Lake greppable named keys `verLike` + `mappings` + `default` —
  `Config/Pattern.lean` `versionTagPresets` NameMap insert `` `verLike `` /
  `StrPat.verLike`; `CLI/Main.lean` `takeArg "mappings"` (setup-file / CLI
  greppable token); `Config/Pattern.lean` `defaultVersionTags` preset name
  `` `default `` (also Translate/Toml `` `default `` cases); **not** Version
  parse labels; presence-only; not value decode; reverse peers across
  verLike/mappings/default/defaultTargets/defaultFacets; exact key-length
  match before `=`; prefix peers `verLikeX`/`mapping`/`defaultTargets`/
  `defaultFacets`/`defaultBranch`/`defaultService` must not match; **exact
  length-7** `default` must miss longer `default*` keys; more58+ continues
  other Lake JSON/TOML keys)
* **hasObjs** / **hasCache** / **hasScript** — first non-comment key match
  (W123 more58; table bodies not excluded — same global first-match as more57;
  Lake greppable named keys `objs` + `cache` + `script` —
  `Build/Common.lean` / `Build/Library.lean` `Job.collectArray … "objs"` job
  caption; `CLI/Main.lean` `| "cache" => lake.cache` + Help.lean path `"cache"`;
  `CLI/Main.lean` `| "script" => lake.script` + DSL `AttributesCore` `` `script ``;
  **not** Version parse labels; presence-only; not value decode; reverse peers
  across objs/cache/script and longer `enableArtifactCache`; exact key-length
  match before `=`; prefix peers `objsX`/`cacheX`/`scriptX`/`Obj`/`Cache`/
  `Script` must not match; more59+ continues other Lake JSON/TOML keys)
* **hasExt** / **hasLean** / **hasToml** — first non-comment key match
  (W124 more59; table bodies not excluded — same global first-match as more58;
  Lake greppable named keys `ext` + `lean` + `toml` —
  `Config/Artifact.lean` / `Config/Cache.lean` field `ext` / `ext := "art"` /
  `self.ext`; `CLI/Main.lean` `| "lean" => lake.lean` + `Load/Package.lean`
  `| "lean" =>` configLang + Help.lean; `Load/Package.lean` `| "toml" =>`
  configLang + `Toml/Grammar.lean` / Help config languages; **not** Version
  parse labels; presence-only; not value decode; reverse peers across
  ext/lean/toml and longer `extension` (`hasExtension`); **exact length-3**
  `ext` must miss longer `extension`; exact key-length match before `=`;
  prefix peers `extX`/`extension`/`leanX`/`Lean`/`tomlX`/`Toml` must not
  match; more60+ continues other Lake JSON/TOML keys)
* **hasEnv** / **hasHelp** / **hasCc** — first non-comment key match
  (W125 more60; table bodies not excluded — same global first-match as more59;
  Lake greppable named keys `env` + `help` + `cc` —
  `CLI/Main.lean` `| "env" => lake.env` + Help.lean `| "env"`;
  `CLI/Main.lean` `| "help" => lake.help` (+ cache/script help subcommands);
  `Config/InstallPath.lean` `cc : FilePath := "cc"` + Help LEAN_CC +
  `Build/Actions.lean` linker default `"cc"`; **not** Version parse labels;
  presence-only; not value decode; reverse peers across env/help/cc and
  single-letter more52 `hasC` (`c`); **exact length-2** `cc` must miss bare
  `c` (`hasC`); exact key-length match before `=`; prefix peers
  `envX`/`Env`/`helpX`/`Help`/`ccX`/`Cc` must not match; more61+ continues
  other Lake JSON/TOML keys)
* **hasInfo** / **hasRemote** / **hasFacets** — first non-comment key match
  (W126 more61; table bodies not excluded — same global first-match as more60;
  Lake greppable named keys `info` + `remote` + `facets` —
  `Util/Log.lean` `| "info" | "information" => some .info` / `.info => "info"`;
  `Util/Git.lean` `#["remote", "get-url", remote]` (+ add/set-url);
  `CLI/Translate/Toml.lean` `encodeFacets` + `Config/LeanLibConfig.lean`
  `defaultFacets` / `Config/Workspace.lean` `facetConfigs`; **not** Version
  parse labels; presence-only; not value decode; reverse peers across
  info/remote/facets and longer `remoteUrl` (`hasRemoteUrl`) /
  `defaultFacets` (`hasDefaultFacets`) / `information`; **exact length-6**
  `remote` must miss longer `remoteUrl`; exact key-length match before `=`;
  prefix peers `infoX`/`Info`/`remoteX`/`Remote`/`facetsX`/`Facets` must not
  match; more62+ continues other Lake JSON/TOML keys)
* **hasPackage** / **hasModule** / **hasBuild** — first non-comment key match
  (W127 more62; table bodies not excluded — same global first-match as more61;
  Lake greppable named keys `package` + `module` + `build` —
  `CLI/Build.lean` `unknownFacet "package"` / `unknownFacet "module"`;
  `CLI/Main.lean` `| "build" => lake.build` + Help.lean `| "build"` +
  `Config/Defaults.lean` `defaultBuildDir` / `"build"`; **not** Version parse
  labels; presence-only; not value decode; reverse peers across
  package/module/build and longer `packages` (`hasPackages`) /
  `packagesDir` (`hasPackagesDir`) / `precompileModules`
  (`hasPrecompileModules`) / `buildDir` (`hasBuildDir`) / `buildType`
  (`hasBuildType`) / `buildArchive` (`hasBuildArchive`); **exact length-7**
  `package` must miss longer `packages`; **exact length-5** `build` must miss
  longer `buildDir`; exact key-length match before `=`; prefix peers
  `packageX`/`Package`/`moduleX`/`Module`/`buildX`/`Build` must not match;
  more63+ continues other Lake JSON/TOML keys)
* **hasClean** / **hasTest** / **hasServe** — first non-comment key match
  (W128 more63; table bodies not excluded — same global first-match as more62;
  Lake greppable named keys `clean` + `test` + `serve` —
  `CLI/Main.lean` `| "clean" => lake.clean` / `| "test" => lake.test` /
  `| "serve" => lake.serve`; Help.lean; **not** Version parse labels;
  presence-only; not value decode; reverse peers across clean/test/serve and
  longer `testDriver` (`hasTestDriver`) / `serverArgs` (`hasServerArgs`);
  more64+ continues other Lake JSON/TOML keys)
* **hasLint** / **hasExe** / **hasQuery** — first non-comment key match
  (W129 more64; table bodies not excluded — same global first-match as more63;
  Lake greppable named keys `lint` + `exe` + `query` —
  `CLI/Main.lean` `| "lint" => lake.lint` / `| "exe" | "exec" => lake.exe` /
  `| "query" => lake.query`; Help.lean `| "lint"` / `| "exe"` / `| "query"`;
  **not** Version parse labels; presence-only; not value decode; reverse peers
  across lint/exe/query and longer `lintDriver` (`hasLintDriver`) /
  `lintDriverArgs` (`hasLintDriverArgs`) / `builtinLint` (`hasBuiltinLint`) /
  `exeName` (`hasExeName`); **exact length-4** `lint` must miss longer
  `lintDriver`; **exact length-3** `exe` must miss longer `exeName`; exact
  key-length match before `=`; prefix peers `lintX`/`Lint`/`exeX`/`Exe`/
  `queryX`/`Query` must not match; more65+ continues other Lake JSON/TOML keys)
* **hasInit** / **hasNew** / **hasUpdate** — first non-comment key match
  (W130 more65; table bodies not excluded — same global first-match as more64;
  Lake greppable named keys `init` + `new` + `update` —
  `CLI/Main.lean` `| "init" => lake.init` / `| "new" => lake.new` /
  `| "update" | "upgrade" => lake.update`; Help.lean `| "init"` / `| "new"` /
  `| "update"`; **not** Version parse labels; presence-only; not value decode;
  reverse peers across init/new/update; **exact length-4** `init` / **exact
  length-3** `new` / **exact length-6** `update` key match before `=`;
  prefix peers `initX`/`Init`/`newX`/`New`/`updateX`/`Update` must not match;
  bare `update` only (not alias `upgrade`); more66+ continues other Lake
  JSON/TOML keys)
* **hasPack** / **hasUnpack** / **hasUpload** — first non-comment key match
  (W131 more66; table bodies not excluded — same global first-match as more65;
  Lake greppable named keys `pack` + `unpack` + `upload` —
  `CLI/Main.lean` `| "pack" => lake.pack` / `| "unpack" => lake.unpack` /
  `| "upload" => lake.upload`; Help.lean `| "pack"` / `| "unpack"` /
  `| "upload"` (+ `helpPack`/`helpUnpack`/`helpUpload`); **not** Version parse
  labels; presence-only; not value decode; reverse peers across pack/unpack/upload
  and more65 len-6 `update` (`hasUpdate`); **exact length-4** `pack` / **exact
  length-6** `unpack` / **exact length-6** `upload` key match before `=`;
  prefix peers `packX`/`Pack`/`unpackX`/`Unpack`/`uploadX`/`Upload` must not
  match; more67+ continues other Lake JSON/TOML keys)
* **hasShake** / **hasRun** / **hasScripts** — first non-comment key match
  (W132 more67; table bodies not excluded — same global first-match as more66;
  Lake greppable named keys `shake` + `run` + `scripts` —
  `CLI/Main.lean` `| "shake" => lake.shake` / `| "run" => lake.script.run` /
  `| "scripts" => lake.script.list`; Help.lean `| "shake"` / `| "run"` /
  `| "scripts"` (+ `helpShake`/`helpScriptRun`/`helpScriptList`); **not** Version
  parse labels; presence-only; not value decode; reverse peers across
  shake/run/scripts and more58 len-6 `script` (`hasScript`); **exact length-5**
  `shake` / **exact length-3** `run` / **exact length-7** `scripts` key match
  before `=`; prefix peers `shakeX`/`Shake`/`runX`/`Run`/`scriptsX`/`Scripts`
  must not match; more68+ continues other Lake JSON/TOML keys)
* **hasGet** / **hasPut** / **hasAdd** — first non-comment key match
  (W133 more68; table bodies not excluded — same global first-match as more67;
  Lake greppable named keys `get` + `put` + `add` —
  `CLI/Main.lean` `| "get" => cache.get` / `| "put" => cache.put` /
  `| "add" => cache.add`; Help.lean `| "get"` / `| "put"` / `| "add"`
  (+ `helpCacheGet`/`helpCachePut`/`helpCacheAdd`); **not** Version parse
  labels; presence-only; not value decode; reverse peers across get/put/add
  and more58 len-5 `cache` (`hasCache`); **exact length-3** `get` / **exact
  length-3** `put` / **exact length-3** `add` key match before `=`;
  prefix peers `getX`/`Get`/`putX`/`Put`/`addX`/`Add` must not match;
  more69+ continues other Lake JSON/TOML keys)
* **hasList** / **hasDoc** / **hasStage** — first non-comment key match
  (W134 more69; table bodies not excluded — same global first-match as more68;
  Lake greppable named keys `list` + `doc` + `stage` —
  `CLI/Main.lean` `| "list" => script.list` / `| "doc" => script.doc` /
  `| "stage" => cache.stage`; Help.lean `| "list"` / `| "doc"` / `| "stage"`
  (+ `helpScriptList`/`helpScriptDoc`/`helpCacheStage`); **not** Version parse
  labels; presence-only; not value decode; reverse peers across list/doc/stage
  and more67 len-7 `scripts` (`hasScripts`) / more58 len-6 `script` (`hasScript`)
  / more68 get/put/add / more58 `hasCache`; **exact length-4** `list` / **exact
  length-3** `doc` / **exact length-5** `stage` key match before `=`;
  prefix peers `listX`/`List`/`docX`/`Doc`/`stageX`/`Stage` must not match;
  more70+ continues other Lake JSON/TOML keys)
* **hasExec** / **hasUnstage** / **hasPutStaged** — first non-comment key match
  (W135 more70; table bodies not excluded — same global first-match as more69;
  Lake greppable named keys `exec` + `unstage` + `put-staged` —
  `CLI/Main.lean` `| "exe" | "exec" => lake.exe` / `| "unstage" => cache.unstage` /
  `| "put-staged" => cache.putStaged`; Help.lean `| "exec"` (via helpExe) /
  `| "unstage"` / `| "put-staged"` (+ `helpCacheUnstage`/`helpCachePutStaged`);
  **not** Version parse labels; presence-only; not value decode; reverse peers
  across exec/unstage/put-staged and more64 len-3 `exe` (`hasExe`) / more69
  len-5 `stage` (`hasStage`) / more68 len-3 `put` (`hasPut`) / more58 `hasCache`;
  **exact length-4** `exec` / **exact length-7** `unstage` / **exact length-10**
  `put-staged` key match before `=`; prefix peers `execX`/`Exec`/`unstageX`/
  `Unstage`/`put-stagedX`/`Put-staged` must not match;
  more71+ continues other Lake JSON/TOML keys)
* **hasCheckBuild** / **hasCheckLint** / **hasCheckTest** — first non-comment key match
  (W136 more71; table bodies not excluded — same global first-match as more70;
  Lake greppable named keys `check-build` + `check-lint` + `check-test` —
  `CLI/Main.lean` `| "check-build" => lake.checkBuild` /
  `| "check-lint" => lake.checkLint` / `| "check-test" => lake.checkTest`;
  Help.lean `| "check-build"` / `| "check-lint"` / `| "check-test"`
  (+ `helpCheckBuild`/`helpCheckLint`/`helpCheckTest`); **not** Version parse
  labels; presence-only; not value decode; reverse peers across check-build /
  check-lint / check-test and more62 len-5 `build` (`hasBuild`) / more64 len-4
  `lint` (`hasLint`) / more63 len-4 `test` (`hasTest`); **exact length-11**
  `check-build` / **exact length-10** `check-lint` / **exact length-10**
  `check-test` key match before `=`; prefix peers `check-buildX`/`Check-build`/
  `check-lintX`/`Check-lint`/`check-testX`/`Check-test` must not match;
  more72+ continues other Lake JSON/TOML keys)
* **hasQueryKind** / **hasSetupFile** / **hasSelfCheck** — first non-comment key match
  (W137 more72; table bodies not excluded — same global first-match as more71;
  Lake greppable named keys `query-kind` + `setup-file` + `self-check` —
  `CLI/Main.lean` `| "query-kind" => lake.queryKind` /
  `| "setup-file" => lake.setupFile` / `| "self-check" => lake.selfCheck`;
  Serve.lean documents `setup-file`; **not** Version parse labels;
  presence-only; not value decode; reverse peers across query-kind / setup-file
  / self-check and more64 len-5 `query` (`hasQuery`) / more35 len-4 `kind`
  (`hasKind`); **exact length-10** `query-kind` / **exact length-10**
  `setup-file` / **exact length-10** `self-check` key match before `=`;
  prefix peers `query-kindX`/`Query-kind`/`setup-fileX`/`Setup-file`/
  `self-checkX`/`Self-check` must not match; more73+ continues other Lake
  JSON/TOML keys)
* **hasTranslateConfig** / **hasResolveDeps** / **hasServices** — first non-comment key match
  (W138 more73; table bodies not excluded — same global first-match as more72;
  Lake greppable named keys `translate-config` + `resolve-deps` + `services` —
  `CLI/Main.lean` `| "translate-config" => lake.translateConfig` /
  `| "resolve-deps" => lake.resolveDeps` / `| "services" => cache.services`;
  Help.lean `| "translate-config"` / `| "services"`; **not** Version parse labels;
  presence-only; not value decode; reverse peers across translate-config /
  resolve-deps / services and more40 len-7 `service` (`hasService`);
  **exact length-16** `translate-config` / **exact length-12** `resolve-deps` /
  **exact length-8** `services` key match before `=`;
  prefix peers `translate-configX`/`Translate-config`/`resolve-depsX`/
  `Resolve-deps`/`servicesX`/`Services` must not match; more74+ continues other
  Lake JSON/TOML keys)
* **hasReservoirConfig** / **hasVersionTagsCli** / **hasUpgrade** — first non-comment key match
  (W139 more74; table bodies not excluded — same global first-match as more73;
  Lake greppable named keys `reservoir-config` + `version-tags` + `upgrade` —
  `CLI/Main.lean` `| "reservoir-config" => lake.reservoirConfig` /
  `| "version-tags" => lake.versionTags` / `| "update" | "upgrade" => lake.update`;
  Help.lean `| "update" | "upgrade"`; **not** Version parse labels;
  presence-only; not value decode; reverse peers across reservoir-config /
  version-tags / upgrade and more7 len-9 `reservoir` (`hasReservoir`) / more12
  camelCase `versionTags` (`hasVersionTags`) / more65 len-6 `update` (`hasUpdate`);
  **exact length-16** `reservoir-config` / **exact length-12** `version-tags` /
  **exact length-7** `upgrade` key match before `=`;
  prefix peers `reservoir-configX`/`Reservoir-config`/`version-tagsX`/
  `Version-tags`/`upgradeX`/`Upgrade` must not match; more75+ continues other
  Lake JSON/TOML keys)
* **hasNoBuild** / **hasNoCache** / **hasTryCache** — first non-comment key match
  (W140 more75; table bodies not excluded — same global first-match as more74;
  Lake greppable long-option stems `no-build` + `no-cache` + `try-cache` —
  `CLI/Main.lean` `| "--no-build" =>` / `| "--no-cache" =>` /
  `| "--try-cache" =>`; key string **without** leading `--` (same convention as
  more70 `put-staged` / more71 `check-build`); **not** Version parse labels;
  presence-only; not value decode; reverse peers across no-build / no-cache /
  try-cache and more62 len-5 `build` (`hasBuild`) / more58 len-5 `cache`
  (`hasCache`); **exact length-8** `no-build` / **exact length-8** `no-cache` /
  **exact length-9** `try-cache` key match before `=`;
  prefix peers `no-buildX`/`No-build`/`no-cacheX`/`No-cache`/`try-cacheX`/
  `Try-cache` must not match; more76+ continues other Lake JSON/TOML keys)
* **hasForceDownload** / **hasDownloadArts** / **hasMappingsOnly** — first non-comment key match
  (W141 more76; table bodies not excluded — same global first-match as more75;
  Lake greppable long-option stems `force-download` + `download-arts` +
  `mappings-only` — `CLI/Main.lean` `| "--force-download" =>` /
  `| "--download-arts" =>` / `| "--mappings-only" =>`; key string **without**
  leading `--` (same convention as more75 `no-build` / more70 `put-staged`);
  **not** Version parse labels; presence-only; not value decode; reverse peers
  across download-arts / mappings-only and more55 len-3 `art` (`hasArt`) /
  more57 len-8 `mappings` (`hasMappings`); force-download has no shipped reverse
  peer among download flags; **exact length-14** `force-download` /
  **exact length-13** `download-arts` / **exact length-13** `mappings-only` key
  match before `=`; prefix peers `force-downloadX`/`Force-download`/
  `download-artsX`/`Download-arts`/`mappings-onlyX`/`Mappings-only` must not
  match; more77+ continues other Lake JSON/TOML keys)
* **hasNoOverwrite** / **hasForceOverwrite** / **hasRehash** — first non-comment key match
  (W142 more77; table bodies not excluded — same global first-match as more76;
  Lake greppable long-option stems `no-overwrite` + `force-overwrite` +
  `rehash` — `CLI/Main.lean` `| "--no-overwrite" =>` /
  `| "--force-overwrite" =>` / `| "--rehash" =>`; key string **without**
  leading `--` (same convention as more76 `force-download` / more75 `no-build`);
  **not** Version parse labels; presence-only; not value decode; reverse peers
  bidirectional no-overwrite↔force-overwrite; rehash has no shipped reverse
  peer among overwrite/trust flags; **exact length-12** `no-overwrite` /
  **exact length-15** `force-overwrite` (distinct from more76 len-14
  `force-download`) / **exact length-6** `rehash` key match before `=`;
  prefix peers `no-overwriteX`/`No-overwrite`/`force-overwriteX`/
  `Force-overwrite`/`rehashX`/`Rehash` must not match; more78+ continues other
  Lake JSON/TOML keys)
* **hasKeepImplied** / **hasKeepPrefix** / **hasKeepPublic** — first non-comment key match
  (W143 more78; table bodies not excluded — same global first-match as more77;
  Lake greppable long-option stems `keep-implied` + `keep-prefix` +
  `keep-public` — `CLI/Main.lean` `| "--keep-implied" =>` /
  `| "--keep-prefix" =>` / `| "--keep-public" =>`; key string **without**
  leading `--` (same convention as more77 `no-overwrite` / more76 `force-download`);
  **not** Version parse labels; presence-only; not value decode; reverse peers
  keep-implied↔keep-prefix↔keep-public (cross-key among shake keep-* cluster;
  keep-prefix vs keep-public share len-11 — content not length alone);
  **exact length-12** `keep-implied` / **exact length-11** `keep-prefix` /
  **exact length-11** `keep-public` key match before `=`; prefix peers
  `keep-impliedX`/`Keep-implied`/`keep-prefixX`/`Keep-prefix`/
  `keep-publicX`/`Keep-public` must not match; more79+ continues other
  Lake JSON/TOML keys)
* **hasAddPublic** / **hasGhStyle** / **hasExplain** — first non-comment key match
  (W144 more79; table bodies not excluded — same global first-match as more78;
  Lake greppable long-option stems `add-public` + `gh-style` +
  `explain` — `CLI/Main.lean` `| "--add-public" =>` /
  `| "--gh-style" =>` / `| "--explain" =>`; key string **without**
  leading `--` (same convention as more78 `keep-public` / more77 `no-overwrite`);
  **not** Version parse labels; presence-only; not value decode; reverse peers
  add-public↔keep-public (more78 `hasKeepPublic`) and trio among
  add-public↔gh-style↔explain (shake residual cluster);
  **exact length-10** `add-public` / **exact length-8** `gh-style` /
  **exact length-7** `explain` key match before `=`; prefix peers
  `add-publicX`/`Add-public`/`gh-styleX`/`Gh-style`/
  `explainX`/`Explain` must not match; more80+ continues other
  Lake JSON/TOML keys)
* **hasBuiltinOnly** / **hasLintOnly** / **hasRecordExceptions** — first non-comment key match
  (W145 more80; table bodies not excluded — same global first-match as more79;
  Lake greppable long-option stems `builtin-only` + `lint-only` +
  `record-exceptions` — `CLI/Main.lean` `| "--builtin-only" =>` /
  `| "--lint-only" =>` / `| "--record-exceptions" =>`; key string **without**
  leading `--` (same convention as more79 `add-public` / more78 `keep-public`);
  **not** Version parse labels; presence-only; not value decode; reverse peers
  builtin-only↔hasBuiltinLint (more20 camel `builtinLint` len-11) /
  lint-only↔hasLint (more64 len-4 `lint`) and trio among
  builtin-only↔lint-only↔record-exceptions (lint residual cluster);
  **exact length-12** `builtin-only` / **exact length-9** `lint-only` /
  **exact length-17** `record-exceptions` key match before `=`; prefix peers
  `builtin-onlyX`/`Builtin-only`/`lint-onlyX`/`Lint-only`/
  `record-exceptionsX`/`Record-exceptions` must not match; more81+ continues other
  Lake JSON/TOML keys)
* **hasKeepToolchain** / **hasAllowEmpty** / **hasMaxRevs** — first non-comment key match
  (W146 more81; table bodies not excluded — same global first-match as more80;
  Lake greppable long-option stems `keep-toolchain` + `allow-empty` +
  `max-revs` — `CLI/Main.lean` `| "--keep-toolchain" =>` /
  `| "--allow-empty" =>` / `| "--max-revs" =>`; key string **without**
  leading `--` (same convention as more80 `builtin-only` / more79 `add-public`);
  **not** Version parse labels; presence-only; not value decode; reverse peers
  keep-toolchain↔hasFixedToolchain (more19 camel `fixedToolchain` len-14
  content-distinct) / max-revs↔hasRev (exact len-3 `rev`) and trio among
  keep-toolchain↔allow-empty↔max-revs (update/toolchain residual cluster);
  **exact length-14** `keep-toolchain` / **exact length-11** `allow-empty` /
  **exact length-8** `max-revs` key match before `=`; prefix peers
  `keep-toolchainX`/`Keep-toolchain`/`allow-emptyX`/`Allow-empty`/
  `max-revsX`/`Max-revs` must not match; more82+ continues other
  Lake JSON/TOML keys)
* **hasLogLevel** / **hasFailLevel** / **hasNoAnsi** — first non-comment key match
  (W147 more82; table bodies not excluded — same global first-match as more81;
  Lake greppable long-option stems `log-level` + `fail-level` +
  `no-ansi` — `CLI/Main.lean` `| "--log-level" =>` /
  `| "--fail-level" =>` / `| "--no-ansi" =>`; key string **without**
  leading `--` (same convention as more81 `keep-toolchain` / more80 `builtin-only`);
  **not** Version parse labels; presence-only; not value decode; reverse peers
  log-level↔fail-level and no-ansi↔bare `ansi` (len-4; more85 `hasAnsi`) and
  trio among log-level↔fail-level↔no-ansi (log/output residual cluster);
  **exact length-9** `log-level` / **exact length-10** `fail-level` /
  **exact length-7** `no-ansi` key match before `=`; prefix peers
  `log-levelX`/`Log-level`/`fail-levelX`/`Fail-level`/
  `no-ansiX`/`No-ansi` must not match; more83+ continues other
  Lake JSON/TOML keys)
* **hasReconfigure** / **hasQuiet** / **hasVerbose** — first non-comment key match
  (W148 more83; table bodies not excluded — same global first-match as more82;
  Lake greppable long-option stems `reconfigure` + `quiet` +
  `verbose` — `CLI/Main.lean` `| "--reconfigure" =>` /
  `| "--quiet" =>` / `| "--verbose" =>` (also short `-R` for reconfigure in
  `lakeShortOption`); key string **without** leading `--` (same convention as
  more82 `log-level` / more81 `keep-toolchain`);
  **not** Version parse labels; presence-only; not value decode; reverse peers
  quiet↔verbose and reconfigure among trio (and more65 `update` / `hasUpdate`)
  (verbosity/reconfigure residual cluster after more82 log/output);
  **exact length-11** `reconfigure` / **exact length-5** `quiet` /
  **exact length-7** `verbose` key match before `=`; prefix peers
  `reconfigureX`/`Reconfigure`/`quietX`/`Quiet`/
  `verboseX`/`Verbose` must not match; more84+ continues other
  Lake JSON/TOML keys)
* **hasOffline** / **hasPlatform** / **hasToolchain** — first non-comment key match
  (W149 more84; table bodies not excluded — same global first-match as more83;
  Lake greppable long-option stems `offline` + `platform` +
  `toolchain` — `CLI/Main.lean` `| "--offline" =>` /
  `| "--platform" =>` / `| "--toolchain" =>`; key string **without**
  leading `--` (same convention as more83 `reconfigure` / more82 `log-level`);
  **not** Version parse labels; presence-only; not value decode; reverse peers
  platform↔hasPlatformIndependent (more4; longer camel) and
  toolchain↔hasFixedToolchain (more19) / hasKeepToolchain (more81) and
  trio among offline↔platform↔toolchain (cache/env residual cluster after more83
  verbosity/reconfigure);
  **exact length-7** `offline` / **exact length-8** `platform` /
  **exact length-9** `toolchain` key match before `=`; prefix peers
  `offlineX`/`Offline`/`platformX`/`Platform`/
  `toolchainX`/`Toolchain` must not match; more85+ continues other
  Lake JSON/TOML keys)
* **hasWfail** / **hasIofail** / **hasAnsi** — first non-comment key match
  (W150 more85; table bodies not excluded — same global first-match as more84;
  Lake greppable long-option stems `wfail` + `iofail` +
  `ansi` — `CLI/Main.lean` `| "--wfail" =>` /
  `| "--iofail" =>` / `| "--ansi" =>`; key string **without**
  leading `--` (same convention as more84 `offline` / more83 `reconfigure`);
  **not** Version parse labels; presence-only; not value decode; reverse peers
  ansi↔hasNoAnsi (more82; exact len-7 `no-ansi`) and
  wfail/iofail↔hasFailLevel (more82) and each other and
  trio among wfail↔iofail↔ansi (failLv/ansi residual cluster after more82
  log-level/fail-level/no-ansi and more84 offline/platform/toolchain);
  **exact length-5** `wfail` / **exact length-6** `iofail` /
  **exact length-4** `ansi` key match before `=`; prefix peers
  `wfailX`/`Wfail`/`iofailX`/`Iofail`/
  `ansiX`/`Ansi` must not match; more86+ continues other
  Lake JSON/TOML keys)
* **hasForce** / **hasFix** / **hasOnly** — first non-comment key match
  (W151 more86; table bodies not excluded — same global first-match as more85;
  Lake greppable long-option stems `force` + `fix` +
  `only` — `CLI/Main.lean` `| "--force" =>` /
  `| "--fix" =>` / `| "--only" =>` (shake residual cluster); key string
  **without** leading `--` (same convention as more85 `wfail` / more84 `offline`);
  **not** Version parse labels; presence-only; not value decode; reverse peers
  force↔hasForceDownload (more76; exact len-14 `force-download`) /
  hasForceOverwrite (more77; exact len-15 `force-overwrite`) and
  only↔hasMappingsOnly (more76; len-13) / hasBuiltinOnly (more80; len-12) /
  hasLintOnly (more80; len-9) and trio among force↔fix↔only (shake residual
  cluster after more78 keep-* / more79 add-public/gh-style/explain);
  **exact length-5** `force` / **exact length-3** `fix` /
  **exact length-4** `only` key match before `=`; prefix peers
  `forceX`/`Force`/`fixX`/`Fix`/
  `onlyX`/`Only` must not match; more87+ continues other
  Lake JSON/TOML keys)
* **hasTrace** / **hasOld** / **hasJson** — first non-comment key match
  (W152 more87; table bodies not excluded — same global first-match as more86;
  Lake greppable long-option stems `trace` + `old` +
  `json` — `CLI/Main.lean` `| "--trace" =>` /
  `| "--old" =>` / `| "--json" =>` (shake residual + outFormat residual);
  key string **without** leading `--` (same convention as more86 `force` /
  more85 `wfail`); **not** Version parse labels; presence-only; not value decode;
  reverse peers trace↔hasTraceArgs (more56; exact len-9 `traceArgs`) and
  json↔hasText (more36; exact len-4 `text` outFormat peer) and trio among
  trace↔old↔json (shake residual cluster after more86 force/fix/only);
  **exact length-5** `trace` / **exact length-3** `old` /
  **exact length-4** `json` key match before `=`; prefix peers
  `traceX`/`Trace`/`oldX`/`Old`/
  `jsonX`/`Json` must not match; more88+ continues other
  Lake JSON/TOML keys e.g. free stem `linters`)
* **hasLinters** / **hasBuiltinLintCli** / **hasLinter** — first non-comment key match
  (W153 more88; table bodies not excluded — same global first-match as more87;
  Lake greppable long-option stems `linters` + `builtin-lint` + greppable
  identity token `linter` — `CLI/Main.lean` `| "--linters" =>` /
  `| "--builtin-lint" =>` / `parseLintersSpec` `"linter" ++ s` (lint residual
  closeout); key string **without** leading `--` (same convention as more87
  `trace` / more86 `force`); **not** Version parse labels; presence-only; not
  value decode; reverse peers linters↔hasLinter (exact len-7 vs len-6) /
  hasLint (more64) / hasLintOnly (more80) and builtin-lint↔hasBuiltinLint
  (more20 camel `builtinLint` len-11; `*Cli` suffix like more74
  `hasVersionTagsCli`) / hasBuiltinOnly (more80 len-12 content peer) and trio
  among linters↔builtin-lint↔linter (lint residual cluster after more80
  builtin-only/lint-only/record-exceptions and more87 trace/old/json);
  **exact length-7** `linters` / **exact length-12** `builtin-lint` /
  **exact length-6** `linter` key match before `=`; prefix peers
  `lintersX`/`Linters`/`builtin-lintX`/`Builtin-lint`/
  `linterX`/`Linter` must not match; more89+ continues other
  Lake JSON/TOML keys — pure free long-option stems empty after more88)
* **hasSrcDir** / **srcDirOff** / **srcDirLen** — top-level `srcDir = …` presence
  and value span (quotes stripped like package name)
* **hasBuildType** — top-level `buildType = …` presence
* **findKey** / **valueOff** / **valueLen** / **hasKey** — global `key = value` lookup

Honesty:

* **Config subset only** — no dotted key paths, no multi-line strings, no typed
  values, no full inline-array AST, no write/update API.
* Array-of-tables accepted as header lines (`[[name]]`); most body keys still use
  first global match (including more4 `hasPlatformIndependent` /
  `hasPreferReleaseBuild` / `leanArgsCount` and more5 `hasBuildArchive` /
  `hasSupportInterpreter` / `moreLinkArgsCount` and more6 `hasEnableArtifactCache` /
  `hasPrecompileModules` / `weakLinkArgsCount` and more7 `hasPackagesDir` /
  `hasReservoir` and more8 `hasBuildDir` / `hasWrappersDir` and more9
  `hasNativeLibDir` / `hasTestDriverArgs` and more10
  `hasLintDriverArgs` / `hasMoreLinkArgs` and more11
  `hasLeanOptions` / `hasMoreServerOptions` and more12
  `hasManifest` / `hasVersionTags` and more13
  `hasDescription` / `hasKeywords` and more14
  `hasHomepage` / `hasLicense` and more15
  `hasReadmeFile` / `hasLicenseFiles` and more16
  `hasBootstrap` / `hasMoreServerArgs` / `hasReleaseRepo` and more17
  `hasLeanLibDir` / `hasBinDir` / `hasIrDir` and more18
  `hasExtraDepTargets` / `hasRestoreAllArtifacts` / `hasLibPrefixOnWindows` and more19
  `hasAllowImportAll` / `hasFixedToolchain` / `hasVersion` and more20
  `hasBuiltinLint` / `hasMoreLeancArgs` / `hasAllowNonModules` and more21
  `hasRequiresModuleSystem` / `hasWeakLeancArgs` / `hasMoreLinkObjs` and more22
  `hasMoreLinkLibs` / `hasDynlibs` / `hasPlugins` and more23
  `hasDefaultFacets` / `hasMoreGlobalServerArgs` / `hasLibName`; more24
  `hasScope` / `hasRemoteUrl` / `hasWeakLeanArgs`; more25
  `hasFreestanding` / `hasRoots` / `hasGlobs`; more26
  `hasNeeds` / `hasWeakLinkArgs` / `hasExeName`; more27
  `hasMoreLeanArgs` / `hasNativeFacets` / `hasRoot`; more28
  `hasName` / `hasLeanArgs` / `hasTestRunner`; more29
  `hasServerOptions` / `hasLeancArgs` / `hasBaseName` — **table bodies are
  not excluded**).
  **Exceptions:** `requirePathScopedCount` tracks `[[require]]` scope only;
  `firstLeanLibName*` / `firstLeanLibRoot*` track first `[[lean_lib]]` scope only;
  `firstLeanExeName*` / `firstLeanExeRoot*` track first `[[lean_exe]]` scope only;
  `firstRequireName*` / `firstRequirePath*` / `firstRequireRev*` / `firstRequireGit*` /
  `firstRequireUrl*` / `firstRequireVersion*` / `firstRequireScope*` / `firstRequireSubDir*` /
  `firstRequireOpts*` track first
  `[[require]]` scope only
  (any other `[table]` / `[[…]]` header clears the respective flag).
* **`defaultTargetsCount` / `moreLeanArgsCount` / `weakLeanArgsCount` /
  `leanArgsCount` / `moreLinkArgsCount` / `weakLinkArgsCount`:** only counts closed `"…"` pairs inside
  the raw value span; unquoted tokens and nested structures are **not** modeled
  (fail-closed). Closing `]` is **not** required: an unclosed array with closed
  quote pairs still counts those pairs (same policy as more3 moreLeanArgs).
* **Comments:** only full-line `#` after indent is a comment. Mid-line `#` inside
  a value is **not** stripped (raw value bytes; subset honesty).
* **`packageName*` / `srcDir*` vs `valueOff`/`valueLen`:** named helpers strip a
  **closed** surrounding `"…"` pair and **fail closed** (miss / zero) on a leading
  `"` without a matching trailing `"` on the same line. `valueOff` / `valueLen`
  return the raw value span after `=` (no quote strip) so callers can choose policy.
* Local structural scan (does **not** compose `Toml` / `TomlQuery` APIs;
  reimplements the fail-closed config subset including `[[…]]`).
* Miss sentinel is `USize.neg1` (**LP64 harness**).
* **C ABI:** product exports stay `lean_fs_tomlcfg_*` (stable short name; not renamed).

## Intentional TCB (TomlConfig-local)

Structural ASCII markers + fixed key/header magic bytes are freestanding
`@[extern]` axioms kept **here**. Name-pinned on ComplianceCorpus (`path name=Ident`).
-/

namespace Systems.TomlConfig

open Systems.Scalars
open Systems.Bytes
open Systems.Status

/-- ASCII `'['` (91). -/
@[extern c inline "((uint32_t)91)"] public axiom cLBrack : U32
/-- ASCII `']'` (93). -/
@[extern c inline "((uint32_t)93)"] public axiom cRBrack : U32
/-- ASCII `'='` (61). -/
@[extern c inline "((uint32_t)61)"] public axiom cEq : U32
/-- ASCII `'#'` (35). -/
@[extern c inline "((uint32_t)35)"] public axiom cHash : U32
/-- ASCII `'"'` (34). -/
@[extern c inline "((uint32_t)34)"] public axiom cQuote : U32
/-- ASCII space (32). -/
@[extern c inline "((uint32_t)32)"] public axiom cSp : U32
/-- ASCII tab (9). -/
@[extern c inline "((uint32_t)9)"] public axiom cTab : U32
/-- ASCII LF (10). -/
@[extern c inline "((uint32_t)10)"] public axiom cLf : U32
/-- ASCII CR (13). -/
@[extern c inline "((uint32_t)13)"] public axiom cCr : U32

/-- Package key `name` length (4). -/
@[extern c inline "((size_t)4)"] public axiom nameKeyLen : USize
/-- `name[0]` = `'n'` (110). -/
@[extern c inline "((uint32_t)110)"] public axiom name0 : U32
/-- `name[1]` = `'a'` (97). -/
@[extern c inline "((uint32_t)97)"] public axiom name1 : U32
/-- `name[2]` = `'m'` (109). -/
@[extern c inline "((uint32_t)109)"] public axiom name2 : U32
/-- `name[3]` = `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom name3 : U32

/-- `lean_lib` header name length (8). -/
@[extern c inline "((size_t)8)"] public axiom leanLibNameLen : USize
/-- `'l'` (108). -/
@[extern c inline "((uint32_t)108)"] public axiom ll0 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom ll1 : U32
/-- `'a'` (97). -/
@[extern c inline "((uint32_t)97)"] public axiom ll2 : U32
/-- `'n'` (110). -/
@[extern c inline "((uint32_t)110)"] public axiom ll3 : U32
/-- `'_'` (95). -/
@[extern c inline "((uint32_t)95)"] public axiom ll4 : U32
/-- `'l'` (108). -/
@[extern c inline "((uint32_t)108)"] public axiom ll5 : U32
/-- `'i'` (105). -/
@[extern c inline "((uint32_t)105)"] public axiom ll6 : U32
/-- `'b'` (98). -/
@[extern c inline "((uint32_t)98)"] public axiom ll7 : U32

/-- `require` header name length (7). -/
@[extern c inline "((size_t)7)"] public axiom requireNameLen : USize
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom rq0 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom rq1 : U32
/-- `'q'` (113). -/
@[extern c inline "((uint32_t)113)"] public axiom rq2 : U32
/-- `'u'` (117). -/
@[extern c inline "((uint32_t)117)"] public axiom rq3 : U32
/-- `'i'` (105). -/
@[extern c inline "((uint32_t)105)"] public axiom rq4 : U32
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom rq5 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom rq6 : U32

/-- `'x'` (120) at `lean_exe` pos6 (`lean_exe` reuses `leanLibNameLen` + `ll0`–`ll4`). -/
@[extern c inline "((uint32_t)120)"] public axiom lx6 : U32

/-- `srcDir` key length (6). -/
@[extern c inline "((size_t)6)"] public axiom srcDirKeyLen : USize
/-- `'s'` (115). -/
@[extern c inline "((uint32_t)115)"] public axiom sd0 : U32
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom sd1 : U32
/-- `'c'` (99). -/
@[extern c inline "((uint32_t)99)"] public axiom sd2 : U32
/-- `'D'` (68). -/
@[extern c inline "((uint32_t)68)"] public axiom sd3 : U32
/-- `'i'` (105). -/
@[extern c inline "((uint32_t)105)"] public axiom sd4 : U32
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom sd5 : U32

/-- `defaultTargets` key length (14). -/
@[extern c inline "((size_t)14)"] public axiom defaultTargetsKeyLen : USize
/-- `'d'` (100). -/
@[extern c inline "((uint32_t)100)"] public axiom dt0 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom dt1 : U32
/-- `'f'` (102). -/
@[extern c inline "((uint32_t)102)"] public axiom dt2 : U32
/-- `'a'` (97). -/
@[extern c inline "((uint32_t)97)"] public axiom dt3 : U32
/-- `'u'` (117). -/
@[extern c inline "((uint32_t)117)"] public axiom dt4 : U32
/-- `'l'` (108). -/
@[extern c inline "((uint32_t)108)"] public axiom dt5 : U32
/-- `'t'` (116). -/
@[extern c inline "((uint32_t)116)"] public axiom dt6 : U32
/-- `'T'` (84). -/
@[extern c inline "((uint32_t)84)"] public axiom dt7 : U32
/-- `'a'` (97). -/
@[extern c inline "((uint32_t)97)"] public axiom dt8 : U32
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom dt9 : U32
/-- `'g'` (103). -/
@[extern c inline "((uint32_t)103)"] public axiom dt10 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom dt11 : U32
/-- `'t'` (116). -/
@[extern c inline "((uint32_t)116)"] public axiom dt12 : U32
/-- `'s'` (115). -/
@[extern c inline "((uint32_t)115)"] public axiom dt13 : U32

/-- Package key `version` length (7). -/
@[extern c inline "((size_t)7)"] public axiom versionKeyLen : USize
/-- `'v'` (118). -/
@[extern c inline "((uint32_t)118)"] public axiom ver0 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom ver1 : U32
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom ver2 : U32
/-- `'s'` (115). -/
@[extern c inline "((uint32_t)115)"] public axiom ver3 : U32
/-- `'i'` (105). -/
@[extern c inline "((uint32_t)105)"] public axiom ver4 : U32
/-- `'o'` (111). -/
@[extern c inline "((uint32_t)111)"] public axiom ver5 : U32
/-- `'n'` (110). -/
@[extern c inline "((uint32_t)110)"] public axiom ver6 : U32

/-- Key `buildType` length (9). -/
@[extern c inline "((size_t)9)"] public axiom buildTypeKeyLen : USize
/-- `'b'` (98). -/
@[extern c inline "((uint32_t)98)"] public axiom bt0 : U32
/-- `'u'` (117). -/
@[extern c inline "((uint32_t)117)"] public axiom bt1 : U32
/-- `'i'` (105). -/
@[extern c inline "((uint32_t)105)"] public axiom bt2 : U32
/-- `'l'` (108). -/
@[extern c inline "((uint32_t)108)"] public axiom bt3 : U32
/-- `'d'` (100). -/
@[extern c inline "((uint32_t)100)"] public axiom bt4 : U32
/-- `'T'` (84). -/
@[extern c inline "((uint32_t)84)"] public axiom bt5 : U32
/-- `'y'` (121). -/
@[extern c inline "((uint32_t)121)"] public axiom bt6 : U32
/-- `'p'` (112). -/
@[extern c inline "((uint32_t)112)"] public axiom bt7 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom bt8 : U32

/-- Key `path` length (4). -/
@[extern c inline "((size_t)4)"] public axiom pathKeyLen : USize
/-- `'p'` (112). -/
@[extern c inline "((uint32_t)112)"] public axiom path0 : U32
/-- `'a'` (97). -/
@[extern c inline "((uint32_t)97)"] public axiom path1 : U32
/-- `'t'` (116). -/
@[extern c inline "((uint32_t)116)"] public axiom path2 : U32
/-- `'h'` (104). -/
@[extern c inline "((uint32_t)104)"] public axiom path3 : U32

/-- Key `moreLeanArgs` length (12). -/
@[extern c inline "((size_t)12)"] public axiom moreLeanArgsKeyLen : USize
/-- `'m'` (109). -/
@[extern c inline "((uint32_t)109)"] public axiom mla0 : U32
/-- `'o'` (111). -/
@[extern c inline "((uint32_t)111)"] public axiom mla1 : U32
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom mla2 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom mla3 : U32
/-- `'L'` (76). -/
@[extern c inline "((uint32_t)76)"] public axiom mla4 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom mla5 : U32
/-- `'a'` (97). -/
@[extern c inline "((uint32_t)97)"] public axiom mla6 : U32
/-- `'n'` (110). -/
@[extern c inline "((uint32_t)110)"] public axiom mla7 : U32
/-- `'A'` (65). -/
@[extern c inline "((uint32_t)65)"] public axiom mla8 : U32
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom mla9 : U32
/-- `'g'` (103). -/
@[extern c inline "((uint32_t)103)"] public axiom mla10 : U32
/-- `'s'` (115). -/
@[extern c inline "((uint32_t)115)"] public axiom mla11 : U32

/-- Key `backend` length (7). -/
@[extern c inline "((size_t)7)"] public axiom backendKeyLen : USize
/-- `'b'` (98). -/
@[extern c inline "((uint32_t)98)"] public axiom be0 : U32
/-- `'a'` (97). -/
@[extern c inline "((uint32_t)97)"] public axiom be1 : U32
/-- `'c'` (99). -/
@[extern c inline "((uint32_t)99)"] public axiom be2 : U32
/-- `'k'` (107). -/
@[extern c inline "((uint32_t)107)"] public axiom be3 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom be4 : U32
/-- `'n'` (110). -/
@[extern c inline "((uint32_t)110)"] public axiom be5 : U32
/-- `'d'` (100). -/
@[extern c inline "((uint32_t)100)"] public axiom be6 : U32

/-- Key `testDriver` length (10). -/
@[extern c inline "((size_t)10)"] public axiom testDriverKeyLen : USize
/-- `'t'` (116). -/
@[extern c inline "((uint32_t)116)"] public axiom td0 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom td1 : U32
/-- `'s'` (115). -/
@[extern c inline "((uint32_t)115)"] public axiom td2 : U32
/-- `'t'` (116). -/
@[extern c inline "((uint32_t)116)"] public axiom td3 : U32
/-- `'D'` (68). -/
@[extern c inline "((uint32_t)68)"] public axiom td4 : U32
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom td5 : U32
/-- `'i'` (105). -/
@[extern c inline "((uint32_t)105)"] public axiom td6 : U32
/-- `'v'` (118). -/
@[extern c inline "((uint32_t)118)"] public axiom td7 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom td8 : U32
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom td9 : U32

/-- Key `lintDriver` length (10). -/
@[extern c inline "((size_t)10)"] public axiom lintDriverKeyLen : USize
/-- `'l'` (108). -/
@[extern c inline "((uint32_t)108)"] public axiom ld0 : U32
/-- `'i'` (105). -/
@[extern c inline "((uint32_t)105)"] public axiom ld1 : U32
/-- `'n'` (110). -/
@[extern c inline "((uint32_t)110)"] public axiom ld2 : U32
/-- `'t'` (116). -/
@[extern c inline "((uint32_t)116)"] public axiom ld3 : U32
/-- `'D'` (68). -/
@[extern c inline "((uint32_t)68)"] public axiom ld4 : U32
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom ld5 : U32
/-- `'i'` (105). -/
@[extern c inline "((uint32_t)105)"] public axiom ld6 : U32
/-- `'v'` (118). -/
@[extern c inline "((uint32_t)118)"] public axiom ld7 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom ld8 : U32
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom ld9 : U32

/-- Key `weakLeanArgs` length (12). -/
@[extern c inline "((size_t)12)"] public axiom weakLeanArgsKeyLen : USize
/-- `'w'` (119). -/
@[extern c inline "((uint32_t)119)"] public axiom wla0 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom wla1 : U32
/-- `'a'` (97). -/
@[extern c inline "((uint32_t)97)"] public axiom wla2 : U32
/-- `'k'` (107). -/
@[extern c inline "((uint32_t)107)"] public axiom wla3 : U32
/-- `'L'` (76). -/
@[extern c inline "((uint32_t)76)"] public axiom wla4 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom wla5 : U32
/-- `'a'` (97). -/
@[extern c inline "((uint32_t)97)"] public axiom wla6 : U32
/-- `'n'` (110). -/
@[extern c inline "((uint32_t)110)"] public axiom wla7 : U32
/-- `'A'` (65). -/
@[extern c inline "((uint32_t)65)"] public axiom wla8 : U32
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom wla9 : U32
/-- `'g'` (103). -/
@[extern c inline "((uint32_t)103)"] public axiom wla10 : U32
/-- `'s'` (115). -/
@[extern c inline "((uint32_t)115)"] public axiom wla11 : U32

/-- Key `platformIndependent` length (19). -/
@[extern c inline "((size_t)19)"] public axiom platformIndependentKeyLen : USize
/-- `'p'` (112). -/
@[extern c inline "((uint32_t)112)"] public axiom pi0 : U32
/-- `'l'` (108). -/
@[extern c inline "((uint32_t)108)"] public axiom pi1 : U32
/-- `'a'` (97). -/
@[extern c inline "((uint32_t)97)"] public axiom pi2 : U32
/-- `'t'` (116). -/
@[extern c inline "((uint32_t)116)"] public axiom pi3 : U32
/-- `'f'` (102). -/
@[extern c inline "((uint32_t)102)"] public axiom pi4 : U32
/-- `'o'` (111). -/
@[extern c inline "((uint32_t)111)"] public axiom pi5 : U32
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom pi6 : U32
/-- `'m'` (109). -/
@[extern c inline "((uint32_t)109)"] public axiom pi7 : U32
/-- `'I'` (73). -/
@[extern c inline "((uint32_t)73)"] public axiom pi8 : U32
/-- `'n'` (110). -/
@[extern c inline "((uint32_t)110)"] public axiom pi9 : U32
/-- `'d'` (100). -/
@[extern c inline "((uint32_t)100)"] public axiom pi10 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom pi11 : U32
/-- `'p'` (112). -/
@[extern c inline "((uint32_t)112)"] public axiom pi12 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom pi13 : U32
/-- `'n'` (110). -/
@[extern c inline "((uint32_t)110)"] public axiom pi14 : U32
/-- `'d'` (100). -/
@[extern c inline "((uint32_t)100)"] public axiom pi15 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom pi16 : U32
/-- `'n'` (110). -/
@[extern c inline "((uint32_t)110)"] public axiom pi17 : U32
/-- `'t'` (116). -/
@[extern c inline "((uint32_t)116)"] public axiom pi18 : U32

/-- Key `preferReleaseBuild` length (18). -/
@[extern c inline "((size_t)18)"] public axiom preferReleaseBuildKeyLen : USize
/-- `'p'` (112). -/
@[extern c inline "((uint32_t)112)"] public axiom prb0 : U32
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom prb1 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom prb2 : U32
/-- `'f'` (102). -/
@[extern c inline "((uint32_t)102)"] public axiom prb3 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom prb4 : U32
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom prb5 : U32
/-- `'R'` (82). -/
@[extern c inline "((uint32_t)82)"] public axiom prb6 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom prb7 : U32
/-- `'l'` (108). -/
@[extern c inline "((uint32_t)108)"] public axiom prb8 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom prb9 : U32
/-- `'a'` (97). -/
@[extern c inline "((uint32_t)97)"] public axiom prb10 : U32
/-- `'s'` (115). -/
@[extern c inline "((uint32_t)115)"] public axiom prb11 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom prb12 : U32
/-- `'B'` (66). -/
@[extern c inline "((uint32_t)66)"] public axiom prb13 : U32
/-- `'u'` (117). -/
@[extern c inline "((uint32_t)117)"] public axiom prb14 : U32
/-- `'i'` (105). -/
@[extern c inline "((uint32_t)105)"] public axiom prb15 : U32
/-- `'l'` (108). -/
@[extern c inline "((uint32_t)108)"] public axiom prb16 : U32
/-- `'d'` (100). -/
@[extern c inline "((uint32_t)100)"] public axiom prb17 : U32

/-- Key `leanArgs` length (8). -/
@[extern c inline "((size_t)8)"] public axiom leanArgsKeyLen : USize
/-- `'l'` (108). -/
@[extern c inline "((uint32_t)108)"] public axiom la0 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom la1 : U32
/-- `'a'` (97). -/
@[extern c inline "((uint32_t)97)"] public axiom la2 : U32
/-- `'n'` (110). -/
@[extern c inline "((uint32_t)110)"] public axiom la3 : U32
/-- `'A'` (65). -/
@[extern c inline "((uint32_t)65)"] public axiom la4 : U32
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom la5 : U32
/-- `'g'` (103). -/
@[extern c inline "((uint32_t)103)"] public axiom la6 : U32
/-- `'s'` (115). -/
@[extern c inline "((uint32_t)115)"] public axiom la7 : U32

/-- Key `moreLinkArgs` length (12). -/
@[extern c inline "((size_t)12)"] public axiom moreLinkArgsKeyLen : USize
/-- `'m'` (109). -/
@[extern c inline "((uint32_t)109)"] public axiom mlink0 : U32
/-- `'o'` (111). -/
@[extern c inline "((uint32_t)111)"] public axiom mlink1 : U32
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom mlink2 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom mlink3 : U32
/-- `'L'` (76). -/
@[extern c inline "((uint32_t)76)"] public axiom mlink4 : U32
/-- `'i'` (105). -/
@[extern c inline "((uint32_t)105)"] public axiom mlink5 : U32
/-- `'n'` (110). -/
@[extern c inline "((uint32_t)110)"] public axiom mlink6 : U32
/-- `'k'` (107). -/
@[extern c inline "((uint32_t)107)"] public axiom mlink7 : U32
/-- `'A'` (65). -/
@[extern c inline "((uint32_t)65)"] public axiom mlink8 : U32
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom mlink9 : U32
/-- `'g'` (103). -/
@[extern c inline "((uint32_t)103)"] public axiom mlink10 : U32
/-- `'s'` (115). -/
@[extern c inline "((uint32_t)115)"] public axiom mlink11 : U32

/-- Key `buildArchive` length (12). -/
@[extern c inline "((size_t)12)"] public axiom buildArchiveKeyLen : USize
/-- `'b'` (98). -/
@[extern c inline "((uint32_t)98)"] public axiom ba0 : U32
/-- `'u'` (117). -/
@[extern c inline "((uint32_t)117)"] public axiom ba1 : U32
/-- `'i'` (105). -/
@[extern c inline "((uint32_t)105)"] public axiom ba2 : U32
/-- `'l'` (108). -/
@[extern c inline "((uint32_t)108)"] public axiom ba3 : U32
/-- `'d'` (100). -/
@[extern c inline "((uint32_t)100)"] public axiom ba4 : U32
/-- `'A'` (65). -/
@[extern c inline "((uint32_t)65)"] public axiom ba5 : U32
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom ba6 : U32
/-- `'c'` (99). -/
@[extern c inline "((uint32_t)99)"] public axiom ba7 : U32
/-- `'h'` (104). -/
@[extern c inline "((uint32_t)104)"] public axiom ba8 : U32
/-- `'i'` (105). -/
@[extern c inline "((uint32_t)105)"] public axiom ba9 : U32
/-- `'v'` (118). -/
@[extern c inline "((uint32_t)118)"] public axiom ba10 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom ba11 : U32

/-- Key `supportInterpreter` length (18). -/
@[extern c inline "((size_t)18)"] public axiom supportInterpreterKeyLen : USize
/-- `'s'` (115). -/
@[extern c inline "((uint32_t)115)"] public axiom si0 : U32
/-- `'u'` (117). -/
@[extern c inline "((uint32_t)117)"] public axiom si1 : U32
/-- `'p'` (112). -/
@[extern c inline "((uint32_t)112)"] public axiom si2 : U32
/-- `'p'` (112). -/
@[extern c inline "((uint32_t)112)"] public axiom si3 : U32
/-- `'o'` (111). -/
@[extern c inline "((uint32_t)111)"] public axiom si4 : U32
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom si5 : U32
/-- `'t'` (116). -/
@[extern c inline "((uint32_t)116)"] public axiom si6 : U32
/-- `'I'` (73). -/
@[extern c inline "((uint32_t)73)"] public axiom si7 : U32
/-- `'n'` (110). -/
@[extern c inline "((uint32_t)110)"] public axiom si8 : U32
/-- `'t'` (116). -/
@[extern c inline "((uint32_t)116)"] public axiom si9 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom si10 : U32
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom si11 : U32
/-- `'p'` (112). -/
@[extern c inline "((uint32_t)112)"] public axiom si12 : U32
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom si13 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom si14 : U32
/-- `'t'` (116). -/
@[extern c inline "((uint32_t)116)"] public axiom si15 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom si16 : U32
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom si17 : U32


/-- Key `weakLinkArgs` length (12). -/
@[extern c inline "((size_t)12)"] public axiom weakLinkArgsKeyLen : USize
/-- `'w'` (119). -/
@[extern c inline "((uint32_t)119)"] public axiom wlink0 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom wlink1 : U32
/-- `'a'` (97). -/
@[extern c inline "((uint32_t)97)"] public axiom wlink2 : U32
/-- `'k'` (107). -/
@[extern c inline "((uint32_t)107)"] public axiom wlink3 : U32
/-- `'L'` (76). -/
@[extern c inline "((uint32_t)76)"] public axiom wlink4 : U32
/-- `'i'` (105). -/
@[extern c inline "((uint32_t)105)"] public axiom wlink5 : U32
/-- `'n'` (110). -/
@[extern c inline "((uint32_t)110)"] public axiom wlink6 : U32
/-- `'k'` (107). -/
@[extern c inline "((uint32_t)107)"] public axiom wlink7 : U32
/-- `'A'` (65). -/
@[extern c inline "((uint32_t)65)"] public axiom wlink8 : U32
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom wlink9 : U32
/-- `'g'` (103). -/
@[extern c inline "((uint32_t)103)"] public axiom wlink10 : U32
/-- `'s'` (115). -/
@[extern c inline "((uint32_t)115)"] public axiom wlink11 : U32

/-- Key `enableArtifactCache` length (19). -/
@[extern c inline "((size_t)19)"] public axiom enableArtifactCacheKeyLen : USize
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom eac0 : U32
/-- `'n'` (110). -/
@[extern c inline "((uint32_t)110)"] public axiom eac1 : U32
/-- `'a'` (97). -/
@[extern c inline "((uint32_t)97)"] public axiom eac2 : U32
/-- `'b'` (98). -/
@[extern c inline "((uint32_t)98)"] public axiom eac3 : U32
/-- `'l'` (108). -/
@[extern c inline "((uint32_t)108)"] public axiom eac4 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom eac5 : U32
/-- `'A'` (65). -/
@[extern c inline "((uint32_t)65)"] public axiom eac6 : U32
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom eac7 : U32
/-- `'t'` (116). -/
@[extern c inline "((uint32_t)116)"] public axiom eac8 : U32
/-- `'i'` (105). -/
@[extern c inline "((uint32_t)105)"] public axiom eac9 : U32
/-- `'f'` (102). -/
@[extern c inline "((uint32_t)102)"] public axiom eac10 : U32
/-- `'a'` (97). -/
@[extern c inline "((uint32_t)97)"] public axiom eac11 : U32
/-- `'c'` (99). -/
@[extern c inline "((uint32_t)99)"] public axiom eac12 : U32
/-- `'t'` (116). -/
@[extern c inline "((uint32_t)116)"] public axiom eac13 : U32
/-- `'C'` (67). -/
@[extern c inline "((uint32_t)67)"] public axiom eac14 : U32
/-- `'a'` (97). -/
@[extern c inline "((uint32_t)97)"] public axiom eac15 : U32
/-- `'c'` (99). -/
@[extern c inline "((uint32_t)99)"] public axiom eac16 : U32
/-- `'h'` (104). -/
@[extern c inline "((uint32_t)104)"] public axiom eac17 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom eac18 : U32

/-- Key `precompileModules` length (17). -/
@[extern c inline "((size_t)17)"] public axiom precompileModulesKeyLen : USize
/-- `'p'` (112). -/
@[extern c inline "((uint32_t)112)"] public axiom pcm0 : U32
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom pcm1 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom pcm2 : U32
/-- `'c'` (99). -/
@[extern c inline "((uint32_t)99)"] public axiom pcm3 : U32
/-- `'o'` (111). -/
@[extern c inline "((uint32_t)111)"] public axiom pcm4 : U32
/-- `'m'` (109). -/
@[extern c inline "((uint32_t)109)"] public axiom pcm5 : U32
/-- `'p'` (112). -/
@[extern c inline "((uint32_t)112)"] public axiom pcm6 : U32
/-- `'i'` (105). -/
@[extern c inline "((uint32_t)105)"] public axiom pcm7 : U32
/-- `'l'` (108). -/
@[extern c inline "((uint32_t)108)"] public axiom pcm8 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom pcm9 : U32
/-- `'M'` (77). -/
@[extern c inline "((uint32_t)77)"] public axiom pcm10 : U32
/-- `'o'` (111). -/
@[extern c inline "((uint32_t)111)"] public axiom pcm11 : U32
/-- `'d'` (100). -/
@[extern c inline "((uint32_t)100)"] public axiom pcm12 : U32
/-- `'u'` (117). -/
@[extern c inline "((uint32_t)117)"] public axiom pcm13 : U32
/-- `'l'` (108). -/
@[extern c inline "((uint32_t)108)"] public axiom pcm14 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom pcm15 : U32
/-- `'s'` (115). -/
@[extern c inline "((uint32_t)115)"] public axiom pcm16 : U32

/-- Key `root` length (4). -/
@[extern c inline "((size_t)4)"] public axiom rootKeyLen : USize
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom root0 : U32
/-- `'o'` (111). -/
@[extern c inline "((uint32_t)111)"] public axiom root1 : U32
/-- `'o'` (111). -/
@[extern c inline "((uint32_t)111)"] public axiom root2 : U32
/-- `'t'` (116). -/
@[extern c inline "((uint32_t)116)"] public axiom root3 : U32

/-- Key `packagesDir` length (11). -/
@[extern c inline "((size_t)11)"] public axiom packagesDirKeyLen : USize
/-- `'p'` (112). -/
@[extern c inline "((uint32_t)112)"] public axiom pkgd0 : U32
/-- `'a'` (97). -/
@[extern c inline "((uint32_t)97)"] public axiom pkgd1 : U32
/-- `'c'` (99). -/
@[extern c inline "((uint32_t)99)"] public axiom pkgd2 : U32
/-- `'k'` (107). -/
@[extern c inline "((uint32_t)107)"] public axiom pkgd3 : U32
/-- `'a'` (97). -/
@[extern c inline "((uint32_t)97)"] public axiom pkgd4 : U32
/-- `'g'` (103). -/
@[extern c inline "((uint32_t)103)"] public axiom pkgd5 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom pkgd6 : U32
/-- `'s'` (115). -/
@[extern c inline "((uint32_t)115)"] public axiom pkgd7 : U32
/-- `'D'` (68). -/
@[extern c inline "((uint32_t)68)"] public axiom pkgd8 : U32
/-- `'i'` (105). -/
@[extern c inline "((uint32_t)105)"] public axiom pkgd9 : U32
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom pkgd10 : U32

/-- Key `reservoir` length (9). -/
@[extern c inline "((size_t)9)"] public axiom reservoirKeyLen : USize
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom resv0 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom resv1 : U32
/-- `'s'` (115). -/
@[extern c inline "((uint32_t)115)"] public axiom resv2 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom resv3 : U32
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom resv4 : U32
/-- `'v'` (118). -/
@[extern c inline "((uint32_t)118)"] public axiom resv5 : U32
/-- `'o'` (111). -/
@[extern c inline "((uint32_t)111)"] public axiom resv6 : U32
/-- `'i'` (105). -/
@[extern c inline "((uint32_t)105)"] public axiom resv7 : U32
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom resv8 : U32

/-- Key `buildDir` length (8). -/
@[extern c inline "((size_t)8)"] public axiom buildDirKeyLen : USize
/-- `'b'` (98). -/
@[extern c inline "((uint32_t)98)"] public axiom bdir0 : U32
/-- `'u'` (117). -/
@[extern c inline "((uint32_t)117)"] public axiom bdir1 : U32
/-- `'i'` (105). -/
@[extern c inline "((uint32_t)105)"] public axiom bdir2 : U32
/-- `'l'` (108). -/
@[extern c inline "((uint32_t)108)"] public axiom bdir3 : U32
/-- `'d'` (100). -/
@[extern c inline "((uint32_t)100)"] public axiom bdir4 : U32
/-- `'D'` (68). -/
@[extern c inline "((uint32_t)68)"] public axiom bdir5 : U32
/-- `'i'` (105). -/
@[extern c inline "((uint32_t)105)"] public axiom bdir6 : U32
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom bdir7 : U32

/-- Key `wrappersDir` length (11). -/
@[extern c inline "((size_t)11)"] public axiom wrappersDirKeyLen : USize
/-- `'w'` (119). -/
@[extern c inline "((uint32_t)119)"] public axiom wrap0 : U32
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom wrap1 : U32
/-- `'a'` (97). -/
@[extern c inline "((uint32_t)97)"] public axiom wrap2 : U32
/-- `'p'` (112). -/
@[extern c inline "((uint32_t)112)"] public axiom wrap3 : U32
/-- `'p'` (112). -/
@[extern c inline "((uint32_t)112)"] public axiom wrap4 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom wrap5 : U32
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom wrap6 : U32
/-- `'s'` (115). -/
@[extern c inline "((uint32_t)115)"] public axiom wrap7 : U32
/-- `'D'` (68). -/
@[extern c inline "((uint32_t)68)"] public axiom wrap8 : U32
/-- `'i'` (105). -/
@[extern c inline "((uint32_t)105)"] public axiom wrap9 : U32
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom wrap10 : U32

/-- Key `nativeLibDir` length (12). -/
@[extern c inline "((size_t)12)"] public axiom nativeLibDirKeyLen : USize
/-- `'n'` (110). -/
@[extern c inline "((uint32_t)110)"] public axiom nld0 : U32
/-- `'a'` (97). -/
@[extern c inline "((uint32_t)97)"] public axiom nld1 : U32
/-- `'t'` (116). -/
@[extern c inline "((uint32_t)116)"] public axiom nld2 : U32
/-- `'i'` (105). -/
@[extern c inline "((uint32_t)105)"] public axiom nld3 : U32
/-- `'v'` (118). -/
@[extern c inline "((uint32_t)118)"] public axiom nld4 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom nld5 : U32
/-- `'L'` (76). -/
@[extern c inline "((uint32_t)76)"] public axiom nld6 : U32
/-- `'i'` (105). -/
@[extern c inline "((uint32_t)105)"] public axiom nld7 : U32
/-- `'b'` (98). -/
@[extern c inline "((uint32_t)98)"] public axiom nld8 : U32
/-- `'D'` (68). -/
@[extern c inline "((uint32_t)68)"] public axiom nld9 : U32
/-- `'i'` (105). -/
@[extern c inline "((uint32_t)105)"] public axiom nld10 : U32
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom nld11 : U32

/-- Key `testDriverArgs` length (14). -/
@[extern c inline "((size_t)14)"] public axiom testDriverArgsKeyLen : USize
/-- `'t'` (116). -/
@[extern c inline "((uint32_t)116)"] public axiom tda0 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom tda1 : U32
/-- `'s'` (115). -/
@[extern c inline "((uint32_t)115)"] public axiom tda2 : U32
/-- `'t'` (116). -/
@[extern c inline "((uint32_t)116)"] public axiom tda3 : U32
/-- `'D'` (68). -/
@[extern c inline "((uint32_t)68)"] public axiom tda4 : U32
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom tda5 : U32
/-- `'i'` (105). -/
@[extern c inline "((uint32_t)105)"] public axiom tda6 : U32
/-- `'v'` (118). -/
@[extern c inline "((uint32_t)118)"] public axiom tda7 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom tda8 : U32
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom tda9 : U32
/-- `'A'` (65). -/
@[extern c inline "((uint32_t)65)"] public axiom tda10 : U32
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom tda11 : U32
/-- `'g'` (103). -/
@[extern c inline "((uint32_t)103)"] public axiom tda12 : U32
/-- `'s'` (115). -/
@[extern c inline "((uint32_t)115)"] public axiom tda13 : U32

/-- Key `rev` length (3). -/
@[extern c inline "((size_t)3)"] public axiom revKeyLen : USize
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom rev0 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom rev1 : U32
/-- `'v'` (118). -/
@[extern c inline "((uint32_t)118)"] public axiom rev2 : U32

/-- Key `lintDriverArgs` length (14). -/
@[extern c inline "((size_t)14)"] public axiom lintDriverArgsKeyLen : USize
/-- `'l'` (108). -/
@[extern c inline "((uint32_t)108)"] public axiom lda0 : U32
/-- `'i'` (105). -/
@[extern c inline "((uint32_t)105)"] public axiom lda1 : U32
/-- `'n'` (110). -/
@[extern c inline "((uint32_t)110)"] public axiom lda2 : U32
/-- `'t'` (116). -/
@[extern c inline "((uint32_t)116)"] public axiom lda3 : U32
/-- `'D'` (68). -/
@[extern c inline "((uint32_t)68)"] public axiom lda4 : U32
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom lda5 : U32
/-- `'i'` (105). -/
@[extern c inline "((uint32_t)105)"] public axiom lda6 : U32
/-- `'v'` (118). -/
@[extern c inline "((uint32_t)118)"] public axiom lda7 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom lda8 : U32
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom lda9 : U32
/-- `'A'` (65). -/
@[extern c inline "((uint32_t)65)"] public axiom lda10 : U32
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom lda11 : U32
/-- `'g'` (103). -/
@[extern c inline "((uint32_t)103)"] public axiom lda12 : U32
/-- `'s'` (115). -/
@[extern c inline "((uint32_t)115)"] public axiom lda13 : U32

/-- Key `git` length (3). -/
@[extern c inline "((size_t)3)"] public axiom gitKeyLen : USize
/-- `'g'` (103). -/
@[extern c inline "((uint32_t)103)"] public axiom git0 : U32
/-- `'i'` (105). -/
@[extern c inline "((uint32_t)105)"] public axiom git1 : U32
/-- `'t'` (116). -/
@[extern c inline "((uint32_t)116)"] public axiom git2 : U32

/-- Key `leanOptions` length (11). -/
@[extern c inline "((size_t)11)"] public axiom leanOptionsKeyLen : USize
/-- `'l'` (108). -/
@[extern c inline "((uint32_t)108)"] public axiom lo0 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom lo1 : U32
/-- `'a'` (97). -/
@[extern c inline "((uint32_t)97)"] public axiom lo2 : U32
/-- `'n'` (110). -/
@[extern c inline "((uint32_t)110)"] public axiom lo3 : U32
/-- `'O'` (79). -/
@[extern c inline "((uint32_t)79)"] public axiom lo4 : U32
/-- `'p'` (112). -/
@[extern c inline "((uint32_t)112)"] public axiom lo5 : U32
/-- `'t'` (116). -/
@[extern c inline "((uint32_t)116)"] public axiom lo6 : U32
/-- `'i'` (105). -/
@[extern c inline "((uint32_t)105)"] public axiom lo7 : U32
/-- `'o'` (111). -/
@[extern c inline "((uint32_t)111)"] public axiom lo8 : U32
/-- `'n'` (110). -/
@[extern c inline "((uint32_t)110)"] public axiom lo9 : U32
/-- `'s'` (115). -/
@[extern c inline "((uint32_t)115)"] public axiom lo10 : U32

/-- Key `moreServerOptions` length (17). -/
@[extern c inline "((size_t)17)"] public axiom moreServerOptionsKeyLen : USize
/-- `'m'` (109). -/
@[extern c inline "((uint32_t)109)"] public axiom mso0 : U32
/-- `'o'` (111). -/
@[extern c inline "((uint32_t)111)"] public axiom mso1 : U32
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom mso2 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom mso3 : U32
/-- `'S'` (83). -/
@[extern c inline "((uint32_t)83)"] public axiom mso4 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom mso5 : U32
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom mso6 : U32
/-- `'v'` (118). -/
@[extern c inline "((uint32_t)118)"] public axiom mso7 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom mso8 : U32
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom mso9 : U32
/-- `'O'` (79). -/
@[extern c inline "((uint32_t)79)"] public axiom mso10 : U32
/-- `'p'` (112). -/
@[extern c inline "((uint32_t)112)"] public axiom mso11 : U32
/-- `'t'` (116). -/
@[extern c inline "((uint32_t)116)"] public axiom mso12 : U32
/-- `'i'` (105). -/
@[extern c inline "((uint32_t)105)"] public axiom mso13 : U32
/-- `'o'` (111). -/
@[extern c inline "((uint32_t)111)"] public axiom mso14 : U32
/-- `'n'` (110). -/
@[extern c inline "((uint32_t)110)"] public axiom mso15 : U32
/-- `'s'` (115). -/
@[extern c inline "((uint32_t)115)"] public axiom mso16 : U32

/-- Key `url` length (3). -/
@[extern c inline "((size_t)3)"] public axiom urlKeyLen : USize
/-- `'u'` (117). -/
@[extern c inline "((uint32_t)117)"] public axiom url0 : U32
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom url1 : U32
/-- `'l'` (108). -/
@[extern c inline "((uint32_t)108)"] public axiom url2 : U32

/-- Key `manifest` length (8). -/
@[extern c inline "((size_t)8)"] public axiom manifestKeyLen : USize
/-- `'m'` (109). -/
@[extern c inline "((uint32_t)109)"] public axiom mf0 : U32
/-- `'a'` (97). -/
@[extern c inline "((uint32_t)97)"] public axiom mf1 : U32
/-- `'n'` (110). -/
@[extern c inline "((uint32_t)110)"] public axiom mf2 : U32
/-- `'i'` (105). -/
@[extern c inline "((uint32_t)105)"] public axiom mf3 : U32
/-- `'f'` (102). -/
@[extern c inline "((uint32_t)102)"] public axiom mf4 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom mf5 : U32
/-- `'s'` (115). -/
@[extern c inline "((uint32_t)115)"] public axiom mf6 : U32
/-- `'t'` (116). -/
@[extern c inline "((uint32_t)116)"] public axiom mf7 : U32

/-- Key `versionTags` length (11). -/
@[extern c inline "((size_t)11)"] public axiom versionTagsKeyLen : USize
/-- `'v'` (118). -/
@[extern c inline "((uint32_t)118)"] public axiom vt0 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom vt1 : U32
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom vt2 : U32
/-- `'s'` (115). -/
@[extern c inline "((uint32_t)115)"] public axiom vt3 : U32
/-- `'i'` (105). -/
@[extern c inline "((uint32_t)105)"] public axiom vt4 : U32
/-- `'o'` (111). -/
@[extern c inline "((uint32_t)111)"] public axiom vt5 : U32
/-- `'n'` (110). -/
@[extern c inline "((uint32_t)110)"] public axiom vt6 : U32
/-- `'T'` (84). -/
@[extern c inline "((uint32_t)84)"] public axiom vt7 : U32
/-- `'a'` (97). -/
@[extern c inline "((uint32_t)97)"] public axiom vt8 : U32
/-- `'g'` (103). -/
@[extern c inline "((uint32_t)103)"] public axiom vt9 : U32
/-- `'s'` (115). -/
@[extern c inline "((uint32_t)115)"] public axiom vt10 : U32

/-- Key `description` length (11). -/
@[extern c inline "((size_t)11)"] public axiom descriptionKeyLen : USize
/-- `'d'` (100). -/
@[extern c inline "((uint32_t)100)"] public axiom ds0 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom ds1 : U32
/-- `'s'` (115). -/
@[extern c inline "((uint32_t)115)"] public axiom ds2 : U32
/-- `'c'` (99). -/
@[extern c inline "((uint32_t)99)"] public axiom ds3 : U32
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom ds4 : U32
/-- `'i'` (105). -/
@[extern c inline "((uint32_t)105)"] public axiom ds5 : U32
/-- `'p'` (112). -/
@[extern c inline "((uint32_t)112)"] public axiom ds6 : U32
/-- `'t'` (116). -/
@[extern c inline "((uint32_t)116)"] public axiom ds7 : U32
/-- `'i'` (105). -/
@[extern c inline "((uint32_t)105)"] public axiom ds8 : U32
/-- `'o'` (111). -/
@[extern c inline "((uint32_t)111)"] public axiom ds9 : U32
/-- `'n'` (110). -/
@[extern c inline "((uint32_t)110)"] public axiom ds10 : U32

/-- Key `keywords` length (8). -/
@[extern c inline "((size_t)8)"] public axiom keywordsKeyLen : USize
/-- `'k'` (107). -/
@[extern c inline "((uint32_t)107)"] public axiom kw0 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom kw1 : U32
/-- `'y'` (121). -/
@[extern c inline "((uint32_t)121)"] public axiom kw2 : U32
/-- `'w'` (119). -/
@[extern c inline "((uint32_t)119)"] public axiom kw3 : U32
/-- `'o'` (111). -/
@[extern c inline "((uint32_t)111)"] public axiom kw4 : U32
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom kw5 : U32
/-- `'d'` (100). -/
@[extern c inline "((uint32_t)100)"] public axiom kw6 : U32
/-- `'s'` (115). -/
@[extern c inline "((uint32_t)115)"] public axiom kw7 : U32

/-- Key `scope` length (5). -/
@[extern c inline "((size_t)5)"] public axiom scopeKeyLen : USize
/-- `'s'` (115). -/
@[extern c inline "((uint32_t)115)"] public axiom sc0 : U32
/-- `'c'` (99). -/
@[extern c inline "((uint32_t)99)"] public axiom sc1 : U32
/-- `'o'` (111). -/
@[extern c inline "((uint32_t)111)"] public axiom sc2 : U32
/-- `'p'` (112). -/
@[extern c inline "((uint32_t)112)"] public axiom sc3 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom sc4 : U32

/-- Key `homepage` length (8). -/
@[extern c inline "((size_t)8)"] public axiom homepageKeyLen : USize
/-- `'h'` (104). -/
@[extern c inline "((uint32_t)104)"] public axiom hp0 : U32
/-- `'o'` (111). -/
@[extern c inline "((uint32_t)111)"] public axiom hp1 : U32
/-- `'m'` (109). -/
@[extern c inline "((uint32_t)109)"] public axiom hp2 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom hp3 : U32
/-- `'p'` (112). -/
@[extern c inline "((uint32_t)112)"] public axiom hp4 : U32
/-- `'a'` (97). -/
@[extern c inline "((uint32_t)97)"] public axiom hp5 : U32
/-- `'g'` (103). -/
@[extern c inline "((uint32_t)103)"] public axiom hp6 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom hp7 : U32

/-- Key `license` length (7). -/
@[extern c inline "((size_t)7)"] public axiom licenseKeyLen : USize
/-- `'l'` (108). -/
@[extern c inline "((uint32_t)108)"] public axiom lc0 : U32
/-- `'i'` (105). -/
@[extern c inline "((uint32_t)105)"] public axiom lc1 : U32
/-- `'c'` (99). -/
@[extern c inline "((uint32_t)99)"] public axiom lc2 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom lc3 : U32
/-- `'n'` (110). -/
@[extern c inline "((uint32_t)110)"] public axiom lc4 : U32
/-- `'s'` (115). -/
@[extern c inline "((uint32_t)115)"] public axiom lc5 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom lc6 : U32

/-- Key `subDir` length (6). -/
@[extern c inline "((size_t)6)"] public axiom subDirKeyLen : USize
/-- `'s'` (115) — subDir byte0 (distinct names from srcDir `sd*`). -/
@[extern c inline "((uint32_t)115)"] public axiom sbd0 : U32
/-- `'u'` (117). -/
@[extern c inline "((uint32_t)117)"] public axiom sbd1 : U32
/-- `'b'` (98). -/
@[extern c inline "((uint32_t)98)"] public axiom sbd2 : U32
/-- `'D'` (68). -/
@[extern c inline "((uint32_t)68)"] public axiom sbd3 : U32
/-- `'i'` (105). -/
@[extern c inline "((uint32_t)105)"] public axiom sbd4 : U32
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom sbd5 : U32

/-- Key `readmeFile` length (10). -/
@[extern c inline "((size_t)10)"] public axiom readmeFileKeyLen : USize
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom rf0 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom rf1 : U32
/-- `'a'` (97). -/
@[extern c inline "((uint32_t)97)"] public axiom rf2 : U32
/-- `'d'` (100). -/
@[extern c inline "((uint32_t)100)"] public axiom rf3 : U32
/-- `'m'` (109). -/
@[extern c inline "((uint32_t)109)"] public axiom rf4 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom rf5 : U32
/-- `'F'` (70). -/
@[extern c inline "((uint32_t)70)"] public axiom rf6 : U32
/-- `'i'` (105). -/
@[extern c inline "((uint32_t)105)"] public axiom rf7 : U32
/-- `'l'` (108). -/
@[extern c inline "((uint32_t)108)"] public axiom rf8 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom rf9 : U32

/-- Key `licenseFiles` length (12). -/
@[extern c inline "((size_t)12)"] public axiom licenseFilesKeyLen : USize
/-- `'l'` (108). -/
@[extern c inline "((uint32_t)108)"] public axiom lf0 : U32
/-- `'i'` (105). -/
@[extern c inline "((uint32_t)105)"] public axiom lf1 : U32
/-- `'c'` (99). -/
@[extern c inline "((uint32_t)99)"] public axiom lf2 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom lf3 : U32
/-- `'n'` (110). -/
@[extern c inline "((uint32_t)110)"] public axiom lf4 : U32
/-- `'s'` (115). -/
@[extern c inline "((uint32_t)115)"] public axiom lf5 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom lf6 : U32
/-- `'F'` (70). -/
@[extern c inline "((uint32_t)70)"] public axiom lf7 : U32
/-- `'i'` (105). -/
@[extern c inline "((uint32_t)105)"] public axiom lf8 : U32
/-- `'l'` (108). -/
@[extern c inline "((uint32_t)108)"] public axiom lf9 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom lf10 : U32
/-- `'s'` (115). -/
@[extern c inline "((uint32_t)115)"] public axiom lf11 : U32

/-- Key `opts` length (4). -/
@[extern c inline "((size_t)4)"] public axiom optsKeyLen : USize
/-- `'o'` (111). -/
@[extern c inline "((uint32_t)111)"] public axiom op0 : U32
/-- `'p'` (112). -/
@[extern c inline "((uint32_t)112)"] public axiom op1 : U32
/-- `'t'` (116). -/
@[extern c inline "((uint32_t)116)"] public axiom op2 : U32
/-- `'s'` (115). -/
@[extern c inline "((uint32_t)115)"] public axiom op3 : U32

/-- Key length for `type` (4). DependencySrc table form. -/
@[extern c inline "((size_t)4)"] public axiom typeKeyLen : USize
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom ty0 : U32
/-- 'y' (121). -/
@[extern c inline "((uint32_t)121)"] public axiom ty1 : U32
/-- 'p' (112). -/
@[extern c inline "((uint32_t)112)"] public axiom ty2 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom ty3 : U32
/-- Key length for `dir` (3). DependencySrc.path table form. -/
@[extern c inline "((size_t)3)"] public axiom dirKeyLen : USize
/-- 'd' (100). -/
@[extern c inline "((uint32_t)100)"] public axiom dir0 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom dir1 : U32
/-- 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom dir2 : U32
/-- Key length for `source` (6). Dependency optional source table. -/
@[extern c inline "((size_t)6)"] public axiom sourceKeyLen : USize
/-- 's' (115). -/
@[extern c inline "((uint32_t)115)"] public axiom src0 : U32
/-- 'o' (111). -/
@[extern c inline "((uint32_t)111)"] public axiom src1 : U32
/-- 'u' (117). -/
@[extern c inline "((uint32_t)117)"] public axiom src2 : U32
/-- 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom src3 : U32
/-- 'c' (99). -/
@[extern c inline "((uint32_t)99)"] public axiom src4 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom src5 : U32

/-- Key length for `kind` (4). LakeConfig / CacheServiceConfig TOML. -/
@[extern c inline "((size_t)4)"] public axiom kindKeyLen : USize
/-- 'k' (107). -/
@[extern c inline "((uint32_t)107)"] public axiom kind0 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom kind1 : U32
/-- 'n' (110). -/
@[extern c inline "((uint32_t)110)"] public axiom kind2 : U32
/-- 'd' (100). -/
@[extern c inline "((uint32_t)100)"] public axiom kind3 : U32
/-- Key length for `preset` (6). Pattern.decodeToml versionTags preset. -/
@[extern c inline "((size_t)6)"] public axiom presetKeyLen : USize
/-- 'p' (112). -/
@[extern c inline "((uint32_t)112)"] public axiom pre0 : U32
/-- 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom pre1 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom pre2 : U32
/-- 's' (115). -/
@[extern c inline "((uint32_t)115)"] public axiom pre3 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom pre4 : U32
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom pre5 : U32
/-- Key length for `extension` (9). PathPatDescr.decodeToml. -/
@[extern c inline "((size_t)9)"] public axiom extensionKeyLen : USize
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom ext0 : U32
/-- 'x' (120). -/
@[extern c inline "((uint32_t)120)"] public axiom ext1 : U32
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom ext2 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom ext3 : U32
/-- 'n' (110). -/
@[extern c inline "((uint32_t)110)"] public axiom ext4 : U32
/-- 's' (115). -/
@[extern c inline "((uint32_t)115)"] public axiom ext5 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom ext6 : U32
/-- 'o' (111). -/
@[extern c inline "((uint32_t)111)"] public axiom ext7 : U32
/-- 'n' (110). -/
@[extern c inline "((uint32_t)110)"] public axiom ext8 : U32

/-- Key length for `filter` (6). InputDir.decodeToml filter pattern. -/
@[extern c inline "((size_t)6)"] public axiom filterKeyLen : USize
/-- 'f' (102). -/
@[extern c inline "((uint32_t)102)"] public axiom fil0 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom fil1 : U32
/-- 'l' (108). -/
@[extern c inline "((uint32_t)108)"] public axiom fil2 : U32
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom fil3 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom fil4 : U32
/-- 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom fil5 : U32
/-- Key length for `text` (4). InputFile/InputDir text mode. -/
@[extern c inline "((size_t)4)"] public axiom textKeyLen : USize
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom txt0 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom txt1 : U32
/-- 'x' (120). -/
@[extern c inline "((uint32_t)120)"] public axiom txt2 : U32
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom txt3 : U32
/-- Key length for `fileName` (8). PathPatDescr.decodeToml fileName pattern. -/
@[extern c inline "((size_t)8)"] public axiom fileNameKeyLen : USize
/-- 'f' (102). -/
@[extern c inline "((uint32_t)102)"] public axiom fn0 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom fn1 : U32
/-- 'l' (108). -/
@[extern c inline "((uint32_t)108)"] public axiom fn2 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom fn3 : U32
/-- 'N' (78). -/
@[extern c inline "((uint32_t)78)"] public axiom fn4 : U32
/-- 'a' (97). -/
@[extern c inline "((uint32_t)97)"] public axiom fn5 : U32
/-- 'm' (109). -/
@[extern c inline "((uint32_t)109)"] public axiom fn6 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom fn7 : U32

/-- Key length for `startsWith` (10). StrPatDescr/PathPat string prefix pattern. -/
@[extern c inline "((size_t)10)"] public axiom startsWithKeyLen : USize
/-- 's' (115). -/
@[extern c inline "((uint32_t)115)"] public axiom sw0 : U32
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom sw1 : U32
/-- 'a' (97). -/
@[extern c inline "((uint32_t)97)"] public axiom sw2 : U32
/-- 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom sw3 : U32
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom sw4 : U32
/-- 's' (115). -/
@[extern c inline "((uint32_t)115)"] public axiom sw5 : U32
/-- 'W' (87). -/
@[extern c inline "((uint32_t)87)"] public axiom sw6 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom sw7 : U32
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom sw8 : U32
/-- 'h' (104). -/
@[extern c inline "((uint32_t)104)"] public axiom sw9 : U32
/-- Key length for `endsWith` (8). StrPatDescr/PathPat string suffix pattern. -/
@[extern c inline "((size_t)8)"] public axiom endsWithKeyLen : USize
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom ew0 : U32
/-- 'n' (110). -/
@[extern c inline "((uint32_t)110)"] public axiom ew1 : U32
/-- 'd' (100). -/
@[extern c inline "((uint32_t)100)"] public axiom ew2 : U32
/-- 's' (115). -/
@[extern c inline "((uint32_t)115)"] public axiom ew3 : U32
/-- 'W' (87). -/
@[extern c inline "((uint32_t)87)"] public axiom ew4 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom ew5 : U32
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom ew6 : U32
/-- 'h' (104). -/
@[extern c inline "((uint32_t)104)"] public axiom ew7 : U32
/-- Key length for `not` (3). PathPatDescr/StrPatDescr negation pattern. -/
@[extern c inline "((size_t)3)"] public axiom notKeyLen : USize
/-- 'n' (110). -/
@[extern c inline "((uint32_t)110)"] public axiom nt0 : U32
/-- 'o' (111). -/
@[extern c inline "((uint32_t)111)"] public axiom nt1 : U32
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom nt2 : U32


/-- Key length for `any` (3). PatternDescr disjunction. -/
@[extern c inline "((size_t)3)"] public axiom anyKeyLen : USize
/-- 'a' (97). -/
@[extern c inline "((uint32_t)97)"] public axiom any0 : U32
/-- 'n' (110). -/
@[extern c inline "((uint32_t)110)"] public axiom any1 : U32
/-- 'y' (121). -/
@[extern c inline "((uint32_t)121)"] public axiom any2 : U32
/-- Key length for `all` (3). PatternDescr conjunction. -/
@[extern c inline "((size_t)3)"] public axiom allKeyLen : USize
/-- 'a' (97). -/
@[extern c inline "((uint32_t)97)"] public axiom all0 : U32
/-- 'l' (108). -/
@[extern c inline "((uint32_t)108)"] public axiom all1 : U32
/-- 'l' (108). -/
@[extern c inline "((uint32_t)108)"] public axiom all2 : U32
/-- Key length for `apiEndpoint` (11). LakeConfig cache service URL. -/
@[extern c inline "((size_t)11)"] public axiom apiEndpointKeyLen : USize
/-- 'a' (97). -/
@[extern c inline "((uint32_t)97)"] public axiom ae0 : U32
/-- 'p' (112). -/
@[extern c inline "((uint32_t)112)"] public axiom ae1 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom ae2 : U32
/-- 'E' (69). -/
@[extern c inline "((uint32_t)69)"] public axiom ae3 : U32
/-- 'n' (110). -/
@[extern c inline "((uint32_t)110)"] public axiom ae4 : U32
/-- 'd' (100). -/
@[extern c inline "((uint32_t)100)"] public axiom ae5 : U32
/-- 'p' (112). -/
@[extern c inline "((uint32_t)112)"] public axiom ae6 : U32
/-- 'o' (111). -/
@[extern c inline "((uint32_t)111)"] public axiom ae7 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom ae8 : U32
/-- 'n' (110). -/
@[extern c inline "((uint32_t)110)"] public axiom ae9 : U32
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom ae10 : U32

/-- Key length for `artifactEndpoint` (16). CacheServiceConfig S3 artifact URL. -/
@[extern c inline "((size_t)16)"] public axiom artifactEndpointKeyLen : USize
/-- 'a' (97). -/
@[extern c inline "((uint32_t)97)"] public axiom art0 : U32
/-- 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom art1 : U32
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom art2 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom art3 : U32
/-- 'f' (102). -/
@[extern c inline "((uint32_t)102)"] public axiom art4 : U32
/-- 'a' (97). -/
@[extern c inline "((uint32_t)97)"] public axiom art5 : U32
/-- 'c' (99). -/
@[extern c inline "((uint32_t)99)"] public axiom art6 : U32
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom art7 : U32
/-- 'E' (69). -/
@[extern c inline "((uint32_t)69)"] public axiom art8 : U32
/-- 'n' (110). -/
@[extern c inline "((uint32_t)110)"] public axiom art9 : U32
/-- 'd' (100). -/
@[extern c inline "((uint32_t)100)"] public axiom art10 : U32
/-- 'p' (112). -/
@[extern c inline "((uint32_t)112)"] public axiom art11 : U32
/-- 'o' (111). -/
@[extern c inline "((uint32_t)111)"] public axiom art12 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom art13 : U32
/-- 'n' (110). -/
@[extern c inline "((uint32_t)110)"] public axiom art14 : U32
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom art15 : U32
/-- Key length for `revisionEndpoint` (16). CacheServiceConfig S3 revision URL. -/
@[extern c inline "((size_t)16)"] public axiom revisionEndpointKeyLen : USize
/-- 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom reE0 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom reE1 : U32
/-- 'v' (118). -/
@[extern c inline "((uint32_t)118)"] public axiom reE2 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom reE3 : U32
/-- 's' (115). -/
@[extern c inline "((uint32_t)115)"] public axiom reE4 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom reE5 : U32
/-- 'o' (111). -/
@[extern c inline "((uint32_t)111)"] public axiom reE6 : U32
/-- 'n' (110). -/
@[extern c inline "((uint32_t)110)"] public axiom reE7 : U32
/-- 'E' (69). -/
@[extern c inline "((uint32_t)69)"] public axiom reE8 : U32
/-- 'n' (110). -/
@[extern c inline "((uint32_t)110)"] public axiom reE9 : U32
/-- 'd' (100). -/
@[extern c inline "((uint32_t)100)"] public axiom reE10 : U32
/-- 'p' (112). -/
@[extern c inline "((uint32_t)112)"] public axiom reE11 : U32
/-- 'o' (111). -/
@[extern c inline "((uint32_t)111)"] public axiom reE12 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom reE13 : U32
/-- 'n' (110). -/
@[extern c inline "((uint32_t)110)"] public axiom reE14 : U32
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom reE15 : U32
/-- Key length for `defaultService` (14). CacheConfig default service name. -/
@[extern c inline "((size_t)14)"] public axiom defaultServiceKeyLen : USize
/-- 'd' (100). -/
@[extern c inline "((uint32_t)100)"] public axiom dsv0 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom dsv1 : U32
/-- 'f' (102). -/
@[extern c inline "((uint32_t)102)"] public axiom dsv2 : U32
/-- 'a' (97). -/
@[extern c inline "((uint32_t)97)"] public axiom dsv3 : U32
/-- 'u' (117). -/
@[extern c inline "((uint32_t)117)"] public axiom dsv4 : U32
/-- 'l' (108). -/
@[extern c inline "((uint32_t)108)"] public axiom dsv5 : U32
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom dsv6 : U32
/-- 'S' (83). -/
@[extern c inline "((uint32_t)83)"] public axiom dsv7 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom dsv8 : U32
/-- 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom dsv9 : U32
/-- 'v' (118). -/
@[extern c inline "((uint32_t)118)"] public axiom dsv10 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom dsv11 : U32
/-- 'c' (99). -/
@[extern c inline "((uint32_t)99)"] public axiom dsv12 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom dsv13 : U32

/-- Key length for `service` (7). CacheOutput service name field. -/
@[extern c inline "((size_t)7)"] public axiom serviceKeyLen : USize
/-- 's' (115). -/
@[extern c inline "((uint32_t)115)"] public axiom svc0 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom svc1 : U32
/-- 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom svc2 : U32
/-- 'v' (118). -/
@[extern c inline "((uint32_t)118)"] public axiom svc3 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom svc4 : U32
/-- 'c' (99). -/
@[extern c inline "((uint32_t)99)"] public axiom svc5 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom svc6 : U32

/-- Key length for `repo` (4). CacheOutput repo scope field. -/
@[extern c inline "((size_t)4)"] public axiom repoKeyLen : USize
/-- 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom repo0 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom repo1 : U32
/-- 'p' (112). -/
@[extern c inline "((uint32_t)112)"] public axiom repo2 : U32
/-- 'o' (111). -/
@[extern c inline "((uint32_t)111)"] public axiom repo3 : U32

/-- Key length for `schemaVersion` (13). CacheOutput schema version field. -/
@[extern c inline "((size_t)13)"] public axiom schemaVersionKeyLen : USize
/-- 's' (115). -/
@[extern c inline "((uint32_t)115)"] public axiom sch0 : U32
/-- 'c' (99). -/
@[extern c inline "((uint32_t)99)"] public axiom sch1 : U32
/-- 'h' (104). -/
@[extern c inline "((uint32_t)104)"] public axiom sch2 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom sch3 : U32
/-- 'm' (109). -/
@[extern c inline "((uint32_t)109)"] public axiom sch4 : U32
/-- 'a' (97). -/
@[extern c inline "((uint32_t)97)"] public axiom sch5 : U32
/-- 'V' (86). -/
@[extern c inline "((uint32_t)86)"] public axiom sch6 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom sch7 : U32
/-- 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom sch8 : U32
/-- 's' (115). -/
@[extern c inline "((uint32_t)115)"] public axiom sch9 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom sch10 : U32
/-- 'o' (111). -/
@[extern c inline "((uint32_t)111)"] public axiom sch11 : U32
/-- 'n' (110). -/
@[extern c inline "((uint32_t)110)"] public axiom sch12 : U32


/-- Key length for `data` (4). CacheOutput JSON data payload field. -/
@[extern c inline "((size_t)4)"] public axiom dataKeyLen : USize
/-- 'd' (100). -/
@[extern c inline "((uint32_t)100)"] public axiom data0 : U32
/-- 'a' (97). -/
@[extern c inline "((uint32_t)97)"] public axiom data1 : U32
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom data2 : U32
/-- 'a' (97). -/
@[extern c inline "((uint32_t)97)"] public axiom data3 : U32

/-- Key length for `manifestFile` (12). Manifest entry relative manifest path field. -/
@[extern c inline "((size_t)12)"] public axiom manifestFileKeyLen : USize
/-- 'm' (109). -/
@[extern c inline "((uint32_t)109)"] public axiom mfile0 : U32
/-- 'a' (97). -/
@[extern c inline "((uint32_t)97)"] public axiom mfile1 : U32
/-- 'n' (110). -/
@[extern c inline "((uint32_t)110)"] public axiom mfile2 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom mfile3 : U32
/-- 'f' (102). -/
@[extern c inline "((uint32_t)102)"] public axiom mfile4 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom mfile5 : U32
/-- 's' (115). -/
@[extern c inline "((uint32_t)115)"] public axiom mfile6 : U32
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom mfile7 : U32
/-- 'F' (70). -/
@[extern c inline "((uint32_t)70)"] public axiom mfile8 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom mfile9 : U32
/-- 'l' (108). -/
@[extern c inline "((uint32_t)108)"] public axiom mfile10 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom mfile11 : U32

/-- Key length for `lakeDir` (7). Manifest lake directory field. -/
@[extern c inline "((size_t)7)"] public axiom lakeDirKeyLen : USize
/-- 'l' (108). -/
@[extern c inline "((uint32_t)108)"] public axiom laked0 : U32
/-- 'a' (97). -/
@[extern c inline "((uint32_t)97)"] public axiom laked1 : U32
/-- 'k' (107). -/
@[extern c inline "((uint32_t)107)"] public axiom laked2 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom laked3 : U32
/-- 'D' (68). -/
@[extern c inline "((uint32_t)68)"] public axiom laked4 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom laked5 : U32
/-- 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom laked6 : U32

/-- Key length for `configFile` (10). Package/Manifest configuration file path field. -/
@[extern c inline "((size_t)10)"] public axiom cfgfKeyLen : USize
/-- 'c' (99). -/
@[extern c inline "((uint32_t)99)"] public axiom cfgf0 : U32
/-- 'o' (111). -/
@[extern c inline "((uint32_t)111)"] public axiom cfgf1 : U32
/-- 'n' (110). -/
@[extern c inline "((uint32_t)110)"] public axiom cfgf2 : U32
/-- 'f' (102). -/
@[extern c inline "((uint32_t)102)"] public axiom cfgf3 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom cfgf4 : U32
/-- 'g' (103). -/
@[extern c inline "((uint32_t)103)"] public axiom cfgf5 : U32
/-- 'F' (70). -/
@[extern c inline "((uint32_t)70)"] public axiom cfgf6 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom cfgf7 : U32
/-- 'l' (108). -/
@[extern c inline "((uint32_t)108)"] public axiom cfgf8 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom cfgf9 : U32

/-- Key length for `inputRev` (8). Manifest package entry git input revision field. -/
@[extern c inline "((size_t)8)"] public axiom inprevKeyLen : USize
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom inprev0 : U32
/-- 'n' (110). -/
@[extern c inline "((uint32_t)110)"] public axiom inprev1 : U32
/-- 'p' (112). -/
@[extern c inline "((uint32_t)112)"] public axiom inprev2 : U32
/-- 'u' (117). -/
@[extern c inline "((uint32_t)117)"] public axiom inprev3 : U32
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom inprev4 : U32
/-- 'R' (82). -/
@[extern c inline "((uint32_t)82)"] public axiom inprev5 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom inprev6 : U32
/-- 'v' (118). -/
@[extern c inline "((uint32_t)118)"] public axiom inprev7 : U32

/-- Key length for `packages` (8). Manifest packages table/array field. -/
@[extern c inline "((size_t)8)"] public axiom pkgsKeyLen : USize
/-- 'p' (112). -/
@[extern c inline "((uint32_t)112)"] public axiom pkgs0 : U32
/-- 'a' (97). -/
@[extern c inline "((uint32_t)97)"] public axiom pkgs1 : U32
/-- 'c' (99). -/
@[extern c inline "((uint32_t)99)"] public axiom pkgs2 : U32
/-- 'k' (107). -/
@[extern c inline "((uint32_t)107)"] public axiom pkgs3 : U32
/-- 'a' (97). -/
@[extern c inline "((uint32_t)97)"] public axiom pkgs4 : U32
/-- 'g' (103). -/
@[extern c inline "((uint32_t)103)"] public axiom pkgs5 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom pkgs6 : U32
/-- 's' (115). -/
@[extern c inline "((uint32_t)115)"] public axiom pkgs7 : U32


/-- Key length for `inherited` (9). Manifest PackageEntry inherited-flag field. -/
@[extern c inline "((size_t)9)"] public axiom inhKeyLen : USize
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom inh0 : U32
/-- 'n' (110). -/
@[extern c inline "((uint32_t)110)"] public axiom inh1 : U32
/-- 'h' (104). -/
@[extern c inline "((uint32_t)104)"] public axiom inh2 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom inh3 : U32
/-- 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom inh4 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom inh5 : U32
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom inh6 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom inh7 : U32
/-- 'd' (100). -/
@[extern c inline "((uint32_t)100)"] public axiom inh8 : U32

/-- Key length for `gitUrl` (6). Reservoir RegistrySrc git URL field. -/
@[extern c inline "((size_t)6)"] public axiom gurlKeyLen : USize
/-- 'g' (103). -/
@[extern c inline "((uint32_t)103)"] public axiom gurl0 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom gurl1 : U32
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom gurl2 : U32
/-- 'U' (85). -/
@[extern c inline "((uint32_t)85)"] public axiom gurl3 : U32
/-- 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom gurl4 : U32
/-- 'l' (108). -/
@[extern c inline "((uint32_t)108)"] public axiom gurl5 : U32

/-- Key length for `fullName` (8). Reservoir RegistryPkg full name field. -/
@[extern c inline "((size_t)8)"] public axiom fnamKeyLen : USize
/-- 'f' (102). -/
@[extern c inline "((uint32_t)102)"] public axiom fnam0 : U32
/-- 'u' (117). -/
@[extern c inline "((uint32_t)117)"] public axiom fnam1 : U32
/-- 'l' (108). -/
@[extern c inline "((uint32_t)108)"] public axiom fnam2 : U32
/-- 'l' (108). -/
@[extern c inline "((uint32_t)108)"] public axiom fnam3 : U32
/-- 'N' (78). -/
@[extern c inline "((uint32_t)78)"] public axiom fnam4 : U32
/-- 'a' (97). -/
@[extern c inline "((uint32_t)97)"] public axiom fnam5 : U32
/-- 'm' (109). -/
@[extern c inline "((uint32_t)109)"] public axiom fnam6 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom fnam7 : U32

/-- Key length for `defaultBranch` (13). Reservoir RegistrySrc default branch field. -/
@[extern c inline "((size_t)13)"] public axiom dbrKeyLen : USize
/-- 'd' (100). -/
@[extern c inline "((uint32_t)100)"] public axiom dbr0 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom dbr1 : U32
/-- 'f' (102). -/
@[extern c inline "((uint32_t)102)"] public axiom dbr2 : U32
/-- 'a' (97). -/
@[extern c inline "((uint32_t)97)"] public axiom dbr3 : U32
/-- 'u' (117). -/
@[extern c inline "((uint32_t)117)"] public axiom dbr4 : U32
/-- 'l' (108). -/
@[extern c inline "((uint32_t)108)"] public axiom dbr5 : U32
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom dbr6 : U32
/-- 'B' (66). -/
@[extern c inline "((uint32_t)66)"] public axiom dbr7 : U32
/-- 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom dbr8 : U32
/-- 'a' (97). -/
@[extern c inline "((uint32_t)97)"] public axiom dbr9 : U32
/-- 'n' (110). -/
@[extern c inline "((uint32_t)110)"] public axiom dbr10 : U32
/-- 'c' (99). -/
@[extern c inline "((uint32_t)99)"] public axiom dbr11 : U32
/-- 'h' (104). -/
@[extern c inline "((uint32_t)104)"] public axiom dbr12 : U32

/-- Key length for `repoUrl` (7). Reservoir RegistrySrc repository URL field. -/
@[extern c inline "((size_t)7)"] public axiom rurlKeyLen : USize
/-- 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom rurl0 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom rurl1 : U32
/-- 'p' (112). -/
@[extern c inline "((uint32_t)112)"] public axiom rurl2 : U32
/-- 'o' (111). -/
@[extern c inline "((uint32_t)111)"] public axiom rurl3 : U32
/-- 'U' (85). -/
@[extern c inline "((uint32_t)85)"] public axiom rurl4 : U32
/-- 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom rurl5 : U32
/-- 'l' (108). -/
@[extern c inline "((uint32_t)108)"] public axiom rurl6 : U32

/-- Key length for `sources` (7). Reservoir RegistryPkg sources field. -/
@[extern c inline "((size_t)7)"] public axiom srcsKeyLen : USize
/-- 's' (115). -/
@[extern c inline "((uint32_t)115)"] public axiom srcs0 : U32
/-- 'o' (111). -/
@[extern c inline "((uint32_t)111)"] public axiom srcs1 : U32
/-- 'u' (117). -/
@[extern c inline "((uint32_t)117)"] public axiom srcs2 : U32
/-- 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom srcs3 : U32
/-- 'c' (99). -/
@[extern c inline "((uint32_t)99)"] public axiom srcs4 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom srcs5 : U32
/-- 's' (115). -/
@[extern c inline "((uint32_t)115)"] public axiom srcs6 : U32




/-- Key length for `revision` (8). Reservoir RegistryVer revision field. -/
@[extern c inline "((size_t)8)"] public axiom revkKeyLen : USize
/-- 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom revk0 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom revk1 : U32
/-- 'v' (118). -/
@[extern c inline "((uint32_t)118)"] public axiom revk2 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom revk3 : U32
/-- 's' (115). -/
@[extern c inline "((uint32_t)115)"] public axiom revk4 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom revk5 : U32
/-- 'o' (111). -/
@[extern c inline "((uint32_t)111)"] public axiom revk6 : U32
/-- 'n' (110). -/
@[extern c inline "((uint32_t)110)"] public axiom revk7 : U32

/-- Key length for `host` (4). Reservoir RegistrySrc host field. -/
@[extern c inline "((size_t)4)"] public axiom hostkKeyLen : USize
/-- 'h' (104). -/
@[extern c inline "((uint32_t)104)"] public axiom hostk0 : U32
/-- 'o' (111). -/
@[extern c inline "((uint32_t)111)"] public axiom hostk1 : U32
/-- 's' (115). -/
@[extern c inline "((uint32_t)115)"] public axiom hostk2 : U32
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom hostk3 : U32

/-- Key length for `hash` (4). Lake Module unpack JSON / artifact `"hash"` field. -/
@[extern c inline "((size_t)4)"] public axiom hashkKeyLen : USize
/-- 'h' (104). -/
@[extern c inline "((uint32_t)104)"] public axiom hashk0 : U32
/-- 'a' (97). -/
@[extern c inline "((uint32_t)97)"] public axiom hashk1 : U32
/-- 's' (115). -/
@[extern c inline "((uint32_t)115)"] public axiom hashk2 : U32
/-- 'h' (104). -/
@[extern c inline "((uint32_t)104)"] public axiom hashk3 : U32

/-- Key length for `depHash` (7). Lake Build JSON trace `"depHash"` field. -/
@[extern c inline "((size_t)7)"] public axiom dhashkKeyLen : USize
/-- 'd' (100). -/
@[extern c inline "((uint32_t)100)"] public axiom dhashk0 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom dhashk1 : U32
/-- 'p' (112). -/
@[extern c inline "((uint32_t)112)"] public axiom dhashk2 : U32
/-- 'H' (72). -/
@[extern c inline "((uint32_t)72)"] public axiom dhashk3 : U32
/-- 'a' (97). -/
@[extern c inline "((uint32_t)97)"] public axiom dhashk4 : U32
/-- 's' (115). -/
@[extern c inline "((uint32_t)115)"] public axiom dhashk5 : U32
/-- 'h' (104). -/
@[extern c inline "((uint32_t)104)"] public axiom dhashk6 : U32

/-- Key length for `file` (4). Lake Module unpackLtar JSON `"file"` field. -/
@[extern c inline "((size_t)4)"] public axiom filekKeyLen : USize
/-- 'f' (102). -/
@[extern c inline "((uint32_t)102)"] public axiom filek0 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom filek1 : U32
/-- 'l' (108). -/
@[extern c inline "((uint32_t)108)"] public axiom filek2 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom filek3 : U32

/-- Key length for `inputs` (6). Lake Build JSON trace `"inputs"` field. -/
@[extern c inline "((size_t)6)"] public axiom inpskKeyLen : USize
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom inpsk0 : U32
/-- 'n' (110). -/
@[extern c inline "((uint32_t)110)"] public axiom inpsk1 : U32
/-- 'p' (112). -/
@[extern c inline "((uint32_t)112)"] public axiom inpsk2 : U32
/-- 'u' (117). -/
@[extern c inline "((uint32_t)117)"] public axiom inpsk3 : U32
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom inpsk4 : U32
/-- 's' (115). -/
@[extern c inline "((uint32_t)115)"] public axiom inpsk5 : U32

/-- Key length for `outputs` (7). Lake Build JSON trace `"outputs"` field. -/
@[extern c inline "((size_t)7)"] public axiom outpskKeyLen : USize
/-- 'o' (111). -/
@[extern c inline "((uint32_t)111)"] public axiom outpsk0 : U32
/-- 'u' (117). -/
@[extern c inline "((uint32_t)117)"] public axiom outpsk1 : U32
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom outpsk2 : U32
/-- 'p' (112). -/
@[extern c inline "((uint32_t)112)"] public axiom outpsk3 : U32
/-- 'u' (117). -/
@[extern c inline "((uint32_t)117)"] public axiom outpsk4 : U32
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom outpsk5 : U32
/-- 's' (115). -/
@[extern c inline "((uint32_t)115)"] public axiom outpsk6 : U32

/-- Key length for `status` (6). Lake Reservoir err JSON `"status"` field. -/
@[extern c inline "((size_t)6)"] public axiom statkKeyLen : USize
/-- 's' (115). -/
@[extern c inline "((uint32_t)115)"] public axiom statk0 : U32
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom statk1 : U32
/-- 'a' (97). -/
@[extern c inline "((uint32_t)97)"] public axiom statk2 : U32
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom statk3 : U32
/-- 'u' (117). -/
@[extern c inline "((uint32_t)117)"] public axiom statk4 : U32
/-- 's' (115). -/
@[extern c inline "((uint32_t)115)"] public axiom statk5 : U32

/-- Key length for `log` (3). Lake Build JSON trace `"log"` field. -/
@[extern c inline "((size_t)3)"] public axiom logkKeyLen : USize
/-- 'l' (108). -/
@[extern c inline "((uint32_t)108)"] public axiom logk0 : U32
/-- 'o' (111). -/
@[extern c inline "((uint32_t)111)"] public axiom logk1 : U32
/-- 'g' (103). -/
@[extern c inline "((uint32_t)103)"] public axiom logk2 : U32

/-- Key length for `synthetic` (9). Lake Build JSON trace `"synthetic"` field. -/
@[extern c inline "((size_t)9)"] public axiom synthkKeyLen : USize
/-- 's' (115). -/
@[extern c inline "((uint32_t)115)"] public axiom synthk0 : U32
/-- 'y' (121). -/
@[extern c inline "((uint32_t)121)"] public axiom synthk1 : U32
/-- 'n' (110). -/
@[extern c inline "((uint32_t)110)"] public axiom synthk2 : U32
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom synthk3 : U32
/-- 'h' (104). -/
@[extern c inline "((uint32_t)104)"] public axiom synthk4 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom synthk5 : U32
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom synthk6 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom synthk7 : U32
/-- 'c' (99). -/
@[extern c inline "((uint32_t)99)"] public axiom synthk8 : U32

/-- Key length for `message` (7). Lake Reservoir err JSON `"message"` field. -/
@[extern c inline "((size_t)7)"] public axiom msgkKeyLen : USize
/-- 'm' (109). -/
@[extern c inline "((uint32_t)109)"] public axiom msgk0 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom msgk1 : U32
/-- 's' (115). -/
@[extern c inline "((uint32_t)115)"] public axiom msgk2 : U32
/-- 's' (115). -/
@[extern c inline "((uint32_t)115)"] public axiom msgk3 : U32
/-- 'a' (97). -/
@[extern c inline "((uint32_t)97)"] public axiom msgk4 : U32
/-- 'g' (103). -/
@[extern c inline "((uint32_t)103)"] public axiom msgk5 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom msgk6 : U32

/-- Key length for `error` (5). Lake Reservoir response `"error"` field. -/
@[extern c inline "((size_t)5)"] public axiom errkKeyLen : USize
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom errk0 : U32
/-- 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom errk1 : U32
/-- 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom errk2 : U32
/-- 'o' (111). -/
@[extern c inline "((uint32_t)111)"] public axiom errk3 : U32
/-- 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom errk4 : U32

/-- Key length for `http_code` (9). Lake curl JSON `"http_code"` field. -/
@[extern c inline "((size_t)9)"] public axiom httpkKeyLen : USize
/-- 'h' (104). -/
@[extern c inline "((uint32_t)104)"] public axiom httpk0 : U32
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom httpk1 : U32
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom httpk2 : U32
/-- 'p' (112). -/
@[extern c inline "((uint32_t)112)"] public axiom httpk3 : U32
/-- '_' (95). -/
@[extern c inline "((uint32_t)95)"] public axiom httpk4 : U32
/-- 'c' (99). -/
@[extern c inline "((uint32_t)99)"] public axiom httpk5 : U32
/-- 'o' (111). -/
@[extern c inline "((uint32_t)111)"] public axiom httpk6 : U32
/-- 'd' (100). -/
@[extern c inline "((uint32_t)100)"] public axiom httpk7 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom httpk8 : U32

/-- Key length for `response_code` (13). Lake curl JSON `"response_code"` field. -/
@[extern c inline "((size_t)13)"] public axiom respckKeyLen : USize
/-- 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom respck0 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom respck1 : U32
/-- 's' (115). -/
@[extern c inline "((uint32_t)115)"] public axiom respck2 : U32
/-- 'p' (112). -/
@[extern c inline "((uint32_t)112)"] public axiom respck3 : U32
/-- 'o' (111). -/
@[extern c inline "((uint32_t)111)"] public axiom respck4 : U32
/-- 'n' (110). -/
@[extern c inline "((uint32_t)110)"] public axiom respck5 : U32
/-- 's' (115). -/
@[extern c inline "((uint32_t)115)"] public axiom respck6 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom respck7 : U32
/-- '_' (95). -/
@[extern c inline "((uint32_t)95)"] public axiom respck8 : U32
/-- 'c' (99). -/
@[extern c inline "((uint32_t)99)"] public axiom respck9 : U32
/-- 'o' (111). -/
@[extern c inline "((uint32_t)111)"] public axiom respck10 : U32
/-- 'd' (100). -/
@[extern c inline "((uint32_t)100)"] public axiom respck11 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom respck12 : U32

/-- Key length for `errormsg` (8). Lake curl JSON `"errormsg"` field. -/
@[extern c inline "((size_t)8)"] public axiom emsgkKeyLen : USize
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom emsgk0 : U32
/-- 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom emsgk1 : U32
/-- 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom emsgk2 : U32
/-- 'o' (111). -/
@[extern c inline "((uint32_t)111)"] public axiom emsgk3 : U32
/-- 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom emsgk4 : U32
/-- 'm' (109). -/
@[extern c inline "((uint32_t)109)"] public axiom emsgk5 : U32
/-- 's' (115). -/
@[extern c inline "((uint32_t)115)"] public axiom emsgk6 : U32
/-- 'g' (103). -/
@[extern c inline "((uint32_t)103)"] public axiom emsgk7 : U32

/-- Key length for `content_type` (12). Lake curl JSON `"content_type"` field. -/
@[extern c inline "((size_t)12)"] public axiom ctypekKeyLen : USize
/-- 'c' (99). -/
@[extern c inline "((uint32_t)99)"] public axiom ctypek0 : U32
/-- 'o' (111). -/
@[extern c inline "((uint32_t)111)"] public axiom ctypek1 : U32
/-- 'n' (110). -/
@[extern c inline "((uint32_t)110)"] public axiom ctypek2 : U32
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom ctypek3 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom ctypek4 : U32
/-- 'n' (110). -/
@[extern c inline "((uint32_t)110)"] public axiom ctypek5 : U32
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom ctypek6 : U32
/-- '_' (95). -/
@[extern c inline "((uint32_t)95)"] public axiom ctypek7 : U32
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom ctypek8 : U32
/-- 'y' (121). -/
@[extern c inline "((uint32_t)121)"] public axiom ctypek9 : U32
/-- 'p' (112). -/
@[extern c inline "((uint32_t)112)"] public axiom ctypek10 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom ctypek11 : U32

/-- Key length for `urlnum` (6). Lake curl JSON `"urlnum"` field. -/
@[extern c inline "((size_t)6)"] public axiom urlnumkKeyLen : USize
/-- 'u' (117). -/
@[extern c inline "((uint32_t)117)"] public axiom urlnumk0 : U32
/-- 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom urlnumk1 : U32
/-- 'l' (108). -/
@[extern c inline "((uint32_t)108)"] public axiom urlnumk2 : U32
/-- 'n' (110). -/
@[extern c inline "((uint32_t)110)"] public axiom urlnumk3 : U32
/-- 'u' (117). -/
@[extern c inline "((uint32_t)117)"] public axiom urlnumk4 : U32
/-- 'm' (109). -/
@[extern c inline "((uint32_t)109)"] public axiom urlnumk5 : U32

/-- Key length for `size_download` (13). Lake curl JSON `"size_download"` field. -/
@[extern c inline "((size_t)13)"] public axiom szdlkKeyLen : USize
/-- 's' (115). -/
@[extern c inline "((uint32_t)115)"] public axiom szdlk0 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom szdlk1 : U32
/-- 'z' (122). -/
@[extern c inline "((uint32_t)122)"] public axiom szdlk2 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom szdlk3 : U32
/-- '_' (95). -/
@[extern c inline "((uint32_t)95)"] public axiom szdlk4 : U32
/-- 'd' (100). -/
@[extern c inline "((uint32_t)100)"] public axiom szdlk5 : U32
/-- 'o' (111). -/
@[extern c inline "((uint32_t)111)"] public axiom szdlk6 : U32
/-- 'w' (119). -/
@[extern c inline "((uint32_t)119)"] public axiom szdlk7 : U32
/-- 'n' (110). -/
@[extern c inline "((uint32_t)110)"] public axiom szdlk8 : U32
/-- 'l' (108). -/
@[extern c inline "((uint32_t)108)"] public axiom szdlk9 : U32
/-- 'o' (111). -/
@[extern c inline "((uint32_t)111)"] public axiom szdlk10 : U32
/-- 'a' (97). -/
@[extern c inline "((uint32_t)97)"] public axiom szdlk11 : U32
/-- 'd' (100). -/
@[extern c inline "((uint32_t)100)"] public axiom szdlk12 : U32

/-- Key length for `rs` (2). Lake ModuleOutputDescrs JSON `"rs"` (irSig). -/
@[extern c inline "((size_t)2)"] public axiom rskKeyLen : USize
/-- 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom rsk0 : U32
/-- 's' (115). -/
@[extern c inline "((uint32_t)115)"] public axiom rsk1 : U32

/-- Key length for `o` (1). Lake ModuleOutputDescrs JSON `"o"` (olean hashes). -/
@[extern c inline "((size_t)1)"] public axiom okeyKeyLen : USize
/-- 'o' (111). -/
@[extern c inline "((uint32_t)111)"] public axiom okey0 : U32

/-- Key length for `i` (1). Lake ModuleOutputDescrs JSON `"i"` (ilean). -/
@[extern c inline "((size_t)1)"] public axiom ikeyKeyLen : USize
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom ikey0 : U32

/-- Key length for `m` (1). Lake ModuleOutputDescrs JSON `"m"` (isModule). -/
@[extern c inline "((size_t)1)"] public axiom mkeyKeyLen : USize
/-- 'm' (109). -/
@[extern c inline "((uint32_t)109)"] public axiom mkey0 : U32

/-- Key length for `c` (1). Lake ModuleOutputDescrs JSON `"c"` (c artifact). -/
@[extern c inline "((size_t)1)"] public axiom ckeyKeyLen : USize
/-- 'c' (99). -/
@[extern c inline "((uint32_t)99)"] public axiom ckey0 : U32

/-- Key length for `b` (1). Lake ModuleOutputDescrs JSON `"b"` (bc). -/
@[extern c inline "((size_t)1)"] public axiom bkeyKeyLen : USize
/-- 'b' (98). -/
@[extern c inline "((uint32_t)98)"] public axiom bkey0 : U32

/-- Key length for `l` (1). Lake ModuleOutputDescrs JSON `"l"` (ltar). -/
@[extern c inline "((size_t)1)"] public axiom lkeyKeyLen : USize
/-- 'l' (108). -/
@[extern c inline "((uint32_t)108)"] public axiom lkey0 : U32

/-- Key length for `r` (1). Lake ModuleOutputDescrs JSON `"r"` (ir). Distinct from `rs`. -/
@[extern c inline "((size_t)1)"] public axiom rkeyKeyLen : USize
/-- 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom rkey0 : U32

/-- Key length for `require` (7). Lake package-table deps (`Load/Toml.lean`). -/
@[extern c inline "((size_t)7)"] public axiom reqkKeyLen : USize
/-- 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom reqk0 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom reqk1 : U32
/-- 'q' (113). -/
@[extern c inline "((uint32_t)113)"] public axiom reqk2 : U32
/-- 'u' (117). -/
@[extern c inline "((uint32_t)117)"] public axiom reqk3 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom reqk4 : U32
/-- 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom reqk5 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom reqk6 : U32

/-- Key length for `value` (5). Real Lake TOML object key (`Load/Toml.lean` LeanOption table `value`). -/
@[extern c inline "((size_t)5)"] public axiom valkKeyLen : USize
/-- 'v' (118). -/
@[extern c inline "((uint32_t)118)"] public axiom valk0 : U32
/-- 'a' (97). -/
@[extern c inline "((uint32_t)97)"] public axiom valk1 : U32
/-- 'l' (108). -/
@[extern c inline "((uint32_t)108)"] public axiom valk2 : U32
/-- 'u' (117). -/
@[extern c inline "((uint32_t)117)"] public axiom valk3 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom valk4 : U32

/-- Key length for `major` (5). Residual literal key-text inspired by Version parseVerNat label `"major"` (not a lakefile object key). -/
@[extern c inline "((size_t)5)"] public axiom majorkKeyLen : USize
/-- 'm' (109). -/
@[extern c inline "((uint32_t)109)"] public axiom majork0 : U32
/-- 'a' (97). -/
@[extern c inline "((uint32_t)97)"] public axiom majork1 : U32
/-- 'j' (106). -/
@[extern c inline "((uint32_t)106)"] public axiom majork2 : U32
/-- 'o' (111). -/
@[extern c inline "((uint32_t)111)"] public axiom majork3 : U32
/-- 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom majork4 : U32

/-- Key length for `minor` (5). Residual literal key-text inspired by Version parseVerNat label `"minor"` (not a lakefile object key). -/
@[extern c inline "((size_t)5)"] public axiom minorkKeyLen : USize
/-- 'm' (109). -/
@[extern c inline "((uint32_t)109)"] public axiom minork0 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom minork1 : U32
/-- 'n' (110). -/
@[extern c inline "((uint32_t)110)"] public axiom minork2 : U32
/-- 'o' (111). -/
@[extern c inline "((uint32_t)111)"] public axiom minork3 : U32
/-- 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom minork4 : U32

/-- Key length for `art` (3). Lake cache/artifact extension identity (`Config/Artifact.lean` / `Config/Cache.lean` default `ext := "art"`). -/
@[extern c inline "((size_t)3)"] public axiom artkKeyLen : USize
/-- 'a' (97). -/
@[extern c inline "((uint32_t)97)"] public axiom artk0 : U32
/-- 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom artk1 : U32
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom artk2 : U32

/-- Key length for `olean` (5). Lake cache/compute facet ext (`Build/Module.lean` `"olean"`). -/
@[extern c inline "((size_t)5)"] public axiom oleankKeyLen : USize
/-- 'o' (111). -/
@[extern c inline "((uint32_t)111)"] public axiom oleank0 : U32
/-- 'l' (108). -/
@[extern c inline "((uint32_t)108)"] public axiom oleank1 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom oleank2 : U32
/-- 'a' (97). -/
@[extern c inline "((uint32_t)97)"] public axiom oleank3 : U32
/-- 'n' (110). -/
@[extern c inline "((uint32_t)110)"] public axiom oleank4 : U32

/-- Key length for `ltar` (4). Lake cache/compute facet ext (`Build/Module.lean` `"ltar"`). -/
@[extern c inline "((size_t)4)"] public axiom ltarkKeyLen : USize
/-- 'l' (108). -/
@[extern c inline "((uint32_t)108)"] public axiom ltark0 : U32
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom ltark1 : U32
/-- 'a' (97). -/
@[extern c inline "((uint32_t)97)"] public axiom ltark2 : U32
/-- 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom ltark3 : U32

/-- Key length for `ir` (2). Lake cache/compute facet ext / defaultIrDir (`Build/Module.lean` `"ir"`; `Config/Defaults.lean` `defaultIrDir := "ir"`). Distinct from more51 `hasI` (single-letter ModuleArtifacts `i`). -/
@[extern c inline "((size_t)2)"] public axiom irkKeyLen : USize
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom irk0 : U32
/-- 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom irk1 : U32

/-- Key length for `traceArgs` (9). Lake build-trace caption / identity (`Build/Common.lean` `addPureTrace traceArgs "traceArgs"`). -/
@[extern c inline "((size_t)9)"] public axiom trargskKeyLen : USize
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom trargsk0 : U32
/-- 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom trargsk1 : U32
/-- 'a' (97). -/
@[extern c inline "((uint32_t)97)"] public axiom trargsk2 : U32
/-- 'c' (99). -/
@[extern c inline "((uint32_t)99)"] public axiom trargsk3 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom trargsk4 : U32
/-- 'A' (65). -/
@[extern c inline "((uint32_t)65)"] public axiom trargsk5 : U32
/-- 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom trargsk6 : U32
/-- 'g' (103). -/
@[extern c inline "((uint32_t)103)"] public axiom trargsk7 : U32
/-- 's' (115). -/
@[extern c inline "((uint32_t)115)"] public axiom trargsk8 : U32

/-- Key length for `debugAssertions` (15). Lake Lean option NameMap key (`Config/LeanConfig.lean` BuildType.leanOptions `` `debugAssertions ``). -/
@[extern c inline "((size_t)15)"] public axiom dassertkKeyLen : USize
/-- 'd' (100). -/
@[extern c inline "((uint32_t)100)"] public axiom dassertk0 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom dassertk1 : U32
/-- 'b' (98). -/
@[extern c inline "((uint32_t)98)"] public axiom dassertk2 : U32
/-- 'u' (117). -/
@[extern c inline "((uint32_t)117)"] public axiom dassertk3 : U32
/-- 'g' (103). -/
@[extern c inline "((uint32_t)103)"] public axiom dassertk4 : U32
/-- 'A' (65). -/
@[extern c inline "((uint32_t)65)"] public axiom dassertk5 : U32
/-- 's' (115). -/
@[extern c inline "((uint32_t)115)"] public axiom dassertk6 : U32
/-- 's' (115). -/
@[extern c inline "((uint32_t)115)"] public axiom dassertk7 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom dassertk8 : U32
/-- 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom dassertk9 : U32
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom dassertk10 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom dassertk11 : U32
/-- 'o' (111). -/
@[extern c inline "((uint32_t)111)"] public axiom dassertk12 : U32
/-- 'n' (110). -/
@[extern c inline "((uint32_t)110)"] public axiom dassertk13 : U32
/-- 's' (115). -/
@[extern c inline "((uint32_t)115)"] public axiom dassertk14 : U32

/-- Key length for `verLike` (7). Lake version-tag preset name (`Config/Pattern.lean` `versionTagPresets` insert `` `verLike `` / `StrPat.verLike`). -/
@[extern c inline "((size_t)7)"] public axiom vlkKeyLen : USize
/-- 'v' (118). -/
@[extern c inline "((uint32_t)118)"] public axiom vlk0 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom vlk1 : U32
/-- 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom vlk2 : U32
/-- 'L' (76). -/
@[extern c inline "((uint32_t)76)"] public axiom vlk3 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom vlk4 : U32
/-- 'k' (107). -/
@[extern c inline "((uint32_t)107)"] public axiom vlk5 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom vlk6 : U32

/-- Key length for `mappings` (8). Lake CLI greppable token (`CLI/Main.lean` `takeArg "mappings"`). -/
@[extern c inline "((size_t)8)"] public axiom mapkKeyLen : USize
/-- 'm' (109). -/
@[extern c inline "((uint32_t)109)"] public axiom mapk0 : U32
/-- 'a' (97). -/
@[extern c inline "((uint32_t)97)"] public axiom mapk1 : U32
/-- 'p' (112). -/
@[extern c inline "((uint32_t)112)"] public axiom mapk2 : U32
/-- 'p' (112). -/
@[extern c inline "((uint32_t)112)"] public axiom mapk3 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom mapk4 : U32
/-- 'n' (110). -/
@[extern c inline "((uint32_t)110)"] public axiom mapk5 : U32
/-- 'g' (103). -/
@[extern c inline "((uint32_t)103)"] public axiom mapk6 : U32
/-- 's' (115). -/
@[extern c inline "((uint32_t)115)"] public axiom mapk7 : U32

/-- Key length for `default` (7). Lake version-tag preset name (`Config/Pattern.lean` `defaultVersionTags` `` `default ``). Exact length-7 — must miss longer `defaultTargets`/`defaultFacets`/`defaultBranch`/`defaultService`. -/
@[extern c inline "((size_t)7)"] public axiom defkKeyLen : USize
/-- 'd' (100). -/
@[extern c inline "((uint32_t)100)"] public axiom defk0 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom defk1 : U32
/-- 'f' (102). -/
@[extern c inline "((uint32_t)102)"] public axiom defk2 : U32
/-- 'a' (97). -/
@[extern c inline "((uint32_t)97)"] public axiom defk3 : U32
/-- 'u' (117). -/
@[extern c inline "((uint32_t)117)"] public axiom defk4 : U32
/-- 'l' (108). -/
@[extern c inline "((uint32_t)108)"] public axiom defk5 : U32
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom defk6 : U32

/-- Key length for `objs` (4). Lake job caption (`Build/Common.lean` / `Build/Library.lean` `Job.collectArray … "objs"`). -/
@[extern c inline "((size_t)4)"] public axiom objkKeyLen : USize
/-- 'o' (111). -/
@[extern c inline "((uint32_t)111)"] public axiom objk0 : U32
/-- 'b' (98). -/
@[extern c inline "((uint32_t)98)"] public axiom objk1 : U32
/-- 'j' (106). -/
@[extern c inline "((uint32_t)106)"] public axiom objk2 : U32
/-- 's' (115). -/
@[extern c inline "((uint32_t)115)"] public axiom objk3 : U32

/-- Key length for `cache` (5). Lake CLI command (`CLI/Main.lean` `| "cache" => lake.cache`; Help.lean; lakeDir path `"cache"`). -/
@[extern c inline "((size_t)5)"] public axiom cchkKeyLen : USize
/-- 'c' (99). -/
@[extern c inline "((uint32_t)99)"] public axiom cchk0 : U32
/-- 'a' (97). -/
@[extern c inline "((uint32_t)97)"] public axiom cchk1 : U32
/-- 'c' (99). -/
@[extern c inline "((uint32_t)99)"] public axiom cchk2 : U32
/-- 'h' (104). -/
@[extern c inline "((uint32_t)104)"] public axiom cchk3 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom cchk4 : U32

/-- Key length for `script` (6). Lake CLI command (`CLI/Main.lean` `| "script" => lake.script`) + DSL attribute `` `script `` (`DSL/AttributesCore.lean`). -/
@[extern c inline "((size_t)6)"] public axiom scrkKeyLen : USize
/-- 's' (115). -/
@[extern c inline "((uint32_t)115)"] public axiom scrk0 : U32
/-- 'c' (99). -/
@[extern c inline "((uint32_t)99)"] public axiom scrk1 : U32
/-- 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom scrk2 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom scrk3 : U32
/-- 'p' (112). -/
@[extern c inline "((uint32_t)112)"] public axiom scrk4 : U32
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom scrk5 : U32

/-- Key length for `ext` (3). Lake artifact/cache field (`Config/Artifact.lean` / `Config/Cache.lean` `ext := "art"` / `self.ext`). -/
@[extern c inline "((size_t)3)"] public axiom extkKeyLen : USize
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom extk0 : U32
/-- 'x' (120). -/
@[extern c inline "((uint32_t)120)"] public axiom extk1 : U32
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom extk2 : U32

/-- Key length for `lean` (4). Lake CLI / configLang token (`CLI/Main.lean` `| "lean" => lake.lean`; `Load/Package.lean` `| "lean" =>`; Help.lean). -/
@[extern c inline "((size_t)4)"] public axiom leankKeyLen : USize
/-- 'l' (108). -/
@[extern c inline "((uint32_t)108)"] public axiom leank0 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom leank1 : U32
/-- 'a' (97). -/
@[extern c inline "((uint32_t)97)"] public axiom leank2 : U32
/-- 'n' (110). -/
@[extern c inline "((uint32_t)110)"] public axiom leank3 : U32

/-- Key length for `toml` (4). Lake configLang token (`Load/Package.lean` `| "toml" =>`; `Toml/Grammar.lean` / Help config languages). -/
@[extern c inline "((size_t)4)"] public axiom tomlkKeyLen : USize
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom tomlk0 : U32
/-- 'o' (111). -/
@[extern c inline "((uint32_t)111)"] public axiom tomlk1 : U32
/-- 'm' (109). -/
@[extern c inline "((uint32_t)109)"] public axiom tomlk2 : U32
/-- 'l' (108). -/
@[extern c inline "((uint32_t)108)"] public axiom tomlk3 : U32

/-- Key length for `env` (3). Lake CLI token (`CLI/Main.lean` `| "env" => lake.env`; Help.lean `| "env"`). -/
@[extern c inline "((size_t)3)"] public axiom envkKeyLen : USize
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom envk0 : U32
/-- 'n' (110). -/
@[extern c inline "((uint32_t)110)"] public axiom envk1 : U32
/-- 'v' (118). -/
@[extern c inline "((uint32_t)118)"] public axiom envk2 : U32

/-- Key length for `help` (4). Lake CLI token (`CLI/Main.lean` `| "help" => lake.help`; cache/script help subcommands). -/
@[extern c inline "((size_t)4)"] public axiom helpkKeyLen : USize
/-- 'h' (104). -/
@[extern c inline "((uint32_t)104)"] public axiom helpk0 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom helpk1 : U32
/-- 'l' (108). -/
@[extern c inline "((uint32_t)108)"] public axiom helpk2 : U32
/-- 'p' (112). -/
@[extern c inline "((uint32_t)112)"] public axiom helpk3 : U32

/-- Key length for `cc` (2). Lake install/linker default (`Config/InstallPath.lean` `cc : FilePath := "cc"`; Help LEAN_CC; `Build/Actions.lean` linker `"cc"`). -/
@[extern c inline "((size_t)2)"] public axiom cckKeyLen : USize
/-- 'c' (99). -/
@[extern c inline "((uint32_t)99)"] public axiom cck0 : U32
/-- 'c' (99). -/
@[extern c inline "((uint32_t)99)"] public axiom cck1 : U32

/-- Key length for `info` (4). Lake log-level token (`Util/Log.lean` `| "info" | "information" => some .info`; `.info => "info"`). -/
@[extern c inline "((size_t)4)"] public axiom infokKeyLen : USize
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom infok0 : U32
/-- 'n' (110). -/
@[extern c inline "((uint32_t)110)"] public axiom infok1 : U32
/-- 'f' (102). -/
@[extern c inline "((uint32_t)102)"] public axiom infok2 : U32
/-- 'o' (111). -/
@[extern c inline "((uint32_t)111)"] public axiom infok3 : U32

/-- Key length for `remote` (6). Lake git remote subcommand (`Util/Git.lean` `#["remote", "get-url", remote]` / add / set-url). Exact len-6 — distinct from more24 `remoteUrl` (9). -/
@[extern c inline "((size_t)6)"] public axiom remotekKeyLen : USize
/-- 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom remotek0 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom remotek1 : U32
/-- 'm' (109). -/
@[extern c inline "((uint32_t)109)"] public axiom remotek2 : U32
/-- 'o' (111). -/
@[extern c inline "((uint32_t)111)"] public axiom remotek3 : U32
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom remotek4 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom remotek5 : U32

/-- Key length for `facets` (6). Lake facet identity (`CLI/Translate/Toml.lean` `encodeFacets`; `Config/LeanLibConfig.lean` `defaultFacets`; `Config/Workspace.lean` `facetConfigs`). Exact len-6 — distinct from more23 `defaultFacets` (13) / more27 `nativeFacets` (12). -/
@[extern c inline "((size_t)6)"] public axiom facetskKeyLen : USize
/-- 'f' (102). -/
@[extern c inline "((uint32_t)102)"] public axiom facetsk0 : U32
/-- 'a' (97). -/
@[extern c inline "((uint32_t)97)"] public axiom facetsk1 : U32
/-- 'c' (99). -/
@[extern c inline "((uint32_t)99)"] public axiom facetsk2 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom facetsk3 : U32
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom facetsk4 : U32
/-- 's' (115). -/
@[extern c inline "((uint32_t)115)"] public axiom facetsk5 : U32

/-- Key length for `package` (7). Lake facet-kind token (`CLI/Build.lean` `unknownFacet "package"`). Exact len-7 — distinct from more29 `packages` (8) / more7 `packagesDir` (11). -/
@[extern c inline "((size_t)7)"] public axiom packagekKeyLen : USize
/-- 'p' (112). -/
@[extern c inline "((uint32_t)112)"] public axiom packagek0 : U32
/-- 'a' (97). -/
@[extern c inline "((uint32_t)97)"] public axiom packagek1 : U32
/-- 'c' (99). -/
@[extern c inline "((uint32_t)99)"] public axiom packagek2 : U32
/-- 'k' (107). -/
@[extern c inline "((uint32_t)107)"] public axiom packagek3 : U32
/-- 'a' (97). -/
@[extern c inline "((uint32_t)97)"] public axiom packagek4 : U32
/-- 'g' (103). -/
@[extern c inline "((uint32_t)103)"] public axiom packagek5 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom packagek6 : U32

/-- Key length for `module` (6). Lake facet-kind token (`CLI/Build.lean` `unknownFacet "module"`). Exact len-6 — distinct from more6 `precompileModules` (17) / more16 `requiresModuleSystem` (20). -/
@[extern c inline "((size_t)6)"] public axiom modulekKeyLen : USize
/-- 'm' (109). -/
@[extern c inline "((uint32_t)109)"] public axiom modulek0 : U32
/-- 'o' (111). -/
@[extern c inline "((uint32_t)111)"] public axiom modulek1 : U32
/-- 'd' (100). -/
@[extern c inline "((uint32_t)100)"] public axiom modulek2 : U32
/-- 'u' (117). -/
@[extern c inline "((uint32_t)117)"] public axiom modulek3 : U32
/-- 'l' (108). -/
@[extern c inline "((uint32_t)108)"] public axiom modulek4 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom modulek5 : U32

/-- Key length for `build` (5). Lake CLI command + default build dir (`CLI/Main.lean` `| "build" => lake.build`; Help.lean; `Config/Defaults.lean` `defaultBuildDir` / `"build"`). Exact len-5 — distinct from more8 `buildDir` (8) / more2 `buildType` (9) / more5 `buildArchive` (12). -/
@[extern c inline "((size_t)5)"] public axiom buildkKeyLen : USize
/-- 'b' (98). -/
@[extern c inline "((uint32_t)98)"] public axiom buildk0 : U32
/-- 'u' (117). -/
@[extern c inline "((uint32_t)117)"] public axiom buildk1 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom buildk2 : U32
/-- 'l' (108). -/
@[extern c inline "((uint32_t)108)"] public axiom buildk3 : U32
/-- 'd' (100). -/
@[extern c inline "((uint32_t)100)"] public axiom buildk4 : U32

/-- Key length for `clean` (5). Lake CLI command (`CLI/Main.lean` `| "clean" => lake.clean`; Help.lean `| "clean"` / `helpClean`; also cache subcommand `| "clean" => cache.clean`). Exact len-5. -/
@[extern c inline "((size_t)5)"] public axiom cleankKeyLen : USize
/-- 'c' (99). -/
@[extern c inline "((uint32_t)99)"] public axiom cleank0 : U32
/-- 'l' (108). -/
@[extern c inline "((uint32_t)108)"] public axiom cleank1 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom cleank2 : U32
/-- 'a' (97). -/
@[extern c inline "((uint32_t)97)"] public axiom cleank3 : U32
/-- 'n' (110). -/
@[extern c inline "((uint32_t)110)"] public axiom cleank4 : U32

/-- Key length for `test` (4). Lake CLI command (`CLI/Main.lean` `| "test" => lake.test`; Help.lean `| "test"` / `helpTest`). Exact len-4 — distinct from more3 `testDriver` (10) / more9 `testDriverArgs` (14) / more28 `testRunner` (10). -/
@[extern c inline "((size_t)4)"] public axiom testkKeyLen : USize
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom testk0 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom testk1 : U32
/-- 's' (115). -/
@[extern c inline "((uint32_t)115)"] public axiom testk2 : U32
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom testk3 : U32

/-- Key length for `serve` (5). Lake CLI command (`CLI/Main.lean` `| "serve" => lake.serve`; Help.lean `| "serve"` / `helpServe`). Exact len-5 — distinct from more29 `serverOptions` (13) / more30 `serverArgs` (10). -/
@[extern c inline "((size_t)5)"] public axiom servekKeyLen : USize
/-- 's' (115). -/
@[extern c inline "((uint32_t)115)"] public axiom servek0 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom servek1 : U32
/-- 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom servek2 : U32
/-- 'v' (118). -/
@[extern c inline "((uint32_t)118)"] public axiom servek3 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom servek4 : U32

/-- Key length for `lint` (4). Lake CLI command (`CLI/Main.lean` `| "lint" => lake.lint`; Help.lean `| "lint"` / `helpLint`). Exact len-4 — distinct from more3 `lintDriver` (10) / more10 `lintDriverArgs` (14) / more20 `builtinLint` (11). -/
@[extern c inline "((size_t)4)"] public axiom lintkKeyLen : USize
/-- 'l' (108). -/
@[extern c inline "((uint32_t)108)"] public axiom lintk0 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom lintk1 : U32
/-- 'n' (110). -/
@[extern c inline "((uint32_t)110)"] public axiom lintk2 : U32
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom lintk3 : U32

/-- Key length for `exe` (3). Lake CLI command (`CLI/Main.lean` `| "exe" | "exec" => lake.exe`; Help.lean `| "exe"` / `helpExe`). Exact len-3 — distinct from more26 `exeName` (7). -/
@[extern c inline "((size_t)3)"] public axiom exekKeyLen : USize
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom exek0 : U32
/-- 'x' (120). -/
@[extern c inline "((uint32_t)120)"] public axiom exek1 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom exek2 : U32

/-- Key length for `query` (5). Lake CLI command (`CLI/Main.lean` `| "query" => lake.query`; Help.lean `| "query"` / `helpQuery`). Exact len-5. -/
@[extern c inline "((size_t)5)"] public axiom querykKeyLen : USize
/-- 'q' (113). -/
@[extern c inline "((uint32_t)113)"] public axiom queryk0 : U32
/-- 'u' (117). -/
@[extern c inline "((uint32_t)117)"] public axiom queryk1 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom queryk2 : U32
/-- 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom queryk3 : U32
/-- 'y' (121). -/
@[extern c inline "((uint32_t)121)"] public axiom queryk4 : U32

/-- Key length for `init` (4). Lake CLI command (`CLI/Main.lean` `| "init" => lake.init`; Help.lean `| "init"` / `helpInit`). Exact len-4. -/
@[extern c inline "((size_t)4)"] public axiom initkKeyLen : USize
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom initk0 : U32
/-- 'n' (110). -/
@[extern c inline "((uint32_t)110)"] public axiom initk1 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom initk2 : U32
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom initk3 : U32

/-- Key length for `new` (3). Lake CLI command (`CLI/Main.lean` `| "new" => lake.new`; Help.lean `| "new"` / `helpNew`). Exact len-3. -/
@[extern c inline "((size_t)3)"] public axiom newkKeyLen : USize
/-- 'n' (110). -/
@[extern c inline "((uint32_t)110)"] public axiom newk0 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom newk1 : U32
/-- 'w' (119). -/
@[extern c inline "((uint32_t)119)"] public axiom newk2 : U32

/-- Key length for `update` (6). Lake CLI command (`CLI/Main.lean` `| "update" | "upgrade" => lake.update`; Help.lean `| "update"` / `helpUpdate`). Exact len-6 — bare `update` only (not alias `upgrade`). -/
@[extern c inline "((size_t)6)"] public axiom updatekKeyLen : USize
/-- 'u' (117). -/
@[extern c inline "((uint32_t)117)"] public axiom updatek0 : U32
/-- 'p' (112). -/
@[extern c inline "((uint32_t)112)"] public axiom updatek1 : U32
/-- 'd' (100). -/
@[extern c inline "((uint32_t)100)"] public axiom updatek2 : U32
/-- 'a' (97). -/
@[extern c inline "((uint32_t)97)"] public axiom updatek3 : U32
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom updatek4 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom updatek5 : U32

/-- Key length for `pack` (4). Lake CLI command (`CLI/Main.lean` `| "pack" => lake.pack`; Help.lean `| "pack"` / `helpPack`). Exact len-4. -/
@[extern c inline "((size_t)4)"] public axiom packkKeyLen : USize
/-- 'p' (112). -/
@[extern c inline "((uint32_t)112)"] public axiom packk0 : U32
/-- 'a' (97). -/
@[extern c inline "((uint32_t)97)"] public axiom packk1 : U32
/-- 'c' (99). -/
@[extern c inline "((uint32_t)99)"] public axiom packk2 : U32
/-- 'k' (107). -/
@[extern c inline "((uint32_t)107)"] public axiom packk3 : U32

/-- Key length for `unpack` (6). Lake CLI command (`CLI/Main.lean` `| "unpack" => lake.unpack`; Help.lean `| "unpack"` / `helpUnpack`). Exact len-6. -/
@[extern c inline "((size_t)6)"] public axiom unpackkKeyLen : USize
/-- 'u' (117). -/
@[extern c inline "((uint32_t)117)"] public axiom unpackk0 : U32
/-- 'n' (110). -/
@[extern c inline "((uint32_t)110)"] public axiom unpackk1 : U32
/-- 'p' (112). -/
@[extern c inline "((uint32_t)112)"] public axiom unpackk2 : U32
/-- 'a' (97). -/
@[extern c inline "((uint32_t)97)"] public axiom unpackk3 : U32
/-- 'c' (99). -/
@[extern c inline "((uint32_t)99)"] public axiom unpackk4 : U32
/-- 'k' (107). -/
@[extern c inline "((uint32_t)107)"] public axiom unpackk5 : U32

/-- Key length for `upload` (6). Lake CLI command (`CLI/Main.lean` `| "upload" => lake.upload`; Help.lean `| "upload"` / `helpUpload`). Exact len-6 — distinct from more65 `update`. -/
@[extern c inline "((size_t)6)"] public axiom uploadkKeyLen : USize
/-- 'u' (117). -/
@[extern c inline "((uint32_t)117)"] public axiom uploadk0 : U32
/-- 'p' (112). -/
@[extern c inline "((uint32_t)112)"] public axiom uploadk1 : U32
/-- 'l' (108). -/
@[extern c inline "((uint32_t)108)"] public axiom uploadk2 : U32
/-- 'o' (111). -/
@[extern c inline "((uint32_t)111)"] public axiom uploadk3 : U32
/-- 'a' (97). -/
@[extern c inline "((uint32_t)97)"] public axiom uploadk4 : U32
/-- 'd' (100). -/
@[extern c inline "((uint32_t)100)"] public axiom uploadk5 : U32

/-- Key length for `shake` (5). Lake CLI command (`CLI/Main.lean` `| "shake" => lake.shake`; Help.lean `| "shake"` / `helpShake`). Exact len-5. -/
@[extern c inline "((size_t)5)"] public axiom shakekKeyLen : USize
/-- 's' (115). -/
@[extern c inline "((uint32_t)115)"] public axiom shakek0 : U32
/-- 'h' (104). -/
@[extern c inline "((uint32_t)104)"] public axiom shakek1 : U32
/-- 'a' (97). -/
@[extern c inline "((uint32_t)97)"] public axiom shakek2 : U32
/-- 'k' (107). -/
@[extern c inline "((uint32_t)107)"] public axiom shakek3 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom shakek4 : U32

/-- Key length for `run` (3). Lake CLI command (`CLI/Main.lean` `| "run" => lake.script.run`; Help.lean `| "run"` / `helpScriptRun`). Exact len-3. -/
@[extern c inline "((size_t)3)"] public axiom runkKeyLen : USize
/-- 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom runk0 : U32
/-- 'u' (117). -/
@[extern c inline "((uint32_t)117)"] public axiom runk1 : U32
/-- 'n' (110). -/
@[extern c inline "((uint32_t)110)"] public axiom runk2 : U32

/-- Key length for `scripts` (7). Lake CLI command (`CLI/Main.lean` `| "scripts" => lake.script.list`; Help.lean `| "scripts"` / `helpScriptList`). Exact len-7 — distinct from more58 `script`. -/
@[extern c inline "((size_t)7)"] public axiom scriptskKeyLen : USize
/-- 's' (115). -/
@[extern c inline "((uint32_t)115)"] public axiom scriptsk0 : U32
/-- 'c' (99). -/
@[extern c inline "((uint32_t)99)"] public axiom scriptsk1 : U32
/-- 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom scriptsk2 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom scriptsk3 : U32
/-- 'p' (112). -/
@[extern c inline "((uint32_t)112)"] public axiom scriptsk4 : U32
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom scriptsk5 : U32
/-- 's' (115). -/
@[extern c inline "((uint32_t)115)"] public axiom scriptsk6 : U32

/-- Key length for `get` (3). Lake CLI command (`CLI/Main.lean` `| "get" => cache.get`; Help.lean `| "get"` / `helpCacheGet`). Exact len-3. -/
@[extern c inline "((size_t)3)"] public axiom getkKeyLen : USize
/-- 'g' (103). -/
@[extern c inline "((uint32_t)103)"] public axiom getk0 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom getk1 : U32
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom getk2 : U32

/-- Key length for `put` (3). Lake CLI command (`CLI/Main.lean` `| "put" => cache.put`; Help.lean `| "put"` / `helpCachePut`). Exact len-3. -/
@[extern c inline "((size_t)3)"] public axiom putkKeyLen : USize
/-- 'p' (112). -/
@[extern c inline "((uint32_t)112)"] public axiom putk0 : U32
/-- 'u' (117). -/
@[extern c inline "((uint32_t)117)"] public axiom putk1 : U32
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom putk2 : U32

/-- Key length for `add` (3). Lake CLI command (`CLI/Main.lean` `| "add" => cache.add`; Help.lean `| "add"` / `helpCacheAdd`). Exact len-3. -/
@[extern c inline "((size_t)3)"] public axiom addkKeyLen : USize
/-- 'a' (97). -/
@[extern c inline "((uint32_t)97)"] public axiom addk0 : U32
/-- 'd' (100). -/
@[extern c inline "((uint32_t)100)"] public axiom addk1 : U32
/-- 'd' (100). -/
@[extern c inline "((uint32_t)100)"] public axiom addk2 : U32

/-- Key length for `list` (4). Lake CLI command (`CLI/Main.lean` `| "list" => script.list`; Help.lean `| "list"` / `helpScriptList`). Exact len-4. -/
@[extern c inline "((size_t)4)"] public axiom listkKeyLen : USize
/-- 'l' (108). -/
@[extern c inline "((uint32_t)108)"] public axiom listk0 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom listk1 : U32
/-- 's' (115). -/
@[extern c inline "((uint32_t)115)"] public axiom listk2 : U32
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom listk3 : U32

/-- Key length for `doc` (3). Lake CLI command (`CLI/Main.lean` `| "doc" => script.doc`; Help.lean `| "doc"` / `helpScriptDoc`). Exact len-3. -/
@[extern c inline "((size_t)3)"] public axiom dockKeyLen : USize
/-- 'd' (100). -/
@[extern c inline "((uint32_t)100)"] public axiom dock0 : U32
/-- 'o' (111). -/
@[extern c inline "((uint32_t)111)"] public axiom dock1 : U32
/-- 'c' (99). -/
@[extern c inline "((uint32_t)99)"] public axiom dock2 : U32

/-- Key length for `stage` (5). Lake CLI command (`CLI/Main.lean` `| "stage" => cache.stage`; Help.lean `| "stage"` / `helpCacheStage`). Exact len-5. -/
@[extern c inline "((size_t)5)"] public axiom stagekKeyLen : USize
/-- 's' (115). -/
@[extern c inline "((uint32_t)115)"] public axiom stagek0 : U32
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom stagek1 : U32
/-- 'a' (97). -/
@[extern c inline "((uint32_t)97)"] public axiom stagek2 : U32
/-- 'g' (103). -/
@[extern c inline "((uint32_t)103)"] public axiom stagek3 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom stagek4 : U32

/-- Key length for `exec` (4). Lake CLI alias (`CLI/Main.lean` `| "exe" | "exec" => lake.exe`; Help.lean helpExe). Exact len-4. -/
@[extern c inline "((size_t)4)"] public axiom execkKeyLen : USize
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom execk0 : U32
/-- 'x' (120). -/
@[extern c inline "((uint32_t)120)"] public axiom execk1 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom execk2 : U32
/-- 'c' (99). -/
@[extern c inline "((uint32_t)99)"] public axiom execk3 : U32

/-- Key length for `unstage` (7). Lake CLI command (`CLI/Main.lean` `| "unstage" => cache.unstage`; Help.lean `| "unstage"` / `helpCacheUnstage`). Exact len-7. -/
@[extern c inline "((size_t)7)"] public axiom unstagekKeyLen : USize
/-- 'u' (117). -/
@[extern c inline "((uint32_t)117)"] public axiom unstagek0 : U32
/-- 'n' (110). -/
@[extern c inline "((uint32_t)110)"] public axiom unstagek1 : U32
/-- 's' (115). -/
@[extern c inline "((uint32_t)115)"] public axiom unstagek2 : U32
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom unstagek3 : U32
/-- 'a' (97). -/
@[extern c inline "((uint32_t)97)"] public axiom unstagek4 : U32
/-- 'g' (103). -/
@[extern c inline "((uint32_t)103)"] public axiom unstagek5 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom unstagek6 : U32

/-- Key length for `put-staged` (10). Lake CLI command (`CLI/Main.lean` `| "put-staged" => cache.putStaged`; Help.lean `| "put-staged"` / `helpCachePutStaged`). Exact len-10. -/
@[extern c inline "((size_t)10)"] public axiom putstagedkKeyLen : USize
/-- 'p' (112). -/
@[extern c inline "((uint32_t)112)"] public axiom putstagedk0 : U32
/-- 'u' (117). -/
@[extern c inline "((uint32_t)117)"] public axiom putstagedk1 : U32
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom putstagedk2 : U32
/-- '-' (45). -/
@[extern c inline "((uint32_t)45)"] public axiom putstagedk3 : U32
/-- 's' (115). -/
@[extern c inline "((uint32_t)115)"] public axiom putstagedk4 : U32
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom putstagedk5 : U32
/-- 'a' (97). -/
@[extern c inline "((uint32_t)97)"] public axiom putstagedk6 : U32
/-- 'g' (103). -/
@[extern c inline "((uint32_t)103)"] public axiom putstagedk7 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom putstagedk8 : U32
/-- 'd' (100). -/
@[extern c inline "((uint32_t)100)"] public axiom putstagedk9 : U32

/-- Key length for `check-build` (11). Lake CLI command (`CLI/Main.lean` `| "check-build" => lake.checkBuild`; Help.lean `| "check-build"` / `helpCheckBuild`). Exact len-11. -/
@[extern c inline "((size_t)11)"] public axiom checkbuildkKeyLen : USize
/-- 'c' (99). -/
@[extern c inline "((uint32_t)99)"] public axiom checkbuildk0 : U32
/-- 'h' (104). -/
@[extern c inline "((uint32_t)104)"] public axiom checkbuildk1 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom checkbuildk2 : U32
/-- 'c' (99). -/
@[extern c inline "((uint32_t)99)"] public axiom checkbuildk3 : U32
/-- 'k' (107). -/
@[extern c inline "((uint32_t)107)"] public axiom checkbuildk4 : U32
/-- '-' (45). -/
@[extern c inline "((uint32_t)45)"] public axiom checkbuildk5 : U32
/-- 'b' (98). -/
@[extern c inline "((uint32_t)98)"] public axiom checkbuildk6 : U32
/-- 'u' (117). -/
@[extern c inline "((uint32_t)117)"] public axiom checkbuildk7 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom checkbuildk8 : U32
/-- 'l' (108). -/
@[extern c inline "((uint32_t)108)"] public axiom checkbuildk9 : U32
/-- 'd' (100). -/
@[extern c inline "((uint32_t)100)"] public axiom checkbuildk10 : U32

/-- Key length for `check-lint` (10). Lake CLI command (`CLI/Main.lean` `| "check-lint" => lake.checkLint`; Help.lean `| "check-lint"` / `helpCheckLint`). Exact len-10. -/
@[extern c inline "((size_t)10)"] public axiom checklintkKeyLen : USize
/-- 'c' (99). -/
@[extern c inline "((uint32_t)99)"] public axiom checklintk0 : U32
/-- 'h' (104). -/
@[extern c inline "((uint32_t)104)"] public axiom checklintk1 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom checklintk2 : U32
/-- 'c' (99). -/
@[extern c inline "((uint32_t)99)"] public axiom checklintk3 : U32
/-- 'k' (107). -/
@[extern c inline "((uint32_t)107)"] public axiom checklintk4 : U32
/-- '-' (45). -/
@[extern c inline "((uint32_t)45)"] public axiom checklintk5 : U32
/-- 'l' (108). -/
@[extern c inline "((uint32_t)108)"] public axiom checklintk6 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom checklintk7 : U32
/-- 'n' (110). -/
@[extern c inline "((uint32_t)110)"] public axiom checklintk8 : U32
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom checklintk9 : U32

/-- Key length for `check-test` (10). Lake CLI command (`CLI/Main.lean` `| "check-test" => lake.checkTest`; Help.lean `| "check-test"` / `helpCheckTest`). Exact len-10. -/
@[extern c inline "((size_t)10)"] public axiom checktestkKeyLen : USize
/-- 'c' (99). -/
@[extern c inline "((uint32_t)99)"] public axiom checktestk0 : U32
/-- 'h' (104). -/
@[extern c inline "((uint32_t)104)"] public axiom checktestk1 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom checktestk2 : U32
/-- 'c' (99). -/
@[extern c inline "((uint32_t)99)"] public axiom checktestk3 : U32
/-- 'k' (107). -/
@[extern c inline "((uint32_t)107)"] public axiom checktestk4 : U32
/-- '-' (45). -/
@[extern c inline "((uint32_t)45)"] public axiom checktestk5 : U32
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom checktestk6 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom checktestk7 : U32
/-- 's' (115). -/
@[extern c inline "((uint32_t)115)"] public axiom checktestk8 : U32
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom checktestk9 : U32

/-- Key length for `query-kind` (10). Lake CLI command (`CLI/Main.lean` `| "query-kind" => lake.queryKind`). Exact len-10. -/
@[extern c inline "((size_t)10)"] public axiom querykindkKeyLen : USize
/-- 'q' (113). -/
@[extern c inline "((uint32_t)113)"] public axiom querykindk0 : U32
/-- 'u' (117). -/
@[extern c inline "((uint32_t)117)"] public axiom querykindk1 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom querykindk2 : U32
/-- 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom querykindk3 : U32
/-- 'y' (121). -/
@[extern c inline "((uint32_t)121)"] public axiom querykindk4 : U32
/-- '-' (45). -/
@[extern c inline "((uint32_t)45)"] public axiom querykindk5 : U32
/-- 'k' (107). -/
@[extern c inline "((uint32_t)107)"] public axiom querykindk6 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom querykindk7 : U32
/-- 'n' (110). -/
@[extern c inline "((uint32_t)110)"] public axiom querykindk8 : U32
/-- 'd' (100). -/
@[extern c inline "((uint32_t)100)"] public axiom querykindk9 : U32

/-- Key length for `setup-file` (10). Lake CLI command (`CLI/Main.lean` `| "setup-file" => lake.setupFile`; Serve.lean). Exact len-10. -/
@[extern c inline "((size_t)10)"] public axiom setupfilekKeyLen : USize
/-- 's' (115). -/
@[extern c inline "((uint32_t)115)"] public axiom setupfilek0 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom setupfilek1 : U32
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom setupfilek2 : U32
/-- 'u' (117). -/
@[extern c inline "((uint32_t)117)"] public axiom setupfilek3 : U32
/-- 'p' (112). -/
@[extern c inline "((uint32_t)112)"] public axiom setupfilek4 : U32
/-- '-' (45). -/
@[extern c inline "((uint32_t)45)"] public axiom setupfilek5 : U32
/-- 'f' (102). -/
@[extern c inline "((uint32_t)102)"] public axiom setupfilek6 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom setupfilek7 : U32
/-- 'l' (108). -/
@[extern c inline "((uint32_t)108)"] public axiom setupfilek8 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom setupfilek9 : U32

/-- Key length for `self-check` (10). Lake CLI command (`CLI/Main.lean` `| "self-check" => lake.selfCheck`). Exact len-10. -/
@[extern c inline "((size_t)10)"] public axiom selfcheckkKeyLen : USize
/-- 's' (115). -/
@[extern c inline "((uint32_t)115)"] public axiom selfcheckk0 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom selfcheckk1 : U32
/-- 'l' (108). -/
@[extern c inline "((uint32_t)108)"] public axiom selfcheckk2 : U32
/-- 'f' (102). -/
@[extern c inline "((uint32_t)102)"] public axiom selfcheckk3 : U32
/-- '-' (45). -/
@[extern c inline "((uint32_t)45)"] public axiom selfcheckk4 : U32
/-- 'c' (99). -/
@[extern c inline "((uint32_t)99)"] public axiom selfcheckk5 : U32
/-- 'h' (104). -/
@[extern c inline "((uint32_t)104)"] public axiom selfcheckk6 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom selfcheckk7 : U32
/-- 'c' (99). -/
@[extern c inline "((uint32_t)99)"] public axiom selfcheckk8 : U32
/-- 'k' (107). -/
@[extern c inline "((uint32_t)107)"] public axiom selfcheckk9 : U32

/-- Key length for `translate-config` (16). Lake CLI command (`CLI/Main.lean` `| "translate-config" => lake.translateConfig`). Exact len-16. -/
@[extern c inline "((size_t)16)"] public axiom translateconfigkKeyLen : USize
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom translateconfigk0 : U32
/-- 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom translateconfigk1 : U32
/-- 'a' (97). -/
@[extern c inline "((uint32_t)97)"] public axiom translateconfigk2 : U32
/-- 'n' (110). -/
@[extern c inline "((uint32_t)110)"] public axiom translateconfigk3 : U32
/-- 's' (115). -/
@[extern c inline "((uint32_t)115)"] public axiom translateconfigk4 : U32
/-- 'l' (108). -/
@[extern c inline "((uint32_t)108)"] public axiom translateconfigk5 : U32
/-- 'a' (97). -/
@[extern c inline "((uint32_t)97)"] public axiom translateconfigk6 : U32
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom translateconfigk7 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom translateconfigk8 : U32
/-- '-' (45). -/
@[extern c inline "((uint32_t)45)"] public axiom translateconfigk9 : U32
/-- 'c' (99). -/
@[extern c inline "((uint32_t)99)"] public axiom translateconfigk10 : U32
/-- 'o' (111). -/
@[extern c inline "((uint32_t)111)"] public axiom translateconfigk11 : U32
/-- 'n' (110). -/
@[extern c inline "((uint32_t)110)"] public axiom translateconfigk12 : U32
/-- 'f' (102). -/
@[extern c inline "((uint32_t)102)"] public axiom translateconfigk13 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom translateconfigk14 : U32
/-- 'g' (103). -/
@[extern c inline "((uint32_t)103)"] public axiom translateconfigk15 : U32

/-- Key length for `resolve-deps` (12). Lake CLI command (`CLI/Main.lean` `| "resolve-deps" => lake.resolveDeps`). Exact len-12. -/
@[extern c inline "((size_t)12)"] public axiom resolvedepskKeyLen : USize
/-- 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom resolvedepsk0 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom resolvedepsk1 : U32
/-- 's' (115). -/
@[extern c inline "((uint32_t)115)"] public axiom resolvedepsk2 : U32
/-- 'o' (111). -/
@[extern c inline "((uint32_t)111)"] public axiom resolvedepsk3 : U32
/-- 'l' (108). -/
@[extern c inline "((uint32_t)108)"] public axiom resolvedepsk4 : U32
/-- 'v' (118). -/
@[extern c inline "((uint32_t)118)"] public axiom resolvedepsk5 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom resolvedepsk6 : U32
/-- '-' (45). -/
@[extern c inline "((uint32_t)45)"] public axiom resolvedepsk7 : U32
/-- 'd' (100). -/
@[extern c inline "((uint32_t)100)"] public axiom resolvedepsk8 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom resolvedepsk9 : U32
/-- 'p' (112). -/
@[extern c inline "((uint32_t)112)"] public axiom resolvedepsk10 : U32
/-- 's' (115). -/
@[extern c inline "((uint32_t)115)"] public axiom resolvedepsk11 : U32

/-- Key length for `services` (8). Lake CLI command (`CLI/Main.lean` `| "services" => cache.services`). Exact len-8 (distinct from more40 len-7 `service`). -/
@[extern c inline "((size_t)8)"] public axiom serviceskKeyLen : USize
/-- 's' (115). -/
@[extern c inline "((uint32_t)115)"] public axiom servicesk0 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom servicesk1 : U32
/-- 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom servicesk2 : U32
/-- 'v' (118). -/
@[extern c inline "((uint32_t)118)"] public axiom servicesk3 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom servicesk4 : U32
/-- 'c' (99). -/
@[extern c inline "((uint32_t)99)"] public axiom servicesk5 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom servicesk6 : U32
/-- 's' (115). -/
@[extern c inline "((uint32_t)115)"] public axiom servicesk7 : U32

/-- Key length for `reservoir-config` (16). Lake CLI command (`CLI/Main.lean` `| "reservoir-config" => lake.reservoirConfig`). Exact len-16 (distinct from more7 len-9 `reservoir`). -/
@[extern c inline "((size_t)16)"] public axiom reservoirconfigkKeyLen : USize
/-- 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom reservoirconfigk0 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom reservoirconfigk1 : U32
/-- 's' (115). -/
@[extern c inline "((uint32_t)115)"] public axiom reservoirconfigk2 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom reservoirconfigk3 : U32
/-- 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom reservoirconfigk4 : U32
/-- 'v' (118). -/
@[extern c inline "((uint32_t)118)"] public axiom reservoirconfigk5 : U32
/-- 'o' (111). -/
@[extern c inline "((uint32_t)111)"] public axiom reservoirconfigk6 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom reservoirconfigk7 : U32
/-- 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom reservoirconfigk8 : U32
/-- '-' (45). -/
@[extern c inline "((uint32_t)45)"] public axiom reservoirconfigk9 : U32
/-- 'c' (99). -/
@[extern c inline "((uint32_t)99)"] public axiom reservoirconfigk10 : U32
/-- 'o' (111). -/
@[extern c inline "((uint32_t)111)"] public axiom reservoirconfigk11 : U32
/-- 'n' (110). -/
@[extern c inline "((uint32_t)110)"] public axiom reservoirconfigk12 : U32
/-- 'f' (102). -/
@[extern c inline "((uint32_t)102)"] public axiom reservoirconfigk13 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom reservoirconfigk14 : U32
/-- 'g' (103). -/
@[extern c inline "((uint32_t)103)"] public axiom reservoirconfigk15 : U32

/-- Key length for `version-tags` (12). Lake CLI command (`CLI/Main.lean` `| "version-tags" => lake.versionTags`). Exact len-12 (distinct from more12 camelCase len-11 `versionTags`). -/
@[extern c inline "((size_t)12)"] public axiom versiontagsclikKeyLen : USize
/-- 'v' (118). -/
@[extern c inline "((uint32_t)118)"] public axiom versiontagsclik0 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom versiontagsclik1 : U32
/-- 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom versiontagsclik2 : U32
/-- 's' (115). -/
@[extern c inline "((uint32_t)115)"] public axiom versiontagsclik3 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom versiontagsclik4 : U32
/-- 'o' (111). -/
@[extern c inline "((uint32_t)111)"] public axiom versiontagsclik5 : U32
/-- 'n' (110). -/
@[extern c inline "((uint32_t)110)"] public axiom versiontagsclik6 : U32
/-- '-' (45). -/
@[extern c inline "((uint32_t)45)"] public axiom versiontagsclik7 : U32
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom versiontagsclik8 : U32
/-- 'a' (97). -/
@[extern c inline "((uint32_t)97)"] public axiom versiontagsclik9 : U32
/-- 'g' (103). -/
@[extern c inline "((uint32_t)103)"] public axiom versiontagsclik10 : U32
/-- 's' (115). -/
@[extern c inline "((uint32_t)115)"] public axiom versiontagsclik11 : U32

/-- Key length for `upgrade` (7). Lake CLI command (`CLI/Main.lean` `| "update" | "upgrade" => lake.update`; Help.lean same). Exact len-7 (distinct from more65 len-6 `update`). -/
@[extern c inline "((size_t)7)"] public axiom upgradekKeyLen : USize
/-- 'u' (117). -/
@[extern c inline "((uint32_t)117)"] public axiom upgradek0 : U32
/-- 'p' (112). -/
@[extern c inline "((uint32_t)112)"] public axiom upgradek1 : U32
/-- 'g' (103). -/
@[extern c inline "((uint32_t)103)"] public axiom upgradek2 : U32
/-- 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom upgradek3 : U32
/-- 'a' (97). -/
@[extern c inline "((uint32_t)97)"] public axiom upgradek4 : U32
/-- 'd' (100). -/
@[extern c inline "((uint32_t)100)"] public axiom upgradek5 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom upgradek6 : U32

/-- Key length for `no-build` (8). Lake long-option stem (`CLI/Main.lean` `| "--no-build" =>`); key without leading `--`. Exact len-8 (distinct from more62 len-5 `build`). -/
@[extern c inline "((size_t)8)"] public axiom nobuildkKeyLen : USize
/-- 'n' (110). -/
@[extern c inline "((uint32_t)110)"] public axiom nobuildk0 : U32
/-- 'o' (111). -/
@[extern c inline "((uint32_t)111)"] public axiom nobuildk1 : U32
/-- '-' (45). -/
@[extern c inline "((uint32_t)45)"] public axiom nobuildk2 : U32
/-- 'b' (98). -/
@[extern c inline "((uint32_t)98)"] public axiom nobuildk3 : U32
/-- 'u' (117). -/
@[extern c inline "((uint32_t)117)"] public axiom nobuildk4 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom nobuildk5 : U32
/-- 'l' (108). -/
@[extern c inline "((uint32_t)108)"] public axiom nobuildk6 : U32
/-- 'd' (100). -/
@[extern c inline "((uint32_t)100)"] public axiom nobuildk7 : U32

/-- Key length for `no-cache` (8). Lake long-option stem (`CLI/Main.lean` `| "--no-cache" =>`); key without leading `--`. Exact len-8 (distinct from more58 len-5 `cache`). -/
@[extern c inline "((size_t)8)"] public axiom nocachekKeyLen : USize
/-- 'n' (110). -/
@[extern c inline "((uint32_t)110)"] public axiom nocachek0 : U32
/-- 'o' (111). -/
@[extern c inline "((uint32_t)111)"] public axiom nocachek1 : U32
/-- '-' (45). -/
@[extern c inline "((uint32_t)45)"] public axiom nocachek2 : U32
/-- 'c' (99). -/
@[extern c inline "((uint32_t)99)"] public axiom nocachek3 : U32
/-- 'a' (97). -/
@[extern c inline "((uint32_t)97)"] public axiom nocachek4 : U32
/-- 'c' (99). -/
@[extern c inline "((uint32_t)99)"] public axiom nocachek5 : U32
/-- 'h' (104). -/
@[extern c inline "((uint32_t)104)"] public axiom nocachek6 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom nocachek7 : U32

/-- Key length for `try-cache` (9). Lake long-option stem (`CLI/Main.lean` `| "--try-cache" =>`); key without leading `--`. Exact len-9 (distinct from more58 len-5 `cache` and more75 `no-cache`). -/
@[extern c inline "((size_t)9)"] public axiom trycachekKeyLen : USize
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom trycachek0 : U32
/-- 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom trycachek1 : U32
/-- 'y' (121). -/
@[extern c inline "((uint32_t)121)"] public axiom trycachek2 : U32
/-- '-' (45). -/
@[extern c inline "((uint32_t)45)"] public axiom trycachek3 : U32
/-- 'c' (99). -/
@[extern c inline "((uint32_t)99)"] public axiom trycachek4 : U32
/-- 'a' (97). -/
@[extern c inline "((uint32_t)97)"] public axiom trycachek5 : U32
/-- 'c' (99). -/
@[extern c inline "((uint32_t)99)"] public axiom trycachek6 : U32
/-- 'h' (104). -/
@[extern c inline "((uint32_t)104)"] public axiom trycachek7 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom trycachek8 : U32

/-- Key length for `force-download` (14). Lake long-option stem (`CLI/Main.lean` `| "--force-download" =>`); key without leading `--`. Exact len-14. -/
@[extern c inline "((size_t)14)"] public axiom forcedownloadkKeyLen : USize
/-- 'f' (102). -/
@[extern c inline "((uint32_t)102)"] public axiom forcedownloadk0 : U32
/-- 'o' (111). -/
@[extern c inline "((uint32_t)111)"] public axiom forcedownloadk1 : U32
/-- 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom forcedownloadk2 : U32
/-- 'c' (99). -/
@[extern c inline "((uint32_t)99)"] public axiom forcedownloadk3 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom forcedownloadk4 : U32
/-- '-' (45). -/
@[extern c inline "((uint32_t)45)"] public axiom forcedownloadk5 : U32
/-- 'd' (100). -/
@[extern c inline "((uint32_t)100)"] public axiom forcedownloadk6 : U32
/-- 'o' (111). -/
@[extern c inline "((uint32_t)111)"] public axiom forcedownloadk7 : U32
/-- 'w' (119). -/
@[extern c inline "((uint32_t)119)"] public axiom forcedownloadk8 : U32
/-- 'n' (110). -/
@[extern c inline "((uint32_t)110)"] public axiom forcedownloadk9 : U32
/-- 'l' (108). -/
@[extern c inline "((uint32_t)108)"] public axiom forcedownloadk10 : U32
/-- 'o' (111). -/
@[extern c inline "((uint32_t)111)"] public axiom forcedownloadk11 : U32
/-- 'a' (97). -/
@[extern c inline "((uint32_t)97)"] public axiom forcedownloadk12 : U32
/-- 'd' (100). -/
@[extern c inline "((uint32_t)100)"] public axiom forcedownloadk13 : U32

/-- Key length for `download-arts` (13). Lake long-option stem (`CLI/Main.lean` `| "--download-arts" =>`); key without leading `--`. Exact len-13 (distinct from more55 len-3 `art`). -/
@[extern c inline "((size_t)13)"] public axiom downloadartskKeyLen : USize
/-- 'd' (100). -/
@[extern c inline "((uint32_t)100)"] public axiom downloadartsk0 : U32
/-- 'o' (111). -/
@[extern c inline "((uint32_t)111)"] public axiom downloadartsk1 : U32
/-- 'w' (119). -/
@[extern c inline "((uint32_t)119)"] public axiom downloadartsk2 : U32
/-- 'n' (110). -/
@[extern c inline "((uint32_t)110)"] public axiom downloadartsk3 : U32
/-- 'l' (108). -/
@[extern c inline "((uint32_t)108)"] public axiom downloadartsk4 : U32
/-- 'o' (111). -/
@[extern c inline "((uint32_t)111)"] public axiom downloadartsk5 : U32
/-- 'a' (97). -/
@[extern c inline "((uint32_t)97)"] public axiom downloadartsk6 : U32
/-- 'd' (100). -/
@[extern c inline "((uint32_t)100)"] public axiom downloadartsk7 : U32
/-- '-' (45). -/
@[extern c inline "((uint32_t)45)"] public axiom downloadartsk8 : U32
/-- 'a' (97). -/
@[extern c inline "((uint32_t)97)"] public axiom downloadartsk9 : U32
/-- 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom downloadartsk10 : U32
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom downloadartsk11 : U32
/-- 's' (115). -/
@[extern c inline "((uint32_t)115)"] public axiom downloadartsk12 : U32

/-- Key length for `mappings-only` (13). Lake long-option stem (`CLI/Main.lean` `| "--mappings-only" =>`); key without leading `--`. Exact len-13 (distinct from more57 len-8 `mappings`). -/
@[extern c inline "((size_t)13)"] public axiom mappingsonlykKeyLen : USize
/-- 'm' (109). -/
@[extern c inline "((uint32_t)109)"] public axiom mappingsonlyk0 : U32
/-- 'a' (97). -/
@[extern c inline "((uint32_t)97)"] public axiom mappingsonlyk1 : U32
/-- 'p' (112). -/
@[extern c inline "((uint32_t)112)"] public axiom mappingsonlyk2 : U32
/-- 'p' (112). -/
@[extern c inline "((uint32_t)112)"] public axiom mappingsonlyk3 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom mappingsonlyk4 : U32
/-- 'n' (110). -/
@[extern c inline "((uint32_t)110)"] public axiom mappingsonlyk5 : U32
/-- 'g' (103). -/
@[extern c inline "((uint32_t)103)"] public axiom mappingsonlyk6 : U32
/-- 's' (115). -/
@[extern c inline "((uint32_t)115)"] public axiom mappingsonlyk7 : U32
/-- '-' (45). -/
@[extern c inline "((uint32_t)45)"] public axiom mappingsonlyk8 : U32
/-- 'o' (111). -/
@[extern c inline "((uint32_t)111)"] public axiom mappingsonlyk9 : U32
/-- 'n' (110). -/
@[extern c inline "((uint32_t)110)"] public axiom mappingsonlyk10 : U32
/-- 'l' (108). -/
@[extern c inline "((uint32_t)108)"] public axiom mappingsonlyk11 : U32
/-- 'y' (121). -/
@[extern c inline "((uint32_t)121)"] public axiom mappingsonlyk12 : U32

/-- Key length for `no-overwrite` (12). Lake long-option stem (`CLI/Main.lean` `| "--no-overwrite" =>`); key without leading `--`. Exact len-12. -/
@[extern c inline "((size_t)12)"] public axiom nooverwritekKeyLen : USize
/-- 'n' (110). -/
@[extern c inline "((uint32_t)110)"] public axiom nooverwritek0 : U32
/-- 'o' (111). -/
@[extern c inline "((uint32_t)111)"] public axiom nooverwritek1 : U32
/-- '-' (45). -/
@[extern c inline "((uint32_t)45)"] public axiom nooverwritek2 : U32
/-- 'o' (111). -/
@[extern c inline "((uint32_t)111)"] public axiom nooverwritek3 : U32
/-- 'v' (118). -/
@[extern c inline "((uint32_t)118)"] public axiom nooverwritek4 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom nooverwritek5 : U32
/-- 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom nooverwritek6 : U32
/-- 'w' (119). -/
@[extern c inline "((uint32_t)119)"] public axiom nooverwritek7 : U32
/-- 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom nooverwritek8 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom nooverwritek9 : U32
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom nooverwritek10 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom nooverwritek11 : U32

/-- Key length for `force-overwrite` (15). Lake long-option stem (`CLI/Main.lean` `| "--force-overwrite" =>`); key without leading `--`. Exact len-15 (distinct from more76 len-14 `force-download`). -/
@[extern c inline "((size_t)15)"] public axiom forceoverwritekKeyLen : USize
/-- 'f' (102). -/
@[extern c inline "((uint32_t)102)"] public axiom forceoverwritek0 : U32
/-- 'o' (111). -/
@[extern c inline "((uint32_t)111)"] public axiom forceoverwritek1 : U32
/-- 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom forceoverwritek2 : U32
/-- 'c' (99). -/
@[extern c inline "((uint32_t)99)"] public axiom forceoverwritek3 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom forceoverwritek4 : U32
/-- '-' (45). -/
@[extern c inline "((uint32_t)45)"] public axiom forceoverwritek5 : U32
/-- 'o' (111). -/
@[extern c inline "((uint32_t)111)"] public axiom forceoverwritek6 : U32
/-- 'v' (118). -/
@[extern c inline "((uint32_t)118)"] public axiom forceoverwritek7 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom forceoverwritek8 : U32
/-- 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom forceoverwritek9 : U32
/-- 'w' (119). -/
@[extern c inline "((uint32_t)119)"] public axiom forceoverwritek10 : U32
/-- 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom forceoverwritek11 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom forceoverwritek12 : U32
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom forceoverwritek13 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom forceoverwritek14 : U32

/-- Key length for `rehash` (6). Lake long-option stem (`CLI/Main.lean` `| "--rehash" =>`); key without leading `--`. Exact len-6. -/
@[extern c inline "((size_t)6)"] public axiom rehashkKeyLen : USize
/-- 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom rehashk0 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom rehashk1 : U32
/-- 'h' (104). -/
@[extern c inline "((uint32_t)104)"] public axiom rehashk2 : U32
/-- 'a' (97). -/
@[extern c inline "((uint32_t)97)"] public axiom rehashk3 : U32
/-- 's' (115). -/
@[extern c inline "((uint32_t)115)"] public axiom rehashk4 : U32
/-- 'h' (104). -/
@[extern c inline "((uint32_t)104)"] public axiom rehashk5 : U32

/-- Key length for `keep-implied` (12). Lake long-option stem (`CLI/Main.lean` `| "--keep-implied" =>`); key without leading `--`. Exact len-12. -/
@[extern c inline "((size_t)12)"] public axiom keepimpliedkKeyLen : USize
/-- 'k' (107). -/
@[extern c inline "((uint32_t)107)"] public axiom keepimpliedk0 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom keepimpliedk1 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom keepimpliedk2 : U32
/-- 'p' (112). -/
@[extern c inline "((uint32_t)112)"] public axiom keepimpliedk3 : U32
/-- '-' (45). -/
@[extern c inline "((uint32_t)45)"] public axiom keepimpliedk4 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom keepimpliedk5 : U32
/-- 'm' (109). -/
@[extern c inline "((uint32_t)109)"] public axiom keepimpliedk6 : U32
/-- 'p' (112). -/
@[extern c inline "((uint32_t)112)"] public axiom keepimpliedk7 : U32
/-- 'l' (108). -/
@[extern c inline "((uint32_t)108)"] public axiom keepimpliedk8 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom keepimpliedk9 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom keepimpliedk10 : U32
/-- 'd' (100). -/
@[extern c inline "((uint32_t)100)"] public axiom keepimpliedk11 : U32

/-- Key length for `keep-prefix` (11). Lake long-option stem (`CLI/Main.lean` `| "--keep-prefix" =>`); key without leading `--`. Exact len-11. -/
@[extern c inline "((size_t)11)"] public axiom keepprefixkKeyLen : USize
/-- 'k' (107). -/
@[extern c inline "((uint32_t)107)"] public axiom keepprefixk0 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom keepprefixk1 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom keepprefixk2 : U32
/-- 'p' (112). -/
@[extern c inline "((uint32_t)112)"] public axiom keepprefixk3 : U32
/-- '-' (45). -/
@[extern c inline "((uint32_t)45)"] public axiom keepprefixk4 : U32
/-- 'p' (112). -/
@[extern c inline "((uint32_t)112)"] public axiom keepprefixk5 : U32
/-- 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom keepprefixk6 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom keepprefixk7 : U32
/-- 'f' (102). -/
@[extern c inline "((uint32_t)102)"] public axiom keepprefixk8 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom keepprefixk9 : U32
/-- 'x' (120). -/
@[extern c inline "((uint32_t)120)"] public axiom keepprefixk10 : U32

/-- Key length for `keep-public` (11). Lake long-option stem (`CLI/Main.lean` `| "--keep-public" =>`); key without leading `--`. Exact len-11. -/
@[extern c inline "((size_t)11)"] public axiom keeppublickKeyLen : USize
/-- 'k' (107). -/
@[extern c inline "((uint32_t)107)"] public axiom keeppublick0 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom keeppublick1 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom keeppublick2 : U32
/-- 'p' (112). -/
@[extern c inline "((uint32_t)112)"] public axiom keeppublick3 : U32
/-- '-' (45). -/
@[extern c inline "((uint32_t)45)"] public axiom keeppublick4 : U32
/-- 'p' (112). -/
@[extern c inline "((uint32_t)112)"] public axiom keeppublick5 : U32
/-- 'u' (117). -/
@[extern c inline "((uint32_t)117)"] public axiom keeppublick6 : U32
/-- 'b' (98). -/
@[extern c inline "((uint32_t)98)"] public axiom keeppublick7 : U32
/-- 'l' (108). -/
@[extern c inline "((uint32_t)108)"] public axiom keeppublick8 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom keeppublick9 : U32
/-- 'c' (99). -/
@[extern c inline "((uint32_t)99)"] public axiom keeppublick10 : U32

/-- Key length for `add-public` (10). Lake long-option stem (`CLI/Main.lean` `| "--add-public" =>`); key without leading `--`. Exact len-10. -/
@[extern c inline "((size_t)10)"] public axiom addpublickKeyLen : USize
/-- 'a' (97). -/
@[extern c inline "((uint32_t)97)"] public axiom addpublick0 : U32
/-- 'd' (100). -/
@[extern c inline "((uint32_t)100)"] public axiom addpublick1 : U32
/-- 'd' (100). -/
@[extern c inline "((uint32_t)100)"] public axiom addpublick2 : U32
/-- '-' (45). -/
@[extern c inline "((uint32_t)45)"] public axiom addpublick3 : U32
/-- 'p' (112). -/
@[extern c inline "((uint32_t)112)"] public axiom addpublick4 : U32
/-- 'u' (117). -/
@[extern c inline "((uint32_t)117)"] public axiom addpublick5 : U32
/-- 'b' (98). -/
@[extern c inline "((uint32_t)98)"] public axiom addpublick6 : U32
/-- 'l' (108). -/
@[extern c inline "((uint32_t)108)"] public axiom addpublick7 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom addpublick8 : U32
/-- 'c' (99). -/
@[extern c inline "((uint32_t)99)"] public axiom addpublick9 : U32

/-- Key length for `gh-style` (8). Lake long-option stem (`CLI/Main.lean` `| "--gh-style" =>`); key without leading `--`. Exact len-8. -/
@[extern c inline "((size_t)8)"] public axiom ghstylekKeyLen : USize
/-- 'g' (103). -/
@[extern c inline "((uint32_t)103)"] public axiom ghstylek0 : U32
/-- 'h' (104). -/
@[extern c inline "((uint32_t)104)"] public axiom ghstylek1 : U32
/-- '-' (45). -/
@[extern c inline "((uint32_t)45)"] public axiom ghstylek2 : U32
/-- 's' (115). -/
@[extern c inline "((uint32_t)115)"] public axiom ghstylek3 : U32
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom ghstylek4 : U32
/-- 'y' (121). -/
@[extern c inline "((uint32_t)121)"] public axiom ghstylek5 : U32
/-- 'l' (108). -/
@[extern c inline "((uint32_t)108)"] public axiom ghstylek6 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom ghstylek7 : U32

/-- Key length for `explain` (7). Lake long-option stem (`CLI/Main.lean` `| "--explain" =>`); key without leading `--`. Exact len-7. -/
@[extern c inline "((size_t)7)"] public axiom explainkKeyLen : USize
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom explaink0 : U32
/-- 'x' (120). -/
@[extern c inline "((uint32_t)120)"] public axiom explaink1 : U32
/-- 'p' (112). -/
@[extern c inline "((uint32_t)112)"] public axiom explaink2 : U32
/-- 'l' (108). -/
@[extern c inline "((uint32_t)108)"] public axiom explaink3 : U32
/-- 'a' (97). -/
@[extern c inline "((uint32_t)97)"] public axiom explaink4 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom explaink5 : U32
/-- 'n' (110). -/
@[extern c inline "((uint32_t)110)"] public axiom explaink6 : U32

/-- Key length for `builtin-only` (12). Lake long-option stem (`CLI/Main.lean` `| "--builtin-only" =>`); key without leading `--`. Exact len-12 — distinct from more20 camel `builtinLint` (11). -/
@[extern c inline "((size_t)12)"] public axiom builtinonlykKeyLen : USize
/-- 'b' (98). -/
@[extern c inline "((uint32_t)98)"] public axiom builtinonlyk0 : U32
/-- 'u' (117). -/
@[extern c inline "((uint32_t)117)"] public axiom builtinonlyk1 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom builtinonlyk2 : U32
/-- 'l' (108). -/
@[extern c inline "((uint32_t)108)"] public axiom builtinonlyk3 : U32
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom builtinonlyk4 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom builtinonlyk5 : U32
/-- 'n' (110). -/
@[extern c inline "((uint32_t)110)"] public axiom builtinonlyk6 : U32
/-- '-' (45). -/
@[extern c inline "((uint32_t)45)"] public axiom builtinonlyk7 : U32
/-- 'o' (111). -/
@[extern c inline "((uint32_t)111)"] public axiom builtinonlyk8 : U32
/-- 'n' (110). -/
@[extern c inline "((uint32_t)110)"] public axiom builtinonlyk9 : U32
/-- 'l' (108). -/
@[extern c inline "((uint32_t)108)"] public axiom builtinonlyk10 : U32
/-- 'y' (121). -/
@[extern c inline "((uint32_t)121)"] public axiom builtinonlyk11 : U32

/-- Key length for `lint-only` (9). Lake long-option stem (`CLI/Main.lean` `| "--lint-only" =>`); key without leading `--`. Exact len-9 — distinct from more64 `lint` (4) / free `linters` (7). -/
@[extern c inline "((size_t)9)"] public axiom lintonlykKeyLen : USize
/-- 'l' (108). -/
@[extern c inline "((uint32_t)108)"] public axiom lintonlyk0 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom lintonlyk1 : U32
/-- 'n' (110). -/
@[extern c inline "((uint32_t)110)"] public axiom lintonlyk2 : U32
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom lintonlyk3 : U32
/-- '-' (45). -/
@[extern c inline "((uint32_t)45)"] public axiom lintonlyk4 : U32
/-- 'o' (111). -/
@[extern c inline "((uint32_t)111)"] public axiom lintonlyk5 : U32
/-- 'n' (110). -/
@[extern c inline "((uint32_t)110)"] public axiom lintonlyk6 : U32
/-- 'l' (108). -/
@[extern c inline "((uint32_t)108)"] public axiom lintonlyk7 : U32
/-- 'y' (121). -/
@[extern c inline "((uint32_t)121)"] public axiom lintonlyk8 : U32

/-- Key length for `record-exceptions` (17). Lake long-option stem (`CLI/Main.lean` `| "--record-exceptions" =>`); key without leading `--`. Exact len-17. -/
@[extern c inline "((size_t)17)"] public axiom recordexceptionskKeyLen : USize
/-- 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom recordexceptionsk0 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom recordexceptionsk1 : U32
/-- 'c' (99). -/
@[extern c inline "((uint32_t)99)"] public axiom recordexceptionsk2 : U32
/-- 'o' (111). -/
@[extern c inline "((uint32_t)111)"] public axiom recordexceptionsk3 : U32
/-- 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom recordexceptionsk4 : U32
/-- 'd' (100). -/
@[extern c inline "((uint32_t)100)"] public axiom recordexceptionsk5 : U32
/-- '-' (45). -/
@[extern c inline "((uint32_t)45)"] public axiom recordexceptionsk6 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom recordexceptionsk7 : U32
/-- 'x' (120). -/
@[extern c inline "((uint32_t)120)"] public axiom recordexceptionsk8 : U32
/-- 'c' (99). -/
@[extern c inline "((uint32_t)99)"] public axiom recordexceptionsk9 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom recordexceptionsk10 : U32
/-- 'p' (112). -/
@[extern c inline "((uint32_t)112)"] public axiom recordexceptionsk11 : U32
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom recordexceptionsk12 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom recordexceptionsk13 : U32
/-- 'o' (111). -/
@[extern c inline "((uint32_t)111)"] public axiom recordexceptionsk14 : U32
/-- 'n' (110). -/
@[extern c inline "((uint32_t)110)"] public axiom recordexceptionsk15 : U32
/-- 's' (115). -/
@[extern c inline "((uint32_t)115)"] public axiom recordexceptionsk16 : U32

/-- Key length for `keep-toolchain` (14). Lake long-option stem (`CLI/Main.lean` `| "--keep-toolchain" =>`); key without leading `--`. Exact len-14 — content-distinct from more19 camel `fixedToolchain` (also len-14). -/
@[extern c inline "((size_t)14)"] public axiom keeptoolchainkKeyLen : USize
/-- 'k' (107). -/
@[extern c inline "((uint32_t)107)"] public axiom keeptoolchaink0 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom keeptoolchaink1 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom keeptoolchaink2 : U32
/-- 'p' (112). -/
@[extern c inline "((uint32_t)112)"] public axiom keeptoolchaink3 : U32
/-- '-' (45). -/
@[extern c inline "((uint32_t)45)"] public axiom keeptoolchaink4 : U32
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom keeptoolchaink5 : U32
/-- 'o' (111). -/
@[extern c inline "((uint32_t)111)"] public axiom keeptoolchaink6 : U32
/-- 'o' (111). -/
@[extern c inline "((uint32_t)111)"] public axiom keeptoolchaink7 : U32
/-- 'l' (108). -/
@[extern c inline "((uint32_t)108)"] public axiom keeptoolchaink8 : U32
/-- 'c' (99). -/
@[extern c inline "((uint32_t)99)"] public axiom keeptoolchaink9 : U32
/-- 'h' (104). -/
@[extern c inline "((uint32_t)104)"] public axiom keeptoolchaink10 : U32
/-- 'a' (97). -/
@[extern c inline "((uint32_t)97)"] public axiom keeptoolchaink11 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom keeptoolchaink12 : U32
/-- 'n' (110). -/
@[extern c inline "((uint32_t)110)"] public axiom keeptoolchaink13 : U32

/-- Key length for `allow-empty` (11). Lake long-option stem (`CLI/Main.lean` `| "--allow-empty" =>`); key without leading `--`. Exact len-11. -/
@[extern c inline "((size_t)11)"] public axiom allowemptykKeyLen : USize
/-- 'a' (97). -/
@[extern c inline "((uint32_t)97)"] public axiom allowemptyk0 : U32
/-- 'l' (108). -/
@[extern c inline "((uint32_t)108)"] public axiom allowemptyk1 : U32
/-- 'l' (108). -/
@[extern c inline "((uint32_t)108)"] public axiom allowemptyk2 : U32
/-- 'o' (111). -/
@[extern c inline "((uint32_t)111)"] public axiom allowemptyk3 : U32
/-- 'w' (119). -/
@[extern c inline "((uint32_t)119)"] public axiom allowemptyk4 : U32
/-- '-' (45). -/
@[extern c inline "((uint32_t)45)"] public axiom allowemptyk5 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom allowemptyk6 : U32
/-- 'm' (109). -/
@[extern c inline "((uint32_t)109)"] public axiom allowemptyk7 : U32
/-- 'p' (112). -/
@[extern c inline "((uint32_t)112)"] public axiom allowemptyk8 : U32
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom allowemptyk9 : U32
/-- 'y' (121). -/
@[extern c inline "((uint32_t)121)"] public axiom allowemptyk10 : U32

/-- Key length for `max-revs` (8). Lake long-option stem (`CLI/Main.lean` `| "--max-revs" =>`); key without leading `--`. Exact len-8 — distinct from more exact len-3 `rev`. -/
@[extern c inline "((size_t)8)"] public axiom maxrevskKeyLen : USize
/-- 'm' (109). -/
@[extern c inline "((uint32_t)109)"] public axiom maxrevsk0 : U32
/-- 'a' (97). -/
@[extern c inline "((uint32_t)97)"] public axiom maxrevsk1 : U32
/-- 'x' (120). -/
@[extern c inline "((uint32_t)120)"] public axiom maxrevsk2 : U32
/-- '-' (45). -/
@[extern c inline "((uint32_t)45)"] public axiom maxrevsk3 : U32
/-- 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom maxrevsk4 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom maxrevsk5 : U32
/-- 'v' (118). -/
@[extern c inline "((uint32_t)118)"] public axiom maxrevsk6 : U32
/-- 's' (115). -/
@[extern c inline "((uint32_t)115)"] public axiom maxrevsk7 : U32

/-- Key length for `log-level` (9). Lake long-option stem (`CLI/Main.lean` `| "--log-level" =>`); key without leading `--`. Exact len-9 — distinct from more61 exact len-4 `info` (`hasInfo` value token). -/
@[extern c inline "((size_t)9)"] public axiom loglevelkKeyLen : USize
/-- 'l' (108). -/
@[extern c inline "((uint32_t)108)"] public axiom loglevelk0 : U32
/-- 'o' (111). -/
@[extern c inline "((uint32_t)111)"] public axiom loglevelk1 : U32
/-- 'g' (103). -/
@[extern c inline "((uint32_t)103)"] public axiom loglevelk2 : U32
/-- '-' (45). -/
@[extern c inline "((uint32_t)45)"] public axiom loglevelk3 : U32
/-- 'l' (108). -/
@[extern c inline "((uint32_t)108)"] public axiom loglevelk4 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom loglevelk5 : U32
/-- 'v' (118). -/
@[extern c inline "((uint32_t)118)"] public axiom loglevelk6 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom loglevelk7 : U32
/-- 'l' (108). -/
@[extern c inline "((uint32_t)108)"] public axiom loglevelk8 : U32

/-- Key length for `fail-level` (10). Lake long-option stem (`CLI/Main.lean` `| "--fail-level" =>`); key without leading `--`. Exact len-10. -/
@[extern c inline "((size_t)10)"] public axiom faillevelkKeyLen : USize
/-- 'f' (102). -/
@[extern c inline "((uint32_t)102)"] public axiom faillevelk0 : U32
/-- 'a' (97). -/
@[extern c inline "((uint32_t)97)"] public axiom faillevelk1 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom faillevelk2 : U32
/-- 'l' (108). -/
@[extern c inline "((uint32_t)108)"] public axiom faillevelk3 : U32
/-- '-' (45). -/
@[extern c inline "((uint32_t)45)"] public axiom faillevelk4 : U32
/-- 'l' (108). -/
@[extern c inline "((uint32_t)108)"] public axiom faillevelk5 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom faillevelk6 : U32
/-- 'v' (118). -/
@[extern c inline "((uint32_t)118)"] public axiom faillevelk7 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom faillevelk8 : U32
/-- 'l' (108). -/
@[extern c inline "((uint32_t)108)"] public axiom faillevelk9 : U32

/-- Key length for `no-ansi` (7). Lake long-option stem (`CLI/Main.lean` `| "--no-ansi" =>`); key without leading `--`. Exact len-7 — distinct from free bare `ansi` (4). -/
@[extern c inline "((size_t)7)"] public axiom noansikKeyLen : USize
/-- 'n' (110). -/
@[extern c inline "((uint32_t)110)"] public axiom noansik0 : U32
/-- 'o' (111). -/
@[extern c inline "((uint32_t)111)"] public axiom noansik1 : U32
/-- '-' (45). -/
@[extern c inline "((uint32_t)45)"] public axiom noansik2 : U32
/-- 'a' (97). -/
@[extern c inline "((uint32_t)97)"] public axiom noansik3 : U32
/-- 'n' (110). -/
@[extern c inline "((uint32_t)110)"] public axiom noansik4 : U32
/-- 's' (115). -/
@[extern c inline "((uint32_t)115)"] public axiom noansik5 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom noansik6 : U32

/-- Key length for `reconfigure` (11). Lake long-option stem (`CLI/Main.lean` `| "--reconfigure" =>`; short `-R` in `lakeShortOption`); key without leading `--`. Exact len-11. -/
@[extern c inline "((size_t)11)"] public axiom reconfigurekKeyLen : USize
/-- 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom reconfigurek0 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom reconfigurek1 : U32
/-- 'c' (99). -/
@[extern c inline "((uint32_t)99)"] public axiom reconfigurek2 : U32
/-- 'o' (111). -/
@[extern c inline "((uint32_t)111)"] public axiom reconfigurek3 : U32
/-- 'n' (110). -/
@[extern c inline "((uint32_t)110)"] public axiom reconfigurek4 : U32
/-- 'f' (102). -/
@[extern c inline "((uint32_t)102)"] public axiom reconfigurek5 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom reconfigurek6 : U32
/-- 'g' (103). -/
@[extern c inline "((uint32_t)103)"] public axiom reconfigurek7 : U32
/-- 'u' (117). -/
@[extern c inline "((uint32_t)117)"] public axiom reconfigurek8 : U32
/-- 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom reconfigurek9 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom reconfigurek10 : U32

/-- Key length for `quiet` (5). Lake long-option stem (`CLI/Main.lean` `| "--quiet" =>`); key without leading `--`. Exact len-5 — reverse peer `verbose` (7). -/
@[extern c inline "((size_t)5)"] public axiom quietkKeyLen : USize
/-- 'q' (113). -/
@[extern c inline "((uint32_t)113)"] public axiom quietk0 : U32
/-- 'u' (117). -/
@[extern c inline "((uint32_t)117)"] public axiom quietk1 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom quietk2 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom quietk3 : U32
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom quietk4 : U32

/-- Key length for `verbose` (7). Lake long-option stem (`CLI/Main.lean` `| "--verbose" =>`); key without leading `--`. Exact len-7 — reverse peer `quiet` (5). -/
@[extern c inline "((size_t)7)"] public axiom verbosekKeyLen : USize
/-- 'v' (118). -/
@[extern c inline "((uint32_t)118)"] public axiom verbosek0 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom verbosek1 : U32
/-- 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom verbosek2 : U32
/-- 'b' (98). -/
@[extern c inline "((uint32_t)98)"] public axiom verbosek3 : U32
/-- 'o' (111). -/
@[extern c inline "((uint32_t)111)"] public axiom verbosek4 : U32
/-- 's' (115). -/
@[extern c inline "((uint32_t)115)"] public axiom verbosek5 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom verbosek6 : U32

/-- Key length for `offline` (7). Lake long-option stem (`CLI/Main.lean` `| "--offline" =>`); key without leading `--`. Exact len-7 — reverse peers `platform` (8) / `toolchain` (9). -/
@[extern c inline "((size_t)7)"] public axiom offlinekKeyLen : USize
/-- 'o' (111). -/
@[extern c inline "((uint32_t)111)"] public axiom offlinek0 : U32
/-- 'f' (102). -/
@[extern c inline "((uint32_t)102)"] public axiom offlinek1 : U32
/-- 'f' (102). -/
@[extern c inline "((uint32_t)102)"] public axiom offlinek2 : U32
/-- 'l' (108). -/
@[extern c inline "((uint32_t)108)"] public axiom offlinek3 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom offlinek4 : U32
/-- 'n' (110). -/
@[extern c inline "((uint32_t)110)"] public axiom offlinek5 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom offlinek6 : U32

/-- Key length for `platform` (8). Lake long-option stem (`CLI/Main.lean` `| "--platform" =>`); key without leading `--`. Exact len-8 — distinct from more4 camel `platformIndependent` (`hasPlatformIndependent`). -/
@[extern c inline "((size_t)8)"] public axiom platformkKeyLen : USize
/-- 'p' (112). -/
@[extern c inline "((uint32_t)112)"] public axiom platformk0 : U32
/-- 'l' (108). -/
@[extern c inline "((uint32_t)108)"] public axiom platformk1 : U32
/-- 'a' (97). -/
@[extern c inline "((uint32_t)97)"] public axiom platformk2 : U32
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom platformk3 : U32
/-- 'f' (102). -/
@[extern c inline "((uint32_t)102)"] public axiom platformk4 : U32
/-- 'o' (111). -/
@[extern c inline "((uint32_t)111)"] public axiom platformk5 : U32
/-- 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom platformk6 : U32
/-- 'm' (109). -/
@[extern c inline "((uint32_t)109)"] public axiom platformk7 : U32

/-- Key length for `toolchain` (9). Lake long-option stem (`CLI/Main.lean` `| "--toolchain" =>`); key without leading `--`. Exact len-9 — distinct from more81 `keep-toolchain` (14) / more19 camel `fixedToolchain` (14). -/
@[extern c inline "((size_t)9)"] public axiom toolchainkKeyLen : USize
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom toolchaink0 : U32
/-- 'o' (111). -/
@[extern c inline "((uint32_t)111)"] public axiom toolchaink1 : U32
/-- 'o' (111). -/
@[extern c inline "((uint32_t)111)"] public axiom toolchaink2 : U32
/-- 'l' (108). -/
@[extern c inline "((uint32_t)108)"] public axiom toolchaink3 : U32
/-- 'c' (99). -/
@[extern c inline "((uint32_t)99)"] public axiom toolchaink4 : U32
/-- 'h' (104). -/
@[extern c inline "((uint32_t)104)"] public axiom toolchaink5 : U32
/-- 'a' (97). -/
@[extern c inline "((uint32_t)97)"] public axiom toolchaink6 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom toolchaink7 : U32
/-- 'n' (110). -/
@[extern c inline "((uint32_t)110)"] public axiom toolchaink8 : U32

/-- Key length for `wfail` (5). Lake long-option stem (`CLI/Main.lean` `| "--wfail" =>`); key without leading `--`. Exact len-5 — reverse peers `iofail` (6) / `ansi` (4) / more82 `fail-level` (`hasFailLevel`). -/
@[extern c inline "((size_t)5)"] public axiom wfailkKeyLen : USize
/-- 'w' (119). -/
@[extern c inline "((uint32_t)119)"] public axiom wfailk0 : U32
/-- 'f' (102). -/
@[extern c inline "((uint32_t)102)"] public axiom wfailk1 : U32
/-- 'a' (97). -/
@[extern c inline "((uint32_t)97)"] public axiom wfailk2 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom wfailk3 : U32
/-- 'l' (108). -/
@[extern c inline "((uint32_t)108)"] public axiom wfailk4 : U32

/-- Key length for `iofail` (6). Lake long-option stem (`CLI/Main.lean` `| "--iofail" =>`); key without leading `--`. Exact len-6 — reverse peers `wfail` (5) / `ansi` (4) / more82 `fail-level` (`hasFailLevel`). -/
@[extern c inline "((size_t)6)"] public axiom iofailkKeyLen : USize
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom iofailk0 : U32
/-- 'o' (111). -/
@[extern c inline "((uint32_t)111)"] public axiom iofailk1 : U32
/-- 'f' (102). -/
@[extern c inline "((uint32_t)102)"] public axiom iofailk2 : U32
/-- 'a' (97). -/
@[extern c inline "((uint32_t)97)"] public axiom iofailk3 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom iofailk4 : U32
/-- 'l' (108). -/
@[extern c inline "((uint32_t)108)"] public axiom iofailk5 : U32

/-- Key length for `ansi` (4). Lake long-option stem (`CLI/Main.lean` `| "--ansi" =>`); key without leading `--`. Exact len-4 — reverse peer more82 `no-ansi` (`hasNoAnsi` len-7). -/
@[extern c inline "((size_t)4)"] public axiom ansikKeyLen : USize
/-- 'a' (97). -/
@[extern c inline "((uint32_t)97)"] public axiom ansik0 : U32
/-- 'n' (110). -/
@[extern c inline "((uint32_t)110)"] public axiom ansik1 : U32
/-- 's' (115). -/
@[extern c inline "((uint32_t)115)"] public axiom ansik2 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom ansik3 : U32

/-- Key length for `force` (5). Lake long-option stem (`CLI/Main.lean` `| "--force" =>`); key without leading `--`. Exact len-5 — reverse peers more76 `force-download` (`hasForceDownload` len-14) / more77 `force-overwrite` (`hasForceOverwrite` len-15) / trio `fix`/`only`. -/
@[extern c inline "((size_t)5)"] public axiom forcekKeyLen : USize
/-- 'f' (102). -/
@[extern c inline "((uint32_t)102)"] public axiom forcek0 : U32
/-- 'o' (111). -/
@[extern c inline "((uint32_t)111)"] public axiom forcek1 : U32
/-- 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom forcek2 : U32
/-- 'c' (99). -/
@[extern c inline "((uint32_t)99)"] public axiom forcek3 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom forcek4 : U32

/-- Key length for `fix` (3). Lake long-option stem (`CLI/Main.lean` `| "--fix" =>`); key without leading `--`. Exact len-3 — reverse peers `force` (5) / `only` (4). -/
@[extern c inline "((size_t)3)"] public axiom fixkKeyLen : USize
/-- 'f' (102). -/
@[extern c inline "((uint32_t)102)"] public axiom fixk0 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom fixk1 : U32
/-- 'x' (120). -/
@[extern c inline "((uint32_t)120)"] public axiom fixk2 : U32

/-- Key length for `only` (4). Lake long-option stem (`CLI/Main.lean` `| "--only" =>`); key without leading `--`. Exact len-4 — reverse peers more76 `mappings-only` (`hasMappingsOnly` len-13) / more80 `builtin-only` (`hasBuiltinOnly` len-12) / more80 `lint-only` (`hasLintOnly` len-9) / trio `force`/`fix`. -/
@[extern c inline "((size_t)4)"] public axiom onlykKeyLen : USize
/-- 'o' (111). -/
@[extern c inline "((uint32_t)111)"] public axiom onlyk0 : U32
/-- 'n' (110). -/
@[extern c inline "((uint32_t)110)"] public axiom onlyk1 : U32
/-- 'l' (108). -/
@[extern c inline "((uint32_t)108)"] public axiom onlyk2 : U32
/-- 'y' (121). -/
@[extern c inline "((uint32_t)121)"] public axiom onlyk3 : U32

/-- Key length for `trace` (5). Lake long-option stem (`CLI/Main.lean` `| "--trace" =>`); key without leading `--`. Exact len-5 — reverse peers more56 `traceArgs` (`hasTraceArgs` len-9) / trio `old`/`json`. -/
@[extern c inline "((size_t)5)"] public axiom tracekKeyLen : USize
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom tracek0 : U32
/-- 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom tracek1 : U32
/-- 'a' (97). -/
@[extern c inline "((uint32_t)97)"] public axiom tracek2 : U32
/-- 'c' (99). -/
@[extern c inline "((uint32_t)99)"] public axiom tracek3 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom tracek4 : U32

/-- Key length for `old` (3). Lake long-option stem (`CLI/Main.lean` `| "--old" =>`); key without leading `--`. Exact len-3 — reverse peers `trace` (5) / `json` (4). -/
@[extern c inline "((size_t)3)"] public axiom oldkKeyLen : USize
/-- 'o' (111). -/
@[extern c inline "((uint32_t)111)"] public axiom oldk0 : U32
/-- 'l' (108). -/
@[extern c inline "((uint32_t)108)"] public axiom oldk1 : U32
/-- 'd' (100). -/
@[extern c inline "((uint32_t)100)"] public axiom oldk2 : U32

/-- Key length for `json` (4). Lake long-option stem (`CLI/Main.lean` `| "--json" =>`); key without leading `--`. Exact len-4 — reverse peers more36 `text` (`hasText` len-4 outFormat peer) / trio `trace`/`old`. -/
@[extern c inline "((size_t)4)"] public axiom jsonkKeyLen : USize
/-- 'j' (106). -/
@[extern c inline "((uint32_t)106)"] public axiom jsonk0 : U32
/-- 's' (115). -/
@[extern c inline "((uint32_t)115)"] public axiom jsonk1 : U32
/-- 'o' (111). -/
@[extern c inline "((uint32_t)111)"] public axiom jsonk2 : U32
/-- 'n' (110). -/
@[extern c inline "((uint32_t)110)"] public axiom jsonk3 : U32

/-- Key length for `linters` (7). Lake long-option stem (`CLI/Main.lean` `| "--linters" =>`); key without leading `--`. Exact len-7 — reverse peers trio `linter` (6) / `builtin-lint` (12); ≠ more64 `lint` (4) / more80 `lint-only` (9). -/
@[extern c inline "((size_t)7)"] public axiom linterskKeyLen : USize
/-- 'l' (108). -/
@[extern c inline "((uint32_t)108)"] public axiom lintersk0 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom lintersk1 : U32
/-- 'n' (110). -/
@[extern c inline "((uint32_t)110)"] public axiom lintersk2 : U32
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom lintersk3 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom lintersk4 : U32
/-- 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom lintersk5 : U32
/-- 's' (115). -/
@[extern c inline "((uint32_t)115)"] public axiom lintersk6 : U32

/-- Key length for `builtin-lint` (12). Lake long-option stem (`CLI/Main.lean` `| "--builtin-lint" =>`); key without leading `--`. Exact len-12 — `*Cli` name like more74 `version-tags` / `hasVersionTagsCli`; reverse peers more20 camel `builtinLint` (`hasBuiltinLint` len-11) / more80 `builtin-only` (`hasBuiltinOnly` len-12 content peer) / trio `linters`/`linter`. -/
@[extern c inline "((size_t)12)"] public axiom builtinlintclikKeyLen : USize
/-- 'b' (98). -/
@[extern c inline "((uint32_t)98)"] public axiom builtinlintclik0 : U32
/-- 'u' (117). -/
@[extern c inline "((uint32_t)117)"] public axiom builtinlintclik1 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom builtinlintclik2 : U32
/-- 'l' (108). -/
@[extern c inline "((uint32_t)108)"] public axiom builtinlintclik3 : U32
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom builtinlintclik4 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom builtinlintclik5 : U32
/-- 'n' (110). -/
@[extern c inline "((uint32_t)110)"] public axiom builtinlintclik6 : U32
/-- '-' (45). -/
@[extern c inline "((uint32_t)45)"] public axiom builtinlintclik7 : U32
/-- 'l' (108). -/
@[extern c inline "((uint32_t)108)"] public axiom builtinlintclik8 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom builtinlintclik9 : U32
/-- 'n' (110). -/
@[extern c inline "((uint32_t)110)"] public axiom builtinlintclik10 : U32
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom builtinlintclik11 : U32

/-- Key length for `linter` (6). Lake greppable identity token (`CLI/Main.lean` `parseLintersSpec` `"linter" ++ s`); key without leading `--`. Exact len-6 — reverse peers trio `linters` (7) / `builtin-lint` (12); ≠ more64 `lint` (4) / more80 `lint-only` (9); prefix of `linters` kept distinct by exact-len. -/
@[extern c inline "((size_t)6)"] public axiom linterkKeyLen : USize
/-- 'l' (108). -/
@[extern c inline "((uint32_t)108)"] public axiom linterk0 : U32
/-- 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom linterk1 : U32
/-- 'n' (110). -/
@[extern c inline "((uint32_t)110)"] public axiom linterk2 : U32
/-- 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom linterk3 : U32
/-- 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom linterk4 : U32
/-- 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom linterk5 : U32

/-- Key `bootstrap` length (9). -/
@[extern c inline "((size_t)9)"] public axiom bootstrapKeyLen : USize
/-- `'b'` (98). -/
@[extern c inline "((uint32_t)98)"] public axiom bs0 : U32
/-- `'o'` (111). -/
@[extern c inline "((uint32_t)111)"] public axiom bs1 : U32
/-- `'o'` (111). -/
@[extern c inline "((uint32_t)111)"] public axiom bs2 : U32
/-- `'t'` (116). -/
@[extern c inline "((uint32_t)116)"] public axiom bs3 : U32
/-- `'s'` (115). -/
@[extern c inline "((uint32_t)115)"] public axiom bs4 : U32
/-- `'t'` (116). -/
@[extern c inline "((uint32_t)116)"] public axiom bs5 : U32
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom bs6 : U32
/-- `'a'` (97). -/
@[extern c inline "((uint32_t)97)"] public axiom bs7 : U32
/-- `'p'` (112). -/
@[extern c inline "((uint32_t)112)"] public axiom bs8 : U32

/-- Key `moreServerArgs` length (14). -/
@[extern c inline "((size_t)14)"] public axiom moreServerArgsKeyLen : USize
/-- `'m'` (109). -/
@[extern c inline "((uint32_t)109)"] public axiom msa0 : U32
/-- `'o'` (111). -/
@[extern c inline "((uint32_t)111)"] public axiom msa1 : U32
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom msa2 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom msa3 : U32
/-- `'S'` (83). -/
@[extern c inline "((uint32_t)83)"] public axiom msa4 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom msa5 : U32
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom msa6 : U32
/-- `'v'` (118). -/
@[extern c inline "((uint32_t)118)"] public axiom msa7 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom msa8 : U32
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom msa9 : U32
/-- `'A'` (65). -/
@[extern c inline "((uint32_t)65)"] public axiom msa10 : U32
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom msa11 : U32
/-- `'g'` (103). -/
@[extern c inline "((uint32_t)103)"] public axiom msa12 : U32
/-- `'s'` (115). -/
@[extern c inline "((uint32_t)115)"] public axiom msa13 : U32

/-- Key `releaseRepo` length (11). -/
@[extern c inline "((size_t)11)"] public axiom releaseRepoKeyLen : USize
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom rr0 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom rr1 : U32
/-- `'l'` (108). -/
@[extern c inline "((uint32_t)108)"] public axiom rr2 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom rr3 : U32
/-- `'a'` (97). -/
@[extern c inline "((uint32_t)97)"] public axiom rr4 : U32
/-- `'s'` (115). -/
@[extern c inline "((uint32_t)115)"] public axiom rr5 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom rr6 : U32
/-- `'R'` (82). -/
@[extern c inline "((uint32_t)82)"] public axiom rr7 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom rr8 : U32
/-- `'p'` (112). -/
@[extern c inline "((uint32_t)112)"] public axiom rr9 : U32
/-- `'o'` (111). -/
@[extern c inline "((uint32_t)111)"] public axiom rr10 : U32

/-- Key `leanLibDir` length (10). -/
@[extern c inline "((size_t)10)"] public axiom leanLibDirKeyLen : USize
/-- `'l'` (108). -/
@[extern c inline "((uint32_t)108)"] public axiom lld0 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom lld1 : U32
/-- `'a'` (97). -/
@[extern c inline "((uint32_t)97)"] public axiom lld2 : U32
/-- `'n'` (110). -/
@[extern c inline "((uint32_t)110)"] public axiom lld3 : U32
/-- `'L'` (76). -/
@[extern c inline "((uint32_t)76)"] public axiom lld4 : U32
/-- `'i'` (105). -/
@[extern c inline "((uint32_t)105)"] public axiom lld5 : U32
/-- `'b'` (98). -/
@[extern c inline "((uint32_t)98)"] public axiom lld6 : U32
/-- `'D'` (68). -/
@[extern c inline "((uint32_t)68)"] public axiom lld7 : U32
/-- `'i'` (105). -/
@[extern c inline "((uint32_t)105)"] public axiom lld8 : U32
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom lld9 : U32

/-- Key `binDir` length (6). -/
@[extern c inline "((size_t)6)"] public axiom binDirKeyLen : USize
/-- `'b'` (98). -/
@[extern c inline "((uint32_t)98)"] public axiom bd0 : U32
/-- `'i'` (105). -/
@[extern c inline "((uint32_t)105)"] public axiom bd1 : U32
/-- `'n'` (110). -/
@[extern c inline "((uint32_t)110)"] public axiom bd2 : U32
/-- `'D'` (68). -/
@[extern c inline "((uint32_t)68)"] public axiom bd3 : U32
/-- `'i'` (105). -/
@[extern c inline "((uint32_t)105)"] public axiom bd4 : U32
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom bd5 : U32

/-- Key `irDir` length (5). -/
@[extern c inline "((size_t)5)"] public axiom irDirKeyLen : USize
/-- `'i'` (105). -/
@[extern c inline "((uint32_t)105)"] public axiom id0 : U32
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom id1 : U32
/-- `'D'` (68). -/
@[extern c inline "((uint32_t)68)"] public axiom id2 : U32
/-- `'i'` (105). -/
@[extern c inline "((uint32_t)105)"] public axiom id3 : U32
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom id4 : U32

/-- Key `extraDepTargets` length (15). -/
@[extern c inline "((size_t)15)"] public axiom extraDepTargetsKeyLen : USize
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom edt0 : U32
/-- `'x'` (120). -/
@[extern c inline "((uint32_t)120)"] public axiom edt1 : U32
/-- `'t'` (116). -/
@[extern c inline "((uint32_t)116)"] public axiom edt2 : U32
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom edt3 : U32
/-- `'a'` (97). -/
@[extern c inline "((uint32_t)97)"] public axiom edt4 : U32
/-- `'D'` (68). -/
@[extern c inline "((uint32_t)68)"] public axiom edt5 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom edt6 : U32
/-- `'p'` (112). -/
@[extern c inline "((uint32_t)112)"] public axiom edt7 : U32
/-- `'T'` (84). -/
@[extern c inline "((uint32_t)84)"] public axiom edt8 : U32
/-- `'a'` (97). -/
@[extern c inline "((uint32_t)97)"] public axiom edt9 : U32
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom edt10 : U32
/-- `'g'` (103). -/
@[extern c inline "((uint32_t)103)"] public axiom edt11 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom edt12 : U32
/-- `'t'` (116). -/
@[extern c inline "((uint32_t)116)"] public axiom edt13 : U32
/-- `'s'` (115). -/
@[extern c inline "((uint32_t)115)"] public axiom edt14 : U32

/-- Key `restoreAllArtifacts` length (19). -/
@[extern c inline "((size_t)19)"] public axiom restoreAllArtifactsKeyLen : USize
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom raa0 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom raa1 : U32
/-- `'s'` (115). -/
@[extern c inline "((uint32_t)115)"] public axiom raa2 : U32
/-- `'t'` (116). -/
@[extern c inline "((uint32_t)116)"] public axiom raa3 : U32
/-- `'o'` (111). -/
@[extern c inline "((uint32_t)111)"] public axiom raa4 : U32
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom raa5 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom raa6 : U32
/-- `'A'` (65). -/
@[extern c inline "((uint32_t)65)"] public axiom raa7 : U32
/-- `'l'` (108). -/
@[extern c inline "((uint32_t)108)"] public axiom raa8 : U32
/-- `'l'` (108). -/
@[extern c inline "((uint32_t)108)"] public axiom raa9 : U32
/-- `'A'` (65). -/
@[extern c inline "((uint32_t)65)"] public axiom raa10 : U32
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom raa11 : U32
/-- `'t'` (116). -/
@[extern c inline "((uint32_t)116)"] public axiom raa12 : U32
/-- `'i'` (105). -/
@[extern c inline "((uint32_t)105)"] public axiom raa13 : U32
/-- `'f'` (102). -/
@[extern c inline "((uint32_t)102)"] public axiom raa14 : U32
/-- `'a'` (97). -/
@[extern c inline "((uint32_t)97)"] public axiom raa15 : U32
/-- `'c'` (99). -/
@[extern c inline "((uint32_t)99)"] public axiom raa16 : U32
/-- `'t'` (116). -/
@[extern c inline "((uint32_t)116)"] public axiom raa17 : U32
/-- `'s'` (115). -/
@[extern c inline "((uint32_t)115)"] public axiom raa18 : U32

/-- Key `libPrefixOnWindows` length (18). -/
@[extern c inline "((size_t)18)"] public axiom libPrefixOnWindowsKeyLen : USize
/-- `'l'` (108). -/
@[extern c inline "((uint32_t)108)"] public axiom lpw0 : U32
/-- `'i'` (105). -/
@[extern c inline "((uint32_t)105)"] public axiom lpw1 : U32
/-- `'b'` (98). -/
@[extern c inline "((uint32_t)98)"] public axiom lpw2 : U32
/-- `'P'` (80). -/
@[extern c inline "((uint32_t)80)"] public axiom lpw3 : U32
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom lpw4 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom lpw5 : U32
/-- `'f'` (102). -/
@[extern c inline "((uint32_t)102)"] public axiom lpw6 : U32
/-- `'i'` (105). -/
@[extern c inline "((uint32_t)105)"] public axiom lpw7 : U32
/-- `'x'` (120). -/
@[extern c inline "((uint32_t)120)"] public axiom lpw8 : U32
/-- `'O'` (79). -/
@[extern c inline "((uint32_t)79)"] public axiom lpw9 : U32
/-- `'n'` (110). -/
@[extern c inline "((uint32_t)110)"] public axiom lpw10 : U32
/-- `'W'` (87). -/
@[extern c inline "((uint32_t)87)"] public axiom lpw11 : U32
/-- `'i'` (105). -/
@[extern c inline "((uint32_t)105)"] public axiom lpw12 : U32
/-- `'n'` (110). -/
@[extern c inline "((uint32_t)110)"] public axiom lpw13 : U32
/-- `'d'` (100). -/
@[extern c inline "((uint32_t)100)"] public axiom lpw14 : U32
/-- `'o'` (111). -/
@[extern c inline "((uint32_t)111)"] public axiom lpw15 : U32
/-- `'w'` (119). -/
@[extern c inline "((uint32_t)119)"] public axiom lpw16 : U32
/-- `'s'` (115). -/
@[extern c inline "((uint32_t)115)"] public axiom lpw17 : U32


/-- Key `allowImportAll` length (14). -/
@[extern c inline "((size_t)14)"] public axiom allowImportAllKeyLen : USize
/-- `'a'` (97). -/
@[extern c inline "((uint32_t)97)"] public axiom aia0 : U32
/-- `'l'` (108). -/
@[extern c inline "((uint32_t)108)"] public axiom aia1 : U32
/-- `'l'` (108). -/
@[extern c inline "((uint32_t)108)"] public axiom aia2 : U32
/-- `'o'` (111). -/
@[extern c inline "((uint32_t)111)"] public axiom aia3 : U32
/-- `'w'` (119). -/
@[extern c inline "((uint32_t)119)"] public axiom aia4 : U32
/-- `'I'` (73). -/
@[extern c inline "((uint32_t)73)"] public axiom aia5 : U32
/-- `'m'` (109). -/
@[extern c inline "((uint32_t)109)"] public axiom aia6 : U32
/-- `'p'` (112). -/
@[extern c inline "((uint32_t)112)"] public axiom aia7 : U32
/-- `'o'` (111). -/
@[extern c inline "((uint32_t)111)"] public axiom aia8 : U32
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom aia9 : U32
/-- `'t'` (116). -/
@[extern c inline "((uint32_t)116)"] public axiom aia10 : U32
/-- `'A'` (65). -/
@[extern c inline "((uint32_t)65)"] public axiom aia11 : U32
/-- `'l'` (108). -/
@[extern c inline "((uint32_t)108)"] public axiom aia12 : U32
/-- `'l'` (108). -/
@[extern c inline "((uint32_t)108)"] public axiom aia13 : U32

/-- Key `fixedToolchain` length (14). -/
@[extern c inline "((size_t)14)"] public axiom fixedToolchainKeyLen : USize
/-- `'f'` (102). -/
@[extern c inline "((uint32_t)102)"] public axiom ft0 : U32
/-- `'i'` (105). -/
@[extern c inline "((uint32_t)105)"] public axiom ft1 : U32
/-- `'x'` (120). -/
@[extern c inline "((uint32_t)120)"] public axiom ft2 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom ft3 : U32
/-- `'d'` (100). -/
@[extern c inline "((uint32_t)100)"] public axiom ft4 : U32
/-- `'T'` (84). -/
@[extern c inline "((uint32_t)84)"] public axiom ft5 : U32
/-- `'o'` (111). -/
@[extern c inline "((uint32_t)111)"] public axiom ft6 : U32
/-- `'o'` (111). -/
@[extern c inline "((uint32_t)111)"] public axiom ft7 : U32
/-- `'l'` (108). -/
@[extern c inline "((uint32_t)108)"] public axiom ft8 : U32
/-- `'c'` (99). -/
@[extern c inline "((uint32_t)99)"] public axiom ft9 : U32
/-- `'h'` (104). -/
@[extern c inline "((uint32_t)104)"] public axiom ft10 : U32
/-- `'a'` (97). -/
@[extern c inline "((uint32_t)97)"] public axiom ft11 : U32
/-- `'i'` (105). -/
@[extern c inline "((uint32_t)105)"] public axiom ft12 : U32
/-- `'n'` (110). -/
@[extern c inline "((uint32_t)110)"] public axiom ft13 : U32

/-- Key `builtinLint` length (11). -/
@[extern c inline "((size_t)11)"] public axiom builtinLintKeyLen : USize
/-- `'b'` (98). -/
@[extern c inline "((uint32_t)98)"] public axiom bl0 : U32
/-- `'u'` (117). -/
@[extern c inline "((uint32_t)117)"] public axiom bl1 : U32
/-- `'i'` (105). -/
@[extern c inline "((uint32_t)105)"] public axiom bl2 : U32
/-- `'l'` (108). -/
@[extern c inline "((uint32_t)108)"] public axiom bl3 : U32
/-- `'t'` (116). -/
@[extern c inline "((uint32_t)116)"] public axiom bl4 : U32
/-- `'i'` (105). -/
@[extern c inline "((uint32_t)105)"] public axiom bl5 : U32
/-- `'n'` (110). -/
@[extern c inline "((uint32_t)110)"] public axiom bl6 : U32
/-- `'L'` (76). -/
@[extern c inline "((uint32_t)76)"] public axiom bl7 : U32
/-- `'i'` (105). -/
@[extern c inline "((uint32_t)105)"] public axiom bl8 : U32
/-- `'n'` (110). -/
@[extern c inline "((uint32_t)110)"] public axiom bl9 : U32
/-- `'t'` (116). -/
@[extern c inline "((uint32_t)116)"] public axiom bl10 : U32

/-- Key `moreLeancArgs` length (13). -/
@[extern c inline "((size_t)13)"] public axiom moreLeancArgsKeyLen : USize
/-- `'m'` (109). -/
@[extern c inline "((uint32_t)109)"] public axiom mlc0 : U32
/-- `'o'` (111). -/
@[extern c inline "((uint32_t)111)"] public axiom mlc1 : U32
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom mlc2 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom mlc3 : U32
/-- `'L'` (76). -/
@[extern c inline "((uint32_t)76)"] public axiom mlc4 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom mlc5 : U32
/-- `'a'` (97). -/
@[extern c inline "((uint32_t)97)"] public axiom mlc6 : U32
/-- `'n'` (110). -/
@[extern c inline "((uint32_t)110)"] public axiom mlc7 : U32
/-- `'c'` (99). -/
@[extern c inline "((uint32_t)99)"] public axiom mlc8 : U32
/-- `'A'` (65). -/
@[extern c inline "((uint32_t)65)"] public axiom mlc9 : U32
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom mlc10 : U32
/-- `'g'` (103). -/
@[extern c inline "((uint32_t)103)"] public axiom mlc11 : U32
/-- `'s'` (115). -/
@[extern c inline "((uint32_t)115)"] public axiom mlc12 : U32

/-- Key `allowNonModules` length (15). -/
@[extern c inline "((size_t)15)"] public axiom allowNonModulesKeyLen : USize
/-- `'a'` (97). -/
@[extern c inline "((uint32_t)97)"] public axiom anm0 : U32
/-- `'l'` (108). -/
@[extern c inline "((uint32_t)108)"] public axiom anm1 : U32
/-- `'l'` (108). -/
@[extern c inline "((uint32_t)108)"] public axiom anm2 : U32
/-- `'o'` (111). -/
@[extern c inline "((uint32_t)111)"] public axiom anm3 : U32
/-- `'w'` (119). -/
@[extern c inline "((uint32_t)119)"] public axiom anm4 : U32
/-- `'N'` (78). -/
@[extern c inline "((uint32_t)78)"] public axiom anm5 : U32
/-- `'o'` (111). -/
@[extern c inline "((uint32_t)111)"] public axiom anm6 : U32
/-- `'n'` (110). -/
@[extern c inline "((uint32_t)110)"] public axiom anm7 : U32
/-- `'M'` (77). -/
@[extern c inline "((uint32_t)77)"] public axiom anm8 : U32
/-- `'o'` (111). -/
@[extern c inline "((uint32_t)111)"] public axiom anm9 : U32
/-- `'d'` (100). -/
@[extern c inline "((uint32_t)100)"] public axiom anm10 : U32
/-- `'u'` (117). -/
@[extern c inline "((uint32_t)117)"] public axiom anm11 : U32
/-- `'l'` (108). -/
@[extern c inline "((uint32_t)108)"] public axiom anm12 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom anm13 : U32
/-- `'s'` (115). -/
@[extern c inline "((uint32_t)115)"] public axiom anm14 : U32

/-- Key `requiresModuleSystem` length (20). -/
@[extern c inline "((size_t)20)"] public axiom requiresModuleSystemKeyLen : USize
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom rms0 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom rms1 : U32
/-- `'q'` (113). -/
@[extern c inline "((uint32_t)113)"] public axiom rms2 : U32
/-- `'u'` (117). -/
@[extern c inline "((uint32_t)117)"] public axiom rms3 : U32
/-- `'i'` (105). -/
@[extern c inline "((uint32_t)105)"] public axiom rms4 : U32
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom rms5 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom rms6 : U32
/-- `'s'` (115). -/
@[extern c inline "((uint32_t)115)"] public axiom rms7 : U32
/-- `'M'` (77). -/
@[extern c inline "((uint32_t)77)"] public axiom rms8 : U32
/-- `'o'` (111). -/
@[extern c inline "((uint32_t)111)"] public axiom rms9 : U32
/-- `'d'` (100). -/
@[extern c inline "((uint32_t)100)"] public axiom rms10 : U32
/-- `'u'` (117). -/
@[extern c inline "((uint32_t)117)"] public axiom rms11 : U32
/-- `'l'` (108). -/
@[extern c inline "((uint32_t)108)"] public axiom rms12 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom rms13 : U32
/-- `'S'` (83). -/
@[extern c inline "((uint32_t)83)"] public axiom rms14 : U32
/-- `'y'` (121). -/
@[extern c inline "((uint32_t)121)"] public axiom rms15 : U32
/-- `'s'` (115). -/
@[extern c inline "((uint32_t)115)"] public axiom rms16 : U32
/-- `'t'` (116). -/
@[extern c inline "((uint32_t)116)"] public axiom rms17 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom rms18 : U32
/-- `'m'` (109). -/
@[extern c inline "((uint32_t)109)"] public axiom rms19 : U32

/-- Key `weakLeancArgs` length (13). -/
@[extern c inline "((size_t)13)"] public axiom weakLeancArgsKeyLen : USize
/-- `'w'` (119). -/
@[extern c inline "((uint32_t)119)"] public axiom wlc0 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom wlc1 : U32
/-- `'a'` (97). -/
@[extern c inline "((uint32_t)97)"] public axiom wlc2 : U32
/-- `'k'` (107). -/
@[extern c inline "((uint32_t)107)"] public axiom wlc3 : U32
/-- `'L'` (76). -/
@[extern c inline "((uint32_t)76)"] public axiom wlc4 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom wlc5 : U32
/-- `'a'` (97). -/
@[extern c inline "((uint32_t)97)"] public axiom wlc6 : U32
/-- `'n'` (110). -/
@[extern c inline "((uint32_t)110)"] public axiom wlc7 : U32
/-- `'c'` (99). -/
@[extern c inline "((uint32_t)99)"] public axiom wlc8 : U32
/-- `'A'` (65). -/
@[extern c inline "((uint32_t)65)"] public axiom wlc9 : U32
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom wlc10 : U32
/-- `'g'` (103). -/
@[extern c inline "((uint32_t)103)"] public axiom wlc11 : U32
/-- `'s'` (115). -/
@[extern c inline "((uint32_t)115)"] public axiom wlc12 : U32

/-- Key `moreLinkObjs` length (12). -/
@[extern c inline "((size_t)12)"] public axiom moreLinkObjsKeyLen : USize
/-- `'m'` (109). -/
@[extern c inline "((uint32_t)109)"] public axiom mlo0 : U32
/-- `'o'` (111). -/
@[extern c inline "((uint32_t)111)"] public axiom mlo1 : U32
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom mlo2 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom mlo3 : U32
/-- `'L'` (76). -/
@[extern c inline "((uint32_t)76)"] public axiom mlo4 : U32
/-- `'i'` (105). -/
@[extern c inline "((uint32_t)105)"] public axiom mlo5 : U32
/-- `'n'` (110). -/
@[extern c inline "((uint32_t)110)"] public axiom mlo6 : U32
/-- `'k'` (107). -/
@[extern c inline "((uint32_t)107)"] public axiom mlo7 : U32
/-- `'O'` (79). -/
@[extern c inline "((uint32_t)79)"] public axiom mlo8 : U32
/-- `'b'` (98). -/
@[extern c inline "((uint32_t)98)"] public axiom mlo9 : U32
/-- `'j'` (106). -/
@[extern c inline "((uint32_t)106)"] public axiom mlo10 : U32
/-- `'s'` (115). -/
@[extern c inline "((uint32_t)115)"] public axiom mlo11 : U32

/-- Key `moreLinkLibs` length (12). -/
@[extern c inline "((size_t)12)"] public axiom moreLinkLibsKeyLen : USize
/-- `'m'` (109). -/
@[extern c inline "((uint32_t)109)"] public axiom mll0 : U32
/-- `'o'` (111). -/
@[extern c inline "((uint32_t)111)"] public axiom mll1 : U32
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom mll2 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom mll3 : U32
/-- `'L'` (76). -/
@[extern c inline "((uint32_t)76)"] public axiom mll4 : U32
/-- `'i'` (105). -/
@[extern c inline "((uint32_t)105)"] public axiom mll5 : U32
/-- `'n'` (110). -/
@[extern c inline "((uint32_t)110)"] public axiom mll6 : U32
/-- `'k'` (107). -/
@[extern c inline "((uint32_t)107)"] public axiom mll7 : U32
/-- `'L'` (76). -/
@[extern c inline "((uint32_t)76)"] public axiom mll8 : U32
/-- `'i'` (105). -/
@[extern c inline "((uint32_t)105)"] public axiom mll9 : U32
/-- `'b'` (98). -/
@[extern c inline "((uint32_t)98)"] public axiom mll10 : U32
/-- `'s'` (115). -/
@[extern c inline "((uint32_t)115)"] public axiom mll11 : U32

/-- Key `dynlibs` length (7). -/
@[extern c inline "((size_t)7)"] public axiom dynlibsKeyLen : USize
/-- `'d'` (100). -/
@[extern c inline "((uint32_t)100)"] public axiom dyn0 : U32
/-- `'y'` (121). -/
@[extern c inline "((uint32_t)121)"] public axiom dyn1 : U32
/-- `'n'` (110). -/
@[extern c inline "((uint32_t)110)"] public axiom dyn2 : U32
/-- `'l'` (108). -/
@[extern c inline "((uint32_t)108)"] public axiom dyn3 : U32
/-- `'i'` (105). -/
@[extern c inline "((uint32_t)105)"] public axiom dyn4 : U32
/-- `'b'` (98). -/
@[extern c inline "((uint32_t)98)"] public axiom dyn5 : U32
/-- `'s'` (115). -/
@[extern c inline "((uint32_t)115)"] public axiom dyn6 : U32

/-- Key `plugins` length (7). -/
@[extern c inline "((size_t)7)"] public axiom pluginsKeyLen : USize
/-- `'p'` (112). -/
@[extern c inline "((uint32_t)112)"] public axiom plg0 : U32
/-- `'l'` (108). -/
@[extern c inline "((uint32_t)108)"] public axiom plg1 : U32
/-- `'u'` (117). -/
@[extern c inline "((uint32_t)117)"] public axiom plg2 : U32
/-- `'g'` (103). -/
@[extern c inline "((uint32_t)103)"] public axiom plg3 : U32
/-- `'i'` (105). -/
@[extern c inline "((uint32_t)105)"] public axiom plg4 : U32
/-- `'n'` (110). -/
@[extern c inline "((uint32_t)110)"] public axiom plg5 : U32
/-- `'s'` (115). -/
@[extern c inline "((uint32_t)115)"] public axiom plg6 : U32

/-- Key `defaultFacets` length (13). -/
@[extern c inline "((size_t)13)"] public axiom defaultFacetsKeyLen : USize
/-- `'d'` (100). -/
@[extern c inline "((uint32_t)100)"] public axiom df0 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom df1 : U32
/-- `'f'` (102). -/
@[extern c inline "((uint32_t)102)"] public axiom df2 : U32
/-- `'a'` (97). -/
@[extern c inline "((uint32_t)97)"] public axiom df3 : U32
/-- `'u'` (117). -/
@[extern c inline "((uint32_t)117)"] public axiom df4 : U32
/-- `'l'` (108). -/
@[extern c inline "((uint32_t)108)"] public axiom df5 : U32
/-- `'t'` (116). -/
@[extern c inline "((uint32_t)116)"] public axiom df6 : U32
/-- `'F'` (70). -/
@[extern c inline "((uint32_t)70)"] public axiom df7 : U32
/-- `'a'` (97). -/
@[extern c inline "((uint32_t)97)"] public axiom df8 : U32
/-- `'c'` (99). -/
@[extern c inline "((uint32_t)99)"] public axiom df9 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom df10 : U32
/-- `'t'` (116). -/
@[extern c inline "((uint32_t)116)"] public axiom df11 : U32
/-- `'s'` (115). -/
@[extern c inline "((uint32_t)115)"] public axiom df12 : U32

/-- Key `moreGlobalServerArgs` length (20). -/
@[extern c inline "((size_t)20)"] public axiom moreGlobalServerArgsKeyLen : USize
/-- `'m'` (109). -/
@[extern c inline "((uint32_t)109)"] public axiom mgs0 : U32
/-- `'o'` (111). -/
@[extern c inline "((uint32_t)111)"] public axiom mgs1 : U32
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom mgs2 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom mgs3 : U32
/-- `'G'` (71). -/
@[extern c inline "((uint32_t)71)"] public axiom mgs4 : U32
/-- `'l'` (108). -/
@[extern c inline "((uint32_t)108)"] public axiom mgs5 : U32
/-- `'o'` (111). -/
@[extern c inline "((uint32_t)111)"] public axiom mgs6 : U32
/-- `'b'` (98). -/
@[extern c inline "((uint32_t)98)"] public axiom mgs7 : U32
/-- `'a'` (97). -/
@[extern c inline "((uint32_t)97)"] public axiom mgs8 : U32
/-- `'l'` (108). -/
@[extern c inline "((uint32_t)108)"] public axiom mgs9 : U32
/-- `'S'` (83). -/
@[extern c inline "((uint32_t)83)"] public axiom mgs10 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom mgs11 : U32
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom mgs12 : U32
/-- `'v'` (118). -/
@[extern c inline "((uint32_t)118)"] public axiom mgs13 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom mgs14 : U32
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom mgs15 : U32
/-- `'A'` (65). -/
@[extern c inline "((uint32_t)65)"] public axiom mgs16 : U32
/-- `'r'` (114). -/
@[extern c inline "((uint32_t)114)"] public axiom mgs17 : U32
/-- `'g'` (103). -/
@[extern c inline "((uint32_t)103)"] public axiom mgs18 : U32
/-- `'s'` (115). -/
@[extern c inline "((uint32_t)115)"] public axiom mgs19 : U32

/-- Key `libName` length (7). -/
@[extern c inline "((size_t)7)"] public axiom libNameKeyLen : USize
/-- `'l'` (108). -/
@[extern c inline "((uint32_t)108)"] public axiom ln0 : U32
/-- `'i'` (105). -/
@[extern c inline "((uint32_t)105)"] public axiom ln1 : U32
/-- `'b'` (98). -/
@[extern c inline "((uint32_t)98)"] public axiom ln2 : U32
/-- `'N'` (78). -/
@[extern c inline "((uint32_t)78)"] public axiom ln3 : U32
/-- `'a'` (97). -/
@[extern c inline "((uint32_t)97)"] public axiom ln4 : U32
/-- `'m'` (109). -/
@[extern c inline "((uint32_t)109)"] public axiom ln5 : U32
/-- `'e'` (101). -/
@[extern c inline "((uint32_t)101)"] public axiom ln6 : U32

/-- Key `remoteUrl` length (9). -/
@[extern c inline "((size_t)9)"] public axiom remoteUrlKeyLen : USize
/-- `remoteUrl` byte0 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom ru0 : U32
/-- `remoteUrl` byte1 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom ru1 : U32
/-- `remoteUrl` byte2 'm' (109). -/
@[extern c inline "((uint32_t)109)"] public axiom ru2 : U32
/-- `remoteUrl` byte3 'o' (111). -/
@[extern c inline "((uint32_t)111)"] public axiom ru3 : U32
/-- `remoteUrl` byte4 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom ru4 : U32
/-- `remoteUrl` byte5 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom ru5 : U32
/-- `remoteUrl` byte6 'U' (85). -/
@[extern c inline "((uint32_t)85)"] public axiom ru6 : U32
/-- `remoteUrl` byte7 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom ru7 : U32
/-- `remoteUrl` byte8 'l' (108). -/
@[extern c inline "((uint32_t)108)"] public axiom ru8 : U32

/-- Key `freestanding` length (12). -/
@[extern c inline "((size_t)12)"] public axiom freestandingKeyLen : USize
/-- `freestanding` byte0 'f' (102). -/
@[extern c inline "((uint32_t)102)"] public axiom fs0 : U32
/-- `freestanding` byte1 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom fs1 : U32
/-- `freestanding` byte2 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom fs2 : U32
/-- `freestanding` byte3 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom fs3 : U32
/-- `freestanding` byte4 's' (115). -/
@[extern c inline "((uint32_t)115)"] public axiom fs4 : U32
/-- `freestanding` byte5 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom fs5 : U32
/-- `freestanding` byte6 'a' (97). -/
@[extern c inline "((uint32_t)97)"] public axiom fs6 : U32
/-- `freestanding` byte7 'n' (110). -/
@[extern c inline "((uint32_t)110)"] public axiom fs7 : U32
/-- `freestanding` byte8 'd' (100). -/
@[extern c inline "((uint32_t)100)"] public axiom fs8 : U32
/-- `freestanding` byte9 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom fs9 : U32
/-- `freestanding` byte10 'n' (110). -/
@[extern c inline "((uint32_t)110)"] public axiom fs10 : U32
/-- `freestanding` byte11 'g' (103). -/
@[extern c inline "((uint32_t)103)"] public axiom fs11 : U32

/-- Key `roots` length (5). -/
@[extern c inline "((size_t)5)"] public axiom rootsKeyLen : USize
/-- `roots` byte0 'r' (114). -/
@[extern c inline "((uint32_t)114)"] public axiom rt0 : U32
/-- `roots` byte1 'o' (111). -/
@[extern c inline "((uint32_t)111)"] public axiom rt1 : U32
/-- `roots` byte2 'o' (111). -/
@[extern c inline "((uint32_t)111)"] public axiom rt2 : U32
/-- `roots` byte3 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom rt3 : U32
/-- `roots` byte4 's' (115). -/
@[extern c inline "((uint32_t)115)"] public axiom rt4 : U32

/-- Key `globs` length (5). -/
@[extern c inline "((size_t)5)"] public axiom globsKeyLen : USize
/-- `globs` byte0 'g' (103). -/
@[extern c inline "((uint32_t)103)"] public axiom gb0 : U32
/-- `globs` byte1 'l' (108). -/
@[extern c inline "((uint32_t)108)"] public axiom gb1 : U32
/-- `globs` byte2 'o' (111). -/
@[extern c inline "((uint32_t)111)"] public axiom gb2 : U32
/-- `globs` byte3 'b' (98). -/
@[extern c inline "((uint32_t)98)"] public axiom gb3 : U32
/-- `globs` byte4 's' (115). -/
@[extern c inline "((uint32_t)115)"] public axiom gb4 : U32


/-- Key `needs` length (5). -/
@[extern c inline "((size_t)5)"] public axiom needsKeyLen : USize
/-- `needs` byte0 'n' (110). -/
@[extern c inline "((uint32_t)110)"] public axiom nd0 : U32
/-- `needs` byte1 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom nd1 : U32
/-- `needs` byte2 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom nd2 : U32
/-- `needs` byte3 'd' (100). -/
@[extern c inline "((uint32_t)100)"] public axiom nd3 : U32
/-- `needs` byte4 's' (115). -/
@[extern c inline "((uint32_t)115)"] public axiom nd4 : U32

/-- Key `exeName` length (7). -/
@[extern c inline "((size_t)7)"] public axiom exeNameKeyLen : USize
/-- `exeName` byte0 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom en0 : U32
/-- `exeName` byte1 'x' (120). -/
@[extern c inline "((uint32_t)120)"] public axiom en1 : U32
/-- `exeName` byte2 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom en2 : U32
/-- `exeName` byte3 'N' (78). -/
@[extern c inline "((uint32_t)78)"] public axiom en3 : U32
/-- `exeName` byte4 'a' (97). -/
@[extern c inline "((uint32_t)97)"] public axiom en4 : U32
/-- `exeName` byte5 'm' (109). -/
@[extern c inline "((uint32_t)109)"] public axiom en5 : U32
/-- `exeName` byte6 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom en6 : U32

/-- Key `nativeFacets` length (12). -/
@[extern c inline "((size_t)12)"] public axiom nativeFacetsKeyLen : USize
/-- `nativeFacets` byte0 'n' (110). -/
@[extern c inline "((uint32_t)110)"] public axiom nf0 : U32
/-- `nativeFacets` byte1 'a' (97). -/
@[extern c inline "((uint32_t)97)"] public axiom nf1 : U32
/-- `nativeFacets` byte2 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom nf2 : U32
/-- `nativeFacets` byte3 'i' (105). -/
@[extern c inline "((uint32_t)105)"] public axiom nf3 : U32
/-- `nativeFacets` byte4 'v' (118). -/
@[extern c inline "((uint32_t)118)"] public axiom nf4 : U32
/-- `nativeFacets` byte5 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom nf5 : U32
/-- `nativeFacets` byte6 'F' (70). -/
@[extern c inline "((uint32_t)70)"] public axiom nf6 : U32
/-- `nativeFacets` byte7 'a' (97). -/
@[extern c inline "((uint32_t)97)"] public axiom nf7 : U32
/-- `nativeFacets` byte8 'c' (99). -/
@[extern c inline "((uint32_t)99)"] public axiom nf8 : U32
/-- `nativeFacets` byte9 'e' (101). -/
@[extern c inline "((uint32_t)101)"] public axiom nf9 : U32
/-- `nativeFacets` byte10 't' (116). -/
@[extern c inline "((uint32_t)116)"] public axiom nf10 : U32
/-- `nativeFacets` byte11 's' (115). -/
@[extern c inline "((uint32_t)115)"] public axiom nf11 : U32

/-- Relative byte offsets (only `USize.one`/`four` exist on Scalars). -/
@[extern c inline "((size_t)1)"] public axiom off1 : USize
@[extern c inline "((size_t)2)"] public axiom off2 : USize
@[extern c inline "((size_t)3)"] public axiom off3 : USize
@[extern c inline "((size_t)4)"] public axiom off4 : USize
@[extern c inline "((size_t)5)"] public axiom off5 : USize
@[extern c inline "((size_t)6)"] public axiom off6 : USize
@[extern c inline "((size_t)7)"] public axiom off7 : USize
@[extern c inline "((size_t)8)"] public axiom off8 : USize
@[extern c inline "((size_t)9)"] public axiom off9 : USize
@[extern c inline "((size_t)10)"] public axiom off10 : USize
@[extern c inline "((size_t)11)"] public axiom off11 : USize
@[extern c inline "((size_t)12)"] public axiom off12 : USize
@[extern c inline "((size_t)13)"] public axiom off13 : USize
@[extern c inline "((size_t)14)"] public axiom off14 : USize
@[extern c inline "((size_t)15)"] public axiom off15 : USize
@[extern c inline "((size_t)16)"] public axiom off16 : USize
@[extern c inline "((size_t)17)"] public axiom off17 : USize
@[extern c inline "((size_t)18)"] public axiom off18 : USize
@[extern c inline "((size_t)19)"] public axiom off19 : USize

/-- Load byte at index as `U32`. Caller ensures bounds. -/
public unsafe def loadAt (addr : USize) (i : USize) : U32 :=
  U32.ofU8 (U8.load (USize.add addr i))

/-- `1` if `c` is space or tab. -/
public unsafe def isWs (c : U32) : U32 :=
  bifU32 (U32.beq c cSp) U32.one
    (bifU32 (U32.beq c cTab) U32.one U32.zero)

/-- `1` if `c` is LF or CR. -/
public unsafe def isLineEnd (c : U32) : U32 :=
  bifU32 (U32.beq c cLf) U32.one
    (bifU32 (U32.beq c cCr) U32.one U32.zero)

/-- Index of first line-end byte in `[i, n)`, or `n` if none. -/
public unsafe def findLineEnd (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (bifUSize (U32.beq (isLineEnd (loadAt addr i)) U32.one) i
      (findLineEnd addr (USize.add i USize.one) n))
    n

/-- Index just past the line ending at `le` (consumes optional CR LF pair). -/
public unsafe def afterLineEnd (addr : USize) (le : USize) (n : USize) : USize :=
  bifUSize (USize.beq le n) n
    (bifUSize (U32.beq (loadAt addr le) cCr)
      (let j := USize.add le USize.one
       bifUSize (USize.blt j n)
         (bifUSize (U32.beq (loadAt addr j) cLf) (USize.add j USize.one) j)
         j)
      (USize.add le USize.one))

/-- Skip leading spaces/tabs in `[i, hi)`. -/
public unsafe def skipWs (addr : USize) (i : USize) (hi : USize) : USize :=
  bifUSize (USize.blt i hi)
    (bifUSize (U32.beq (isWs (loadAt addr i)) U32.one)
      (skipWs addr (USize.add i USize.one) hi) i)
    i

/-- `1` if spans `[a,a+n)` and `[b,b+n)` are equal. -/
public unsafe def spanEqGo (a : USize) (b : USize) (i : USize) (n : USize) : U32 :=
  bifU32 (USize.blt i n)
    (bifU32 (U8.beq (U8.load (USize.add a i)) (U8.load (USize.add b i)))
      (spanEqGo a b (USize.add i USize.one) n)
      U32.zero)
    U32.one

/-- `1` if equal length-`n` spans match. -/
public unsafe def spanEq (a : USize) (b : USize) (n : USize) : U32 :=
  spanEqGo a b USize.zero n

/-- First `=` index in `[lo, hi)`, or `USize.neg1`. **LP64 miss.** -/
public unsafe def findEq (addr : USize) (lo : USize) (hi : USize) : USize :=
  bifUSize (USize.blt lo hi)
    (bifUSize (U32.beq (loadAt addr lo) cEq) lo
      (findEq addr (USize.add lo USize.one) hi))
    USize.neg1

/-- First `]` index in `[lo, hi)`, or miss. -/
public unsafe def findRBrack (addr : USize) (lo : USize) (hi : USize) : USize :=
  bifUSize (USize.blt lo hi)
    (bifUSize (U32.beq (loadAt addr lo) cRBrack) lo
      (findRBrack addr (USize.add lo USize.one) hi))
    USize.neg1

/-- Trim trailing spaces/tabs from exclusive end `hi` down to `lo`. Returns new end. -/
public unsafe def rtrimWs (addr : USize) (lo : USize) (hi : USize) : USize :=
  bifUSize (USize.blt lo hi)
    (let p := USize.sub hi USize.one
     bifUSize (U32.beq (isWs (loadAt addr p)) U32.one)
       (rtrimWs addr lo p) hi)
    hi

/-- Status of one line `[line, le)`: `0` ok, `1` invalid.

Accepts `[table]` and `[[array]]` headers (config-shaped; not Toml reject). -/
public unsafe def lineOk (addr : USize) (line : USize) (le : USize) : U32 :=
  let i0 := skipWs addr line le
  bifU32 (USize.beq i0 le) ok
    (let c0 := loadAt addr i0
     bifU32 (U32.beq c0 cHash) ok
       (bifU32 (U32.beq c0 cLBrack)
         (let nameStart1 := USize.add i0 USize.one
          bifU32 (USize.blt nameStart1 le)
            (bifU32 (U32.beq (loadAt addr nameStart1) cLBrack)
              -- `[[name]]`
              (let nameStart := USize.add nameStart1 USize.one
               bifU32 (USize.blt nameStart le)
                 (let rb1 := findRBrack addr nameStart le
                  bifU32 (USize.beq rb1 USize.neg1) err
                    (bifU32 (USize.beq rb1 nameStart) err
                      (let after1 := USize.add rb1 USize.one
                       bifU32 (USize.blt after1 le)
                         (bifU32 (U32.beq (loadAt addr after1) cRBrack)
                           (let after := skipWs addr (USize.add after1 USize.one) le
                            bifU32 (USize.beq after le) ok err)
                           err)
                         err)))
                 err)
              -- `[name]`
              (let rb := findRBrack addr nameStart1 le
               bifU32 (USize.beq rb USize.neg1) err
                 (bifU32 (USize.beq rb nameStart1) err
                   (let after := skipWs addr (USize.add rb USize.one) le
                    bifU32 (USize.beq after le) ok err))))
            err)
         (let eq := findEq addr i0 le
          bifU32 (USize.beq eq USize.neg1) err
            (let keyEnd := rtrimWs addr i0 eq
             bifU32 (USize.beq keyEnd i0) err ok))))

/-- Validate loop from line start `i`. -/
public unsafe def validateGo (addr : USize) (i : USize) (n : USize) : U32 :=
  bifU32 (USize.blt i n)
    (let le := findLineEnd addr i n
     bifU32 (U32.beq (lineOk addr i le) ok)
       (validateGo addr (afterLineEnd addr le n) n)
       err)
    ok

/-- Structural validate: `0` ok, `1` invalid. Empty input is ok. -/
public unsafe def validate (addr : USize) (n : USize) : U32 :=
  validateGo addr USize.zero n

/-- Alias of `validate`. -/
public unsafe def scan (addr : USize) (n : USize) : U32 :=
  validate addr n

/-- `1` if span `[off, off+len)` equals the fixed package key `name`. -/
public unsafe def isNameKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len nameKeyLen)
    (bifU32 (U32.beq (loadAt addr off) name0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) name1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) name2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) name3)
            U32.one U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- `1` if span equals fixed `lean_lib`. -/
public unsafe def isLeanLibName (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len leanLibNameLen)
    (bifU32 (U32.beq (loadAt addr off) ll0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) ll1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) ll2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) ll3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) ll4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) ll5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) ll6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) ll7)
                    U32.one U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- `1` if span equals fixed `require`. -/
public unsafe def isRequireName (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len requireNameLen)
    (bifU32 (U32.beq (loadAt addr off) rq0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) rq1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) rq2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) rq3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) rq4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) rq5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) rq6)
                  U32.one U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- `1` if span equals fixed `lean_exe` (`lean_` + `e`/`x`/`e`). -/
public unsafe def isLeanExeName (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len leanLibNameLen)
    (bifU32 (U32.beq (loadAt addr off) ll0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) ll1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) ll2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) ll3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) ll4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) ll1)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) lx6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) ll1)
                    U32.one U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- `1` if span equals fixed key `srcDir`. -/
public unsafe def isSrcDirKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len srcDirKeyLen)
    (bifU32 (U32.beq (loadAt addr off) sd0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) sd1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) sd2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) sd3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) sd4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) sd5)
                U32.one U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- `1` if span equals fixed key `defaultTargets`. -/
public unsafe def isDefaultTargetsKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len defaultTargetsKeyLen)
    (bifU32 (U32.beq (loadAt addr off) dt0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) dt1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) dt2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) dt3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) dt4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) dt5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) dt6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) dt7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) dt8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) dt9)
                        (bifU32 (U32.beq (loadAt addr (USize.add off off10)) dt10)
                          (bifU32 (U32.beq (loadAt addr (USize.add off off11)) dt11)
                            (bifU32 (U32.beq (loadAt addr (USize.add off off12)) dt12)
                              (bifU32 (U32.beq (loadAt addr (USize.add off off13)) dt13)
                                U32.one U32.zero)
                              U32.zero)
                            U32.zero)
                          U32.zero)
                        U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- `1` if span equals fixed package key `version`. -/
public unsafe def isVersionKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len versionKeyLen)
    (bifU32 (U32.beq (loadAt addr off) ver0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) ver1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) ver2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) ver3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) ver4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) ver5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) ver6)
                  U32.one U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- `1` if span equals fixed key `buildType`. -/
public unsafe def isBuildTypeKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len buildTypeKeyLen)
    (bifU32 (U32.beq (loadAt addr off) bt0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) bt1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) bt2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) bt3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) bt4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) bt5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) bt6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) bt7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) bt8)
                      U32.one U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- `1` if span equals fixed key `path`. -/
public unsafe def isPathKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len pathKeyLen)
    (bifU32 (U32.beq (loadAt addr off) path0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) path1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) path2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) path3)
            U32.one U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Header-name match for `arrayTableCountGo` kinds: 0=lean_lib, 1=require, 2=lean_exe. -/
public unsafe def arrayTableNameHit (addr : USize) (off : USize) (len : USize) (kind : U32) : U32 :=
  bifU32 (U32.beq kind U32.zero)
    (isLeanLibName addr off len)
    (bifU32 (U32.beq kind U32.one)
      (isRequireName addr off len)
      (isLeanExeName addr off len))

/-- Count well-formed `[[header]]` lines matching a name predicate kind.
kind: `0` = lean_lib, `1` = require, `2` = lean_exe. -/
public unsafe def arrayTableCountGo (addr : USize) (i : USize) (n : USize)
    (kind : U32) (acc : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (bifUSize (U32.beq (loadAt addr i0) cLBrack)
         (let s1 := USize.add i0 USize.one
          bifUSize (USize.blt s1 le)
            (bifUSize (U32.beq (loadAt addr s1) cLBrack)
              (let nameStart := USize.add s1 USize.one
               bifUSize (USize.blt nameStart le)
                 (let rb1 := findRBrack addr nameStart le
                  bifUSize (USize.beq rb1 USize.neg1)
                    (arrayTableCountGo addr (afterLineEnd addr le n) n kind acc)
                    (bifUSize (USize.beq rb1 nameStart)
                      (arrayTableCountGo addr (afterLineEnd addr le n) n kind acc)
                      (let after1 := USize.add rb1 USize.one
                       bifUSize (USize.blt after1 le)
                         (bifUSize (U32.beq (loadAt addr after1) cRBrack)
                           (let after := skipWs addr (USize.add after1 USize.one) le
                            bifUSize (USize.beq after le)
                              (let sn := USize.sub rb1 nameStart
                               let hit := arrayTableNameHit addr nameStart sn kind
                               bifUSize (U32.beq hit U32.one)
                                 (arrayTableCountGo addr (afterLineEnd addr le n) n kind
                                   (USize.add acc USize.one))
                                 (arrayTableCountGo addr (afterLineEnd addr le n) n kind acc))
                              (arrayTableCountGo addr (afterLineEnd addr le n) n kind acc))
                           (arrayTableCountGo addr (afterLineEnd addr le n) n kind acc))
                         (arrayTableCountGo addr (afterLineEnd addr le n) n kind acc))))
                 (arrayTableCountGo addr (afterLineEnd addr le n) n kind acc))
              (arrayTableCountGo addr (afterLineEnd addr le n) n kind acc))
            (arrayTableCountGo addr (afterLineEnd addr le n) n kind acc))
         (arrayTableCountGo addr (afterLineEnd addr le n) n kind acc))
       (arrayTableCountGo addr (afterLineEnd addr le n) n kind acc))
    acc

/-- Number of well-formed `[[lean_lib]]` headers. -/
public unsafe def leanLibCount (addr : USize) (n : USize) : USize :=
  arrayTableCountGo addr USize.zero n U32.zero USize.zero

/-- Number of well-formed `[[require]]` headers. -/
public unsafe def requireCount (addr : USize) (n : USize) : USize :=
  arrayTableCountGo addr USize.zero n U32.one USize.zero

/-- Number of well-formed `[[lean_exe]]` headers. -/
public unsafe def leanExeCount (addr : USize) (n : USize) : USize :=
  arrayTableCountGo addr USize.zero n U32.two USize.zero

/-- Find `key = value` line with key equal to `[keyAddr, keyLen)`. Returns key offset. -/
public unsafe def findKeyGo (addr : USize) (i : USize) (n : USize)
    (keyAddr : USize) (keyLen : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findKeyGo addr (afterLineEnd addr le n) n keyAddr keyLen)
          (bifUSize (U32.beq c0 cLBrack)
            (findKeyGo addr (afterLineEnd addr le n) n keyAddr keyLen)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findKeyGo addr (afterLineEnd addr le n) n keyAddr keyLen)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (USize.beq kn keyLen)
                  (bifUSize (U32.beq (spanEq (USize.add addr i0) keyAddr keyLen) U32.one)
                    i0
                    (findKeyGo addr (afterLineEnd addr le n) n keyAddr keyLen))
                  (findKeyGo addr (afterLineEnd addr le n) n keyAddr keyLen)))))
       (findKeyGo addr (afterLineEnd addr le n) n keyAddr keyLen))
    USize.neg1

/-- Offset of first matching key on a `key = value` line, or miss. **LP64 miss.** -/
public unsafe def findKey (addr : USize) (n : USize)
    (keyAddr : USize) (keyLen : USize) : USize :=
  bifUSize (USize.beq keyLen USize.zero) USize.neg1
    (findKeyGo addr USize.zero n keyAddr keyLen)

/-- Value byte offset for a key start from `findKey`, or miss if no `=`.

Raw span after optional spaces following `=` — **does not** strip quotes
(contrast `packageNameOff`, which strips a closed `"…"` pair for package identity). -/
public unsafe def valueOff (addr : USize) (n : USize) (keyOff : USize) : USize :=
  bifUSize (USize.blt keyOff n)
    (let le := findLineEnd addr keyOff n
     let eq := findEq addr keyOff le
     bifUSize (USize.beq eq USize.neg1) USize.neg1
       (skipWs addr (USize.add eq USize.one) le))
    USize.neg1

/-- Value length for a key start from `findKey`, or `0` on failure.

Raw trimmed value bytes including surrounding quotes when present (no strip). -/
public unsafe def valueLen (addr : USize) (n : USize) (keyOff : USize) : USize :=
  bifUSize (USize.blt keyOff n)
    (let le := findLineEnd addr keyOff n
     let eq := findEq addr keyOff le
     bifUSize (USize.beq eq USize.neg1) USize.zero
       (let vo := skipWs addr (USize.add eq USize.one) le
        let ve := rtrimWs addr vo le
        bifUSize (USize.blt ve vo) USize.zero (USize.sub ve vo)))
    USize.zero

/-- `1` if a matching key exists, else `0`. -/
public unsafe def hasKey (addr : USize) (n : USize)
    (keyAddr : USize) (keyLen : USize) : U32 :=
  bifU32 (USize.beq (findKey addr n keyAddr keyLen) USize.neg1) U32.zero U32.one

/-- Find first top-level `name = …` key offset, or miss. -/
public unsafe def findNameKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findNameKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findNameKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findNameKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isNameKey addr i0 kn) U32.one)
                  i0
                  (findNameKeyGo addr (afterLineEnd addr le n) n)))))
       (findNameKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if value span `[vo, ve)` is a closed `"…"` pair (len ≥ 2, first and last `"`). -/
public unsafe def isClosedQuoted (addr : USize) (vo : USize) (ve : USize) : U32 :=
  bifU32 (USize.blt vo ve)
    (let last := USize.sub ve USize.one
     bifU32 (USize.blt vo last)
       (bifU32 (U32.beq (loadAt addr vo) cQuote)
         (bifU32 (U32.beq (loadAt addr last) cQuote) U32.one U32.zero)
         U32.zero)
       U32.zero)
    U32.zero

/-- `1` if value starts with `"` but is not a closed pair (unclosed / single quote). -/
public unsafe def isUnclosedQuote (addr : USize) (vo : USize) (ve : USize) : U32 :=
  bifU32 (USize.blt vo ve)
    (bifU32 (U32.beq (loadAt addr vo) cQuote)
      (bifU32 (U32.beq (isClosedQuoted addr vo ve) U32.one) U32.zero U32.one)
      U32.zero)
    U32.zero

/-- Strip a closed surrounding `"…"` from `[vo, ve)`. Returns start offset.

Unquoted values pass through. Callers must reject unclosed quotes first. -/
public unsafe def stripQuoteStart (addr : USize) (vo : USize) (ve : USize) : USize :=
  bifUSize (U32.beq (isClosedQuoted addr vo ve) U32.one)
    (USize.add vo USize.one) vo

/-- Exclusive end after stripping a closed surrounding `"…"`. -/
public unsafe def stripQuoteEnd (addr : USize) (vo : USize) (ve : USize) : USize :=
  bifUSize (U32.beq (isClosedQuoted addr vo ve) U32.one)
    (USize.sub ve USize.one) ve

/-- Byte offset of package `name` value (quotes stripped), or miss. **LP64.**

Fail-closed: leading `"` without a matching trailing `"` on the same line → miss. -/
public unsafe def packageNameOff (addr : USize) (n : USize) : USize :=
  let koff := findNameKeyGo addr USize.zero n
  bifUSize (USize.beq koff USize.neg1) USize.neg1
    (let le := findLineEnd addr koff n
     let eq := findEq addr koff le
     bifUSize (USize.beq eq USize.neg1) USize.neg1
       (let vo := skipWs addr (USize.add eq USize.one) le
        let ve := rtrimWs addr vo le
        bifUSize (USize.blt ve vo) USize.neg1
          (bifUSize (U32.beq (isUnclosedQuote addr vo ve) U32.one) USize.neg1
            (stripQuoteStart addr vo ve))))

/-- Length of package `name` value (quotes stripped), or `0` on miss / unclosed quote. -/
public unsafe def packageNameLen (addr : USize) (n : USize) : USize :=
  let koff := findNameKeyGo addr USize.zero n
  bifUSize (USize.beq koff USize.neg1) USize.zero
    (let le := findLineEnd addr koff n
     let eq := findEq addr koff le
     bifUSize (USize.beq eq USize.neg1) USize.zero
       (let vo := skipWs addr (USize.add eq USize.one) le
        let ve := rtrimWs addr vo le
        bifUSize (USize.blt ve vo) USize.zero
          (bifUSize (U32.beq (isUnclosedQuote addr vo ve) U32.one) USize.zero
            (let s := stripQuoteStart addr vo ve
             let e := stripQuoteEnd addr vo ve
             bifUSize (USize.blt e s) USize.zero (USize.sub e s)))))

/-- Find first top-level `srcDir = …` key offset, or miss. -/
public unsafe def findSrcDirKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findSrcDirKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findSrcDirKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findSrcDirKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isSrcDirKey addr i0 kn) U32.one)
                  i0
                  (findSrcDirKeyGo addr (afterLineEnd addr le n) n)))))
       (findSrcDirKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a top-level `srcDir` key exists. -/
public unsafe def hasSrcDir (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findSrcDirKeyGo addr USize.zero n) USize.neg1) U32.zero U32.one

/-- Byte offset of `srcDir` value (quotes stripped), or miss. **LP64.** -/
public unsafe def srcDirOff (addr : USize) (n : USize) : USize :=
  let koff := findSrcDirKeyGo addr USize.zero n
  bifUSize (USize.beq koff USize.neg1) USize.neg1
    (let le := findLineEnd addr koff n
     let eq := findEq addr koff le
     bifUSize (USize.beq eq USize.neg1) USize.neg1
       (let vo := skipWs addr (USize.add eq USize.one) le
        let ve := rtrimWs addr vo le
        bifUSize (USize.blt ve vo) USize.neg1
          (bifUSize (U32.beq (isUnclosedQuote addr vo ve) U32.one) USize.neg1
            (stripQuoteStart addr vo ve))))

/-- Length of `srcDir` value (quotes stripped), or `0` on miss / unclosed quote. -/
public unsafe def srcDirLen (addr : USize) (n : USize) : USize :=
  let koff := findSrcDirKeyGo addr USize.zero n
  bifUSize (USize.beq koff USize.neg1) USize.zero
    (let le := findLineEnd addr koff n
     let eq := findEq addr koff le
     bifUSize (USize.beq eq USize.neg1) USize.zero
       (let vo := skipWs addr (USize.add eq USize.one) le
        let ve := rtrimWs addr vo le
        bifUSize (USize.blt ve vo) USize.zero
          (bifUSize (U32.beq (isUnclosedQuote addr vo ve) U32.one) USize.zero
            (let s := stripQuoteStart addr vo ve
             let e := stripQuoteEnd addr vo ve
             bifUSize (USize.blt e s) USize.zero (USize.sub e s)))))

/-- Find first top-level `defaultTargets = …` key offset, or miss. -/
public unsafe def findDefaultTargetsKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findDefaultTargetsKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findDefaultTargetsKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findDefaultTargetsKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isDefaultTargetsKey addr i0 kn) U32.one)
                  i0
                  (findDefaultTargetsKeyGo addr (afterLineEnd addr le n) n)))))
       (findDefaultTargetsKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- First `"` index in `[lo, hi)`, or miss. -/
public unsafe def findQuoteEnd (addr : USize) (lo : USize) (hi : USize) : USize :=
  bifUSize (USize.blt lo hi)
    (bifUSize (U32.beq (loadAt addr lo) cQuote) lo
      (findQuoteEnd addr (USize.add lo USize.one) hi))
    USize.neg1

/-- Count closed `"…"` pairs in `[vo, ve)`. Unclosed trailing quote → fail-closed `0` for whole count. -/
public unsafe def countQuotedGo (addr : USize) (i : USize) (ve : USize) (acc : USize) : USize :=
  bifUSize (USize.blt i ve)
    (bifUSize (U32.beq (loadAt addr i) cQuote)
      (let j0 := USize.add i USize.one
       let j := findQuoteEnd addr j0 ve
       bifUSize (USize.beq j USize.neg1) USize.zero
         (countQuotedGo addr (USize.add j USize.one) ve (USize.add acc USize.one)))
      (countQuotedGo addr (USize.add i USize.one) ve acc))
    acc

/-- Fail-closed count of quoted elements in `defaultTargets = […]`.

Returns `0` when the key is absent, the value is empty, does not start with `[`,
or contains an unclosed `"`. Does **not** parse unquoted tokens or nested arrays. -/
public unsafe def defaultTargetsCount (addr : USize) (n : USize) : USize :=
  let koff := findDefaultTargetsKeyGo addr USize.zero n
  bifUSize (USize.beq koff USize.neg1) USize.zero
    (let le := findLineEnd addr koff n
     let eq := findEq addr koff le
     bifUSize (USize.beq eq USize.neg1) USize.zero
       (let vo := skipWs addr (USize.add eq USize.one) le
        let ve := rtrimWs addr vo le
        bifUSize (USize.blt vo ve)
          (bifUSize (U32.beq (loadAt addr vo) cLBrack)
            (countQuotedGo addr vo ve USize.zero)
            USize.zero)
          USize.zero))

/-- Find first top-level `version = …` key offset, or miss. -/
public unsafe def findVersionKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findVersionKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findVersionKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findVersionKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isVersionKey addr i0 kn) U32.one)
                  i0
                  (findVersionKeyGo addr (afterLineEnd addr le n) n)))))
       (findVersionKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- Byte offset of package `version` value (quotes stripped), or miss. **LP64.**

Fail-closed: leading `"` without a matching trailing `"` on the same line → miss. -/
public unsafe def versionOff (addr : USize) (n : USize) : USize :=
  let koff := findVersionKeyGo addr USize.zero n
  bifUSize (USize.beq koff USize.neg1) USize.neg1
    (let le := findLineEnd addr koff n
     let eq := findEq addr koff le
     bifUSize (USize.beq eq USize.neg1) USize.neg1
       (let vo := skipWs addr (USize.add eq USize.one) le
        let ve := rtrimWs addr vo le
        bifUSize (USize.blt ve vo) USize.neg1
          (bifUSize (U32.beq (isUnclosedQuote addr vo ve) U32.one) USize.neg1
            (stripQuoteStart addr vo ve))))

/-- Length of package `version` value (quotes stripped), or `0` on miss / unclosed quote. -/
public unsafe def versionLen (addr : USize) (n : USize) : USize :=
  let koff := findVersionKeyGo addr USize.zero n
  bifUSize (USize.beq koff USize.neg1) USize.zero
    (let le := findLineEnd addr koff n
     let eq := findEq addr koff le
     bifUSize (USize.beq eq USize.neg1) USize.zero
       (let vo := skipWs addr (USize.add eq USize.one) le
        let ve := rtrimWs addr vo le
        bifUSize (USize.blt ve vo) USize.zero
          (bifUSize (U32.beq (isUnclosedQuote addr vo ve) U32.one) USize.zero
            (let s := stripQuoteStart addr vo ve
             let e := stripQuoteEnd addr vo ve
             bifUSize (USize.blt e s) USize.zero (USize.sub e s)))))

/-- Find first top-level `buildType = …` key offset, or miss. -/
public unsafe def findBuildTypeKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findBuildTypeKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findBuildTypeKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findBuildTypeKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isBuildTypeKey addr i0 kn) U32.one)
                  i0
                  (findBuildTypeKeyGo addr (afterLineEnd addr le n) n)))))
       (findBuildTypeKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a top-level `buildType` key exists. -/
public unsafe def hasBuildType (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findBuildTypeKeyGo addr USize.zero n) USize.neg1) U32.zero U32.one

/-- Count well-formed `path = …` keys (global; require-shaped fail-closed subset).

Does **not** scope under `[[require]]` tables — first-global-match style like other
key helpers. Comments and `[table]` headers are skipped. -/
public unsafe def requirePathCountGo (addr : USize) (i : USize) (n : USize) (acc : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (requirePathCountGo addr (afterLineEnd addr le n) n acc)
          (bifUSize (U32.beq c0 cLBrack)
            (requirePathCountGo addr (afterLineEnd addr le n) n acc)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (requirePathCountGo addr (afterLineEnd addr le n) n acc)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isPathKey addr i0 kn) U32.one)
                  (requirePathCountGo addr (afterLineEnd addr le n) n (USize.add acc USize.one))
                  (requirePathCountGo addr (afterLineEnd addr le n) n acc)))))
       (requirePathCountGo addr (afterLineEnd addr le n) n acc))
    acc

/-- Global count of `path = …` keys (require-shaped path scan). Empty → `0`. -/
public unsafe def requirePathCount (addr : USize) (n : USize) : USize :=
  requirePathCountGo addr USize.zero n USize.zero

/-- `1` if span equals fixed key `moreLeanArgs`. -/
public unsafe def isMoreLeanArgsKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len moreLeanArgsKeyLen)
    (bifU32 (U32.beq (loadAt addr off) mla0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) mla1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) mla2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) mla3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) mla4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) mla5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) mla6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) mla7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) mla8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) mla9)
                        (bifU32 (U32.beq (loadAt addr (USize.add off off10)) mla10)
                          (bifU32 (U32.beq (loadAt addr (USize.add off off11)) mla11)
                            U32.one U32.zero)
                          U32.zero)
                        U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- `1` if span equals fixed key `backend`. -/
public unsafe def isBackendKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len backendKeyLen)
    (bifU32 (U32.beq (loadAt addr off) be0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) be1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) be2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) be3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) be4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) be5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) be6)
                  U32.one U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- `1` if a top-level `defaultTargets` key exists. -/
public unsafe def hasDefaultTargets (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findDefaultTargetsKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first top-level `moreLeanArgs = …` key offset, or miss. -/
public unsafe def findMoreLeanArgsKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findMoreLeanArgsKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findMoreLeanArgsKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findMoreLeanArgsKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isMoreLeanArgsKey addr i0 kn) U32.one)
                  i0
                  (findMoreLeanArgsKeyGo addr (afterLineEnd addr le n) n)))))
       (findMoreLeanArgsKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- Fail-closed count of quoted elements in `moreLeanArgs = […]`.

Same quote-count policy as `defaultTargetsCount` (non-array / unclosed → `0`). -/
public unsafe def moreLeanArgsCount (addr : USize) (n : USize) : USize :=
  let koff := findMoreLeanArgsKeyGo addr USize.zero n
  bifUSize (USize.beq koff USize.neg1) USize.zero
    (let le := findLineEnd addr koff n
     let eq := findEq addr koff le
     bifUSize (USize.beq eq USize.neg1) USize.zero
       (let vo := skipWs addr (USize.add eq USize.one) le
        let ve := rtrimWs addr vo le
        bifUSize (USize.blt vo ve)
          (bifUSize (U32.beq (loadAt addr vo) cLBrack)
            (countQuotedGo addr vo ve USize.zero)
            USize.zero)
          USize.zero))

/-- Find first top-level `backend = …` key offset, or miss. -/
public unsafe def findBackendKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findBackendKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findBackendKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findBackendKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isBackendKey addr i0 kn) U32.one)
                  i0
                  (findBackendKeyGo addr (afterLineEnd addr le n) n)))))
       (findBackendKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a top-level `backend` key exists. -/
public unsafe def hasBackend (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findBackendKeyGo addr USize.zero n) USize.neg1) U32.zero U32.one

/-- Classify a table/array-table header line starting at `i0`.

Returns `1` if well-formed `[[require]]`, else `0` (any other `[…]` / `[[…]]` /
malformed header clears require scope). Caller must pass a line whose first
non-ws byte is `'['`. -/
public unsafe def isRequireArrayTableHeader (addr : USize) (i0 : USize) (le : USize) : U32 :=
  let s1 := USize.add i0 USize.one
  bifU32 (USize.blt s1 le)
    (bifU32 (U32.beq (loadAt addr s1) cLBrack)
      (let nameStart := USize.add s1 USize.one
       bifU32 (USize.blt nameStart le)
         (let rb1 := findRBrack addr nameStart le
          bifU32 (USize.beq rb1 USize.neg1) U32.zero
            (bifU32 (USize.beq rb1 nameStart) U32.zero
              (let after1 := USize.add rb1 USize.one
               bifU32 (USize.blt after1 le)
                 (bifU32 (U32.beq (loadAt addr after1) cRBrack)
                   (let after := skipWs addr (USize.add after1 USize.one) le
                    bifU32 (USize.beq after le)
                      (let sn := USize.sub rb1 nameStart
                       isRequireName addr nameStart sn)
                      U32.zero)
                   U32.zero)
                 U32.zero)))
         U32.zero)
      U32.zero)
    U32.zero

/-- Count `path = …` keys only under active `[[require]]` table scope.

`inReq` is `1` while the current header context is a well-formed `[[require]]`.
Any other table header (single `[…]` or non-require `[[…]]`) clears the flag.
Top-level `path =` before any require header is **not** counted (fail-closed). -/
public unsafe def requirePathScopedCountGo (addr : USize) (i : USize) (n : USize)
    (inReq : U32) (acc : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (requirePathScopedCountGo addr (afterLineEnd addr le n) n inReq acc)
          (bifUSize (U32.beq c0 cLBrack)
            (let hit := isRequireArrayTableHeader addr i0 le
             bifUSize (U32.beq hit U32.one)
               (requirePathScopedCountGo addr (afterLineEnd addr le n) n U32.one acc)
               (requirePathScopedCountGo addr (afterLineEnd addr le n) n U32.zero acc))
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (requirePathScopedCountGo addr (afterLineEnd addr le n) n inReq acc)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq inReq U32.one)
                  (bifUSize (U32.beq (isPathKey addr i0 kn) U32.one)
                    (requirePathScopedCountGo addr (afterLineEnd addr le n) n inReq
                      (USize.add acc USize.one))
                    (requirePathScopedCountGo addr (afterLineEnd addr le n) n inReq acc))
                  (requirePathScopedCountGo addr (afterLineEnd addr le n) n inReq acc)))))
       (requirePathScopedCountGo addr (afterLineEnd addr le n) n inReq acc))
    acc

/-- Scoped count of `path = …` under `[[require]]` tables only. Empty → `0`. -/
public unsafe def requirePathScopedCount (addr : USize) (n : USize) : USize :=
  requirePathScopedCountGo addr USize.zero n U32.zero USize.zero

/-- `1` if span equals fixed key `testDriver`. -/
public unsafe def isTestDriverKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len testDriverKeyLen)
    (bifU32 (U32.beq (loadAt addr off) td0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) td1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) td2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) td3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) td4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) td5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) td6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) td7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) td8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) td9)
                        U32.one U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- `1` if span equals fixed key `lintDriver`. -/
public unsafe def isLintDriverKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len lintDriverKeyLen)
    (bifU32 (U32.beq (loadAt addr off) ld0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) ld1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) ld2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) ld3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) ld4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) ld5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) ld6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) ld7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) ld8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) ld9)
                        U32.one U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- `1` if span equals fixed key `weakLeanArgs`. -/
public unsafe def isWeakLeanArgsKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len weakLeanArgsKeyLen)
    (bifU32 (U32.beq (loadAt addr off) wla0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) wla1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) wla2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) wla3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) wla4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) wla5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) wla6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) wla7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) wla8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) wla9)
                        (bifU32 (U32.beq (loadAt addr (USize.add off off10)) wla10)
                          (bifU32 (U32.beq (loadAt addr (USize.add off off11)) wla11)
                            U32.one U32.zero)
                          U32.zero)
                        U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first top-level `testDriver = …` key offset, or miss. -/
public unsafe def findTestDriverKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findTestDriverKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findTestDriverKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findTestDriverKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isTestDriverKey addr i0 kn) U32.one)
                  i0
                  (findTestDriverKeyGo addr (afterLineEnd addr le n) n)))))
       (findTestDriverKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a top-level `testDriver` key exists. -/
public unsafe def hasTestDriver (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findTestDriverKeyGo addr USize.zero n) USize.neg1) U32.zero U32.one

/-- Find first top-level `lintDriver = …` key offset, or miss. -/
public unsafe def findLintDriverKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findLintDriverKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findLintDriverKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findLintDriverKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isLintDriverKey addr i0 kn) U32.one)
                  i0
                  (findLintDriverKeyGo addr (afterLineEnd addr le n) n)))))
       (findLintDriverKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a top-level `lintDriver` key exists. -/
public unsafe def hasLintDriver (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findLintDriverKeyGo addr USize.zero n) USize.neg1) U32.zero U32.one

/-- Find first top-level `weakLeanArgs = …` key offset, or miss. -/
public unsafe def findWeakLeanArgsKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findWeakLeanArgsKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findWeakLeanArgsKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findWeakLeanArgsKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isWeakLeanArgsKey addr i0 kn) U32.one)
                  i0
                  (findWeakLeanArgsKeyGo addr (afterLineEnd addr le n) n)))))
       (findWeakLeanArgsKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- Fail-closed count of quoted elements in `weakLeanArgs = […]`.

Same quote-count policy as `moreLeanArgsCount` / `defaultTargetsCount`. -/
public unsafe def weakLeanArgsCount (addr : USize) (n : USize) : USize :=
  let koff := findWeakLeanArgsKeyGo addr USize.zero n
  bifUSize (USize.beq koff USize.neg1) USize.zero
    (let le := findLineEnd addr koff n
     let eq := findEq addr koff le
     bifUSize (USize.beq eq USize.neg1) USize.zero
       (let vo := skipWs addr (USize.add eq USize.one) le
        let ve := rtrimWs addr vo le
        bifUSize (USize.blt vo ve)
          (bifUSize (U32.beq (loadAt addr vo) cLBrack)
            (countQuotedGo addr vo ve USize.zero)
            USize.zero)
          USize.zero))

/-- Classify a table/array-table header: `1` if well-formed `[[lean_lib]]`. -/
public unsafe def isLeanLibArrayTableHeader (addr : USize) (i0 : USize) (le : USize) : U32 :=
  let s1 := USize.add i0 USize.one
  bifU32 (USize.blt s1 le)
    (bifU32 (U32.beq (loadAt addr s1) cLBrack)
      (let nameStart := USize.add s1 USize.one
       bifU32 (USize.blt nameStart le)
         (let rb1 := findRBrack addr nameStart le
          bifU32 (USize.beq rb1 USize.neg1) U32.zero
            (bifU32 (USize.beq rb1 nameStart) U32.zero
              (let after1 := USize.add rb1 USize.one
               bifU32 (USize.blt after1 le)
                 (bifU32 (U32.beq (loadAt addr after1) cRBrack)
                   (let after := skipWs addr (USize.add after1 USize.one) le
                    bifU32 (USize.beq after le)
                      (let sn := USize.sub rb1 nameStart
                       isLeanLibName addr nameStart sn)
                      U32.zero)
                   U32.zero)
                 U32.zero)))
         U32.zero)
      U32.zero)
    U32.zero

/-- Walk for first `name = …` under **first** `[[lean_lib]]` scope only; key offset or miss.

`phase`: `0` = before first lean_lib, `1` = inside first lean_lib, `2` = left first
(closed — never re-enter a later `[[lean_lib]]`). Any table header while `phase==1`
closes the first scope (`phase→2`); a second `[[lean_lib]]` does **not** re-open.
Top-level `name` before any lean_lib is **not** used (fail-closed). Once a name key
is found in first-scope, return it. -/
public unsafe def findFirstLeanLibNameKeyGo (addr : USize) (i : USize) (n : USize)
    (phase : U32) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findFirstLeanLibNameKeyGo addr (afterLineEnd addr le n) n phase)
          (bifUSize (U32.beq c0 cLBrack)
            (let hit := isLeanLibArrayTableHeader addr i0 le
             bifUSize (U32.beq phase U32.two)
               -- Already left first lean_lib: never re-enter.
               (findFirstLeanLibNameKeyGo addr (afterLineEnd addr le n) n U32.two)
               (bifUSize (U32.beq phase U32.one)
                 -- Leaving first scope (whether next is lean_lib or other table).
                 (findFirstLeanLibNameKeyGo addr (afterLineEnd addr le n) n U32.two)
                 -- phase==0: enter only on first [[lean_lib]].
                 (bifUSize (U32.beq hit U32.one)
                   (findFirstLeanLibNameKeyGo addr (afterLineEnd addr le n) n U32.one)
                   (findFirstLeanLibNameKeyGo addr (afterLineEnd addr le n) n U32.zero))))
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findFirstLeanLibNameKeyGo addr (afterLineEnd addr le n) n phase)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq phase U32.one)
                  (bifUSize (U32.beq (isNameKey addr i0 kn) U32.one)
                    i0
                    (findFirstLeanLibNameKeyGo addr (afterLineEnd addr le n) n phase))
                  (findFirstLeanLibNameKeyGo addr (afterLineEnd addr le n) n phase)))))
       (findFirstLeanLibNameKeyGo addr (afterLineEnd addr le n) n phase))
    USize.neg1

/-- Byte offset of first `[[lean_lib]]` `name` value (quotes stripped), or miss. **LP64.** -/
public unsafe def firstLeanLibNameOff (addr : USize) (n : USize) : USize :=
  let koff := findFirstLeanLibNameKeyGo addr USize.zero n U32.zero
  bifUSize (USize.beq koff USize.neg1) USize.neg1
    (let le := findLineEnd addr koff n
     let eq := findEq addr koff le
     bifUSize (USize.beq eq USize.neg1) USize.neg1
       (let vo := skipWs addr (USize.add eq USize.one) le
        let ve := rtrimWs addr vo le
        bifUSize (USize.blt ve vo) USize.neg1
          (bifUSize (U32.beq (isUnclosedQuote addr vo ve) U32.one) USize.neg1
            (stripQuoteStart addr vo ve))))

/-- Length of first `[[lean_lib]]` `name` value (quotes stripped), or `0` on miss. -/
public unsafe def firstLeanLibNameLen (addr : USize) (n : USize) : USize :=
  let koff := findFirstLeanLibNameKeyGo addr USize.zero n U32.zero
  bifUSize (USize.beq koff USize.neg1) USize.zero
    (let le := findLineEnd addr koff n
     let eq := findEq addr koff le
     bifUSize (USize.beq eq USize.neg1) USize.zero
       (let vo := skipWs addr (USize.add eq USize.one) le
        let ve := rtrimWs addr vo le
        bifUSize (USize.blt ve vo) USize.zero
          (bifUSize (U32.beq (isUnclosedQuote addr vo ve) U32.one) USize.zero
            (let s := stripQuoteStart addr vo ve
             let e := stripQuoteEnd addr vo ve
             bifUSize (USize.blt e s) USize.zero (USize.sub e s)))))

/-- `1` if span equals fixed key `platformIndependent`. -/
public unsafe def isPlatformIndependentKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len platformIndependentKeyLen)
    (bifU32 (U32.beq (loadAt addr off) pi0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) pi1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) pi2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) pi3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) pi4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) pi5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) pi6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) pi7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) pi8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) pi9)
                        (bifU32 (U32.beq (loadAt addr (USize.add off off10)) pi10)
                          (bifU32 (U32.beq (loadAt addr (USize.add off off11)) pi11)
                            (bifU32 (U32.beq (loadAt addr (USize.add off off12)) pi12)
                              (bifU32 (U32.beq (loadAt addr (USize.add off off13)) pi13)
                                (bifU32 (U32.beq (loadAt addr (USize.add off off14)) pi14)
                                  (bifU32 (U32.beq (loadAt addr (USize.add off off15)) pi15)
                                    (bifU32 (U32.beq (loadAt addr (USize.add off off16)) pi16)
                                      (bifU32 (U32.beq (loadAt addr (USize.add off off17)) pi17)
                                        (bifU32 (U32.beq (loadAt addr (USize.add off off18)) pi18)
                                          U32.one U32.zero)
                                        U32.zero)
                                      U32.zero)
                                    U32.zero)
                                  U32.zero)
                                U32.zero)
                              U32.zero)
                            U32.zero)
                          U32.zero)
                        U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- `1` if span equals fixed key `preferReleaseBuild`. -/
public unsafe def isPreferReleaseBuildKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len preferReleaseBuildKeyLen)
    (bifU32 (U32.beq (loadAt addr off) prb0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) prb1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) prb2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) prb3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) prb4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) prb5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) prb6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) prb7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) prb8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) prb9)
                        (bifU32 (U32.beq (loadAt addr (USize.add off off10)) prb10)
                          (bifU32 (U32.beq (loadAt addr (USize.add off off11)) prb11)
                            (bifU32 (U32.beq (loadAt addr (USize.add off off12)) prb12)
                              (bifU32 (U32.beq (loadAt addr (USize.add off off13)) prb13)
                                (bifU32 (U32.beq (loadAt addr (USize.add off off14)) prb14)
                                  (bifU32 (U32.beq (loadAt addr (USize.add off off15)) prb15)
                                    (bifU32 (U32.beq (loadAt addr (USize.add off off16)) prb16)
                                      (bifU32 (U32.beq (loadAt addr (USize.add off off17)) prb17)
                                        U32.one U32.zero)
                                      U32.zero)
                                    U32.zero)
                                  U32.zero)
                                U32.zero)
                              U32.zero)
                            U32.zero)
                          U32.zero)
                        U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- `1` if span equals fixed key `leanArgs`. -/
public unsafe def isLeanArgsKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len leanArgsKeyLen)
    (bifU32 (U32.beq (loadAt addr off) la0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) la1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) la2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) la3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) la4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) la5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) la6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) la7)
                    U32.one U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `platformIndependent = …` key offset, or miss.

Skips full-line `#` comments and bare `[`/`[[` header lines, but does **not**
exclude keys that appear under table bodies (global first-match honesty). -/
public unsafe def findPlatformIndependentKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findPlatformIndependentKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findPlatformIndependentKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findPlatformIndependentKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isPlatformIndependentKey addr i0 kn) U32.one)
                  i0
                  (findPlatformIndependentKeyGo addr (afterLineEnd addr le n) n)))))
       (findPlatformIndependentKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `platformIndependent` key exists (first non-comment match; not table-scoped). -/
public unsafe def hasPlatformIndependent (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findPlatformIndependentKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `preferReleaseBuild = …` key offset, or miss.

Same global first-match policy as `findPlatformIndependentKeyGo` (table bodies not excluded). -/
public unsafe def findPreferReleaseBuildKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findPreferReleaseBuildKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findPreferReleaseBuildKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findPreferReleaseBuildKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isPreferReleaseBuildKey addr i0 kn) U32.one)
                  i0
                  (findPreferReleaseBuildKeyGo addr (afterLineEnd addr le n) n)))))
       (findPreferReleaseBuildKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `preferReleaseBuild` key exists (first non-comment match; not table-scoped). -/
public unsafe def hasPreferReleaseBuild (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findPreferReleaseBuildKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `leanArgs = …` key offset, or miss.

Global first-match (table bodies not excluded); same style as more3 moreLeanArgs. -/
public unsafe def findLeanArgsKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findLeanArgsKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findLeanArgsKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findLeanArgsKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isLeanArgsKey addr i0 kn) U32.one)
                  i0
                  (findLeanArgsKeyGo addr (afterLineEnd addr le n) n)))))
       (findLeanArgsKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- Fail-closed count of quoted elements in `leanArgs = […]`.

Same quote-count policy as `moreLeanArgsCount` / `weakLeanArgsCount`: counts
closed `"…"` pairs in the raw value span after `=`. Closing `]` is **not**
required; missing `]` with closed quotes still counts pairs. Unclosed quotes
→ 0. -/
public unsafe def leanArgsCount (addr : USize) (n : USize) : USize :=
  let koff := findLeanArgsKeyGo addr USize.zero n
  bifUSize (USize.beq koff USize.neg1) USize.zero
    (let le := findLineEnd addr koff n
     let eq := findEq addr koff le
     bifUSize (USize.beq eq USize.neg1) USize.zero
       (let vo := skipWs addr (USize.add eq USize.one) le
        let ve := rtrimWs addr vo le
        bifUSize (USize.blt vo ve)
          (bifUSize (U32.beq (loadAt addr vo) cLBrack)
            (countQuotedGo addr vo ve USize.zero)
            USize.zero)
          USize.zero))

/-- Classify a table/array-table header: `1` if well-formed `[[lean_exe]]`. -/
public unsafe def isLeanExeArrayTableHeader (addr : USize) (i0 : USize) (le : USize) : U32 :=
  let s1 := USize.add i0 USize.one
  bifU32 (USize.blt s1 le)
    (bifU32 (U32.beq (loadAt addr s1) cLBrack)
      (let nameStart := USize.add s1 USize.one
       bifU32 (USize.blt nameStart le)
         (let rb1 := findRBrack addr nameStart le
          bifU32 (USize.beq rb1 USize.neg1) U32.zero
            (bifU32 (USize.beq rb1 nameStart) U32.zero
              (let after1 := USize.add rb1 USize.one
               bifU32 (USize.blt after1 le)
                 (bifU32 (U32.beq (loadAt addr after1) cRBrack)
                   (let after := skipWs addr (USize.add after1 USize.one) le
                    bifU32 (USize.beq after le)
                      (let sn := USize.sub rb1 nameStart
                       isLeanExeName addr nameStart sn)
                      U32.zero)
                   U32.zero)
                 U32.zero)))
         U32.zero)
      U32.zero)
    U32.zero

/-- Walk for first `name = …` under **first** `[[lean_exe]]` scope only; key offset or miss.

Same phase machine as `findFirstLeanLibNameKeyGo` (first-scope-only). -/
public unsafe def findFirstLeanExeNameKeyGo (addr : USize) (i : USize) (n : USize)
    (phase : U32) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findFirstLeanExeNameKeyGo addr (afterLineEnd addr le n) n phase)
          (bifUSize (U32.beq c0 cLBrack)
            (let hit := isLeanExeArrayTableHeader addr i0 le
             bifUSize (U32.beq phase U32.two)
               (findFirstLeanExeNameKeyGo addr (afterLineEnd addr le n) n U32.two)
               (bifUSize (U32.beq phase U32.one)
                 (findFirstLeanExeNameKeyGo addr (afterLineEnd addr le n) n U32.two)
                 (bifUSize (U32.beq hit U32.one)
                   (findFirstLeanExeNameKeyGo addr (afterLineEnd addr le n) n U32.one)
                   (findFirstLeanExeNameKeyGo addr (afterLineEnd addr le n) n U32.zero))))
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findFirstLeanExeNameKeyGo addr (afterLineEnd addr le n) n phase)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq phase U32.one)
                  (bifUSize (U32.beq (isNameKey addr i0 kn) U32.one)
                    i0
                    (findFirstLeanExeNameKeyGo addr (afterLineEnd addr le n) n phase))
                  (findFirstLeanExeNameKeyGo addr (afterLineEnd addr le n) n phase)))))
       (findFirstLeanExeNameKeyGo addr (afterLineEnd addr le n) n phase))
    USize.neg1

/-- Byte offset of first `[[lean_exe]]` `name` value (quotes stripped), or miss. **LP64.** -/
public unsafe def firstLeanExeNameOff (addr : USize) (n : USize) : USize :=
  let koff := findFirstLeanExeNameKeyGo addr USize.zero n U32.zero
  bifUSize (USize.beq koff USize.neg1) USize.neg1
    (let le := findLineEnd addr koff n
     let eq := findEq addr koff le
     bifUSize (USize.beq eq USize.neg1) USize.neg1
       (let vo := skipWs addr (USize.add eq USize.one) le
        let ve := rtrimWs addr vo le
        bifUSize (USize.blt ve vo) USize.neg1
          (bifUSize (U32.beq (isUnclosedQuote addr vo ve) U32.one) USize.neg1
            (stripQuoteStart addr vo ve))))

/-- Length of first `[[lean_exe]]` `name` value (quotes stripped), or `0` on miss. -/
public unsafe def firstLeanExeNameLen (addr : USize) (n : USize) : USize :=
  let koff := findFirstLeanExeNameKeyGo addr USize.zero n U32.zero
  bifUSize (USize.beq koff USize.neg1) USize.zero
    (let le := findLineEnd addr koff n
     let eq := findEq addr koff le
     bifUSize (USize.beq eq USize.neg1) USize.zero
       (let vo := skipWs addr (USize.add eq USize.one) le
        let ve := rtrimWs addr vo le
        bifUSize (USize.blt ve vo) USize.zero
          (bifUSize (U32.beq (isUnclosedQuote addr vo ve) U32.one) USize.zero
            (let s := stripQuoteStart addr vo ve
             let e := stripQuoteEnd addr vo ve
             bifUSize (USize.blt e s) USize.zero (USize.sub e s)))))

/-- `1` if span equals fixed key `moreLinkArgs`. -/
public unsafe def isMoreLinkArgsKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len moreLinkArgsKeyLen)
    (bifU32 (U32.beq (loadAt addr off) mlink0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) mlink1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) mlink2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) mlink3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) mlink4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) mlink5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) mlink6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) mlink7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) mlink8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) mlink9)
                        (bifU32 (U32.beq (loadAt addr (USize.add off off10)) mlink10)
                          (bifU32 (U32.beq (loadAt addr (USize.add off off11)) mlink11)
                            U32.one U32.zero)
                          U32.zero)
                        U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- `1` if span equals fixed key `buildArchive`. -/
public unsafe def isBuildArchiveKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len buildArchiveKeyLen)
    (bifU32 (U32.beq (loadAt addr off) ba0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) ba1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) ba2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) ba3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) ba4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) ba5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) ba6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) ba7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) ba8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) ba9)
                        (bifU32 (U32.beq (loadAt addr (USize.add off off10)) ba10)
                          (bifU32 (U32.beq (loadAt addr (USize.add off off11)) ba11)
                            U32.one U32.zero)
                          U32.zero)
                        U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- `1` if span equals fixed key `supportInterpreter`. -/
public unsafe def isSupportInterpreterKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len supportInterpreterKeyLen)
    (bifU32 (U32.beq (loadAt addr off) si0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) si1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) si2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) si3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) si4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) si5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) si6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) si7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) si8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) si9)
                        (bifU32 (U32.beq (loadAt addr (USize.add off off10)) si10)
                          (bifU32 (U32.beq (loadAt addr (USize.add off off11)) si11)
                            (bifU32 (U32.beq (loadAt addr (USize.add off off12)) si12)
                              (bifU32 (U32.beq (loadAt addr (USize.add off off13)) si13)
                                (bifU32 (U32.beq (loadAt addr (USize.add off off14)) si14)
                                  (bifU32 (U32.beq (loadAt addr (USize.add off off15)) si15)
                                    (bifU32 (U32.beq (loadAt addr (USize.add off off16)) si16)
                                      (bifU32 (U32.beq (loadAt addr (USize.add off off17)) si17)
                                        U32.one U32.zero)
                                      U32.zero)
                                    U32.zero)
                                  U32.zero)
                                U32.zero)
                              U32.zero)
                            U32.zero)
                          U32.zero)
                        U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `moreLinkArgs = …` key offset, or miss.

Global first-match (table bodies not excluded); same style as leanArgs. -/
public unsafe def findMoreLinkArgsKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findMoreLinkArgsKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findMoreLinkArgsKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findMoreLinkArgsKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isMoreLinkArgsKey addr i0 kn) U32.one)
                  i0
                  (findMoreLinkArgsKeyGo addr (afterLineEnd addr le n) n)))))
       (findMoreLinkArgsKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- Fail-closed count of quoted elements in `moreLinkArgs = […]`.

Same quote-count policy as `leanArgsCount` / `moreLeanArgsCount`. -/
public unsafe def moreLinkArgsCount (addr : USize) (n : USize) : USize :=
  let koff := findMoreLinkArgsKeyGo addr USize.zero n
  bifUSize (USize.beq koff USize.neg1) USize.zero
    (let le := findLineEnd addr koff n
     let eq := findEq addr koff le
     bifUSize (USize.beq eq USize.neg1) USize.zero
       (let vo := skipWs addr (USize.add eq USize.one) le
        let ve := rtrimWs addr vo le
        bifUSize (USize.blt vo ve)
          (bifUSize (U32.beq (loadAt addr vo) cLBrack)
            (countQuotedGo addr vo ve USize.zero)
            USize.zero)
          USize.zero))

/-- Find first non-comment `buildArchive = …` key offset, or miss.

Same global first-match policy as more4 platformIndependent (table bodies not excluded). -/
public unsafe def findBuildArchiveKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findBuildArchiveKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findBuildArchiveKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findBuildArchiveKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isBuildArchiveKey addr i0 kn) U32.one)
                  i0
                  (findBuildArchiveKeyGo addr (afterLineEnd addr le n) n)))))
       (findBuildArchiveKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `buildArchive` key exists (first non-comment match; not table-scoped). -/
public unsafe def hasBuildArchive (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findBuildArchiveKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `supportInterpreter = …` key offset, or miss. -/
public unsafe def findSupportInterpreterKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findSupportInterpreterKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findSupportInterpreterKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findSupportInterpreterKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isSupportInterpreterKey addr i0 kn) U32.one)
                  i0
                  (findSupportInterpreterKeyGo addr (afterLineEnd addr le n) n)))))
       (findSupportInterpreterKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `supportInterpreter` key exists (first non-comment match; not table-scoped). -/
public unsafe def hasSupportInterpreter (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findSupportInterpreterKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Walk for first `name = …` under **first** `[[require]]` scope only; key offset or miss.

Same phase machine as `findFirstLeanLibNameKeyGo` / `findFirstLeanExeNameKeyGo`. -/
public unsafe def findFirstRequireNameKeyGo (addr : USize) (i : USize) (n : USize)
    (phase : U32) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findFirstRequireNameKeyGo addr (afterLineEnd addr le n) n phase)
          (bifUSize (U32.beq c0 cLBrack)
            (let hit := isRequireArrayTableHeader addr i0 le
             bifUSize (U32.beq phase U32.two)
               (findFirstRequireNameKeyGo addr (afterLineEnd addr le n) n U32.two)
               (bifUSize (U32.beq phase U32.one)
                 (findFirstRequireNameKeyGo addr (afterLineEnd addr le n) n U32.two)
                 (bifUSize (U32.beq hit U32.one)
                   (findFirstRequireNameKeyGo addr (afterLineEnd addr le n) n U32.one)
                   (findFirstRequireNameKeyGo addr (afterLineEnd addr le n) n U32.zero))))
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findFirstRequireNameKeyGo addr (afterLineEnd addr le n) n phase)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq phase U32.one)
                  (bifUSize (U32.beq (isNameKey addr i0 kn) U32.one)
                    i0
                    (findFirstRequireNameKeyGo addr (afterLineEnd addr le n) n phase))
                  (findFirstRequireNameKeyGo addr (afterLineEnd addr le n) n phase)))))
       (findFirstRequireNameKeyGo addr (afterLineEnd addr le n) n phase))
    USize.neg1

/-- Byte offset of first `[[require]]` `name` value (quotes stripped), or miss. **LP64.** -/
public unsafe def firstRequireNameOff (addr : USize) (n : USize) : USize :=
  let koff := findFirstRequireNameKeyGo addr USize.zero n U32.zero
  bifUSize (USize.beq koff USize.neg1) USize.neg1
    (let le := findLineEnd addr koff n
     let eq := findEq addr koff le
     bifUSize (USize.beq eq USize.neg1) USize.neg1
       (let vo := skipWs addr (USize.add eq USize.one) le
        let ve := rtrimWs addr vo le
        bifUSize (USize.blt ve vo) USize.neg1
          (bifUSize (U32.beq (isUnclosedQuote addr vo ve) U32.one) USize.neg1
            (stripQuoteStart addr vo ve))))

/-- Length of first `[[require]]` `name` value (quotes stripped), or `0` on miss. -/
public unsafe def firstRequireNameLen (addr : USize) (n : USize) : USize :=
  let koff := findFirstRequireNameKeyGo addr USize.zero n U32.zero
  bifUSize (USize.beq koff USize.neg1) USize.zero
    (let le := findLineEnd addr koff n
     let eq := findEq addr koff le
     bifUSize (USize.beq eq USize.neg1) USize.zero
       (let vo := skipWs addr (USize.add eq USize.one) le
        let ve := rtrimWs addr vo le
        bifUSize (USize.blt ve vo) USize.zero
          (bifUSize (U32.beq (isUnclosedQuote addr vo ve) U32.one) USize.zero
            (let s := stripQuoteStart addr vo ve
             let e := stripQuoteEnd addr vo ve
             bifUSize (USize.blt e s) USize.zero (USize.sub e s)))))

/-- `1` if span equals fixed key `weakLinkArgs`. -/
public unsafe def isWeakLinkArgsKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len weakLinkArgsKeyLen)
    (bifU32 (U32.beq (loadAt addr off) wlink0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) wlink1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) wlink2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) wlink3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) wlink4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) wlink5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) wlink6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) wlink7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) wlink8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) wlink9)
                        (bifU32 (U32.beq (loadAt addr (USize.add off off10)) wlink10)
                          (bifU32 (U32.beq (loadAt addr (USize.add off off11)) wlink11)
                            U32.one U32.zero)
                          U32.zero)
                        U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- `1` if span equals fixed key `enableArtifactCache`. -/
public unsafe def isEnableArtifactCacheKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len enableArtifactCacheKeyLen)
    (bifU32 (U32.beq (loadAt addr off) eac0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) eac1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) eac2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) eac3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) eac4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) eac5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) eac6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) eac7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) eac8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) eac9)
                        (bifU32 (U32.beq (loadAt addr (USize.add off off10)) eac10)
                          (bifU32 (U32.beq (loadAt addr (USize.add off off11)) eac11)
                            (bifU32 (U32.beq (loadAt addr (USize.add off off12)) eac12)
                              (bifU32 (U32.beq (loadAt addr (USize.add off off13)) eac13)
                                (bifU32 (U32.beq (loadAt addr (USize.add off off14)) eac14)
                                  (bifU32 (U32.beq (loadAt addr (USize.add off off15)) eac15)
                                    (bifU32 (U32.beq (loadAt addr (USize.add off off16)) eac16)
                                      (bifU32 (U32.beq (loadAt addr (USize.add off off17)) eac17)
                                        (bifU32 (U32.beq (loadAt addr (USize.add off off18)) eac18)
                                          U32.one U32.zero)
                                        U32.zero)
                                      U32.zero)
                                    U32.zero)
                                  U32.zero)
                                U32.zero)
                              U32.zero)
                            U32.zero)
                          U32.zero)
                        U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- `1` if span equals fixed key `precompileModules`. -/
public unsafe def isPrecompileModulesKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len precompileModulesKeyLen)
    (bifU32 (U32.beq (loadAt addr off) pcm0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) pcm1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) pcm2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) pcm3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) pcm4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) pcm5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) pcm6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) pcm7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) pcm8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) pcm9)
                        (bifU32 (U32.beq (loadAt addr (USize.add off off10)) pcm10)
                          (bifU32 (U32.beq (loadAt addr (USize.add off off11)) pcm11)
                            (bifU32 (U32.beq (loadAt addr (USize.add off off12)) pcm12)
                              (bifU32 (U32.beq (loadAt addr (USize.add off off13)) pcm13)
                                (bifU32 (U32.beq (loadAt addr (USize.add off off14)) pcm14)
                                  (bifU32 (U32.beq (loadAt addr (USize.add off off15)) pcm15)
                                    (bifU32 (U32.beq (loadAt addr (USize.add off off16)) pcm16)
                                      U32.one U32.zero)
                                    U32.zero)
                                  U32.zero)
                                U32.zero)
                              U32.zero)
                            U32.zero)
                          U32.zero)
                        U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- `1` if span equals fixed key `root`. -/
public unsafe def isRootKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len rootKeyLen)
    (bifU32 (U32.beq (loadAt addr off) root0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) root1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) root2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) root3)
            U32.one U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `weakLinkArgs = …` key offset, or miss. -/
public unsafe def findWeakLinkArgsKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findWeakLinkArgsKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findWeakLinkArgsKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findWeakLinkArgsKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isWeakLinkArgsKey addr i0 kn) U32.one)
                  i0
                  (findWeakLinkArgsKeyGo addr (afterLineEnd addr le n) n)))))
       (findWeakLinkArgsKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- Fail-closed count of quoted elements in `weakLinkArgs = […]`. -/
public unsafe def weakLinkArgsCount (addr : USize) (n : USize) : USize :=
  let koff := findWeakLinkArgsKeyGo addr USize.zero n
  bifUSize (USize.beq koff USize.neg1) USize.zero
    (let le := findLineEnd addr koff n
     let eq := findEq addr koff le
     bifUSize (USize.beq eq USize.neg1) USize.zero
       (let vo := skipWs addr (USize.add eq USize.one) le
        let ve := rtrimWs addr vo le
        bifUSize (USize.blt vo ve)
          (bifUSize (U32.beq (loadAt addr vo) cLBrack)
            (countQuotedGo addr vo ve USize.zero)
            USize.zero)
          USize.zero))

/-- Find first non-comment `enableArtifactCache = …` key offset, or miss. -/
public unsafe def findEnableArtifactCacheKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findEnableArtifactCacheKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findEnableArtifactCacheKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findEnableArtifactCacheKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isEnableArtifactCacheKey addr i0 kn) U32.one)
                  i0
                  (findEnableArtifactCacheKeyGo addr (afterLineEnd addr le n) n)))))
       (findEnableArtifactCacheKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if an `enableArtifactCache` key exists (first non-comment match). -/
public unsafe def hasEnableArtifactCache (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findEnableArtifactCacheKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `precompileModules = …` key offset, or miss. -/
public unsafe def findPrecompileModulesKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findPrecompileModulesKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findPrecompileModulesKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findPrecompileModulesKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isPrecompileModulesKey addr i0 kn) U32.one)
                  i0
                  (findPrecompileModulesKeyGo addr (afterLineEnd addr le n) n)))))
       (findPrecompileModulesKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `precompileModules` key exists (first non-comment match). -/
public unsafe def hasPrecompileModules (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findPrecompileModulesKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Walk for first `root = …` under **first** `[[lean_lib]]` scope only. -/
public unsafe def findFirstLeanLibRootKeyGo (addr : USize) (i : USize) (n : USize)
    (phase : U32) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findFirstLeanLibRootKeyGo addr (afterLineEnd addr le n) n phase)
          (bifUSize (U32.beq c0 cLBrack)
            (let hit := isLeanLibArrayTableHeader addr i0 le
             bifUSize (U32.beq phase U32.two)
               (findFirstLeanLibRootKeyGo addr (afterLineEnd addr le n) n U32.two)
               (bifUSize (U32.beq phase U32.one)
                 (findFirstLeanLibRootKeyGo addr (afterLineEnd addr le n) n U32.two)
                 (bifUSize (U32.beq hit U32.one)
                   (findFirstLeanLibRootKeyGo addr (afterLineEnd addr le n) n U32.one)
                   (findFirstLeanLibRootKeyGo addr (afterLineEnd addr le n) n U32.zero))))
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findFirstLeanLibRootKeyGo addr (afterLineEnd addr le n) n phase)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq phase U32.one)
                  (bifUSize (U32.beq (isRootKey addr i0 kn) U32.one)
                    i0
                    (findFirstLeanLibRootKeyGo addr (afterLineEnd addr le n) n phase))
                  (findFirstLeanLibRootKeyGo addr (afterLineEnd addr le n) n phase)))))
       (findFirstLeanLibRootKeyGo addr (afterLineEnd addr le n) n phase))
    USize.neg1

/-- Byte offset of first `[[lean_lib]]` `root` value (quotes stripped), or miss. **LP64.** -/
public unsafe def firstLeanLibRootOff (addr : USize) (n : USize) : USize :=
  let koff := findFirstLeanLibRootKeyGo addr USize.zero n U32.zero
  bifUSize (USize.beq koff USize.neg1) USize.neg1
    (let le := findLineEnd addr koff n
     let eq := findEq addr koff le
     bifUSize (USize.beq eq USize.neg1) USize.neg1
       (let vo := skipWs addr (USize.add eq USize.one) le
        let ve := rtrimWs addr vo le
        bifUSize (USize.blt ve vo) USize.neg1
          (bifUSize (U32.beq (isUnclosedQuote addr vo ve) U32.one) USize.neg1
            (stripQuoteStart addr vo ve))))

/-- Length of first `[[lean_lib]]` `root` value (quotes stripped), or `0` on miss. -/
public unsafe def firstLeanLibRootLen (addr : USize) (n : USize) : USize :=
  let koff := findFirstLeanLibRootKeyGo addr USize.zero n U32.zero
  bifUSize (USize.beq koff USize.neg1) USize.zero
    (let le := findLineEnd addr koff n
     let eq := findEq addr koff le
     bifUSize (USize.beq eq USize.neg1) USize.zero
       (let vo := skipWs addr (USize.add eq USize.one) le
        let ve := rtrimWs addr vo le
        bifUSize (USize.blt ve vo) USize.zero
          (bifUSize (U32.beq (isUnclosedQuote addr vo ve) U32.one) USize.zero
            (let s := stripQuoteStart addr vo ve
             let e := stripQuoteEnd addr vo ve
             bifUSize (USize.blt e s) USize.zero (USize.sub e s)))))

/-- `1` if span equals fixed key `packagesDir`. -/
public unsafe def isPackagesDirKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len packagesDirKeyLen)
    (bifU32 (U32.beq (loadAt addr off) pkgd0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) pkgd1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) pkgd2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) pkgd3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) pkgd4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) pkgd5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) pkgd6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) pkgd7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) pkgd8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) pkgd9)
                        (bifU32 (U32.beq (loadAt addr (USize.add off off10)) pkgd10)
                          U32.one U32.zero)
                        U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- `1` if span equals fixed key `reservoir`. -/
public unsafe def isReservoirKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len reservoirKeyLen)
    (bifU32 (U32.beq (loadAt addr off) resv0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) resv1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) resv2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) resv3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) resv4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) resv5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) resv6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) resv7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) resv8)
                      U32.one U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `packagesDir = …` key offset, or miss. -/
public unsafe def findPackagesDirKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findPackagesDirKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findPackagesDirKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findPackagesDirKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isPackagesDirKey addr i0 kn) U32.one)
                  i0
                  (findPackagesDirKeyGo addr (afterLineEnd addr le n) n)))))
       (findPackagesDirKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `packagesDir` key exists (first non-comment match). -/
public unsafe def hasPackagesDir (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findPackagesDirKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `reservoir = …` key offset, or miss. -/
public unsafe def findReservoirKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findReservoirKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findReservoirKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findReservoirKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isReservoirKey addr i0 kn) U32.one)
                  i0
                  (findReservoirKeyGo addr (afterLineEnd addr le n) n)))))
       (findReservoirKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `reservoir` key exists (first non-comment match). -/
public unsafe def hasReservoir (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findReservoirKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Walk for first `root = …` under **first** `[[lean_exe]]` scope only. -/
public unsafe def findFirstLeanExeRootKeyGo (addr : USize) (i : USize) (n : USize)
    (phase : U32) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findFirstLeanExeRootKeyGo addr (afterLineEnd addr le n) n phase)
          (bifUSize (U32.beq c0 cLBrack)
            (let hit := isLeanExeArrayTableHeader addr i0 le
             bifUSize (U32.beq phase U32.two)
               (findFirstLeanExeRootKeyGo addr (afterLineEnd addr le n) n U32.two)
               (bifUSize (U32.beq phase U32.one)
                 (findFirstLeanExeRootKeyGo addr (afterLineEnd addr le n) n U32.two)
                 (bifUSize (U32.beq hit U32.one)
                   (findFirstLeanExeRootKeyGo addr (afterLineEnd addr le n) n U32.one)
                   (findFirstLeanExeRootKeyGo addr (afterLineEnd addr le n) n U32.zero))))
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findFirstLeanExeRootKeyGo addr (afterLineEnd addr le n) n phase)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq phase U32.one)
                  (bifUSize (U32.beq (isRootKey addr i0 kn) U32.one)
                    i0
                    (findFirstLeanExeRootKeyGo addr (afterLineEnd addr le n) n phase))
                  (findFirstLeanExeRootKeyGo addr (afterLineEnd addr le n) n phase)))))
       (findFirstLeanExeRootKeyGo addr (afterLineEnd addr le n) n phase))
    USize.neg1

/-- Byte offset of first `[[lean_exe]]` `root` value (quotes stripped), or miss. **LP64.** -/
public unsafe def firstLeanExeRootOff (addr : USize) (n : USize) : USize :=
  let koff := findFirstLeanExeRootKeyGo addr USize.zero n U32.zero
  bifUSize (USize.beq koff USize.neg1) USize.neg1
    (let le := findLineEnd addr koff n
     let eq := findEq addr koff le
     bifUSize (USize.beq eq USize.neg1) USize.neg1
       (let vo := skipWs addr (USize.add eq USize.one) le
        let ve := rtrimWs addr vo le
        bifUSize (USize.blt ve vo) USize.neg1
          (bifUSize (U32.beq (isUnclosedQuote addr vo ve) U32.one) USize.neg1
            (stripQuoteStart addr vo ve))))

/-- Length of first `[[lean_exe]]` `root` value (quotes stripped), or `0` on miss. -/
public unsafe def firstLeanExeRootLen (addr : USize) (n : USize) : USize :=
  let koff := findFirstLeanExeRootKeyGo addr USize.zero n U32.zero
  bifUSize (USize.beq koff USize.neg1) USize.zero
    (let le := findLineEnd addr koff n
     let eq := findEq addr koff le
     bifUSize (USize.beq eq USize.neg1) USize.zero
       (let vo := skipWs addr (USize.add eq USize.one) le
        let ve := rtrimWs addr vo le
        bifUSize (USize.blt ve vo) USize.zero
          (bifUSize (U32.beq (isUnclosedQuote addr vo ve) U32.one) USize.zero
            (let s := stripQuoteStart addr vo ve
             let e := stripQuoteEnd addr vo ve
             bifUSize (USize.blt e s) USize.zero (USize.sub e s)))))

/-- `1` if span equals fixed key `buildDir`. -/
public unsafe def isBuildDirKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len buildDirKeyLen)
    (bifU32 (U32.beq (loadAt addr off) bdir0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) bdir1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) bdir2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) bdir3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) bdir4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) bdir5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) bdir6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) bdir7)
                    U32.one U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- `1` if span equals fixed key `wrappersDir`. -/
public unsafe def isWrappersDirKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len wrappersDirKeyLen)
    (bifU32 (U32.beq (loadAt addr off) wrap0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) wrap1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) wrap2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) wrap3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) wrap4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) wrap5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) wrap6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) wrap7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) wrap8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) wrap9)
                        (bifU32 (U32.beq (loadAt addr (USize.add off off10)) wrap10)
                          U32.one U32.zero)
                        U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `buildDir = …` key offset, or miss. -/
public unsafe def findBuildDirKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findBuildDirKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findBuildDirKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findBuildDirKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isBuildDirKey addr i0 kn) U32.one)
                  i0
                  (findBuildDirKeyGo addr (afterLineEnd addr le n) n)))))
       (findBuildDirKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `buildDir` key exists (first non-comment match). -/
public unsafe def hasBuildDir (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findBuildDirKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `wrappersDir = …` key offset, or miss. -/
public unsafe def findWrappersDirKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findWrappersDirKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findWrappersDirKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findWrappersDirKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isWrappersDirKey addr i0 kn) U32.one)
                  i0
                  (findWrappersDirKeyGo addr (afterLineEnd addr le n) n)))))
       (findWrappersDirKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `wrappersDir` key exists (first non-comment match). -/
public unsafe def hasWrappersDir (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findWrappersDirKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Walk for first `path = …` under **first** `[[require]]` scope only. -/
public unsafe def findFirstRequirePathKeyGo (addr : USize) (i : USize) (n : USize)
    (phase : U32) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findFirstRequirePathKeyGo addr (afterLineEnd addr le n) n phase)
          (bifUSize (U32.beq c0 cLBrack)
            (let hit := isRequireArrayTableHeader addr i0 le
             bifUSize (U32.beq phase U32.two)
               (findFirstRequirePathKeyGo addr (afterLineEnd addr le n) n U32.two)
               (bifUSize (U32.beq phase U32.one)
                 (findFirstRequirePathKeyGo addr (afterLineEnd addr le n) n U32.two)
                 (bifUSize (U32.beq hit U32.one)
                   (findFirstRequirePathKeyGo addr (afterLineEnd addr le n) n U32.one)
                   (findFirstRequirePathKeyGo addr (afterLineEnd addr le n) n U32.zero))))
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findFirstRequirePathKeyGo addr (afterLineEnd addr le n) n phase)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq phase U32.one)
                  (bifUSize (U32.beq (isPathKey addr i0 kn) U32.one)
                    i0
                    (findFirstRequirePathKeyGo addr (afterLineEnd addr le n) n phase))
                  (findFirstRequirePathKeyGo addr (afterLineEnd addr le n) n phase)))))
       (findFirstRequirePathKeyGo addr (afterLineEnd addr le n) n phase))
    USize.neg1

/-- Byte offset of first `[[require]]` `path` value (quotes stripped), or miss. **LP64.** -/
public unsafe def firstRequirePathOff (addr : USize) (n : USize) : USize :=
  let koff := findFirstRequirePathKeyGo addr USize.zero n U32.zero
  bifUSize (USize.beq koff USize.neg1) USize.neg1
    (let le := findLineEnd addr koff n
     let eq := findEq addr koff le
     bifUSize (USize.beq eq USize.neg1) USize.neg1
       (let vo := skipWs addr (USize.add eq USize.one) le
        let ve := rtrimWs addr vo le
        bifUSize (USize.blt ve vo) USize.neg1
          (bifUSize (U32.beq (isUnclosedQuote addr vo ve) U32.one) USize.neg1
            (stripQuoteStart addr vo ve))))

/-- Length of first `[[require]]` `path` value (quotes stripped), or `0` on miss. -/
public unsafe def firstRequirePathLen (addr : USize) (n : USize) : USize :=
  let koff := findFirstRequirePathKeyGo addr USize.zero n U32.zero
  bifUSize (USize.beq koff USize.neg1) USize.zero
    (let le := findLineEnd addr koff n
     let eq := findEq addr koff le
     bifUSize (USize.beq eq USize.neg1) USize.zero
       (let vo := skipWs addr (USize.add eq USize.one) le
        let ve := rtrimWs addr vo le
        bifUSize (USize.blt ve vo) USize.zero
          (bifUSize (U32.beq (isUnclosedQuote addr vo ve) U32.one) USize.zero
            (let s := stripQuoteStart addr vo ve
             let e := stripQuoteEnd addr vo ve
             bifUSize (USize.blt e s) USize.zero (USize.sub e s)))))

/-- `1` if span equals fixed key `nativeLibDir`. -/
public unsafe def isNativeLibDirKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len nativeLibDirKeyLen)
    (bifU32 (U32.beq (loadAt addr off) nld0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) nld1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) nld2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) nld3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) nld4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) nld5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) nld6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) nld7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) nld8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) nld9)
                        (bifU32 (U32.beq (loadAt addr (USize.add off off10)) nld10)
                          (bifU32 (U32.beq (loadAt addr (USize.add off off11)) nld11)
                            U32.one U32.zero)
                          U32.zero)
                        U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- `1` if span equals fixed key `testDriverArgs`. -/
public unsafe def isTestDriverArgsKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len testDriverArgsKeyLen)
    (bifU32 (U32.beq (loadAt addr off) tda0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) tda1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) tda2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) tda3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) tda4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) tda5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) tda6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) tda7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) tda8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) tda9)
                        (bifU32 (U32.beq (loadAt addr (USize.add off off10)) tda10)
                          (bifU32 (U32.beq (loadAt addr (USize.add off off11)) tda11)
                            (bifU32 (U32.beq (loadAt addr (USize.add off off12)) tda12)
                              (bifU32 (U32.beq (loadAt addr (USize.add off off13)) tda13)
                                U32.one U32.zero)
                              U32.zero)
                            U32.zero)
                          U32.zero)
                        U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- `1` if span equals fixed key `rev`. -/
public unsafe def isRevKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len revKeyLen)
    (bifU32 (U32.beq (loadAt addr off) rev0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) rev1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) rev2)
          U32.one U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `nativeLibDir = …` key offset, or miss. -/
public unsafe def findNativeLibDirKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findNativeLibDirKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findNativeLibDirKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findNativeLibDirKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isNativeLibDirKey addr i0 kn) U32.one)
                  i0
                  (findNativeLibDirKeyGo addr (afterLineEnd addr le n) n)))))
       (findNativeLibDirKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `nativeLibDir` key exists (first non-comment match). -/
public unsafe def hasNativeLibDir (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findNativeLibDirKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `testDriverArgs = …` key offset, or miss. -/
public unsafe def findTestDriverArgsKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findTestDriverArgsKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findTestDriverArgsKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findTestDriverArgsKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isTestDriverArgsKey addr i0 kn) U32.one)
                  i0
                  (findTestDriverArgsKeyGo addr (afterLineEnd addr le n) n)))))
       (findTestDriverArgsKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `testDriverArgs` key exists (first non-comment match). -/
public unsafe def hasTestDriverArgs (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findTestDriverArgsKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Walk for first `rev = …` under **first** `[[require]]` scope only. -/
public unsafe def findFirstRequireRevKeyGo (addr : USize) (i : USize) (n : USize)
    (phase : U32) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findFirstRequireRevKeyGo addr (afterLineEnd addr le n) n phase)
          (bifUSize (U32.beq c0 cLBrack)
            (let hit := isRequireArrayTableHeader addr i0 le
             bifUSize (U32.beq phase U32.two)
               (findFirstRequireRevKeyGo addr (afterLineEnd addr le n) n U32.two)
               (bifUSize (U32.beq phase U32.one)
                 (findFirstRequireRevKeyGo addr (afterLineEnd addr le n) n U32.two)
                 (bifUSize (U32.beq hit U32.one)
                   (findFirstRequireRevKeyGo addr (afterLineEnd addr le n) n U32.one)
                   (findFirstRequireRevKeyGo addr (afterLineEnd addr le n) n U32.zero))))
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findFirstRequireRevKeyGo addr (afterLineEnd addr le n) n phase)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq phase U32.one)
                  (bifUSize (U32.beq (isRevKey addr i0 kn) U32.one)
                    i0
                    (findFirstRequireRevKeyGo addr (afterLineEnd addr le n) n phase))
                  (findFirstRequireRevKeyGo addr (afterLineEnd addr le n) n phase)))))
       (findFirstRequireRevKeyGo addr (afterLineEnd addr le n) n phase))
    USize.neg1

/-- Byte offset of first `[[require]]` `rev` value (quotes stripped), or miss. **LP64.** -/
public unsafe def firstRequireRevOff (addr : USize) (n : USize) : USize :=
  let koff := findFirstRequireRevKeyGo addr USize.zero n U32.zero
  bifUSize (USize.beq koff USize.neg1) USize.neg1
    (let le := findLineEnd addr koff n
     let eq := findEq addr koff le
     bifUSize (USize.beq eq USize.neg1) USize.neg1
       (let vo := skipWs addr (USize.add eq USize.one) le
        let ve := rtrimWs addr vo le
        bifUSize (USize.blt ve vo) USize.neg1
          (bifUSize (U32.beq (isUnclosedQuote addr vo ve) U32.one) USize.neg1
            (stripQuoteStart addr vo ve))))

/-- Length of first `[[require]]` `rev` value (quotes stripped), or `0` on miss. -/
public unsafe def firstRequireRevLen (addr : USize) (n : USize) : USize :=
  let koff := findFirstRequireRevKeyGo addr USize.zero n U32.zero
  bifUSize (USize.beq koff USize.neg1) USize.zero
    (let le := findLineEnd addr koff n
     let eq := findEq addr koff le
     bifUSize (USize.beq eq USize.neg1) USize.zero
       (let vo := skipWs addr (USize.add eq USize.one) le
        let ve := rtrimWs addr vo le
        bifUSize (USize.blt ve vo) USize.zero
          (bifUSize (U32.beq (isUnclosedQuote addr vo ve) U32.one) USize.zero
            (let s := stripQuoteStart addr vo ve
             let e := stripQuoteEnd addr vo ve
             bifUSize (USize.blt e s) USize.zero (USize.sub e s)))))



/-- `1` if span equals fixed key `lintDriverArgs`. -/
public unsafe def isLintDriverArgsKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len lintDriverArgsKeyLen)
    (bifU32 (U32.beq (loadAt addr off) lda0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) lda1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) lda2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) lda3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) lda4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) lda5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) lda6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) lda7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) lda8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) lda9)
                        (bifU32 (U32.beq (loadAt addr (USize.add off off10)) lda10)
                          (bifU32 (U32.beq (loadAt addr (USize.add off off11)) lda11)
                            (bifU32 (U32.beq (loadAt addr (USize.add off off12)) lda12)
                              (bifU32 (U32.beq (loadAt addr (USize.add off off13)) lda13)
                                U32.one U32.zero)
                              U32.zero)
                            U32.zero)
                          U32.zero)
                        U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- `1` if span equals fixed key `git`. -/
public unsafe def isGitKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len gitKeyLen)
    (bifU32 (U32.beq (loadAt addr off) git0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) git1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) git2)
          U32.one U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `lintDriverArgs = …` key offset, or miss. -/
public unsafe def findLintDriverArgsKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findLintDriverArgsKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findLintDriverArgsKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findLintDriverArgsKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isLintDriverArgsKey addr i0 kn) U32.one)
                  i0
                  (findLintDriverArgsKeyGo addr (afterLineEnd addr le n) n)))))
       (findLintDriverArgsKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `lintDriverArgs` key exists (first non-comment match). -/
public unsafe def hasLintDriverArgs (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findLintDriverArgsKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `moreLinkArgs = …` key offset, or miss. -/
public unsafe def findMoreLinkArgsPresenceKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findMoreLinkArgsPresenceKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findMoreLinkArgsPresenceKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findMoreLinkArgsPresenceKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isMoreLinkArgsKey addr i0 kn) U32.one)
                  i0
                  (findMoreLinkArgsPresenceKeyGo addr (afterLineEnd addr le n) n)))))
       (findMoreLinkArgsPresenceKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `moreLinkArgs` key exists (first non-comment match; W75 more10 presence). -/
public unsafe def hasMoreLinkArgs (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findMoreLinkArgsPresenceKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Walk for first `git = …` under **first** `[[require]]` scope only. -/
public unsafe def findFirstRequireGitKeyGo (addr : USize) (i : USize) (n : USize)
    (phase : U32) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findFirstRequireGitKeyGo addr (afterLineEnd addr le n) n phase)
          (bifUSize (U32.beq c0 cLBrack)
            (let hit := isRequireArrayTableHeader addr i0 le
             bifUSize (U32.beq phase U32.two)
               (findFirstRequireGitKeyGo addr (afterLineEnd addr le n) n U32.two)
               (bifUSize (U32.beq phase U32.one)
                 (findFirstRequireGitKeyGo addr (afterLineEnd addr le n) n U32.two)
                 (bifUSize (U32.beq hit U32.one)
                   (findFirstRequireGitKeyGo addr (afterLineEnd addr le n) n U32.one)
                   (findFirstRequireGitKeyGo addr (afterLineEnd addr le n) n U32.zero))))
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findFirstRequireGitKeyGo addr (afterLineEnd addr le n) n phase)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq phase U32.one)
                  (bifUSize (U32.beq (isGitKey addr i0 kn) U32.one)
                    i0
                    (findFirstRequireGitKeyGo addr (afterLineEnd addr le n) n phase))
                  (findFirstRequireGitKeyGo addr (afterLineEnd addr le n) n phase)))))
       (findFirstRequireGitKeyGo addr (afterLineEnd addr le n) n phase))
    USize.neg1

/-- Byte offset of first `[[require]]` `git` value (quotes stripped), or miss. **LP64.** -/
public unsafe def firstRequireGitOff (addr : USize) (n : USize) : USize :=
  let koff := findFirstRequireGitKeyGo addr USize.zero n U32.zero
  bifUSize (USize.beq koff USize.neg1) USize.neg1
    (let le := findLineEnd addr koff n
     let eq := findEq addr koff le
     bifUSize (USize.beq eq USize.neg1) USize.neg1
       (let vo := skipWs addr (USize.add eq USize.one) le
        let ve := rtrimWs addr vo le
        bifUSize (USize.blt ve vo) USize.neg1
          (bifUSize (U32.beq (isUnclosedQuote addr vo ve) U32.one) USize.neg1
            (stripQuoteStart addr vo ve))))

/-- Length of first `[[require]]` `git` value (quotes stripped), or `0` on miss. -/
public unsafe def firstRequireGitLen (addr : USize) (n : USize) : USize :=
  let koff := findFirstRequireGitKeyGo addr USize.zero n U32.zero
  bifUSize (USize.beq koff USize.neg1) USize.zero
    (let le := findLineEnd addr koff n
     let eq := findEq addr koff le
     bifUSize (USize.beq eq USize.neg1) USize.zero
       (let vo := skipWs addr (USize.add eq USize.one) le
        let ve := rtrimWs addr vo le
        bifUSize (USize.blt ve vo) USize.zero
          (bifUSize (U32.beq (isUnclosedQuote addr vo ve) U32.one) USize.zero
            (let s := stripQuoteStart addr vo ve
             let e := stripQuoteEnd addr vo ve
             bifUSize (USize.blt e s) USize.zero (USize.sub e s)))))



/-- `1` if span equals fixed key `leanOptions`. -/
public unsafe def isLeanOptionsKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len leanOptionsKeyLen)
    (bifU32 (U32.beq (loadAt addr off) lo0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) lo1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) lo2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) lo3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) lo4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) lo5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) lo6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) lo7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) lo8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) lo9)
                        (bifU32 (U32.beq (loadAt addr (USize.add off off10)) lo10)
                          U32.one U32.zero)
                        U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- `1` if span equals fixed key `moreServerOptions`. -/
public unsafe def isMoreServerOptionsKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len moreServerOptionsKeyLen)
    (bifU32 (U32.beq (loadAt addr off) mso0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) mso1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) mso2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) mso3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) mso4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) mso5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) mso6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) mso7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) mso8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) mso9)
                        (bifU32 (U32.beq (loadAt addr (USize.add off off10)) mso10)
                          (bifU32 (U32.beq (loadAt addr (USize.add off off11)) mso11)
                            (bifU32 (U32.beq (loadAt addr (USize.add off off12)) mso12)
                              (bifU32 (U32.beq (loadAt addr (USize.add off off13)) mso13)
                                (bifU32 (U32.beq (loadAt addr (USize.add off off14)) mso14)
                                  (bifU32 (U32.beq (loadAt addr (USize.add off off15)) mso15)
                                    (bifU32 (U32.beq (loadAt addr (USize.add off off16)) mso16)
                                      U32.one U32.zero)
                                    U32.zero)
                                  U32.zero)
                                U32.zero)
                              U32.zero)
                            U32.zero)
                          U32.zero)
                        U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- `1` if span equals fixed key `url`. -/
public unsafe def isUrlKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len urlKeyLen)
    (bifU32 (U32.beq (loadAt addr off) url0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) url1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) url2)
          U32.one U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `leanOptions = …` key offset, or miss. -/
public unsafe def findLeanOptionsKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findLeanOptionsKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findLeanOptionsKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findLeanOptionsKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isLeanOptionsKey addr i0 kn) U32.one)
                  i0
                  (findLeanOptionsKeyGo addr (afterLineEnd addr le n) n)))))
       (findLeanOptionsKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `leanOptions` key exists (first non-comment match). -/
public unsafe def hasLeanOptions (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findLeanOptionsKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `moreServerOptions = …` key offset, or miss. -/
public unsafe def findMoreServerOptionsKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findMoreServerOptionsKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findMoreServerOptionsKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findMoreServerOptionsKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isMoreServerOptionsKey addr i0 kn) U32.one)
                  i0
                  (findMoreServerOptionsKeyGo addr (afterLineEnd addr le n) n)))))
       (findMoreServerOptionsKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `moreServerOptions` key exists (first non-comment match; W76 more11 presence). -/
public unsafe def hasMoreServerOptions (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findMoreServerOptionsKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Walk for first `url = …` under **first** `[[require]]` scope only. -/
public unsafe def findFirstRequireUrlKeyGo (addr : USize) (i : USize) (n : USize)
    (phase : U32) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findFirstRequireUrlKeyGo addr (afterLineEnd addr le n) n phase)
          (bifUSize (U32.beq c0 cLBrack)
            (let hit := isRequireArrayTableHeader addr i0 le
             bifUSize (U32.beq phase U32.two)
               (findFirstRequireUrlKeyGo addr (afterLineEnd addr le n) n U32.two)
               (bifUSize (U32.beq phase U32.one)
                 (findFirstRequireUrlKeyGo addr (afterLineEnd addr le n) n U32.two)
                 (bifUSize (U32.beq hit U32.one)
                   (findFirstRequireUrlKeyGo addr (afterLineEnd addr le n) n U32.one)
                   (findFirstRequireUrlKeyGo addr (afterLineEnd addr le n) n U32.zero))))
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findFirstRequireUrlKeyGo addr (afterLineEnd addr le n) n phase)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq phase U32.one)
                  (bifUSize (U32.beq (isUrlKey addr i0 kn) U32.one)
                    i0
                    (findFirstRequireUrlKeyGo addr (afterLineEnd addr le n) n phase))
                  (findFirstRequireUrlKeyGo addr (afterLineEnd addr le n) n phase)))))
       (findFirstRequireUrlKeyGo addr (afterLineEnd addr le n) n phase))
    USize.neg1

/-- Byte offset of first `[[require]]` `url` value (quotes stripped), or miss. **LP64.** -/
public unsafe def firstRequireUrlOff (addr : USize) (n : USize) : USize :=
  let koff := findFirstRequireUrlKeyGo addr USize.zero n U32.zero
  bifUSize (USize.beq koff USize.neg1) USize.neg1
    (let le := findLineEnd addr koff n
     let eq := findEq addr koff le
     bifUSize (USize.beq eq USize.neg1) USize.neg1
       (let vo := skipWs addr (USize.add eq USize.one) le
        let ve := rtrimWs addr vo le
        bifUSize (USize.blt ve vo) USize.neg1
          (bifUSize (U32.beq (isUnclosedQuote addr vo ve) U32.one) USize.neg1
            (stripQuoteStart addr vo ve))))

/-- Length of first `[[require]]` `url` value (quotes stripped), or `0` on miss. -/
public unsafe def firstRequireUrlLen (addr : USize) (n : USize) : USize :=
  let koff := findFirstRequireUrlKeyGo addr USize.zero n U32.zero
  bifUSize (USize.beq koff USize.neg1) USize.zero
    (let le := findLineEnd addr koff n
     let eq := findEq addr koff le
     bifUSize (USize.beq eq USize.neg1) USize.zero
       (let vo := skipWs addr (USize.add eq USize.one) le
        let ve := rtrimWs addr vo le
        bifUSize (USize.blt ve vo) USize.zero
          (bifUSize (U32.beq (isUnclosedQuote addr vo ve) U32.one) USize.zero
            (let s := stripQuoteStart addr vo ve
             let e := stripQuoteEnd addr vo ve
             bifUSize (USize.blt e s) USize.zero (USize.sub e s)))))



/-- `1` if span equals fixed key `manifest`. -/
public unsafe def isManifestKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len manifestKeyLen)
    (bifU32 (U32.beq (loadAt addr off) mf0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) mf1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) mf2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) mf3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) mf4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) mf5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) mf6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) mf7)
                    U32.one U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- `1` if span equals fixed key `versionTags`. -/
public unsafe def isVersionTagsKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len versionTagsKeyLen)
    (bifU32 (U32.beq (loadAt addr off) vt0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) vt1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) vt2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) vt3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) vt4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) vt5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) vt6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) vt7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) vt8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) vt9)
                        (bifU32 (U32.beq (loadAt addr (USize.add off off10)) vt10)
                          U32.one U32.zero)
                        U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `manifest = …` key offset, or miss. -/
public unsafe def findManifestKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findManifestKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findManifestKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findManifestKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isManifestKey addr i0 kn) U32.one)
                  i0
                  (findManifestKeyGo addr (afterLineEnd addr le n) n)))))
       (findManifestKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `manifest` key exists (first non-comment match; shaped presence only — not PackageConfig). -/
public unsafe def hasManifest (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findManifestKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `versionTags = …` key offset, or miss. -/
public unsafe def findVersionTagsKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findVersionTagsKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findVersionTagsKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findVersionTagsKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isVersionTagsKey addr i0 kn) U32.one)
                  i0
                  (findVersionTagsKeyGo addr (afterLineEnd addr le n) n)))))
       (findVersionTagsKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `versionTags` key exists (first non-comment match; W77 more12 presence). -/
public unsafe def hasVersionTags (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findVersionTagsKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Walk for first `version = …` under **first** `[[require]]` scope only. -/
public unsafe def findFirstRequireVersionKeyGo (addr : USize) (i : USize) (n : USize)
    (phase : U32) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findFirstRequireVersionKeyGo addr (afterLineEnd addr le n) n phase)
          (bifUSize (U32.beq c0 cLBrack)
            (let hit := isRequireArrayTableHeader addr i0 le
             bifUSize (U32.beq phase U32.two)
               (findFirstRequireVersionKeyGo addr (afterLineEnd addr le n) n U32.two)
               (bifUSize (U32.beq phase U32.one)
                 (findFirstRequireVersionKeyGo addr (afterLineEnd addr le n) n U32.two)
                 (bifUSize (U32.beq hit U32.one)
                   (findFirstRequireVersionKeyGo addr (afterLineEnd addr le n) n U32.one)
                   (findFirstRequireVersionKeyGo addr (afterLineEnd addr le n) n U32.zero))))
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findFirstRequireVersionKeyGo addr (afterLineEnd addr le n) n phase)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq phase U32.one)
                  (bifUSize (U32.beq (isVersionKey addr i0 kn) U32.one)
                    i0
                    (findFirstRequireVersionKeyGo addr (afterLineEnd addr le n) n phase))
                  (findFirstRequireVersionKeyGo addr (afterLineEnd addr le n) n phase)))))
       (findFirstRequireVersionKeyGo addr (afterLineEnd addr le n) n phase))
    USize.neg1

/-- Byte offset of first `[[require]]` `version` value (quotes stripped), or miss. **LP64.** -/
public unsafe def firstRequireVersionOff (addr : USize) (n : USize) : USize :=
  let koff := findFirstRequireVersionKeyGo addr USize.zero n U32.zero
  bifUSize (USize.beq koff USize.neg1) USize.neg1
    (let le := findLineEnd addr koff n
     let eq := findEq addr koff le
     bifUSize (USize.beq eq USize.neg1) USize.neg1
       (let vo := skipWs addr (USize.add eq USize.one) le
        let ve := rtrimWs addr vo le
        bifUSize (USize.blt ve vo) USize.neg1
          (bifUSize (U32.beq (isUnclosedQuote addr vo ve) U32.one) USize.neg1
            (stripQuoteStart addr vo ve))))

/-- Length of first `[[require]]` `version` value (quotes stripped), or `0` on miss. -/
public unsafe def firstRequireVersionLen (addr : USize) (n : USize) : USize :=
  let koff := findFirstRequireVersionKeyGo addr USize.zero n U32.zero
  bifUSize (USize.beq koff USize.neg1) USize.zero
    (let le := findLineEnd addr koff n
     let eq := findEq addr koff le
     bifUSize (USize.beq eq USize.neg1) USize.zero
       (let vo := skipWs addr (USize.add eq USize.one) le
        let ve := rtrimWs addr vo le
        bifUSize (USize.blt ve vo) USize.zero
          (bifUSize (U32.beq (isUnclosedQuote addr vo ve) U32.one) USize.zero
            (let s := stripQuoteStart addr vo ve
             let e := stripQuoteEnd addr vo ve
             bifUSize (USize.blt e s) USize.zero (USize.sub e s)))))



/-- `1` if span equals fixed key `description`. -/
public unsafe def isDescriptionKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len descriptionKeyLen)
    (bifU32 (U32.beq (loadAt addr off) ds0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) ds1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) ds2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) ds3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) ds4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) ds5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) ds6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) ds7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) ds8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) ds9)
                        (bifU32 (U32.beq (loadAt addr (USize.add off off10)) ds10)
                          U32.one U32.zero)
                        U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- `1` if span equals fixed key `keywords`. -/
public unsafe def isKeywordsKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len keywordsKeyLen)
    (bifU32 (U32.beq (loadAt addr off) kw0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) kw1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) kw2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) kw3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) kw4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) kw5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) kw6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) kw7)
                    U32.one U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- `1` if span equals fixed key `scope`. -/
public unsafe def isScopeKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len scopeKeyLen)
    (bifU32 (U32.beq (loadAt addr off) sc0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) sc1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) sc2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) sc3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) sc4)
              U32.one U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `description = …` key offset, or miss. -/
public unsafe def findDescriptionKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findDescriptionKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findDescriptionKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findDescriptionKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isDescriptionKey addr i0 kn) U32.one)
                  i0
                  (findDescriptionKeyGo addr (afterLineEnd addr le n) n)))))
       (findDescriptionKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `description` key exists (first non-comment match; W78 more13 presence). -/
public unsafe def hasDescription (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findDescriptionKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `keywords = …` key offset, or miss. -/
public unsafe def findKeywordsKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findKeywordsKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findKeywordsKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findKeywordsKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isKeywordsKey addr i0 kn) U32.one)
                  i0
                  (findKeywordsKeyGo addr (afterLineEnd addr le n) n)))))
       (findKeywordsKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `keywords` key exists (first non-comment match; W78 more13 presence). -/
public unsafe def hasKeywords (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findKeywordsKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Walk for first `scope = …` under **first** `[[require]]` scope only. -/
public unsafe def findFirstRequireScopeKeyGo (addr : USize) (i : USize) (n : USize)
    (phase : U32) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findFirstRequireScopeKeyGo addr (afterLineEnd addr le n) n phase)
          (bifUSize (U32.beq c0 cLBrack)
            (let hit := isRequireArrayTableHeader addr i0 le
             bifUSize (U32.beq phase U32.two)
               (findFirstRequireScopeKeyGo addr (afterLineEnd addr le n) n U32.two)
               (bifUSize (U32.beq phase U32.one)
                 (findFirstRequireScopeKeyGo addr (afterLineEnd addr le n) n U32.two)
                 (bifUSize (U32.beq hit U32.one)
                   (findFirstRequireScopeKeyGo addr (afterLineEnd addr le n) n U32.one)
                   (findFirstRequireScopeKeyGo addr (afterLineEnd addr le n) n U32.zero))))
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findFirstRequireScopeKeyGo addr (afterLineEnd addr le n) n phase)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq phase U32.one)
                  (bifUSize (U32.beq (isScopeKey addr i0 kn) U32.one)
                    i0
                    (findFirstRequireScopeKeyGo addr (afterLineEnd addr le n) n phase))
                  (findFirstRequireScopeKeyGo addr (afterLineEnd addr le n) n phase)))))
       (findFirstRequireScopeKeyGo addr (afterLineEnd addr le n) n phase))
    USize.neg1

/-- Byte offset of first `[[require]]` `scope` value (quotes stripped), or miss. **LP64.** -/
public unsafe def firstRequireScopeOff (addr : USize) (n : USize) : USize :=
  let koff := findFirstRequireScopeKeyGo addr USize.zero n U32.zero
  bifUSize (USize.beq koff USize.neg1) USize.neg1
    (let le := findLineEnd addr koff n
     let eq := findEq addr koff le
     bifUSize (USize.beq eq USize.neg1) USize.neg1
       (let vo := skipWs addr (USize.add eq USize.one) le
        let ve := rtrimWs addr vo le
        bifUSize (USize.blt ve vo) USize.neg1
          (bifUSize (U32.beq (isUnclosedQuote addr vo ve) U32.one) USize.neg1
            (stripQuoteStart addr vo ve))))

/-- Length of first `[[require]]` `scope` value (quotes stripped), or `0` on miss. -/
public unsafe def firstRequireScopeLen (addr : USize) (n : USize) : USize :=
  let koff := findFirstRequireScopeKeyGo addr USize.zero n U32.zero
  bifUSize (USize.beq koff USize.neg1) USize.zero
    (let le := findLineEnd addr koff n
     let eq := findEq addr koff le
     bifUSize (USize.beq eq USize.neg1) USize.zero
       (let vo := skipWs addr (USize.add eq USize.one) le
        let ve := rtrimWs addr vo le
        bifUSize (USize.blt ve vo) USize.zero
          (bifUSize (U32.beq (isUnclosedQuote addr vo ve) U32.one) USize.zero
            (let s := stripQuoteStart addr vo ve
             let e := stripQuoteEnd addr vo ve
             bifUSize (USize.blt e s) USize.zero (USize.sub e s)))))

/-- `1` if span equals fixed key `homepage`. -/
public unsafe def isHomepageKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len homepageKeyLen)
    (bifU32 (U32.beq (loadAt addr off) hp0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) hp1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) hp2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) hp3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) hp4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) hp5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) hp6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) hp7)
                    U32.one U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- `1` if span equals fixed key `license`. -/
public unsafe def isLicenseKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len licenseKeyLen)
    (bifU32 (U32.beq (loadAt addr off) lc0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) lc1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) lc2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) lc3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) lc4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) lc5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) lc6)
                  U32.one U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- `1` if span equals fixed key `subDir`. -/
public unsafe def isSubDirKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len subDirKeyLen)
    (bifU32 (U32.beq (loadAt addr off) sbd0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) sbd1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) sbd2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) sbd3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) sbd4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) sbd5)
                U32.one U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `homepage = …` key offset, or miss. -/
public unsafe def findHomepageKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findHomepageKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findHomepageKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findHomepageKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isHomepageKey addr i0 kn) U32.one)
                  i0
                  (findHomepageKeyGo addr (afterLineEnd addr le n) n)))))
       (findHomepageKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `homepage` key exists (first non-comment match; W79 more14 presence). -/
public unsafe def hasHomepage (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findHomepageKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `license = …` key offset, or miss. -/
public unsafe def findLicenseKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findLicenseKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findLicenseKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findLicenseKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isLicenseKey addr i0 kn) U32.one)
                  i0
                  (findLicenseKeyGo addr (afterLineEnd addr le n) n)))))
       (findLicenseKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `license` key exists (first non-comment match; W79 more14 presence). -/
public unsafe def hasLicense (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findLicenseKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Walk for first `subDir = …` under **first** `[[require]]` scope only. -/
public unsafe def findFirstRequireSubDirKeyGo (addr : USize) (i : USize) (n : USize)
    (phase : U32) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findFirstRequireSubDirKeyGo addr (afterLineEnd addr le n) n phase)
          (bifUSize (U32.beq c0 cLBrack)
            (let hit := isRequireArrayTableHeader addr i0 le
             bifUSize (U32.beq phase U32.two)
               (findFirstRequireSubDirKeyGo addr (afterLineEnd addr le n) n U32.two)
               (bifUSize (U32.beq phase U32.one)
                 (findFirstRequireSubDirKeyGo addr (afterLineEnd addr le n) n U32.two)
                 (bifUSize (U32.beq hit U32.one)
                   (findFirstRequireSubDirKeyGo addr (afterLineEnd addr le n) n U32.one)
                   (findFirstRequireSubDirKeyGo addr (afterLineEnd addr le n) n U32.zero))))
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findFirstRequireSubDirKeyGo addr (afterLineEnd addr le n) n phase)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq phase U32.one)
                  (bifUSize (U32.beq (isSubDirKey addr i0 kn) U32.one)
                    i0
                    (findFirstRequireSubDirKeyGo addr (afterLineEnd addr le n) n phase))
                  (findFirstRequireSubDirKeyGo addr (afterLineEnd addr le n) n phase)))))
       (findFirstRequireSubDirKeyGo addr (afterLineEnd addr le n) n phase))
    USize.neg1

/-- Byte offset of first `[[require]]` `subDir` value (quotes stripped), or miss. **LP64.** -/
public unsafe def firstRequireSubDirOff (addr : USize) (n : USize) : USize :=
  let koff := findFirstRequireSubDirKeyGo addr USize.zero n U32.zero
  bifUSize (USize.beq koff USize.neg1) USize.neg1
    (let le := findLineEnd addr koff n
     let eq := findEq addr koff le
     bifUSize (USize.beq eq USize.neg1) USize.neg1
       (let vo := skipWs addr (USize.add eq USize.one) le
        let ve := rtrimWs addr vo le
        bifUSize (USize.blt ve vo) USize.neg1
          (bifUSize (U32.beq (isUnclosedQuote addr vo ve) U32.one) USize.neg1
            (stripQuoteStart addr vo ve))))

/-- Length of first `[[require]]` `subDir` value (quotes stripped), or `0` on miss. -/
public unsafe def firstRequireSubDirLen (addr : USize) (n : USize) : USize :=
  let koff := findFirstRequireSubDirKeyGo addr USize.zero n U32.zero
  bifUSize (USize.beq koff USize.neg1) USize.zero
    (let le := findLineEnd addr koff n
     let eq := findEq addr koff le
     bifUSize (USize.beq eq USize.neg1) USize.zero
       (let vo := skipWs addr (USize.add eq USize.one) le
        let ve := rtrimWs addr vo le
        bifUSize (USize.blt ve vo) USize.zero
          (bifUSize (U32.beq (isUnclosedQuote addr vo ve) U32.one) USize.zero
            (let s := stripQuoteStart addr vo ve
             let e := stripQuoteEnd addr vo ve
             bifUSize (USize.blt e s) USize.zero (USize.sub e s)))))


/-- `1` if span equals fixed key `readmeFile`. -/
public unsafe def isReadmeFileKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len readmeFileKeyLen)
    (bifU32 (U32.beq (loadAt addr off) rf0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) rf1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) rf2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) rf3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) rf4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) rf5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) rf6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) rf7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) rf8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) rf9)
                        U32.one U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- `1` if span equals fixed key `licenseFiles`. -/
public unsafe def isLicenseFilesKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len licenseFilesKeyLen)
    (bifU32 (U32.beq (loadAt addr off) lf0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) lf1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) lf2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) lf3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) lf4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) lf5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) lf6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) lf7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) lf8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) lf9)
                        (bifU32 (U32.beq (loadAt addr (USize.add off off10)) lf10)
                          (bifU32 (U32.beq (loadAt addr (USize.add off off11)) lf11)
                            U32.one U32.zero)
                          U32.zero)
                        U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- `1` if span equals fixed key `opts`. -/
public unsafe def isOptsKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len optsKeyLen)
    (bifU32 (U32.beq (loadAt addr off) op0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) op1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) op2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) op3)
            U32.one U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `readmeFile = …` key offset, or miss. -/
public unsafe def findReadmeFileKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findReadmeFileKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findReadmeFileKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findReadmeFileKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isReadmeFileKey addr i0 kn) U32.one)
                  i0
                  (findReadmeFileKeyGo addr (afterLineEnd addr le n) n)))))
       (findReadmeFileKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `readmeFile` key exists (first non-comment match; W80 more15 presence). -/
public unsafe def hasReadmeFile (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findReadmeFileKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `licenseFiles = …` key offset, or miss. -/
public unsafe def findLicenseFilesKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findLicenseFilesKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findLicenseFilesKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findLicenseFilesKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isLicenseFilesKey addr i0 kn) U32.one)
                  i0
                  (findLicenseFilesKeyGo addr (afterLineEnd addr le n) n)))))
       (findLicenseFilesKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `licenseFiles` key exists (first non-comment match; W80 more15 presence). -/
public unsafe def hasLicenseFiles (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findLicenseFilesKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Walk for first `opts = …` under **first** `[[require]]` scope only. -/
public unsafe def findFirstRequireOptsKeyGo (addr : USize) (i : USize) (n : USize)
    (phase : U32) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findFirstRequireOptsKeyGo addr (afterLineEnd addr le n) n phase)
          (bifUSize (U32.beq c0 cLBrack)
            (let hit := isRequireArrayTableHeader addr i0 le
             bifUSize (U32.beq phase U32.two)
               (findFirstRequireOptsKeyGo addr (afterLineEnd addr le n) n U32.two)
               (bifUSize (U32.beq phase U32.one)
                 (findFirstRequireOptsKeyGo addr (afterLineEnd addr le n) n U32.two)
                 (bifUSize (U32.beq hit U32.one)
                   (findFirstRequireOptsKeyGo addr (afterLineEnd addr le n) n U32.one)
                   (findFirstRequireOptsKeyGo addr (afterLineEnd addr le n) n U32.zero))))
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findFirstRequireOptsKeyGo addr (afterLineEnd addr le n) n phase)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq phase U32.one)
                  (bifUSize (U32.beq (isOptsKey addr i0 kn) U32.one)
                    i0
                    (findFirstRequireOptsKeyGo addr (afterLineEnd addr le n) n phase))
                  (findFirstRequireOptsKeyGo addr (afterLineEnd addr le n) n phase)))))
       (findFirstRequireOptsKeyGo addr (afterLineEnd addr le n) n phase))
    USize.neg1

/-- Byte offset of first `[[require]]` `opts` value (quotes stripped), or miss. **LP64.** -/
public unsafe def firstRequireOptsOff (addr : USize) (n : USize) : USize :=
  let koff := findFirstRequireOptsKeyGo addr USize.zero n U32.zero
  bifUSize (USize.beq koff USize.neg1) USize.neg1
    (let le := findLineEnd addr koff n
     let eq := findEq addr koff le
     bifUSize (USize.beq eq USize.neg1) USize.neg1
       (let vo := skipWs addr (USize.add eq USize.one) le
        let ve := rtrimWs addr vo le
        bifUSize (USize.blt ve vo) USize.neg1
          (bifUSize (U32.beq (isUnclosedQuote addr vo ve) U32.one) USize.neg1
            (stripQuoteStart addr vo ve))))

/-- Length of first `[[require]]` `opts` value (quotes stripped), or `0` on miss. -/
public unsafe def firstRequireOptsLen (addr : USize) (n : USize) : USize :=
  let koff := findFirstRequireOptsKeyGo addr USize.zero n U32.zero
  bifUSize (USize.beq koff USize.neg1) USize.zero
    (let le := findLineEnd addr koff n
     let eq := findEq addr koff le
     bifUSize (USize.beq eq USize.neg1) USize.zero
       (let vo := skipWs addr (USize.add eq USize.one) le
        let ve := rtrimWs addr vo le
        bifUSize (USize.blt ve vo) USize.zero
          (bifUSize (U32.beq (isUnclosedQuote addr vo ve) U32.one) USize.zero
            (let s := stripQuoteStart addr vo ve
             let e := stripQuoteEnd addr vo ve
             bifUSize (USize.blt e s) USize.zero (USize.sub e s)))))

/-- `1` if span equals fixed key `bootstrap`. -/
public unsafe def isBootstrapKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len bootstrapKeyLen)
    (bifU32 (U32.beq (loadAt addr off) bs0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) bs1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) bs2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) bs3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) bs4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) bs5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) bs6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) bs7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) bs8)
                      U32.one U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- `1` if span equals fixed key `moreServerArgs`. -/
public unsafe def isMoreServerArgsKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len moreServerArgsKeyLen)
    (bifU32 (U32.beq (loadAt addr off) msa0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) msa1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) msa2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) msa3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) msa4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) msa5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) msa6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) msa7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) msa8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) msa9)
                        (bifU32 (U32.beq (loadAt addr (USize.add off off10)) msa10)
                          (bifU32 (U32.beq (loadAt addr (USize.add off off11)) msa11)
                            (bifU32 (U32.beq (loadAt addr (USize.add off off12)) msa12)
                              (bifU32 (U32.beq (loadAt addr (USize.add off off13)) msa13)
                                U32.one U32.zero)
                              U32.zero)
                            U32.zero)
                          U32.zero)
                        U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- `1` if span equals fixed key `releaseRepo`. -/
public unsafe def isReleaseRepoKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len releaseRepoKeyLen)
    (bifU32 (U32.beq (loadAt addr off) rr0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) rr1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) rr2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) rr3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) rr4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) rr5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) rr6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) rr7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) rr8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) rr9)
                        (bifU32 (U32.beq (loadAt addr (USize.add off off10)) rr10)
                          U32.one U32.zero)
                        U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `bootstrap = …` key offset, or miss. -/
public unsafe def findBootstrapKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findBootstrapKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findBootstrapKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findBootstrapKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isBootstrapKey addr i0 kn) U32.one)
                  i0
                  (findBootstrapKeyGo addr (afterLineEnd addr le n) n)))))
       (findBootstrapKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `bootstrap` key exists (first non-comment match; W81 more16 presence). -/
public unsafe def hasBootstrap (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findBootstrapKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `moreServerArgs = …` key offset, or miss. -/
public unsafe def findMoreServerArgsKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findMoreServerArgsKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findMoreServerArgsKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findMoreServerArgsKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isMoreServerArgsKey addr i0 kn) U32.one)
                  i0
                  (findMoreServerArgsKeyGo addr (afterLineEnd addr le n) n)))))
       (findMoreServerArgsKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `moreServerArgs` key exists (first non-comment match; W81 more16 presence). -/
public unsafe def hasMoreServerArgs (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findMoreServerArgsKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `releaseRepo = …` key offset, or miss. -/
public unsafe def findReleaseRepoKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findReleaseRepoKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findReleaseRepoKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findReleaseRepoKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isReleaseRepoKey addr i0 kn) U32.one)
                  i0
                  (findReleaseRepoKeyGo addr (afterLineEnd addr le n) n)))))
       (findReleaseRepoKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `releaseRepo` key exists (first non-comment match; W81 more16 presence). -/
public unsafe def hasReleaseRepo (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findReleaseRepoKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one


/-- `1` if span equals fixed key `leanLibDir`. -/
public unsafe def isLeanLibDirKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len leanLibDirKeyLen)
    (bifU32 (U32.beq (loadAt addr off) lld0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) lld1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) lld2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) lld3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) lld4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) lld5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) lld6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) lld7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) lld8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) lld9)
                        U32.one U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- `1` if span equals fixed key `binDir`. -/
public unsafe def isBinDirKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len binDirKeyLen)
    (bifU32 (U32.beq (loadAt addr off) bd0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) bd1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) bd2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) bd3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) bd4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) bd5)
                U32.one U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- `1` if span equals fixed key `irDir`. -/
public unsafe def isIrDirKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len irDirKeyLen)
    (bifU32 (U32.beq (loadAt addr off) id0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) id1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) id2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) id3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) id4)
              U32.one U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `leanLibDir = …` key offset, or miss. -/
public unsafe def findLeanLibDirKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findLeanLibDirKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findLeanLibDirKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findLeanLibDirKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isLeanLibDirKey addr i0 kn) U32.one)
                  i0
                  (findLeanLibDirKeyGo addr (afterLineEnd addr le n) n)))))
       (findLeanLibDirKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `leanLibDir` key exists (first non-comment match; W82 more17 presence). -/
public unsafe def hasLeanLibDir (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findLeanLibDirKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `binDir = …` key offset, or miss. -/
public unsafe def findBinDirKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findBinDirKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findBinDirKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findBinDirKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isBinDirKey addr i0 kn) U32.one)
                  i0
                  (findBinDirKeyGo addr (afterLineEnd addr le n) n)))))
       (findBinDirKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `binDir` key exists (first non-comment match; W82 more17 presence). -/
public unsafe def hasBinDir (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findBinDirKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `irDir = …` key offset, or miss. -/
public unsafe def findIrDirKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findIrDirKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findIrDirKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findIrDirKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isIrDirKey addr i0 kn) U32.one)
                  i0
                  (findIrDirKeyGo addr (afterLineEnd addr le n) n)))))
       (findIrDirKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if an `irDir` key exists (first non-comment match; W82 more17 presence). -/
public unsafe def hasIrDir (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findIrDirKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one



/-- `1` if span equals fixed key `extraDepTargets`. -/
public unsafe def isExtraDepTargetsKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len extraDepTargetsKeyLen)
    (bifU32 (U32.beq (loadAt addr off) edt0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) edt1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) edt2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) edt3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) edt4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) edt5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) edt6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) edt7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) edt8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) edt9)
                        (bifU32 (U32.beq (loadAt addr (USize.add off off10)) edt10)
                          (bifU32 (U32.beq (loadAt addr (USize.add off off11)) edt11)
                            (bifU32 (U32.beq (loadAt addr (USize.add off off12)) edt12)
                              (bifU32 (U32.beq (loadAt addr (USize.add off off13)) edt13)
                                (bifU32 (U32.beq (loadAt addr (USize.add off off14)) edt14)
                                  U32.one U32.zero)
                                U32.zero)
                              U32.zero)
                            U32.zero)
                          U32.zero)
                        U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- `1` if span equals fixed key `restoreAllArtifacts`. -/
public unsafe def isRestoreAllArtifactsKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len restoreAllArtifactsKeyLen)
    (bifU32 (U32.beq (loadAt addr off) raa0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) raa1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) raa2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) raa3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) raa4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) raa5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) raa6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) raa7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) raa8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) raa9)
                        (bifU32 (U32.beq (loadAt addr (USize.add off off10)) raa10)
                          (bifU32 (U32.beq (loadAt addr (USize.add off off11)) raa11)
                            (bifU32 (U32.beq (loadAt addr (USize.add off off12)) raa12)
                              (bifU32 (U32.beq (loadAt addr (USize.add off off13)) raa13)
                                (bifU32 (U32.beq (loadAt addr (USize.add off off14)) raa14)
                                  (bifU32 (U32.beq (loadAt addr (USize.add off off15)) raa15)
                                    (bifU32 (U32.beq (loadAt addr (USize.add off off16)) raa16)
                                      (bifU32 (U32.beq (loadAt addr (USize.add off off17)) raa17)
                                        (bifU32 (U32.beq (loadAt addr (USize.add off off18)) raa18)
                                          U32.one U32.zero)
                                        U32.zero)
                                      U32.zero)
                                    U32.zero)
                                  U32.zero)
                                U32.zero)
                              U32.zero)
                            U32.zero)
                          U32.zero)
                        U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- `1` if span equals fixed key `libPrefixOnWindows`. -/
public unsafe def isLibPrefixOnWindowsKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len libPrefixOnWindowsKeyLen)
    (bifU32 (U32.beq (loadAt addr off) lpw0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) lpw1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) lpw2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) lpw3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) lpw4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) lpw5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) lpw6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) lpw7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) lpw8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) lpw9)
                        (bifU32 (U32.beq (loadAt addr (USize.add off off10)) lpw10)
                          (bifU32 (U32.beq (loadAt addr (USize.add off off11)) lpw11)
                            (bifU32 (U32.beq (loadAt addr (USize.add off off12)) lpw12)
                              (bifU32 (U32.beq (loadAt addr (USize.add off off13)) lpw13)
                                (bifU32 (U32.beq (loadAt addr (USize.add off off14)) lpw14)
                                  (bifU32 (U32.beq (loadAt addr (USize.add off off15)) lpw15)
                                    (bifU32 (U32.beq (loadAt addr (USize.add off off16)) lpw16)
                                      (bifU32 (U32.beq (loadAt addr (USize.add off off17)) lpw17)
                                        U32.one U32.zero)
                                      U32.zero)
                                    U32.zero)
                                  U32.zero)
                                U32.zero)
                              U32.zero)
                            U32.zero)
                          U32.zero)
                        U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `extraDepTargets = …` key offset, or miss. -/
public unsafe def findExtraDepTargetsKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findExtraDepTargetsKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findExtraDepTargetsKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findExtraDepTargetsKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isExtraDepTargetsKey addr i0 kn) U32.one)
                  i0
                  (findExtraDepTargetsKeyGo addr (afterLineEnd addr le n) n)))))
       (findExtraDepTargetsKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if an `extraDepTargets` key exists (first non-comment match; W83 more18 presence). -/
public unsafe def hasExtraDepTargets (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findExtraDepTargetsKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `restoreAllArtifacts = …` key offset, or miss. -/
public unsafe def findRestoreAllArtifactsKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findRestoreAllArtifactsKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findRestoreAllArtifactsKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findRestoreAllArtifactsKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isRestoreAllArtifactsKey addr i0 kn) U32.one)
                  i0
                  (findRestoreAllArtifactsKeyGo addr (afterLineEnd addr le n) n)))))
       (findRestoreAllArtifactsKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `restoreAllArtifacts` key exists (first non-comment match; W83 more18 presence). -/
public unsafe def hasRestoreAllArtifacts (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findRestoreAllArtifactsKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `libPrefixOnWindows = …` key offset, or miss. -/
public unsafe def findLibPrefixOnWindowsKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findLibPrefixOnWindowsKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findLibPrefixOnWindowsKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findLibPrefixOnWindowsKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isLibPrefixOnWindowsKey addr i0 kn) U32.one)
                  i0
                  (findLibPrefixOnWindowsKeyGo addr (afterLineEnd addr le n) n)))))
       (findLibPrefixOnWindowsKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `libPrefixOnWindows` key exists (first non-comment match; W83 more18 presence). -/
public unsafe def hasLibPrefixOnWindows (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findLibPrefixOnWindowsKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- `1` if span equals fixed key `allowImportAll`. -/
public unsafe def isAllowImportAllKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len allowImportAllKeyLen)
    (bifU32 (U32.beq (loadAt addr off) aia0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) aia1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) aia2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) aia3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) aia4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) aia5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) aia6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) aia7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) aia8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) aia9)
                        (bifU32 (U32.beq (loadAt addr (USize.add off off10)) aia10)
                          (bifU32 (U32.beq (loadAt addr (USize.add off off11)) aia11)
                            (bifU32 (U32.beq (loadAt addr (USize.add off off12)) aia12)
                              (bifU32 (U32.beq (loadAt addr (USize.add off off13)) aia13)
                                U32.one U32.zero)
                              U32.zero)
                            U32.zero)
                          U32.zero)
                        U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- `1` if span equals fixed key `fixedToolchain`. -/
public unsafe def isFixedToolchainKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len fixedToolchainKeyLen)
    (bifU32 (U32.beq (loadAt addr off) ft0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) ft1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) ft2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) ft3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) ft4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) ft5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) ft6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) ft7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) ft8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) ft9)
                        (bifU32 (U32.beq (loadAt addr (USize.add off off10)) ft10)
                          (bifU32 (U32.beq (loadAt addr (USize.add off off11)) ft11)
                            (bifU32 (U32.beq (loadAt addr (USize.add off off12)) ft12)
                              (bifU32 (U32.beq (loadAt addr (USize.add off off13)) ft13)
                                U32.one U32.zero)
                              U32.zero)
                            U32.zero)
                          U32.zero)
                        U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `allowImportAll = …` key offset, or miss. -/
public unsafe def findAllowImportAllKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findAllowImportAllKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findAllowImportAllKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findAllowImportAllKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isAllowImportAllKey addr i0 kn) U32.one)
                  i0
                  (findAllowImportAllKeyGo addr (afterLineEnd addr le n) n)))))
       (findAllowImportAllKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if an `allowImportAll` key exists (first non-comment match; W84 more19 presence). -/
public unsafe def hasAllowImportAll (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findAllowImportAllKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `fixedToolchain = …` key offset, or miss. -/
public unsafe def findFixedToolchainKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findFixedToolchainKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findFixedToolchainKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findFixedToolchainKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isFixedToolchainKey addr i0 kn) U32.one)
                  i0
                  (findFixedToolchainKeyGo addr (afterLineEnd addr le n) n)))))
       (findFixedToolchainKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `fixedToolchain` key exists (first non-comment match; W84 more19 presence). -/
public unsafe def hasFixedToolchain (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findFixedToolchainKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- `1` if a `version` key exists (first non-comment match; W84 more19 presence).

Reuses `findVersionKeyGo` / `isVersionKey` (package version field; presence-only,
not SemVer decode). Complement of `versionOff`/`versionLen` value spans. -/
public unsafe def hasVersion (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findVersionKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- `1` if span equals fixed key `builtinLint`. -/
public unsafe def isBuiltinLintKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len builtinLintKeyLen)
    (bifU32 (U32.beq (loadAt addr off) bl0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) bl1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) bl2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) bl3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) bl4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) bl5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) bl6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) bl7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) bl8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) bl9)
                        (bifU32 (U32.beq (loadAt addr (USize.add off off10)) bl10)
                          U32.one U32.zero)
                        U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `builtinLint = …` key offset, or miss. -/
public unsafe def findBuiltinLintKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findBuiltinLintKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findBuiltinLintKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findBuiltinLintKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isBuiltinLintKey addr i0 kn) U32.one)
                  i0
                  (findBuiltinLintKeyGo addr (afterLineEnd addr le n) n)))))
       (findBuiltinLintKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `builtinLint` key exists (first non-comment match; W85 more20 presence). -/
public unsafe def hasBuiltinLint (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findBuiltinLintKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- `1` if span equals fixed key `moreLeancArgs` (distinct from `moreLeanArgs`). -/
public unsafe def isMoreLeancArgsKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len moreLeancArgsKeyLen)
    (bifU32 (U32.beq (loadAt addr off) mlc0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) mlc1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) mlc2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) mlc3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) mlc4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) mlc5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) mlc6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) mlc7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) mlc8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) mlc9)
                        (bifU32 (U32.beq (loadAt addr (USize.add off off10)) mlc10)
                          (bifU32 (U32.beq (loadAt addr (USize.add off off11)) mlc11)
                            (bifU32 (U32.beq (loadAt addr (USize.add off off12)) mlc12)
                              U32.one U32.zero)
                            U32.zero)
                          U32.zero)
                        U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `moreLeancArgs = …` key offset, or miss. -/
public unsafe def findMoreLeancArgsKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findMoreLeancArgsKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findMoreLeancArgsKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findMoreLeancArgsKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isMoreLeancArgsKey addr i0 kn) U32.one)
                  i0
                  (findMoreLeancArgsKeyGo addr (afterLineEnd addr le n) n)))))
       (findMoreLeancArgsKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `moreLeancArgs` key exists (first non-comment match; W85 more20 presence).

Distinct from `moreLeanArgsCount` (quote-count walker for `moreLeanArgs`). -/
public unsafe def hasMoreLeancArgs (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findMoreLeancArgsKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- `1` if span equals fixed key `allowNonModules`. -/
public unsafe def isAllowNonModulesKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len allowNonModulesKeyLen)
    (bifU32 (U32.beq (loadAt addr off) anm0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) anm1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) anm2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) anm3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) anm4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) anm5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) anm6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) anm7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) anm8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) anm9)
                        (bifU32 (U32.beq (loadAt addr (USize.add off off10)) anm10)
                          (bifU32 (U32.beq (loadAt addr (USize.add off off11)) anm11)
                            (bifU32 (U32.beq (loadAt addr (USize.add off off12)) anm12)
                              (bifU32 (U32.beq (loadAt addr (USize.add off off13)) anm13)
                                (bifU32 (U32.beq (loadAt addr (USize.add off off14)) anm14)
                                  U32.one U32.zero)
                                U32.zero)
                              U32.zero)
                            U32.zero)
                          U32.zero)
                        U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `allowNonModules = …` key offset, or miss. -/
public unsafe def findAllowNonModulesKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findAllowNonModulesKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findAllowNonModulesKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findAllowNonModulesKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isAllowNonModulesKey addr i0 kn) U32.one)
                  i0
                  (findAllowNonModulesKeyGo addr (afterLineEnd addr le n) n)))))
       (findAllowNonModulesKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if an `allowNonModules` key exists (first non-comment match; W85 more20 presence). -/
public unsafe def hasAllowNonModules (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findAllowNonModulesKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- `1` if span equals fixed key `requiresModuleSystem`. -/
public unsafe def isRequiresModuleSystemKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len requiresModuleSystemKeyLen)
    (bifU32 (U32.beq (loadAt addr off) rms0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) rms1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) rms2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) rms3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) rms4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) rms5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) rms6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) rms7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) rms8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) rms9)
                        (bifU32 (U32.beq (loadAt addr (USize.add off off10)) rms10)
                          (bifU32 (U32.beq (loadAt addr (USize.add off off11)) rms11)
                            (bifU32 (U32.beq (loadAt addr (USize.add off off12)) rms12)
                              (bifU32 (U32.beq (loadAt addr (USize.add off off13)) rms13)
                                (bifU32 (U32.beq (loadAt addr (USize.add off off14)) rms14)
                                  (bifU32 (U32.beq (loadAt addr (USize.add off off15)) rms15)
                                    (bifU32 (U32.beq (loadAt addr (USize.add off off16)) rms16)
                                      (bifU32 (U32.beq (loadAt addr (USize.add off off17)) rms17)
                                        (bifU32 (U32.beq (loadAt addr (USize.add off off18)) rms18)
                                          (bifU32 (U32.beq (loadAt addr (USize.add off off19)) rms19)
                                            U32.one U32.zero)
                                          U32.zero)
                                        U32.zero)
                                      U32.zero)
                                    U32.zero)
                                  U32.zero)
                                U32.zero)
                              U32.zero)
                            U32.zero)
                          U32.zero)
                        U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `requiresModuleSystem = …` key offset, or miss. -/
public unsafe def findRequiresModuleSystemKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findRequiresModuleSystemKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findRequiresModuleSystemKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findRequiresModuleSystemKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isRequiresModuleSystemKey addr i0 kn) U32.one)
                  i0
                  (findRequiresModuleSystemKeyGo addr (afterLineEnd addr le n) n)))))
       (findRequiresModuleSystemKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `requiresModuleSystem` key exists (first non-comment match; W86 more21 presence). -/
public unsafe def hasRequiresModuleSystem (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findRequiresModuleSystemKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- `1` if span equals fixed key `weakLeancArgs` (distinct from `weakLeanArgs`). -/
public unsafe def isWeakLeancArgsKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len weakLeancArgsKeyLen)
    (bifU32 (U32.beq (loadAt addr off) wlc0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) wlc1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) wlc2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) wlc3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) wlc4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) wlc5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) wlc6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) wlc7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) wlc8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) wlc9)
                        (bifU32 (U32.beq (loadAt addr (USize.add off off10)) wlc10)
                          (bifU32 (U32.beq (loadAt addr (USize.add off off11)) wlc11)
                            (bifU32 (U32.beq (loadAt addr (USize.add off off12)) wlc12)
                              U32.one U32.zero)
                            U32.zero)
                          U32.zero)
                        U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `weakLeancArgs = …` key offset, or miss. -/
public unsafe def findWeakLeancArgsKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findWeakLeancArgsKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findWeakLeancArgsKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findWeakLeancArgsKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isWeakLeancArgsKey addr i0 kn) U32.one)
                  i0
                  (findWeakLeancArgsKeyGo addr (afterLineEnd addr le n) n)))))
       (findWeakLeancArgsKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `weakLeancArgs` key exists (first non-comment match; W86 more21 presence).

Distinct from `weakLeanArgsCount` (quote-count walker for `weakLeanArgs`). -/
public unsafe def hasWeakLeancArgs (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findWeakLeancArgsKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- `1` if span equals fixed key `moreLinkObjs` (distinct from `moreLinkArgs`). -/
public unsafe def isMoreLinkObjsKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len moreLinkObjsKeyLen)
    (bifU32 (U32.beq (loadAt addr off) mlo0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) mlo1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) mlo2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) mlo3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) mlo4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) mlo5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) mlo6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) mlo7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) mlo8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) mlo9)
                        (bifU32 (U32.beq (loadAt addr (USize.add off off10)) mlo10)
                          (bifU32 (U32.beq (loadAt addr (USize.add off off11)) mlo11)
                            U32.one U32.zero)
                          U32.zero)
                        U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `moreLinkObjs = …` key offset, or miss. -/
public unsafe def findMoreLinkObjsKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findMoreLinkObjsKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findMoreLinkObjsKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findMoreLinkObjsKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isMoreLinkObjsKey addr i0 kn) U32.one)
                  i0
                  (findMoreLinkObjsKeyGo addr (afterLineEnd addr le n) n)))))
       (findMoreLinkObjsKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `moreLinkObjs` key exists (first non-comment match; W86 more21 presence).

Distinct from `hasMoreLinkArgs` / `moreLinkArgsCount` (moreLinkArgs key). -/
public unsafe def hasMoreLinkObjs (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findMoreLinkObjsKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- `1` if span equals fixed key `moreLinkLibs` (distinct from `moreLinkArgs` / `moreLinkObjs`). -/
public unsafe def isMoreLinkLibsKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len moreLinkLibsKeyLen)
    (bifU32 (U32.beq (loadAt addr off) mll0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) mll1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) mll2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) mll3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) mll4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) mll5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) mll6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) mll7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) mll8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) mll9)
                        (bifU32 (U32.beq (loadAt addr (USize.add off off10)) mll10)
                          (bifU32 (U32.beq (loadAt addr (USize.add off off11)) mll11)
                            U32.one U32.zero)
                          U32.zero)
                        U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `moreLinkLibs = …` key offset, or miss. -/
public unsafe def findMoreLinkLibsKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findMoreLinkLibsKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findMoreLinkLibsKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findMoreLinkLibsKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isMoreLinkLibsKey addr i0 kn) U32.one)
                  i0
                  (findMoreLinkLibsKeyGo addr (afterLineEnd addr le n) n)))))
       (findMoreLinkLibsKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `moreLinkLibs` key exists (first non-comment match; W87 more22 presence).

Distinct from `hasMoreLinkArgs` / `moreLinkArgsCount` (moreLinkArgs) and
`hasMoreLinkObjs` (moreLinkObjs). -/
public unsafe def hasMoreLinkLibs (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findMoreLinkLibsKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- `1` if span equals fixed key `dynlibs`. -/
public unsafe def isDynlibsKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len dynlibsKeyLen)
    (bifU32 (U32.beq (loadAt addr off) dyn0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) dyn1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) dyn2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) dyn3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) dyn4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) dyn5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) dyn6)
                  U32.one U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `dynlibs = …` key offset, or miss. -/
public unsafe def findDynlibsKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findDynlibsKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findDynlibsKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findDynlibsKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isDynlibsKey addr i0 kn) U32.one)
                  i0
                  (findDynlibsKeyGo addr (afterLineEnd addr le n) n)))))
       (findDynlibsKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `dynlibs` key exists (first non-comment match; W87 more22 presence). -/
public unsafe def hasDynlibs (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findDynlibsKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- `1` if span equals fixed key `plugins`. -/
public unsafe def isPluginsKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len pluginsKeyLen)
    (bifU32 (U32.beq (loadAt addr off) plg0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) plg1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) plg2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) plg3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) plg4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) plg5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) plg6)
                  U32.one U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `plugins = …` key offset, or miss. -/
public unsafe def findPluginsKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findPluginsKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findPluginsKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findPluginsKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isPluginsKey addr i0 kn) U32.one)
                  i0
                  (findPluginsKeyGo addr (afterLineEnd addr le n) n)))))
       (findPluginsKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `plugins` key exists (first non-comment match; W87 more22 presence).

Distinct from `hasDynlibs` (dynlibs key). -/
public unsafe def hasPlugins (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findPluginsKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- `1` if span equals fixed key `defaultFacets`. -/
public unsafe def isDefaultFacetsKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len defaultFacetsKeyLen)
    (bifU32 (U32.beq (loadAt addr off) df0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) df1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) df2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) df3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) df4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) df5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) df6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) df7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) df8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) df9)
                        (bifU32 (U32.beq (loadAt addr (USize.add off off10)) df10)
                          (bifU32 (U32.beq (loadAt addr (USize.add off off11)) df11)
                            (bifU32 (U32.beq (loadAt addr (USize.add off off12)) df12)
                              U32.one U32.zero)
                            U32.zero)
                          U32.zero)
                        U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `defaultFacets = …` key offset, or miss. -/
public unsafe def findDefaultFacetsKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findDefaultFacetsKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findDefaultFacetsKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findDefaultFacetsKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isDefaultFacetsKey addr i0 kn) U32.one)
                  i0
                  (findDefaultFacetsKeyGo addr (afterLineEnd addr le n) n)))))
       (findDefaultFacetsKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `defaultFacets` key exists (first non-comment match; W88 more23 presence).

Distinct from facet value decode — presence-only. -/
public unsafe def hasDefaultFacets (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findDefaultFacetsKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- `1` if span equals fixed key `moreGlobalServerArgs`. -/
public unsafe def isMoreGlobalServerArgsKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len moreGlobalServerArgsKeyLen)
    (bifU32 (U32.beq (loadAt addr off) mgs0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) mgs1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) mgs2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) mgs3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) mgs4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) mgs5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) mgs6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) mgs7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) mgs8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) mgs9)
                        (bifU32 (U32.beq (loadAt addr (USize.add off off10)) mgs10)
                          (bifU32 (U32.beq (loadAt addr (USize.add off off11)) mgs11)
                            (bifU32 (U32.beq (loadAt addr (USize.add off off12)) mgs12)
                              (bifU32 (U32.beq (loadAt addr (USize.add off off13)) mgs13)
                                (bifU32 (U32.beq (loadAt addr (USize.add off off14)) mgs14)
                                  (bifU32 (U32.beq (loadAt addr (USize.add off off15)) mgs15)
                                    (bifU32 (U32.beq (loadAt addr (USize.add off off16)) mgs16)
                                      (bifU32 (U32.beq (loadAt addr (USize.add off off17)) mgs17)
                                        (bifU32 (U32.beq (loadAt addr (USize.add off off18)) mgs18)
                                          (bifU32 (U32.beq (loadAt addr (USize.add off off19)) mgs19)
                                            U32.one U32.zero)
                                          U32.zero)
                                        U32.zero)
                                      U32.zero)
                                    U32.zero)
                                  U32.zero)
                                U32.zero)
                              U32.zero)
                            U32.zero)
                          U32.zero)
                        U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `moreGlobalServerArgs = …` key offset, or miss. -/
public unsafe def findMoreGlobalServerArgsKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findMoreGlobalServerArgsKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findMoreGlobalServerArgsKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findMoreGlobalServerArgsKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isMoreGlobalServerArgsKey addr i0 kn) U32.one)
                  i0
                  (findMoreGlobalServerArgsKeyGo addr (afterLineEnd addr le n) n)))))
       (findMoreGlobalServerArgsKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `moreGlobalServerArgs` key exists (first non-comment match; W88 more23 presence).

Distinct from `hasMoreServerArgs` (moreServerArgs) and `hasMoreServerOptions`. -/
public unsafe def hasMoreGlobalServerArgs (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findMoreGlobalServerArgsKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- `1` if span equals fixed key `libName`. -/
public unsafe def isLibNameKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len libNameKeyLen)
    (bifU32 (U32.beq (loadAt addr off) ln0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) ln1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) ln2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) ln3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) ln4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) ln5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) ln6)
                  U32.one U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `libName = …` key offset, or miss. -/
public unsafe def findLibNameKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findLibNameKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findLibNameKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findLibNameKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isLibNameKey addr i0 kn) U32.one)
                  i0
                  (findLibNameKeyGo addr (afterLineEnd addr le n) n)))))
       (findLibNameKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `libName` key exists (first non-comment match; W88 more23 presence).

Distinct from `hasNativeLibDir` / `hasLeanLibDir`. -/
public unsafe def hasLibName (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findLibNameKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one


/-- Find first non-comment `scope = …` key offset, or miss. -/
public unsafe def findScopeKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findScopeKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findScopeKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findScopeKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isScopeKey addr i0 kn) U32.one)
                  i0
                  (findScopeKeyGo addr (afterLineEnd addr le n) n)))))
       (findScopeKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `scope` key exists (first non-comment match; W89 more24 presence).

Package/dep scope presence-only; not value decode. -/
public unsafe def hasScope (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findScopeKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- `1` if span equals fixed key `remoteUrl`. -/
public unsafe def isRemoteUrlKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len remoteUrlKeyLen)
    (bifU32 (U32.beq (loadAt addr off) ru0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) ru1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) ru2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) ru3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) ru4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) ru5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) ru6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) ru7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) ru8)
                      U32.one U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `remoteUrl = …` key offset, or miss. -/
public unsafe def findRemoteUrlKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findRemoteUrlKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findRemoteUrlKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findRemoteUrlKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isRemoteUrlKey addr i0 kn) U32.one)
                  i0
                  (findRemoteUrlKeyGo addr (afterLineEnd addr le n) n)))))
       (findRemoteUrlKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `remoteUrl` key exists (first non-comment match; W89 more24 presence).

Package remote URL presence-only; not value decode. -/
public unsafe def hasRemoteUrl (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findRemoteUrlKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- `1` if a `weakLeanArgs` key exists (first non-comment match; W89 more24 presence).

Reuses more3 `findWeakLeanArgsKeyGo`. Distinct from `weakLeanArgsCount` quote-count
and from `hasWeakLeancArgs` (`weakLeancArgs`). -/
public unsafe def hasWeakLeanArgs (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findWeakLeanArgsKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one


/-- `1` if span equals fixed key `freestanding`. -/
public unsafe def isFreestandingKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len freestandingKeyLen)
    (bifU32 (U32.beq (loadAt addr off) fs0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) fs1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) fs2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) fs3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) fs4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) fs5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) fs6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) fs7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) fs8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) fs9)
                        (bifU32 (U32.beq (loadAt addr (USize.add off off10)) fs10)
                          (bifU32 (U32.beq (loadAt addr (USize.add off off11)) fs11)
                            U32.one U32.zero)
                          U32.zero)
                        U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `freestanding = …` key offset, or miss. -/
public unsafe def findFreestandingKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findFreestandingKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findFreestandingKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findFreestandingKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isFreestandingKey addr i0 kn) U32.one)
                  i0
                  (findFreestandingKeyGo addr (afterLineEnd addr le n) n)))))
       (findFreestandingKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `freestanding` key exists (first non-comment match; W90 more25 presence).

LeanLibConfig freestanding presence-only; not value decode. -/
public unsafe def hasFreestanding (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findFreestandingKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- `1` if span equals fixed key `roots`. -/
public unsafe def isRootsKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len rootsKeyLen)
    (bifU32 (U32.beq (loadAt addr off) rt0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) rt1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) rt2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) rt3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) rt4)
              U32.one U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `roots = …` key offset, or miss. -/
public unsafe def findRootsKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findRootsKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findRootsKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findRootsKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isRootsKey addr i0 kn) U32.one)
                  i0
                  (findRootsKeyGo addr (afterLineEnd addr le n) n)))))
       (findRootsKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `roots` key exists (first non-comment match; W90 more25 presence).

LeanLibConfig roots presence-only; not value decode. -/
public unsafe def hasRoots (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findRootsKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- `1` if span equals fixed key `globs`. -/
public unsafe def isGlobsKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len globsKeyLen)
    (bifU32 (U32.beq (loadAt addr off) gb0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) gb1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) gb2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) gb3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) gb4)
              U32.one U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `globs = …` key offset, or miss. -/
public unsafe def findGlobsKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findGlobsKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findGlobsKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findGlobsKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isGlobsKey addr i0 kn) U32.one)
                  i0
                  (findGlobsKeyGo addr (afterLineEnd addr le n) n)))))
       (findGlobsKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `globs` key exists (first non-comment match; W90 more25 presence).

LeanLibConfig globs presence-only; not value decode. -/
public unsafe def hasGlobs (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findGlobsKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one


/-- `1` if span equals fixed key `needs`. -/
public unsafe def isNeedsKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len needsKeyLen)
    (bifU32 (U32.beq (loadAt addr off) nd0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) nd1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) nd2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) nd3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) nd4)
              U32.one U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `needs = …` key offset, or miss. -/
public unsafe def findNeedsKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findNeedsKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findNeedsKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findNeedsKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isNeedsKey addr i0 kn) U32.one)
                  i0
                  (findNeedsKeyGo addr (afterLineEnd addr le n) n)))))
       (findNeedsKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `needs` key exists (first non-comment match; W91 more26 presence).

LeanLibConfig/LeanExeConfig needs presence-only; not value decode. -/
public unsafe def hasNeeds (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findNeedsKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- `1` if a `weakLinkArgs` key exists (first non-comment match; W91 more26 presence).

LeanConfig weakLinkArgs presence-only (reuses more6 finder); distinct from
`weakLinkArgsCount` quote-count and from `hasWeakLeanArgs` / `hasWeakLeancArgs`. -/
public unsafe def hasWeakLinkArgs (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findWeakLinkArgsKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- `1` if span equals fixed key `exeName`. -/
public unsafe def isExeNameKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len exeNameKeyLen)
    (bifU32 (U32.beq (loadAt addr off) en0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) en1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) en2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) en3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) en4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) en5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) en6)
                  U32.one U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `exeName = …` key offset, or miss. -/
public unsafe def findExeNameKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findExeNameKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findExeNameKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findExeNameKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isExeNameKey addr i0 kn) U32.one)
                  i0
                  (findExeNameKeyGo addr (afterLineEnd addr le n) n)))))
       (findExeNameKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if an `exeName` key exists (first non-comment match; W91 more26 presence).

LeanExeConfig exeName presence-only; not value decode. -/
public unsafe def hasExeName (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findExeNameKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one


/-- `1` if a `moreLeanArgs` key exists (first non-comment match; W92 more27 presence).

LeanConfig moreLeanArgs presence-only (reuses more3 finder); distinct from
`moreLeanArgsCount` quote-count and from `hasMoreLeancArgs` / `hasMoreLinkArgs`. -/
public unsafe def hasMoreLeanArgs (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findMoreLeanArgsKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- `1` if span equals fixed key `nativeFacets`. -/
public unsafe def isNativeFacetsKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len nativeFacetsKeyLen)
    (bifU32 (U32.beq (loadAt addr off) nf0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) nf1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) nf2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) nf3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) nf4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) nf5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) nf6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) nf7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) nf8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) nf9)
                        (bifU32 (U32.beq (loadAt addr (USize.add off off10)) nf10)
                          (bifU32 (U32.beq (loadAt addr (USize.add off off11)) nf11)
                            U32.one U32.zero)
                          U32.zero)
                        U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `nativeFacets = …` key offset, or miss. -/
public unsafe def findNativeFacetsKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findNativeFacetsKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findNativeFacetsKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findNativeFacetsKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isNativeFacetsKey addr i0 kn) U32.one)
                  i0
                  (findNativeFacetsKeyGo addr (afterLineEnd addr le n) n)))))
       (findNativeFacetsKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `nativeFacets` key exists (first non-comment match; W92 more27 presence).

LeanLibConfig/LeanExeConfig nativeFacets presence-only; not value decode.
(Lake TOML loader may exclude decode of this field; key name is still real.) -/
public unsafe def hasNativeFacets (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findNativeFacetsKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `root = …` key offset, or miss.

Uses existing `isRootKey` (LeanExeConfig `root`; distinct from `roots` / `hasRoots`). -/
public unsafe def findRootKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findRootKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findRootKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findRootKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isRootKey addr i0 kn) U32.one)
                  i0
                  (findRootKeyGo addr (afterLineEnd addr le n) n)))))
       (findRootKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `root` key exists (first non-comment match; W92 more27 presence).

LeanExeConfig `root` presence-only; distinct from `hasRoots` (`roots`) and `hasSrcDir`.
Not value decode. -/
public unsafe def hasRoot (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findRootKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Key `testRunner` length (10). -/
@[extern c inline "((size_t)10)"] public axiom testRunnerKeyLen : USize
/-- `t` of `testRunner`. -/
@[extern c inline "((uint32_t)116)"] public axiom tr0 : U32
/-- `e` of `testRunner`. -/
@[extern c inline "((uint32_t)101)"] public axiom tr1 : U32
/-- `s` of `testRunner`. -/
@[extern c inline "((uint32_t)115)"] public axiom tr2 : U32
/-- `t` of `testRunner`. -/
@[extern c inline "((uint32_t)116)"] public axiom tr3 : U32
/-- `R` of `testRunner`. -/
@[extern c inline "((uint32_t)82)"] public axiom tr4 : U32
/-- `u` of `testRunner`. -/
@[extern c inline "((uint32_t)117)"] public axiom tr5 : U32
/-- `n` of `testRunner`. -/
@[extern c inline "((uint32_t)110)"] public axiom tr6 : U32
/-- `n` of `testRunner`. -/
@[extern c inline "((uint32_t)110)"] public axiom tr7 : U32
/-- `e` of `testRunner`. -/
@[extern c inline "((uint32_t)101)"] public axiom tr8 : U32
/-- `r` of `testRunner`. -/
@[extern c inline "((uint32_t)114)"] public axiom tr9 : U32

/-- `1` if a `name` key exists (first non-comment match; W93 more28 presence).

PackageConfig / lean_lib / lean_exe `name` presence-only (reuses package name finder);
distinct from `packageNameOff` / `packageNameLen` value spans. Not value decode. -/
public unsafe def hasName (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findNameKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- `1` if a literal `leanArgs` key exists (first non-comment match; W93 more28 presence).

**Honesty:** Lake TOML PackageConfig/LeanConfig fields use `moreLeanArgs` (and weak*
variants); runtime `Module.leanArgs` / `LeanLib.leanArgs` / `Workspace.leanArgs` are
**derived** accumulations, not a first-class TOML schema field. This matcher is
literal-byte presence of the key text `leanArgs` (reuses more4 finder) — useful for
corpus / reverse-peer vs `hasMoreLeanArgs`, **not** a PackageConfig TOML field claim.
Distinct from `leanArgsCount` quote-count and from `hasMoreLeanArgs` / `hasWeakLeanArgs`.
Not value decode. -/
public unsafe def hasLeanArgs (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findLeanArgsKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- `1` if span equals fixed key `testRunner`. -/
public unsafe def isTestRunnerKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len testRunnerKeyLen)
    (bifU32 (U32.beq (loadAt addr off) tr0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) tr1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) tr2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) tr3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) tr4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) tr5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) tr6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) tr7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) tr8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) tr9)
                        U32.one U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `testRunner = …` key offset, or miss. -/
public unsafe def findTestRunnerKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findTestRunnerKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findTestRunnerKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findTestRunnerKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isTestRunnerKey addr i0 kn) U32.one)
                  i0
                  (findTestRunnerKeyGo addr (afterLineEnd addr le n) n)))))
       (findTestRunnerKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `testRunner` key exists (first non-comment match; W93 more28 presence).

PackageConfig `testRunner` (alias of `testDriver`) presence-only; distinct from
`hasTestDriver`. Not value decode. -/
public unsafe def hasTestRunner (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findTestRunnerKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one


/-- Key `serverOptions` length (13). -/
@[extern c inline "((size_t)13)"] public axiom soKeyLen : USize
/-- `s` of `serverOptions`. -/
@[extern c inline "((uint32_t)115)"] public axiom so0 : U32
/-- `e` of `serverOptions`. -/
@[extern c inline "((uint32_t)101)"] public axiom so1 : U32
/-- `r` of `serverOptions`. -/
@[extern c inline "((uint32_t)114)"] public axiom so2 : U32
/-- `v` of `serverOptions`. -/
@[extern c inline "((uint32_t)118)"] public axiom so3 : U32
/-- `e` of `serverOptions`. -/
@[extern c inline "((uint32_t)101)"] public axiom so4 : U32
/-- `r` of `serverOptions`. -/
@[extern c inline "((uint32_t)114)"] public axiom so5 : U32
/-- `O` of `serverOptions`. -/
@[extern c inline "((uint32_t)79)"] public axiom so6 : U32
/-- `p` of `serverOptions`. -/
@[extern c inline "((uint32_t)112)"] public axiom so7 : U32
/-- `t` of `serverOptions`. -/
@[extern c inline "((uint32_t)116)"] public axiom so8 : U32
/-- `i` of `serverOptions`. -/
@[extern c inline "((uint32_t)105)"] public axiom so9 : U32
/-- `o` of `serverOptions`. -/
@[extern c inline "((uint32_t)111)"] public axiom so10 : U32
/-- `n` of `serverOptions`. -/
@[extern c inline "((uint32_t)110)"] public axiom so11 : U32
/-- `s` of `serverOptions`. -/
@[extern c inline "((uint32_t)115)"] public axiom so12 : U32

/-- `1` if span equals fixed key `serverOptions`. -/
public unsafe def isServerOptionsKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len soKeyLen)
    (bifU32 (U32.beq (loadAt addr off) so0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) so1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) so2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) so3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) so4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) so5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) so6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) so7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) so8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) so9)
                        (bifU32 (U32.beq (loadAt addr (USize.add off off10)) so10)
                          (bifU32 (U32.beq (loadAt addr (USize.add off off11)) so11)
                            (bifU32 (U32.beq (loadAt addr (USize.add off off12)) so12)
                              U32.one U32.zero)
                            U32.zero)
                          U32.zero)
                        U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `serverOptions = …` key offset, or miss. -/
public unsafe def findServerOptionsKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findServerOptionsKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findServerOptionsKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findServerOptionsKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isServerOptionsKey addr i0 kn) U32.one)
                  i0
                  (findServerOptionsKeyGo addr (afterLineEnd addr le n) n)))))
       (findServerOptionsKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `serverOptions` key exists (first non-comment match; W94 more29 presence).

**Honesty:** Lake TOML LeanConfig fields use `moreServerOptions`; runtime
`Module.serverOptions` / `LeanLib.serverOptions` / `Workspace.serverOptions` are
**derived** accumulations, not a first-class TOML schema field. This matcher is
literal-byte presence of the key text `serverOptions` — useful for corpus /
reverse-peer vs `hasMoreServerOptions`, **not** a PackageConfig TOML field claim.
Distinct from `hasMoreServerOptions` / `hasMoreServerArgs` / `hasMoreGlobalServerArgs`.
Not value decode. -/
public unsafe def hasServerOptions (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findServerOptionsKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Key `leancArgs` length (9). -/
@[extern c inline "((size_t)9)"] public axiom lcaKeyLen : USize
/-- `l` of `leancArgs`. -/
@[extern c inline "((uint32_t)108)"] public axiom lca0 : U32
/-- `e` of `leancArgs`. -/
@[extern c inline "((uint32_t)101)"] public axiom lca1 : U32
/-- `a` of `leancArgs`. -/
@[extern c inline "((uint32_t)97)"] public axiom lca2 : U32
/-- `n` of `leancArgs`. -/
@[extern c inline "((uint32_t)110)"] public axiom lca3 : U32
/-- `c` of `leancArgs`. -/
@[extern c inline "((uint32_t)99)"] public axiom lca4 : U32
/-- `A` of `leancArgs`. -/
@[extern c inline "((uint32_t)65)"] public axiom lca5 : U32
/-- `r` of `leancArgs`. -/
@[extern c inline "((uint32_t)114)"] public axiom lca6 : U32
/-- `g` of `leancArgs`. -/
@[extern c inline "((uint32_t)103)"] public axiom lca7 : U32
/-- `s` of `leancArgs`. -/
@[extern c inline "((uint32_t)115)"] public axiom lca8 : U32

/-- `1` if span equals fixed key `leancArgs`. -/
public unsafe def isLeancArgsKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len lcaKeyLen)
    (bifU32 (U32.beq (loadAt addr off) lca0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) lca1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) lca2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) lca3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) lca4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) lca5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) lca6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) lca7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) lca8)
                      U32.one U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `leancArgs = …` key offset, or miss. -/
public unsafe def findLeancArgsKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findLeancArgsKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findLeancArgsKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findLeancArgsKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isLeancArgsKey addr i0 kn) U32.one)
                  i0
                  (findLeancArgsKeyGo addr (afterLineEnd addr le n) n)))))
       (findLeancArgsKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `leancArgs` key exists (first non-comment match; W94 more29 presence).

**Honesty:** Lake TOML LeanConfig fields use `moreLeancArgs` (and weak*
variants); runtime `Module.leancArgs` / `LeanLib.leancArgs` are **derived**
accumulations (buildType + package + lib), not a first-class TOML schema field.
This matcher is literal-byte presence of the key text `leancArgs` — reverse-peer
vs `hasMoreLeancArgs` / `hasWeakLeancArgs`, **not** a PackageConfig TOML field claim.
Distinct from `hasMoreLeancArgs` / `hasWeakLeancArgs` / `hasMoreLeanArgs` / `hasLeanArgs`.
Not value decode. -/
public unsafe def hasLeancArgs (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findLeancArgsKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Key `baseName` length (8). -/
@[extern c inline "((size_t)8)"] public axiom bnKeyLen : USize
/-- `b` of `baseName`. -/
@[extern c inline "((uint32_t)98)"] public axiom bn0 : U32
/-- `a` of `baseName`. -/
@[extern c inline "((uint32_t)97)"] public axiom bn1 : U32
/-- `s` of `baseName`. -/
@[extern c inline "((uint32_t)115)"] public axiom bn2 : U32
/-- `e` of `baseName`. -/
@[extern c inline "((uint32_t)101)"] public axiom bn3 : U32
/-- `N` of `baseName`. -/
@[extern c inline "((uint32_t)78)"] public axiom bn4 : U32
/-- `a` of `baseName`. -/
@[extern c inline "((uint32_t)97)"] public axiom bn5 : U32
/-- `m` of `baseName`. -/
@[extern c inline "((uint32_t)109)"] public axiom bn6 : U32
/-- `e` of `baseName`. -/
@[extern c inline "((uint32_t)101)"] public axiom bn7 : U32

/-- `1` if span equals fixed key `baseName`. -/
public unsafe def isBaseNameKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len bnKeyLen)
    (bifU32 (U32.beq (loadAt addr off) bn0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) bn1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) bn2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) bn3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) bn4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) bn5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) bn6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) bn7)
                    U32.one U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `baseName = …` key offset, or miss. -/
public unsafe def findBaseNameKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findBaseNameKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findBaseNameKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findBaseNameKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isBaseNameKey addr i0 kn) U32.one)
                  i0
                  (findBaseNameKeyGo addr (afterLineEnd addr le n) n)))))
       (findBaseNameKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `baseName` key exists (first non-comment match; W94 more29 presence).

**Honesty:** `Package.baseName` / `PackageConfig` carry an author package name,
but Lake TOML load sets `baseName` from the package `name` / path — there is **no**
first-class TOML schema field `baseName`. This matcher is literal-byte presence of
the key text `baseName` (corpus / reverse-peer vs `hasName`), **not** a PackageConfig
TOML field claim.
Distinct from `hasName` / `packageNameOff` / `packageNameLen`.
Not value decode. -/
public unsafe def hasBaseName (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findBaseNameKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one


/-- Key `linkArgs` length (8). -/
@[extern c inline "((size_t)8)"] public axiom lkaKeyLen : USize
/-- `l` of `linkArgs`. -/
@[extern c inline "((uint32_t)108)"] public axiom lka0 : U32
/-- `i` of `linkArgs`. -/
@[extern c inline "((uint32_t)105)"] public axiom lka1 : U32
/-- `n` of `linkArgs`. -/
@[extern c inline "((uint32_t)110)"] public axiom lka2 : U32
/-- `k` of `linkArgs`. -/
@[extern c inline "((uint32_t)107)"] public axiom lka3 : U32
/-- `A` of `linkArgs`. -/
@[extern c inline "((uint32_t)65)"] public axiom lka4 : U32
/-- `r` of `linkArgs`. -/
@[extern c inline "((uint32_t)114)"] public axiom lka5 : U32
/-- `g` of `linkArgs`. -/
@[extern c inline "((uint32_t)103)"] public axiom lka6 : U32
/-- `s` of `linkArgs`. -/
@[extern c inline "((uint32_t)115)"] public axiom lka7 : U32

/-- `1` if span equals fixed key `linkArgs`. -/
public unsafe def isLinkArgsKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len lkaKeyLen)
    (bifU32 (U32.beq (loadAt addr off) lka0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) lka1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) lka2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) lka3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) lka4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) lka5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) lka6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) lka7)
                    U32.one U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `linkArgs = …` key offset, or miss. -/
public unsafe def findLinkArgsKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findLinkArgsKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findLinkArgsKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findLinkArgsKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isLinkArgsKey addr i0 kn) U32.one)
                  i0
                  (findLinkArgsKeyGo addr (afterLineEnd addr le n) n)))))
       (findLinkArgsKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `linkArgs` key exists (first non-comment match; W95 more30 presence).

**Honesty:** Lake TOML LeanConfig fields use `moreLinkArgs` (and weak*
variants); runtime link arg lists are **derived** accumulations, not a first-class
TOML schema field. This matcher is literal-byte presence of the key text `linkArgs` —
reverse-peer vs `hasMoreLinkArgs` / `hasWeakLinkArgs`, **not** a PackageConfig TOML field claim.
Distinct from `hasMoreLinkArgs` / `hasWeakLinkArgs` / `hasMoreLinkObjs` / `hasMoreLinkLibs`.
Not value decode. -/
public unsafe def hasLinkArgs (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findLinkArgsKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Key `serverArgs` length (10). -/
@[extern c inline "((size_t)10)"] public axiom saKeyLen : USize
/-- `s` of `serverArgs`. -/
@[extern c inline "((uint32_t)115)"] public axiom sa0 : U32
/-- `e` of `serverArgs`. -/
@[extern c inline "((uint32_t)101)"] public axiom sa1 : U32
/-- `r` of `serverArgs`. -/
@[extern c inline "((uint32_t)114)"] public axiom sa2 : U32
/-- `v` of `serverArgs`. -/
@[extern c inline "((uint32_t)118)"] public axiom sa3 : U32
/-- `e` of `serverArgs`. -/
@[extern c inline "((uint32_t)101)"] public axiom sa4 : U32
/-- `r` of `serverArgs`. -/
@[extern c inline "((uint32_t)114)"] public axiom sa5 : U32
/-- `A` of `serverArgs`. -/
@[extern c inline "((uint32_t)65)"] public axiom sa6 : U32
/-- `r` of `serverArgs`. -/
@[extern c inline "((uint32_t)114)"] public axiom sa7 : U32
/-- `g` of `serverArgs`. -/
@[extern c inline "((uint32_t)103)"] public axiom sa8 : U32
/-- `s` of `serverArgs`. -/
@[extern c inline "((uint32_t)115)"] public axiom sa9 : U32

/-- `1` if span equals fixed key `serverArgs`. -/
public unsafe def isServerArgsKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len saKeyLen)
    (bifU32 (U32.beq (loadAt addr off) sa0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) sa1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) sa2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) sa3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) sa4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) sa5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) sa6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) sa7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) sa8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) sa9)
                        U32.one U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `serverArgs = …` key offset, or miss. -/
public unsafe def findServerArgsKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findServerArgsKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findServerArgsKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findServerArgsKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isServerArgsKey addr i0 kn) U32.one)
                  i0
                  (findServerArgsKeyGo addr (afterLineEnd addr le n) n)))))
       (findServerArgsKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `serverArgs` key exists (first non-comment match; W95 more30 presence).

**Honesty:** Lake TOML PackageConfig fields use `moreServerArgs` (alias of
`moreGlobalServerArgs`); runtime server arg lists are **derived** accumulations.
This matcher is literal-byte presence of the key text `serverArgs` — reverse-peer
vs `hasMoreServerArgs`, **not** a PackageConfig TOML field claim.
Distinct from `hasMoreServerArgs` / `hasMoreGlobalServerArgs` / `hasMoreServerOptions` / `hasServerOptions`.
Not value decode. -/
public unsafe def hasServerArgs (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findServerArgsKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Key `globalServerArgs` length (16). -/
@[extern c inline "((size_t)16)"] public axiom gsaKeyLen : USize
/-- `g` of `globalServerArgs`. -/
@[extern c inline "((uint32_t)103)"] public axiom gsa0 : U32
/-- `l` of `globalServerArgs`. -/
@[extern c inline "((uint32_t)108)"] public axiom gsa1 : U32
/-- `o` of `globalServerArgs`. -/
@[extern c inline "((uint32_t)111)"] public axiom gsa2 : U32
/-- `b` of `globalServerArgs`. -/
@[extern c inline "((uint32_t)98)"] public axiom gsa3 : U32
/-- `a` of `globalServerArgs`. -/
@[extern c inline "((uint32_t)97)"] public axiom gsa4 : U32
/-- `l` of `globalServerArgs`. -/
@[extern c inline "((uint32_t)108)"] public axiom gsa5 : U32
/-- `S` of `globalServerArgs`. -/
@[extern c inline "((uint32_t)83)"] public axiom gsa6 : U32
/-- `e` of `globalServerArgs`. -/
@[extern c inline "((uint32_t)101)"] public axiom gsa7 : U32
/-- `r` of `globalServerArgs`. -/
@[extern c inline "((uint32_t)114)"] public axiom gsa8 : U32
/-- `v` of `globalServerArgs`. -/
@[extern c inline "((uint32_t)118)"] public axiom gsa9 : U32
/-- `e` of `globalServerArgs`. -/
@[extern c inline "((uint32_t)101)"] public axiom gsa10 : U32
/-- `r` of `globalServerArgs`. -/
@[extern c inline "((uint32_t)114)"] public axiom gsa11 : U32
/-- `A` of `globalServerArgs`. -/
@[extern c inline "((uint32_t)65)"] public axiom gsa12 : U32
/-- `r` of `globalServerArgs`. -/
@[extern c inline "((uint32_t)114)"] public axiom gsa13 : U32
/-- `g` of `globalServerArgs`. -/
@[extern c inline "((uint32_t)103)"] public axiom gsa14 : U32
/-- `s` of `globalServerArgs`. -/
@[extern c inline "((uint32_t)115)"] public axiom gsa15 : U32

/-- `1` if span equals fixed key `globalServerArgs`. -/
public unsafe def isGlobalServerArgsKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len gsaKeyLen)
    (bifU32 (U32.beq (loadAt addr off) gsa0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) gsa1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) gsa2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) gsa3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) gsa4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) gsa5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) gsa6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) gsa7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) gsa8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) gsa9)
                        (bifU32 (U32.beq (loadAt addr (USize.add off off10)) gsa10)
                          (bifU32 (U32.beq (loadAt addr (USize.add off off11)) gsa11)
                            (bifU32 (U32.beq (loadAt addr (USize.add off off12)) gsa12)
                              (bifU32 (U32.beq (loadAt addr (USize.add off off13)) gsa13)
                                (bifU32 (U32.beq (loadAt addr (USize.add off off14)) gsa14)
                                  (bifU32 (U32.beq (loadAt addr (USize.add off off15)) gsa15)
                                    U32.one U32.zero)
                                  U32.zero)
                                U32.zero)
                              U32.zero)
                            U32.zero)
                          U32.zero)
                        U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `globalServerArgs = …` key offset, or miss. -/
public unsafe def findGlobalServerArgsKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findGlobalServerArgsKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findGlobalServerArgsKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findGlobalServerArgsKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isGlobalServerArgsKey addr i0 kn) U32.one)
                  i0
                  (findGlobalServerArgsKeyGo addr (afterLineEnd addr le n) n)))))
       (findGlobalServerArgsKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `globalServerArgs` key exists (first non-comment match; W95 more30 presence).

**Honesty:** Lake TOML PackageConfig fields use `moreGlobalServerArgs` (alias
`moreServerArgs`); there is **no** first-class TOML schema field `globalServerArgs`.
This matcher is literal-byte presence of the key text `globalServerArgs` — reverse-peer
vs `hasMoreGlobalServerArgs` / `hasMoreServerArgs`, **not** a PackageConfig TOML field claim.
Distinct from `hasMoreGlobalServerArgs` / `hasMoreServerArgs` / `hasServerArgs` / `hasServerOptions`.
Not value decode. -/
public unsafe def hasGlobalServerArgs (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findGlobalServerArgsKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Key `linkObjs` length (8). -/
@[extern c inline "((size_t)8)"] public axiom lkoKeyLen : USize
/-- `l` of `linkObjs`. -/
@[extern c inline "((uint32_t)108)"] public axiom lko0 : U32
/-- `i` of `linkObjs`. -/
@[extern c inline "((uint32_t)105)"] public axiom lko1 : U32
/-- `n` of `linkObjs`. -/
@[extern c inline "((uint32_t)110)"] public axiom lko2 : U32
/-- `k` of `linkObjs`. -/
@[extern c inline "((uint32_t)107)"] public axiom lko3 : U32
/-- `O` of `linkObjs`. -/
@[extern c inline "((uint32_t)79)"] public axiom lko4 : U32
/-- `b` of `linkObjs`. -/
@[extern c inline "((uint32_t)98)"] public axiom lko5 : U32
/-- `j` of `linkObjs`. -/
@[extern c inline "((uint32_t)106)"] public axiom lko6 : U32
/-- `s` of `linkObjs`. -/
@[extern c inline "((uint32_t)115)"] public axiom lko7 : U32

/-- `1` if span equals fixed key `linkObjs`. -/
public unsafe def isLinkObjsKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len lkoKeyLen)
    (bifU32 (U32.beq (loadAt addr off) lko0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) lko1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) lko2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) lko3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) lko4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) lko5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) lko6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) lko7)
                    U32.one U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `linkObjs = …` key offset, or miss. -/
public unsafe def findLinkObjsKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findLinkObjsKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findLinkObjsKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findLinkObjsKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isLinkObjsKey addr i0 kn) U32.one)
                  i0
                  (findLinkObjsKeyGo addr (afterLineEnd addr le n) n)))))
       (findLinkObjsKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `linkObjs` key exists (first non-comment match; W96 more31 presence).

**Honesty:** Lake TOML LeanConfig fields use `moreLinkObjs`; runtime link object
lists are **derived** accumulations (build `linkObjs` parameters).
This matcher is literal-byte presence of the key text `linkObjs` — reverse-peer
vs `hasMoreLinkObjs`, **not** a PackageConfig/LeanConfig TOML field claim.
Distinct from `hasMoreLinkObjs` / `hasMoreLinkLibs` / `hasLinkLibs` / `hasMoreLinkArgs` / `hasLinkArgs`.
Not value decode. -/
public unsafe def hasLinkObjs (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findLinkObjsKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Key `linkLibs` length (8). -/
@[extern c inline "((size_t)8)"] public axiom lklKeyLen : USize
/-- `l` of `linkLibs`. -/
@[extern c inline "((uint32_t)108)"] public axiom lkl0 : U32
/-- `i` of `linkLibs`. -/
@[extern c inline "((uint32_t)105)"] public axiom lkl1 : U32
/-- `n` of `linkLibs`. -/
@[extern c inline "((uint32_t)110)"] public axiom lkl2 : U32
/-- `k` of `linkLibs`. -/
@[extern c inline "((uint32_t)107)"] public axiom lkl3 : U32
/-- `L` of `linkLibs`. -/
@[extern c inline "((uint32_t)76)"] public axiom lkl4 : U32
/-- `i` of `linkLibs`. -/
@[extern c inline "((uint32_t)105)"] public axiom lkl5 : U32
/-- `b` of `linkLibs`. -/
@[extern c inline "((uint32_t)98)"] public axiom lkl6 : U32
/-- `s` of `linkLibs`. -/
@[extern c inline "((uint32_t)115)"] public axiom lkl7 : U32

/-- `1` if span equals fixed key `linkLibs`. -/
public unsafe def isLinkLibsKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len lklKeyLen)
    (bifU32 (U32.beq (loadAt addr off) lkl0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) lkl1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) lkl2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) lkl3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) lkl4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) lkl5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) lkl6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) lkl7)
                    U32.one U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `linkLibs = …` key offset, or miss. -/
public unsafe def findLinkLibsKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findLinkLibsKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findLinkLibsKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findLinkLibsKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isLinkLibsKey addr i0 kn) U32.one)
                  i0
                  (findLinkLibsKeyGo addr (afterLineEnd addr le n) n)))))
       (findLinkLibsKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `linkLibs` key exists (first non-comment match; W96 more31 presence).

**Honesty:** Lake TOML LeanConfig fields use `moreLinkLibs`; runtime link library
lists are **derived** accumulations (build `linkLibs` parameters).
This matcher is literal-byte presence of the key text `linkLibs` — reverse-peer
vs `hasMoreLinkLibs`, **not** a PackageConfig/LeanConfig TOML field claim.
Distinct from `hasMoreLinkLibs` / `hasMoreLinkObjs` / `hasLinkObjs` / `hasMoreLinkArgs` / `hasLinkArgs` / `hasDynlibs`.
Not value decode. -/
public unsafe def hasLinkLibs (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findLinkLibsKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Key `options` length (7). -/
@[extern c inline "((size_t)7)"] public axiom roptKeyLen : USize
/-- `o` of `options`. -/
@[extern c inline "((uint32_t)111)"] public axiom ropt0 : U32
/-- `p` of `options`. -/
@[extern c inline "((uint32_t)112)"] public axiom ropt1 : U32
/-- `t` of `options`. -/
@[extern c inline "((uint32_t)116)"] public axiom ropt2 : U32
/-- `i` of `options`. -/
@[extern c inline "((uint32_t)105)"] public axiom ropt3 : U32
/-- `o` of `options`. -/
@[extern c inline "((uint32_t)111)"] public axiom ropt4 : U32
/-- `n` of `options`. -/
@[extern c inline "((uint32_t)110)"] public axiom ropt5 : U32
/-- `s` of `options`. -/
@[extern c inline "((uint32_t)115)"] public axiom ropt6 : U32

/-- `1` if span equals fixed key `options`. -/
public unsafe def isOptionsKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len roptKeyLen)
    (bifU32 (U32.beq (loadAt addr off) ropt0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) ropt1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) ropt2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) ropt3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) ropt4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) ropt5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) ropt6)
                  U32.one U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `options = …` key offset, or miss. -/
public unsafe def findOptionsKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findOptionsKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findOptionsKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findOptionsKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isOptionsKey addr i0 kn) U32.one)
                  i0
                  (findOptionsKeyGo addr (afterLineEnd addr le n) n)))))
       (findOptionsKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `options` key exists (first non-comment match; W96 more31 presence).

**Honesty:** Lake TOML `[[require]]` tables decode an `options` name-map field
(`Dependency.opts`); this is a **real** require-table key (not PackageConfig).
Presence-only at any non-comment key site (table bodies not excluded) — distinct
from `firstRequireOptsOff`/`firstRequireOptsLen` value spans and from `hasLeanOptions`.
Not value decode. -/
public unsafe def hasOptions (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findOptionsKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one


/-- Find first non-comment `git = …` key offset, or miss. -/
public unsafe def findGitKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findGitKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findGitKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findGitKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isGitKey addr i0 kn) U32.one)
                  i0
                  (findGitKeyGo addr (afterLineEnd addr le n) n)))))
       (findGitKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `git` key exists (first non-comment match; W97 more32 presence).

**Honesty:** Lake TOML `[[require]]` tables decode a `git` URL field
(`DependencySrc.git`); this is a **real** require-table key (not PackageConfig).
Presence-only at any non-comment key site (table bodies not excluded) — distinct
from `firstRequireGitOff`/`firstRequireGitLen` value spans (first-require scoped).
Not value decode. Distinct from `hasPath` / `hasRev` / `hasRemoteUrl` / `hasUrl`. -/
public unsafe def hasGit (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findGitKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `path` key offset, or miss (literal key text `path`). -/
public unsafe def findPathKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findPathKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findPathKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findPathKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isPathKey addr i0 kn) U32.one)
                  i0
                  (findPathKeyGo addr (afterLineEnd addr le n) n)))))
       (findPathKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `path` key exists (first non-comment match; W97 more32 presence).

**Honesty:** Lake TOML `[[require]]` tables decode a `path` field
(`DependencySrc.path`); this is a **real** require-table key (not PackageConfig).
Presence-only at any non-comment key site (table bodies not excluded) — distinct
from `firstRequirePathOff`/`firstRequirePathLen` value spans and from path-count
helpers. Not value decode. Distinct from `hasGit` / `hasRev` / `hasSrcDir` /
`hasPackagesDir` / `hasBuildDir`. -/
public unsafe def hasPath (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findPathKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `rev` key offset, or miss. -/
public unsafe def findRevKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findRevKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findRevKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findRevKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isRevKey addr i0 kn) U32.one)
                  i0
                  (findRevKeyGo addr (afterLineEnd addr le n) n)))))
       (findRevKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `rev` key exists (first non-comment match; W97 more32 presence).

**Honesty:** Lake TOML `[[require]]` tables decode a `rev` field on git deps
(`DependencySrc.git` rev); this is a **real** require-table key (not PackageConfig).
Presence-only at any non-comment key site (table bodies not excluded) — distinct
from `firstRequireRevOff`/`firstRequireRevLen` value spans. Not value decode.
Distinct from `hasGit` / `hasPath` / `hasVersion` / `hasVersionTags`. -/
public unsafe def hasRev (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findRevKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one


/-- Find first non-comment `subDir` key offset, or miss (literal key text `subDir`). -/
public unsafe def findSubDirKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findSubDirKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findSubDirKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findSubDirKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isSubDirKey addr i0 kn) U32.one)
                  i0
                  (findSubDirKeyGo addr (afterLineEnd addr le n) n)))))
       (findSubDirKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `subDir` key exists (first non-comment match; W98 more33 presence).

**Honesty:** Lake TOML `[[require]]` / DependencySrc.git decode optional `subDir`
(path under the git clone); this is a **real** require-table key (not PackageConfig).
Presence-only at any non-comment key site (table bodies not excluded) — distinct
from `firstRequireSubDirOff`/`firstRequireSubDirLen` first-require-scoped value spans.
Not value decode. Distinct from `hasSrcDir` / `hasPath` / `hasPackagesDir` / `hasBuildDir`. -/
public unsafe def hasSubDir (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findSubDirKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `url` key offset, or miss (literal key text `url`). -/
public unsafe def findUrlKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findUrlKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findUrlKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findUrlKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isUrlKey addr i0 kn) U32.one)
                  i0
                  (findUrlKeyGo addr (afterLineEnd addr le n) n)))))
       (findUrlKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `url` key exists (first non-comment match; W98 more33 presence).

**Honesty:** Lake TOML DependencySrc.git table form uses `url` inside a `git = { … }`
table (`t.tryDecode \`url`); also honest **literal-byte** key match at any non-comment
site. Presence-only — not value decode. Distinct from `hasGit` / `hasRemoteUrl` /
`hasHomepage` / `hasPath`. Reverse peer vs `git` string form is cross-key band. -/
public unsafe def hasUrl (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findUrlKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `opts` key offset, or miss (literal key text `opts`). -/
public unsafe def findOptsKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findOptsKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findOptsKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findOptsKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isOptsKey addr i0 kn) U32.one)
                  i0
                  (findOptsKeyGo addr (afterLineEnd addr le n) n)))))
       (findOptsKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if an `opts` key exists (first non-comment match; W98 more33 presence).

**Honesty:** Lake TOML `[[require]]` historically used literal `opts = …` for dep
options; current Lake Dependency.decodeToml reads **`options`** (`tryDecodeD \`options`).
This matcher is **literal-byte** presence for key text `opts` (four bytes) — honest
residual key scan / historical spelling; **not** `hasOptions` (PackageConfig/lib
`options` key). Distinct from `firstRequireOptsOff`/`firstRequireOptsLen` value spans
and from `hasOptions` / `hasLeanOptions` / `hasMoreServerOptions`. Not value decode. -/
public unsafe def hasOpts (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findOptsKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one


/-- Match key text `type` (four bytes). -/
public unsafe def isTypeKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len typeKeyLen)
    (bifU32 (U32.beq (loadAt addr off) ty0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) ty1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) ty2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) ty3)
            U32.one U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Match key text `dir` (three bytes). -/
public unsafe def isDirKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len dirKeyLen)
    (bifU32 (U32.beq (loadAt addr off) dir0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) dir1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) dir2)
          U32.one U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Match key text `source` (six bytes). -/
public unsafe def isSourceKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len sourceKeyLen)
    (bifU32 (U32.beq (loadAt addr off) src0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) src1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) src2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) src3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) src4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) src5)
                U32.one U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `type` key offset, or miss (literal key text `type`). -/
public unsafe def findTypeKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findTypeKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findTypeKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findTypeKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isTypeKey addr i0 kn) U32.one)
                  i0
                  (findTypeKeyGo addr (afterLineEnd addr le n) n)))))
       (findTypeKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `type` key exists (first non-comment match; W99 more34 presence).

**Honesty:** Lake TOML `DependencySrc.decodeToml` reads `type` (`"path"` / `"git"`) on
table-form dependency sources. Presence-only literal-byte key scan at any non-comment
site — not value decode. Distinct from `hasBuildType` (PackageConfig buildType) and
from `hasPath` / `hasGit` string-form DependencySrc keys. -/
public unsafe def hasType (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findTypeKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `dir` key offset, or miss (literal key text `dir`). -/
public unsafe def findDirKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findDirKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findDirKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findDirKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isDirKey addr i0 kn) U32.one)
                  i0
                  (findDirKeyGo addr (afterLineEnd addr le n) n)))))
       (findDirKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `dir` key exists (first non-comment match; W99 more34 presence).

**Honesty:** Lake TOML `DependencySrc` path table form uses `dir` (`t.decode \`dir`) when
`type = "path"`. Presence-only literal-byte — not value decode. Distinct from `hasPath`
(string-form `path = …` DependencySrc) / `hasSrcDir` / `hasBuildDir` / `hasSubDir`. -/
public unsafe def hasDir (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findDirKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `source` key offset, or miss (literal key text `source`). -/
public unsafe def findSourceKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findSourceKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findSourceKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findSourceKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isSourceKey addr i0 kn) U32.one)
                  i0
                  (findSourceKeyGo addr (afterLineEnd addr le n) n)))))
       (findSourceKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `source` key exists (first non-comment match; W99 more34 presence).

**Honesty:** Lake TOML `Dependency.decodeToml` falls back to `t.decode? \`source` when
neither top-level `path` nor `git` is present. Presence-only literal-byte key scan —
not value/table decode. Distinct from `hasSrcDir` / `hasGit` / `hasPath` / `hasType`. -/
public unsafe def hasSource (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findSourceKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Match key text `kind` (four bytes). -/
public unsafe def isKindKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len kindKeyLen)
    (bifU32 (U32.beq (loadAt addr off) kind0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) kind1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) kind2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) kind3)
            U32.one U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Match key text `preset` (six bytes). -/
public unsafe def isPresetKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len presetKeyLen)
    (bifU32 (U32.beq (loadAt addr off) pre0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) pre1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) pre2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) pre3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) pre4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) pre5)
                U32.one U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Match key text `extension` (nine bytes). -/
public unsafe def isExtensionKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len extensionKeyLen)
    (bifU32 (U32.beq (loadAt addr off) ext0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) ext1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) ext2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) ext3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) ext4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) ext5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) ext6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) ext7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) ext8)
                      U32.one U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `kind` key offset, or miss (literal key text `kind`). -/
public unsafe def findKindKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findKindKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findKindKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findKindKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isKindKey addr i0 kn) U32.one)
                  i0
                  (findKindKeyGo addr (afterLineEnd addr le n) n)))))
       (findKindKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `kind` key exists (first non-comment match; W100 more35 presence).

**Honesty:** Lake TOML uses `kind` on cache/service and custom-data config tables
(`LakeConfig` / `CacheServiceConfig` / `CustomData`). Presence-only literal-byte key
scan at any non-comment site — not value decode. Distinct from `hasKey` / `hasType` /
`hasKeywords`. -/
public unsafe def hasKind (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findKindKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `preset` key offset, or miss (literal key text `preset`). -/
public unsafe def findPresetKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findPresetKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findPresetKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findPresetKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isPresetKey addr i0 kn) U32.one)
                  i0
                  (findPresetKeyGo addr (afterLineEnd addr le n) n)))))
       (findPresetKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `preset` key exists (first non-comment match; W100 more35 presence).

**Honesty:** Lake TOML `Pattern.decodeToml` reads `preset` for named version-tag /
pattern presets (`t.decode? \`preset`). Presence-only literal-byte — not value decode.
Distinct from `hasVersionTags` / `hasPreferReleaseBuild` / `hasPrecompileModules`. -/
public unsafe def hasPreset (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findPresetKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `extension` key offset, or miss (literal key text `extension`). -/
public unsafe def findExtensionKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findExtensionKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findExtensionKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findExtensionKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isExtensionKey addr i0 kn) U32.one)
                  i0
                  (findExtensionKeyGo addr (afterLineEnd addr le n) n)))))
       (findExtensionKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if an `extension` key exists (first non-comment match; W100 more35 presence).

**Honesty:** Lake TOML `PathPatDescr.decodeToml` reads `extension` for path patterns
(`t.decode? \`extension`). Presence-only literal-byte — not value decode. Distinct from
`hasExeName` / `hasExtraDepTargets` / `hasEnableArtifactCache`. -/
public unsafe def hasExtension (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findExtensionKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Match key text `filter` (six bytes). -/
public unsafe def isFilterKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len filterKeyLen)
    (bifU32 (U32.beq (loadAt addr off) fil0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) fil1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) fil2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) fil3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) fil4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) fil5)
                U32.one U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Match key text `text` (four bytes). -/
public unsafe def isTextKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len textKeyLen)
    (bifU32 (U32.beq (loadAt addr off) txt0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) txt1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) txt2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) txt3)
            U32.one U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Match key text `fileName` (eight bytes). -/
public unsafe def isFileNameKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len fileNameKeyLen)
    (bifU32 (U32.beq (loadAt addr off) fn0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) fn1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) fn2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) fn3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) fn4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) fn5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) fn6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) fn7)
                    U32.one U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `filter` key offset, or miss (literal key text `filter`). -/
public unsafe def findFilterKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findFilterKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findFilterKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findFilterKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isFilterKey addr i0 kn) U32.one)
                  i0
                  (findFilterKeyGo addr (afterLineEnd addr le n) n)))))
       (findFilterKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `filter` key exists (first non-comment match; W101 more36 presence).

**Honesty:** Lake TOML InputDir config reads `filter` for include/exclude path patterns.
Presence-only literal-byte key scan at any non-comment site — not value decode. Distinct from
`hasFileName` / `hasExtension` / `hasPath` / `hasGlobs`. -/
public unsafe def hasFilter (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findFilterKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `text` key offset, or miss (literal key text `text`). -/
public unsafe def findTextKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findTextKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findTextKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findTextKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isTextKey addr i0 kn) U32.one)
                  i0
                  (findTextKeyGo addr (afterLineEnd addr le n) n)))))
       (findTextKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `text` key exists (first non-comment match; W101 more36 presence).

**Honesty:** Lake TOML InputFile/InputDir config reads `text` for text-mode input targets.
Presence-only literal-byte — not value decode. Distinct from `hasTestDriver` / `hasType` /
`hasTestRunner` / `hasExtension`. -/
public unsafe def hasText (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findTextKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `fileName` key offset, or miss (literal key text `fileName`). -/
public unsafe def findFileNameKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findFileNameKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findFileNameKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findFileNameKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isFileNameKey addr i0 kn) U32.one)
                  i0
                  (findFileNameKeyGo addr (afterLineEnd addr le n) n)))))
       (findFileNameKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `fileName` key exists (first non-comment match; W101 more36 presence).

**Honesty:** Lake TOML `PathPatDescr.decodeToml` reads `fileName` for path patterns
(`t.decode? \`fileName`). Presence-only literal-byte — not value decode. Distinct from
`hasName` / `hasExeName` / `hasLibName` / `hasExtension` / `hasFilter`. -/
public unsafe def hasFileName (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findFileNameKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one


/-- Match key text `startsWith` (ten bytes). -/
public unsafe def isStartsWithKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len startsWithKeyLen)
    (bifU32 (U32.beq (loadAt addr off) sw0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) sw1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) sw2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) sw3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) sw4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) sw5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) sw6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) sw7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) sw8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) sw9)
                        U32.one U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Match key text `endsWith` (eight bytes). -/
public unsafe def isEndsWithKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len endsWithKeyLen)
    (bifU32 (U32.beq (loadAt addr off) ew0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) ew1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) ew2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) ew3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) ew4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) ew5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) ew6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) ew7)
                    U32.one U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Match key text `not` (three bytes). -/
public unsafe def isNotKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len notKeyLen)
    (bifU32 (U32.beq (loadAt addr off) nt0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) nt1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) nt2)
          U32.one U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `startsWith` key offset, or miss (literal key text `startsWith`). -/
public unsafe def findStartsWithKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findStartsWithKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findStartsWithKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findStartsWithKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isStartsWithKey addr i0 kn) U32.one)
                  i0
                  (findStartsWithKeyGo addr (afterLineEnd addr le n) n)))))
       (findStartsWithKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `startsWith` key exists (first non-comment match; W102 more37 presence).

**Honesty:** Lake TOML `StrPatDescr.decodeToml` / path string patterns read `startsWith`
(`t.decode? \`startsWith`). Presence-only literal-byte — not value decode. Distinct from
`hasEndsWith` / `hasNot` / `hasPreset` / `hasExtension` / `hasFilter`. -/
public unsafe def hasStartsWith (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findStartsWithKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `endsWith` key offset, or miss (literal key text `endsWith`). -/
public unsafe def findEndsWithKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findEndsWithKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findEndsWithKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findEndsWithKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isEndsWithKey addr i0 kn) U32.one)
                  i0
                  (findEndsWithKeyGo addr (afterLineEnd addr le n) n)))))
       (findEndsWithKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if an `endsWith` key exists (first non-comment match; W102 more37 presence).

**Honesty:** Lake TOML `StrPatDescr.decodeToml` / path string patterns read `endsWith`
(`t.decode? \`endsWith`). Presence-only literal-byte — not value decode. Distinct from
`hasStartsWith` / `hasNot` / `hasExtension` / `hasFileName`. -/
public unsafe def hasEndsWith (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findEndsWithKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `not` key offset, or miss (literal key text `not`). -/
public unsafe def findNotKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findNotKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findNotKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findNotKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isNotKey addr i0 kn) U32.one)
                  i0
                  (findNotKeyGo addr (afterLineEnd addr le n) n)))))
       (findNotKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `not` key exists (first non-comment match; W102 more37 presence).

**Honesty:** Lake TOML PathPatDescr/StrPatDescr decode reads `not` for negation patterns
(`t.decode? \`not`). Presence-only literal-byte — not value decode. Distinct from
`hasName` / `hasNeeds` / `hasNativeFacets` / `hasStartsWith` / `hasEndsWith`. Short key
`not` is intentional (three ASCII bytes). -/
public unsafe def hasNot (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findNotKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Match key text `any` (three bytes). -/
public unsafe def isAnyKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len anyKeyLen)
    (bifU32 (U32.beq (loadAt addr off) any0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) any1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) any2)
          U32.one U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Match key text `all` (three bytes). -/
public unsafe def isAllKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len allKeyLen)
    (bifU32 (U32.beq (loadAt addr off) all0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) all1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) all2)
          U32.one U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Match key text `apiEndpoint` (eleven bytes). -/
public unsafe def isApiEndpointKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len apiEndpointKeyLen)
    (bifU32 (U32.beq (loadAt addr off) ae0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) ae1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) ae2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) ae3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) ae4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) ae5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) ae6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) ae7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) ae8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) ae9)
                        (bifU32 (U32.beq (loadAt addr (USize.add off off10)) ae10)
                          U32.one U32.zero)
                        U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `any` key offset, or miss (literal key text `any`). -/
public unsafe def findAnyKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findAnyKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findAnyKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findAnyKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isAnyKey addr i0 kn) U32.one)
                  i0
                  (findAnyKeyGo addr (afterLineEnd addr le n) n)))))
       (findAnyKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if an `any` key exists (first non-comment match; W103 more38 presence).

**Honesty:** Lake TOML `PatternDescr.decodeToml` reads `any` for disjunction patterns
(`t.decode? \`any`). Presence-only literal-byte — not value decode. Distinct from
`hasAll` / `hasNot` / `hasStartsWith` / `hasApiEndpoint`. Short key `any` is intentional. -/
public unsafe def hasAny (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findAnyKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `all` key offset, or miss (literal key text `all`). -/
public unsafe def findAllKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findAllKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findAllKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findAllKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isAllKey addr i0 kn) U32.one)
                  i0
                  (findAllKeyGo addr (afterLineEnd addr le n) n)))))
       (findAllKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if an `all` key exists (first non-comment match; W103 more38 presence).

**Honesty:** Lake TOML `PatternDescr.decodeToml` reads `all` for conjunction patterns
(`t.decode? \`all`). Presence-only literal-byte — not value decode. Distinct from
`hasAny` / `hasNot` / `hasAllowImportAll` / `hasApiEndpoint`. Short key `all` is intentional. -/
public unsafe def hasAll (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findAllKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `apiEndpoint` key offset, or miss (literal key text `apiEndpoint`). -/
public unsafe def findApiEndpointKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findApiEndpointKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findApiEndpointKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findApiEndpointKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isApiEndpointKey addr i0 kn) U32.one)
                  i0
                  (findApiEndpointKeyGo addr (afterLineEnd addr le n) n)))))
       (findApiEndpointKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if an `apiEndpoint` key exists (first non-comment match; W103 more38 presence).

**Honesty:** Lake TOML LakeConfig / cache service decode reads `apiEndpoint`
(`t.decode? \`apiEndpoint`). Presence-only literal-byte — not value decode. Distinct from
`hasAny` / `hasAll` / `hasUrl` / `hasHomepage` / `hasRemoteUrl`. -/
public unsafe def hasApiEndpoint (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findApiEndpointKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one


/-- Match key text `artifactEndpoint` (sixteen bytes). -/
public unsafe def isArtifactEndpointKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len artifactEndpointKeyLen)
    (bifU32 (U32.beq (loadAt addr off) art0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) art1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) art2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) art3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) art4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) art5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) art6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) art7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) art8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) art9)
                        (bifU32 (U32.beq (loadAt addr (USize.add off off10)) art10)
                          (bifU32 (U32.beq (loadAt addr (USize.add off off11)) art11)
                            (bifU32 (U32.beq (loadAt addr (USize.add off off12)) art12)
                              (bifU32 (U32.beq (loadAt addr (USize.add off off13)) art13)
                                (bifU32 (U32.beq (loadAt addr (USize.add off off14)) art14)
                                  (bifU32 (U32.beq (loadAt addr (USize.add off off15)) art15)
                                    U32.one U32.zero)
                                  U32.zero)
                                U32.zero)
                              U32.zero)
                            U32.zero)
                          U32.zero)
                        U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Match key text `revisionEndpoint` (sixteen bytes). -/
public unsafe def isRevisionEndpointKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len revisionEndpointKeyLen)
    (bifU32 (U32.beq (loadAt addr off) reE0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) reE1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) reE2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) reE3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) reE4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) reE5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) reE6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) reE7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) reE8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) reE9)
                        (bifU32 (U32.beq (loadAt addr (USize.add off off10)) reE10)
                          (bifU32 (U32.beq (loadAt addr (USize.add off off11)) reE11)
                            (bifU32 (U32.beq (loadAt addr (USize.add off off12)) reE12)
                              (bifU32 (U32.beq (loadAt addr (USize.add off off13)) reE13)
                                (bifU32 (U32.beq (loadAt addr (USize.add off off14)) reE14)
                                  (bifU32 (U32.beq (loadAt addr (USize.add off off15)) reE15)
                                    U32.one U32.zero)
                                  U32.zero)
                                U32.zero)
                              U32.zero)
                            U32.zero)
                          U32.zero)
                        U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Match key text `defaultService` (fourteen bytes). -/
public unsafe def isDefaultServiceKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len defaultServiceKeyLen)
    (bifU32 (U32.beq (loadAt addr off) dsv0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) dsv1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) dsv2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) dsv3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) dsv4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) dsv5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) dsv6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) dsv7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) dsv8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) dsv9)
                        (bifU32 (U32.beq (loadAt addr (USize.add off off10)) dsv10)
                          (bifU32 (U32.beq (loadAt addr (USize.add off off11)) dsv11)
                            (bifU32 (U32.beq (loadAt addr (USize.add off off12)) dsv12)
                              (bifU32 (U32.beq (loadAt addr (USize.add off off13)) dsv13)
                                U32.one U32.zero)
                              U32.zero)
                            U32.zero)
                          U32.zero)
                        U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `artifactEndpoint` key offset, or miss. -/
public unsafe def findArtifactEndpointKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findArtifactEndpointKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findArtifactEndpointKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findArtifactEndpointKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isArtifactEndpointKey addr i0 kn) U32.one)
                  i0
                  (findArtifactEndpointKeyGo addr (afterLineEnd addr le n) n)))))
       (findArtifactEndpointKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if an `artifactEndpoint` key exists (first non-comment match; W104 more39 presence).

**Honesty:** Lake TOML CacheServiceConfig decode reads `artifactEndpoint`
(`t.decode? \`artifactEndpoint`). Presence-only literal-byte — not value decode. Distinct from
`hasRevisionEndpoint` / `hasApiEndpoint` / `hasDefaultService` / `hasUrl`. -/
public unsafe def hasArtifactEndpoint (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findArtifactEndpointKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `revisionEndpoint` key offset, or miss. -/
public unsafe def findRevisionEndpointKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findRevisionEndpointKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findRevisionEndpointKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findRevisionEndpointKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isRevisionEndpointKey addr i0 kn) U32.one)
                  i0
                  (findRevisionEndpointKeyGo addr (afterLineEnd addr le n) n)))))
       (findRevisionEndpointKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `revisionEndpoint` key exists (first non-comment match; W104 more39 presence).

**Honesty:** Lake TOML CacheServiceConfig decode reads `revisionEndpoint`
(`t.decode? \`revisionEndpoint`). Presence-only literal-byte — not value decode. Distinct from
`hasArtifactEndpoint` / `hasApiEndpoint` / `hasDefaultService` / `hasRev`. -/
public unsafe def hasRevisionEndpoint (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findRevisionEndpointKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `defaultService` key offset, or miss. -/
public unsafe def findDefaultServiceKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findDefaultServiceKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findDefaultServiceKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findDefaultServiceKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isDefaultServiceKey addr i0 kn) U32.one)
                  i0
                  (findDefaultServiceKeyGo addr (afterLineEnd addr le n) n)))))
       (findDefaultServiceKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `defaultService` key exists (first non-comment match; W104 more39 presence).

**Honesty:** Lake TOML CacheConfig decode reads `defaultService`
(`t.decode? \`defaultService`). Presence-only literal-byte — not value decode. Distinct from
`hasArtifactEndpoint` / `hasRevisionEndpoint` / `hasApiEndpoint` / `hasDefaultTargets`. -/
public unsafe def hasDefaultService (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findDefaultServiceKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one



/-- Match key text `service` (seven bytes). -/
public unsafe def isServiceKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len serviceKeyLen)
    (bifU32 (U32.beq (loadAt addr off) svc0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) svc1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) svc2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) svc3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) svc4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) svc5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) svc6)
                  U32.one U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Match key text `repo` (four bytes). -/
public unsafe def isRepoKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len repoKeyLen)
    (bifU32 (U32.beq (loadAt addr off) repo0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) repo1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) repo2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) repo3)
            U32.one U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Match key text `schemaVersion` (thirteen bytes). -/
public unsafe def isSchemaVersionKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len schemaVersionKeyLen)
    (bifU32 (U32.beq (loadAt addr off) sch0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) sch1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) sch2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) sch3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) sch4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) sch5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) sch6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) sch7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) sch8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) sch9)
                        (bifU32 (U32.beq (loadAt addr (USize.add off off10)) sch10)
                          (bifU32 (U32.beq (loadAt addr (USize.add off off11)) sch11)
                            (bifU32 (U32.beq (loadAt addr (USize.add off off12)) sch12)
                              U32.one U32.zero)
                            U32.zero)
                          U32.zero)
                        U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `service` key offset, or miss. -/
public unsafe def findServiceKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findServiceKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findServiceKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findServiceKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isServiceKey addr i0 kn) U32.one)
                  i0
                  (findServiceKeyGo addr (afterLineEnd addr le n) n)))))
       (findServiceKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `service` key exists (first non-comment match; W105 more40 presence).

**Honesty:** Lake CacheOutput JSON/TOML insert/get reads `service`
(`obj.insert "service"` / `obj.get? "service"`). Presence-only literal-byte — not value decode. Distinct from
`hasRepo` / `hasSchemaVersion` / `hasDefaultService` / `hasArtifactEndpoint`. -/
public unsafe def hasService (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findServiceKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `repo` key offset, or miss. -/
public unsafe def findRepoKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findRepoKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findRepoKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findRepoKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isRepoKey addr i0 kn) U32.one)
                  i0
                  (findRepoKeyGo addr (afterLineEnd addr le n) n)))))
       (findRepoKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `repo` key exists (first non-comment match; W105 more40 presence).

**Honesty:** Lake CacheOutput JSON/TOML insert/get reads `repo`
(scope-as-repo branch of CacheOutput). Presence-only literal-byte — not value decode. Distinct from
`hasService` / `hasSchemaVersion` / `hasDefaultService` / `hasRevisionEndpoint`. -/
public unsafe def hasRepo (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findRepoKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `schemaVersion` key offset, or miss. -/
public unsafe def findSchemaVersionKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findSchemaVersionKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findSchemaVersionKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findSchemaVersionKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isSchemaVersionKey addr i0 kn) U32.one)
                  i0
                  (findSchemaVersionKeyGo addr (afterLineEnd addr le n) n)))))
       (findSchemaVersionKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `schemaVersion` key exists (first non-comment match; W105 more40 presence).

**Honesty:** Lake CacheOutput JSON/TOML insert/get reads `schemaVersion`
(`obj.insert "schemaVersion"` / `obj.contains "schemaVersion"`). Presence-only literal-byte — not value decode. Distinct from
`hasService` / `hasRepo` / `hasDefaultService` / `hasVersionTags`. -/
public unsafe def hasSchemaVersion (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findSchemaVersionKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one



/-- Match key text `data` (four bytes). -/
public unsafe def isDataKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len dataKeyLen)
    (bifU32 (U32.beq (loadAt addr off) data0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) data1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) data2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) data3)
            U32.one U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Match key text `manifestFile` (twelve bytes). -/
public unsafe def isManifestFileKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len manifestFileKeyLen)
    (bifU32 (U32.beq (loadAt addr off) mfile0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) mfile1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) mfile2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) mfile3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) mfile4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) mfile5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) mfile6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) mfile7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) mfile8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) mfile9)
                        (bifU32 (U32.beq (loadAt addr (USize.add off off10)) mfile10)
                          (bifU32 (U32.beq (loadAt addr (USize.add off off11)) mfile11)
                            U32.one U32.zero)
                          U32.zero)
                        U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Match key text `lakeDir` (seven bytes). -/
public unsafe def isLakeDirKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len lakeDirKeyLen)
    (bifU32 (U32.beq (loadAt addr off) laked0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) laked1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) laked2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) laked3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) laked4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) laked5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) laked6)
                  U32.one U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `data` key offset, or miss. -/
public unsafe def findDataKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findDataKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findDataKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findDataKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isDataKey addr i0 kn) U32.one)
                  i0
                  (findDataKeyGo addr (afterLineEnd addr le n) n)))))
       (findDataKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `data` key exists (first non-comment match; W106 more41 presence).

**Honesty:** Lake CacheOutput JSON insert/get reads `data`
(`obj.insert "data"` / `obj.get? "data"`). Presence-only literal-byte — not value decode. Distinct from
`hasManifestFile` / `hasLakeDir` / `hasService` / `hasRepo`. -/
public unsafe def hasData (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findDataKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `manifestFile` key offset, or miss. -/
public unsafe def findManifestFileKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findManifestFileKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findManifestFileKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findManifestFileKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isManifestFileKey addr i0 kn) U32.one)
                  i0
                  (findManifestFileKeyGo addr (afterLineEnd addr le n) n)))))
       (findManifestFileKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `manifestFile` key exists (first non-comment match; W106 more41 presence).

**Honesty:** Lake Manifest entry JSON/TOML reads `manifestFile`
(`obj.getD "manifestFile"` / entry field). Presence-only literal-byte — not value decode. Distinct from
`hasData` / `hasLakeDir` / `hasManifest` / `hasService`. -/
public unsafe def hasManifestFile (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findManifestFileKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `lakeDir` key offset, or miss. -/
public unsafe def findLakeDirKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findLakeDirKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findLakeDirKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findLakeDirKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isLakeDirKey addr i0 kn) U32.one)
                  i0
                  (findLakeDirKeyGo addr (afterLineEnd addr le n) n)))))
       (findLakeDirKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `lakeDir` key exists (first non-comment match; W106 more41 presence).

**Honesty:** Lake Manifest JSON/TOML reads `lakeDir`
(`obj.getD "lakeDir"` / Manifest.lakeDir). Presence-only literal-byte — not value decode. Distinct from
`hasData` / `hasManifestFile` / `hasBuildDir` / `hasPackagesDir`. -/
public unsafe def hasLakeDir (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findLakeDirKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Match key text `configFile` (ten bytes). -/
public unsafe def isConfigFileKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len cfgfKeyLen)
    (bifU32 (U32.beq (loadAt addr off) cfgf0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) cfgf1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) cfgf2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) cfgf3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) cfgf4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) cfgf5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) cfgf6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) cfgf7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) cfgf8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) cfgf9)
                        U32.one U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Match key text `inputRev` (eight bytes). -/
public unsafe def isInputRevKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len inprevKeyLen)
    (bifU32 (U32.beq (loadAt addr off) inprev0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) inprev1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) inprev2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) inprev3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) inprev4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) inprev5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) inprev6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) inprev7)
                    U32.one U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Match key text `packages` (eight bytes). -/
public unsafe def isPackagesKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len pkgsKeyLen)
    (bifU32 (U32.beq (loadAt addr off) pkgs0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) pkgs1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) pkgs2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) pkgs3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) pkgs4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) pkgs5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) pkgs6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) pkgs7)
                    U32.one U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `configFile` key offset, or miss. -/
public unsafe def findConfigFileKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findConfigFileKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findConfigFileKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findConfigFileKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isConfigFileKey addr i0 kn) U32.one)
                  i0
                  (findConfigFileKeyGo addr (afterLineEnd addr le n) n)))))
       (findConfigFileKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `configFile` key exists (first non-comment match; W107 more42 presence).

**Honesty:** Lake Package/Manifest reads `configFile`
(`Package.configFile` / load config path). Presence-only literal-byte — not value decode. Distinct from
`hasInputRev` / `hasPackages` / `hasManifestFile` / `hasData`. -/
public unsafe def hasConfigFile (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findConfigFileKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `inputRev` key offset, or miss. -/
public unsafe def findInputRevKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findInputRevKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findInputRevKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findInputRevKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isInputRevKey addr i0 kn) U32.one)
                  i0
                  (findInputRevKeyGo addr (afterLineEnd addr le n) n)))))
       (findInputRevKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if an `inputRev` key exists (first non-comment match; W107 more42 presence).

**Honesty:** Lake Manifest package entry JSON/TOML reads `inputRev`
(`inputRev?` git dependency field). Presence-only literal-byte — not value decode. Distinct from
`hasConfigFile` / `hasPackages` / `hasManifestFile` / `hasData`. -/
public unsafe def hasInputRev (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findInputRevKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `packages` key offset, or miss. -/
public unsafe def findPackagesKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findPackagesKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findPackagesKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findPackagesKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isPackagesKey addr i0 kn) U32.one)
                  i0
                  (findPackagesKeyGo addr (afterLineEnd addr le n) n)))))
       (findPackagesKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `packages` key exists (first non-comment match; W107 more42 presence).

**Honesty:** Lake Manifest JSON/TOML reads `packages`
(manifest package list field). Presence-only literal-byte — not value decode. Distinct from
`hasConfigFile` / `hasInputRev` / `hasPackagesDir` / `hasData`. -/
public unsafe def hasPackages (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findPackagesKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one



/-- Match key text `inherited` (nine bytes). -/
public unsafe def isInheritedKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len inhKeyLen)
    (bifU32 (U32.beq (loadAt addr off) inh0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) inh1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) inh2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) inh3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) inh4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) inh5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) inh6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) inh7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) inh8)
                      U32.one U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Match key text `gitUrl` (six bytes). -/
public unsafe def isGitUrlKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len gurlKeyLen)
    (bifU32 (U32.beq (loadAt addr off) gurl0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) gurl1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) gurl2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) gurl3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) gurl4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) gurl5)
                U32.one U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Match key text `fullName` (eight bytes). -/
public unsafe def isFullNameKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len fnamKeyLen)
    (bifU32 (U32.beq (loadAt addr off) fnam0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) fnam1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) fnam2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) fnam3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) fnam4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) fnam5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) fnam6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) fnam7)
                    U32.one U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `inherited` key offset, or miss. -/
public unsafe def findInheritedKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findInheritedKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findInheritedKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findInheritedKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isInheritedKey addr i0 kn) U32.one)
                  i0
                  (findInheritedKeyGo addr (afterLineEnd addr le n) n)))))
       (findInheritedKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if an `inherited` key exists (first non-comment match; W108 more43 presence).

**Honesty:** Lake Manifest PackageEntry reads `inherited`
(`PackageEntry.inherited`). Presence-only literal-byte — not value decode. Distinct from
`hasGitUrl` / `hasFullName` / `hasConfigFile` / `hasInputRev` / `hasPackages`. -/
public unsafe def hasInherited (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findInheritedKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `gitUrl` key offset, or miss. -/
public unsafe def findGitUrlKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findGitUrlKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findGitUrlKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findGitUrlKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isGitUrlKey addr i0 kn) U32.one)
                  i0
                  (findGitUrlKeyGo addr (afterLineEnd addr le n) n)))))
       (findGitUrlKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `gitUrl` key exists (first non-comment match; W108 more43 presence).

**Honesty:** Lake Reservoir RegistrySrc reads `gitUrl`
(git source URL field). Presence-only literal-byte — not value decode. Distinct from
`hasInherited` / `hasFullName` / `hasConfigFile` / `hasInputRev` / `hasGit`. -/
public unsafe def hasGitUrl (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findGitUrlKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `fullName` key offset, or miss. -/
public unsafe def findFullNameKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findFullNameKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findFullNameKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findFullNameKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isFullNameKey addr i0 kn) U32.one)
                  i0
                  (findFullNameKeyGo addr (afterLineEnd addr le n) n)))))
       (findFullNameKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `fullName` key exists (first non-comment match; W108 more43 presence).

**Honesty:** Lake Reservoir RegistryPkg reads `fullName`
(package full name field). Presence-only literal-byte — not value decode. Distinct from
`hasInherited` / `hasGitUrl` / `hasConfigFile` / `hasName` / `hasPackages`. -/
public unsafe def hasFullName (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findFullNameKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Match key text `defaultBranch` (thirteen bytes). -/
public unsafe def isDefaultBranchKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len dbrKeyLen)
    (bifU32 (U32.beq (loadAt addr off) dbr0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) dbr1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) dbr2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) dbr3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) dbr4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) dbr5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) dbr6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) dbr7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) dbr8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) dbr9)
                        (bifU32 (U32.beq (loadAt addr (USize.add off off10)) dbr10)
                          (bifU32 (U32.beq (loadAt addr (USize.add off off11)) dbr11)
                            (bifU32 (U32.beq (loadAt addr (USize.add off off12)) dbr12)
                              U32.one U32.zero)
                            U32.zero)
                          U32.zero)
                        U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Match key text `repoUrl` (seven bytes). -/
public unsafe def isRepoUrlKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len rurlKeyLen)
    (bifU32 (U32.beq (loadAt addr off) rurl0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) rurl1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) rurl2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) rurl3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) rurl4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) rurl5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) rurl6)
                  U32.one U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Match key text `sources` (seven bytes). -/
public unsafe def isSourcesKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len srcsKeyLen)
    (bifU32 (U32.beq (loadAt addr off) srcs0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) srcs1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) srcs2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) srcs3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) srcs4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) srcs5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) srcs6)
                  U32.one U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `defaultBranch` key offset, or miss. -/
public unsafe def findDefaultBranchKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findDefaultBranchKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findDefaultBranchKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findDefaultBranchKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isDefaultBranchKey addr i0 kn) U32.one)
                  i0
                  (findDefaultBranchKeyGo addr (afterLineEnd addr le n) n)))))
       (findDefaultBranchKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `defaultBranch` key exists (first non-comment match; W109 more44 presence).

**Honesty:** Lake Reservoir RegistrySrc reads `defaultBranch`
(default branch field). Presence-only literal-byte — not value decode. Distinct from
`hasRepoUrl` / `hasSources` / `hasInherited` / `hasGitUrl` / `hasFullName`. -/
public unsafe def hasDefaultBranch (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findDefaultBranchKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `repoUrl` key offset, or miss. -/
public unsafe def findRepoUrlKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findRepoUrlKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findRepoUrlKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findRepoUrlKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isRepoUrlKey addr i0 kn) U32.one)
                  i0
                  (findRepoUrlKeyGo addr (afterLineEnd addr le n) n)))))
       (findRepoUrlKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `repoUrl` key exists (first non-comment match; W109 more44 presence).

**Honesty:** Lake Reservoir RegistrySrc reads `repoUrl`
(repository URL field). Presence-only literal-byte — not value decode. Distinct from
`hasDefaultBranch` / `hasSources` / `hasInherited` / `hasGitUrl` / `hasFullName`. -/
public unsafe def hasRepoUrl (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findRepoUrlKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `sources` key offset, or miss. -/
public unsafe def findSourcesKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findSourcesKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findSourcesKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findSourcesKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isSourcesKey addr i0 kn) U32.one)
                  i0
                  (findSourcesKeyGo addr (afterLineEnd addr le n) n)))))
       (findSourcesKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `sources` key exists (first non-comment match; W109 more44 presence).

**Honesty:** Lake Reservoir RegistryPkg reads `sources`
(package sources list field). Presence-only literal-byte — not value decode. Distinct from
`hasDefaultBranch` / `hasRepoUrl` / `hasInherited` / `hasGitUrl` / `hasFullName`. -/
public unsafe def hasSources (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findSourcesKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one



/-- Match key text `revision` (eight bytes). -/
public unsafe def isRevisionKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len revkKeyLen)
    (bifU32 (U32.beq (loadAt addr off) revk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) revk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) revk2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) revk3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) revk4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) revk5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) revk6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) revk7)
                    U32.one U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Match key text `host` (four bytes). -/
public unsafe def isHostKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len hostkKeyLen)
    (bifU32 (U32.beq (loadAt addr off) hostk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) hostk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) hostk2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) hostk3)
            U32.one U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Match key text `hash` (four bytes). -/
public unsafe def isHashKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len hashkKeyLen)
    (bifU32 (U32.beq (loadAt addr off) hashk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) hashk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) hashk2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) hashk3)
            U32.one U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero


/-- Find first non-comment `revision` key offset, or miss. -/
public unsafe def findRevisionKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findRevisionKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findRevisionKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findRevisionKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isRevisionKey addr i0 kn) U32.one)
                  i0
                  (findRevisionKeyGo addr (afterLineEnd addr le n) n)))))
       (findRevisionKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `revision` key exists (first non-comment match; W110 more45 presence).

**Honesty:** Lake Reservoir RegistryVer reads `revision`
(version revision field). Presence-only literal-byte — not value decode. Distinct from
`hasHost` / `hasHash` / `hasDefaultBranch` / `hasRepoUrl` / `hasSources`. -/
public unsafe def hasRevision (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findRevisionKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `host` key offset, or miss. -/
public unsafe def findHostKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findHostKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findHostKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findHostKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isHostKey addr i0 kn) U32.one)
                  i0
                  (findHostKeyGo addr (afterLineEnd addr le n) n)))))
       (findHostKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `host` key exists (first non-comment match; W110 more45 presence).

**Honesty:** Lake Reservoir RegistrySrc reads `host`
(source host field). Presence-only literal-byte — not value decode. Distinct from
`hasRevision` / `hasHash` / `hasDefaultBranch` / `hasRepoUrl` / `hasSources`. -/
public unsafe def hasHost (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findHostKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `hash` key offset, or miss. -/
public unsafe def findHashKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findHashKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findHashKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findHashKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isHashKey addr i0 kn) U32.one)
                  i0
                  (findHashKeyGo addr (afterLineEnd addr le n) n)))))
       (findHashKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `hash` key exists (first non-comment match; W110 more45 presence).

**Honesty:** Lake Module unpack JSON inserts `"hash"` (`Module.unpackLtar` / artifact
path). Presence-only literal-byte — not value decode. Distinct from
`hasRevision` / `hasHost` / `hasDefaultBranch` / `hasRepoUrl` / `hasSources`. -/
public unsafe def hasHash (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findHashKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Match key text `depHash` (seven bytes). -/
public unsafe def isDepHashKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len dhashkKeyLen)
    (bifU32 (U32.beq (loadAt addr off) dhashk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) dhashk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) dhashk2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) dhashk3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) dhashk4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) dhashk5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) dhashk6)
                  U32.one U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Match key text `file` (four bytes). -/
public unsafe def isFileKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len filekKeyLen)
    (bifU32 (U32.beq (loadAt addr off) filek0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) filek1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) filek2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) filek3)
            U32.one U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Match key text `inputs` (six bytes). -/
public unsafe def isInputsKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len inpskKeyLen)
    (bifU32 (U32.beq (loadAt addr off) inpsk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) inpsk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) inpsk2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) inpsk3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) inpsk4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) inpsk5)
                U32.one U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero


/-- Find first non-comment `depHash` key offset, or miss. -/
public unsafe def findDepHashKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findDepHashKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findDepHashKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findDepHashKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isDepHashKey addr i0 kn) U32.one)
                  i0
                  (findDepHashKeyGo addr (afterLineEnd addr le n) n)))))
       (findDepHashKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `depHash` key exists (first non-comment match; W111 more46 presence).

**Honesty:** Lake Build JSON inserts `"depHash"` (`Build/Common.lean` JobResult.toJson).
Presence-only literal-byte — not value decode. Distinct from
`hasFile` / `hasInputs` / `hasHash` / `hasRevision` / `hasHost`. -/
public unsafe def hasDepHash (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findDepHashKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `file` key offset, or miss. -/
public unsafe def findFileKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findFileKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findFileKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findFileKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isFileKey addr i0 kn) U32.one)
                  i0
                  (findFileKeyGo addr (afterLineEnd addr le n) n)))))
       (findFileKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `file` key exists (first non-comment match; W111 more46 presence).

**Honesty:** Lake Module unpackLtar JSON inserts `"file"` (`Module.lean` near hash).
Presence-only literal-byte — not value decode. Distinct from
`hasDepHash` / `hasInputs` / `hasHash` / `hasRevision` / `hasHost`.
Not `hasFileName` (different key spelling). -/
public unsafe def hasFile (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findFileKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `inputs` key offset, or miss. -/
public unsafe def findInputsKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findInputsKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findInputsKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findInputsKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isInputsKey addr i0 kn) U32.one)
                  i0
                  (findInputsKeyGo addr (afterLineEnd addr le n) n)))))
       (findInputsKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if an `inputs` key exists (first non-comment match; W111 more46 presence).

**Honesty:** Lake Build JSON inserts `"inputs"` (`Build/Common.lean` JobResult.toJson).
Presence-only literal-byte — not value decode. Distinct from
`hasDepHash` / `hasFile` / `hasHash` / `hasRevision` / `hasHost`. -/
public unsafe def hasInputs (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findInputsKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Match key text `outputs` (seven bytes). -/
public unsafe def isOutputsKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len outpskKeyLen)
    (bifU32 (U32.beq (loadAt addr off) outpsk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) outpsk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) outpsk2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) outpsk3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) outpsk4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) outpsk5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) outpsk6)
                  U32.one U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Match key text `status` (six bytes). -/
public unsafe def isStatusKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len statkKeyLen)
    (bifU32 (U32.beq (loadAt addr off) statk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) statk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) statk2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) statk3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) statk4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) statk5)
                U32.one U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Match key text `log` (three bytes). -/
public unsafe def isLogKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len logkKeyLen)
    (bifU32 (U32.beq (loadAt addr off) logk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) logk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) logk2)
          U32.one U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `outputs` key offset, or miss. -/
public unsafe def findOutputsKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findOutputsKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findOutputsKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findOutputsKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isOutputsKey addr i0 kn) U32.one)
                  i0
                  (findOutputsKeyGo addr (afterLineEnd addr le n) n)))))
       (findOutputsKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if an `outputs` key exists (first non-comment match; W112 more47 presence).

**Honesty:** Lake Build JSON inserts `"outputs"` (`Build/Common.lean` JobResult.toJson).
Presence-only literal-byte — not value decode. Distinct from
`hasInputs` / `hasDepHash` / `hasFile` / `hasStatus` / `hasLog`. -/
public unsafe def hasOutputs (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findOutputsKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `status` key offset, or miss. -/
public unsafe def findStatusKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findStatusKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findStatusKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findStatusKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isStatusKey addr i0 kn) U32.one)
                  i0
                  (findStatusKeyGo addr (afterLineEnd addr le n) n)))))
       (findStatusKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `status` key exists (first non-comment match; W112 more47 presence).

**Honesty:** Lake Reservoir err JSON reads `"status"` (`Util/Reservoir.lean` err.get).
Presence-only literal-byte — not value decode. Distinct from
`hasOutputs` / `hasLog` / `hasDepHash` / `hasFile` / `hasInputs`. -/
public unsafe def hasStatus (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findStatusKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `log` key offset, or miss. -/
public unsafe def findLogKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findLogKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findLogKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findLogKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isLogKey addr i0 kn) U32.one)
                  i0
                  (findLogKeyGo addr (afterLineEnd addr le n) n)))))
       (findLogKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `log` key exists (first non-comment match; W112 more47 presence).

**Honesty:** Lake Build JSON inserts `"log"` (`Build/Common.lean` JobResult.toJson).
Presence-only literal-byte — not value decode. Distinct from
`hasOutputs` / `hasStatus` / `hasDepHash` / `hasFile` / `hasInputs`. -/
public unsafe def hasLog (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findLogKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Match key text `synthetic` (nine bytes). -/
public unsafe def isSyntheticKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len synthkKeyLen)
    (bifU32 (U32.beq (loadAt addr off) synthk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) synthk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) synthk2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) synthk3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) synthk4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) synthk5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) synthk6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) synthk7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) synthk8)
                      U32.one U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Match key text `message` (seven bytes). -/
public unsafe def isMessageKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len msgkKeyLen)
    (bifU32 (U32.beq (loadAt addr off) msgk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) msgk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) msgk2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) msgk3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) msgk4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) msgk5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) msgk6)
                  U32.one U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Match key text `error` (five bytes). -/
public unsafe def isErrorKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len errkKeyLen)
    (bifU32 (U32.beq (loadAt addr off) errk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) errk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) errk2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) errk3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) errk4)
              U32.one U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `synthetic` key offset, or miss. -/
public unsafe def findSyntheticKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findSyntheticKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findSyntheticKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findSyntheticKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isSyntheticKey addr i0 kn) U32.one)
                  i0
                  (findSyntheticKeyGo addr (afterLineEnd addr le n) n)))))
       (findSyntheticKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `synthetic` key exists (first non-comment match; W113 more48 presence).

**Honesty:** Lake Build JSON inserts `"synthetic"` after `"log"`
(`Build/Common.lean` BuildMetadata.toJson L75).
Presence-only literal-byte — not value decode. Distinct from
`hasOutputs` / `hasStatus` / `hasLog` / `hasMessage` / `hasError`. -/
public unsafe def hasSynthetic (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findSyntheticKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `message` key offset, or miss. -/
public unsafe def findMessageKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findMessageKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findMessageKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findMessageKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isMessageKey addr i0 kn) U32.one)
                  i0
                  (findMessageKeyGo addr (afterLineEnd addr le n) n)))))
       (findMessageKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `message` key exists (first non-comment match; W113 more48 presence).

**Honesty:** Lake Reservoir err JSON reads `"message"`
(`Util/Reservoir.lean` L29 `err.get "message"`).
Presence-only literal-byte — not value decode. Distinct from
`hasSynthetic` / `hasError` / `hasOutputs` / `hasStatus` / `hasLog`. -/
public unsafe def hasMessage (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findMessageKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `error` key offset, or miss. -/
public unsafe def findErrorKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findErrorKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findErrorKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findErrorKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isErrorKey addr i0 kn) U32.one)
                  i0
                  (findErrorKeyGo addr (afterLineEnd addr le n) n)))))
       (findErrorKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if an `error` key exists (first non-comment match; W113 more48 presence).

**Honesty:** Lake Reservoir response reads `"error"`
(`Util/Reservoir.lean` L27 `obj.get? "error"`).
Presence-only literal-byte — not value decode. Distinct from
`hasSynthetic` / `hasMessage` / `hasOutputs` / `hasStatus` / `hasLog`. -/
public unsafe def hasError (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findErrorKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Match key text `http_code` (nine bytes). -/
public unsafe def isHttpCodeKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len httpkKeyLen)
    (bifU32 (U32.beq (loadAt addr off) httpk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) httpk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) httpk2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) httpk3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) httpk4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) httpk5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) httpk6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) httpk7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) httpk8)
                      U32.one U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Match key text `response_code` (thirteen bytes). -/
public unsafe def isResponseCodeKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len respckKeyLen)
    (bifU32 (U32.beq (loadAt addr off) respck0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) respck1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) respck2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) respck3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) respck4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) respck5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) respck6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) respck7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) respck8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) respck9)
                        (bifU32 (U32.beq (loadAt addr (USize.add off off10)) respck10)
                          (bifU32 (U32.beq (loadAt addr (USize.add off off11)) respck11)
                            (bifU32 (U32.beq (loadAt addr (USize.add off off12)) respck12)
                              U32.one U32.zero)
                            U32.zero)
                          U32.zero)
                        U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Match key text `errormsg` (eight bytes). -/
public unsafe def isErrormsgKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len emsgkKeyLen)
    (bifU32 (U32.beq (loadAt addr off) emsgk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) emsgk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) emsgk2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) emsgk3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) emsgk4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) emsgk5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) emsgk6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) emsgk7)
                    U32.one U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `http_code` key offset, or miss. -/
public unsafe def findHttpCodeKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findHttpCodeKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findHttpCodeKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findHttpCodeKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isHttpCodeKey addr i0 kn) U32.one)
                  i0
                  (findHttpCodeKeyGo addr (afterLineEnd addr le n) n)))))
       (findHttpCodeKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if an `http_code` key exists (first non-comment match; W114 more49 presence).

**Honesty:** Lake curl JSON reads `"http_code"`
(`Config/Cache.lean` L770 `out.get "http_code"`; also `Util/Url.lean` L120).
Presence-only literal-byte — not value decode. Distinct from
`hasResponseCode` / `hasErrormsg` / `hasError` / `hasSynthetic` / `hasMessage`. -/
public unsafe def hasHttpCode (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findHttpCodeKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `response_code` key offset, or miss. -/
public unsafe def findResponseCodeKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findResponseCodeKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findResponseCodeKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findResponseCodeKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isResponseCodeKey addr i0 kn) U32.one)
                  i0
                  (findResponseCodeKeyGo addr (afterLineEnd addr le n) n)))))
       (findResponseCodeKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `response_code` key exists (first non-comment match; W114 more49 presence).

**Honesty:** Lake curl JSON reads `"response_code"`
(`Config/Cache.lean` L578 / `Util/Url.lean` L120 `data.get? "response_code"`).
Presence-only literal-byte — not value decode. Distinct from
`hasHttpCode` / `hasErrormsg` / `hasError` / `hasSynthetic` / `hasMessage`. -/
public unsafe def hasResponseCode (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findResponseCodeKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `errormsg` key offset, or miss. -/
public unsafe def findErrormsgKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findErrormsgKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findErrormsgKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findErrormsgKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isErrormsgKey addr i0 kn) U32.one)
                  i0
                  (findErrormsgKeyGo addr (afterLineEnd addr le n) n)))))
       (findErrormsgKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if an `errormsg` key exists (first non-comment match; W114 more49 presence).

**Honesty:** Lake curl JSON reads `"errormsg"`
(`Config/Cache.lean` L809 `out.getAs String "errormsg"`; also L963).
Presence-only literal-byte — not value decode. Distinct from
`hasHttpCode` / `hasResponseCode` / `hasError` / `hasMessage` / `hasSynthetic`. -/
public unsafe def hasErrormsg (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findErrormsgKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Match key text `content_type` (twelve bytes). -/
public unsafe def isContentTypeKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len ctypekKeyLen)
    (bifU32 (U32.beq (loadAt addr off) ctypek0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) ctypek1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) ctypek2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) ctypek3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) ctypek4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) ctypek5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) ctypek6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) ctypek7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) ctypek8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) ctypek9)
                        (bifU32 (U32.beq (loadAt addr (USize.add off off10)) ctypek10)
                          (bifU32 (U32.beq (loadAt addr (USize.add off off11)) ctypek11)
                            U32.one U32.zero)
                          U32.zero)
                        U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Match key text `urlnum` (six bytes). -/
public unsafe def isUrlnumKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len urlnumkKeyLen)
    (bifU32 (U32.beq (loadAt addr off) urlnumk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) urlnumk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) urlnumk2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) urlnumk3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) urlnumk4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) urlnumk5)
                U32.one U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Match key text `size_download` (thirteen bytes). -/
public unsafe def isSizeDownloadKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len szdlkKeyLen)
    (bifU32 (U32.beq (loadAt addr off) szdlk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) szdlk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) szdlk2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) szdlk3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) szdlk4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) szdlk5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) szdlk6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) szdlk7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) szdlk8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) szdlk9)
                        (bifU32 (U32.beq (loadAt addr (USize.add off off10)) szdlk10)
                          (bifU32 (U32.beq (loadAt addr (USize.add off off11)) szdlk11)
                            (bifU32 (U32.beq (loadAt addr (USize.add off off12)) szdlk12)
                              U32.one U32.zero)
                            U32.zero)
                          U32.zero)
                        U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `content_type` key offset, or miss. -/
public unsafe def findContentTypeKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findContentTypeKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findContentTypeKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findContentTypeKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isContentTypeKey addr i0 kn) U32.one)
                  i0
                  (findContentTypeKeyGo addr (afterLineEnd addr le n) n)))))
       (findContentTypeKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `content_type` key exists (first non-comment match; W115 more50 presence).

**Honesty:** Lake curl JSON reads `"content_type"`
(`Config/Cache.lean` L819 `out.getAs String "content_type"`).
Presence-only literal-byte — not value decode. Distinct from
`hasUrlnum` / `hasSizeDownload` / `hasHttpCode` / `hasResponseCode` / `hasErrormsg`. -/
public unsafe def hasContentType (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findContentTypeKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `urlnum` key offset, or miss. -/
public unsafe def findUrlnumKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findUrlnumKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findUrlnumKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findUrlnumKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isUrlnumKey addr i0 kn) U32.one)
                  i0
                  (findUrlnumKeyGo addr (afterLineEnd addr le n) n)))))
       (findUrlnumKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `urlnum` key exists (first non-comment match; W115 more50 presence).

**Honesty:** Lake curl JSON reads `"urlnum"`
(`Config/Cache.lean` L801 area `out.getAs Nat "urlnum"`).
Presence-only literal-byte — not value decode. Distinct from
`hasContentType` / `hasSizeDownload` / `hasHttpCode` / `hasResponseCode` / `hasErrormsg`. -/
public unsafe def hasUrlnum (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findUrlnumKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `size_download` key offset, or miss. -/
public unsafe def findSizeDownloadKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findSizeDownloadKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findSizeDownloadKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findSizeDownloadKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isSizeDownloadKey addr i0 kn) U32.one)
                  i0
                  (findSizeDownloadKeyGo addr (afterLineEnd addr le n) n)))))
       (findSizeDownloadKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `size_download` key exists (first non-comment match; W115 more50 presence).

**Honesty:** Lake curl JSON reads `"size_download"`
(`Config/Cache.lean` L815/L825 `out.getAs Nat "size_download"`).
Presence-only literal-byte — not value decode. Distinct from
`hasContentType` / `hasUrlnum` / `hasHttpCode` / `hasResponseCode` / `hasErrormsg`. -/
public unsafe def hasSizeDownload (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findSizeDownloadKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Match key text `rs` (two bytes). -/
public unsafe def isRsKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len rskKeyLen)
    (bifU32 (U32.beq (loadAt addr off) rsk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) rsk1)
        U32.one U32.zero)
      U32.zero)
    U32.zero

/-- Match key text `o` (one byte). -/
public unsafe def isOKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len okeyKeyLen)
    (bifU32 (U32.beq (loadAt addr off) okey0)
      U32.one U32.zero)
    U32.zero

/-- Match key text `i` (one byte). -/
public unsafe def isIKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len ikeyKeyLen)
    (bifU32 (U32.beq (loadAt addr off) ikey0)
      U32.one U32.zero)
    U32.zero

/-- Find first non-comment `rs` key offset, or miss. -/
public unsafe def findRsKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findRsKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findRsKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findRsKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isRsKey addr i0 kn) U32.one)
                  i0
                  (findRsKeyGo addr (afterLineEnd addr le n) n)))))
       (findRsKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if an `rs` key exists (first non-comment match; W116 more51 presence).

**Honesty:** Lake ModuleOutputDescrs JSON uses single/short keys intentionally —
`"rs"` is irSig (`Build/ModuleArtifacts.lean` L43 insert / L66 get?).
Presence-only literal-byte exact key-length match before `=` — not value decode.
Distinct from `hasO` / `hasI` / `hasContentType` / `hasUrlnum` / `hasSizeDownload`.
Prefix peers (`rsx`, `Rs`) and reverse peers (`o`/`i`) must not match. -/
public unsafe def hasRs (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findRsKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `o` key offset, or miss. -/
public unsafe def findOKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findOKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findOKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findOKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isOKey addr i0 kn) U32.one)
                  i0
                  (findOKeyGo addr (afterLineEnd addr le n) n)))))
       (findOKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if an `o` key exists (first non-comment match; W116 more51 presence).

**Honesty:** Lake ModuleOutputDescrs JSON uses single-letter key `"o"` for olean
hashes (`Build/ModuleArtifacts.lean` L40 insert / L57 get). Presence-only
literal-byte exact key-length match before `=` — not value decode. Distinct from
`hasRs` / `hasI` / `hasOutputs` / `hasOpts` / longer keys starting with `o`.
Prefix peers (`ox`, `outputs`) must not match. -/
public unsafe def hasO (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findOKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `i` key offset, or miss. -/
public unsafe def findIKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findIKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findIKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findIKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isIKey addr i0 kn) U32.one)
                  i0
                  (findIKeyGo addr (afterLineEnd addr le n) n)))))
       (findIKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if an `i` key exists (first non-comment match; W116 more51 presence).

**Honesty:** Lake ModuleOutputDescrs JSON uses single-letter key `"i"` for ilean
(`Build/ModuleArtifacts.lean` L41 insert / L65 get). Presence-only literal-byte
exact key-length match before `=` — not value decode. Distinct from
`hasRs` / `hasO` / `hasInputs` / `hasInherited` / longer keys starting with `i`.
Prefix peers (`ix`, `inputs`) must not match. -/
public unsafe def hasI (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findIKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Match key text `m` (one byte). -/
public unsafe def isMKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len mkeyKeyLen)
    (bifU32 (U32.beq (loadAt addr off) mkey0)
      U32.one U32.zero)
    U32.zero

/-- Match key text `c` (one byte). -/
public unsafe def isCKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len ckeyKeyLen)
    (bifU32 (U32.beq (loadAt addr off) ckey0)
      U32.one U32.zero)
    U32.zero

/-- Match key text `b` (one byte). -/
public unsafe def isBKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len bkeyKeyLen)
    (bifU32 (U32.beq (loadAt addr off) bkey0)
      U32.one U32.zero)
    U32.zero

/-- Find first non-comment `m` key offset, or miss. -/
public unsafe def findMKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findMKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findMKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findMKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isMKey addr i0 kn) U32.one)
                  i0
                  (findMKeyGo addr (afterLineEnd addr le n) n)))))
       (findMKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if an `m` key exists (first non-comment match; W117 more52 presence).

**Honesty:** Lake ModuleOutputDescrs JSON uses single-letter key `"m"` for
isModule (`Build/ModuleArtifacts.lean` L39 insert / L61 get?). Presence-only
literal-byte exact key-length match before `=` — not value decode. Distinct from
`hasC` / `hasB` / `hasManifest` / `hasMessage` / longer keys starting with `m`.
Prefix peers (`mx`, `manifest`) must not match. -/
public unsafe def hasM (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findMKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `c` key offset, or miss. -/
public unsafe def findCKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findCKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findCKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findCKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isCKey addr i0 kn) U32.one)
                  i0
                  (findCKeyGo addr (afterLineEnd addr le n) n)))))
       (findCKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `c` key exists (first non-comment match; W117 more52 presence).

**Honesty:** Lake ModuleOutputDescrs JSON uses single-letter key `"c"` for the
c artifact (`Build/ModuleArtifacts.lean` L46 insert / L68 get). Presence-only
literal-byte exact key-length match before `=` — not value decode. Distinct from
`hasM` / `hasB` / `hasConfigFile` / `hasContentType` / longer keys starting with `c`.
Prefix peers (`cx`, `content_type`) must not match. -/
public unsafe def hasC (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findCKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `b` key offset, or miss. -/
public unsafe def findBKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findBKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findBKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findBKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isBKey addr i0 kn) U32.one)
                  i0
                  (findBKeyGo addr (afterLineEnd addr le n) n)))))
       (findBKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `b` key exists (first non-comment match; W117 more52 presence).

**Honesty:** Lake ModuleOutputDescrs JSON uses single-letter key `"b"` for bc
(`Build/ModuleArtifacts.lean` L48 insert / L69 get?). Presence-only literal-byte
exact key-length match before `=` — not value decode. Distinct from
`hasM` / `hasC` / `hasBootstrap` / `hasBuildDir` / longer keys starting with `b`.
Prefix peers (`bx`, `bootstrap`) must not match. -/
public unsafe def hasB (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findBKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Match key text `l` (one byte). -/
public unsafe def isLKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len lkeyKeyLen)
    (bifU32 (U32.beq (loadAt addr off) lkey0)
      U32.one U32.zero)
    U32.zero

/-- Match key text `r` (one byte). Distinct from `rs` (`hasRs`). -/
public unsafe def isRKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len rkeyKeyLen)
    (bifU32 (U32.beq (loadAt addr off) rkey0)
      U32.one U32.zero)
    U32.zero

/-- Match key text `require` (seven bytes). -/
public unsafe def isRequireKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len reqkKeyLen)
    (bifU32 (U32.beq (loadAt addr off) reqk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) reqk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) reqk2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) reqk3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) reqk4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) reqk5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) reqk6)
                  U32.one U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `l` key offset, or miss. -/
public unsafe def findLKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findLKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findLKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findLKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isLKey addr i0 kn) U32.one)
                  i0
                  (findLKeyGo addr (afterLineEnd addr le n) n)))))
       (findLKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if an `l` key exists (first non-comment match; W118 more53 presence).

**Honesty:** Lake ModuleOutputDescrs JSON uses single-letter key `"l"` for ltar
(`Build/ModuleArtifacts.lean` L50 insert / L70 get?). Presence-only literal-byte
exact key-length match before `=` — not value decode. Distinct from
`hasR` / `hasRequire` / `hasLibName` / `hasLeanLibDir` / longer keys starting with `l`.
Prefix peers (`lx`, `leanOptions`) must not match. Single-letter keys intentional. -/
public unsafe def hasL (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findLKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `r` key offset, or miss. -/
public unsafe def findRKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findRKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findRKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findRKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isRKey addr i0 kn) U32.one)
                  i0
                  (findRKeyGo addr (afterLineEnd addr le n) n)))))
       (findRKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if an `r` key exists (first non-comment match; W118 more53 presence).

**Honesty:** Lake ModuleOutputDescrs JSON uses single-letter key `"r"` for ir
(`Build/ModuleArtifacts.lean` L45 insert / L67 get?). Presence-only literal-byte
exact key-length match before `=` — not value decode. **Distinct from more51
`hasRs` (`rs` irSig)** — exact length-1 match; `rs` must not match. Distinct from
`hasRequire` / `hasRoot` / `hasReleaseRepo` / longer keys starting with `r`.
Prefix peers (`rx`, `root`) must not match. Single-letter keys intentional. -/
public unsafe def hasR (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findRKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `require` key offset, or miss. -/
public unsafe def findRequireKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findRequireKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findRequireKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findRequireKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isRequireKey addr i0 kn) U32.one)
                  i0
                  (findRequireKeyGo addr (afterLineEnd addr le n) n)))))
       (findRequireKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `require` key exists (first non-comment match; W118 more53 presence).

**Honesty:** Lake package-table deps use `require` (`Load/Toml.lean` ~L499
`table.tryDecodeD \`require`). Presence-only literal-byte exact key-length match
before `=` — not value decode. Distinct from `hasR` / `hasRs` / `hasRequiresModuleSystem`
/ `hasRoot` / longer keys starting with `require`. Prefix peers (`required`,
`requiresModuleSystem`) must not match. -/
public unsafe def hasRequire (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findRequireKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Match key text `value` (five bytes). -/
public unsafe def isValueKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len valkKeyLen)
    (bifU32 (U32.beq (loadAt addr off) valk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) valk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) valk2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) valk3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) valk4)
              U32.one U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Match key text `major` (five bytes). -/
public unsafe def isMajorKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len majorkKeyLen)
    (bifU32 (U32.beq (loadAt addr off) majork0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) majork1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) majork2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) majork3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) majork4)
              U32.one U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Match key text `minor` (five bytes). -/
public unsafe def isMinorKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len minorkKeyLen)
    (bifU32 (U32.beq (loadAt addr off) minork0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) minork1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) minork2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) minork3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) minork4)
              U32.one U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `value` key offset, or miss. -/
public unsafe def findValueKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findValueKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findValueKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findValueKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isValueKey addr i0 kn) U32.one)
                  i0
                  (findValueKeyGo addr (afterLineEnd addr le n) n)))))
       (findValueKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `value` key exists (first non-comment match; W119 more54 presence).

**Honesty:** Real Lake TOML object key `value` on LeanOption tables
(`Load/Toml.lean` LeanOption.decodeToml `t.tryDecode` of field `value`). Not
`Toml/Elab/Expression.lean` KeyTy.toString (that site is declaration-manner enum
text, not an object key). Presence-only literal-byte exact key-length match
before `=` — not value decode. Distinct from `hasVersion` / `hasMajor` /
`hasMinor` / longer keys starting with `value`. Prefix peers (`values`, `Value`)
must not match. -/
public unsafe def hasValue (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findValueKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `major` key offset, or miss. -/
public unsafe def findMajorKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findMajorKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findMajorKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findMajorKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isMajorKey addr i0 kn) U32.one)
                  i0
                  (findMajorKeyGo addr (afterLineEnd addr le n) n)))))
       (findMajorKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `major` key exists (first non-comment match; W119 more54 presence).

**Honesty:** Residual **literal key-text** matcher for bytes `major` — inspired by
`Util/Version.lean` parseVerNat error-message label `"major"`, **not** a greppable
lakefile / Lake JSON object key (`tryDecode` / JSON insert). Presence-only
literal-byte exact key-length match before `=` — not value decode. Distinct from
`hasMinor` / `hasManifest` / `hasM` / longer keys starting with `major`. Prefix
peers (`majorX`, `Major`) must not match. more55+ prefer real object keys only. -/
public unsafe def hasMajor (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findMajorKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `minor` key offset, or miss. -/
public unsafe def findMinorKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findMinorKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findMinorKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findMinorKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isMinorKey addr i0 kn) U32.one)
                  i0
                  (findMinorKeyGo addr (afterLineEnd addr le n) n)))))
       (findMinorKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `minor` key exists (first non-comment match; W119 more54 presence).

**Honesty:** Residual **literal key-text** matcher for bytes `minor` — inspired by
`Util/Version.lean` parseVerNat error-message label `"minor"`, **not** a greppable
lakefile / Lake JSON object key (`tryDecode` / JSON insert). Presence-only
literal-byte exact key-length match before `=` — not value decode. Distinct from
`hasMajor` / `hasManifest` / `hasM` / longer keys starting with `minor`. Prefix
peers (`minorX`, `Minor`) must not match. more55+ prefer real object keys only. -/
public unsafe def hasMinor (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findMinorKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Match key text `art` (three bytes). -/
public unsafe def isArtKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len artkKeyLen)
    (bifU32 (U32.beq (loadAt addr off) artk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) artk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) artk2)
          U32.one U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Match key text `olean` (five bytes). -/
public unsafe def isOleanKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len oleankKeyLen)
    (bifU32 (U32.beq (loadAt addr off) oleank0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) oleank1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) oleank2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) oleank3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) oleank4)
              U32.one U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Match key text `ltar` (four bytes). -/
public unsafe def isLtarKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len ltarkKeyLen)
    (bifU32 (U32.beq (loadAt addr off) ltark0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) ltark1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) ltark2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) ltark3)
            U32.one U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `art` key offset, or miss. -/
public unsafe def findArtKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findArtKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findArtKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findArtKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isArtKey addr i0 kn) U32.one)
                  i0
                  (findArtKeyGo addr (afterLineEnd addr le n) n)))))
       (findArtKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if an `art` key exists (first non-comment match; W120 more55 presence).

**Honesty:** Lake greppable cache/artifact extension identity token `art` —
`Config/Artifact.lean` / `Config/Cache.lean` default `ext := "art"`. **Not** a
PackageConfig TOML field; residual intentionally includes cache/artifact
extension identity strings after tryDecode/JSON-insert inventory is largely
exhausted. Presence-only literal-byte exact key-length match before `=` — not
value decode. Distinct from `hasArtifactEndpoint` / longer keys starting with
`art`. Prefix peers (`artifact`, `arts`, `Art`) must not match. -/
public unsafe def hasArt (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findArtKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `olean` key offset, or miss. -/
public unsafe def findOleanKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findOleanKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findOleanKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findOleanKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isOleanKey addr i0 kn) U32.one)
                  i0
                  (findOleanKeyGo addr (afterLineEnd addr le n) n)))))
       (findOleanKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if an `olean` key exists (first non-comment match; W120 more55 presence).

**Honesty:** Lake greppable cache/compute facet extension identity token
`olean` — `Build/Module.lean` cache/compute facet ext `"olean"`. **Not** a
PackageConfig TOML field; residual intentionally includes cache/artifact
extension identity strings after tryDecode/JSON-insert inventory is largely
exhausted. Presence-only literal-byte exact key-length match before `=` — not
value decode. Distinct from `hasO` / longer keys starting with `olean`. Prefix
peers (`oleans`, `Olean`) must not match. -/
public unsafe def hasOlean (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findOleanKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `ltar` key offset, or miss. -/
public unsafe def findLtarKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findLtarKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findLtarKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findLtarKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isLtarKey addr i0 kn) U32.one)
                  i0
                  (findLtarKeyGo addr (afterLineEnd addr le n) n)))))
       (findLtarKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if an `ltar` key exists (first non-comment match; W120 more55 presence).

**Honesty:** Lake greppable cache/compute facet extension identity token
`ltar` — `Build/Module.lean` cache/compute facet ext `"ltar"`. **Not** a
PackageConfig TOML field; residual intentionally includes cache/artifact
extension identity strings after tryDecode/JSON-insert inventory is largely
exhausted. Presence-only literal-byte exact key-length match before `=` — not
value decode. Distinct from `hasL` / longer keys starting with `ltar`. Prefix
peers (`ltars`, `Ltar`) must not match. -/
public unsafe def hasLtar (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findLtarKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Match key text `ir` (two bytes). -/
public unsafe def isIrKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len irkKeyLen)
    (bifU32 (U32.beq (loadAt addr off) irk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) irk1)
        U32.one U32.zero)
      U32.zero)
    U32.zero

/-- Match key text `traceArgs` (nine bytes). -/
public unsafe def isTraceArgsKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len trargskKeyLen)
    (bifU32 (U32.beq (loadAt addr off) trargsk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) trargsk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) trargsk2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) trargsk3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) trargsk4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) trargsk5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) trargsk6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) trargsk7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) trargsk8)
                      U32.one U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Match key text `debugAssertions` (fifteen bytes). -/
public unsafe def isDebugAssertionsKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len dassertkKeyLen)
    (bifU32 (U32.beq (loadAt addr off) dassertk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) dassertk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) dassertk2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) dassertk3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) dassertk4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) dassertk5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) dassertk6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) dassertk7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) dassertk8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) dassertk9)
                        (bifU32 (U32.beq (loadAt addr (USize.add off off10)) dassertk10)
                          (bifU32 (U32.beq (loadAt addr (USize.add off off11)) dassertk11)
                            (bifU32 (U32.beq (loadAt addr (USize.add off off12)) dassertk12)
                              (bifU32 (U32.beq (loadAt addr (USize.add off off13)) dassertk13)
                                (bifU32 (U32.beq (loadAt addr (USize.add off off14)) dassertk14)
                                  U32.one U32.zero)
                                U32.zero)
                              U32.zero)
                            U32.zero)
                          U32.zero)
                        U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `ir` key offset, or miss. -/
public unsafe def findIrKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findIrKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findIrKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findIrKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isIrKey addr i0 kn) U32.one)
                  i0
                  (findIrKeyGo addr (afterLineEnd addr le n) n)))))
       (findIrKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if an `ir` key exists (first non-comment match; W121 more56 presence).

**Honesty:** Lake greppable cache/compute facet extension identity token `ir` —
`Build/Module.lean` cache/compute facet ext `"ir"`; `Config/Defaults.lean`
`defaultIrDir := "ir"`. **Not** a PackageConfig TOML field named `ir` alone
(package uses `irDir`); residual intentionally includes cache/artifact
extension identity strings after tryDecode/JSON-insert inventory is largely
exhausted. Presence-only literal-byte exact key-length match before `=` — not
value decode. **Distinct from more51 `hasI`** (single-letter ModuleArtifacts
`i`): exact length-2; `i` alone must not match; longer keys starting with `ir`
(e.g. `irDir`) miss. Prefix peers (`irs`, `Ir`, `irDir`) must not match. -/
public unsafe def hasIr (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findIrKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `traceArgs` key offset, or miss. -/
public unsafe def findTraceArgsKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findTraceArgsKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findTraceArgsKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findTraceArgsKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isTraceArgsKey addr i0 kn) U32.one)
                  i0
                  (findTraceArgsKeyGo addr (afterLineEnd addr le n) n)))))
       (findTraceArgsKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `traceArgs` key exists (first non-comment match; W121 more56 presence).

**Honesty:** Lake greppable build-trace caption / identity string `traceArgs` —
`Build/Common.lean` `addPureTrace traceArgs "traceArgs"`. **Not** a PackageConfig
TOML field; residual intentionally includes greppable Lake identity tokens after
tryDecode/JSON-insert inventory is largely exhausted. Presence-only literal-byte
exact key-length match before `=` — not value decode. Distinct from more28
`hasLeanArgs` (`leanArgs`) / longer keys starting with `traceArgs`. Prefix peers
(`traceArg`, `TraceArgs`) must not match. -/
public unsafe def hasTraceArgs (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findTraceArgsKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `debugAssertions` key offset, or miss. -/
public unsafe def findDebugAssertionsKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findDebugAssertionsKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findDebugAssertionsKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findDebugAssertionsKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isDebugAssertionsKey addr i0 kn) U32.one)
                  i0
                  (findDebugAssertionsKeyGo addr (afterLineEnd addr le n) n)))))
       (findDebugAssertionsKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `debugAssertions` key exists (first non-comment match; W121 more56 presence).

**Honesty:** Real Lean option NameMap key `` `debugAssertions `` —
`Config/LeanConfig.lean` BuildType.leanOptions debug inserts. Presence-only
literal-byte exact key-length match before `=` — not value decode. Distinct from
longer keys starting with `debugAssertions`. Prefix peers (`debugAssertion`,
`DebugAssertions`) must not match. -/
public unsafe def hasDebugAssertions (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findDebugAssertionsKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Match key text `verLike` (seven bytes). -/
public unsafe def isVerLikeKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len vlkKeyLen)
    (bifU32 (U32.beq (loadAt addr off) vlk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) vlk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) vlk2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) vlk3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) vlk4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) vlk5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) vlk6)
                  U32.one U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Match key text `mappings` (eight bytes). -/
public unsafe def isMappingsKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len mapkKeyLen)
    (bifU32 (U32.beq (loadAt addr off) mapk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) mapk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) mapk2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) mapk3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) mapk4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) mapk5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) mapk6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) mapk7)
                    U32.one U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Match key text `default` (seven bytes). -/
public unsafe def isDefaultKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len defkKeyLen)
    (bifU32 (U32.beq (loadAt addr off) defk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) defk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) defk2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) defk3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) defk4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) defk5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) defk6)
                  U32.one U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `verLike` key offset, or miss. -/
public unsafe def findVerLikeKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findVerLikeKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findVerLikeKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findVerLikeKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isVerLikeKey addr i0 kn) U32.one)
                  i0
                  (findVerLikeKeyGo addr (afterLineEnd addr le n) n)))))
       (findVerLikeKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `verLike` key exists (first non-comment match; W122 more57 presence).

**Honesty:** Lake greppable version-tag preset name `` `verLike `` —
`Config/Pattern.lean` `versionTagPresets` NameMap insert `` `verLike `` /
`StrPat.verLike`. Presence-only literal-byte exact key-length match before `=` —
not value decode. Distinct from longer keys starting with `verLike`. Prefix peers
(`verLikeX`, `VerLike`, `verlike`) must not match. -/
public unsafe def hasVerLike (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findVerLikeKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `mappings` key offset, or miss. -/
public unsafe def findMappingsKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findMappingsKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findMappingsKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findMappingsKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isMappingsKey addr i0 kn) U32.one)
                  i0
                  (findMappingsKeyGo addr (afterLineEnd addr le n) n)))))
       (findMappingsKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `mappings` key exists (first non-comment match; W122 more57 presence).

**Honesty:** Lake greppable CLI token `mappings` — `CLI/Main.lean`
`takeArg "mappings"` (setup-file / CLI greppable token). Presence-only
literal-byte exact key-length match before `=` — not value decode. Distinct from
shorter/longer keys starting with `mapping`. Prefix peers (`mapping`, `Mappings`,
`mappingsX`) must not match. -/
public unsafe def hasMappings (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findMappingsKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `default` key offset, or miss. -/
public unsafe def findDefaultKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findDefaultKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findDefaultKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findDefaultKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isDefaultKey addr i0 kn) U32.one)
                  i0
                  (findDefaultKeyGo addr (afterLineEnd addr le n) n)))))
       (findDefaultKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `default` key exists (first non-comment match; W122 more57 presence).

**Honesty:** Lake greppable version-tag preset name `` `default `` —
`Config/Pattern.lean` `defaultVersionTags` / `versionTagPresets` insert
`` `default `` (also Translate/Toml `` `default `` cases). Presence-only
literal-byte **exact length-7** key match before `=` — not value decode.
**Distinct from** existing longer-key APIs `hasDefaultTargets` /
`hasDefaultFacets` / `hasDefaultService` / `hasDefaultBranch`: those match
`defaultTargets`/`defaultFacets`/`defaultService`/`defaultBranch` and must not
match bare `default`; this API must miss those longer keys. Prefix peers
(`defaultX`, `Default`, `default_script`) must not match. -/
public unsafe def hasDefault (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findDefaultKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Match key text `objs` (four bytes). -/
public unsafe def isObjsKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len objkKeyLen)
    (bifU32 (U32.beq (loadAt addr off) objk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) objk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) objk2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) objk3)
            U32.one U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Match key text `cache` (five bytes). -/
public unsafe def isCacheKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len cchkKeyLen)
    (bifU32 (U32.beq (loadAt addr off) cchk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) cchk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) cchk2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) cchk3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) cchk4)
              U32.one U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Match key text `script` (six bytes). -/
public unsafe def isScriptKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len scrkKeyLen)
    (bifU32 (U32.beq (loadAt addr off) scrk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) scrk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) scrk2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) scrk3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) scrk4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) scrk5)
                U32.one U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `objs` key offset, or miss. -/
public unsafe def findObjsKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findObjsKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findObjsKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findObjsKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isObjsKey addr i0 kn) U32.one)
                  i0
                  (findObjsKeyGo addr (afterLineEnd addr le n) n)))))
       (findObjsKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if an `objs` key exists (first non-comment match; W123 more58 presence).

**Honesty:** Lake greppable job caption `objs` —
`Build/Common.lean` / `Build/Library.lean` `Job.collectArray … "objs"`.
Presence-only literal-byte exact key-length match before `=` — not value
decode. Distinct from longer keys starting with `objs`. Prefix peers
(`objsX`, `Objs`, `OBJS`) must not match. -/
public unsafe def hasObjs (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findObjsKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `cache` key offset, or miss. -/
public unsafe def findCacheKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findCacheKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findCacheKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findCacheKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isCacheKey addr i0 kn) U32.one)
                  i0
                  (findCacheKeyGo addr (afterLineEnd addr le n) n)))))
       (findCacheKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `cache` key exists (first non-comment match; W123 more58 presence).

**Honesty:** Lake greppable CLI command `cache` — `CLI/Main.lean`
`| "cache" => lake.cache` (also Help.lean; lakeDir path `"cache"`).
Presence-only literal-byte exact key-length match before `=` — not value
decode. **Distinct from** longer `enableArtifactCache` (`hasEnableArtifactCache`):
that must miss bare `cache`; this API must miss `enableArtifactCache`. Prefix
peers (`cacheX`, `Cache`, `caches`) must not match. -/
public unsafe def hasCache (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findCacheKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `script` key offset, or miss. -/
public unsafe def findScriptKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findScriptKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findScriptKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findScriptKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isScriptKey addr i0 kn) U32.one)
                  i0
                  (findScriptKeyGo addr (afterLineEnd addr le n) n)))))
       (findScriptKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `script` key exists (first non-comment match; W123 more58 presence).

**Honesty:** Lake greppable CLI command / DSL attribute `script` —
`CLI/Main.lean` `| "script" => lake.script`; `DSL/AttributesCore.lean`
`` `script ``. Presence-only literal-byte exact key-length match before `=` —
not value decode. Distinct from longer keys (`scripts`, `scriptX`) and case
peers (`Script`). Prefix peers must not match. -/
public unsafe def hasScript (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findScriptKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Match key text `ext` (three bytes). -/
public unsafe def isExtKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len extkKeyLen)
    (bifU32 (U32.beq (loadAt addr off) extk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) extk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) extk2)
          U32.one U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Match key text `lean` (four bytes). -/
public unsafe def isLeanKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len leankKeyLen)
    (bifU32 (U32.beq (loadAt addr off) leank0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) leank1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) leank2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) leank3)
            U32.one U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Match key text `toml` (four bytes). -/
public unsafe def isTomlKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len tomlkKeyLen)
    (bifU32 (U32.beq (loadAt addr off) tomlk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) tomlk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) tomlk2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) tomlk3)
            U32.one U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `ext` key offset, or miss. -/
public unsafe def findExtKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findExtKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findExtKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findExtKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isExtKey addr i0 kn) U32.one)
                  i0
                  (findExtKeyGo addr (afterLineEnd addr le n) n)))))
       (findExtKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if an `ext` key exists (first non-comment match; W124 more59 presence).

**Honesty:** Lake greppable artifact/cache field `ext` —
`Config/Artifact.lean` / `Config/Cache.lean` `ext := "art"` / `self.ext`.
Presence-only literal-byte **exact length-3** key match before `=` — not value
decode. **Distinct from** longer `extension` (`hasExtension`): that must miss
bare `ext`; this API must miss `extension`. Prefix peers (`extX`, `Ext`,
`EXT`) must not match. -/
public unsafe def hasExt (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findExtKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `lean` key offset, or miss. -/
public unsafe def findLeanKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findLeanKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findLeanKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findLeanKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isLeanKey addr i0 kn) U32.one)
                  i0
                  (findLeanKeyGo addr (afterLineEnd addr le n) n)))))
       (findLeanKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `lean` key exists (first non-comment match; W124 more59 presence).

**Honesty:** Lake greppable CLI / configLang token `lean` — `CLI/Main.lean`
`| "lean" => lake.lean`; `Load/Package.lean` `| "lean" =>` configLang;
Help.lean. Presence-only literal-byte exact key-length match before `=` — not
value decode. **Distinct from** longer `leanArgs`/`leanOptions`/`leanLibDir`
(`hasLeanArgs` / `hasLeanOptions` / `hasLeanLibDir`): those must miss bare
`lean`; this API must miss those longer keys. Prefix peers (`leanX`, `Lean`,
`LEAN`) must not match. -/
public unsafe def hasLean (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findLeanKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `toml` key offset, or miss. -/
public unsafe def findTomlKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findTomlKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findTomlKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findTomlKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isTomlKey addr i0 kn) U32.one)
                  i0
                  (findTomlKeyGo addr (afterLineEnd addr le n) n)))))
       (findTomlKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `toml` key exists (first non-comment match; W124 more59 presence).

**Honesty:** Lake greppable configLang token `toml` — `Load/Package.lean`
`| "toml" =>` configLang; `Toml/Grammar.lean` / Help config languages.
Presence-only literal-byte exact key-length match before `=` — not value
decode. Distinct from longer keys (`tomlX`, `tomlFile`) and case peers
(`Toml`). Prefix peers must not match. -/
public unsafe def hasToml (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findTomlKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Match key text `env` (three bytes). -/
public unsafe def isEnvKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len envkKeyLen)
    (bifU32 (U32.beq (loadAt addr off) envk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) envk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) envk2)
          U32.one U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Match key text `help` (four bytes). -/
public unsafe def isHelpKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len helpkKeyLen)
    (bifU32 (U32.beq (loadAt addr off) helpk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) helpk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) helpk2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) helpk3)
            U32.one U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Match key text `cc` (two bytes). -/
public unsafe def isCcKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len cckKeyLen)
    (bifU32 (U32.beq (loadAt addr off) cck0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) cck1)
        U32.one U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `env` key offset, or miss. -/
public unsafe def findEnvKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findEnvKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findEnvKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findEnvKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isEnvKey addr i0 kn) U32.one)
                  i0
                  (findEnvKeyGo addr (afterLineEnd addr le n) n)))))
       (findEnvKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if an `env` key exists (first non-comment match; W125 more60 presence).

**Honesty:** Lake greppable CLI command `env` — `CLI/Main.lean`
`| "env" => lake.env`; Help.lean `| "env"`. Presence-only literal-byte
exact key-length match before `=` — not value decode. Distinct from longer
keys (`envX`, `environment`) and case peers (`Env`). Prefix peers must not
match. -/
public unsafe def hasEnv (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findEnvKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `help` key offset, or miss. -/
public unsafe def findHelpKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findHelpKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findHelpKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findHelpKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isHelpKey addr i0 kn) U32.one)
                  i0
                  (findHelpKeyGo addr (afterLineEnd addr le n) n)))))
       (findHelpKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `help` key exists (first non-comment match; W125 more60 presence).

**Honesty:** Lake greppable CLI command `help` — `CLI/Main.lean`
`| "help" => lake.help` (also cache/script help subcommands). Presence-only
literal-byte exact key-length match before `=` — not value decode. Must miss
longer keys (`helpX`, `helper`) and case peers (`Help`). Prefix peers must
not match. -/
public unsafe def hasHelp (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findHelpKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `cc` key offset, or miss. -/
public unsafe def findCcKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findCcKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findCcKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findCcKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isCcKey addr i0 kn) U32.one)
                  i0
                  (findCcKeyGo addr (afterLineEnd addr le n) n)))))
       (findCcKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `cc` key exists (first non-comment match; W125 more60 presence).

**Honesty:** Lake greppable install/linker identity `cc` —
`Config/InstallPath.lean` `cc : FilePath := "cc"`; Help LEAN_CC;
`Build/Actions.lean` linker default `"cc"`. Presence-only literal-byte
**exact length-2** key match before `=` — not value decode. **Distinct from**
single-letter more52 `hasC` (`c`): that must miss bare `cc`; this API must
miss bare `c`. Prefix peers (`ccX`, `Cc`, `CC`) must not match. -/
public unsafe def hasCc (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findCcKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Match key text `info` (four bytes). -/
public unsafe def isInfoKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len infokKeyLen)
    (bifU32 (U32.beq (loadAt addr off) infok0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) infok1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) infok2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) infok3)
            U32.one U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Match key text `remote` (six bytes). -/
public unsafe def isRemoteKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len remotekKeyLen)
    (bifU32 (U32.beq (loadAt addr off) remotek0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) remotek1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) remotek2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) remotek3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) remotek4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) remotek5)
                U32.one U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Match key text `facets` (six bytes). -/
public unsafe def isFacetsKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len facetskKeyLen)
    (bifU32 (U32.beq (loadAt addr off) facetsk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) facetsk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) facetsk2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) facetsk3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) facetsk4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) facetsk5)
                U32.one U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `info` key offset, or miss. -/
public unsafe def findInfoKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findInfoKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findInfoKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findInfoKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isInfoKey addr i0 kn) U32.one)
                  i0
                  (findInfoKeyGo addr (afterLineEnd addr le n) n)))))
       (findInfoKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if an `info` key exists (first non-comment match; W126 more61 presence).

**Honesty:** Lake greppable log-level token `info` — `Util/Log.lean`
`| "info" | "information" => some .info`; `.info => "info"`. Presence-only
literal-byte exact key-length match before `=` — not value decode. Must miss
longer keys (`infoX`, `information`) and case peers (`Info`). Prefix peers
must not match. -/
public unsafe def hasInfo (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findInfoKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `remote` key offset, or miss. -/
public unsafe def findRemoteKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findRemoteKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findRemoteKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findRemoteKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isRemoteKey addr i0 kn) U32.one)
                  i0
                  (findRemoteKeyGo addr (afterLineEnd addr le n) n)))))
       (findRemoteKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `remote` key exists (first non-comment match; W126 more61 presence).

**Honesty:** Lake greppable git remote subcommand `remote` — `Util/Git.lean`
`#["remote", "get-url", remote]` (+ add / set-url). Presence-only literal-byte
**exact length-6** key match before `=` — not value decode. **Distinct from**
more24 `hasRemoteUrl` (`remoteUrl` len-9): that must miss bare `remote`; this
API must miss `remoteUrl`. Prefix peers (`remoteX`, `Remote`, `REMOTE`) must
not match. -/
public unsafe def hasRemote (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findRemoteKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `facets` key offset, or miss. -/
public unsafe def findFacetsKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findFacetsKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findFacetsKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findFacetsKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isFacetsKey addr i0 kn) U32.one)
                  i0
                  (findFacetsKeyGo addr (afterLineEnd addr le n) n)))))
       (findFacetsKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `facets` key exists (first non-comment match; W126 more61 presence).

**Honesty:** Lake greppable facet identity `facets` —
`CLI/Translate/Toml.lean` `encodeFacets`; `Config/LeanLibConfig.lean`
`defaultFacets`; `Config/Workspace.lean` `facetConfigs`. Presence-only
literal-byte **exact length-6** key match before `=` — not value decode.
**Distinct from** more23 `hasDefaultFacets` (`defaultFacets`) and more27
`hasNativeFacets` (`nativeFacets`): those must miss bare `facets`; this API
must miss longer keys. Prefix peers (`facetsX`, `Facets`, `FACETS`) must not
match. -/
public unsafe def hasFacets (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findFacetsKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Match key text `package` (seven bytes). -/
public unsafe def isPackageKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len packagekKeyLen)
    (bifU32 (U32.beq (loadAt addr off) packagek0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) packagek1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) packagek2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) packagek3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) packagek4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) packagek5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) packagek6)
                  U32.one U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Match key text `module` (six bytes). -/
public unsafe def isModuleKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len modulekKeyLen)
    (bifU32 (U32.beq (loadAt addr off) modulek0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) modulek1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) modulek2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) modulek3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) modulek4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) modulek5)
                U32.one U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Match key text `build` (five bytes). -/
public unsafe def isBuildKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len buildkKeyLen)
    (bifU32 (U32.beq (loadAt addr off) buildk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) buildk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) buildk2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) buildk3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) buildk4)
              U32.one U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `package` key offset, or miss. -/
public unsafe def findPackageKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findPackageKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findPackageKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findPackageKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isPackageKey addr i0 kn) U32.one)
                  i0
                  (findPackageKeyGo addr (afterLineEnd addr le n) n)))))
       (findPackageKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `package` key exists (first non-comment match; W127 more62 presence).

**Honesty:** Lake greppable facet-kind token `package` — `CLI/Build.lean`
`unknownFacet "package"`. Presence-only literal-byte **exact length-7** key
match before `=` — not value decode. **Distinct from** more29 `hasPackages`
(`packages` len-8) and more7 `hasPackagesDir` (`packagesDir` len-11): those
must miss bare `package`; this API must miss `packages` / `packagesDir`.
Prefix peers (`packageX`, `Package`, `PACKAGE`) must not match. -/
public unsafe def hasPackage (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findPackageKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `module` key offset, or miss. -/
public unsafe def findModuleKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findModuleKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findModuleKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findModuleKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isModuleKey addr i0 kn) U32.one)
                  i0
                  (findModuleKeyGo addr (afterLineEnd addr le n) n)))))
       (findModuleKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `module` key exists (first non-comment match; W127 more62 presence).

**Honesty:** Lake greppable facet-kind token `module` — `CLI/Build.lean`
`unknownFacet "module"`. Presence-only literal-byte **exact length-6** key
match before `=` — not value decode. **Distinct from** more6
`hasPrecompileModules` (`precompileModules`) and more16
`hasRequiresModuleSystem` (`requiresModuleSystem`): those must miss bare
`module`; this API must miss longer keys. Prefix peers (`moduleX`, `Module`,
`MODULE`) must not match. -/
public unsafe def hasModule (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findModuleKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `build` key offset, or miss. -/
public unsafe def findBuildKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findBuildKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findBuildKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findBuildKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isBuildKey addr i0 kn) U32.one)
                  i0
                  (findBuildKeyGo addr (afterLineEnd addr le n) n)))))
       (findBuildKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `build` key exists (first non-comment match; W127 more62 presence).

**Honesty:** Lake greppable CLI command + default build-dir token `build` —
`CLI/Main.lean` `| "build" => lake.build`; Help.lean `| "build"`;
`Config/Defaults.lean` `defaultBuildDir` / `"build"`. Presence-only
literal-byte **exact length-5** key match before `=` — not value decode.
**Distinct from** more8 `hasBuildDir` (`buildDir` len-8), more2 `hasBuildType`
(`buildType` len-9), more5 `hasBuildArchive` (`buildArchive` len-12): those
must miss bare `build`; this API must miss longer keys. Prefix peers
(`buildX`, `Build`, `BUILD`) must not match. -/
public unsafe def hasBuild (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findBuildKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Match key text `clean` (five bytes). -/
public unsafe def isCleanKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len cleankKeyLen)
    (bifU32 (U32.beq (loadAt addr off) cleank0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) cleank1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) cleank2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) cleank3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) cleank4)
              U32.one U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Match key text `test` (four bytes). -/
public unsafe def isTestKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len testkKeyLen)
    (bifU32 (U32.beq (loadAt addr off) testk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) testk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) testk2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) testk3)
            U32.one U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Match key text `serve` (five bytes). -/
public unsafe def isServeKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len servekKeyLen)
    (bifU32 (U32.beq (loadAt addr off) servek0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) servek1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) servek2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) servek3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) servek4)
              U32.one U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `clean` key offset, or miss. -/
public unsafe def findCleanKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findCleanKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findCleanKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findCleanKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isCleanKey addr i0 kn) U32.one)
                  i0
                  (findCleanKeyGo addr (afterLineEnd addr le n) n)))))
       (findCleanKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `clean` key exists (first non-comment match; W128 more63 presence).

**Honesty:** Lake greppable CLI command token `clean` — `CLI/Main.lean`
`| "clean" => lake.clean`; Help.lean `| "clean"` / `helpClean`; cache
subcommand `| "clean" => cache.clean`. Presence-only literal-byte **exact
length-5** key match before `=` — not value decode. Prefix peers
(`cleanX`, `Clean`, `CLEAN`) must not match. -/
public unsafe def hasClean (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findCleanKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `test` key offset, or miss. -/
public unsafe def findTestKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findTestKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findTestKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findTestKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isTestKey addr i0 kn) U32.one)
                  i0
                  (findTestKeyGo addr (afterLineEnd addr le n) n)))))
       (findTestKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `test` key exists (first non-comment match; W128 more63 presence).

**Honesty:** Lake greppable CLI command token `test` — `CLI/Main.lean`
`| "test" => lake.test`; Help.lean `| "test"` / `helpTest`. Presence-only
literal-byte **exact length-4** key match before `=` — not value decode.
**Distinct from** more3 `hasTestDriver` (`testDriver` len-10), more9
`hasTestDriverArgs` (`testDriverArgs` len-14), more28 `hasTestRunner`
(`testRunner` len-10): those must miss bare `test`; this API must miss
longer keys. Prefix peers (`testX`, `Test`, `TEST`) must not match. -/
public unsafe def hasTest (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findTestKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `serve` key offset, or miss. -/
public unsafe def findServeKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findServeKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findServeKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findServeKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isServeKey addr i0 kn) U32.one)
                  i0
                  (findServeKeyGo addr (afterLineEnd addr le n) n)))))
       (findServeKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `serve` key exists (first non-comment match; W128 more63 presence).

**Honesty:** Lake greppable CLI command token `serve` — `CLI/Main.lean`
`| "serve" => lake.serve`; Help.lean `| "serve"` / `helpServe`. Presence-only
literal-byte **exact length-5** key match before `=` — not value decode.
**Distinct from** more29 `hasServerOptions` (`serverOptions` len-13) and
more30 `hasServerArgs` (`serverArgs` len-10): those must miss bare `serve`;
this API must miss longer keys (`server*`). Prefix peers (`serveX`, `Serve`,
`SERVE`) must not match. -/
public unsafe def hasServe (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findServeKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Match key text `lint` (four bytes). -/
public unsafe def isLintKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len lintkKeyLen)
    (bifU32 (U32.beq (loadAt addr off) lintk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) lintk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) lintk2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) lintk3)
            U32.one U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Match key text `exe` (three bytes). -/
public unsafe def isExeKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len exekKeyLen)
    (bifU32 (U32.beq (loadAt addr off) exek0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) exek1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) exek2)
          U32.one U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Match key text `query` (five bytes). -/
public unsafe def isQueryKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len querykKeyLen)
    (bifU32 (U32.beq (loadAt addr off) queryk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) queryk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) queryk2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) queryk3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) queryk4)
              U32.one U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `lint` key offset, or miss. -/
public unsafe def findLintKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findLintKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findLintKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findLintKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isLintKey addr i0 kn) U32.one)
                  i0
                  (findLintKeyGo addr (afterLineEnd addr le n) n)))))
       (findLintKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `lint` key exists (first non-comment match; W129 more64 presence).

**Honesty:** Lake greppable CLI command token `lint` — `CLI/Main.lean`
`| "lint" => lake.lint`; Help.lean `| "lint"` / `helpLint`. Presence-only
literal-byte **exact length-4** key match before `=` — not value decode.
**Distinct from** more3 `hasLintDriver` (`lintDriver` len-10), more10
`hasLintDriverArgs` (`lintDriverArgs` len-14), more20 `hasBuiltinLint`
(`builtinLint` len-11): those must miss bare `lint`; this API must miss
longer keys. Prefix peers (`lintX`, `Lint`, `LINT`) must not match. -/
public unsafe def hasLint (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findLintKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `exe` key offset, or miss. -/
public unsafe def findExeKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findExeKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findExeKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findExeKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isExeKey addr i0 kn) U32.one)
                  i0
                  (findExeKeyGo addr (afterLineEnd addr le n) n)))))
       (findExeKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `exe` key exists (first non-comment match; W129 more64 presence).

**Honesty:** Lake greppable CLI command token `exe` — `CLI/Main.lean`
`| "exe" | "exec" => lake.exe`; Help.lean `| "exe"` / `helpExe`. Presence-only
literal-byte **exact length-3** key match before `=` — not value decode.
**Distinct from** more26 `hasExeName` (`exeName` len-7): that must miss bare
`exe`; this API must miss longer keys. Prefix peers (`exeX`, `Exe`, `EXE`)
must not match. -/
public unsafe def hasExe (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findExeKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `query` key offset, or miss. -/
public unsafe def findQueryKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findQueryKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findQueryKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findQueryKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isQueryKey addr i0 kn) U32.one)
                  i0
                  (findQueryKeyGo addr (afterLineEnd addr le n) n)))))
       (findQueryKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `query` key exists (first non-comment match; W129 more64 presence).

**Honesty:** Lake greppable CLI command token `query` — `CLI/Main.lean`
`| "query" => lake.query`; Help.lean `| "query"` / `helpQuery`. Presence-only
literal-byte **exact length-5** key match before `=` — not value decode.
Prefix peers (`queryX`, `Query`, `QUERY`) must not match. -/
public unsafe def hasQuery (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findQueryKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Match key text `init` (four bytes). -/
public unsafe def isInitKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len initkKeyLen)
    (bifU32 (U32.beq (loadAt addr off) initk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) initk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) initk2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) initk3)
            U32.one U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Match key text `new` (three bytes). -/
public unsafe def isNewKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len newkKeyLen)
    (bifU32 (U32.beq (loadAt addr off) newk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) newk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) newk2)
          U32.one U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Match key text `update` (six bytes). -/
public unsafe def isUpdateKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len updatekKeyLen)
    (bifU32 (U32.beq (loadAt addr off) updatek0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) updatek1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) updatek2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) updatek3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) updatek4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) updatek5)
                U32.one U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `init` key offset, or miss. -/
public unsafe def findInitKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findInitKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findInitKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findInitKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isInitKey addr i0 kn) U32.one)
                  i0
                  (findInitKeyGo addr (afterLineEnd addr le n) n)))))
       (findInitKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `init` key exists (first non-comment match; W130 more65 presence).

**Honesty:** Lake greppable CLI command token `init` — `CLI/Main.lean`
`| "init" => lake.init`; Help.lean `| "init"` / `helpInit`. Presence-only
literal-byte **exact length-4** key match before `=` — not value decode.
Prefix peers (`initX`, `Init`, `INIT`) must not match. -/
public unsafe def hasInit (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findInitKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `new` key offset, or miss. -/
public unsafe def findNewKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findNewKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findNewKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findNewKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isNewKey addr i0 kn) U32.one)
                  i0
                  (findNewKeyGo addr (afterLineEnd addr le n) n)))))
       (findNewKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `new` key exists (first non-comment match; W130 more65 presence).

**Honesty:** Lake greppable CLI command token `new` — `CLI/Main.lean`
`| "new" => lake.new`; Help.lean `| "new"` / `helpNew`. Presence-only
literal-byte **exact length-3** key match before `=` — not value decode.
Prefix peers (`newX`, `New`, `NEW`) must not match. -/
public unsafe def hasNew (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findNewKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `update` key offset, or miss. -/
public unsafe def findUpdateKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findUpdateKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findUpdateKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findUpdateKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isUpdateKey addr i0 kn) U32.one)
                  i0
                  (findUpdateKeyGo addr (afterLineEnd addr le n) n)))))
       (findUpdateKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `update` key exists (first non-comment match; W130 more65 presence).

**Honesty:** Lake greppable CLI command token `update` — `CLI/Main.lean`
`| "update" | "upgrade" => lake.update`; Help.lean `| "update"` / `helpUpdate`.
Presence-only literal-byte **exact length-6** key match before `=` — not value
decode. Bare `update` only (alias `upgrade` is a different key). Prefix peers
(`updateX`, `Update`, `UPDATE`) must not match. -/
public unsafe def hasUpdate (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findUpdateKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Match key text `pack` (four bytes). -/
public unsafe def isPackKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len packkKeyLen)
    (bifU32 (U32.beq (loadAt addr off) packk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) packk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) packk2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) packk3)
            U32.one U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Match key text `unpack` (six bytes). -/
public unsafe def isUnpackKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len unpackkKeyLen)
    (bifU32 (U32.beq (loadAt addr off) unpackk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) unpackk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) unpackk2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) unpackk3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) unpackk4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) unpackk5)
                U32.one U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Match key text `upload` (six bytes). -/
public unsafe def isUploadKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len uploadkKeyLen)
    (bifU32 (U32.beq (loadAt addr off) uploadk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) uploadk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) uploadk2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) uploadk3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) uploadk4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) uploadk5)
                U32.one U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `pack` key offset, or miss. -/
public unsafe def findPackKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findPackKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findPackKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findPackKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isPackKey addr i0 kn) U32.one)
                  i0
                  (findPackKeyGo addr (afterLineEnd addr le n) n)))))
       (findPackKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `pack` key exists (first non-comment match; W131 more66 presence).

**Honesty:** Lake greppable CLI command token `pack` — `CLI/Main.lean`
`| "pack" => lake.pack`; Help.lean `| "pack"` / `helpPack`. Presence-only
literal-byte **exact length-4** key match before `=` — not value decode.
Prefix peers (`packX`, `Pack`, `PACK`) must not match. Distinct from longer
`unpack` (exact len-6). -/
public unsafe def hasPack (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findPackKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `unpack` key offset, or miss. -/
public unsafe def findUnpackKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findUnpackKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findUnpackKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findUnpackKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isUnpackKey addr i0 kn) U32.one)
                  i0
                  (findUnpackKeyGo addr (afterLineEnd addr le n) n)))))
       (findUnpackKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `unpack` key exists (first non-comment match; W131 more66 presence).

**Honesty:** Lake greppable CLI command token `unpack` — `CLI/Main.lean`
`| "unpack" => lake.unpack`; Help.lean `| "unpack"` / `helpUnpack`. Presence-only
literal-byte **exact length-6** key match before `=` — not value decode.
Prefix peers (`unpackX`, `Unpack`, `UNPACK`) must not match. Distinct from bare
`pack` (exact len-4). -/
public unsafe def hasUnpack (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findUnpackKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `upload` key offset, or miss. -/
public unsafe def findUploadKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findUploadKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findUploadKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findUploadKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isUploadKey addr i0 kn) U32.one)
                  i0
                  (findUploadKeyGo addr (afterLineEnd addr le n) n)))))
       (findUploadKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `upload` key exists (first non-comment match; W131 more66 presence).

**Honesty:** Lake greppable CLI command token `upload` — `CLI/Main.lean`
`| "upload" => lake.upload`; Help.lean `| "upload"` / `helpUpload`. Presence-only
literal-byte **exact length-6** key match before `=` — not value decode.
Prefix peers (`uploadX`, `Upload`, `UPLOAD`) must not match. Distinct from more65
len-6 `update` (`hasUpdate`) — reverse peer. -/
public unsafe def hasUpload (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findUploadKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Match key text `shake` (five bytes). -/
public unsafe def isShakeKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len shakekKeyLen)
    (bifU32 (U32.beq (loadAt addr off) shakek0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) shakek1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) shakek2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) shakek3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) shakek4)
              U32.one U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Match key text `run` (three bytes). -/
public unsafe def isRunKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len runkKeyLen)
    (bifU32 (U32.beq (loadAt addr off) runk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) runk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) runk2)
          U32.one U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Match key text `scripts` (seven bytes). -/
public unsafe def isScriptsKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len scriptskKeyLen)
    (bifU32 (U32.beq (loadAt addr off) scriptsk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) scriptsk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) scriptsk2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) scriptsk3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) scriptsk4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) scriptsk5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) scriptsk6)
                  U32.one U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `shake` key offset, or miss. -/
public unsafe def findShakeKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findShakeKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findShakeKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findShakeKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isShakeKey addr i0 kn) U32.one)
                  i0
                  (findShakeKeyGo addr (afterLineEnd addr le n) n)))))
       (findShakeKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `shake` key exists (first non-comment match; W132 more67 presence).

**Honesty:** Lake greppable CLI command token `shake` — `CLI/Main.lean`
`| "shake" => lake.shake`; Help.lean `| "shake"` / `helpShake`. Presence-only
literal-byte **exact length-5** key match before `=` — not value decode.
Prefix peers (`shakeX`, `Shake`, `SHAKE`) must not match. -/
public unsafe def hasShake (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findShakeKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `run` key offset, or miss. -/
public unsafe def findRunKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findRunKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findRunKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findRunKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isRunKey addr i0 kn) U32.one)
                  i0
                  (findRunKeyGo addr (afterLineEnd addr le n) n)))))
       (findRunKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `run` key exists (first non-comment match; W132 more67 presence).

**Honesty:** Lake greppable CLI command token `run` — `CLI/Main.lean`
`| "run" => lake.script.run`; Help.lean `| "run"` / `helpScriptRun`. Presence-only
literal-byte **exact length-3** key match before `=` — not value decode.
Prefix peers (`runX`, `Run`, `RUN`) must not match. -/
public unsafe def hasRun (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findRunKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `scripts` key offset, or miss. -/
public unsafe def findScriptsKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findScriptsKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findScriptsKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findScriptsKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isScriptsKey addr i0 kn) U32.one)
                  i0
                  (findScriptsKeyGo addr (afterLineEnd addr le n) n)))))
       (findScriptsKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `scripts` key exists (first non-comment match; W132 more67 presence).

**Honesty:** Lake greppable CLI command token `scripts` — `CLI/Main.lean`
`| "scripts" => lake.script.list`; Help.lean `| "scripts"` / `helpScriptList`.
Presence-only literal-byte **exact length-7** key match before `=` — not value
decode. Prefix peers (`scriptsX`, `Scripts`, `SCRIPTS`) must not match. Distinct
from more58 len-6 `script` (`hasScript`) — reverse peer. -/
public unsafe def hasScripts (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findScriptsKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Match key text `get` (three bytes). -/
public unsafe def isGetKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len getkKeyLen)
    (bifU32 (U32.beq (loadAt addr off) getk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) getk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) getk2)
          U32.one U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Match key text `put` (three bytes). -/
public unsafe def isPutKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len putkKeyLen)
    (bifU32 (U32.beq (loadAt addr off) putk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) putk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) putk2)
          U32.one U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Match key text `add` (three bytes). -/
public unsafe def isAddKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len addkKeyLen)
    (bifU32 (U32.beq (loadAt addr off) addk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) addk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) addk2)
          U32.one U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `get` key offset, or miss. -/
public unsafe def findGetKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findGetKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findGetKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findGetKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isGetKey addr i0 kn) U32.one)
                  i0
                  (findGetKeyGo addr (afterLineEnd addr le n) n)))))
       (findGetKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `get` key exists (first non-comment match; W133 more68 presence).

**Honesty:** Lake greppable CLI command token `get` — `CLI/Main.lean`
`| "get" => cache.get`; Help.lean `| "get"` / `helpCacheGet`. Presence-only
literal-byte **exact length-3** key match before `=` — not value decode.
Prefix peers (`getX`, `Get`, `GET`) must not match. -/
public unsafe def hasGet (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findGetKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `put` key offset, or miss. -/
public unsafe def findPutKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findPutKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findPutKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findPutKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isPutKey addr i0 kn) U32.one)
                  i0
                  (findPutKeyGo addr (afterLineEnd addr le n) n)))))
       (findPutKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `put` key exists (first non-comment match; W133 more68 presence).

**Honesty:** Lake greppable CLI command token `put` — `CLI/Main.lean`
`| "put" => cache.put`; Help.lean `| "put"` / `helpCachePut`. Presence-only
literal-byte **exact length-3** key match before `=` — not value decode.
Prefix peers (`putX`, `Put`, `PUT`) must not match. -/
public unsafe def hasPut (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findPutKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `add` key offset, or miss. -/
public unsafe def findAddKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findAddKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findAddKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findAddKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isAddKey addr i0 kn) U32.one)
                  i0
                  (findAddKeyGo addr (afterLineEnd addr le n) n)))))
       (findAddKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if an `add` key exists (first non-comment match; W133 more68 presence).

**Honesty:** Lake greppable CLI command token `add` — `CLI/Main.lean`
`| "add" => cache.add`; Help.lean `| "add"` / `helpCacheAdd`. Presence-only
literal-byte **exact length-3** key match before `=` — not value decode.
Prefix peers (`addX`, `Add`, `ADD`) must not match. Distinct from more58
len-5 `cache` (`hasCache`) — reverse peer among cache CLI subcommands. -/
public unsafe def hasAdd (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findAddKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Match key text `list` (four bytes). -/
public unsafe def isListKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len listkKeyLen)
    (bifU32 (U32.beq (loadAt addr off) listk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) listk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) listk2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) listk3)
            U32.one U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Match key text `doc` (three bytes). -/
public unsafe def isDocKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len dockKeyLen)
    (bifU32 (U32.beq (loadAt addr off) dock0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) dock1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) dock2)
          U32.one U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Match key text `stage` (five bytes). -/
public unsafe def isStageKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len stagekKeyLen)
    (bifU32 (U32.beq (loadAt addr off) stagek0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) stagek1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) stagek2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) stagek3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) stagek4)
              U32.one U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `list` key offset, or miss. -/
public unsafe def findListKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findListKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findListKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findListKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isListKey addr i0 kn) U32.one)
                  i0
                  (findListKeyGo addr (afterLineEnd addr le n) n)))))
       (findListKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `list` key exists (first non-comment match; W134 more69 presence).

**Honesty:** Lake greppable CLI command token `list` — `CLI/Main.lean`
`| "list" => script.list`; Help.lean `| "list"` / `helpScriptList`. Presence-only
literal-byte **exact length-4** key match before `=` — not value decode.
Prefix peers (`listX`, `List`, `LIST`) must not match. Distinct from more67
len-7 `scripts` / more58 len-6 `script`. -/
public unsafe def hasList (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findListKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `doc` key offset, or miss. -/
public unsafe def findDocKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findDocKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findDocKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findDocKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isDocKey addr i0 kn) U32.one)
                  i0
                  (findDocKeyGo addr (afterLineEnd addr le n) n)))))
       (findDocKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `doc` key exists (first non-comment match; W134 more69 presence).

**Honesty:** Lake greppable CLI command token `doc` — `CLI/Main.lean`
`| "doc" => script.doc`; Help.lean `| "doc"` / `helpScriptDoc`. Presence-only
literal-byte **exact length-3** key match before `=` — not value decode.
Prefix peers (`docX`, `Doc`, `DOC`) must not match. -/
public unsafe def hasDoc (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findDocKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `stage` key offset, or miss. -/
public unsafe def findStageKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findStageKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findStageKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findStageKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isStageKey addr i0 kn) U32.one)
                  i0
                  (findStageKeyGo addr (afterLineEnd addr le n) n)))))
       (findStageKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `stage` key exists (first non-comment match; W134 more69 presence).

**Honesty:** Lake greppable CLI command token `stage` — `CLI/Main.lean`
`| "stage" => cache.stage`; Help.lean `| "stage"` / `helpCacheStage`. Presence-only
literal-byte **exact length-5** key match before `=` — not value decode.
Prefix peers (`stageX`, `Stage`, `STAGE`) must not match. Distinct from more58
len-5 `cache` (`hasCache`) and more68 get/put/add — reverse peers among cache CLI. -/
public unsafe def hasStage (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findStageKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Match key text `exec` (four bytes). -/
public unsafe def isExecKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len execkKeyLen)
    (bifU32 (U32.beq (loadAt addr off) execk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) execk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) execk2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) execk3)
            U32.one U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Match key text `unstage` (seven bytes). -/
public unsafe def isUnstageKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len unstagekKeyLen)
    (bifU32 (U32.beq (loadAt addr off) unstagek0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) unstagek1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) unstagek2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) unstagek3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) unstagek4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) unstagek5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) unstagek6)
                  U32.one U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Match key text `put-staged` (ten bytes). -/
public unsafe def isPutStagedKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len putstagedkKeyLen)
    (bifU32 (U32.beq (loadAt addr off) putstagedk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) putstagedk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) putstagedk2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) putstagedk3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) putstagedk4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) putstagedk5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) putstagedk6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) putstagedk7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) putstagedk8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) putstagedk9)
                        U32.one U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `exec` key offset, or miss. -/
public unsafe def findExecKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findExecKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findExecKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findExecKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isExecKey addr i0 kn) U32.one)
                  i0
                  (findExecKeyGo addr (afterLineEnd addr le n) n)))))
       (findExecKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if an `exec` key exists (first non-comment match; W135 more70 presence).

**Honesty:** Lake greppable CLI command token `exec` — `CLI/Main.lean`
`| "exe" | "exec" => lake.exe`; Help.lean helpExe. Presence-only
literal-byte **exact length-4** key match before `=` — not value decode.
Prefix peers (`execX`, `Exec`, `EXEC`) must not match. Distinct from more64
len-3 `exe` (`hasExe`) — reverse peer among exe/exec CLI aliases. -/
public unsafe def hasExec (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findExecKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `unstage` key offset, or miss. -/
public unsafe def findUnstageKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findUnstageKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findUnstageKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findUnstageKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isUnstageKey addr i0 kn) U32.one)
                  i0
                  (findUnstageKeyGo addr (afterLineEnd addr le n) n)))))
       (findUnstageKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if an `unstage` key exists (first non-comment match; W135 more70 presence).

**Honesty:** Lake greppable CLI command token `unstage` — `CLI/Main.lean`
`| "unstage" => cache.unstage`; Help.lean `| "unstage"` / `helpCacheUnstage`.
Presence-only literal-byte **exact length-7** key match before `=` — not value
decode. Prefix peers (`unstageX`, `Unstage`, `UNSTAGE`) must not match.
Distinct from more69 len-5 `stage` (`hasStage`) — reverse peer among cache stage. -/
public unsafe def hasUnstage (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findUnstageKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `put-staged` key offset, or miss. -/
public unsafe def findPutStagedKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findPutStagedKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findPutStagedKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findPutStagedKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isPutStagedKey addr i0 kn) U32.one)
                  i0
                  (findPutStagedKeyGo addr (afterLineEnd addr le n) n)))))
       (findPutStagedKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `put-staged` key exists (first non-comment match; W135 more70 presence).

**Honesty:** Lake greppable CLI command token `put-staged` — `CLI/Main.lean`
`| "put-staged" => cache.putStaged`; Help.lean `| "put-staged"` /
`helpCachePutStaged`. Presence-only literal-byte **exact length-10** key match
before `=` — not value decode. Prefix peers (`put-stagedX`, `Put-staged`) must
not match. Distinct from more68 len-3 `put` (`hasPut`) / more69 len-5 `stage`
(`hasStage`) — reverse peers among cache CLI. -/
public unsafe def hasPutStaged (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findPutStagedKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Match key text `check-build` (eleven bytes). -/
public unsafe def isCheckBuildKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len checkbuildkKeyLen)
    (bifU32 (U32.beq (loadAt addr off) checkbuildk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) checkbuildk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) checkbuildk2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) checkbuildk3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) checkbuildk4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) checkbuildk5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) checkbuildk6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) checkbuildk7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) checkbuildk8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) checkbuildk9)
                        (bifU32 (U32.beq (loadAt addr (USize.add off off10)) checkbuildk10)
                          U32.one U32.zero)
                        U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Match key text `check-lint` (ten bytes). -/
public unsafe def isCheckLintKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len checklintkKeyLen)
    (bifU32 (U32.beq (loadAt addr off) checklintk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) checklintk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) checklintk2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) checklintk3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) checklintk4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) checklintk5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) checklintk6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) checklintk7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) checklintk8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) checklintk9)
                        U32.one U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Match key text `check-test` (ten bytes). -/
public unsafe def isCheckTestKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len checktestkKeyLen)
    (bifU32 (U32.beq (loadAt addr off) checktestk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) checktestk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) checktestk2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) checktestk3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) checktestk4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) checktestk5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) checktestk6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) checktestk7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) checktestk8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) checktestk9)
                        U32.one U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `check-build` key offset, or miss. -/
public unsafe def findCheckBuildKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findCheckBuildKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findCheckBuildKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findCheckBuildKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isCheckBuildKey addr i0 kn) U32.one)
                  i0
                  (findCheckBuildKeyGo addr (afterLineEnd addr le n) n)))))
       (findCheckBuildKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `check-build` key exists (first non-comment match; W136 more71 presence).

**Honesty:** Lake greppable CLI command token `check-build` — `CLI/Main.lean`
`| "check-build" => lake.checkBuild`; Help.lean `| "check-build"` /
`helpCheckBuild`. Presence-only literal-byte **exact length-11** key match
before `=` — not value decode. Prefix peers (`check-buildX`, `Check-build`) must
not match. Distinct from more62 len-5 `build` (`hasBuild`) — reverse peer among
build CLI. -/
public unsafe def hasCheckBuild (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findCheckBuildKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `check-lint` key offset, or miss. -/
public unsafe def findCheckLintKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findCheckLintKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findCheckLintKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findCheckLintKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isCheckLintKey addr i0 kn) U32.one)
                  i0
                  (findCheckLintKeyGo addr (afterLineEnd addr le n) n)))))
       (findCheckLintKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `check-lint` key exists (first non-comment match; W136 more71 presence).

**Honesty:** Lake greppable CLI command token `check-lint` — `CLI/Main.lean`
`| "check-lint" => lake.checkLint`; Help.lean `| "check-lint"` /
`helpCheckLint`. Presence-only literal-byte **exact length-10** key match
before `=` — not value decode. Prefix peers (`check-lintX`, `Check-lint`) must
not match. Distinct from more64 len-4 `lint` (`hasLint`) — reverse peer among
lint CLI. -/
public unsafe def hasCheckLint (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findCheckLintKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `check-test` key offset, or miss. -/
public unsafe def findCheckTestKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findCheckTestKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findCheckTestKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findCheckTestKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isCheckTestKey addr i0 kn) U32.one)
                  i0
                  (findCheckTestKeyGo addr (afterLineEnd addr le n) n)))))
       (findCheckTestKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `check-test` key exists (first non-comment match; W136 more71 presence).

**Honesty:** Lake greppable CLI command token `check-test` — `CLI/Main.lean`
`| "check-test" => lake.checkTest`; Help.lean `| "check-test"` /
`helpCheckTest`. Presence-only literal-byte **exact length-10** key match
before `=` — not value decode. Prefix peers (`check-testX`, `Check-test`) must
not match. Distinct from more63 len-4 `test` (`hasTest`) — reverse peer among
test CLI. -/
public unsafe def hasCheckTest (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findCheckTestKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one


/-- Match key text `query-kind` (ten bytes). -/
public unsafe def isQueryKindKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len querykindkKeyLen)
    (bifU32 (U32.beq (loadAt addr off) querykindk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) querykindk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) querykindk2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) querykindk3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) querykindk4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) querykindk5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) querykindk6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) querykindk7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) querykindk8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) querykindk9)
                        U32.one U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Match key text `setup-file` (ten bytes). -/
public unsafe def isSetupFileKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len setupfilekKeyLen)
    (bifU32 (U32.beq (loadAt addr off) setupfilek0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) setupfilek1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) setupfilek2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) setupfilek3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) setupfilek4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) setupfilek5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) setupfilek6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) setupfilek7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) setupfilek8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) setupfilek9)
                        U32.one U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Match key text `self-check` (ten bytes). -/
public unsafe def isSelfCheckKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len selfcheckkKeyLen)
    (bifU32 (U32.beq (loadAt addr off) selfcheckk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) selfcheckk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) selfcheckk2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) selfcheckk3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) selfcheckk4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) selfcheckk5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) selfcheckk6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) selfcheckk7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) selfcheckk8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) selfcheckk9)
                        U32.one U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `query-kind` key offset, or miss. -/
public unsafe def findQueryKindKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findQueryKindKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findQueryKindKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findQueryKindKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isQueryKindKey addr i0 kn) U32.one)
                  i0
                  (findQueryKindKeyGo addr (afterLineEnd addr le n) n)))))
       (findQueryKindKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `query-kind` key exists (first non-comment match; W137 more72 presence).

**Honesty:** Lake greppable CLI command token `query-kind` — `CLI/Main.lean`
`| "query-kind" => lake.queryKind`. Presence-only literal-byte **exact length-10**
key match before `=` — not value decode. Prefix peers (`query-kindX`,
`Query-kind`) must not match. Distinct from more64 len-5 `query` (`hasQuery`) /
more35 len-4 `kind` (`hasKind`) — reverse peers among query CLI. -/
public unsafe def hasQueryKind (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findQueryKindKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `setup-file` key offset, or miss. -/
public unsafe def findSetupFileKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findSetupFileKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findSetupFileKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findSetupFileKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isSetupFileKey addr i0 kn) U32.one)
                  i0
                  (findSetupFileKeyGo addr (afterLineEnd addr le n) n)))))
       (findSetupFileKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `setup-file` key exists (first non-comment match; W137 more72 presence).

**Honesty:** Lake greppable CLI command token `setup-file` — `CLI/Main.lean`
`| "setup-file" => lake.setupFile`; Serve.lean. Presence-only literal-byte
**exact length-10** key match before `=` — not value decode. Prefix peers
(`setup-fileX`, `Setup-file`) must not match. -/
public unsafe def hasSetupFile (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findSetupFileKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `self-check` key offset, or miss. -/
public unsafe def findSelfCheckKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findSelfCheckKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findSelfCheckKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findSelfCheckKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isSelfCheckKey addr i0 kn) U32.one)
                  i0
                  (findSelfCheckKeyGo addr (afterLineEnd addr le n) n)))))
       (findSelfCheckKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `self-check` key exists (first non-comment match; W137 more72 presence).

**Honesty:** Lake greppable CLI command token `self-check` — `CLI/Main.lean`
`| "self-check" => lake.selfCheck`. Presence-only literal-byte **exact length-10**
key match before `=` — not value decode. Prefix peers (`self-checkX`,
`Self-check`) must not match. -/
public unsafe def hasSelfCheck (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findSelfCheckKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Match key text `translate-config` (sixteen bytes). -/
public unsafe def isTranslateConfigKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len translateconfigkKeyLen)
    (bifU32 (U32.beq (loadAt addr off) translateconfigk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) translateconfigk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) translateconfigk2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) translateconfigk3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) translateconfigk4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) translateconfigk5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) translateconfigk6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) translateconfigk7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) translateconfigk8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) translateconfigk9)
                        (bifU32 (U32.beq (loadAt addr (USize.add off off10)) translateconfigk10)
                          (bifU32 (U32.beq (loadAt addr (USize.add off off11)) translateconfigk11)
                            (bifU32 (U32.beq (loadAt addr (USize.add off off12)) translateconfigk12)
                              (bifU32 (U32.beq (loadAt addr (USize.add off off13)) translateconfigk13)
                                (bifU32 (U32.beq (loadAt addr (USize.add off off14)) translateconfigk14)
                                  (bifU32 (U32.beq (loadAt addr (USize.add off off15)) translateconfigk15)
                                    U32.one U32.zero)
                                  U32.zero)
                                U32.zero)
                              U32.zero)
                            U32.zero)
                          U32.zero)
                        U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Match key text `resolve-deps` (twelve bytes). -/
public unsafe def isResolveDepsKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len resolvedepskKeyLen)
    (bifU32 (U32.beq (loadAt addr off) resolvedepsk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) resolvedepsk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) resolvedepsk2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) resolvedepsk3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) resolvedepsk4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) resolvedepsk5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) resolvedepsk6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) resolvedepsk7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) resolvedepsk8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) resolvedepsk9)
                        (bifU32 (U32.beq (loadAt addr (USize.add off off10)) resolvedepsk10)
                          (bifU32 (U32.beq (loadAt addr (USize.add off off11)) resolvedepsk11)
                            U32.one U32.zero)
                          U32.zero)
                        U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Match key text `services` (eight bytes). -/
public unsafe def isServicesKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len serviceskKeyLen)
    (bifU32 (U32.beq (loadAt addr off) servicesk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) servicesk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) servicesk2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) servicesk3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) servicesk4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) servicesk5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) servicesk6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) servicesk7)
                    U32.one U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `translate-config` key offset, or miss. -/
public unsafe def findTranslateConfigKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findTranslateConfigKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findTranslateConfigKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findTranslateConfigKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isTranslateConfigKey addr i0 kn) U32.one)
                  i0
                  (findTranslateConfigKeyGo addr (afterLineEnd addr le n) n)))))
       (findTranslateConfigKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `translate-config` key exists (first non-comment match; W138 more73 presence).

**Honesty:** Lake greppable CLI command token `translate-config` — `CLI/Main.lean`
`| "translate-config" => lake.translateConfig`. Presence-only literal-byte
**exact length-16** key match before `=` — not value decode. Prefix peers
(`translate-configX`, `Translate-config`) must not match. -/
public unsafe def hasTranslateConfig (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findTranslateConfigKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `resolve-deps` key offset, or miss. -/
public unsafe def findResolveDepsKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findResolveDepsKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findResolveDepsKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findResolveDepsKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isResolveDepsKey addr i0 kn) U32.one)
                  i0
                  (findResolveDepsKeyGo addr (afterLineEnd addr le n) n)))))
       (findResolveDepsKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `resolve-deps` key exists (first non-comment match; W138 more73 presence).

**Honesty:** Lake greppable CLI command token `resolve-deps` — `CLI/Main.lean`
`| "resolve-deps" => lake.resolveDeps`. Presence-only literal-byte **exact length-12**
key match before `=` — not value decode. Prefix peers (`resolve-depsX`,
`Resolve-deps`) must not match. -/
public unsafe def hasResolveDeps (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findResolveDepsKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `services` key offset, or miss. -/
public unsafe def findServicesKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findServicesKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findServicesKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findServicesKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isServicesKey addr i0 kn) U32.one)
                  i0
                  (findServicesKeyGo addr (afterLineEnd addr le n) n)))))
       (findServicesKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `services` key exists (first non-comment match; W138 more73 presence).

**Honesty:** Lake greppable CLI command token `services` — `CLI/Main.lean`
`| "services" => cache.services`. Presence-only literal-byte **exact length-8**
key match before `=` — not value decode. Prefix peers (`servicesX`,
`Services`) must not match. Distinct from more40 len-7 `service` (`hasService`)
— reverse peers among service/services CLI. -/
public unsafe def hasServices (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findServicesKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Match key text `reservoir-config` (sixteen bytes). -/
public unsafe def isReservoirConfigKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len reservoirconfigkKeyLen)
    (bifU32 (U32.beq (loadAt addr off) reservoirconfigk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) reservoirconfigk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) reservoirconfigk2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) reservoirconfigk3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) reservoirconfigk4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) reservoirconfigk5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) reservoirconfigk6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) reservoirconfigk7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) reservoirconfigk8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) reservoirconfigk9)
                        (bifU32 (U32.beq (loadAt addr (USize.add off off10)) reservoirconfigk10)
                          (bifU32 (U32.beq (loadAt addr (USize.add off off11)) reservoirconfigk11)
                            (bifU32 (U32.beq (loadAt addr (USize.add off off12)) reservoirconfigk12)
                              (bifU32 (U32.beq (loadAt addr (USize.add off off13)) reservoirconfigk13)
                                (bifU32 (U32.beq (loadAt addr (USize.add off off14)) reservoirconfigk14)
                                  (bifU32 (U32.beq (loadAt addr (USize.add off off15)) reservoirconfigk15)
                                    U32.one U32.zero)
                                  U32.zero)
                                U32.zero)
                              U32.zero)
                            U32.zero)
                          U32.zero)
                        U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Match key text `version-tags` (twelve bytes; hyphen CLI token). -/
public unsafe def isVersionTagsCliKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len versiontagsclikKeyLen)
    (bifU32 (U32.beq (loadAt addr off) versiontagsclik0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) versiontagsclik1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) versiontagsclik2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) versiontagsclik3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) versiontagsclik4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) versiontagsclik5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) versiontagsclik6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) versiontagsclik7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) versiontagsclik8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) versiontagsclik9)
                        (bifU32 (U32.beq (loadAt addr (USize.add off off10)) versiontagsclik10)
                          (bifU32 (U32.beq (loadAt addr (USize.add off off11)) versiontagsclik11)
                            U32.one U32.zero)
                          U32.zero)
                        U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Match key text `upgrade` (seven bytes). -/
public unsafe def isUpgradeKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len upgradekKeyLen)
    (bifU32 (U32.beq (loadAt addr off) upgradek0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) upgradek1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) upgradek2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) upgradek3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) upgradek4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) upgradek5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) upgradek6)
                  U32.one U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `reservoir-config` key offset, or miss. -/
public unsafe def findReservoirConfigKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findReservoirConfigKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findReservoirConfigKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findReservoirConfigKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isReservoirConfigKey addr i0 kn) U32.one)
                  i0
                  (findReservoirConfigKeyGo addr (afterLineEnd addr le n) n)))))
       (findReservoirConfigKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `reservoir-config` key exists (first non-comment match; W139 more74 presence).

**Honesty:** Lake greppable CLI command token `reservoir-config` — `CLI/Main.lean`
`| "reservoir-config" => lake.reservoirConfig`. Presence-only literal-byte
**exact length-16** key match before `=` — not value decode. Prefix peers
(`reservoir-configX`, `Reservoir-config`) must not match. Distinct from more7
len-9 `reservoir` (`hasReservoir`) — reverse peer. -/
public unsafe def hasReservoirConfig (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findReservoirConfigKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `version-tags` key offset, or miss. -/
public unsafe def findVersionTagsCliKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findVersionTagsCliKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findVersionTagsCliKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findVersionTagsCliKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isVersionTagsCliKey addr i0 kn) U32.one)
                  i0
                  (findVersionTagsCliKeyGo addr (afterLineEnd addr le n) n)))))
       (findVersionTagsCliKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `version-tags` key exists (first non-comment match; W139 more74 presence).

**Honesty:** Lake greppable CLI command token `version-tags` — `CLI/Main.lean`
`| "version-tags" => lake.versionTags`. Presence-only literal-byte
**exact length-12** key match before `=` — not value decode. Prefix peers
(`version-tagsX`, `Version-tags`) must not match. Distinct from more12 camelCase
len-11 `versionTags` (`hasVersionTags`) — reverse peer; C ABI uses `_cli` suffix. -/
public unsafe def hasVersionTagsCli (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findVersionTagsCliKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Find first non-comment `upgrade` key offset, or miss. -/
public unsafe def findUpgradeKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findUpgradeKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findUpgradeKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findUpgradeKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isUpgradeKey addr i0 kn) U32.one)
                  i0
                  (findUpgradeKeyGo addr (afterLineEnd addr le n) n)))))
       (findUpgradeKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if an `upgrade` key exists (first non-comment match; W139 more74 presence).

**Honesty:** Lake greppable CLI command token `upgrade` — `CLI/Main.lean`
`| "update" | "upgrade" => lake.update`; Help.lean same. Presence-only
literal-byte **exact length-7** key match before `=` — not value decode. Prefix
peers (`upgradeX`, `Upgrade`) must not match. Distinct from more65 len-6
`update` (`hasUpdate`) — reverse peer. -/
public unsafe def hasUpgrade (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findUpgradeKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Match key text `no-build` (eight bytes). -/
public unsafe def isNoBuildKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len nobuildkKeyLen)
    (bifU32 (U32.beq (loadAt addr off) nobuildk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) nobuildk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) nobuildk2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) nobuildk3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) nobuildk4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) nobuildk5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) nobuildk6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) nobuildk7)
                    U32.one U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `no-build` key offset, or miss. -/
public unsafe def findNoBuildKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findNoBuildKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findNoBuildKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findNoBuildKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isNoBuildKey addr i0 kn) U32.one)
                  i0
                  (findNoBuildKeyGo addr (afterLineEnd addr le n) n)))))
       (findNoBuildKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `no-build` key exists (first non-comment match; W140 more75 presence).

**Honesty:** Lake greppable long-option stem `no-build` — `CLI/Main.lean`
`| "--no-build" =>` (key without leading `--`). Presence-only literal-byte
**exact length-8** key match before `=` — not value decode. Prefix peers
(`no-buildX`, `No-build`) must not match. Distinct from more62 len-5 `build`
(`hasBuild`) — reverse peer. -/
public unsafe def hasNoBuild (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findNoBuildKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Match key text `no-cache` (eight bytes). -/
public unsafe def isNoCacheKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len nocachekKeyLen)
    (bifU32 (U32.beq (loadAt addr off) nocachek0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) nocachek1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) nocachek2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) nocachek3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) nocachek4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) nocachek5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) nocachek6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) nocachek7)
                    U32.one U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `no-cache` key offset, or miss. -/
public unsafe def findNoCacheKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findNoCacheKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findNoCacheKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findNoCacheKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isNoCacheKey addr i0 kn) U32.one)
                  i0
                  (findNoCacheKeyGo addr (afterLineEnd addr le n) n)))))
       (findNoCacheKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `no-cache` key exists (first non-comment match; W140 more75 presence).

**Honesty:** Lake greppable long-option stem `no-cache` — `CLI/Main.lean`
`| "--no-cache" =>` (key without leading `--`). Presence-only literal-byte
**exact length-8** key match before `=` — not value decode. Prefix peers
(`no-cacheX`, `No-cache`) must not match. Distinct from more58 len-5 `cache`
(`hasCache`) and peer `try-cache` — reverse peers. -/
public unsafe def hasNoCache (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findNoCacheKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Match key text `try-cache` (nine bytes). -/
public unsafe def isTryCacheKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len trycachekKeyLen)
    (bifU32 (U32.beq (loadAt addr off) trycachek0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) trycachek1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) trycachek2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) trycachek3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) trycachek4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) trycachek5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) trycachek6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) trycachek7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) trycachek8)
                      U32.one U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `try-cache` key offset, or miss. -/
public unsafe def findTryCacheKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findTryCacheKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findTryCacheKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findTryCacheKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isTryCacheKey addr i0 kn) U32.one)
                  i0
                  (findTryCacheKeyGo addr (afterLineEnd addr le n) n)))))
       (findTryCacheKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `try-cache` key exists (first non-comment match; W140 more75 presence).

**Honesty:** Lake greppable long-option stem `try-cache` — `CLI/Main.lean`
`| "--try-cache" =>` (key without leading `--`). Presence-only literal-byte
**exact length-9** key match before `=` — not value decode. Prefix peers
(`try-cacheX`, `Try-cache`) must not match. Distinct from more58 len-5 `cache`
(`hasCache`) and peer `no-cache` — reverse peers. -/
public unsafe def hasTryCache (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findTryCacheKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Match key text `force-download` (fourteen bytes). -/
public unsafe def isForceDownloadKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len forcedownloadkKeyLen)
    (bifU32 (U32.beq (loadAt addr off) forcedownloadk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) forcedownloadk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) forcedownloadk2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) forcedownloadk3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) forcedownloadk4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) forcedownloadk5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) forcedownloadk6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) forcedownloadk7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) forcedownloadk8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) forcedownloadk9)
                        (bifU32 (U32.beq (loadAt addr (USize.add off off10)) forcedownloadk10)
                          (bifU32 (U32.beq (loadAt addr (USize.add off off11)) forcedownloadk11)
                            (bifU32 (U32.beq (loadAt addr (USize.add off off12)) forcedownloadk12)
                              (bifU32 (U32.beq (loadAt addr (USize.add off off13)) forcedownloadk13)
                                U32.one U32.zero)
                              U32.zero)
                            U32.zero)
                          U32.zero)
                        U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `force-download` key offset, or miss. -/
public unsafe def findForceDownloadKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findForceDownloadKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findForceDownloadKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findForceDownloadKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isForceDownloadKey addr i0 kn) U32.one)
                  i0
                  (findForceDownloadKeyGo addr (afterLineEnd addr le n) n)))))
       (findForceDownloadKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `force-download` key exists (first non-comment match; W141 more76 presence).

**Honesty:** Lake greppable long-option stem `force-download` — `CLI/Main.lean`
`| "--force-download" =>` (key without leading `--`). Presence-only literal-byte
**exact length-14** key match before `=` — not value decode. Prefix peers
(`force-downloadX`, `Force-download`) must not match. No shipped reverse peer
among download flags (distinct from more77 len-15 `force-overwrite`). -/
public unsafe def hasForceDownload (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findForceDownloadKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Match key text `download-arts` (thirteen bytes). -/
public unsafe def isDownloadArtsKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len downloadartskKeyLen)
    (bifU32 (U32.beq (loadAt addr off) downloadartsk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) downloadartsk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) downloadartsk2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) downloadartsk3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) downloadartsk4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) downloadartsk5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) downloadartsk6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) downloadartsk7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) downloadartsk8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) downloadartsk9)
                        (bifU32 (U32.beq (loadAt addr (USize.add off off10)) downloadartsk10)
                          (bifU32 (U32.beq (loadAt addr (USize.add off off11)) downloadartsk11)
                            (bifU32 (U32.beq (loadAt addr (USize.add off off12)) downloadartsk12)
                              U32.one U32.zero)
                            U32.zero)
                          U32.zero)
                        U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `download-arts` key offset, or miss. -/
public unsafe def findDownloadArtsKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findDownloadArtsKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findDownloadArtsKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findDownloadArtsKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isDownloadArtsKey addr i0 kn) U32.one)
                  i0
                  (findDownloadArtsKeyGo addr (afterLineEnd addr le n) n)))))
       (findDownloadArtsKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `download-arts` key exists (first non-comment match; W141 more76 presence).

**Honesty:** Lake greppable long-option stem `download-arts` — `CLI/Main.lean`
`| "--download-arts" =>` (key without leading `--`). Presence-only literal-byte
**exact length-13** key match before `=` — not value decode. Prefix peers
(`download-artsX`, `Download-arts`) must not match. Distinct from more55 len-3
`art` (`hasArt`) — reverse peer. -/
public unsafe def hasDownloadArts (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findDownloadArtsKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Match key text `mappings-only` (thirteen bytes). -/
public unsafe def isMappingsOnlyKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len mappingsonlykKeyLen)
    (bifU32 (U32.beq (loadAt addr off) mappingsonlyk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) mappingsonlyk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) mappingsonlyk2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) mappingsonlyk3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) mappingsonlyk4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) mappingsonlyk5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) mappingsonlyk6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) mappingsonlyk7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) mappingsonlyk8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) mappingsonlyk9)
                        (bifU32 (U32.beq (loadAt addr (USize.add off off10)) mappingsonlyk10)
                          (bifU32 (U32.beq (loadAt addr (USize.add off off11)) mappingsonlyk11)
                            (bifU32 (U32.beq (loadAt addr (USize.add off off12)) mappingsonlyk12)
                              U32.one U32.zero)
                            U32.zero)
                          U32.zero)
                        U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `mappings-only` key offset, or miss. -/
public unsafe def findMappingsOnlyKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findMappingsOnlyKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findMappingsOnlyKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findMappingsOnlyKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isMappingsOnlyKey addr i0 kn) U32.one)
                  i0
                  (findMappingsOnlyKeyGo addr (afterLineEnd addr le n) n)))))
       (findMappingsOnlyKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `mappings-only` key exists (first non-comment match; W141 more76 presence).

**Honesty:** Lake greppable long-option stem `mappings-only` — `CLI/Main.lean`
`| "--mappings-only" =>` (key without leading `--`). Presence-only literal-byte
**exact length-13** key match before `=` — not value decode. Prefix peers
(`mappings-onlyX`, `Mappings-only`) must not match. Distinct from more57 len-8
`mappings` (`hasMappings`) — reverse peer. -/
public unsafe def hasMappingsOnly (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findMappingsOnlyKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Match key text `no-overwrite` (twelve bytes). -/
public unsafe def isNoOverwriteKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len nooverwritekKeyLen)
    (bifU32 (U32.beq (loadAt addr off) nooverwritek0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) nooverwritek1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) nooverwritek2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) nooverwritek3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) nooverwritek4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) nooverwritek5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) nooverwritek6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) nooverwritek7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) nooverwritek8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) nooverwritek9)
                        (bifU32 (U32.beq (loadAt addr (USize.add off off10)) nooverwritek10)
                          (bifU32 (U32.beq (loadAt addr (USize.add off off11)) nooverwritek11)
                            U32.one U32.zero)
                          U32.zero)
                        U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `no-overwrite` key offset, or miss. -/
public unsafe def findNoOverwriteKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findNoOverwriteKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findNoOverwriteKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findNoOverwriteKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isNoOverwriteKey addr i0 kn) U32.one)
                  i0
                  (findNoOverwriteKeyGo addr (afterLineEnd addr le n) n)))))
       (findNoOverwriteKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `no-overwrite` key exists (first non-comment match; W142 more77 presence).

**Honesty:** Lake greppable long-option stem `no-overwrite` — `CLI/Main.lean`
`| "--no-overwrite" =>` (key without leading `--`). Presence-only literal-byte
**exact length-12** key match before `=` — not value decode. Prefix peers
(`no-overwriteX`, `No-overwrite`) must not match. Reverse peer
`force-overwrite` (`hasForceOverwrite`). -/
public unsafe def hasNoOverwrite (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findNoOverwriteKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Match key text `force-overwrite` (fifteen bytes). -/
public unsafe def isForceOverwriteKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len forceoverwritekKeyLen)
    (bifU32 (U32.beq (loadAt addr off) forceoverwritek0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) forceoverwritek1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) forceoverwritek2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) forceoverwritek3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) forceoverwritek4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) forceoverwritek5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) forceoverwritek6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) forceoverwritek7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) forceoverwritek8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) forceoverwritek9)
                        (bifU32 (U32.beq (loadAt addr (USize.add off off10)) forceoverwritek10)
                          (bifU32 (U32.beq (loadAt addr (USize.add off off11)) forceoverwritek11)
                            (bifU32 (U32.beq (loadAt addr (USize.add off off12)) forceoverwritek12)
                              (bifU32 (U32.beq (loadAt addr (USize.add off off13)) forceoverwritek13)
                                (bifU32 (U32.beq (loadAt addr (USize.add off off14)) forceoverwritek14)
                                  U32.one U32.zero)
                                U32.zero)
                              U32.zero)
                            U32.zero)
                          U32.zero)
                        U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `force-overwrite` key offset, or miss. -/
public unsafe def findForceOverwriteKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findForceOverwriteKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findForceOverwriteKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findForceOverwriteKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isForceOverwriteKey addr i0 kn) U32.one)
                  i0
                  (findForceOverwriteKeyGo addr (afterLineEnd addr le n) n)))))
       (findForceOverwriteKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `force-overwrite` key exists (first non-comment match; W142 more77 presence).

**Honesty:** Lake greppable long-option stem `force-overwrite` — `CLI/Main.lean`
`| "--force-overwrite" =>` (key without leading `--`). Presence-only literal-byte
**exact length-15** key match before `=` — not value decode. Prefix peers
(`force-overwriteX`, `Force-overwrite`) must not match. Distinct from more76
len-14 `force-download` (`hasForceDownload`). Reverse peer `no-overwrite`
(`hasNoOverwrite`). -/
public unsafe def hasForceOverwrite (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findForceOverwriteKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Match key text `rehash` (six bytes). -/
public unsafe def isRehashKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len rehashkKeyLen)
    (bifU32 (U32.beq (loadAt addr off) rehashk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) rehashk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) rehashk2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) rehashk3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) rehashk4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) rehashk5)
                U32.one U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `rehash` key offset, or miss. -/
public unsafe def findRehashKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findRehashKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findRehashKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findRehashKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isRehashKey addr i0 kn) U32.one)
                  i0
                  (findRehashKeyGo addr (afterLineEnd addr le n) n)))))
       (findRehashKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `rehash` key exists (first non-comment match; W142 more77 presence).

**Honesty:** Lake greppable long-option stem `rehash` — `CLI/Main.lean`
`| "--rehash" =>` (key without leading `--`). Presence-only literal-byte
**exact length-6** key match before `=` — not value decode. Prefix peers
(`rehashX`, `Rehash`) must not match. No shipped reverse peer among
overwrite/trust flags. -/
public unsafe def hasRehash (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findRehashKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Match key text `keep-implied` (twelve bytes). -/
public unsafe def isKeepImpliedKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len keepimpliedkKeyLen)
    (bifU32 (U32.beq (loadAt addr off) keepimpliedk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) keepimpliedk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) keepimpliedk2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) keepimpliedk3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) keepimpliedk4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) keepimpliedk5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) keepimpliedk6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) keepimpliedk7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) keepimpliedk8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) keepimpliedk9)
                        (bifU32 (U32.beq (loadAt addr (USize.add off off10)) keepimpliedk10)
                          (bifU32 (U32.beq (loadAt addr (USize.add off off11)) keepimpliedk11)
                            U32.one U32.zero)
                          U32.zero)
                        U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `keep-implied` key offset, or miss. -/
public unsafe def findKeepImpliedKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findKeepImpliedKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findKeepImpliedKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findKeepImpliedKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isKeepImpliedKey addr i0 kn) U32.one)
                  i0
                  (findKeepImpliedKeyGo addr (afterLineEnd addr le n) n)))))
       (findKeepImpliedKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `keep-implied` key exists (first non-comment match; W143 more78 presence).

**Honesty:** Lake greppable long-option stem `keep-implied` — `CLI/Main.lean`
`| "--keep-implied" =>` (key without leading `--`). Presence-only literal-byte
**exact length-12** key match before `=` — not value decode. Prefix peers
(`keep-impliedX`, `Keep-implied`) must not match. Reverse peers
`keep-prefix` (`hasKeepPrefix`) / `keep-public` (`hasKeepPublic`). -/
public unsafe def hasKeepImplied (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findKeepImpliedKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Match key text `keep-prefix` (eleven bytes). -/
public unsafe def isKeepPrefixKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len keepprefixkKeyLen)
    (bifU32 (U32.beq (loadAt addr off) keepprefixk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) keepprefixk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) keepprefixk2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) keepprefixk3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) keepprefixk4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) keepprefixk5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) keepprefixk6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) keepprefixk7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) keepprefixk8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) keepprefixk9)
                        (bifU32 (U32.beq (loadAt addr (USize.add off off10)) keepprefixk10)
                          U32.one U32.zero)
                        U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `keep-prefix` key offset, or miss. -/
public unsafe def findKeepPrefixKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findKeepPrefixKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findKeepPrefixKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findKeepPrefixKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isKeepPrefixKey addr i0 kn) U32.one)
                  i0
                  (findKeepPrefixKeyGo addr (afterLineEnd addr le n) n)))))
       (findKeepPrefixKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `keep-prefix` key exists (first non-comment match; W143 more78 presence).

**Honesty:** Lake greppable long-option stem `keep-prefix` — `CLI/Main.lean`
`| "--keep-prefix" =>` (key without leading `--`). Presence-only literal-byte
**exact length-11** key match before `=` — not value decode. Prefix peers
(`keep-prefixX`, `Keep-prefix`) must not match. Reverse peers
`keep-implied` (`hasKeepImplied`) / `keep-public` (`hasKeepPublic`) — same
len-11 content peer with `keep-public`. -/
public unsafe def hasKeepPrefix (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findKeepPrefixKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Match key text `keep-public` (eleven bytes). -/
public unsafe def isKeepPublicKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len keeppublickKeyLen)
    (bifU32 (U32.beq (loadAt addr off) keeppublick0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) keeppublick1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) keeppublick2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) keeppublick3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) keeppublick4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) keeppublick5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) keeppublick6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) keeppublick7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) keeppublick8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) keeppublick9)
                        (bifU32 (U32.beq (loadAt addr (USize.add off off10)) keeppublick10)
                          U32.one U32.zero)
                        U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `keep-public` key offset, or miss. -/
public unsafe def findKeepPublicKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findKeepPublicKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findKeepPublicKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findKeepPublicKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isKeepPublicKey addr i0 kn) U32.one)
                  i0
                  (findKeepPublicKeyGo addr (afterLineEnd addr le n) n)))))
       (findKeepPublicKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `keep-public` key exists (first non-comment match; W143 more78 presence).

**Honesty:** Lake greppable long-option stem `keep-public` — `CLI/Main.lean`
`| "--keep-public" =>` (key without leading `--`). Presence-only literal-byte
**exact length-11** key match before `=` — not value decode. Prefix peers
(`keep-publicX`, `Keep-public`) must not match. Reverse peers
`keep-implied` (`hasKeepImplied`) / `keep-prefix` (`hasKeepPrefix`) — same
len-11 content peer with `keep-prefix`. -/
public unsafe def hasKeepPublic (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findKeepPublicKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Match key text `add-public` (ten bytes). -/
public unsafe def isAddPublicKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len addpublickKeyLen)
    (bifU32 (U32.beq (loadAt addr off) addpublick0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) addpublick1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) addpublick2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) addpublick3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) addpublick4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) addpublick5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) addpublick6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) addpublick7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) addpublick8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) addpublick9)
                        U32.one U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `add-public` key offset, or miss. -/
public unsafe def findAddPublicKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findAddPublicKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findAddPublicKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findAddPublicKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isAddPublicKey addr i0 kn) U32.one)
                  i0
                  (findAddPublicKeyGo addr (afterLineEnd addr le n) n)))))
       (findAddPublicKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `add-public` key exists (first non-comment match; W144 more79 presence).

**Honesty:** Lake greppable long-option stem `add-public` — `CLI/Main.lean`
`| "--add-public" =>` (key without leading `--`). Presence-only literal-byte
**exact length-10** key match before `=` — not value decode. Prefix peers
(`add-publicX`, `Add-public`) must not match. Reverse peers
`keep-public` (`hasKeepPublic` more78) / `gh-style` (`hasGhStyle`) /
`explain` (`hasExplain`). -/
public unsafe def hasAddPublic (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findAddPublicKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Match key text `gh-style` (eight bytes). -/
public unsafe def isGhStyleKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len ghstylekKeyLen)
    (bifU32 (U32.beq (loadAt addr off) ghstylek0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) ghstylek1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) ghstylek2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) ghstylek3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) ghstylek4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) ghstylek5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) ghstylek6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) ghstylek7)
                    U32.one U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `gh-style` key offset, or miss. -/
public unsafe def findGhStyleKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findGhStyleKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findGhStyleKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findGhStyleKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isGhStyleKey addr i0 kn) U32.one)
                  i0
                  (findGhStyleKeyGo addr (afterLineEnd addr le n) n)))))
       (findGhStyleKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `gh-style` key exists (first non-comment match; W144 more79 presence).

**Honesty:** Lake greppable long-option stem `gh-style` — `CLI/Main.lean`
`| "--gh-style" =>` (key without leading `--`). Presence-only literal-byte
**exact length-8** key match before `=` — not value decode. Prefix peers
(`gh-styleX`, `Gh-style`) must not match. Reverse peers
`add-public` (`hasAddPublic`) / `explain` (`hasExplain`) / more78
`keep-public` (`hasKeepPublic`). -/
public unsafe def hasGhStyle (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findGhStyleKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Match key text `explain` (seven bytes). -/
public unsafe def isExplainKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len explainkKeyLen)
    (bifU32 (U32.beq (loadAt addr off) explaink0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) explaink1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) explaink2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) explaink3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) explaink4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) explaink5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) explaink6)
                  U32.one U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `explain` key offset, or miss. -/
public unsafe def findExplainKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findExplainKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findExplainKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findExplainKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isExplainKey addr i0 kn) U32.one)
                  i0
                  (findExplainKeyGo addr (afterLineEnd addr le n) n)))))
       (findExplainKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `explain` key exists (first non-comment match; W144 more79 presence).

**Honesty:** Lake greppable long-option stem `explain` — `CLI/Main.lean`
`| "--explain" =>` (key without leading `--`). Presence-only literal-byte
**exact length-7** key match before `=` — not value decode. Prefix peers
(`explainX`, `Explain`) must not match. Reverse peers
`add-public` (`hasAddPublic`) / `gh-style` (`hasGhStyle`). -/
public unsafe def hasExplain (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findExplainKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Match key text `builtin-only` (twelve bytes). -/
public unsafe def isBuiltinOnlyKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len builtinonlykKeyLen)
    (bifU32 (U32.beq (loadAt addr off) builtinonlyk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) builtinonlyk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) builtinonlyk2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) builtinonlyk3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) builtinonlyk4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) builtinonlyk5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) builtinonlyk6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) builtinonlyk7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) builtinonlyk8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) builtinonlyk9)
                        (bifU32 (U32.beq (loadAt addr (USize.add off off10)) builtinonlyk10)
                          (bifU32 (U32.beq (loadAt addr (USize.add off off11)) builtinonlyk11)
                            U32.one U32.zero)
                          U32.zero)
                        U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `builtin-only` key offset, or miss. -/
public unsafe def findBuiltinOnlyKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findBuiltinOnlyKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findBuiltinOnlyKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findBuiltinOnlyKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isBuiltinOnlyKey addr i0 kn) U32.one)
                  i0
                  (findBuiltinOnlyKeyGo addr (afterLineEnd addr le n) n)))))
       (findBuiltinOnlyKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `builtin-only` key exists (first non-comment match; W145 more80 presence).

**Honesty:** Lake greppable long-option stem `builtin-only` — `CLI/Main.lean`
`| "--builtin-only" =>` (key without leading `--`). Presence-only literal-byte
**exact length-12** key match before `=` — not value decode. Prefix peers
(`builtin-onlyX`, `Builtin-only`) must not match. Reverse peers
`builtinLint` (`hasBuiltinLint` more20) / `lint-only` (`hasLintOnly`) /
`record-exceptions` (`hasRecordExceptions`) / bare `lint` (`hasLint` more64). -/
public unsafe def hasBuiltinOnly (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findBuiltinOnlyKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Match key text `lint-only` (nine bytes). -/
public unsafe def isLintOnlyKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len lintonlykKeyLen)
    (bifU32 (U32.beq (loadAt addr off) lintonlyk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) lintonlyk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) lintonlyk2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) lintonlyk3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) lintonlyk4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) lintonlyk5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) lintonlyk6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) lintonlyk7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) lintonlyk8)
                      U32.one U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `lint-only` key offset, or miss. -/
public unsafe def findLintOnlyKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findLintOnlyKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findLintOnlyKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findLintOnlyKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isLintOnlyKey addr i0 kn) U32.one)
                  i0
                  (findLintOnlyKeyGo addr (afterLineEnd addr le n) n)))))
       (findLintOnlyKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `lint-only` key exists (first non-comment match; W145 more80 presence).

**Honesty:** Lake greppable long-option stem `lint-only` — `CLI/Main.lean`
`| "--lint-only" =>` (key without leading `--`). Presence-only literal-byte
**exact length-9** key match before `=` — not value decode. Prefix peers
(`lint-onlyX`, `Lint-only`) must not match. Reverse peers
`lint` (`hasLint` more64) / `builtin-only` (`hasBuiltinOnly`) /
`record-exceptions` (`hasRecordExceptions`). -/
public unsafe def hasLintOnly (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findLintOnlyKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Match key text `record-exceptions` (seventeen bytes). -/
public unsafe def isRecordExceptionsKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len recordexceptionskKeyLen)
    (bifU32 (U32.beq (loadAt addr off) recordexceptionsk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) recordexceptionsk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) recordexceptionsk2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) recordexceptionsk3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) recordexceptionsk4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) recordexceptionsk5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) recordexceptionsk6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) recordexceptionsk7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) recordexceptionsk8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) recordexceptionsk9)
                        (bifU32 (U32.beq (loadAt addr (USize.add off off10)) recordexceptionsk10)
                          (bifU32 (U32.beq (loadAt addr (USize.add off off11)) recordexceptionsk11)
                            (bifU32 (U32.beq (loadAt addr (USize.add off off12)) recordexceptionsk12)
                              (bifU32 (U32.beq (loadAt addr (USize.add off off13)) recordexceptionsk13)
                                (bifU32 (U32.beq (loadAt addr (USize.add off off14)) recordexceptionsk14)
                                  (bifU32 (U32.beq (loadAt addr (USize.add off off15)) recordexceptionsk15)
                                    (bifU32 (U32.beq (loadAt addr (USize.add off off16)) recordexceptionsk16)
                                      U32.one U32.zero)
                                    U32.zero)
                                  U32.zero)
                                U32.zero)
                              U32.zero)
                            U32.zero)
                          U32.zero)
                        U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `record-exceptions` key offset, or miss. -/
public unsafe def findRecordExceptionsKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findRecordExceptionsKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findRecordExceptionsKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findRecordExceptionsKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isRecordExceptionsKey addr i0 kn) U32.one)
                  i0
                  (findRecordExceptionsKeyGo addr (afterLineEnd addr le n) n)))))
       (findRecordExceptionsKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `record-exceptions` key exists (first non-comment match; W145 more80 presence).

**Honesty:** Lake greppable long-option stem `record-exceptions` — `CLI/Main.lean`
`| "--record-exceptions" =>` (key without leading `--`). Presence-only literal-byte
**exact length-17** key match before `=` — not value decode. Prefix peers
(`record-exceptionsX`, `Record-exceptions`) must not match. Reverse peers
`builtin-only` (`hasBuiltinOnly`) / `lint-only` (`hasLintOnly`). -/
public unsafe def hasRecordExceptions (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findRecordExceptionsKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Match key text `keep-toolchain` (fourteen bytes). -/
public unsafe def isKeepToolchainKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len keeptoolchainkKeyLen)
    (bifU32 (U32.beq (loadAt addr off) keeptoolchaink0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) keeptoolchaink1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) keeptoolchaink2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) keeptoolchaink3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) keeptoolchaink4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) keeptoolchaink5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) keeptoolchaink6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) keeptoolchaink7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) keeptoolchaink8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) keeptoolchaink9)
                        (bifU32 (U32.beq (loadAt addr (USize.add off off10)) keeptoolchaink10)
                          (bifU32 (U32.beq (loadAt addr (USize.add off off11)) keeptoolchaink11)
                            (bifU32 (U32.beq (loadAt addr (USize.add off off12)) keeptoolchaink12)
                              (bifU32 (U32.beq (loadAt addr (USize.add off off13)) keeptoolchaink13)
                                U32.one U32.zero)
                              U32.zero)
                            U32.zero)
                          U32.zero)
                        U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `keep-toolchain` key offset, or miss. -/
public unsafe def findKeepToolchainKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findKeepToolchainKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findKeepToolchainKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findKeepToolchainKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isKeepToolchainKey addr i0 kn) U32.one)
                  i0
                  (findKeepToolchainKeyGo addr (afterLineEnd addr le n) n)))))
       (findKeepToolchainKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `keep-toolchain` key exists (first non-comment match; W146 more81 presence).

**Honesty:** Lake greppable long-option stem `keep-toolchain` — `CLI/Main.lean`
`| "--keep-toolchain" =>` (key without leading `--`). Presence-only literal-byte
**exact length-14** key match before `=` — not value decode. Prefix peers
(`keep-toolchainX`, `Keep-toolchain`) must not match. Reverse peers
`fixedToolchain` (`hasFixedToolchain` more19) / free `toolchain` /
`allow-empty` (`hasAllowEmpty`) / `max-revs` (`hasMaxRevs`). -/
public unsafe def hasKeepToolchain (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findKeepToolchainKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Match key text `allow-empty` (eleven bytes). -/
public unsafe def isAllowEmptyKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len allowemptykKeyLen)
    (bifU32 (U32.beq (loadAt addr off) allowemptyk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) allowemptyk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) allowemptyk2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) allowemptyk3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) allowemptyk4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) allowemptyk5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) allowemptyk6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) allowemptyk7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) allowemptyk8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) allowemptyk9)
                        (bifU32 (U32.beq (loadAt addr (USize.add off off10)) allowemptyk10)
                          U32.one U32.zero)
                        U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `allow-empty` key offset, or miss. -/
public unsafe def findAllowEmptyKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findAllowEmptyKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findAllowEmptyKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findAllowEmptyKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isAllowEmptyKey addr i0 kn) U32.one)
                  i0
                  (findAllowEmptyKeyGo addr (afterLineEnd addr le n) n)))))
       (findAllowEmptyKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if an `allow-empty` key exists (first non-comment match; W146 more81 presence).

**Honesty:** Lake greppable long-option stem `allow-empty` — `CLI/Main.lean`
`| "--allow-empty" =>` (key without leading `--`). Presence-only literal-byte
**exact length-11** key match before `=` — not value decode. Prefix peers
(`allow-emptyX`, `Allow-empty`) must not match. Reverse peers
`keep-toolchain` (`hasKeepToolchain`) / `max-revs` (`hasMaxRevs`) /
`update` (`hasUpdate` more65). -/
public unsafe def hasAllowEmpty (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findAllowEmptyKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Match key text `max-revs` (eight bytes). -/
public unsafe def isMaxRevsKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len maxrevskKeyLen)
    (bifU32 (U32.beq (loadAt addr off) maxrevsk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) maxrevsk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) maxrevsk2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) maxrevsk3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) maxrevsk4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) maxrevsk5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) maxrevsk6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) maxrevsk7)
                    U32.one U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `max-revs` key offset, or miss. -/
public unsafe def findMaxRevsKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findMaxRevsKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findMaxRevsKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findMaxRevsKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isMaxRevsKey addr i0 kn) U32.one)
                  i0
                  (findMaxRevsKeyGo addr (afterLineEnd addr le n) n)))))
       (findMaxRevsKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `max-revs` key exists (first non-comment match; W146 more81 presence).

**Honesty:** Lake greppable long-option stem `max-revs` — `CLI/Main.lean`
`| "--max-revs" =>` (key without leading `--`). Presence-only literal-byte
**exact length-8** key match before `=` — not value decode. Prefix peers
(`max-revsX`, `Max-revs`) must not match. Reverse peers
`rev` (`hasRev`) / `keep-toolchain` (`hasKeepToolchain`) /
`allow-empty` (`hasAllowEmpty`). -/
public unsafe def hasMaxRevs (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findMaxRevsKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Match key text `log-level` (nine bytes). -/
public unsafe def isLogLevelKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len loglevelkKeyLen)
    (bifU32 (U32.beq (loadAt addr off) loglevelk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) loglevelk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) loglevelk2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) loglevelk3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) loglevelk4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) loglevelk5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) loglevelk6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) loglevelk7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) loglevelk8)
                      U32.one U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `log-level` key offset, or miss. -/
public unsafe def findLogLevelKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findLogLevelKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findLogLevelKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findLogLevelKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isLogLevelKey addr i0 kn) U32.one)
                  i0
                  (findLogLevelKeyGo addr (afterLineEnd addr le n) n)))))
       (findLogLevelKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `log-level` key exists (first non-comment match; W147 more82 presence).

**Honesty:** Lake greppable long-option stem `log-level` — `CLI/Main.lean`
`| "--log-level" =>` (key without leading `--`). Presence-only literal-byte
**exact length-9** key match before `=` — not value decode. Prefix peers
(`log-levelX`, `Log-level`) must not match. Reverse peers
`fail-level` (`hasFailLevel`) / bare `ansi` (len-4; more85 `hasAnsi`) /
`no-ansi` (`hasNoAnsi`) / value token `info` (`hasInfo` more61). -/
public unsafe def hasLogLevel (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findLogLevelKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Match key text `fail-level` (ten bytes). -/
public unsafe def isFailLevelKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len faillevelkKeyLen)
    (bifU32 (U32.beq (loadAt addr off) faillevelk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) faillevelk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) faillevelk2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) faillevelk3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) faillevelk4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) faillevelk5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) faillevelk6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) faillevelk7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) faillevelk8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) faillevelk9)
                        U32.one U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `fail-level` key offset, or miss. -/
public unsafe def findFailLevelKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findFailLevelKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findFailLevelKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findFailLevelKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isFailLevelKey addr i0 kn) U32.one)
                  i0
                  (findFailLevelKeyGo addr (afterLineEnd addr le n) n)))))
       (findFailLevelKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `fail-level` key exists (first non-comment match; W147 more82 presence).

**Honesty:** Lake greppable long-option stem `fail-level` — `CLI/Main.lean`
`| "--fail-level" =>` (key without leading `--`). Presence-only literal-byte
**exact length-10** key match before `=` — not value decode. Prefix peers
(`fail-levelX`, `Fail-level`) must not match. Reverse peers
`log-level` (`hasLogLevel`) / `no-ansi` (`hasNoAnsi`) /
more85 `wfail` (`hasWfail`) / `iofail` (`hasIofail`). -/
public unsafe def hasFailLevel (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findFailLevelKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Match key text `no-ansi` (seven bytes). -/
public unsafe def isNoAnsiKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len noansikKeyLen)
    (bifU32 (U32.beq (loadAt addr off) noansik0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) noansik1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) noansik2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) noansik3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) noansik4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) noansik5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) noansik6)
                  U32.one U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `no-ansi` key offset, or miss. -/
public unsafe def findNoAnsiKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findNoAnsiKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findNoAnsiKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findNoAnsiKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isNoAnsiKey addr i0 kn) U32.one)
                  i0
                  (findNoAnsiKeyGo addr (afterLineEnd addr le n) n)))))
       (findNoAnsiKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `no-ansi` key exists (first non-comment match; W147 more82 presence).

**Honesty:** Lake greppable long-option stem `no-ansi` — `CLI/Main.lean`
`| "--no-ansi" =>` (key without leading `--`). Presence-only literal-byte
**exact length-7** key match before `=` — not value decode. Prefix peers
(`no-ansiX`, `No-ansi`) must not match. Reverse peers bare `ansi` (len-4;
more85 `hasAnsi`) / `log-level` (`hasLogLevel`) / `fail-level` (`hasFailLevel`). -/
public unsafe def hasNoAnsi (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findNoAnsiKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Match key text `reconfigure` (eleven bytes). -/
public unsafe def isReconfigureKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len reconfigurekKeyLen)
    (bifU32 (U32.beq (loadAt addr off) reconfigurek0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) reconfigurek1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) reconfigurek2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) reconfigurek3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) reconfigurek4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) reconfigurek5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) reconfigurek6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) reconfigurek7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) reconfigurek8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) reconfigurek9)
                        (bifU32 (U32.beq (loadAt addr (USize.add off off10)) reconfigurek10)
                          U32.one U32.zero)
                        U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `reconfigure` key offset, or miss. -/
public unsafe def findReconfigureKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findReconfigureKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findReconfigureKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findReconfigureKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isReconfigureKey addr i0 kn) U32.one)
                  i0
                  (findReconfigureKeyGo addr (afterLineEnd addr le n) n)))))
       (findReconfigureKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `reconfigure` key exists (first non-comment match; W148 more83 presence).

**Honesty:** Lake greppable long-option stem `reconfigure` — `CLI/Main.lean`
`| "--reconfigure" =>` (key without leading `--`; short `-R` exists separately).
Presence-only literal-byte **exact length-11** key match before `=` — not value
decode. Prefix peers (`reconfigureX`, `Reconfigure`) must not match. Reverse
peers `quiet` (`hasQuiet`) / `verbose` (`hasVerbose`) /
`update` (`hasUpdate` more65). -/
public unsafe def hasReconfigure (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findReconfigureKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Match key text `quiet` (five bytes). -/
public unsafe def isQuietKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len quietkKeyLen)
    (bifU32 (U32.beq (loadAt addr off) quietk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) quietk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) quietk2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) quietk3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) quietk4)
              U32.one U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `quiet` key offset, or miss. -/
public unsafe def findQuietKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findQuietKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findQuietKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findQuietKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isQuietKey addr i0 kn) U32.one)
                  i0
                  (findQuietKeyGo addr (afterLineEnd addr le n) n)))))
       (findQuietKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `quiet` key exists (first non-comment match; W148 more83 presence).

**Honesty:** Lake greppable long-option stem `quiet` — `CLI/Main.lean`
`| "--quiet" =>` (key without leading `--`). Presence-only literal-byte
**exact length-5** key match before `=` — not value decode. Prefix peers
(`quietX`, `Quiet`) must not match. Reverse peers `verbose` (`hasVerbose`) /
`reconfigure` (`hasReconfigure`). -/
public unsafe def hasQuiet (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findQuietKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Match key text `verbose` (seven bytes). -/
public unsafe def isVerboseKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len verbosekKeyLen)
    (bifU32 (U32.beq (loadAt addr off) verbosek0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) verbosek1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) verbosek2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) verbosek3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) verbosek4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) verbosek5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) verbosek6)
                  U32.one U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `verbose` key offset, or miss. -/
public unsafe def findVerboseKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findVerboseKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findVerboseKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findVerboseKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isVerboseKey addr i0 kn) U32.one)
                  i0
                  (findVerboseKeyGo addr (afterLineEnd addr le n) n)))))
       (findVerboseKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `verbose` key exists (first non-comment match; W148 more83 presence).

**Honesty:** Lake greppable long-option stem `verbose` — `CLI/Main.lean`
`| "--verbose" =>` (key without leading `--`). Presence-only literal-byte
**exact length-7** key match before `=` — not value decode. Prefix peers
(`verboseX`, `Verbose`) must not match. Reverse peers `quiet` (`hasQuiet`) /
`reconfigure` (`hasReconfigure`). -/
public unsafe def hasVerbose (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findVerboseKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Match key text `offline` (seven bytes). -/
public unsafe def isOfflineKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len offlinekKeyLen)
    (bifU32 (U32.beq (loadAt addr off) offlinek0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) offlinek1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) offlinek2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) offlinek3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) offlinek4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) offlinek5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) offlinek6)
                  U32.one U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `offline` key offset, or miss. -/
public unsafe def findOfflineKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findOfflineKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findOfflineKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findOfflineKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isOfflineKey addr i0 kn) U32.one)
                  i0
                  (findOfflineKeyGo addr (afterLineEnd addr le n) n)))))
       (findOfflineKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if an `offline` key exists (first non-comment match; W149 more84 presence).

**Honesty:** Lake greppable long-option stem `offline` — `CLI/Main.lean`
`| "--offline" =>` (key without leading `--`). Presence-only literal-byte
**exact length-7** key match before `=` — not value decode. Prefix peers
(`offlineX`, `Offline`) must not match. Reverse peers `platform` (`hasPlatform`) /
`toolchain` (`hasToolchain`). -/
public unsafe def hasOffline (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findOfflineKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Match key text `platform` (eight bytes). -/
public unsafe def isPlatformKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len platformkKeyLen)
    (bifU32 (U32.beq (loadAt addr off) platformk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) platformk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) platformk2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) platformk3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) platformk4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) platformk5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) platformk6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) platformk7)
                    U32.one U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `platform` key offset, or miss. -/
public unsafe def findPlatformKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findPlatformKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findPlatformKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findPlatformKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isPlatformKey addr i0 kn) U32.one)
                  i0
                  (findPlatformKeyGo addr (afterLineEnd addr le n) n)))))
       (findPlatformKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `platform` key exists (first non-comment match; W149 more84 presence).

**Honesty:** Lake greppable long-option stem `platform` — `CLI/Main.lean`
`| "--platform" =>` (key without leading `--`). Presence-only literal-byte
**exact length-8** key match before `=` — not value decode. Prefix peers
(`platformX`, `Platform`) must not match. Must miss longer more4 camel
`platformIndependent` (`hasPlatformIndependent`). Reverse peers
`offline` (`hasOffline`) / `toolchain` (`hasToolchain`). -/
public unsafe def hasPlatform (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findPlatformKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Match key text `toolchain` (nine bytes). -/
public unsafe def isToolchainKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len toolchainkKeyLen)
    (bifU32 (U32.beq (loadAt addr off) toolchaink0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) toolchaink1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) toolchaink2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) toolchaink3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) toolchaink4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) toolchaink5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) toolchaink6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) toolchaink7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) toolchaink8)
                      U32.one U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `toolchain` key offset, or miss. -/
public unsafe def findToolchainKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findToolchainKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findToolchainKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findToolchainKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isToolchainKey addr i0 kn) U32.one)
                  i0
                  (findToolchainKeyGo addr (afterLineEnd addr le n) n)))))
       (findToolchainKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `toolchain` key exists (first non-comment match; W149 more84 presence).

**Honesty:** Lake greppable long-option stem `toolchain` — `CLI/Main.lean`
`| "--toolchain" =>` (key without leading `--`). Presence-only literal-byte
**exact length-9** key match before `=` — not value decode. Prefix peers
(`toolchainX`, `Toolchain`) must not match. Must miss longer more81
`keep-toolchain` (`hasKeepToolchain`) and more19 camel `fixedToolchain`
(`hasFixedToolchain`). Reverse peers `offline` (`hasOffline`) /
`platform` (`hasPlatform`). -/
public unsafe def hasToolchain (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findToolchainKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Match key text `wfail` (five bytes). -/
public unsafe def isWfailKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len wfailkKeyLen)
    (bifU32 (U32.beq (loadAt addr off) wfailk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) wfailk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) wfailk2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) wfailk3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) wfailk4)
              U32.one U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `wfail` key offset, or miss. -/
public unsafe def findWfailKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findWfailKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findWfailKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findWfailKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isWfailKey addr i0 kn) U32.one)
                  i0
                  (findWfailKeyGo addr (afterLineEnd addr le n) n)))))
       (findWfailKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `wfail` key exists (first non-comment match; W150 more85 presence).

**Honesty:** Lake greppable long-option stem `wfail` — `CLI/Main.lean`
`| "--wfail" =>` (key without leading `--`). Presence-only literal-byte
**exact length-5** key match before `=` — not value decode. Prefix peers
(`wfailX`, `Wfail`) must not match. Reverse peers `iofail` (`hasIofail`) /
`ansi` (`hasAnsi`) / more82 `fail-level` (`hasFailLevel`). -/
public unsafe def hasWfail (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findWfailKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Match key text `iofail` (six bytes). -/
public unsafe def isIofailKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len iofailkKeyLen)
    (bifU32 (U32.beq (loadAt addr off) iofailk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) iofailk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) iofailk2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) iofailk3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) iofailk4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) iofailk5)
                U32.one U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `iofail` key offset, or miss. -/
public unsafe def findIofailKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findIofailKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findIofailKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findIofailKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isIofailKey addr i0 kn) U32.one)
                  i0
                  (findIofailKeyGo addr (afterLineEnd addr le n) n)))))
       (findIofailKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if an `iofail` key exists (first non-comment match; W150 more85 presence).

**Honesty:** Lake greppable long-option stem `iofail` — `CLI/Main.lean`
`| "--iofail" =>` (key without leading `--`). Presence-only literal-byte
**exact length-6** key match before `=` — not value decode. Prefix peers
(`iofailX`, `Iofail`) must not match. Reverse peers `wfail` (`hasWfail`) /
`ansi` (`hasAnsi`) / more82 `fail-level` (`hasFailLevel`). -/
public unsafe def hasIofail (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findIofailKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Match key text `ansi` (four bytes). -/
public unsafe def isAnsiKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len ansikKeyLen)
    (bifU32 (U32.beq (loadAt addr off) ansik0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) ansik1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) ansik2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) ansik3)
            U32.one U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `ansi` key offset, or miss. -/
public unsafe def findAnsiKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findAnsiKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findAnsiKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findAnsiKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isAnsiKey addr i0 kn) U32.one)
                  i0
                  (findAnsiKeyGo addr (afterLineEnd addr le n) n)))))
       (findAnsiKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if an `ansi` key exists (first non-comment match; W150 more85 presence).

**Honesty:** Lake greppable long-option stem `ansi` — `CLI/Main.lean`
`| "--ansi" =>` (key without leading `--`). Presence-only literal-byte
**exact length-4** key match before `=` — not value decode. Prefix peers
(`ansiX`, `Ansi`) must not match. Must miss longer more82 `no-ansi`
(`hasNoAnsi`). Reverse peers `no-ansi` (`hasNoAnsi`) /
`wfail` (`hasWfail`) / `iofail` (`hasIofail`). -/
public unsafe def hasAnsi (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findAnsiKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Match key text `force` (five bytes). -/
public unsafe def isForceKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len forcekKeyLen)
    (bifU32 (U32.beq (loadAt addr off) forcek0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) forcek1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) forcek2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) forcek3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) forcek4)
              U32.one U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `force` key offset, or miss. -/
public unsafe def findForceKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findForceKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findForceKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findForceKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isForceKey addr i0 kn) U32.one)
                  i0
                  (findForceKeyGo addr (afterLineEnd addr le n) n)))))
       (findForceKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `force` key exists (first non-comment match; W151 more86 presence).

**Honesty:** Lake greppable long-option stem `force` — `CLI/Main.lean`
`| "--force" =>` (key without leading `--`). Presence-only literal-byte
**exact length-5** key match before `=` — not value decode. Prefix peers
(`forceX`, `Force`) must not match. Must miss longer more76
`force-download` (`hasForceDownload`) and more77 `force-overwrite`
(`hasForceOverwrite`). Reverse peers `fix` (`hasFix`) /
`only` (`hasOnly`). -/
public unsafe def hasForce (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findForceKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Match key text `fix` (three bytes). -/
public unsafe def isFixKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len fixkKeyLen)
    (bifU32 (U32.beq (loadAt addr off) fixk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) fixk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) fixk2)
          U32.one U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `fix` key offset, or miss. -/
public unsafe def findFixKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findFixKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findFixKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findFixKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isFixKey addr i0 kn) U32.one)
                  i0
                  (findFixKeyGo addr (afterLineEnd addr le n) n)))))
       (findFixKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `fix` key exists (first non-comment match; W151 more86 presence).

**Honesty:** Lake greppable long-option stem `fix` — `CLI/Main.lean`
`| "--fix" =>` (key without leading `--`). Presence-only literal-byte
**exact length-3** key match before `=` — not value decode. Prefix peers
(`fixX`, `Fix`) must not match. Reverse peers `force` (`hasForce`) /
`only` (`hasOnly`). -/
public unsafe def hasFix (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findFixKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Match key text `only` (four bytes). -/
public unsafe def isOnlyKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len onlykKeyLen)
    (bifU32 (U32.beq (loadAt addr off) onlyk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) onlyk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) onlyk2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) onlyk3)
            U32.one U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `only` key offset, or miss. -/
public unsafe def findOnlyKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findOnlyKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findOnlyKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findOnlyKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isOnlyKey addr i0 kn) U32.one)
                  i0
                  (findOnlyKeyGo addr (afterLineEnd addr le n) n)))))
       (findOnlyKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if an `only` key exists (first non-comment match; W151 more86 presence).

**Honesty:** Lake greppable long-option stem `only` — `CLI/Main.lean`
`| "--only" =>` (key without leading `--`). Presence-only literal-byte
**exact length-4** key match before `=` — not value decode. Prefix peers
(`onlyX`, `Only`) must not match. Must miss longer more76 `mappings-only`
(`hasMappingsOnly`) / more80 `builtin-only` (`hasBuiltinOnly`) /
`lint-only` (`hasLintOnly`). Reverse peers `force` (`hasForce`) /
`fix` (`hasFix`). -/
public unsafe def hasOnly (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findOnlyKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Match key text `trace` (five bytes). -/
public unsafe def isTraceKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len tracekKeyLen)
    (bifU32 (U32.beq (loadAt addr off) tracek0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) tracek1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) tracek2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) tracek3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) tracek4)
              U32.one U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `trace` key offset, or miss. -/
public unsafe def findTraceKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findTraceKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findTraceKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findTraceKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isTraceKey addr i0 kn) U32.one)
                  i0
                  (findTraceKeyGo addr (afterLineEnd addr le n) n)))))
       (findTraceKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `trace` key exists (first non-comment match; W152 more87 presence).

**Honesty:** Lake greppable long-option stem `trace` — `CLI/Main.lean`
`| "--trace" =>` (key without leading `--`). Presence-only literal-byte
**exact length-5** key match before `=` — not value decode. Prefix peers
(`traceX`, `Trace`) must not match. Must miss longer more56
`traceArgs` (`hasTraceArgs` len-9). Reverse peers `old` (`hasOld`) /
`json` (`hasJson`). -/
public unsafe def hasTrace (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findTraceKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Match key text `old` (three bytes). -/
public unsafe def isOldKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len oldkKeyLen)
    (bifU32 (U32.beq (loadAt addr off) oldk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) oldk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) oldk2)
          U32.one U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `old` key offset, or miss. -/
public unsafe def findOldKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findOldKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findOldKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findOldKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isOldKey addr i0 kn) U32.one)
                  i0
                  (findOldKeyGo addr (afterLineEnd addr le n) n)))))
       (findOldKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if an `old` key exists (first non-comment match; W152 more87 presence).

**Honesty:** Lake greppable long-option stem `old` — `CLI/Main.lean`
`| "--old" =>` (key without leading `--`). Presence-only literal-byte
**exact length-3** key match before `=` — not value decode. Prefix peers
(`oldX`, `Old`) must not match. Reverse peers `trace` (`hasTrace`) /
`json` (`hasJson`). -/
public unsafe def hasOld (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findOldKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Match key text `json` (four bytes). -/
public unsafe def isJsonKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len jsonkKeyLen)
    (bifU32 (U32.beq (loadAt addr off) jsonk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) jsonk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) jsonk2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) jsonk3)
            U32.one U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `json` key offset, or miss. -/
public unsafe def findJsonKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findJsonKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findJsonKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findJsonKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isJsonKey addr i0 kn) U32.one)
                  i0
                  (findJsonKeyGo addr (afterLineEnd addr le n) n)))))
       (findJsonKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `json` key exists (first non-comment match; W152 more87 presence).

**Honesty:** Lake greppable long-option stem `json` — `CLI/Main.lean`
`| "--json" =>` (key without leading `--`). Presence-only literal-byte
**exact length-4** key match before `=` — not value decode. Prefix peers
(`jsonX`, `Json`) must not match. Reverse peers more36 `text` (`hasText`)
and trio `trace` (`hasTrace`) / `old` (`hasOld`). -/
public unsafe def hasJson (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findJsonKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Match key text `linters` (seven bytes). -/
public unsafe def isLintersKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len linterskKeyLen)
    (bifU32 (U32.beq (loadAt addr off) lintersk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) lintersk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) lintersk2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) lintersk3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) lintersk4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) lintersk5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) lintersk6)
                  U32.one U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `linters` key offset, or miss. -/
public unsafe def findLintersKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findLintersKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findLintersKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findLintersKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isLintersKey addr i0 kn) U32.one)
                  i0
                  (findLintersKeyGo addr (afterLineEnd addr le n) n)))))
       (findLintersKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `linters` key exists (first non-comment match; W153 more88 presence).

**Honesty:** Lake greppable long-option stem `linters` — `CLI/Main.lean`
`| "--linters" =>` (key without leading `--`). Presence-only literal-byte
**exact length-7** key match before `=` — not value decode. Prefix peers
(`lintersX`, `Linters`) must not match. Must miss shorter more64 `lint`
(`hasLint` len-4) / trio `linter` (`hasLinter` len-6) / more80 `lint-only`
(`hasLintOnly` len-9). Reverse peers `builtin-lint` (`hasBuiltinLintCli`) /
`linter` (`hasLinter`). -/
public unsafe def hasLinters (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findLintersKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Match key text `builtin-lint` (twelve bytes). -/
public unsafe def isBuiltinLintCliKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len builtinlintclikKeyLen)
    (bifU32 (U32.beq (loadAt addr off) builtinlintclik0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) builtinlintclik1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) builtinlintclik2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) builtinlintclik3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) builtinlintclik4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) builtinlintclik5)
                (bifU32 (U32.beq (loadAt addr (USize.add off off6)) builtinlintclik6)
                  (bifU32 (U32.beq (loadAt addr (USize.add off off7)) builtinlintclik7)
                    (bifU32 (U32.beq (loadAt addr (USize.add off off8)) builtinlintclik8)
                      (bifU32 (U32.beq (loadAt addr (USize.add off off9)) builtinlintclik9)
                        (bifU32 (U32.beq (loadAt addr (USize.add off off10)) builtinlintclik10)
                          (bifU32 (U32.beq (loadAt addr (USize.add off off11)) builtinlintclik11)
                            U32.one U32.zero)
                          U32.zero)
                        U32.zero)
                      U32.zero)
                    U32.zero)
                  U32.zero)
                U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `builtin-lint` key offset, or miss. -/
public unsafe def findBuiltinLintCliKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findBuiltinLintCliKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findBuiltinLintCliKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findBuiltinLintCliKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isBuiltinLintCliKey addr i0 kn) U32.one)
                  i0
                  (findBuiltinLintCliKeyGo addr (afterLineEnd addr le n) n)))))
       (findBuiltinLintCliKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `builtin-lint` key exists (first non-comment match; W153 more88 presence).

**Honesty:** Lake greppable long-option stem `builtin-lint` — `CLI/Main.lean`
`| "--builtin-lint" =>` (key without leading `--`). Presence-only literal-byte
**exact length-12** key match before `=` — not value decode. Named
`hasBuiltinLintCli` (`*Cli` like more74 `hasVersionTagsCli`) because more20
already has `hasBuiltinLint` for camel `builtinLint` (len-11). Prefix peers
(`builtin-lintX`, `Builtin-lint`) must not match. Must miss more20 camel
`builtinLint` / more80 `builtin-only` (also len-12 — content peer). Reverse
peers `linters` (`hasLinters`) / `linter` (`hasLinter`). -/
public unsafe def hasBuiltinLintCli (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findBuiltinLintCliKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

/-- Match key text `linter` (six bytes). -/
public unsafe def isLinterKey (addr : USize) (off : USize) (len : USize) : U32 :=
  bifU32 (USize.beq len linterkKeyLen)
    (bifU32 (U32.beq (loadAt addr off) linterk0)
      (bifU32 (U32.beq (loadAt addr (USize.add off off1)) linterk1)
        (bifU32 (U32.beq (loadAt addr (USize.add off off2)) linterk2)
          (bifU32 (U32.beq (loadAt addr (USize.add off off3)) linterk3)
            (bifU32 (U32.beq (loadAt addr (USize.add off off4)) linterk4)
              (bifU32 (U32.beq (loadAt addr (USize.add off off5)) linterk5)
                U32.one U32.zero)
              U32.zero)
            U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- Find first non-comment `linter` key offset, or miss. -/
public unsafe def findLinterKeyGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let i0 := skipWs addr i le
     bifUSize (USize.blt i0 le)
       (let c0 := loadAt addr i0
        bifUSize (U32.beq c0 cHash)
          (findLinterKeyGo addr (afterLineEnd addr le n) n)
          (bifUSize (U32.beq c0 cLBrack)
            (findLinterKeyGo addr (afterLineEnd addr le n) n)
            (let eq := findEq addr i0 le
             bifUSize (USize.beq eq USize.neg1)
               (findLinterKeyGo addr (afterLineEnd addr le n) n)
               (let keyEnd := rtrimWs addr i0 eq
                let kn := USize.sub keyEnd i0
                bifUSize (U32.beq (isLinterKey addr i0 kn) U32.one)
                  i0
                  (findLinterKeyGo addr (afterLineEnd addr le n) n)))))
       (findLinterKeyGo addr (afterLineEnd addr le n) n))
    USize.neg1

/-- `1` if a `linter` key exists (first non-comment match; W153 more88 presence).

**Honesty:** Lake greppable identity token `linter` — `CLI/Main.lean`
`parseLintersSpec` (`s := "linter" ++ s` when spec starts with `.`; key without
leading `--`). Presence-only literal-byte **exact length-6** key match before
`=` — not value decode. Prefix peers (`linterX`, `Linter`) must not match.
Must miss longer trio `linters` (`hasLinters` len-7) / shorter more64 `lint`
(`hasLint` len-4) / more80 `lint-only` (`hasLintOnly` len-9). Reverse peers
`linters` (`hasLinters`) / `builtin-lint` (`hasBuiltinLintCli`). -/
public unsafe def hasLinter (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq (findLinterKeyGo addr USize.zero n) USize.neg1)
    U32.zero U32.one

end Systems.TomlConfig
