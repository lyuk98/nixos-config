{
  config,
  inputs,
  lib,
  ...
}:
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  # Specify path of the age key to decrypt secrets with
  # This file needs to be present to decrypt secrets during activation
  sops.age.keyFile = lib.mkDefault "/var/lib/sops-nix/keys.txt";

  # Preserve the age key
  preservation.preserveAt."/persist".files = [
    # Keep age key
    {
      file = config.sops.age.keyFile;
      inInitrd = true;
      mode = "0600";

      configureParent = true;
      parent = {
        mode = "0600";
      };
    }
  ];
}
