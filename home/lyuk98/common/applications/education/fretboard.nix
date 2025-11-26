{
  pkgs,
  lib,
  config,
  ...
}:
{
  # Create option to enable Fretboard
  options.applications.education.fretboard.enable = lib.mkEnableOption "Fretboard";

  config = lib.mkIf config.applications.education.fretboard.enable {
    # Add packages
    home.packages = [ pkgs.fretboard ];
  };
}
