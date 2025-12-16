{
  outputs,
  lib,
  config,
  ...
}:
let
  # Helper function to create a connection
  inherit (config.lib.topology) mkConnection;

  # NixOS configurations
  inherit (outputs) nixosConfigurations;

  # Interface name for the tunnel traffic
  tailscale0 = config.services.tailscale.interfaceName;

  # List of tags of devices this host can reach
  reachableTags = [
    "tag:vault"
  ];
in
{
  topology.self = {
    # Create physical connections from this device to hosts with specific tags
    interfaces.${tailscale0}.physicalConnections = lib.pipe (builtins.attrNames nixosConfigurations) [
      (builtins.filter (node: node != config.networking.hostName))
      (builtins.filter (
        node:
        builtins.any (
          tag: builtins.elem tag nixosConfigurations.${node}.config.services.tailscale.advertiseTags
        ) reachableTags
      ))
      (builtins.map (
        node: mkConnection node nixosConfigurations.${node}.config.services.tailscale.interfaceName
      ))
    ];
  };
}
