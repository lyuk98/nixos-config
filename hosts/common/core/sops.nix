{ inputs, lib, ... }:
let
  ageKeyFile = "/var/lib/sops-nix/keys.txt";
in
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  # Specify path of the age key to decrypt secrets with
  # This file needs to be present to decrypt secrets during activation
  sops.age.keyFile = lib.mkDefault "/persist${ageKeyFile}";

  # Use persistence for the age key
  environment = {
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
