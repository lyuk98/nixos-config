{ lib, config, ... }:
{
  # Enable network usage statistics with vnStat
  services.vnstat.enable = true;

  # Make data directory persistent if Impermanence is enabled
  environment = lib.optionalAttrs (config.environment ? persistence) {
    persistence."/persist".directories = [ "/var/lib/vnstat" ];
  };
}
