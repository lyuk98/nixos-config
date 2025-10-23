{ inputs, ... }:
{
  imports = [
    inputs.disko.nixosModules.disko

    ./disko-config.nix
    ./ente.nix
    ./lightsail.nix
    ./systemd-networkd.nix
    ./tailscale.nix
    ./vault-agent.nix

    ../common/core

    ../common/optional/grub.nix
    ../common/optional/sshd.nix
    ../common/optional/systemd-networkd.nix
  ];

  # Preserve secrets
  preservation.preserveAt."/persist".directories = [
    {
      directory = "/var/lib/secrets";
      mode = "0751";
    }
  ];

  # Set the hostname
  networking.hostName = "museum";

  # Enable hardened profile
  profiles.hardened = true;

  # The platform where the NixOS configuration runs
  nixpkgs.hostPlatform = "x86_64-linux";

  # First version of NixOS installed in this system
  system.stateVersion = "25.11";
}
