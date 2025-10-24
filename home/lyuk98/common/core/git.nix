{ pkgs, lib, ... }:
let
  # Git with libsecret support
  git = pkgs.git.override { withLibsecret = true; };
in
{
  programs.git = {
    # Enable Git
    enable = true;

    # Use the custom Git package
    package = git;

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

      # Convert CRLF to LF on commit, but not the other way around
      core.autocrlf = "input";

      # Use libsecret as a credential helper
      credential.helper = lib.mkDefault "${git}/bin/git-credential-libsecret";

      # The default branch name upon repository initialisation
      init.defaultBranch = "main";
    };

    lfs = {
      # Enable Git Large File Storage
      enable = true;
    };
  };
}
