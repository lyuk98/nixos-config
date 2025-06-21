{
  pkgs,
  lib,
  config,
  ...
}:
{
  # Create option to enable Audacity
  options.applications.audio.audacity.enable = lib.mkEnableOption "Audacity";

  config = lib.mkIf config.applications.audio.audacity.enable {
    # Add packages
    home.packages = [ pkgs.audacity ];
  };
}
