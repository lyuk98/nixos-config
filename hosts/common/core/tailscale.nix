{
  pkgs,
  lib,
  config,
  ...
}:
{
  services.tailscale = {
    # Enable Tailscale client daemon
    enable = true;

    # Override Tailscale package to skip tests that affect some kernel versions
    # https://github.com/NixOS/nixpkgs/issues/438765
    package =
      let
        version = config.boot.kernelPackages.kernel.version;
      in
      lib.mkIf (
        (lib.versionAtLeast version "6.6.102" && lib.versionOlder version "6.6.105")
        || (lib.versionAtLeast version "6.12.42" && lib.versionOlder version "6.12.46")
        || (lib.versionAtLeast version "6.16.1" && lib.versionOlder version "6.16.6")
      ) (pkgs.tailscale.overrideAttrs { doCheck = false; });

    # Open firewall for the port to listen on
    openFirewall = true;

    # Set settings for client-related routing features by default
    useRoutingFeatures = lib.mkDefault "client";
  };

  # Start tailscaled after a network connection is established
  # Nixpkgs already implements this for NetworkManager, but systemd-networkd is out of luck
  systemd.services.tailscaled.after = lib.mkIf (config.systemd.network.enable) [
    "systemd-networkd-wait-online.service"
  ];

  # Make state directory persistent
  environment.persistence."/persist".directories =
    lib.optional config.services.tailscale.enable "/var/lib/tailscale";
}
