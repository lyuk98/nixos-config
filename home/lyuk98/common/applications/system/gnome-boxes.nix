{
  pkgs,
  lib,
  config,
  ...
}:
{
  # Create option to enable GNOME Boxes
  options.applications.system.gnome-boxes.enable = lib.mkEnableOption "Boxes";

  config = lib.mkIf config.applications.system.gnome-boxes.enable {
    # Add packages
    home.packages = [ pkgs.gnome-boxes ];
  };
}
