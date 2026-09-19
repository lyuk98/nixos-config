{
  pkgs ? import <nixpkgs> { },
  ...
}:
{
  # Packages from the internet
  openvehiclediag = pkgs.callPackage ./openvehiclediag { };
  cbf-parser = pkgs.callPackage ./openvehiclediag { program = "cbf_parser"; };
}
