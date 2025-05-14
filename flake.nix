{
  description = "NixOS configuration";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # SOPS to store secrets
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Lanzaboote for secure boot
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NixOS profiles for different hardware
    hardware.url = "github:nixos/nixos-hardware";

    # nix-flatpak to declaratively manage Flatpak installations
    nix-flatpak.url = "github:gmodena/nix-flatpak";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      ...
    }:
    let
      inherit (self) outputs;
    in
    {
      # NixOS configuration entrypoint
      # Used with `nixos-rebuild switch --flake .#<hostname>`
      nixosConfigurations = {
        # Framework Laptop 13
        framework = nixpkgs.lib.nixosSystem {
          modules = [ ./hosts/framework ];
          specialArgs = { inherit inputs outputs; };
        };
      };

      # Home-manager configuration entrypoint
      # Used with `home-manager switch --flake .#<username>@<hostname>`
      homeConfigurations = {
        # lyuk98 @ Framework Laptop 13
        "lyuk98@framework" = home-manager.lib.homeManagerConfiguration {
          modules = [ ./home/lyuk98/framework.nix ];
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
        };
      };
    };
}
