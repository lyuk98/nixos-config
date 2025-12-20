{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.services.tailscale = {
    # Whether to enable Tailscale SSH
    ssh = lib.mkEnableOption "Tailscale SSH";

    # List of tags to apply to the device
    advertiseTags = lib.mkOption {
      default = [ ];
      example = [ "tag:server" ];
      description = "List of tags to apply to the device";
      type = lib.types.listOf lib.types.str;
    };

    # List of subnet routes to expose to the Tailscale network
    advertiseRoutes = lib.mkOption {
      default = [ ];
      example = [ "192.0.2.0/24" ];
      description = "List of subnet routes to expose to the Tailscale network";
      type = lib.types.listOf lib.types.str;
    };
  };

  config =
    let
      cfg = config.services.tailscale;
    in
    {
      services.tailscale = {
        # Enable Tailscale client daemon
        enable = true;

        # Override Tailscale package to skip tests that affect some kernel versions
        # https://github.com/NixOS/nixpkgs/issues/438765
        package =
          let
            version = config.boot.kernelPackages.kernel.version;
          in
          lib.mkIf (
            (lib.versionAtLeast version "6.6.102" && lib.versionOlder version "6.6.105")
            || (lib.versionAtLeast version "6.12.42" && lib.versionOlder version "6.12.46")
            || (lib.versionAtLeast version "6.16.1" && lib.versionOlder version "6.16.6")
          ) (pkgs.tailscale.overrideAttrs { doCheck = false; });

        extraDaemonFlags =
          # Encrypt state files with TPM for non-ephemeral hosts that have one
          (
            lib.optional (
              config.security.tpm2.enable && (config.services.tailscale.authKeyParameters.ephemeral != true)
            ) "--encrypt-state"
          );

        # Open firewall for the port to listen on
        openFirewall = true;

        # Set settings for client-related routing features by default
        useRoutingFeatures = lib.mkDefault "client";

        # Run tailscale up with extra flags
        extraUpFlags = [
          "--hostname=${config.networking.hostName}"
        ]
        # Enable Tailscale SSH
        ++ (lib.optional cfg.ssh "--ssh")
        # Advertise tags
        ++ (lib.optional (
          builtins.length cfg.advertiseTags != 0
        ) "--advertise-tags=${builtins.concatStringsSep "," cfg.advertiseTags}")
        # Advertise routes
        ++ (lib.optional (
          builtins.length cfg.advertiseRoutes != 0
        ) "--advertise-routes=${builtins.concatStringsSep "," cfg.advertiseRoutes}");
      };

      # Start tailscaled after a network connection is established
      # Nixpkgs already implements this for NetworkManager, but systemd-networkd is out of luck
      systemd.services.tailscaled.after = lib.mkIf (config.systemd.network.enable) [
        "systemd-networkd-wait-online.service"
      ];

      # Make state directory persistent
      preservation.preserveAt."/persist".directories = lib.optional config.services.tailscale.enable {
        directory = "/var/lib/tailscale";
        mode = "0700";
      };

      # Define Tailscale-related topology configurations
      topology =
        let
          inherit (config.lib.topology) getIcon;
          icon = getIcon "tailscale-light" "svg";
        in
        {
          # Define logical network
          networks.tailscale = {
            cidrv4 = "100.64.0.0/10";
            cidrv6 = "fd7a:115c:a1e0::/48";

            inherit icon;
            name = "Tailscale Network (Tailnet)";

            style = {
              primaryColor = "#797878";
              pattern = "solid";
            };
          };

          # Define information about the Tailscale network interface
          self.interfaces.${config.services.tailscale.interfaceName} = {
            type = "wireguard";
            inherit icon;

            # Indicate that this interface belongs to the tailnet
            network = config.topology.networks.tailscale.id;

            # Indicate that this is a virtual interface
            virtual = true;
          };
        };
    };
}
