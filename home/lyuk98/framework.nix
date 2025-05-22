{
  imports = [
    ./common/core
    ./common/applications

    ./common/optional/ffmpeg-nonfree.nix
    ./common/optional/flatpak.nix
    ./common/optional/fonts.nix
    ./common/optional/gh.nix
    ./common/optional/gnome-extensions.nix
    ./common/optional/gnome-shell.nix
  ];

  # Enable applications
  applications = {
    audio.enable = true;
    development.enable = true;
    graphics.enable = true;
    network.enable = true;
    office.enable = true;
  };

  # First version of Home Manager installed in this system
  home.stateVersion = "25.05";
}
