{
  clang,
  clangStdenv,
  cmake,
  expat,
  fetchFromGitHub,
  ffmpeg,
  fontconfig,
  freetype,
  harfbuzz,
  icu,
  lib,
  libjpeg,
  libpng,
  libsysprof-capture,
  libunwind,
  libwebp,
  ninja,
  pkg-config,
  python3,
  qscintilla,
  qt5,
  qtbase,
  stdenv,
  wrapQtAppsHook,
  zlib,
}:
let
  ffmpeg_4-headless =
    (ffmpeg.override {
      # Use latest version of FFmpeg 4.2
      version = "4.2.11";
      hash = "sha256-JQ1KWH09T7E2/TOGZG/okedOUQIO9bzJVwvnU7VL+b0=";

      # Disable unneeded dependencies from a headless setup
      ffmpegVariant = "headless";
      withHeadlessDeps = false;

      # Build only what is necessary
      buildAvcodec = true;
      buildAvdevice = true;
      buildAvfilter = true;
      buildAvformat = true;
      buildAvutil = true;
      buildSwresample = true;
      buildSwscale = true;

      withHardcodedTables = true;
      withNetwork = true;
      withPixelutils = true;
      withSafeBitstreamReader = true;

      buildFfmpeg = true;
    }).overrideAttrs
      (previousAttrs: {
        # Remove incompatible patch
        patches = builtins.filter (
          patch: patch.name != "unbreak-svt-av1-3.0.0.patch"
        ) previousAttrs.patches;

        # Remove nonexistent flags
        configureFlags =
          let
            nonexistentFlags = [
              "--disable-librav1e"
              "--disable-librist"
              "--disable-libsvtav1"
              "--disable-libuavs3d"
              "--disable-vulkan"
            ];
          in
          lib.lists.subtractLists nonexistentFlags previousAttrs.configureFlags;
      });
  gn = stdenv.mkDerivation {
    pname = "gn";
    version = "0-unstable-2025-08-25";

    src = fetchFromGitHub {
      owner = "friction2d";
      repo = "gn";
      rev = "70a9617aad7c09642457b6296d35638b97375dad";
      hash = "sha256-R/HL/a47swDCYM4iwAvcOkJa7qZb8hvsj9ULitgUWuk=";
    };

    nativeBuildInputs = [
      ninja
      python3
    ];

    configurePhase = ''
      python build/gen.py
    '';
    buildPhase = ''
      ninja --verbose -C out -j $NIX_BUILD_CORES gn
    '';
    installPhase = ''
      install --verbose -D out/gn "$out/bin/gn"
    '';

    meta = {
      description = "Meta-build system that generates build files for Ninja";
      mainProgram = "gn";
      homepage = "https://gn.googlesource.com/gn";
      license = lib.licenses.bsd3;
      platforms = lib.platforms.unix;
    };
  };
  harfbuzz-icu = harfbuzz.override { withIcu = true; };

  qtVersion = lib.versions.major qtbase.version;
in
clangStdenv.mkDerivation (finalAttrs: {
  pname = "friction";
  version = "1.0.0-rc.2";

  meta = {
    description = "Powerful and versatile motion graphics application";
    longDescription = ''
      Friction is a powerful and versatile motion graphics application that allows you to create
      vector and raster animations for web and video.
    '';
    homepage = "https://friction.graphics/";
    changelog = "https://friction.graphics/releases/friction-100-rc2.html";
    license = lib.licenses.gpl3;
    mainProgram = "friction";
  };

  src = fetchFromGitHub {
    owner = "friction2d";
    repo = "friction";
    rev = "e1e2c9a20a60bbaa9c0d618b88e37ce35185cd7c";
    fetchSubmodules = true;
    hash = "sha256-tmxzEfOy+eCe7K4Rv+bFNk0t3aD1n4iqAroB1li9vVM=";
  };

  patches = [
    ./gn-replace-executable.patch
  ];

  postPatch = ''
    substituteInPlace src/engine/skia/third_party/freetype2/BUILD.gn \
      --replace-fail /usr ${freetype.dev}
    substituteInPlace src/engine/skia/third_party/harfbuzz/BUILD.gn \
      --replace-fail /usr ${harfbuzz-icu.dev}
  '';

  buildInputs = [
    expat
    ffmpeg_4-headless
    fontconfig
    freetype
    harfbuzz-icu
    icu
    libjpeg
    libpng
    libsysprof-capture
    libunwind
    libwebp
    qscintilla
    qt5.qtdeclarative
    qt5.qtmultimedia
    qtbase
    zlib
  ];
  nativeBuildInputs = [
    clang
    cmake
    gn
    ninja
    pkg-config
    python3
    wrapQtAppsHook
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"

    "-DFRICTION_OFFICIAL_RELEASE=ON"
    "-DCUSTOM_BUILD=rc.2"

    "-DGIT_COMMIT=${builtins.substring 0 8 finalAttrs.src.rev}"
    "-DGIT_BRANCH=v${lib.versions.majorMinor finalAttrs.version}"

    "-DQSCINTILLA_INCLUDE_DIRS=${qscintilla}/include"
    "-DQSCINTILLA_LIBRARIES_DIRS=${qscintilla}/lib"
    "-DQSCINTILLA_LIBRARIES=qscintilla2_qt${qtVersion}"
  ];
})
