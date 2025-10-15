{
  pkgs,
  lib,
  config,
  ...
}:
{
  # Create option to enable LosslessCut
  options.applications.video.losslesscut.enable = lib.mkEnableOption "LosslessCut";

  config = lib.mkIf config.applications.video.losslesscut.enable {
    # Add packages
    home.packages = [ pkgs.losslesscut-bin ];
  };
}
