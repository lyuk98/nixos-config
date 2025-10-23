{ lib, config, ... }:
{
  # Enable fwupd
  services.fwupd.enable = true;

  # Preserve persistent data
  environment.persistence."/persist".directories =
    lib.optional config.services.fwupd.enable "/var/lib/fwupd";
}
