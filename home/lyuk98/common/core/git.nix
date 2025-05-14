{ lib, ... }:
{
  programs.git = {
    # Enable Git
    enable = true;

    signing = lib.mkDefault {
      # Use OpenPGP for signing commits and tags
      format = "openpgp";

      # Signing key fingerprint
      key = "270CB11B1189E79A17DCB7831BDAFDC5D60E735C";

      # Sign commits and tags by default
      signByDefault = true;
    };

    # Default committer email and name
    userEmail = lib.mkDefault "pr@lyuk98.com";
    userName = lib.mkDefault "이영욱";
  };
}
