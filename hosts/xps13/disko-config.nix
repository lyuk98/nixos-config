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

            # ZFS partition
            zfs = {
              size = "100%";

              content = {
                type = "zfs";
                pool = "zroot";
              };
            };
          };
        };
      };
    };

    zpool = {
      # The root zpool
      zroot = {
        type = "zpool";

        rootFsOptions = {
          # Do not mount root filesystem
          mountpoint = "none";

          # Enable transparent compression with zstd
          compression = "zstd";

          # Use ACL on datasets from this pool
          acltype = "posixacl";
          xattr = "sa";

          # Disable automatic snapshot
          "com.sun:auto-snapshot" = "false";
        };

        options = {
          # Force the pool to use 4,096 (2^12) byte sectors
          ashift = "12";
        };

        datasets = {
          # The root dataset
          "root" = {
            type = "zfs_fs";

            options = {
              # Use the default encryption method since OpenZFS 0.8.4
              encryption = "aes-256-gcm";

              # Use passphrase key format
              keyformat = "passphrase";
              keylocation = "prompt";

              # Do not mount this dataset
              mountpoint = "none";
            };
          };

          # Dataset for /nix
          "root/nix" = {
            type = "zfs_fs";

            options = {
              mountpoint = "/nix";
            };
            mountpoint = "/nix";
          };

          # Dataset for /persist
          "root/persist" = {
            type = "zfs_fs";

            options = {
              mountpoint = "/persist";
            };
            mountpoint = "/persist";
          };

          # Dataset for swap volume
          "root/swap" = {
            type = "zfs_volume";

            size = "16G";
            content = {
              type = "swap";
            };

            options = {
              # Set block size to system page size (4KiB)
              volblocksize = "4096";

              # Use zero-length encoding (ZLE) for compression
              compression = "zle";

              # Force data to be immediately flushed
              logbias = "throughput";
              sync = "always";

              # Prevent storing swap data in memory
              primarycache = "metadata";
              secondarycache = "none";

              # Disable automatic snapshot
              "com.sun:auto-snapshot" = "false";
            };
          };

          # Block device for Ceph
          "root/ceph" = {
            type = "zfs_volume";
            size = "32G";
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
          "size=50%"
          "mode=0755"
        ];
      };
    };
  };
}
