{
  pkgs,
  lib,
  config,
  ...
}:
{
  # Create option to enable Friction
  options.applications.graphics.friction.enable = lib.mkEnableOption "Friction";

  config = lib.mkIf config.applications.graphics.friction.enable {
    # Add packages
    home.packages = [ pkgs.friction ];
  };
}
