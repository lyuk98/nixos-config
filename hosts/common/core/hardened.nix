{ lib, modulesPath, ... }:
{
  # Import hardened module
  imports = [ "${modulesPath}/profiles/hardened.nix" ];

  # Do not enable hardening by default
  profiles.hardened = lib.mkDefault false;
}
