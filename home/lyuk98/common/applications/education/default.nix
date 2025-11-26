{
  lib,
  config,
  ...
}:
{
  imports = [
    ./fretboard.nix
  ];

  # Create option to enable all Educational software
  options.applications.education.enable = lib.mkEnableOption "all Educational software";

  # Enable all Educational software if enabled
  config.applications.education = lib.mkIf config.applications.education.enable {
    fretboard.enable = lib.mkDefault true;
  };
}
