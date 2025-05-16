{
  pkgs,
  lib,
  config,
  ...
}:
{
  # Create option to enable Ardour
  options.applications.audio.ardour.enable = lib.mkEnableOption "Ardour";

  config = lib.mkIf config.applications.audio.ardour.enable {
    # Add packages
    home.packages = [
      pkgs.ardour
      pkgs.drumgizmo # DrumGizmo LV2 plugin
    ];

    # Enable guitarix by default
    applications.audio.guitarix.enable = lib.mkDefault true;
  };
}
