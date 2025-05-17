{
  pkgs,
  lib,
  config,
  ...
}:
{
  # Create option to enable Signal Desktop
  options.applications.network.signal-desktop.enable = lib.mkEnableOption "Signal Desktop";

  config = lib.mkIf config.applications.network.signal-desktop.enable {
    # Add Signal Desktop
    home.packages = [ pkgs.signal-desktop ];

    # Enable automatic startup of the application
    xdg.autostart.entries = [ "${pkgs.signal-desktop}/share/applications/signal.desktop" ];
  };
}
