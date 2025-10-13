{
  pkgs,
  lib,
  config,
  ...
}:
{
  # Enable fonts
  home.packages =
    with pkgs;
    [
      cascadia-code # Cascadia Code
      inter # Inter
      iosevka # Iosevka
      noto-fonts # Noto
      noto-fonts-cjk-sans # Noto Sans CJK
      noto-fonts-cjk-serif # Noto Serif CJK
      noto-fonts-color-emoji # Noto Color Emoji
      noto-fonts-monochrome-emoji # Noto Emoji
      pretendard # Pretendard
    ]
    ++ (lib.optionals config.programs.gnome-shell.enable [
      adwaita-fonts # Adwaita fonts
      sarasa-gothic # Sarasa Gothic
    ]);

  fonts.fontconfig = {
    # Enable fontconfig configuration
    enable = true;

    # Set default fonts for the user
    defaultFonts =
      let
        # Default fonts
        default = {
          serif = [
            "Noto Serif"
            "Noto Serif CJK HK"
            "Noto Serif CJK JP"
            "Noto Serif CJK KR"
            "Noto Serif CJK SC"
            "Noto Serif CJK TC"
          ];
          sansSerif = [
            "Noto Sans"
            "Noto Sans CJK HK"
            "Noto Sans CJK JP"
            "Noto Sans CJK KR"
            "Noto Sans CJK SC"
            "Noto Sans CJK TC"
          ];
          monospace = [
            "Noto Sans Mono"
            "Noto Sans Mono CJK HK"
            "Noto Sans Mono CJK JP"
            "Noto Sans Mono CJK KR"
            "Noto Sans Mono CJK SC"
            "Noto Sans Mono CJK TC"
          ];
          emoji = [
            "Noto Color Emoji"
            "Noto Emoji"
          ];
        };

        # Default fonts for GNOME
        gnome = default // {
          sansSerif = [
            "Adwaita Sans"
            "Sarasa Gothic CL"
          ];
          monospace = [
            "Adwaita Mono"
            "Sarasa Fixed CL"
          ];
        };
      in
      # Use default fonts set for GNOME
      if config.programs.gnome-shell.enable then
        gnome
      # Use Noto fonts otherwise
      else
        default;
  };
}
