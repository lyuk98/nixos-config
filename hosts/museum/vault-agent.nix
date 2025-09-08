{
  config,
  inputs,
  lib,
  ...
}:
{
  imports = [ inputs.nixos-vault-service.nixosModules.nixos-vault-service ];

  # Use binary version of Vault to avoid building the package
  nixpkgs.overlays = [
    (final: prev: { vault = prev.vault-bin; })
  ];

  # Allow unfree package (Vault)
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "vault"
      "vault-bin"
    ];

  detsys.vaultAgent = {
    defaultAgentConfig = {
      vault = {
        address = "http://vault.tailnet.lyuk98.com:8200";
      };
      auto_auth.method = [
        {
          type = "approle";
          config = {
            remove_secret_id_file_after_reading = false;
            role_id_file_path = "/var/lib/secrets/vault-role-id";
            secret_id_file_path = "/var/lib/secrets/vault-secret-id";
          };
        }
      ];
    };

    systemd.services = {
      ente = {
        # Enable Vault integration with Museum
        enable = true;

        environment = {
          # Restart the service in case secrets change
          changeAction = "restart";

          # Get secrets from Vault
          templateFiles.env.file = ./environment.ctmpl;
        };

        secretFiles = {
          # Restart the service in case secrets change
          defaultChangeAction = "restart";

          files = {
            "tls.cert".template = ''
              {{ with secret "kv/ente/cloudflare/certificate" }}{{ .Data.certificate }}{{ end }}
            '';
            "tls.key".template = ''
              {{ with secret "kv/ente/cloudflare/certificate" }}{{ .Data.certificate_key }}{{ end }}
            '';
          };
        };
      };

      nginx = {
        # Enable Vault integration with Nginx
        enable = true;

        secretFiles = {
          # Reload unit in case secrets change
          defaultChangeAction = "reload";

          # Get secrets from Vault
          files = {
            certificate.template = ''
              {{ with secret "kv/ente/cloudflare/certificate" }}{{ .Data.certificate }}{{ end }}
            '';
            certificate-key.template = ''
              {{ with secret "kv/ente/cloudflare/certificate" }}{{ .Data.certificate_key }}{{ end }}
            '';
          };
        };
      };
    };
  };

  # Start affected services after tailscaled starts since it is needed to connect to Vault
  systemd.services =
    lib.genAttrs
      [
        "ente"
        "nginx"
      ]
      (name: {
        after = [ config.systemd.services.tailscaled.name ];
        requires = [ config.systemd.services.tailscaled.name ];
      });
}
