{ config, ... }:
let
  # Retain only valid group names
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{
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
        "networkmanager"
        "tss"
        "wheel"
      ];
      hashedPasswordFile = config.sops.secrets.lyuk98-password.path;
      isNormalUser = true;
    };
  };
}
