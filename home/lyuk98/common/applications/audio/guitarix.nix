{
  pkgs,
  lib,
  config,
  ...
}:
{
  # Create option to enable guitarix
  options.applications.audio.guitarix.enable = lib.mkEnableOption "guitarix";

  config = lib.mkIf config.applications.audio.guitarix.enable {
    # Add packages
    home.packages = [
      pkgs.guitarix
      pkgs.gxplugins-lv2 # Extra LV2 plugins to complement guitarix
    ];
  };
}
