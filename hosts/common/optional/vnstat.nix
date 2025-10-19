{ lib, config, ... }:
{
  # Enable network usage statistics with vnStat
  services.vnstat.enable = true;

  # Make data directory persistent
  environment.persistence."/persist".directories =
    lib.optional config.services.vnstat.enable "/var/lib/vnstat";
}
