{
  pkgs,
  lib,
  config,
  ...
}:
{
  # Create option to enable Eloquent
  options.applications.office.eloquent.enable = lib.mkEnableOption "Eloquent";

  config = lib.mkIf config.applications.office.eloquent.enable {
    # Add packages
    home.packages = [ pkgs.eloquent ];
  };
}
