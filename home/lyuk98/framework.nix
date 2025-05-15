{
  imports = [
    ./common/core

    ./common/optional/ardour.nix
    ./common/optional/discord.nix
    ./common/optional/ffmpeg-nonfree.nix
    ./common/optional/firefox.nix
    ./common/optional/flatpak.nix
    ./common/optional/fonts.nix
    ./common/optional/gh.nix
    ./common/optional/gnome-extensions.nix
    ./common/optional/proton-vpn.nix
    ./common/optional/signal-desktop.nix
    ./common/optional/vscode.nix
  ];

  # First version of Home Manager installed in this system
  home.stateVersion = "25.05";
}
