{ lib, config, ... }:
{
  programs.direnv = {
    # Enable direnv
    enable = true;

    # Enable nix-direnv
    nix-direnv.enable = true;

    # Enable integration for enabled shells
    enableBashIntegration = lib.mkDefault config.programs.bash.enable;
    enableFishIntegration = lib.mkDefault config.programs.fish.enable;
    enableNushellIntegration = lib.mkDefault config.programs.nushell.enable;
    enableZshIntegration = lib.mkDefault config.programs.zsh.enable;
  };
}
