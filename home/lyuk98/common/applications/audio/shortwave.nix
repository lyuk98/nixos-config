{
  pkgs,
  lib,
  config,
  ...
}:
{
  # Create option to enable Shortwave
  options.applications.audio.shortwave.enable = lib.mkEnableOption "Shortwave";

  config = lib.mkIf config.applications.audio.shortwave.enable {
    # Add packages
    home.packages = [ pkgs.shortwave ];
  };
}
