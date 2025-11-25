{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
  # Functions for K3s modules
  k3slib = config.services.k3s.lib;

  # Import nix-kube-generators
  kubelib = inputs.nix-kube-generators.lib { inherit pkgs; };

  # Helm charts from nixhelm
  charts = inputs.nixhelm.charts { inherit pkgs; };

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
    # Charts from nixhelm
    (builtins.mapAttrs
      (
        name: value:
        (
          {
            package = k3slib.packageHelmChart value.package;
            createNamespace = true;
            targetNamespace = "openstack";
          }
          // (lib.filterAttrs (name: _: name != "package") value)
        )
      )
      {
        traefik-proxy = {
          package = charts.traefik.traefik;
          values = {
            deployment = {
              podLabels = {
                # Add label used by OpenStack-Helm
                app = "ingress-api";
              };
            };

            additionalArguments = [
              # Do not check for new versions
              "--global.checknewversion=false"
            ];

            service = {
              annotations = {
                # Expose service to Tailscale
                "tailscale.com/expose" = "true";
              };
            };
          };
        };

        # Rook Ceph Operator for managing Ceph clusters
        rook-ceph = {
          package = charts.rook-release.rook-ceph;

          createNamespace = true;
          targetNamespace = "rook-ceph";

          values = {
            allowLoopDevices = true;
            
            # Disable CephFS driver as OpenStack-Helm does not use the file system
            csi.enableCephfsDriver = false;
          };
        };

        # Ceph cluster
        rook-ceph-cluster = {
          package = charts.rook-release.rook-ceph-cluster;

          createNamespace = true;
          targetNamespace = "ceph";

          values = {
            cephClusterSpec = {
              dataDirHostPath = "/var/lib/rook";

              storage = {
                devices = {
                  name = "/dev/zvol/zroot/root/ceph";
                };
              };
            };

            cephBlockPools = [
              {
                spec = {
                  replicated = {
                    size = 1;
                    requireSafeReplicaSize = false;
                  };
                };
                storageClass = {
                  # Set name of the StorageClass to what OpenStack-Helm expects
                  name = "general";
                };
              }
            ];

            operatorNamespace = "rook-ceph";
          };
        };
      }
    )
    # OpenStack-Helm components
    // (builtins.mapAttrs
      (
        name: value:
        (
          {
            package = packageHelmChart {
              repo = "${inputs.openstack-helm}";
              name = name;
            };
            createNamespace = true;
            targetNamespace = "openstack";
          }
          // value
        )
      )
      {
        # Enable using Ceph for services depoyed by OpenStack-Helm charts
        ceph-adapter-rook = { };

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
      }
    );
}
