{ lib, config, ... }:
{
  programs.fzf = {
    # Enable fzf, a command-line fuzzy finder
    enable = true;

    # Enable integration for enabled shells
    enableBashIntegration = lib.mkDefault config.programs.bash.enable;
    enableFishIntegration = lib.mkDefault config.programs.fish.enable;
    enableZshIntegration = lib.mkDefault config.programs.zsh.enable;

    # Use fzf-tmux if tmux is enabled
    tmux.enableShellIntegration = lib.mkDefault config.programs.tmux.enable;
  };
}
