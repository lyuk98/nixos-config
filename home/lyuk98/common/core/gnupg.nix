{ pkgs, lib, ... }:
{
  programs.gpg = {
    # Enable Gnu Privacy Guard
    enable = true;

    # Import public keys
    publicKeys = [
      {
        source = ../../270CB11B1189E79A17DCB7831BDAFDC5D60E735C.asc;
        trust = "ultimate";
      }
    ];
  };

  services.gpg-agent = {
    # Enable GnuPG private key agent
    enable = true;

    # Set default pinentry interface
    pinentry.package = lib.mkDefault pkgs.pinentry-gnome3;
  };
}
