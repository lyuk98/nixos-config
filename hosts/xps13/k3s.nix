{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
  cfg = config.services.k3s;

  # Server configuration
  server = {
    address = config.networking.hostName;
    port = 6443;
  };

  # Helm charts from nixhelm
  charts = inputs.nixhelm.charts { inherit pkgs; };

  # Create a chart archive from nixhelm derivation
  packageHelmChart =
    chart:
    pkgs.stdenv.mkDerivation {
      name = "${chart.name}.tgz";

      phases = [
        "unpackPhase"
        "buildPhase"
      ];

      src = "${chart}";

      buildPhase = ''
        cd ../
        ${pkgs.kubernetes-helm}/bin/helm package ${chart.name}
        cp --verbose *.tgz $out
      '';
    };
in
{
  options.services.k3s = {
    # Create options for CIDRs
    clusterCidr = lib.mkOption {
      default = [ "10.42.0.0/16" ];
      example = [ "10.1.0.0/16" ];
      description = "IPv4/IPv6 network CIDRs to use for pod IPs";
      type = lib.types.listOf lib.types.str;
    };
    serviceCidr = lib.mkOption {
      default = [ "10.43.0.0/16" ];
      example = [ "10.0.0.0/24" ];
      description = "IPv4/IPv6 network CIDRs to use for service";
      type = lib.types.listOf lib.types.str;
    };

    lib = lib.mkOption {
      default = {
        inherit packageHelmChart;
      };
      description = "Common functions for K3s modules";
      type = lib.types.attrs;
    };
  };

  config = {
    sops = {
      secrets = {
        # Tailscale Kubernetes Operator's credential
        "operator-oauth/client-id".sopsFile = ./secrets.yaml;
        "operator-oauth/client-secret".sopsFile = ./secrets.yaml;
      };

      templates = {
        # Template for file to pass as --vpn-auth-file
        "k3s/vpn-auth".content = builtins.concatStringsSep "," [
          "name=tailscale"
          "joinKey=${config.sops.placeholder.tailscale-auth-key}"
          "extraArgs=${builtins.concatStringsSep " " config.services.tailscale.extraUpFlags}"
        ];

        # Template for secret operator-oauth
        # YAML is a superset of JSON, so this can be used to write a manifest file
        "operator-oauth.yaml".content = builtins.toJSON {
          apiVersion = "v1";
          kind = "Secret";
          metadata = {
            name = "operator-oauth";
            namespace = "tailscale";
          };
          stringData = {
            client_id = config.sops.placeholder."operator-oauth/client-id";
            client_secret = config.sops.placeholder."operator-oauth/client-secret";
          };
          immutable = true;
        };
      };
    };

    services.k3s = {
      # Enable K3s
      enable = true;

      # Run as a server
      role = "server";

      # Set the API server's address
      serverAddr = "https://${server.address}:${builtins.toString server.port}";

      # Set network CIDRs for pod IPs and service
      clusterCidr = [
        "10.42.0.0/16"
        "2001:cafe:42::/56"
      ];
      serviceCidr = [
        "10.43.0.0/16"
        "2001:cafe:43::/112"
      ];

      # Set extra flags for K3s
      extraFlags = [
        "--cluster-cidr ${builtins.concatStringsSep "," cfg.clusterCidr}"
        "--service-cidr ${builtins.concatStringsSep "," cfg.serviceCidr}"

        # Enable Tailscale integration
        "--vpn-auth-file ${config.sops.templates."k3s/vpn-auth".path}"

        # Enable IPv6 masquerading
        "--flannel-ipv6-masq"
      ];

      # Attempt to detect node system shutdown and terminate pods
      gracefulNodeShutdown.enable = true;

      # Specify container images
      images = [
        cfg.package.airgap-images
      ];

      manifests = {
        # Namespace for Tailscale
        # Setting autoDeployCharts.tailscale-operator.createNamespace to true does not create one
        # early enough for manifests
        namespace-tailscale.content = {
          apiVersion = "v1";
          kind = "Namespace";
          metadata = {
            name = "tailscale";
          };
        };

        # Secret for Tailscale Kubernetes Operator
        operator-oauth = {
          source = config.sops.templates."operator-oauth.yaml".path;
        };

        # Pre-creation of multi-replica ProxyGroup
        ts-proxies.content = {
          apiVersion = "tailscale.com/v1alpha1";
          kind = "ProxyGroup";
          metadata = {
            name = "ts-proxies";
          };
          spec = {
            type = "egress";
            tags = [ "tag:k3s" ];
            replicas = 3;
          };
        };
      };

      autoDeployCharts = {
        # Tailscale Kubernetes Operator
        tailscale-operator = {
          name = "tailscale-operator";
          package = cfg.lib.packageHelmChart charts.tailscale.tailscale-operator;
          targetNamespace = "tailscale";

          values = {
            # Use custom tag and hostname for the operator
            operatorConfig = {
              defaultTags = [ "tag:k3s-operator" ];
              hostname = "k3s-operator";
            };
          };
        };
      };
    };

    systemd.services.k3s = {
      # Add Tailscale to PATH for integration
      path = [
        config.services.tailscale.package
      ];

      # Start K3s after tailscaled
      after = [
        config.systemd.services.tailscaled.name
      ];
    };
  };
}
