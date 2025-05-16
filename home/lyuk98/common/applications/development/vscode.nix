{
  pkgs,
  lib,
  config,
  ...
}:
{
  # Create option to enable Visual Studio Code
  options.applications.development.vscode.enable = lib.mkEnableOption "Visual Studio Code";

  config = lib.mkIf config.applications.development.vscode.enable {
    programs.vscode = {
      # Enable Visual Studio Code
      enable = true;

      # Define declarative profiles
      profiles = {
        # Define default profile
        default = {
          # Add extensions
          extensions = with pkgs.vscode-extensions; [
            llvm-vs-code-extensions.vscode-clangd # clangd
            jnoortheen.nix-ide # Nix IDE
            ban.spellright # Spell Right
          ];

          # Disable update notifications
          enableUpdateCheck = false;

          # Set user settings
          userSettings = {
            "editor.fontFamily" =
              lib.mkIf (builtins.elem pkgs.cascadia-code config.home.packages) "'Cascadia Code', 'monospace', monospace";
            "editor.insertSpaces" = false;
            "files.autoSave" = "afterDelay";

            "git.autofetch" = true;
            "git.enableCommitSigning" = lib.mkDefault true;
            "git.inputValidation" = true;

            "nix.enableLanguageServer" = true;
            "nix.formatterPath" = "${pkgs.nixfmt-rfc-style}/bin/nixfmt";
            "nix.serverPath" = "${pkgs.nil}/bin/nil";
            "nix.serverSettings" = {
              "nil" = {
                "formatting"."command" = "${pkgs.nixfmt-rfc-style}/bin/nixfmt";
              };
            };
          };
        };
      };
    };
  };
}
