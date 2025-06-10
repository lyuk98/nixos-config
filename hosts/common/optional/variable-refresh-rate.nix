{
  pkgs,
  lib,
  config,
  ...
}:
let
  # Override GSettings for Mutter
  extraGSettingsOverridePackages = [ pkgs.mutter ];

  # Add experimental features to enable variable refresh rate
  extraGSettingsOverrides = ''
    [org.gnome.mutter]
    experimental-features=['variable-refresh-rate']
  '';
in
{
  # For Nixpkgs prior to 25.11
  services.xserver = lib.mkIf (lib.strings.versionOlder lib.trivial.release "25.11") {
    desktopManager.gnome = lib.mkIf config.services.xserver.desktopManager.gnome.enable {
      extraGSettingsOverridePackages = extraGSettingsOverridePackages;
      extraGSettingsOverrides = extraGSettingsOverrides;
    };
  };

  # For Nixpkgs 25.11 and later
  services.desktopManager = lib.mkIf (lib.strings.versionAtLeast lib.trivial.release "25.11") {
    gnome = lib.mkIf config.services.desktopManager.gnome.enable {
      extraGSettingsOverridePackages = extraGSettingsOverridePackages;
      extraGSettingsOverrides = extraGSettingsOverrides;
    };
  };
}
