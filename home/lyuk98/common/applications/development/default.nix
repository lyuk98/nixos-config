{
  lib,
  config,
  ...
}:
{
  imports = [
    ./vscode.nix
  ];

  # Create option to enable all Development applications
  options.applications.development.enable = lib.mkEnableOption "all applications for development";

  # Enable all Development applications if enabled
  config.applications.development = lib.mkIf config.applications.development.enable {
    vscode.enable = lib.mkDefault true;
  };
}
