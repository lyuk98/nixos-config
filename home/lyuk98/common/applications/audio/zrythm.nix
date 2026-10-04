{
  pkgs,
  lib,
  config,
  ...
}:
{
  # Create option to enable Zrythm
  options.applications.audio.zrythm.enable = lib.mkEnableOption "Zrythm";

  # Disable application to avoid build problems
  # config = lib.mkIf config.applications.audio.zrythm.enable {
  #   # Add packages
  #   home.packages = [ pkgs.zrythm ];
  # };
}
