{
  pkgs,
  lib,
  config,
  ...
}:
{
  # Create option to enable MediaInfo
  options.applications.video.mediainfo.enable = lib.mkEnableOption "MediaInfo";

  config = lib.mkIf config.applications.video.mediainfo.enable {
    # Add packages
    home.packages = with pkgs; [
      mediainfo

      # Also add the GUI version
      mediainfo-gui
    ];
  };
}
