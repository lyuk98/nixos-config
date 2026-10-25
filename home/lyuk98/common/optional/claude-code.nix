{ config, ... }: {
  programs.claude-code = {
    # Enable Claude Code
    enable = true;

    # Use XDG directory for Claude Code configuration
    configDir = "${config.xdg.configHome}/claude";
  };
}
