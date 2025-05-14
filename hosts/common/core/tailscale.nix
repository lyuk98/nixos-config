{ lib, ... }:
{
  services.tailscale = {
    # Enable Tailscale client daemon
    enable = true;

    # Open firewall for the port to listen on
    openFirewall = true;

    # Set settings for client-related routing features by default
    useRoutingFeatures = lib.mkDefault "client";
  };
}
