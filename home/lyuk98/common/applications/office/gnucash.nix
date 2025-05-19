{
  pkgs,
  lib,
  config,
  ...
}:
{
  # Create option to enable GnuCash
  options.applications.office.gnucash.enable = lib.mkEnableOption "GnuCash";

  config = lib.mkIf config.applications.office.gnucash.enable {
    # Add packages
    home.packages = [ pkgs.gnucash ];
  };
}
