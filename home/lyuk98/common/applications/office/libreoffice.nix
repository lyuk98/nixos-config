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

        # Custom package containing necessary dictionaries
        config.programs.hunspell.dictionaries
      ];
  };
}
