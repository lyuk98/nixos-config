{ lib, config, ... }:
{
  services.openssh = {
    # Enable OpenSSH daemon
    enable = true;

    settings = lib.mkIf config.services.openssh.enable {
      # Prevent logins to root users using password
      PermitRootLogin = lib.mkDefault "prohibit-password";
      # Disallow password-based authentication
      PasswordAuthentication = lib.mkDefault false;

      # Allow post-quantum key agreement algorithms
      KexAlgorithms = [
        "sntrup761x25519-sha512"
        "sntrup761x25519-sha512@openssh.com"
        "mlkem768x25519-sha256"
      ];
    };
  };

  # Add authorized SSH keys for root
  users.users.root.openssh.authorizedKeys.keyFiles = lib.mkDefault [
    ../../../home/lyuk98/id_ed25519.pub
  ];

  # Preserve host keys if Impermanence is enabled
  preservation.preserveAt."/persist" = lib.optionalAttrs config.services.openssh.enable {
    files = builtins.map (hostKey: {
      file = hostKey.path;
      how = "symlink";
      configureParent = true;
    }) config.services.openssh.hostKeys;
  };
}
