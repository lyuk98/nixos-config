{ lib, config, ... }:
{
  # Persist directory with saved Bluetooth connections
  environment.persistence."/persist".directories =
    lib.optional config.hardware.bluetooth.enable "/var/lib/bluetooth";
}
