{ pkgs, ... }:
{
  # Add Signal Desktop
  home.packages = [ pkgs.signal-desktop ];

  # Enable automatic startup of the application
  xdg.autostart.entries = [ "${pkgs.signal-desktop}/share/applications/signal-desktop.desktop" ];
}
