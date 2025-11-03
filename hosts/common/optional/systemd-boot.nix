{ lib, ... }:
{
  boot.loader = {
    # Do not display entries by default
    timeout = lib.mkDefault 0;

    systemd-boot = {
      enable = true;

      # Disallow edits to kernel cmdline
      editor = false;

      # Limit to 10 latest generations
      configurationLimit = lib.mkDefault 10;
    };

    # Allow modification of EFI variables
    efi.canTouchEfiVariables = lib.mkDefault true;
  };
}
