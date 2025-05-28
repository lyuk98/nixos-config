{ inputs, ... }:
{
  # Import impermanence Home Manager module
  imports = [
    inputs.impermanence.homeManagerModules.impermanence
  ];
}
