{
  pkgs,
  lib,
  config,
  ...
}:
{
  # Create option to enable Collabora Office
  options.applications.office.collabora-desktop.enable = lib.mkEnableOption "Collabora Office";

  config = lib.mkIf config.applications.office.collabora-desktop.enable {
    # Add packages
    home.packages = with pkgs; [
      # Collabora Office for desktop
      collabora-desktop

      # Add Hunspell for spell checking
      hunspell

      # Custom package containing necessary dictionaries
      config.programs.hunspell.dictionaries
    ];
  };
}
