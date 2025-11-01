{ config, ... }:
let
  device = config.disko.devices.disk.main.content.partitions.zfs.device;
in
{
  boot.initrd.clevis = {
    # Enable Clevis in initrd
    enable = true;

    # TODO: specify secret file here
  };
}
