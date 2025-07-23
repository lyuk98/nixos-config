{ pkgs, ... }:
let
  # Package to use for wl-clipboard
  # Alternatives such as `wl-clipboard-rs` exist
  pkg = pkgs.wl-clipboard;
in
{
  # Add package to environment
  home.packages = [ pkg ];
}
