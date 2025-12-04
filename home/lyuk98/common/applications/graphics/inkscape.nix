{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.applications.graphics.inkscape = {
    # Create option to enable Inkscape
    enable = lib.mkEnableOption "Inkscape";

    # Create option to enable extensions for Inkscape
    extensions.enable = lib.mkEnableOption "Inkscape" // {
      default = true;
    };
  };

  config = lib.mkIf config.applications.graphics.inkscape.enable {
    # Add packages
    home.packages = [
      (
        if config.applications.graphics.inkscape.extensions.enable then
          pkgs.inkscape-with-extensions
        else
          pkgs.inkscape
      )
    ];
  };
}
