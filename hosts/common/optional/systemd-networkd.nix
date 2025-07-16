{
  # Disable dhcpcd to allow full management by networkd
  networking = {
    dhcpcd.enable = false;
    useDHCP = false;
  };

  # Enable systemd-networkd
  systemd.network.enable = true;
}
