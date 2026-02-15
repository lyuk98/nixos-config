{ pkgs, ... }:
{
  # Add Backblaze B2
  home.packages = [ pkgs.backblaze-b2 ];
}
