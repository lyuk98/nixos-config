{
  pkgs,
  lib,
  config,
  ...
}:
{
  # Create option to enable Ladybird
  options.applications.network.ladybird.enable = lib.mkEnableOption "Ladybird";

  config = lib.mkIf config.applications.network.ladybird.enable {
    # Add packages
    home.packages = [ pkgs.ladybird ];
  };
}
