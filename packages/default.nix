{
  pkgs ? import <nixpkgs> { },
  ...
}:
{
  # Personal programs
  metadata-to-csv = pkgs.callPackage ./metadata-to-csv { };

  # Custom build environments
  hunspell-dicts = pkgs.callPackage ./hunspell-dicts { };

  # Packages from the internet
  friction = pkgs.libsForQt5.callPackage ./friction { };
  openvehiclediag = pkgs.callPackage ./openvehiclediag { };
  cbf-parser = pkgs.callPackage ./openvehiclediag { program = "cbf_parser"; };
}
