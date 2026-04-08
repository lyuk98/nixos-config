{
  lib,
  config,
  ...
}:
{
  # Prevent replacement of running kernel images
  security.protectKernelImage = true;

  # Force page table isolation even on devices claimed to be safe from Meltdown
  security.forcePageTableIsolation = lib.mkDefault true;

  # Let unprivileged users create new namespaces
  # Enabling it is required for Podman to run containers in rootless mode
  security.unprivilegedUsernsClone = lib.mkDefault config.virtualisation.containers.enable;
}
