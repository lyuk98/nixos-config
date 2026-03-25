{
  pkgs ? import <nixpkgs> { },
  ...
}:
{
  # Personal programs
  metadata-to-csv = pkgs.callPackage ./metadata-to-csv { };

  # Packages from the internet
  openvehiclediag = pkgs.callPackage ./openvehiclediag { };
  cbf-parser = pkgs.callPackage ./openvehiclediag { program = "cbf_parser"; };
}
