{ lib, ... }:
{
  # Enable firmware with a license allowing redistribution
  hardware.enableRedistributableFirmware = lib.mkDefault true;
}
