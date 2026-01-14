{ lib, config, ... }:
{
  programs.nh = {
    # Enable nh, yet another Nix CLI helper
    enable = true;

    clean = {
      # Enable periodic garbage collection
      enable = true;

      extraArgs = builtins.concatStringsSep " " [
        # Keep last 10 generations
        "--keep 10"

        # Keep generations for at least 3 days
        "--keep-since 3d"
      ];

      # Perform cleanup every week
      dates = "weekly";
    };
  };

  # Disable automatic garbage collection from Nix
  nix.gc.automatic = lib.mkIf config.programs.nh.clean.enable false;
}
