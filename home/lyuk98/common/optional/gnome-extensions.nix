{ pkgs, ... }:
let
  # List of extensions
  packages = with pkgs.gnomeExtensions; [
    alphabetical-app-grid # Alphabetical App Grid
    gsconnect # GSConnect
    night-theme-switcher # Night Theme Switcher
  ];
in
{
  # Add personal selection of GNOME Shell extensions
  programs.gnome-shell.extensions = builtins.map (extension: { package = extension; }) packages;
}
