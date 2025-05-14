{ lib, ... }:
{
  imports = [
    ./bash.nix
    ./git.nix
    ./gnupg.nix
    ./home-manager.nix
    ./nixpkgs.nix
    ./pay-respects.nix
    ./xdg-system-dirs.nix
  ];

  # Set default user details
  home = {
    username = lib.mkDefault "lyuk98";
    homeDirectory = lib.mkDefault "/home/lyuk98";
  };
}
