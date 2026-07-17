{
  description = "My NixOS flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lexis = {
      url ="github:EmanuelPeixoto/Lexis";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    llm-agents.url = "github:numtide/llm-agents.nix";
  };

  outputs = { nixpkgs, nixpkgs-stable, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          (final: prev: {
            stable = import nixpkgs-stable {
              inherit system;
              config.allowUnfree = true;
            };
          })
        ];
      };

      # List of systems to generate configurations
      systems = [ "note" "server" "light" ];

      # Function to generate a NixOS configuration
      mkNixosSystem = name:
        nixpkgs.lib.nixosSystem {
          inherit pkgs;
          modules = [
            ./system/${name}
            home-manager.nixosModules.home-manager
          ];
          specialArgs = { inherit inputs; };
        };

      # Function to generate a Home Manager configuration
      mkHomeConfig = name:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./hm/${name} ];
          extraSpecialArgs = { inherit inputs; };
        };

    in {
      nixosConfigurations = {
        NixOS-Note = mkNixosSystem "note";
        NixOS-Server = mkNixosSystem "server";
        NixOS-Light = mkNixosSystem "light";
        # Special case for the ISO
        NixOS-Note-ISO = nixpkgs.lib.nixosSystem {
          inherit pkgs;
          modules = [
            ./system/note/iso.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.emanuel = import ./hm/note;
                extraSpecialArgs = { inherit inputs; };
              };
            }
          ];
          specialArgs = { inherit inputs; };
        };
      };

      homeConfigurations = nixpkgs.lib.genAttrs systems (name: mkHomeConfig name);
    };
}
