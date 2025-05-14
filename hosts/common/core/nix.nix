{ lib, ... }:
{
  nix = {
    settings = {
      # Automatically optimise storage
      auto-optimise-store = lib.mkDefault true;

      # Enable experimental features
      experimental-features = [
        # Prevent rebuild when changes do not change the derivation's output
        "ca-derivations"

        # Enable flakes
        "flakes"

        # Enable nix subcommands
        "nix-command"
      ];

      # Add members of group "wheel" as trusted users
      trusted-users = [
        "root"
        "@wheel"
      ];
    };

    gc = lib.mkDefault {
      # Enable automatic garbage collection
      automatic = true;

      # Run garbage collection every week
      dates = "weekly";

      # Keep last 3 generations
      options = "--delete-older-than +3";
    };
  };
}
