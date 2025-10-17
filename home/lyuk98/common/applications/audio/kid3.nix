{
  pkgs,
  lib,
  config,
  ...
}:
{
  # Create option to enable Kid3
  options.applications.audio.kid3.enable = lib.mkEnableOption "Kid3";

  config = lib.mkIf config.applications.audio.kid3.enable {
    # Add packages
    home.packages = [ pkgs.kid3 ];
  };
}
