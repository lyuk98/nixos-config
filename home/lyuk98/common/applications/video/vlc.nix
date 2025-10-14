{
  pkgs,
  lib,
  config,
  ...
}:
{
  # Create option to enable VLC media player
  options.applications.video.vlc.enable = lib.mkEnableOption "VLC media player";

  config = lib.mkIf config.applications.video.vlc.enable {
    # Add packages
    home.packages = [ pkgs.vlc ];
  };
}
