{ config, inputs, ... }:
{
  imports = [
    inputs.hardware.nixosModules.framework-12th-gen-intel
    ./hardware-configuration.nix

    ../common/core
    ../common/optional/adb.nix
    ../common/optional/appimage.nix
    ../common/optional/fonts.nix
    ../common/optional/fwupd.nix
    ../common/optional/gnome.nix
    ../common/optional/gsconnect.nix
    ../common/optional/iwd.nix
    ../common/optional/lanzaboote.nix
    ../common/optional/libimobiledevice.nix
    ../common/optional/linux-latest.nix
    ../common/optional/pipewire.nix
    ../common/optional/plymouth.nix
    ../common/optional/printing.nix
    ../common/optional/random-mac-address.nix
    ../common/optional/speech-dispatcher.nix
    ../common/optional/steam.nix
    ../common/optional/system-connections.nix
    ../common/optional/tpm2.nix
    ../common/optional/variable-refresh-rate.nix
    ../common/optional/vnstat.nix

    ../common/users/lyuk98
  ];

  # Retrieve secrets
  sops.secrets.machine-id = {
    sopsFile = ./secrets.yaml;
    neededForUsers = true;
  };

  # Set the hostname
  networking.hostName = "framework";

  environment.etc = {
    # Set local machine ID
    machine-id = {
      mode = "0444";
      source = config.sops.secrets.machine-id.path;
    };

    # Set local machine information for pretty hostname
    machine-info = {
      mode = "0644";
      text = ''
        PRETTY_HOSTNAME="Framework Laptop 13"
      '';
    };
  };

  time.timeZone = "America/Toronto";

  # First version of NixOS installed in this system
  system.stateVersion = "25.05";
}
