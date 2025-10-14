{ lib, config, ... }:
let
  # Read NetworkManager connection profiles
  connections = lib.pipe ./system-connections [
    builtins.readDir
    (lib.filterAttrs (_: type: type == "regular"))
    builtins.attrNames
    (builtins.filter (file: lib.hasSuffix ".nmconnection" file))
  ];
in
lib.mkIf config.networking.networkmanager.enable {
  # Retrieve secrets for NetworkManager connections
  sops.secrets =
    builtins.listToAttrs
      # Map each connection to an attribute set representing a SOPS secret
      (
        builtins.map (connection: {
          name = connection;
          value = {
            format = "binary";
            sopsFile = ./system-connections/${connection};
            neededForUsers = true;
          };
        }) connections
      );

  # Copy secrets into /etc
  environment.etc =
    builtins.listToAttrs
      # Map each connection to an attribute set representing a NetworkManager connection
      (
        builtins.map (connection: {
          name = "NetworkManager/system-connections/${connection}";
          value = {
            mode = "0600";
            source = config.sops.secrets.${connection}.path;
          };
        }) connections
      );
}
