{
  pkgs,
  lib,
  config,
  ...
}:
{
  services.xserver.desktopManager.gnome =
    lib.mkIf config.services.xserver.desktopManager.gnome.enable
      {
        # Override GSettings for Mutter
        extraGSettingsOverridePackages = [ pkgs.mutter ];

        # Add experimental features to enable fractional scaling
        extraGSettingsOverrides = ''
          [org.gnome.mutter]
          experimental-features=['scale-monitor-framebuffer', 'xwayland-native-scaling']
        '';
      };
}
