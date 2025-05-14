{ pkgs, ... }:
{
  # Enable fontconfig configuration
  fonts.fontconfig.enable = true;

  # Enable fonts
  home.packages = with pkgs; [
    cascadia-code # Cascadia Code
    inter # Inter
    iosevka # Iosevka
    pretendard # Pretendard
    sarasa-gothic # Sarasa Gothic
  ];
}
