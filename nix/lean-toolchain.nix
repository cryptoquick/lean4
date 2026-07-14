# Shared hermetic stage0→stage1 Lean toolchain for flake consumers (no elan).
# Used by both classic Lean 4 (`pname = lean`) and Systems Lean (`pname = systems-lean`).
# Systems Lean features in-tree are opt-in at use time (compiler.freestanding / Lake freestanding);
# both packages build the same tree; meta and version label distinguish product identity.
#
# Never depends on ./ref CompCert or unfree pkgs.compcert.
{
  lib,
  stdenv,
  cmake,
  pkg-config,
  makeWrapper,
  gmp,
  libuv,
  openssl,
  cadical,
  fetchurl,
  fetchFromGitHub,
  src,
  # Product identity (semver-minor: additive Systems Lean surface; classic defaults unchanged).
  systemsLean ? false,
  version ? (if systemsLean then "4.33.0-systems" else "4.33.0"),
}:

let
  pname = if systemsLean then "systems-lean" else "lean";

  # Match root CMakeLists.txt GIT_TAG (and nixpkgs lean4).
  mimalloc-src = fetchFromGitHub {
    owner = "microsoft";
    repo = "mimalloc";
    tag = "v2.2.3";
    hash = "sha256-B0gngv16WFLBtrtG5NqA2m5e95bYVcQraeITcOX9A74=";
  };

  leantarVersion = "v0.1.20";
  leantarTarget =
    if stdenv.hostPlatform.isDarwin then
      (if stdenv.hostPlatform.isAarch64 then "aarch64" else "x86_64") + "-apple-darwin"
    else
      (if stdenv.hostPlatform.isAarch64 then "aarch64" else "x86_64") + "-unknown-linux-musl";

  leantarHashes = {
    "x86_64-unknown-linux-musl" = "sha256-F4mHhzHvvW61ZRXb5RH3g2VH3v3iN89eSynnjq7a64Y=";
    "aarch64-unknown-linux-musl" = "sha256-qoR2f6rRHELN0kYjIcfTZnqOF+PwP+1UMkJh60y12v8=";
    "aarch64-apple-darwin" = "sha256-hynWcDizREt3hgmhPCYYf1Er+Jx26/1KYHNwMAy6Pds=";
    "x86_64-apple-darwin" = "sha256-xP07T88V3uR0T04uSuTXeCa9aBTmCan5RF7aPzxqb/g=";
  };

  leantar = stdenv.mkDerivation {
    pname = "leantar";
    version = leantarVersion;
    src = fetchurl {
      url = "https://github.com/digama0/leangz/releases/download/${leantarVersion}/leantar-${leantarVersion}-${leantarTarget}.tar.gz";
      hash = leantarHashes.${leantarTarget};
    };
    dontConfigure = true;
    dontBuild = true;
    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin
      cp leantar $out/bin/leantar
      chmod +x $out/bin/leantar
      runHook postInstall
    '';
    meta = {
      description = "leantar (from leangz) for Lake package archives";
      license = lib.licenses.asl20;
      sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    };
  };

  classicMeta = {
    description = "Lean 4 toolchain (classic stage1; RC runtime)";
    longDescription = ''
      Installs stage1 `lean`, `lake`, `leanc`, and the stdlib with the classic Lean
      object runtime. Systems Lean freestanding/QTT support may be present in the
      sources but is off by default (semver-minor additive surface). Does not require
      CompCert or the optional ./ref submodule.
    '';
  };

  systemsMeta = {
    description = "Systems Lean: Lean 4 toolchain with freestanding / Systems Lean support";
    longDescription = ''
      Installs stage1 `lean`, `lake`, `leanc`, and the stdlib (including Systems Lean
      freestanding compiler support and the Systems product prelude when present in src).
      Built with mimalloc (same default as upstream Lean). Classic Lean APIs and defaults
      are unchanged; freestanding/QTT are opt-in. Does not require CompCert or ./ref to build.
    '';
  };

  pkgMeta = if systemsLean then systemsMeta else classicMeta;
in
stdenv.mkDerivation {
  inherit pname version src;

  nativeBuildInputs = [
    cmake
    pkg-config
    makeWrapper
    cadical
    leantar
  ];

  buildInputs = [
    gmp
    libuv
    openssl
  ];

  hardeningDisable = [ "all" ];

  postPatch = ''
    # Expects a git worktree; fails in the Nix sandbox.
    rm -rf src/lake/examples/git

    # Hermetic mimalloc: stages use LEAN_BINARY_DIR/../mimalloc/src/mimalloc/...
    miPat='${mimalloc-src}'
    for file in \
        stage0/src/CMakeLists.txt \
        stage0/src/runtime/CMakeLists.txt \
        src/CMakeLists.txt \
        src/runtime/CMakeLists.txt; do
      substituteInPlace "$file" \
        --replace-fail "\''${LEAN_BINARY_DIR}/../mimalloc/src/mimalloc" "$miPat"
    done
    substituteInPlace CMakeLists.txt \
      --replace-fail 'FetchContent_MakeAvailable(mimalloc)' \
        'message(STATUS "Nix: using vendored mimalloc at ${mimalloc-src}")'
  '';

  preConfigure = ''
    patchShebangs stage0/src/bin src/bin
  '';

  cmakeFlags = [
    "-DUSE_GITHASH=OFF"
    "-DINSTALL_LICENSE=OFF"
    "-DINSTALL_CADICAL=OFF"
    "-DINSTALL_LEANTAR=OFF"
    "-DUSE_MIMALLOC=ON"
    "-DCADICAL=${cadical}/bin/cadical"
    "-DLEANTAR=${leantar}/bin/leantar"
  ];

  enableParallelBuilding = true;

  postInstall = ''
    wrapProgram $out/bin/lean \
      --prefix PATH : ${lib.makeBinPath [ cadical leantar ]}
    if [ -x $out/bin/lake ]; then
      wrapProgram $out/bin/lake \
        --prefix PATH : ${lib.makeBinPath [ cadical leantar ]}
    fi
  '';

  meta = {
    inherit (pkgMeta) description longDescription;
    homepage = "https://lean-lang.org/";
    license = lib.licenses.asl20;
    mainProgram = "lean";
    platforms = lib.platforms.unix;
  };
}
