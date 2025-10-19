{ inputs, ... }:
{
  imports = [ inputs.impermanence.nixosModules.impermanence ];

  environment.persistence = {
    # Enable persistence storage at /persist
    "/persist" = {
      # Prevent bind mounts from being shown as mounted storage
      hideMounts = true;

      # Create bind mounts for given directories
      directories = [
        "/var/lib/nixos"
        "/var/lib/systemd"
        "/var/log"
      ];
    };
  };

  # Require /persist for booting
  fileSystems."/persist".neededForBoot = true;
}
