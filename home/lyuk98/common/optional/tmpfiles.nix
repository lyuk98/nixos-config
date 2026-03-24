{ config, ... }:
{
  # Add tmpfiles.d configuration
  systemd.user.tmpfiles.rules = [
    # Temporary files
    "D %t/temporary-files 0700 - - - -"
    "L \"${config.xdg.userDirs.documents}/Temporary files\" - - - - %t/temporary-files"

    # Mountpoint for iPhones mounted via ifuse
    "D %t/mountpoint/iPhone 0700 - - - -"
    "L ${config.xdg.userDirs.documents}/Mountpoint - - - - %t/mountpoint"
  ];
}
