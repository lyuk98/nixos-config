{ config, ... }:
{
  # Get auth key via sops-nix
  sops.secrets.tailscale-auth-key = {
    sopsFile = ./secrets.yaml;
  };

  # Apply host-specific Tailscale configurations
  services.tailscale = {
    # Provide auth key to issue `tailscale up` with
    # authKeyFile = config.sops.secrets.tailscale-auth-key.path;

    authKeyParameters = {
      # Register as an ephemeral node
      ephemeral = true;
    };

    # Enable Tailscale SSH and advertise tags and subnet routes
    extraUpFlags =
      let
        k3s = config.services.k3s;
        tags = [
          "webserver"
          "k3s-server"
          "k3s"
        ];
      in
      [
        "--accept-routes"
        "--advertise-routes=${builtins.concatStringsSep "," k3s.clusterCidr}"
        "--advertise-tags=${builtins.concatStringsSep "," (builtins.map (tag: "tag:${tag}") tags)}"
        "--ssh"
      ];

    # Use routing features for both clients and servers
    useRoutingFeatures = "both";
  };
}
