{ lib, config, ... }:
{
  # Persist directory for AccountsService daemon
  environment.persistence."/persist".directories =
    lib.optional config.services.accounts-daemon.enable "/var/lib/AccountsService";
}
