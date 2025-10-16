{ lib, config, ... }:
{
  # Import application declarations
  imports = [
    ./audio
    ./development
    ./games
    ./graphics
    ./network
    ./office
    ./system
    ./utility
    ./video
  ];

  # Create option to enable all applications
  options.applications.enable = lib.mkEnableOption "all applications";

  # Enable all categories if enabled
  config.applications = lib.mkIf config.applications.enable {
    audio.enable = lib.mkDefault true;
    development.enable = lib.mkDefault true;
    games.enable = lib.mkDefault true;
    graphics.enable = lib.mkDefault true;
    network.enable = lib.mkDefault true;
    office.enable = lib.mkDefault true;
    system.enable = lib.mkDefault true;
    utility.enable = lib.mkDefault true;
    video.enable = lib.mkDefault true;
  };
}
