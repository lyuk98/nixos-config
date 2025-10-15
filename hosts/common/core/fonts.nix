{
  pkgs,
  lib,
  config,
  ...
}:
# Enable only if a desktop manager is enabled
lib.mkIf config.services.desktopManager.gnome.enable {
  # Provide fonts
  fonts.packages = with pkgs; [
    noto-fonts # Noto
    noto-fonts-cjk-sans # Noto Sans CJK
    noto-fonts-cjk-serif # Noto Serif CJK
    noto-fonts-color-emoji # Noto Color Emoji
    noto-fonts-monochrome-emoji # Noto Emoji
  ];
}
