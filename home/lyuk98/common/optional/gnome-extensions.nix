{
  pkgs,
  lib,
  config,
  ...
}:
let
  # List of extensions
  packages = with pkgs.gnomeExtensions; [
    alphabetical-app-grid # Alphabetical App Grid
    gsconnect # GSConnect
    night-theme-switcher # Night Theme Switcher
  ];
in
lib.mkIf config.programs.gnome-shell.enable {
  # Add personal selection of GNOME Shell extensions
  programs.gnome-shell.extensions = builtins.map (extension: { package = extension; }) packages;

  # Modify dconf settings
  dconf.settings = {
    "org/gnome/shell" = {
      # Enable user extensions
      disable-user-extensions = false;

      # Enable added extensions
      enabled-extensions = [
        "AlphabeticalAppGrid@stuarthayhurst"
        "gsconnect@andyholmes.github.io"
        "nightthemeswitcher@romainvigier.fr"
      ];
    };
  };
}
