{
  imports = [
    ./common/core
    ./common/applications

    ./common/optional/custom-packages.nix
    ./common/optional/direnv.nix
    ./common/optional/ffmpeg-nonfree.nix
    ./common/optional/flatpak.nix
    ./common/optional/fonts.nix
    ./common/optional/fzf.nix
    ./common/optional/gh.nix
    ./common/optional/gnome-extensions.nix
    ./common/optional/gnome-shell.nix
    ./common/optional/msedit.nix
    ./common/optional/nix-output-monitor.nix
    ./common/optional/poppler-utils.nix
    ./common/optional/vault.nix
    ./common/optional/wl-clipboard.nix
  ];

  # Enable applications
  applications = {
    audio.enable = true;
    development.enable = true;
    games.enable = true;
    graphics.enable = true;
    network.enable = true;
    office.enable = true;
    video.enable = true;
  };

  # First version of Home Manager installed in this system
  home.stateVersion = "25.05";
}
