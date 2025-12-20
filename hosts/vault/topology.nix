{
  imports = [
    ../common/optional/nix-topology/networks/digitalocean.nix
  ];

  # Define this device in the topology
  topology.self = {
    deviceType = "nixos";

    # Hardware information
    hardware = {
      info = "DigitalOcean Droplet";
    };
    icon = "devices.cloud-server";

    # Network interfaces
    interfaces = {
      # Wired network
      ens3 = {
        icon = "interfaces.ethernet";

        # Connect to the internet
        physicalConnections = [
          {
            node = "internet";
            interface = "*";
          }
        ];
      };

      # Virtual Private Cloud (VPC) network
      ens4 = {
        icon = "interfaces.ethernet";
        network = "digitalocean";
      };
    };
  };
}
