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
    ../common/optional/persistence.nix
    ../common/optional/sshd.nix
    ../common/optional/systemd-networkd.nix
  ];

  environment.persistence."/persist" = {
    # Preserve machine ID
    files = [
      "/etc/machine-id"
    ];

    # Preserve secrets
    directories = [
      "/var/lib/secrets"
    ];
  };

  # Set the hostname
  networking.hostName = "museum";

  # Enable hardened profile
  profiles.hardened = true;

  # Set memory allocator to libc to avoid current build problems with scudo
  environment.memoryAllocator.provider = "libc";

  # The platform where the NixOS configuration runs
  nixpkgs.hostPlatform = "x86_64-linux";

  # First version of NixOS installed in this system
  system.stateVersion = "25.11";
}
