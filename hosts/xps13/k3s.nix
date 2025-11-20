{ lib, config, ... }:
let
  cfg = config.services.k3s;

  # Server configuration
  server = {
    address = config.networking.hostName;
    port = 6443;
  };
in
{
  options.services.k3s = {
    # Create options for CIDRs
    clusterCidr = lib.mkOption {
      default = [ "10.42.0.0/16" ];
      example = [ "10.1.0.0/16" ];
      description = "IPv4/IPv6 network CIDRs to use for pod IPs";
      type = lib.types.listOf lib.types.str;
    };
    serviceCidr = lib.mkOption {
      default = [ "10.43.0.0/16" ];
      example = [ "10.0.0.0/24" ];
      description = "IPv4/IPv6 network CIDRs to use for service";
      type = lib.types.listOf lib.types.str;
    };
  };

  config = {
    # Template for file to pass as --vpn-auth-file
    sops.templates."k3s/vpn-auth".content = builtins.concatStringsSep "," [
      "name=tailscale"
      "joinKey=${config.sops.placeholder.tailscale-auth-key}"
      "extraArgs=${builtins.concatStringsSep " " config.services.tailscale.extraUpFlags}"
    ];

    services.k3s = {
      # Enable K3s
      enable = true;

      # Run as a server
      role = "server";

      # Set the API server's address
      serverAddr = "https://${server.address}:${builtins.toString server.port}";

      # Set network CIDRs for pod IPs and service
      clusterCidr = [
        "10.42.0.0/16"
        "2001:cafe:42::/56"
      ];
      serviceCidr = [
        "10.43.0.0/16"
        "2001:cafe:43::/112"
      ];

      # Set extra flags for K3s
      extraFlags = [
        "--cluster-cidr ${builtins.concatStringsSep "," cfg.clusterCidr}"
        "--service-cidr ${builtins.concatStringsSep "," cfg.serviceCidr}"

        # Enable Tailscale integration
        "--vpn-auth-file ${config.sops.templates."k3s/vpn-auth".path}"

        # Enable IPv6 masquerading
        "--flannel-ipv6-masq"
      ];

      # Attempt to detect node system shutdown and terminate pods
      gracefulNodeShutdown.enable = true;

      # Specify container images
      images = [
        cfg.package.airgap-images
      ];
    };

    systemd.services.k3s = {
      # Add Tailscale to PATH for integration
      path = [
        config.services.tailscale.package
      ];

      # Start K3s after tailscaled
      after = [
        config.systemd.services.tailscaled.name
      ];
    };
  };
}
