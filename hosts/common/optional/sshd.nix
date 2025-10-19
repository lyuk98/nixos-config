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
    };
  };

  # Add authorized SSH keys for root
  users.users.root.openssh.authorizedKeys.keyFiles = lib.mkDefault [
    ../../../home/lyuk98/id_ed25519.pub
  ];

  # Preserve host keys if Impermanence is enabled
  environment.persistence."/persist" = lib.optionalAttrs config.services.openssh.enable {
    files = builtins.map (hostKey: hostKey.path) config.services.openssh.hostKeys;
  };
}
