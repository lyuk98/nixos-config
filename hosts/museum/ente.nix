{ lib, config, ... }:
{
  services.ente =
    let
      domain = "lyuk98.com";
    in
    {
      web = {
        # Enable Ente web
        enable = true;

        # Set domains for web components
        domains = {
          accounts = "ente-accounts.${domain}";
          cast = "ente-cast.${domain}";
          albums = "ente-albums.${domain}";
          photos = "ente-photos.${domain}";
        };
      };

      api = {
        # Enable Museum, the API server
        enable = true;

        # Enable Nginx proxy for Museum
        nginx.enable = true;

        # Enable local PostgreSQL database
        enableLocalDB = true;

        # Set API endpoint
        domain = "ente-api.${domain}";

        settings =
          let
            files = config.detsys.vaultAgent.systemd.services.ente.secretFiles.files;
          in
          {
            # Manage object storage settings
            s3 = {
              b2-eu-cen = {
                # Indicate that this is not a local MinIO bucket
                are_local_buckets = false;

                # Set sensitive values
                key._secret = files.s3_key.path;
                secret._secret = files.s3_secret.path;
                endpoint._secret = files.s3_endpoint.path;
                region._secret = files.s3_region.path;
                bucket._secret = files.s3_bucket.path;
              };
            };

            # Manage key-related settings
            key = {
              encryption._secret = files.key_encryption.path;
              hash._secret = files.key_hash.path;
            };
            jwt.secret._secret = files.jwt_secret.path;

            # Set internal settings
            internal = {
              admin = 1580559962386438;
              disable-registration = true;
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
          sslCertificate = secrets."tls.cert".path;
          sslCertificateKey = secrets."tls.key".path;
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
