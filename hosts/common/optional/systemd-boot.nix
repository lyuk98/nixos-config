{
  boot.loader = {
    systemd-boot = {
      enable = true;

      # Disallow edits to kernel cmdline
      editor = false;
    };

    # Allow modification of EFI variables
    efi.canTouchEfiVariables = true;
  };
}
