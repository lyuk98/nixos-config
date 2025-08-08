{
  programs.direnv = {
    # Enable direnv
    enable = true;

    # Enable Bash integration for direnv
    enableBashIntegration = true;

    # Enable nix-direnv
    nix-direnv.enable = true;
  };
}
