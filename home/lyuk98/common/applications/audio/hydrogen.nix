{
  pkgs,
  lib,
  config,
  ...
}:
{
  # Create option to enable Hydrogen
  options.applications.audio.hydrogen.enable = lib.mkEnableOption "Hydrogen";

  config = lib.mkIf config.applications.audio.hydrogen.enable {
    # Add packages
    home.packages = [ pkgs.hydrogen ];
  };
}
