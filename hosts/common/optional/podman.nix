{ config, ... }:
{
  virtualisation = {
    podman = {
      # Enable Podman
      enable = true;

      # Provide docker alias
      dockerCompat = !config.virtualisation.docker.enable;

      # Enable DNS resolution in Podman
      defaultNetwork.settings.dns_enabled = true;

      autoPrune = {
        # Periodically prune Podman resources
        enable = true;
      };
    };
  };
}
