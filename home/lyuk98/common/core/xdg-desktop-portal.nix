{
  lib,
  config,
  osConfig,
  ...
}:
{
  # Proceed only if Home Manager can access the system configuration
  xdg.portal = lib.mkIf (!builtins.isNull osConfig) {
    # Enable XDG desktop integration if it is enabled system-wide
    enable = lib.mkDefault osConfig.xdg.portal.enable;

    # Use system's portal configurations by default
    config = lib.mkDefault osConfig.xdg.portal.config;
    configPackages = lib.mkDefault osConfig.xdg.portal.configPackages;

    # Use system's list of additional portals
    extraPortals = lib.mkDefault osConfig.xdg.portal.extraPortals;

    # Let xdg-open use the portal if it is enabled
    xdgOpenUsePortal = config.xdg.portal.enable;
  };
}
