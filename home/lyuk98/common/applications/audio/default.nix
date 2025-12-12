{
  lib,
  config,
  ...
}:
{
  imports = [
    ./ardour.nix
    ./audacity.nix
    ./guitarix.nix
    ./hydrogen.nix
    ./kid3.nix
    ./picard.nix
    ./qpwgraph.nix
    ./shortwave.nix
    ./zrythm.nix
  ];

  # Create option to enable all Audio applications
  options.applications.audio.enable = lib.mkEnableOption "all Audio applications";

  # Enable all Audio applications if enabled
  config.applications.audio = lib.mkIf config.applications.audio.enable {
    ardour.enable = lib.mkDefault true;
    audacity.enable = lib.mkDefault true;
    guitarix.enable = lib.mkDefault true;
    hydrogen.enable = lib.mkDefault true;
    kid3.enable = lib.mkDefault true;
    picard.enable = lib.mkDefault true;
    qpwgraph.enable = lib.mkDefault true;
    shortwave.enable = lib.mkDefault true;
    zrythm.enable = lib.mkDefault true;
  };
}
