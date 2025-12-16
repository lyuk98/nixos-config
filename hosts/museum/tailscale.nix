{
  # Apply host-specific Tailscale configurations
  services.tailscale = {
    # Provide auth key to issue `tailscale up` with
    authKeyFile = "/var/lib/secrets/tailscale-oauth-client-secret";

    authKeyParameters = {
      # Register as an ephemeral node
      ephemeral = true;
    };

    # Enable Tailscale SSH
    ssh = true;

    # Advertise tags
    advertiseTags = [
      "tag:museum"
      "tag:webserver"
    ];

    # Use routing features for servers
    useRoutingFeatures = "server";
  };
}
