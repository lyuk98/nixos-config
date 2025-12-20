{ inputs, ... }:
{
  # Add overlay for nix-topology
  nixpkgs.overlays = [
    inputs.nix-topology.overlays.default
  ];

  # Import nix-topology
  imports = [
    inputs.nix-topology.nixosModules.default

    ../optional/nix-topology/nodes/internet.nix
  ];

  # Define common functions
  lib.topology = {
    # Get icon from Dashboard Icons
    getIcon = brand: format: "${inputs.dashboard-icons}/${format}/${brand}.${format}";
  };
}
