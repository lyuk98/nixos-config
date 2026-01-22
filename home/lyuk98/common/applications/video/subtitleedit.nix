{
  pkgs,
  lib,
  config,
  ...
}:
{
  # Create option to enable Subtitle Edit
  options.applications.video.subtitleedit.enable = lib.mkEnableOption "Subtitle Edit";

  config = lib.mkIf config.applications.video.subtitleedit.enable {
    # Add packages
    home.packages = [ pkgs.subtitleedit ];
  };
}
