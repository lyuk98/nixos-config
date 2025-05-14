{ pkgs, ... }:
{
  imports = [ ./kdeconnect.nix ];

  # Set GSConnect as kdeconnect-kde package
  programs.kdeconnect.package = pkgs.gnomeExtensions.gsconnect;
}
