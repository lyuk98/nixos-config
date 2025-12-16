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
in
{
  topology.self = {
    # Create physical connections from this device to every other device in the tailnet
    interfaces.${tailscale0}.physicalConnections = lib.pipe (builtins.attrNames nixosConfigurations) [
      (builtins.filter (node: node != config.networking.hostName))
      (builtins.map (
        node: mkConnection node nixosConfigurations.${node}.config.services.tailscale.interfaceName
      ))
    ];
  };
}
