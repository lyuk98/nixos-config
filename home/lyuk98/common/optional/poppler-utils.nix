{ pkgs, ... }:
{
  # Add PDF rendering library
  home.packages = [ pkgs.poppler-utils ];
}
