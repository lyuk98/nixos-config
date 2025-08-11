{ lib, config, ... }:
{
  boot.loader = {
    grub = {
      # Enable GNU GRUB
      enable = true;

      # Add EFI support for GRUB
      efiSupport = lib.mkDefault true;

      # Limit to 10 configurations
      configurationLimit = lib.mkDefault 10;
    };

    # Allow modification of EFI variables if `efiInstallAsRemovable` is not enabled
    efi.canTouchEfiVariables = lib.mkDefault (!config.boot.loader.grub.efiInstallAsRemovable);
  };
}
