{ pkgs, ... }:
{
  # Disable tests for pkgs.python314Packages.patool until the merged PR reaches nixos-unstable
  # https://github.com/NixOS/nixpkgs/pull/540742
  nixpkgs.overlays = [
    (final: prev: {
      pythonPackagesExtensions = (prev.pythonPackagesExtensions or [ ]) ++ [
        (_: pyprev: {
          patool = pyprev.patool.overridePythonAttrs (_: {
            doCheck = false;
          });
        })
      ];
    })
  ];

  # Add file to environment
  home.packages = [ pkgs.file ];
}
