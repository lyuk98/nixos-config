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

  # Create a chart archive
  packageHelmChart =
    { repo, name }:
    pkgs.stdenv.mkDerivation (finalAttrs: {
      name = "${name}.tgz";

      phases = [
        "unpackPhase"
        "patchPhase"
        "buildPhase"
      ];

      src = repo;

      postPatch = ''
        mkdir --parents --verbose ${name}/charts
        ${lib.pipe "${repo}/${name}/Chart.yaml" [
          # Read Chart.yaml
          builtins.readFile

          # Convert YAML to an attribute set
          kubelib.fromYAML
          (docs: builtins.elemAt docs 0)

          # Get dependencies
          (yaml: if (builtins.hasAttr "dependencies" yaml) then yaml.dependencies else [ ])

          # Create chart archives of dependencies
          (builtins.map (
            dependency:
            packageHelmChart {
              inherit repo;
              name = dependency.name;
            }
          ))

          # Command to copy each chart archive to where Helm expects
          (builtins.map (chart: "cp --verbose ${chart} ${name}/charts/"))
          (builtins.concatStringsSep "\n")
        ]}
      '';

      buildPhase = ''
        ${pkgs.kubernetes-helm}/bin/helm package ${name}
        cp --verbose ${name}-*.tgz $out
      '';
    });
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
                package = packageHelmChart {
                  repo = "${inputs.openstack-helm}";
                  name = name;
                };
                createNamespace = true;
                targetNamespace = "openstack";
              }
            )
          )
          {
            # OpenStack backend
            rabbitmq = {
              values = {
                pod.replicas.server = 1;
              };
            }; # Message broker
            mariadb = {
              values = {
                pod.replicas.server = 1;
              };
            }; # Backend database
            memcached = { }; # Distributed memory object caching system

            # OpenStack
            keystone = { }; # Identity and authentication service
            heat = { }; # Orchestration service
            glance = { }; # Image service
            cinder = { }; # Block storage service

            # Compute kit backend
            openvswitch = { }; # Networking backend
            libvirt = {
              values = {
                conf.ceph.enabled = true;
              };
            }; # Libvirt service

            # Compute kit
            placement = { }; # Placement service
            nova = {
              values = {
                bootstrap.wait_for_computes.enabled = true;
                conf.ceph.enabled = true;
              };
            }; # Compute service
            neutron = { }; # Networking service

            # Horizon
            horizon = { }; # Dashboard
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
