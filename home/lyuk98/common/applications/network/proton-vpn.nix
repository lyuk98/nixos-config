{
  pkgs,
  lib,
  config,
  ...
}:
{
  # Create option to enable Proton VPN
  options.applications.network.proton-vpn.enable = lib.mkEnableOption "Proton VPN";

  config = lib.mkIf config.applications.network.proton-vpn.enable {
    # Add packages
    home.packages = [ pkgs.protonvpn-gui ];

    # Enable automatic startup of the application
    xdg.autostart.entries = [ "${pkgs.protonvpn-gui}/share/applications/protonvpn-app.desktop" ];
  };
}
