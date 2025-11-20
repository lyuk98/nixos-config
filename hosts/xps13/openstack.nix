{
  pkgs,
  lib,
  inputs,
  ...
}:
let
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
  # Deploy Helm charts for OpenStack
  services.k3s.autoDeployCharts =
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
}
