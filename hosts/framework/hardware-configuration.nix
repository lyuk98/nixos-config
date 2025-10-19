{
  # Encrypted devices to be opened from initrd
  boot.initrd.luks.devices = {
    luks-95582132-bd92-4355-8afc-f17636c73869 = {
      device = "/dev/disk/by-uuid/95582132-bd92-4355-8afc-f17636c73869";

      # Allow TRIM requests to the storage
      allowDiscards = true;

      # Bypass internal read and write workqueues
      bypassWorkqueues = true;
    };
  };

  # File systems to be mounted
  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-uuid/090C-E895";
      fsType = "vfat";
    };

    "/" = {
      device = "none";
      fsType = "tmpfs";
      options = [
        "defaults"
        "size=50%"
        "mode=755"
      ];
    };

    "/home" = {
      device = "/dev/mapper/luks-95582132-bd92-4355-8afc-f17636c73869";
      fsType = "btrfs";
      options = [
        "defaults"
        "subvol=home"
        "compress=zstd"
      ];
    };

    "/nix" = {
      device = "/dev/mapper/luks-95582132-bd92-4355-8afc-f17636c73869";
      fsType = "btrfs";
      options = [
        "defaults"
        "subvol=nix"
        "compress=zstd"
      ];
    };

    "/persist" = {
      device = "/dev/mapper/luks-95582132-bd92-4355-8afc-f17636c73869";
      fsType = "btrfs";
      options = [
        "defaults"
        "subvol=persist"
        "compress=zstd"
      ];
    };
  };

  # Use swap file
  swapDevices = [
    {
      device = "/var/swap/swapfile";

      # Set swap file size in megabytes
      size = 65536;

      # Follow default discard policy by swapon(8)
      discardPolicy = "both";
    }
  ];

  # Enable Framework Laptop 13-specific audio enhancement
  hardware.framework.laptop13.audioEnhancement.enable = true;

  # The platform where the NixOS configuration runs (needed for flakes)
  nixpkgs.hostPlatform = "x86_64-linux";
}
