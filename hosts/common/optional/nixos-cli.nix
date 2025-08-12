{ inputs, ... }:
{
  imports = [ inputs.nixos-cli.nixosModules.nixos-cli ];

  services.nixos-cli = {
    # Enable nixos-cli
    enable = true;
  };
}
