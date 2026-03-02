{ inputs, ... }:
{
  imports = [ inputs.nixos-cli.nixosModules.nixos-cli ];

  programs.nixos-cli = {
    # Enable nixos-cli
    enable = true;
  };
}
