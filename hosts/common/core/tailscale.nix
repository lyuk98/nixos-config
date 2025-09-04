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

  # Make state directory persistent if Impermanence is enabled
  environment = lib.optionalAttrs (config.environment ? persistence) {
    persistence."/persist".directories = [ "/var/lib/tailscale" ];
  };

  # Apply patch to work around kernel regression
  # Fix taken from https://github.com/tailscale/tailscale/issues/16966#issuecomment-3246030218
  boot.kernelPatches =
    let
      version = config.boot.kernelPackages.kernel.version;
    in
    lib.mkIf
      (
        # Fix was not upstreamed yet
        (lib.versionAtLeast version "6.6.102" && lib.versionOlder version "6.7")
        || (lib.versionAtLeast version "6.12.42" && lib.versionOlder version "6.13")
        || (lib.versionAtLeast version "6.16.1" && lib.versionOlder version "6.17")
      )
      [
        # Fix the /proc/net/tcp seek issue
        # Impacts tailscale: https://github.com/tailscale/tailscale/issues/16966
        {
          name = "proc: fix missing pde_set_flags() for net proc files";
          patch = pkgs.fetchurl {
            name = "fix-missing-pde_set_flags-for-net-proc-files.patch";
            url = "https://patchwork.kernel.org/project/linux-fsdevel/patch/20250821105806.1453833-1-wangzijie1@honor.com/raw/";
            hash = "sha256-DbQ8FiRj65B28zP0xxg6LvW5ocEH8AHOqaRbYZOTDXg=";
          };
        }
      ];
}
