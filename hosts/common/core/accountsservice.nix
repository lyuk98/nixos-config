{ lib, config, ... }:
{
  # Persist directory for AccountsService daemon
  preservation.preserveAt."/persist".directories =
    lib.optional config.services.accounts-daemon.enable "/var/lib/AccountsService";
}
