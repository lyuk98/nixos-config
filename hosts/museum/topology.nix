{
  # Define this device in the topology
  topology.self = {
    deviceType = "nixos";

    # Hardware information
    hardware = {
      info = "Amazon Lightsail";
    };
    icon = "devices.cloud-server";

    # Connect to the internet
    interfaces.ens5.physicalConnections = [
      {
        node = "internet";
        interface = "*";
      }
    ];
  };
}
