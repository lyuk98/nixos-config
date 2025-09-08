{ lib, modulesPath, ... }:
{
  imports = [
    "${modulesPath}/virtualisation/amazon-image.nix"
  ];

  # Undo options set by the imported module
  boot.growPartition = lib.mkForce false;
  virtualisation.amazon-init.enable = false;

  # Mark this instance as EFI-compatible
  ec2.efi = true;

  # Allow GRUB to boot regardless of NVRAM state
  boot.loader.grub.efiInstallAsRemovable = true;
}
