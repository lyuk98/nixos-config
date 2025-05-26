{
  pkgs,
  lib,
  config,
  ...
}:
{
  # Create option to enable Kdenlive
  options.applications.video.kdenlive.enable = lib.mkEnableOption "Kdenlive";

  config = lib.mkIf config.applications.video.kdenlive.enable {
    # Add packages
    home.packages = [ pkgs.kdePackages.kdenlive ];
  };
}
