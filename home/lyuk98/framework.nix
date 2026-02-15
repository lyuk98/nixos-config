{
  imports = [
    ./common/core
    ./common/applications

    ./common/optional/android-translation-layer.nix
    ./common/optional/audio-plugins.nix
    ./common/optional/backblaze-b2.nix
    ./common/optional/custom-packages.nix
    ./common/optional/direnv.nix
    ./common/optional/ffmpeg-nonfree.nix
    ./common/optional/fontconfig.nix
    ./common/optional/fzf.nix
    ./common/optional/gh.nix
    ./common/optional/gnome-extensions.nix
    ./common/optional/kubectl.nix
    ./common/optional/nix-output-monitor.nix
    ./common/optional/poppler-utils.nix
    ./common/optional/proton-vpn.nix
    ./common/optional/talos.nix
    ./common/optional/vault.nix
    ./common/optional/wl-clipboard.nix
    ./common/optional/yt-dlp.nix
  ];

  # Enable applications
  applications = {
    audio.enable = true;
    development.enable = true;
    education.enable = true;
    games.enable = true;
    graphics.enable = true;
    network.enable = true;
    office.enable = true;
    system.enable = true;
    utility.enable = true;
    video.enable = true;
  };

  # Disable applications
  applications.network.firefox.enable = false;
  applications.network.proton-vpn.enable = false;

  # First version of Home Manager installed in this system
  home.stateVersion = "25.05";
}
