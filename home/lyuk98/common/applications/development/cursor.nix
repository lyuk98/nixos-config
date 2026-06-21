{
  lib,
  config,
  inputs,
  ...
}:
{
  # Create option to enable Cursor
  options.applications.development.cursor.enable = lib.mkEnableOption "Cursor";

  config = {
    # Add overlay to Nixpkgs
    nixpkgs.overlays = lib.optional config.applications.development.cursor.enable inputs.nix-vscode-extensions.overlays.default;

    programs.cursor = {
      # Enable Cursor
      enable = config.applications.development.cursor.enable;

      # Define declarative profiles
      profiles = {
        # Define default profile
        default =
          let
            vscode = config.programs.vscode.profiles.default;
          in
          {
            # Use extensions also used by VS Code
            extensions = vscode.extensions;

            # Disable update notifications
            enableUpdateCheck = false;
            enableExtensionUpdateCheck = false;

            # Enable integration of MCP configuration from programs.mcp.servers
            enableMcpIntegration = true;

            # Set Cursor like how VS Code is set up
            userSettings = vscode.userSettings;
          };
      };
    };
  };
}
