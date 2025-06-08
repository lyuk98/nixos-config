{ inputs, ... }:
{
  # Add overlay for Nix User Repository
  nixpkgs.overlays = [ inputs.nur.overlays.default ];
}
