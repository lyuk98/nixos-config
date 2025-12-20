{ config, ... }: let
  inherit (config.lib.topology) mkInternet;
in {
  # Create entity representing the internet
  topology.nodes.internet = mkInternet {};
}
