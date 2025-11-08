{
  config,
  inputs,
  lib,
  ...
}:
{
  # Import NixOS module for preservation
  imports = [
    inputs.preservation.nixosModules.preservation
  ];

  preservation = {
    # Enable the preservation module
    enable = lib.mkDefault true;

    preserveAt."/persist" = {
      # Set mount options for directories under /persist
      commonMountOptions = [
        # Prevent bind mounts from being shown as mounted storage
        "x-gvfs-hide"
        "x-gdu.hide"
      ];

      # Preserve system directories
      directories = [
        "/var/lib/systemd"
        "/var/log"
        {
          directory = "/var/lib/nixos";
          inInitrd = true;
        }
      ];

      # Preserve system files
      files = lib.optional (!config.environment.etc ? machine-id) {
        file = "/etc/machine-id";
        inInitrd = true;
      };
    };
  };

  # Disable systemd unit that is not relevant in this setup
  systemd.suppressedSystemUnits = [ "systemd-machine-id-commit.service" ];

  # Require /persist for booting if preservation is enabled
  fileSystems = lib.mkIf config.preservation.enable {
    "/persist".neededForBoot = true;
  };
}
