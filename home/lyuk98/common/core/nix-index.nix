{
  lib,
  config,
  inputs,
  ...
}:
{
  # Import nix-index-database
  imports = [
    inputs.nix-index-database.homeModules.nix-index
  ];

  programs.nix-index = {
    # Enable nix-index
    enable = true;

    # Enable integration for enabled shells
    enableBashIntegration = lib.mkDefault config.programs.bash.enable;
    enableFishIntegration = lib.mkDefault config.programs.fish.enable;
    enableZshIntegration = lib.mkDefault config.programs.zsh.enable;
  };

  # Use prebuilt index for comma
  # This also enables comma
  programs.nix-index-database.comma.enable = true;
}
