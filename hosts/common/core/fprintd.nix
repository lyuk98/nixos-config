{ lib, config, ... }:
{
  # Persist directory for storing biometric data
  environment.persistence."/persist".directories =
    lib.optional config.services.fprintd.enable "/var/lib/fprint";
}
