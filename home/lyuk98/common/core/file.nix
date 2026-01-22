{ pkgs, ... }:
{
  # Add file to environment
  home.packages = [ pkgs.file ];
}
