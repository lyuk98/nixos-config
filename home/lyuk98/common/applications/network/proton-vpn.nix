{
  pkgs,
  lib,
  config,
  osConfig,
  ...
}:
{
  options.applications.network.proton-vpn = {
    # Create option to enable Proton VPN
    enable = lib.mkEnableOption "Proton VPN";

    # Create option to enable autostart for Proton VPN
    autostart.enable = lib.mkOption {
      default = true;
      example = false;
      description = "Whether to enable autostart for Proton VPN";
      type = lib.types.bool;
    };
  };

  config =
    let
      pkg = pkgs.protonvpn-gui;
      networkmanager =
        if (!builtins.isNull osConfig) then
          osConfig.networking.networkmanager.package
        else
          pkgs.networkmanager;
    in
    lib.mkIf config.applications.network.proton-vpn.enable {
      # Add packages
      home.packages = [ pkg ];

      # Enable automatic startup of the application
      systemd.user.services.proton-vpn-autostart =
        lib.mkIf config.applications.network.proton-vpn.autostart.enable
          {
            Unit = {
              Description = "Automatically start Proton VPN upon startup";
              After = [ "graphical-session.target" ];
            };
            Install = {
              WantedBy = [ "graphical-session.target" ];
            };
            Service = {
              Type = "simple";
              ExecStartPre = "${networkmanager}/bin/nm-online";
              ExecStart = lib.getExe pkg;
            };
          };
    };
}
