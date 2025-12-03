{
  lib,
  config,
  modulesPath,
  ...
}:
{
  imports = [
    "${modulesPath}/virtualisation/digital-ocean-config.nix"
  ];

  virtualisation.digitalOcean = {
    # Prevent setting root password from DigitalOcean metadata
    setRootPassword = false;

    # Prevent setting SSH keys from DigitalOcean metadata
    setSshKeys = false;

    # Run kernel RNG seeding script from DigitalOcean vendor data
    seedEntropy = true;
  };

  services.cloud-init = {
    # Enable cloud-init service
    enable = true;

    # Allow operating filesystems
    ext4.enable = true;
    btrfs.enable = true;

    # Allow management of network interfaces using systemd-networkd
    network.enable = true;
  };

  # The following configuration adjusts the profile imported above

  # Do not attempt to grow tmpfs root
  boot.growPartition = lib.mkForce false;

  # Prevent main device from appearing in the list twice
  boot.loader.grub.devices = lib.mkForce [ config.disko.devices.disk.main.device ];
}
