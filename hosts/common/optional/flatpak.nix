{ lib, config, ... }:
{
  # Enable Flatpak
  services.flatpak.enable = true;

  # Make data directory persistent
  preservation.preserveAt."/persist".directories =
    lib.optional config.services.flatpak.enable "/var/lib/flatpak";
}
