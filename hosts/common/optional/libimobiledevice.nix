{ pkgs, ... }:
{
  # Enable the usbmuxd (USB multiplexing daemon) service
  services.usbmuxd.enable = true;

  # Add packages
  environment.systemPackages = [
    pkgs.libimobiledevice
    pkgs.ifuse # Provides `ifuse`
  ];
}
