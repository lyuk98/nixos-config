{
  disko.devices = {
    disk = {

      # Primary disk
      main = {
        type = "disk";
        device = "/dev/nvme0n1";

        # GPT (partition table) as the disk's content
        content = {
          type = "gpt";

          # List of partitions
          partitions = {
            # BIOS boot partition
            boot = {
              priority = 100;
              size = "1M";
              type = "EF02";
            };
            # EFI system partition
            esp = {
              priority = 100;
              end = "500M";
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
    };

    nodev = {
      # Impermanent root with tmpfs
      "/" = {
        fsType = "tmpfs";
        mountOptions = [
          "size=5%"
        ];
      };
    };
  };
}
