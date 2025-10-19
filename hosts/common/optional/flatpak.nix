{lib, config, ...}: {
  # Enable Flatpak
  services.flatpak.enable = true;

  # Make data directory persistent if Impermanence is enabled
  environment = lib.optionalAttrs (config.environment ? persistence) {
    persistence."/persist".directories = [ "/var/lib/flatpak" ];
  };
}
