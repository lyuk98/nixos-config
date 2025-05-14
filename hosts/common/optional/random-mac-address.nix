{ lib, config, ... }:
{
  # Use randomised MAC address for each connection
  # Enable only if NetworkManager is enabled
  networking.networkmanager = lib.mkIf config.networking.networkmanager.enable {
    ethernet.macAddress = "random";
    wifi.macAddress = "random";
  };
}
