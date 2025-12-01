{ config, inputs, ... }:
{
  imports = [
    inputs.disko.nixosModules.disko
    inputs.hardware.nixosModules.dell-xps-13-9350

    ../common/core
    ../common/optional/gnome.nix
    ../common/optional/iwd.nix
    ../common/optional/lanzaboote.nix
    ../common/optional/libvirt.nix
    ../common/optional/pipewire.nix
    ../common/optional/plymouth.nix
    ../common/optional/random-mac-address.nix
    ../common/optional/system-connections.nix
    ../common/optional/tpm2.nix
    ../common/optional/uutils.nix
    ../common/optional/vnstat.nix

    ../common/users/lyuk98

    ./clevis.nix
    ./disko-config.nix
    ./tailscale.nix
  ];

  # Retrieve secrets
  sops.secrets.machine-id = {
    sopsFile = ./secrets.yaml;
    neededForUsers = true;
  };

  # Set the hostname and host ID
  networking = {
    hostName = "xps13";
    hostId = "7e7f3bdd";
  };

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
        PRETTY_HOSTNAME="XPS 13"
      '';
    };
  };

  # Disable power-saving mechanisms
  networking.networkmanager.wifi.powersave = false;
  powerManagement.enable = false;
  services.displayManager.gdm.autoSuspend = false;
  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
  };

  # The platform where the NixOS configuration runs
  nixpkgs.hostPlatform = "x86_64-linux";

  # First version of NixOS installed in this system
  system.stateVersion = "25.11";
}
