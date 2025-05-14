{ lib, ... }:
{
  # Allow non-free packages by default
  nixpkgs.config.allowUnfree = lib.mkDefault true;
}
