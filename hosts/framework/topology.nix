{
  # Define this device in the topology
  topology.self = {
    deviceType = "nixos";

    # Hardware information
    hardware = {
      info = "Framework Laptop 13";
    };
    icon = "devices.laptop";

    # Network interfaces
    interfaces = {
      # Wireless network
      wlan0 = {
        icon = "interfaces.wifi";

        # Connect to the internet
        physicalConnections = [
          {
            node = "internet";
            interface = "*";
          }
        ];
      };
    };
  };
}
