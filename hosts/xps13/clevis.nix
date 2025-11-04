{
  boot.initrd.clevis = {
    # Enable Clevis in initrd
    enable = true;

    # Unlock the device at boot using secret
    devices."zroot/root" = {
      secretFile = "${./root.jwe}";
    };
  };
}
