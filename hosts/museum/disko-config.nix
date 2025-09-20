{
  disko.devices = {
    disk = {

      # Primary disk
      main = {
        type = "disk";
        device = "/dev/nvme0n1";
        imageSize = "4G";

        # GPT (partition table) as the disk's content
        content = {
          type = "gpt";

          # List of partitions
          partitions = {
            # BIOS boot partition
            boot = {
              priority = 100;
              size = "2M";
              type = "EF02";
            };
            # EFI system partition
            esp = {
              priority = 100;
              end = "1G";
              type = "EF00";

              # FAT filesystem
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [
                  "defaults"
                  "umask=0077"
                ];
              };
            };

            # Root partition
            root = {
              size = "100%";

              # Btrfs filesystem
              content = {
                type = "btrfs";

                # Override existing partition
                extraArgs = [
                  "-f"
                ];

                # Subvolumes
                subvolumes = {
                  # /nix
                  "/nix" = {
                    mountOptions = [
                      "defaults"
                      "compress=zstd"
                      "x-systemd.growfs"
                    ];
                    mountpoint = "/nix";
                  };

                  # Persistent data
                  "/persist" = {
                    mountOptions = [
                      "defaults"
                      "compress=zstd"
                    ];
                    mountpoint = "/persist";
                  };

                  # Swap file
                  "/var/swap" = {
                    mountpoint = "/var/swap";
                    swap = {
                      swapfile.size = "1G";
                    };
                  };
                };
              };
            };
          };
        };
      };

      # Secondary storage for persistent data
      storage = {
        type = "disk";
        device = "/dev/nvme1n1";

        # GPT (partition table) as the disk's content
        content = {
          type = "gpt";

          # List of partitions
          partitions = {
            # PostgreSQL storage
            postgresql = {
              size = "100%";

              content = {
                type = "btrfs";

                mountpoint = "/var/lib/postgresql";
                mountOptions = [
                  "defaults"
                  "compress=zstd"
                ];
              };
            };
          };
        };
      };
    };

    nodev = {
      # Impermanent root with tmpfs
      "/" = {
        fsType = "tmpfs";
        mountOptions = [
          "defaults"
          "size=25%"
          "mode=0755"
        ];
      };
    };
  };
}
