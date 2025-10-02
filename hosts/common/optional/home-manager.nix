{ inputs, outputs, ... }:
{
  # Import Home Manager NixOS module
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    # Install profiles to /etc/profiles instead of ~/.nix-profile
    useUserPackages = true;

    # Pass flake inputs and outputs
    extraSpecialArgs = { inherit inputs outputs; };
  };
}
