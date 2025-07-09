{ lib, config, ... }:
{
  services.openssh = {
    # Enable OpenSSH daemon
    enable = true;

    settings = lib.mkIf config.services.openssh.enable {
      # Prevent root users from logging in
      PermitRootLogin = "no";
      # Disallow password-based authentication
      PasswordAuthentication = lib.mkDefault false;
    };
  };
}
