{ pkgs, ... }:
let
  # Package to use for wl-clipboard
  pkg = pkgs.wl-clipboard-rs;
in
{
  # Add package to environment
  home.packages = [ pkg ];
}
