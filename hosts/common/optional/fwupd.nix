{ lib, config, ... }:
{
  # Enable fwupd
  services.fwupd.enable = true;

  # Preserve persistent data
  preservation.preserveAt."/persist".directories =
    lib.optional config.services.fwupd.enable "/var/lib/fwupd";
}
