{ lib, config, ... }:
let
  # Fallback DNS servers
  fallbackDns = [
    "1.1.1.1#cloudflare-dns.com"
    "8.8.8.8#dns.google"
    "9.9.9.9#dns.quad9.net"
    "1.0.0.1#cloudflare-dns.com"
    "8.8.4.4#dns.google"
    "149.112.112.112#dns.quad9.net"
    "2606:4700:4700::1111#cloudflare-dns.com"
    "2001:4860:4860::8888#dns.google"
    "2620:fe::fe#dns.quad9.net"
    "2606:4700:4700::1001#cloudflare-dns.com"
    "2001:4860:4860::8844#dns.google"
    "2620:fe::9#dns.quad9.net"
  ];

  # Use DNS-over-TLS whenever possible
  dnsovertls = "opportunistic";

  # Use DNSSEC whenever possible
  dnssec = "allow-downgrade";
in
{
  services.resolved = {
    # Enable systemd-resolved
    enable = true;
  }
  # Settings for systemd-resolved (Nixpkgs 26.05 and later)
  // (lib.optionalAttrs (lib.versionAtLeast lib.trivial.release "26.05") {
    settings.Resolve = {
      DNSOverTLS = dnsovertls;
      DNSSEC = dnssec;
      FallbackDNS = builtins.concatStringsSep " " fallbackDns;
    };
  })
  # Settings for systemd-resolved (Nixpkgs prior to 26.05)
  // (lib.optionalAttrs (lib.strings.versionOlder lib.trivial.release "26.05") {
    inherit fallbackDns dnsovertls dnssec;
  });

  # Let NetworkManager use systemd-resolved if it is enabled
  networking.networkmanager.dns = lib.mkIf config.networking.networkmanager.enable "systemd-resolved";
}
