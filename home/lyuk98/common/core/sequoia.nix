{ pkgs, lib, ... }:
{
  nixpkgs.overlays = [
    # Use pre-release version of sq to enable support for post-quantum cryptography
    (final: prev: {
      sequoia-sq = prev.sequoia-sq.overrideAttrs (oldAttrs: rec {
        version = "1.4.0-pqc.1";
        src = prev.fetchFromGitLab {
          owner = "sequoia-pgp";
          repo = "sequoia-sq";
          tag = "v${version}";
          hash = "sha256-ep3il5In0ecyNWHvCo0yh4yL92VTy3/FligzKkY+SJQ=";
        };

        # Fetch latest Cargo dependencies
        cargoDeps = prev.rustPlatform.fetchCargoVendor {
          inherit src;
          hash = "sha256-NYUYQCKG4XWchvuEzzAD+R25Wk0YrHN4ISVtQnhPkcM=";
        };

        # Use OpenSSL cryptography backend as it is currently the only one supporting PQC
        buildInputs = oldAttrs.buildInputs ++ [ prev.openssl ];
        cargoBuildNoDefaultFeatures = true;
        cargoBuildFeatures = [ "crypto-openssl" ];
      });
    })
  ];

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
