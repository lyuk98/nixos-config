{
  pkgs,
  lib,
  config,
  ...
}:
{
  # Create option to enable Telegram Desktop
  options.applications.network.telegram-desktop.enable = lib.mkEnableOption "Telegram Desktop";

  config = lib.mkIf config.applications.network.telegram-desktop.enable {
    # Add Telegram Desktop
    home.packages = [ pkgs.telegram-desktop ];
  };
}
