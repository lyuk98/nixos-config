{
  description = "NixOS configuration";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";

    # Nix User Repository
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Flake systems
    systems.url = "github:nix-systems/default-linux";

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
    hardware.url = "github:NixOS/nixos-hardware";

    # Declarative disk partitioning
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Used for declaration of impermanent systems
    impermanence.url = "github:nix-community/impermanence";

    # Generation of NixOS images
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nix-flatpak to declaratively manage Flatpak installations
    nix-flatpak.url = "github:gmodena/nix-flatpak";

    # Weekly updated database for nix-index
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Command-line interface for NixOS
    nixos-cli = {
      url = "github:nix-community/nixos-cli";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Provide extensions from Visual Studio Code Marketplace
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    # NixOS Vault service
    nixos-vault-service = {
      url = "github:DeterminateSystems/nixos-vault-service";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Patch containing PR under review (Ente)
    nixpkgs-ente-patch = {
      url = "https://patch-diff.githubusercontent.com/raw/NixOS/nixpkgs/pull/406847.patch";
      flake = false;
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-stable,
      home-manager,
      systems,
      nixos-generators,
      ...
    }:
    let
      inherit (self) outputs;

      forSystem =
        system: f:
        f rec {
          inherit system;
          pkgs = import nixpkgs { inherit system; };
          lib = pkgs.lib;
        };
      forAllSystems = f: nixpkgs.lib.genAttrs (import systems) (system: (forSystem system f));

      # Patch Nixpkgs to include unmerged PR
      nixpkgs-ente = (import nixpkgs { system = "x86_64-linux"; }).applyPatches {
        name = "nixos-unstable-ente";
        src = nixpkgs;
        patches = [ inputs.nixpkgs-ente-patch ];
      };
      nixos-system-ente = import ("${nixpkgs-ente}/nixos/lib/eval-config.nix");
    in
    {
      # Custom packages and image generators
      packages = forAllSystems (
        {
          pkgs,
          lib,
          system,
          ...
        }:
        (import ./packages { inherit pkgs; })
        // (import ./generators {
          inherit
            inputs
            pkgs
            lib
            system
            ;
        })
      );

      # Use nixfmt as formatter
      formatter = forAllSystems ({ pkgs, ... }: pkgs.nixfmt-rfc-style);

      # Overlays
      overlays = import ./overlays;

      # Development environment
      # Used with `nix develop` or `nix-shell`
      devShells = forAllSystems ({ pkgs, ... }: import ./shell.nix { inherit pkgs; });

      # NixOS configuration entrypoint
      # Used with `nixos-rebuild switch --flake .#<hostname>`
      nixosConfigurations = {
        # Framework Laptop 13
        framework = nixpkgs.lib.nixosSystem {
          modules = [ ./hosts/framework ];
          specialArgs = { inherit inputs outputs; };
        };
        # Museum instance
        museum = nixos-system-ente {
          system = "x86_64-linux";
          modules = [ ./hosts/museum ];
          specialArgs = { inherit inputs outputs; };
        };
        # Vault instance
        vault = nixpkgs-stable.lib.nixosSystem {
          modules = [ ./hosts/vault ];
          specialArgs = { inherit inputs outputs; };
        };
      };

      # Home-manager configuration entrypoint
      # Used with `home-manager switch --flake .#<username>@<hostname>`
      homeConfigurations = {
        # lyuk98 @ Framework Laptop 13
        "lyuk98@framework" = home-manager.lib.homeManagerConfiguration {
          modules = [ ./home/lyuk98/framework.nix ];
          pkgs = forSystem "x86_64-linux" ({ pkgs, ... }: pkgs);
          extraSpecialArgs = { inherit inputs outputs; };
        };
      };
    };
}
