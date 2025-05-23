{
  lib,
  config,
  ...
}:
{
  imports = [
    ./supertuxkart.nix
  ];

  # Create option to enable all Games
  options.applications.games.enable = lib.mkEnableOption "all Games";

  # Enable all Games if enabled
  config.applications.games = lib.mkIf config.applications.games.enable {
    supertuxkart.enable = lib.mkDefault true;
  };
}
