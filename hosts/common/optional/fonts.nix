{ pkgs, lib, ... }:
{
  # Provide fonts
  fonts.packages = with pkgs; [
    noto-fonts # Noto
    noto-fonts-cjk-sans # Noto Sans CJK
    noto-fonts-cjk-serif # Noto Serif CJK
    noto-fonts-color-emoji # Noto Emoji
  ];
}
