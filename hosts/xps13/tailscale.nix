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

    # Enable Tailscale SSH and advertise tags
    extraUpFlags = [
      "--advertise-tags=tag:webserver"
      "--ssh"
    ];

    # Prevent storing state and register as an ephemeral node
    extraDaemonFlags = [
      "--state=mem:"
    ];

    # Use routing features for both clients and servers
    useRoutingFeatures = "both";
  };
}
