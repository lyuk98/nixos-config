{ lib, config, ... }:
{
  programs.pay-respects = {
    # Enable pay-respects to correct previous console command
    enable = true;

    # Enable integration for enabled shells
    enableBashIntegration = lib.mkDefault config.programs.bash.enable;
    enableFishIntegration = lib.mkDefault config.programs.fish.enable;
    enableNushellIntegration = lib.mkDefault config.programs.nushell.enable;
    enableZshIntegration = lib.mkDefault config.programs.zsh.enable;
  };
}
