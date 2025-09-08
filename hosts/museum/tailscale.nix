{
  # Apply host-specific Tailscale configurations
  services.tailscale = {
    # Provide auth key to issue `tailscale up` with
    authKeyFile = "/var/lib/secrets/tailscale-oauth-client-secret";

    # Enable Tailscale SSH and advertise tags
    extraUpFlags = [
      "--advertise-tags=tag:museum,tag:webserver"
      "--hostname=museum"
      "--ssh"
    ];

    # Use routing features for servers
    useRoutingFeatures = "server";
  };
}
