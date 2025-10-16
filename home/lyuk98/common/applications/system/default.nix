{
  lib,
  config,
  ...
}:
{
  imports = [
    ./gnome-boxes.nix
    ./mediawriter.nix
  ];

  # Create option to enable all System applications
  options.applications.system.enable = lib.mkEnableOption "all System applications";

  # Enable all System applications if enabled
  config.applications.system = lib.mkIf config.applications.system.enable {
    gnome-boxes.enable = lib.mkDefault true;
    mediawriter.enable = lib.mkDefault true;
  };
}
