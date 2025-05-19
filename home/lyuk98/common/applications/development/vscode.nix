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

      # Prevent manual installation of extensions
      mutableExtensionsDir = false;

      # Define declarative profiles
      profiles = {
        # Define default profile
        default = {
          # Add extensions
          extensions = with pkgs.vscode-extensions; [
            llvm-vs-code-extensions.vscode-clangd # clangd
            arrterian.nix-env-selector # Nix Environment Selector
            jnoortheen.nix-ide # Nix IDE
            rust-lang.rust-analyzer # rust-analyzer
            ban.spellright # Spell Right
          ];

          # Disable update notifications
          enableUpdateCheck = false;
          enableExtensionUpdateCheck = false;

          # Set user settings
          userSettings = {
            # Text Editor
            "editor.fontFamily" =
              lib.mkIf (builtins.elem pkgs.cascadia-code config.home.packages) "'Cascadia Code', 'monospace', monospace";
            "editor.insertSpaces" = false;
            "files.autoSave" = "afterDelay";

            # Features
            "extensions.autoUpdate" = false;

            # Application
            "telemetry.feedback.enabled" = false;
            "telemetry.telemetryLevel" = "off";

            # Extensions / Git
            "git.autofetch" = true;
            "git.enableCommitSigning" = lib.mkDefault true;
            "git.inputValidation" = true;

            # Extensions / NixIDE
            "nix.enableLanguageServer" = true;
            "nix.formatterPath" = "${pkgs.nixfmt-rfc-style}/bin/nixfmt";
            "nix.serverPath" = "${pkgs.nil}/bin/nil";
            "nix.serverSettings" = {
              "nil" = {
                "formatting"."command" = [ "nixfmt" ];
              };
            };

            # Settings for Nix
            "[nix]" = {
              # Text Editor
              "editor.insertSpaces" = true;
              "editor.tabSize" = 2;
            };

            # Settings for Rust
            "[rust]" = {
              # Text Editor
              "editor.insertSpaces" = true;
              "editor.tabSize" = 4;
            };
          };
        };
      };
    };

    # Nix IDE can only invoke nixfmt if it is available in the environment
    home.packages = [ pkgs.nixfmt-rfc-style ];
  };
}
