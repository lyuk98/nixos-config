{ config, ... }:
{
  # Get auth key via sops-nix
  sops.secrets.tailscale-auth-key = {
    sopsFile = ./secrets.yaml;
  };

  # Apply host-specific Tailscale configurations
  services.tailscale = {
    # Provide auth key to issue `tailscale up` with
    authKeyFile = config.sops.secrets.tailscale-auth-key.path;

    authKeyParameters = {
      # Register as an ephemeral node
      ephemeral = true;
    };

    # Enable Tailscale SSH
    ssh = true;

    # Advertise tags
    advertiseTags = [
      "tag:vault"
      "tag:webserver"
    ];

    # Use routing features for servers
    useRoutingFeatures = "server";
  };
}
