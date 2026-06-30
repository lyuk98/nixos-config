{
  pkgs,
  lib,
  config,
  ...
}:
{
  virtualisation = {
    podman = {
      # Enable Podman
      enable = true;

      # Provide Docker compatibility
      dockerCompat = !config.virtualisation.docker.enable;
      dockerSocket.enable = true;

      # Enable DNS resolution in Podman
      defaultNetwork.settings.dns_enabled = true;

      autoPrune = {
        # Periodically prune Podman resources
        enable = true;
      };
    };
  };

  # Add docker-compose if Podman is enabled
  environment.systemPackages = lib.optional config.virtualisation.podman.enable pkgs.docker-compose;
}
