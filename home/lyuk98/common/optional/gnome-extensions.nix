{
  pkgs,
  lib,
  config,
  ...
}:
lib.mkIf config.programs.gnome-shell.enable {
  # Add personal selection of GNOME Shell extensions
  programs.gnome-shell.extensions = with pkgs.gnomeExtensions; [
    # Alphabetical App Grid
    {
      id = "AlphabeticalAppGrid@stuarthayhurst";
      package = alphabetical-app-grid;
    }
    # GSConnect
    {
      id = "gsconnect@andyholmes.github.io";
      package = gsconnect;
    }
    # Night Theme Switcher
    {
      id = "nightthemeswitcher@romainvigier.fr";
      package = night-theme-switcher;
    }
  ];
}
