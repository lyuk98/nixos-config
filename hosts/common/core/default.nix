{ inputs, ... }:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./disable-root.nix
    ./firmware.nix
    ./hardened.nix
    ./immutable-users.nix
    ./locale.nix
    ./nix.nix
    ./sops.nix
    ./sudo.nix
    ./systemd-initrd.nix
    ./systemd-resolved.nix
    ./tailscale.nix
    ./zram.nix
  ];
}
