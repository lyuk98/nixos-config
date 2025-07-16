{
  # Define networks managed by systemd-networkd
  systemd.network.networks = {
    # Ethernet
    ens5 = {
      # Match interface `ens5`
      name = "ens5";

      # Add Cloudflare DNS
      dns = [
        "2606:4700:4700::1111#cloudflare-dns.com"
        "2606:4700:4700::1001#cloudflare-dns.com"
      ];

      # Enable DHCPv6
      DHCP = "ipv6";
    };
  };
}
