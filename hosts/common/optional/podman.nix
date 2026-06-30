{ config, ... }:
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
}
