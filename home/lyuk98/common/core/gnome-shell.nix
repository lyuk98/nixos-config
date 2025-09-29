{ lib, osConfig, ... }:
{
  # Enable GNOME Shell customisation if the desktop environment is enabled for the system
  programs.gnome-shell.enable = lib.mkIf (!builtins.isNull osConfig) (
    lib.mkDefault osConfig.services.desktopManager.gnome.enable
  );
}
