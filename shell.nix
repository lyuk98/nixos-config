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
      openssh
      sequoia-chameleon-gnupg
      sequoia-sq
      sops
      ssh-to-age
    ];

    NIX_CONFIG = "extra-experimental-features = ca-derivations flakes nix-command";
  };
}
