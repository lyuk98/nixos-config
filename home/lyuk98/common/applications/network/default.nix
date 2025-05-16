{
  lib,
  config,
  ...
}:
{
  imports = [
    ./discord.nix
    ./firefox.nix
    ./proton-vpn.nix
    ./signal-desktop.nix
  ];

  # Create option to enable all Network applications
  options.applications.network.enable = lib.mkEnableOption "all Network applications";

  # Enable all Network applications if enabled
  config.applications.network = lib.mkIf config.applications.network.enable {
    discord.enable = lib.mkDefault true;
    firefox.enable = lib.mkDefault true;
    proton-vpn.enable = lib.mkDefault true;
    signal-desktop.enable = lib.mkDefault true;
  };
}
