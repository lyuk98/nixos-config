{ pkgs, ... }:
{
  imports = [ ./xdg-autostart.nix ];

  # Add Proton VPN to available packages
  home.packages = [ pkgs.protonvpn-gui ];

  # Enable automatic startup of the application
  xdg.autostart.entries = [ "${pkgs.protonvpn-gui}/share/applications/protonvpn-app.desktop" ];
}
