{ lib, ... }:
{
  boot.loader = {
    grub = {
      # Enable GNU GRUB
      enable = true;

      # Add EFI support for GRUB
      efiSupport = lib.mkDefault true;
    };

    # Allow modification of EFI variables
    efi.canTouchEfiVariables = true;
  };
}
