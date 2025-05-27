{ outputs, lib, ... }:
{
  nixpkgs = {
    # Apply custom overlays to Nixpkgs
    overlays = builtins.attrValues outputs.overlays;

    # Allow non-free packages by default
    config.allowUnfree = lib.mkDefault true;
  };
}
