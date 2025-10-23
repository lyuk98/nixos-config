{ lib, config, ... }:
{
  # Persist directory with saved Bluetooth connections
  preservation.preserveAt."/persist".directories =
    lib.optional config.hardware.bluetooth.enable "/var/lib/bluetooth";
}
