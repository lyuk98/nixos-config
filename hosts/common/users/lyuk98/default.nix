{ lib, config, ... }:
let
  # Retain only valid group names
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{
  # Import Home Manager NixOS module
  imports = [
    ../../optional/home-manager.nix
  ];

  # Retrieve secrets
  sops.secrets.lyuk98-password = {
    sopsFile = ./secrets.yaml;
    neededForUsers = true;
  };

  # Create user
  users.users = {
    lyuk98 = {
      description = "이영욱";
      extraGroups = ifTheyExist [
        "adbusers"
        "libvirtd"
        "networkmanager"
        "tss"
        "wheel"
      ];
      hashedPasswordFile = config.sops.secrets.lyuk98-password.path;
      isNormalUser = true;
    };
  };

  # Add Home Manager configuration
  home-manager =
    let
      # Specify path to host-specific Home Manager module
      configuration = ../../../../home/lyuk98/. + "/${config.networking.hostName}.nix";
    in
    # Proceed only if the configuration exists
    lib.mkIf (builtins.pathExists configuration) {
      # Import Home Manager configuration
      users.lyuk98 = import configuration;
    };
}
