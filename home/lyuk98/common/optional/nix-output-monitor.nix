{ pkgs, ... }:
{
  # Add nix-output-monitor
  home.packages = [ pkgs.nix-output-monitor ];
}
