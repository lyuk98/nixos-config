{
  config,
  inputs,
  ...
}:
{
  imports = [
    inputs.disko.nixosModules.disko
    ./disko-config.nix
    ./grub.nix
    ./hardware-configuration.nix
    ./systemd-networkd.nix
    ./tailscale.nix
    ./vault.nix

    ../common/core

    ../common/optional/grub.nix
    ../common/optional/persistence.nix
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

  # Do not check for administrators' passwords or SSH keys
  # since Tailscale SSH can be used to access the system
  users.allowNoPasswordLogin = true;

  # Enable hardened profile
  profiles.hardened = true;

  # First version of NixOS installed in this system
  system.stateVersion = "25.05";
}
