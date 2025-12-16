{ inputs, ... }:
{
  # Add overlay for nix-topology
  nixpkgs.overlays = [
    inputs.nix-topology.overlays.default
  ];

  # Import nix-topology
  imports = [
    inputs.nix-topology.nixosModules.default
  ];
}
