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

  # Create symlinks to NetworkManager connections
  systemd.tmpfiles.settings = builtins.listToAttrs (
    builtins.map (connection: {
      name = "system-connection-${lib.removeSuffix ".nmconnection" connection}";
      value = {
        "/run/NetworkManager/system-connections/${connection}" = {
          "L+" = {
            mode = "0600";
            user = "root";
            group = "root";
            argument = config.sops.secrets.${connection}.path;
          };
        };
      };
    }) connections
  );
}
