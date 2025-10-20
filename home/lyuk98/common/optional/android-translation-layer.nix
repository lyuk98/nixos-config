{ pkgs, ... }:
{
  # Add Android Translation Layer to environment
  home.packages = [ pkgs.android-translation-layer ];
}
