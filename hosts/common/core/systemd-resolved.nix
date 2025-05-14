{ lib, config, ... }:
{
  services.resolved = {
    # Enable systemd-resolved
    enable = true;

    # Use DNS-over-TLS whenever possible
    dnsovertls = "opportunistic";

    # Use DNSSEC whenever possible
    dnssec = "allow-downgrade";
  };

  # Let NetworkManager use systemd-resolved if it is enabled
  networking.networkmanager.dns = lib.mkIf config.networking.networkmanager.enable "systemd-resolved";
}
