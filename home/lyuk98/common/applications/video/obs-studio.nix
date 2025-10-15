{ lib, config, ... }:
{
  # Create option to enable OBS Studio
  options.applications.video.obs-studio.enable = lib.mkEnableOption "OBS Studio";

  config = lib.mkIf config.applications.video.obs-studio.enable {
    programs.obs-studio = {
      # Enable OBS Studio
      enable = true;
    };
  };
}
