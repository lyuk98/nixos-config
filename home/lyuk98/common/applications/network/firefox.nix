{ lib, config, ... }:
{
  # Create option to enable Firefox
  options.applications.network.firefox.enable = lib.mkEnableOption "Firefox";

  config = lib.mkIf config.applications.network.firefox.enable {
    programs.firefox = {
      # Enable Firefox
      enable = true;

      # Add language packs
      languagePacks = [
        "en-GB"
        "en-US"
        "ko"
      ];
    };
  };
}
