{
  imports = [
    ./disable-root.nix
    ./firmware.nix
    ./hardened.nix
    ./immutable-users.nix
    ./locale.nix
    ./msedit.nix
    ./nix.nix
    ./sops.nix
    ./sudo.nix
    ./systemd-initrd.nix
    ./systemd-resolved.nix
    ./tailscale.nix
    ./zram.nix
  ];
}
