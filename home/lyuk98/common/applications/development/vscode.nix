{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{
  # Create option to enable Visual Studio Code
  options.applications.development.vscode.enable = lib.mkEnableOption "Visual Studio Code";

  config = lib.mkIf config.applications.development.vscode.enable {
    # Add overlay to Nixpkgs
    nixpkgs.overlays = [
      inputs.nix-vscode-extensions.overlays.default
    ];

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
          extensions = with pkgs.vscode-marketplace; [
            ccls-project.ccls # ccls
            jkillian.custom-local-formatters # Custom Local Formatters
            github.vscode-github-actions # GitHub Actions
            hashicorp.hcl # HashiCorp HCL
            hashicorp.terraform # HashiCorp Terraform
            arrterian.nix-env-selector # Nix Environment Selector
            jnoortheen.nix-ide # Nix IDE
            rust-lang.rust-analyzer # rust-analyzer
            ban.spellright # Spell Right
            tonybaloney.vscode-pets # vscode-pets
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

            # Extensions / ccls
            "ccls.launch.command" = "${pkgs.ccls}/bin/ccls";

            # Extensions / Custom Local Formatters
            "customLocalFormatters.formatters" = [
              {
                "command" = "${pkgs.hclfmt}/bin/hclfmt";
                "languages" = [
                  "hcl"
                ];
              }
            ];

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

            # Extensions / rust-analyzer
            "rust-analyzer.server.path" = "${pkgs.rust-analyzer}/bin/rust-analyzer";

            # Settings for HashiCorp configuration language
            "[hcl]" = {
              # Text Editor
              "editor.defaultFormatter" = "jkillian.custom-local-formatters";
              "editor.insertSpaces" = true;
              "editor.tabSize" = 2;
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

            # Settings for Terraform
            "[terraform]" = {
              # Text Editor
              "editor.defaultFormatter" = "hashicorp.terraform";
              "editor.insertSpaces" = true;
              "editor.tabSize" = 2;
            };
            "[terraform-vars]" = {
              # Text Editor
              "editor.insertSpaces" = true;
              "editor.tabSize" = 2;
            };
          };
        };
      };
    };

    # Some extensions can only invoke what is available in the environment
    home.packages = with pkgs; [
      nixfmt-rfc-style
      terraform
    ];
  };
}
