{
  pkgs,
  lib,
  config,
  ...
}:
{
  # Create option to enable KolourPaint
  options.applications.graphics.kolourpaint.enable = lib.mkEnableOption "KolourPaint";

  config = lib.mkIf config.applications.graphics.kolourpaint.enable {
    # Add packages
    home.packages = [ pkgs.kdePackages.kolourpaint ];
  };
}
