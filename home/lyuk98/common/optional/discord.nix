{ pkgs, ... }:
{
  # Add Discord to list of available packages
  home.packages = [ pkgs.discord ];
}
