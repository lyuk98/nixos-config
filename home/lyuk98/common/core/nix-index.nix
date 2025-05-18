{ inputs, ... }:
{
  # Import nix-index-database
  imports = [
    inputs.nix-index-database.hmModules.nix-index
  ];

  programs.nix-index = {
    # Enable nix-index
    enable = true;

    # Enable Bash integration for nix-index
    enableBashIntegration = true;
  };

  # Use prebuilt index for comma
  # This also enables comma
  programs.nix-index-database.comma.enable = true;
}
