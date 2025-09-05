{ lib, config, ... }:
{
  services.ente =
    let
      domain = "ente.lyuk98.com";
    in
    {
      web = {
        # Enable Ente web
        enable = true;

        # Set domains for web components
        domains = {
          accounts = "accounts.${domain}";
          cast = "cast.${domain}";
          albums = "albums.${domain}";
          photos = "photos.${domain}";
        };
      };

      api = {
        # Enable Museum, the API server
        enable = true;

        # Enable Nginx proxy for Museum
        nginx.enable = true;

        # Set API endpoint
        domain = "api.${domain}";

        settings = {
          # Set meaningless values for database credentials
          # Secrets are provided via environment variables but not providing the values below
          # will fail due to not passing the type check
          db = {
            host = "";
            port = 5432;
            name = "";
            user = "";
          };
        };
      };
    };

  services.nginx = {
    # Use recommended proxy settings
    recommendedProxySettings = true;

    virtualHosts =
      let
        domains = config.services.ente.web.domains;
        secrets = config.detsys.vaultAgent.systemd.services.nginx.secretFiles.files;
      in
      lib.genAttrs
        [
          domains.api
          domains.accounts
          domains.cast
          domains.albums
          domains.photos
        ]
        (name: {
          # Add certificates to supported endpoints
          sslCertificate = secrets.certificate.path;
          sslCertificateKey = secrets.certificate-key.path;
        });
  };

  # Open ports for incoming web traffic
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  # Add persistent data directory for Ente
  environment.persistence."/persist".directories = [ "/var/lib/ente" ];
}
