{
  pkgs,
  lib,
  config,
  ...
}:
{
  # Create option to enable Anytype
  options.applications.office.anytype.enable = lib.mkEnableOption "Anytype";

  config = lib.mkIf config.applications.office.anytype.enable {
    # Add packages
    home.packages = [ pkgs.anytype ];
  };
}
