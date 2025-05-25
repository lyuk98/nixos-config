{ pkgs, lib, ... }:
{
  # Allow unfree packages for Steam
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "steam"
      "steam-unwrapped"
    ];

  programs.steam = {
    # Enable Steam
    enable = true;

    # Open ports for Steam Remote Play
    remotePlay.openFirewall = true;

    # Open ports for Steam Local Network Game Transfers
    localNetworkGameTransfers.openFirewall = true;

    # Open ports for Source Dedicated Server
    dedicatedServer.openFirewall = true;

    # Add extra compatibility tools
    extraCompatPackages = [
      pkgs.proton-ge-bin
    ];

    # Enable Protontricks
    protontricks.enable = true;
  };
}
