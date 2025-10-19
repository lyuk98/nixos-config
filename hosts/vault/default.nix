{ config, inputs, ... }:
{
  imports = [
    inputs.disko.nixosModules.disko

    ./digitalocean.nix
    ./disko-config.nix
    ./tailscale.nix
    ./vault.nix

    ../common/core

    ../common/optional/grub.nix
    ../common/optional/sshd.nix
    ../common/optional/systemd-networkd.nix
  ];

  # Get secrets from sops-nix
  sops.secrets = {
    machine-id = {
      sopsFile = ./secrets.yaml;
      neededForUsers = true;
    };
  };

  # Set the hostname
  networking.hostName = "vault";

  # Set local machine ID
  environment.etc = {
    machine-id = {
      mode = "0444";
      source = config.sops.secrets.machine-id.path;
    };
  };

  # Enable hardened profile
  profiles.hardened = true;

  # The platform where the NixOS configuration runs
  nixpkgs.hostPlatform = "x86_64-linux";

  # First version of NixOS installed in this system
  system.stateVersion = "25.05";
}
