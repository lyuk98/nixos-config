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
    # Night Theme Switcher
    {
      id = "nightthemeswitcher@romainvigier.fr";
      package = night-theme-switcher;
    }
  ];
}
