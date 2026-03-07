{ pkgs, ... }:
{
  virtualisation.virtualbox.host = {
    # Enable VirtualBox
    enable = true;

    # Enable KVM support for VirtualBox
    enableKvm = true;

    # Use VirtualBox package with KVM support
    package = pkgs.virtualboxKvm;

    # Do not set up a network interface, which is not compatible with virtualbox-kvm
    addNetworkInterface = false;
  };
}
