{
  description = "NixOS configuration";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";

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

    # Declarative management of non-volatile system state
    preservation.url = "github:nix-community/preservation";

    # Generation of NixOS images
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Weekly updated database for nix-index
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Generation of infrastructure and network diagrams
    nix-topology = {
      url = "github:oddlama/nix-topology";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Command-line interface for NixOS
    nixos-cli.url = "github:nix-community/nixos-cli";

    # Provide extensions from Visual Studio Code Marketplace
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    # NixOS Vault service
    nixos-vault-service = {
      url = "github:DeterminateSystems/nixos-vault-service";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Zen Browser
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    # Icons for services
    dashboard-icons = {
      url = "github:homarr-labs/dashboard-icons";
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
      nix-topology,
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
    in
    {
      packages = forAllSystems (
        {
          pkgs,
          lib,
          system,
          ...
        }:
        # Custom packages
        (import ./packages { inherit pkgs; })
        # Image generators
        // (import ./generators {
          inherit
            inputs
            pkgs
            lib
            system
            ;
        })
        # System topology
        // {
          topology = import nix-topology {
            pkgs = import nixpkgs {
              inherit system;
              overlays = [ nix-topology.overlays.default ];
            };
            modules = [
              { nixosConfigurations = self.nixosConfigurations; }
            ];
          };
        }
      );

      # Use nixfmt as formatter
      formatter = forAllSystems ({ pkgs, ... }: pkgs.nixfmt);

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
        museum = nixpkgs.lib.nixosSystem {
          modules = [ ./hosts/museum ];
          specialArgs = { inherit inputs outputs; };
        };
        # Vault instance
        vault = nixpkgs-stable.lib.nixosSystem {
          modules = [ ./hosts/vault ];
          specialArgs = { inherit inputs outputs; };
        };
        # Dell XPS 13 9350
        xps13 = nixpkgs.lib.nixosSystem {
          modules = [ ./hosts/xps13 ];
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
