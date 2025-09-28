{ lib, ... }:
{
  imports = [
    ./bash.nix
    ./editorconfig.nix
    ./git.nix
    ./gnome-backgrounds.nix
    ./gnupg.nix
    ./home-manager.nix
    ./nix-index.nix
    ./nixpkgs.nix
    ./nur.nix
    ./pay-respects.nix
    ./xdg-autostart.nix
    ./xdg-base-dirs.nix
    ./xdg-desktop-portal.nix
    ./xdg-user-dirs.nix
  ];

  # Set default user details
  home = {
    username = lib.mkDefault "lyuk98";
    homeDirectory = lib.mkDefault "/home/lyuk98";
  };
}
