{
  lib,
  config,
  ...
}:
{
  # Disable loading kernel modules after system initialisation
  security.lockKernelModules = lib.mkDefault true;

  # Disable simultaneous multithreading
  security.allowSimultaneousMultithreading = false;

  # Use hardened memory allocator
  environment.memoryAllocator.provider = lib.mkDefault "scudo";
  environment.variables.SCUDO_OPTIONS = lib.mkIf (
    config.environment.memoryAllocator.provider == "scudo"
  ) "zero_contents=true";

  # Flush L1 data cache every time the hypervisor enters the guest
  security.virtualisation.flushL1DataCache = "always";
}
