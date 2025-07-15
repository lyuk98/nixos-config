{
  config,
  inputs,
  lib,
  ...
}:
let
  ageKeyFile = "/var/lib/sops-nix/keys.txt";
in
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  # Specify path of the age key to decrypt secrets with
  # This file needs to be present to decrypt secrets during activation
  sops.age.keyFile = lib.mkDefault "${
    # Specify persisted directory if Impermanence is used
    # since the key will be used during early boot
    lib.optionalString (config.environment ? persistence) "/persist"
  }${ageKeyFile}";

  # Use persistence if enabled
  environment = lib.optionalAttrs (config.environment ? persistence) {
    persistence."/persist" = {
      files = [
        # Keep age key
        {
          file = ageKeyFile;
          parentDirectory = {
            mode = "0600";
          };
        }
      ];
    };
  };
}
