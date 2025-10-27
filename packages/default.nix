{
  pkgs ? import <nixpkgs> { },
  ...
}:
{
  # Personal programs
  metadata-to-csv = pkgs.callPackage ./metadata-to-csv { };

  # Packages from the internet
  friction = pkgs.libsForQt5.callPackage ./friction { };
}
