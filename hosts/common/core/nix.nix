{ lib, ... }:
{
  nix = {
    settings = {
      # Automatically optimise storage
      auto-optimise-store = lib.mkDefault true;

      # Set download buffer size to 128MiB by default
      download-buffer-size = lib.mkDefault 134217728;

      # Enable experimental features
      experimental-features = [
        # Prevent rebuild when changes do not change the derivation's output
        "ca-derivations"

        # Enable flakes
        "flakes"

        # Enable nix subcommands
        "nix-command"
      ];

      # Add binary caches
      substituters = [
        "https://nix-community.cachix.org"
      ];

      # Add trusted public keys for the binary caches
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
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

      # Keep last 10 generations
      options = "--delete-older-than +10";
    };
  };
}
