{
  pkgs,
  lib,
  config,
  ...
}:
let
  gnome =
    if (lib.strings.versionOlder lib.trivial.release "25.11") then
      # For Nixpkgs prior to 25.11
      config.services.xserver.desktopManager.gnome
    else
      # For Nixpkgs 25.11 and later
      config.services.desktopManager.gnome;
  cosmic = config.services.desktopManager.cosmic;
in
# Enable only if a desktop manager is enabled
lib.mkIf (gnome.enable || cosmic.enable) {
  # Provide fonts
  fonts.packages = with pkgs; [
    noto-fonts # Noto
    noto-fonts-cjk-sans # Noto Sans CJK
    noto-fonts-cjk-serif # Noto Serif CJK
    noto-fonts-color-emoji # Noto Color Emoji
    noto-fonts-monochrome-emoji # Noto Emoji
  ];
}
