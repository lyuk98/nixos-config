{ pkgs, lib, ... }:
{
  # Add packages for Sequoia
  home.packages = with pkgs; [
    sequoia-sq # Command-line interface for Sequoia
    sequoia-git # Authenticate changes to VCS repositories
    sequoia-sop # Stateless OpenPGP implementation using Sequoia
    sequoia-sqv # OpenPGP signature verification tool
    sequoia-wot # Sequoia web of trust
    sequoia-chameleon-gnupg # GnuPG reimplementation using Sequoia
  ];

  services.gpg-agent = {
    # Enable GnuPG private key agent
    enable = true;

    # Set default pinentry interface
    pinentry.package = lib.mkDefault pkgs.pinentry-gnome3;
  };
}
