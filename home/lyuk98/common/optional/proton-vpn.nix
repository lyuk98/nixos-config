{
  pkgs,
  lib,
  osConfig,
  ...
}:
let
  # The package to use for Proton VPN
  pkg = pkgs.proton-vpn-cli;

  # The NetworkManager package, following the system package if possible
  networkmanager =
    if (!builtins.isNull osConfig) then
      osConfig.networking.networkmanager.package
    else
      pkgs.networkmanager;
in
{
  # Add Proton VPN CLI app
  home.packages = [ pkg ];

  # Automatically start Proton VPN upon startup
  systemd.user.services.proton-vpn-cli-autostart = {
    Unit = {
      Description = "Automatically start Proton VPN upon startup";
      Wants = [ "network-online.target" ];
      After = [ "network-online.target" ];
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
    Service = {
      Type = "oneshot";
      ExecStartPre = lib.getExe' networkmanager "nm-online";
      ExecStart = "${lib.getExe pkg} connect";
    };
  };
}
