{
  config,
  inputs,
  lib,
  ...
}:
{
  imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];

  # Allow modification of EFI variables
  boot.loader.efi.canTouchEfiVariables = true;

  # Disable systemd-boot since it is replaced by Lanzaboote
  boot.loader.systemd-boot.enable = lib.mkForce false;

  boot.lanzaboote = {
    # Enable Lanzaboote
    enable = true;

    # Limit to 10 latest generations
    configurationLimit = lib.mkDefault 10;

    # Specify location of PKI bundle
    pkiBundle = "/var/lib/sbctl";
  };

  # Make bundle directory persistent
  environment.persistence."/persist".directories =
    lib.optional config.boot.lanzaboote.enable config.boot.lanzaboote.pkiBundle;
}
