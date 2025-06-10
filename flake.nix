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

    # nix-flatpak to declaratively manage Flatpak installations
    nix-flatpak.url = "github:gmodena/nix-flatpak";

    # Weekly updated database for nix-index
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Provide extensions from Visual Studio Code Marketplace
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    # Temporary input to use Microsoft Edit
    nur-packages-dtomvan = {
      url = "github:dtomvan/nur-packages";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      systems,
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
      # Custom packages
      packages = forAllSystems ({ pkgs, ... }: import ./packages { inherit pkgs; });

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
