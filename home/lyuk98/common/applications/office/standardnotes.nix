{
  pkgs,
  lib,
  config,
  ...
}:
{
  # Create option to enable Standard Notes
  options.applications.office.standardnotes.enable = lib.mkEnableOption "Standard Notes";

  config = lib.mkIf config.applications.office.standardnotes.enable {
    # Add packages
    home.packages = [ pkgs.standardnotes ];
  };
}
