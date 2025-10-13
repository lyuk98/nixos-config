{
  pkgs,
  lib,
  config,
  ...
}:
{
  # Create option to enable Bottles
  options.applications.utility.bottles.enable = lib.mkEnableOption "Bottles";

  config = lib.mkIf config.applications.utility.bottles.enable {
    # Add packages
    home.packages = [ pkgs.bottles ];
  };
}
