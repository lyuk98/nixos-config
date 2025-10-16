{
  pkgs,
  lib,
  config,
  ...
}:
{
  # Create option to enable MusicBrainz Picard
  options.applications.audio.picard.enable = lib.mkEnableOption "MusicBrainz Picard";

  config = lib.mkIf config.applications.audio.picard.enable {
    # Add packages
    home.packages = [ pkgs.picard ];
  };
}
