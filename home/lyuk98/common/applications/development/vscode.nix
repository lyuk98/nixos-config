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

  config = {
    # Add overlay to Nixpkgs
    nixpkgs.overlays = lib.optional config.applications.development.vscode.enable inputs.nix-vscode-extensions.overlays.default;

    programs.vscode = {
      # Enable Visual Studio Code
      enable = config.applications.development.vscode.enable;

      # Prevent manual installation of extensions
      mutableExtensionsDir = false;

      # Define declarative profiles
      profiles = {
        # Define default profile
        default = {
          # Add extensions
          extensions = with pkgs; [
            vscode-marketplace.arrterian.nix-env-selector # Nix Environment Selector
            vscode-marketplace.ccls-project.ccls # ccls
            vscode-marketplace.github.vscode-github-actions # GitHub Actions
            vscode-marketplace.hashicorp.hcl # HashiCorp HCL
            vscode-marketplace.jkillian.custom-local-formatters # Custom Local Formatters
            vscode-marketplace.jnoortheen.nix-ide # Nix IDE
            vscode-marketplace.matthewpi.caddyfile-support # Caddyfile Support
            vscode-marketplace.ms-python.black-formatter # Black Formatter
            vscode-marketplace.ms-python.pylint # Pylint
            vscode-marketplace.ms-python.python # Python
            vscode-marketplace.ms-vscode-remote.remote-ssh # Remote - SSH
            vscode-marketplace.ms-vscode-remote.remote-ssh-edit # Remote - SSH: Editing Configuration Files
            vscode-marketplace.redhat.vscode-yaml # YAML
            vscode-marketplace.rust-lang.rust-analyzer # rust-analyzer
            vscode-marketplace.tonybaloney.vscode-pets # vscode-pets

            open-vsx.mermaidchart.vscode-mermaid-chart # Mermaid
            open-vsx.opentofu.vscode-opentofu # VSCode - OpenTofu
            open-vsx.streetsidesoftware.code-spell-checker # Code Spell Checker
            open-vsx.streetsidesoftware.code-spell-checker-british-english-ise # British English -ise - Code Spell Checker
            open-vsx.streetsidesoftware.code-spell-checker-french # French - Code Spell Checker
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

            # Window
            "window.autoDetectColorScheme" = true;

            # Features
            "extensions.autoUpdate" = false;
            "chat.disableAIFeatures" = true;

            # Application
            "telemetry.feedback.enabled" = false;
            "telemetry.telemetryLevel" = "off";

            # Extensions / Caddyfile
            "caddyfile.executable" = lib.getExe pkgs.caddy;

            # Extensions / ccls
            "ccls.launch.command" = lib.getExe pkgs.ccls;

            # Extensions / Code Spell Checker
            "cSpell.enabled" = true;
            "cSpell.caseSensitive" = true;
            "cSpell.language" = builtins.concatStringsSep "," [
              "en-GB"
              "en"
              "fr"
            ];

            # Extensions / Custom Local Formatters
            "customLocalFormatters.formatters" = [
              {
                "command" = lib.getExe pkgs.hclfmt;
                "languages" = [
                  "hcl"
                ];
              }
            ];

            # Extensions / Git
            "git.autofetch" = true;
            "git.enableCommitSigning" = lib.mkDefault true;
            "git.inputValidation" = true;

            # Extensions / LaTeX
            "latex-workshop.formatting.latex" = "latexindent";

            # Extensions / NixIDE
            "nix.enableLanguageServer" = true;
            "nix.serverPath" = lib.getExe pkgs.nixd;
            "nix.serverSettings" = {
              "nixd" = {
                formatting.command = [ (lib.getExe pkgs.nixfmt) ];
              };
            };

            # Extensions / Nix Environment Selector
            "nixEnvSelector.useFlakes" = true;

            # Extensions / Python
            "python.defaultInterpreterPath" = lib.getExe pkgs.python3;

            # Extensions / rust-analyzer
            "rust-analyzer.server.path" = lib.getExe pkgs.rust-analyzer;

            # Extensions / VSCode - OpenTofu
            "opentofu.codelens.referenceCount" = true;
            "opentofu.validation.enableEnhancedValidation" = true;
            "opentofu.languageServer.enable" = true;
            "opentofu.languageServer.path" = lib.getExe pkgs.tofu-ls;
            "opentofu.languageServer.opentofu.path" = lib.getExe pkgs.opentofu;
            "opentofu.experimentalFeatures.prefillRequiredFields" = true;

            # Extensions / YAML
            "yaml.disableSchemaDetection" = [
              "**/.github/workflows/*.yml"
              "**/.github/workflows/*.yaml"
              "**/.gitea/workflows/*.yml"
              "**/.gitea/workflows/*.yaml"
              "**/.forgejo/workflows/*.yml"
              "**/.forgejo/workflows/*.yaml"
            ];

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

            # Settings for Python
            "[python]" = {
              # Text Editor
              "editor.defaultFormatter" = "ms-python.black-formatter";
              "editor.insertSpaces" = true;
              "editor.tabSize" = 4;
            };

            # Settings for Rust
            "[rust]" = {
              # Text Editor
              "editor.insertSpaces" = true;
              "editor.tabSize" = 4;
            };

            # Settings for OpenTofu
            "[opentofu][opentofu-vars]" = {
              # Text Editor
              "editor.defaultFormatter" = "opentofu.vscode-opentofu";
              "editor.insertSpaces" = true;
              "editor.tabSize" = 2;
            };
          };
        };
      };
    };
  };
}
