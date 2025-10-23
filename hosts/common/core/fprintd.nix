{ lib, config, ... }:
{
  # Persist directory for storing biometric data
  preservation.preserveAt."/persist".directories =
    lib.optional config.services.fprintd.enable "/var/lib/fprint";
}
