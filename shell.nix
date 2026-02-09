{
  pkgs ? import <nixpkgs> { },
  ...
}:
{
  # Define default development environment
  default = pkgs.mkShell {
    nativeBuildInputs = with pkgs; [
      nix
      home-manager

      git

      age
      gnupg
      openssh
      sops
      ssh-to-age

      talosctl
      talhelper
    ];

    NIX_CONFIG = "extra-experimental-features = ca-derivations flakes nix-command";
  };
}
