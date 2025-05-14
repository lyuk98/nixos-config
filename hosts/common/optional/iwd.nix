{ lib, config, ... }:
{
  # Enable iwd and disable wpa_supplicant
  networking.wireless.iwd.enable = true;
  networking.wireless.enable = lib.mkForce false;

  # Use iwd as wireless backend for NetworkManager
  networking.networkmanager.wifi.backend = lib.mkIf config.networking.networkmanager.enable "iwd";
}
