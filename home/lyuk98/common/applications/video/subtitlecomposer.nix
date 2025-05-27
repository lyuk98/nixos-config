{
  pkgs,
  lib,
  config,
  ...
}:
{
  # Create option to enable Subtitle Composer
  options.applications.video.subtitlecomposer.enable = lib.mkEnableOption "Subtitle Composer";

  config = lib.mkIf config.applications.video.subtitlecomposer.enable {
    # Add packages
    home.packages = [ pkgs.subtitlecomposer ];
  };
}
