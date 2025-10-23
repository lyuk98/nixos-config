{ lib, config, ... }:
{
  virtualisation = {
    libvirtd = {
      # Enable libvirt
      enable = true;

      # Set QEMU-related options
      qemu = {
        # Enable TPM emulation
        swtpm.enable = true;

        # Run QEMU as an unprivileged user
        runAsRoot = false;
      };
    };

    # Enable USB redirection
    spiceUSBRedirection.enable = true;
  };

  services = {
    # Enable spice-autorandr to automatically resize display
    spice-autorandr.enable = true;

    # Enable Spice guest agent
    spice-vdagentd.enable = true;

    # Enable WebDAV proxy daemon
    spice-webdavd.enable = true;
  };

  # Preserve persistent data
  preservation.preserveAt."/persist".directories =
    lib.optional config.virtualisation.libvirtd.enable "/var/lib/libvirt";
}
