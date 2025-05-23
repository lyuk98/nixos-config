{
  pkgs,
  lib,
  config,
  ...
}:
{
  # Create option to enable SuperTuxKart
  options.applications.games.supertuxkart.enable = lib.mkEnableOption "SuperTuxKart";

  config = lib.mkIf config.applications.games.supertuxkart.enable {
    # Add packages
    home.packages = [ pkgs.superTuxKart ];
  };
}
