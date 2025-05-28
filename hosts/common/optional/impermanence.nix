{ inputs, ... }:
{
  # Import impermanence NixOS module
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];
}
