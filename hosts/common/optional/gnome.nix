{ pkgs, ... }:
{
  imports = [
    ./flatpak.nix
    ./gstreamer.nix
    ./ibus.nix
  ];

  services.xserver = {
    # Enable X11 windowing system
    enable = true;

    # Enable GNOME desktop environment
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  # Enable core services for GNOME
  services.gnome = {
    # Enable core utilities
    core-apps.enable = true;

    # Enable GNOME Shell services
    core-shell.enable = true;

    # Enable essential services
    core-os-services.enable = true;

    # Enable core developer tools
    core-developer-tools.enable = true;

    # Enable GNOME games
    games.enable = true;
  };

  environment.systemPackages = [
    # Add themes for GTK3 applications
    pkgs.gnome-themes-extra

    # Enable HEIC image preview in Nautilus
    pkgs.libheif
    pkgs.libheif.out
  ];
  environment.pathsToLink = [ "share/thumbnailers" ];
}
