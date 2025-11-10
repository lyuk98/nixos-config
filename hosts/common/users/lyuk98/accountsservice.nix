{
  pkgs,
  lib,
  config,
  ...
}:
let
  # Fetch profile image
  icon = pkgs.fetchurl {
    url = "https://images.lyuk98.com/d62b0835-9b50-419b-a59e-724390310383.png";
    hash = "sha256-YLEisgWUDZtMA0jI3MxqFbMt+UD/XRINcksjJiEjPHE=";
  };

  # Write AccountsService user entry
  user = pkgs.writeText "accountsservice-user-lyuk98" ''
    [User]
    Session=
    Icon=${icon}
    SystemAccount=false
  '';
in
lib.mkIf config.services.accounts-daemon.enable {
  systemd.tmpfiles.settings = {
    # Copy the user entry
    "accountsservice-user-lyuk98" = {
      "/var/lib/AccountsService/users/lyuk98" = {
        "C+" = {
          mode = "0600";
          user = "root";
          group = "root";
          argument = "${user}";
        };
      };
    };
  };
}
