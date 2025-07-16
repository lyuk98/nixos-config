{
  boot.loader = {
    # Allow GRUB to boot regardless of NVRAM state
    grub.efiInstallAsRemovable = true;

    # Prevent modification of EFI variables
    efi.canTouchEfiVariables = false;
  };
}
