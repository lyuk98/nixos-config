{
  copyDesktopItems,
  fetchFromGitHub,
  lib,
  makeDesktopItem,
  makeWrapper,
  rustPlatform,
  stdenv,

  gtk3,
  libxkbcommon,
  pkg-config,
  vulkan-loader,
  wayland,
  xorg,

  program ? "openvehiclediag",
}:
let
  rootDir = {
    "openvehiclediag" = "app_rust";
    "cbf_parser" = "CBFParser";
    "common" = "common";
  };
  version = {
    "openvehiclediag" = "1.0.5";
    "cbf_parser" = "0.1.0";
    "common" = "0.1.0";
  };
  lockfile = {
    "openvehiclediag" = ./openvehiclediag.Cargo.lock;
    "cbf_parser" = ./cbf_parser.Cargo.lock;
    "common" = ./common.Cargo.lock;
  };

  description = {
    openvehiclediag = "Cross-platform ECU diagnostics and car hacking application";
    cbf_parser = "Parses Mercedes CBF Files into OpenVehicleDiag's JSON";
  };
  longDescription = {
    openvehiclediag = ''
      Open Vehicle Diagnostics (OVD) is a Rust-based open source vehicle ECU diagnostic
      platform that makes use of the J2534-2 protocol, as well as SocketCAN on Linux!
    '';
    cbf_parser = ''
      This program converts Daimler CBF Files to the OVD JSON Schema. It can also be used
      to translate all the German strings in the CBF to a language of your choosing!
    '';
  };
in
assert builtins.elem program [
  "openvehiclediag"
  "cbf_parser"
];
rustPlatform.buildRustPackage (
  finalAttrs:
  (
    {
      pname = program;
      version = version.${program};

      meta = {
        description = description.${program};
        longDescription = longDescription.${program};
        homepage = "https://github.com/rnd-ash/OpenVehicleDiag";
        changelog = "https://github.com/rnd-ash/OpenVehicleDiag/releases/tag/v${version.openvehiclediag}";
        license = lib.licenses.gpl3;
        mainProgram = program;
      };

      src = fetchFromGitHub {
        owner = "rnd-ash";
        repo = "OpenVehicleDiag";
        rev = "0d9a6bdf88e219a6b9375b45a638cc5acc2fbcf3";
        hash = "sha256-SNX8CloGyk+UhZakhX5BuDvefzlvSrwzMrhuNtcqqmY=";
      };

      postPatch = ''
        substituteInPlace ${rootDir.openvehiclediag}/Cargo.toml \
          --replace-fail 'branch="main"' 'rev="3d14767cd2f3a766cd2eb9accd041acbfde202b2"'

        substituteInPlace ${rootDir.openvehiclediag}/src/passthru.rs \
          --replace-warn 'extern "stdcall" ' ""
        substituteInPlace ${rootDir.openvehiclediag}/src/main.rs \
          --replace-warn 'mod cli_tests;' ""

        ln --symbolic --verbose ${lockfile.openvehiclediag} ${rootDir.openvehiclediag}/Cargo.lock
        ln --symbolic --verbose ${lockfile.cbf_parser} ${rootDir.cbf_parser}/Cargo.lock
        ln --symbolic --verbose ${lockfile.common} ${rootDir.common}/Cargo.lock
      '';

      cargoRoot = rootDir.${program};
      cargoLock.lockFile = lockfile.${program};
      buildAndTestSubdir = finalAttrs.cargoRoot;
    }
    // (lib.optionalAttrs (program == "openvehiclediag") {
      buildInputs = [
        gtk3
      ]
      ++ (lib.optionals stdenv.hostPlatform.isLinux [
        libxkbcommon
        vulkan-loader
        wayland
        xorg.libX11
        xorg.libxcb
        xorg.libXcursor
        xorg.libXi
        xorg.libXrandr
      ]);
      nativeBuildInputs = [
        copyDesktopItems
        makeWrapper
        pkg-config
      ];

      cargoDeps = rustPlatform.fetchCargoVendor {
        src = finalAttrs.src;
        postPatch = finalAttrs.postPatch;
        cargoRoot = finalAttrs.cargoRoot;

        hash = "sha256-SZXRA3N1WjnFH2IqRn+jl3NmjsDCWs/PZrRgh9/Du4Q=";
      };

      desktopItems = builtins.map makeDesktopItem [
        {
          name = program;
          desktopName = "Open Vehicle Diagnostics";
          comment = description.${program};
          icon = "rand_ash-${program}";
          exec = finalAttrs.pname;
          terminal = false;
          categories = [
            "Utility"
          ];
        }
      ];

      postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
        install -D --mode 0644 \
          app_rust/img/launcher.png \
          $out/share/icons/hicolor/256x256/apps/rand_ash-${program}.png

        wrapProgram $out/bin/${program} \
          --unset WAYLAND_DISPLAY \
          --set WINIT_UNIX_BACKEND x11
      '';

      postFixup =
        let
          rpath = lib.makeLibraryPath [
            libxkbcommon
            vulkan-loader
            wayland
            xorg.libX11
          ];
        in
        lib.optionalString stdenv.hostPlatform.isLinux ''
          patchelf $out/bin/.${program}-wrapped \
            --add-rpath ${rpath}
        '';
    })
  )
)
