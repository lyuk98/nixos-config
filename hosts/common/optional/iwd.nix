{ lib, config, ... }:
{
  # Enable iwd and disable wpa_supplicant
  networking.wireless.iwd.enable = true;
  networking.wireless.enable = lib.mkForce false;

  networking.networkmanager = {
    # Use iwd as wireless backend for NetworkManager
    wifi.backend = lib.mkIf config.networking.networkmanager.enable "iwd";

    settings = {
      device = {
        # Disable iwd's auto-connect mechanism and let NetworkManager initiate connections
        "wifi.iwd.autoconnect" = false;
      };
    };
  };
}
