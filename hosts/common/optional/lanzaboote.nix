{
  config,
  inputs,
  lib,
  ...
}:
{
  imports = [
    inputs.lanzaboote.nixosModules.lanzaboote
    ./systemd-boot.nix
  ];

  # Disable systemd-boot since it is replaced by Lanzaboote
  boot.loader.systemd-boot.enable = lib.mkForce false;

  boot.lanzaboote = {
    # Enable Lanzaboote
    enable = true;

    # Specify location of PKI bundle
    pkiBundle = "/var/lib/sbctl";
  };

  # Make bundle directory persistent
  preservation.preserveAt."/persist".directories =
    lib.optional config.boot.lanzaboote.enable config.boot.lanzaboote.pkiBundle;
}
