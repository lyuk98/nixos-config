{
  pkgs,
  lib,
  config,
  ...
}:
{
  sops.secrets = {
    # Get secret Vault settings
    vault-settings = {
      format = "binary";

      # Change ownership of the secret to user `vault`
      owner = config.users.users.vault.name;
      group = config.users.groups.vault.name;

      sopsFile = ./vault.hcl;
    };
  };

  # Allow unfree package for Vault
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "vault"
      "vault-bin"
    ];

  services.vault = {
    # Enable Vault daemon
    enable = true;

    # Use binary version of Vault from Nixpkgs
    package = pkgs.vault-bin;

    # Listen to all available interfaces
    address = "[::]:8200";

    # Use S3 as a storage backend
    storageBackend = "s3";

    # Add secret Vault settings
    extraSettingsPaths = [
      config.sops.secrets.vault-settings.path
    ];

    # Enable Vault UI
    extraConfig = ''
      ui = true
    '';
  };
}
