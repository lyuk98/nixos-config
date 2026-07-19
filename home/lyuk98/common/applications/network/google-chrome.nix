{
  pkgs,
  lib,
  config,
  ...
}:
{
  # Create option to enable Google Chrome
  options.applications.network.google-chrome.enable = lib.mkEnableOption "Google Chrome";

  config = lib.mkIf config.applications.network.google-chrome.enable {
    # Add packages
    home.packages = [ pkgs.google-chrome ];
  };
}
