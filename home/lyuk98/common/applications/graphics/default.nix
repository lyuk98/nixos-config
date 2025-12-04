{
  lib,
  config,
  ...
}:
{
  imports = [
    ./friction.nix
    ./inkscape.nix
    ./kolourpaint.nix
  ];

  # Create option to enable all Graphical applications
  options.applications.graphics.enable = lib.mkEnableOption "all Graphical applications";

  # Enable all Graphical applications if enabled
  config.applications.graphics = lib.mkIf config.applications.graphics.enable {
    friction.enable = lib.mkDefault true;
    inkscape.enable = lib.mkDefault true;
    kolourpaint.enable = lib.mkDefault true;
  };
}
