{ lib, config, ... }:
{
  # Add .desktop files added by Home Manager to XDG_DATA_DIRS
  xdg.systemDirs.data = lib.mkDefault [
    "${config.home.homeDirectory}/.nix-profile/share/applications"
  ];
}
