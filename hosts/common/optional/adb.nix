{ pkgs, ... }:
{
  # Add ADB and other Android SDK platform tools to system environment
  environment.systemPackages = [ pkgs.android-tools ];
}
