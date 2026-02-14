{
  pkgs,
  lib,
  config,
  ...
}:
{
  # Create option to enable Stoat for Desktop
  options.applications.network.stoat-desktop.enable = lib.mkEnableOption "Stoat for Desktop";

  config = lib.mkIf config.applications.network.stoat-desktop.enable {
    # Add packages
    home.packages = [ pkgs.stoat-desktop ];
  };
}
