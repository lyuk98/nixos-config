{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.applications.network.signal-desktop = {
    # Create option to enable Signal Desktop
    enable = lib.mkEnableOption "Signal Desktop";

    # Create option to enable autostart for Signal Desktop
    autostart.enable = lib.mkOption {
      default = true;
      example = false;
      description = "Whether to enable autostart for Signal Desktop";
      type = lib.types.bool;
    };
  };

  config =
    let
      pkg = pkgs.signal-desktop;
    in
    lib.mkIf config.applications.network.signal-desktop.enable {
      # Add Signal Desktop
      home.packages = [ pkg ];

      # Enable automatic startup of the application
      xdg.autostart.entries = lib.optional config.applications.network.signal-desktop.autostart.enable "${pkg}/share/applications/signal.desktop";
    };
}
