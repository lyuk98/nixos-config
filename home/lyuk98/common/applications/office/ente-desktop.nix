{
  pkgs,
  lib,
  config,
  ...
}:
{
  # Create option to enable Ente Photos
  options.applications.office.ente-desktop.enable = lib.mkEnableOption "Ente Photos";

  config = lib.mkIf config.applications.office.ente-desktop.enable {
    # Add packages
    home.packages = [
      pkgs.ente-desktop

      # Also add Ente CLI
      pkgs.ente-cli
    ];
  };
}
