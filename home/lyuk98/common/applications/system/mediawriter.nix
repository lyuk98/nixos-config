{
  pkgs,
  lib,
  config,
  ...
}:
{
  # Create option to enable Fedora Media Writer
  options.applications.system.mediawriter.enable = lib.mkEnableOption "Fedora Media Writer";

  config = lib.mkIf config.applications.system.mediawriter.enable {
    # Add packages
    home.packages = [ pkgs.mediawriter ];
  };
}
