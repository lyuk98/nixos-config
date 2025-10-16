{
  lib,
  config,
  ...
}:
{
  imports = [
    ./mediawriter.nix
  ];

  # Create option to enable all System applications
  options.applications.system.enable = lib.mkEnableOption "all System applications";

  # Enable all System applications if enabled
  config.applications.system = lib.mkIf config.applications.system.enable {
    mediawriter.enable = lib.mkDefault true;
  };
}
