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

  # Import nix-kube-generators
  kubelib = inputs.nix-kube-generators.lib { inherit pkgs; };

  # OpenStack Helm charts
  charts =
    let
      rev = builtins.substring 0 9 inputs.openstack-helm.rev;
      chart =
        component:
        builtins.elemAt (kubelib.fromYAML (builtins.readFile "${inputs.openstack-helm}/${component}/Chart.yaml")) 0;
      version = component: (chart component).version;
      baseurl = "https://tarballs.opendev.org/openstack/openstack-helm";

      tarball =
        {
          component,
          chartVersion ? (version component),
          hash,
        }:
        pkgs.fetchurl {
          url = "${baseurl}/${component}-${chartVersion}+${rev}.tgz";
          inherit hash;
        };
    in
    builtins.mapAttrs (name: value: tarball (value // { component = name; })) {
      # Identity and authentication service
      keystone = {
        chartVersion = "2025.2.1";
        hash = "sha256-Yi6CVnoYhuzLSRmyKHfq4ntqYC/FNZiGSVM3RIzn42g=";
      };

      # Orchestration service
      heat.hash = "sha256-n5nYTWXXbwMafqL2y5KMUsq+WnLo24fJBgyvHJEGq1Y=";

      # Image service
      glance.hash = "sha256-smwqiUE72uuARKIBIQS69pykICs0TQfXUYWAHAeW57w=";

      # Block storage service
      cinder = {
        chartVersion = "2025.2.1";
        hash = "sha256-E8SLZcQmTViY1Q/PUxjgay1pdb61+glGosxUcfsFRhs=";
      };

      # Compute kit backend
      openvswitch = {
        chartVersion = "2025.2.1";
        hash = "sha256-Mk7AYhPkvbrb54fYxR606Gg9JHMnFCOCZngWC+HtLik=";
      };
      libvirt.hash = "sha256-yQVqSXem3aGCfNRAM+qONAyFOlucG6Wfjr5/3ldqZcs=";

      # Compute kit
      placement.hash = "sha256-+Ykc8yLPCSPwNeLzWCous3OdDjIBIQM3HsbujGnko4w=";
      nova.hash = "sha256-sQF8ozH9nVA9jXUxUjnWbzB/PSjCKVLqtnL3DiNXFK8=";
      neutron.hash = "sha256-Czm2OdCJefuTtzDgsU4z8Uv5NqgN/YYIRIwEsfaw82g=";

      # Graphic user interface to Openstack services
      horizon = {
        chartVersion = "2025.2.1";
        hash = "sha256-XRCP6VFE3Ymw5lYkxymw8cGnUUAEwLTPd34zaVFzndY=";
      };
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
  };

  config = {
    # Template for file to pass as --vpn-auth-file
    sops.templates."k3s/vpn-auth".content = builtins.concatStringsSep "," [
      "name=tailscale"
      "joinKey=${config.sops.placeholder.tailscale-auth-key}"
      "extraArgs=${builtins.concatStringsSep " " config.services.tailscale.extraUpFlags}"
    ];

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

      autoDeployCharts =
        builtins.mapAttrs
          (
            name: value:
            (
              value
              // {
                package = charts.${name};
                createNamespace = true;
                targetNamespace = "openstack";
              }
            )
          )
          {
            # Identity and authentication service
            keystone = { };

            # Orchestration service
            heat = { };

            # Image service
            glance = { };

            # Block storage service
            cinder = { };

            # Compute kit backend
            openvswitch = { };
            libvirt = { };

            # Compute kit
            placement = { };
            nova = { };
            neutron = { };

            # Graphic user interface to Openstack services
            horizon = { };
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
