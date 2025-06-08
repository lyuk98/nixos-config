{
  pkgs,
  lib,
  config,
  ...
}:
{
  # Create option to enable LibreOffice
  options.applications.office.libreoffice.enable = lib.mkEnableOption "LibreOffice";

  config = lib.mkIf config.applications.office.libreoffice.enable {
    # Add packages
    home.packages =
      with pkgs;
      [
        # Add a latest stable version of LibreOffice
        libreoffice-fresh

        # Add Hunspell for spell checking
        hunspell
      ]
      ++ (with pkgs.hunspellDicts; [
        # Add dictionaries for Hunspell
        en_GB-ise
        en_US
        ko_KR
      ]);
  };
}
