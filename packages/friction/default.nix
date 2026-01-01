{
  clang,
  clangStdenv,
  cmake,
  expat,
  fetchFromGitHub,
  ffmpeg_4-headless,
  fontconfig,
  freetype,
  harfbuzzFull,
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
  wrapQtAppsHook,
  zlib,
}:
clangStdenv.mkDerivation (finalAttrs: {
  pname = "friction";
  version = "1.0.0-rc.3";

  meta = {
    description = "Powerful and versatile motion graphics application";
    longDescription = ''
      Friction is a powerful and versatile motion graphics application that allows you to create
      vector and raster animations for web and video.
    '';
    homepage = "https://friction.graphics/";
    changelog = "https://friction.graphics/releases/friction-100-rc3.html";
    license = lib.licenses.gpl3;
    mainProgram = "friction";
  };

  src = fetchFromGitHub {
    owner = "friction2d";
    repo = "friction";
    rev = "a49cbb9cf6f687ebacbe7445b3b07e25ef73876c";
    fetchSubmodules = true;
    hash = "sha256-JUDqjUhtYiDll7bTNmYCItT8eQHS5pV38OwqiTXKowM=";
  };

  buildInputs = [
    expat
    ffmpeg_4-headless
    fontconfig
    freetype
    harfbuzzFull
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
    ninja
    pkg-config
    python3
    wrapQtAppsHook
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"

    "-DFRICTION_OFFICIAL_RELEASE=ON"
    "-DCUSTOM_BUILD=rc.3"

    "-DGIT_COMMIT=${builtins.substring 0 8 finalAttrs.src.rev}"
    "-DGIT_BRANCH=v${lib.versions.majorMinor finalAttrs.version}"

    "-DQSCINTILLA_INCLUDE_DIRS=${qscintilla}/include"
    "-DQSCINTILLA_LIBRARIES_DIRS=${qscintilla}/lib"
    "-DQSCINTILLA_LIBRARIES=qscintilla2_qt${lib.versions.major qtbase.version}"
  ];
})
