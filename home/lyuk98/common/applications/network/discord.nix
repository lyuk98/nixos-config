{
  pkgs,
  lib,
  config,
  ...
}:
{
  # Create option to enable Discord
  options.applications.network.discord.enable = lib.mkEnableOption "Discord";

  config = lib.mkIf config.applications.network.discord.enable {
    # Add packages
    home.packages = [ pkgs.discord ];
  };
}
