{ pkgs, ... }:
{
  # Add my custom packages
  home.packages = [ pkgs.metadata-to-csv ];
}
