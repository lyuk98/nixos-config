{ pkgs, ... }:
{
  # Add packages
  home.packages = with pkgs; [
    # Talos Linux management
    talosctl

    # Tool for creating clusters declaratively
    talhelper
  ];
}
