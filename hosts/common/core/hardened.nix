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
}
