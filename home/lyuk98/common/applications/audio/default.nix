{
  lib,
  config,
  ...
}:
{
  imports = [
    ./ardour.nix
    ./guitarix.nix
  ];

  # Create option to enable all Audio applications
  options.applications.audio.enable = lib.mkEnableOption "all Audio applications";

  # Enable all Audio applications if enabled
  config.applications.audio = lib.mkIf config.applications.audio.enable {
    ardour.enable = lib.mkDefault true;
    guitarix.enable = lib.mkDefault true;
  };
}
