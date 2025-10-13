{ pkgs, ... }:
{
  # Enable fonts
  home.packages = with pkgs; [
    cascadia-code # Cascadia Code
    inter # Inter
    iosevka # Iosevka
    noto-fonts # Noto
    noto-fonts-cjk-serif # Noto Serif CJK
    noto-fonts-color-emoji # Noto Emoji
    pretendard # Pretendard
    sarasa-gothic # Sarasa Gothic
  ];

  fonts.fontconfig = {
    # Enable fontconfig configuration
    enable = true;

    # Set default fonts for the user
    defaultFonts = {
      serif = [
        "Noto Serif"
        "Noto Serif CJK HK"
        "Noto Serif CJK JP"
        "Noto Serif CJK KR"
        "Noto Serif CJK SC"
        "Noto Serif CJK TC"
      ];
      sansSerif = [
        "Inter"
        "Sarasa Gothic CL"
      ];
      monospace = [
        "Iosevka"
        "Sarasa Fixed CL"
      ];
      emoji = [
        "Noto Color Emoji"
      ];
    };
  };
}
