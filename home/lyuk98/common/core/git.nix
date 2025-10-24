{ pkgs, lib, ... }:
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

    # Add globally ignored paths
    ignores = [
      # Linux
      "*~"
      ".fuse_hidden*"
      ".directory"
      ".Trash-*"
      ".nfs*"
      "nohup.out"
    ];

    # Extra configurations
    settings = {
      # Default committer information
      user = {
        email = lib.mkDefault "pr@lyuk98.com";
        name = lib.mkDefault "이영욱";
      };

      core.autocrlf = "input";
      credential.helper = lib.mkDefault "${
        pkgs.git.override { withLibsecret = true; }
      }/bin/git-credential-libsecret";
      init.defaultBranch = "main";
    };

    lfs = {
      # Enable Git Large File Storage
      enable = true;
    };
  };
}
