{ lib, config, ... }:
{
  # Import application declarations
  imports = [
    ./audio
    ./development
    ./network
  ];

  # Create option to enable all applications
  options.applications.enable = lib.mkEnableOption "all applications";

  # Enable all categories if enabled
  config.applications = lib.mkIf config.applications.enable {
    audio.enable = lib.mkDefault true;
    development.enable = lib.mkDefault true;
    network.enable = lib.mkDefault true;
  };
}
