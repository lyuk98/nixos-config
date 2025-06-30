{ lib, config, ... }:
{
  services.tailscale = {
    # Enable Tailscale client daemon
    enable = true;

    # Open firewall for the port to listen on
    openFirewall = true;

    # Set settings for client-related routing features by default
    useRoutingFeatures = lib.mkDefault "client";
  };

  # Make state directory persistent if Impermanence is enabled
  environment = lib.optionalAttrs (config.environment ? persistence) {
    persistence."/persist".directories = [ "/var/lib/tailscale" ];
  };
}
