{
  description = "My NixOS flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
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
    lexis.url = "github:EmanuelPeixoto/Lexis";
  };

  outputs = { self, nixpkgs, nixpkgs-stable, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          (final: prev: {
            stable = import nixpkgs-stable {
              inherit system;
              config = prev.config;
            };
          })
        ];
      };
    in {
      nixosConfigurations = {
        NixOS-Note = nixpkgs.lib.nixosSystem {
          inherit pkgs;
          modules = [
            ./system/note
            home-manager.nixosModules.home-manager
          ];
          specialArgs = { inherit inputs; };
        };

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

        NixOS-Server = nixpkgs.lib.nixosSystem {
          inherit pkgs;
          modules = [
            ./system/server
            home-manager.nixosModules.home-manager
          ];
          specialArgs = { inherit inputs; };
        };
      };

      homeConfigurations = {
        note = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./hm/note ];
          extraSpecialArgs = { inherit inputs; };
        };

        server = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./hm/server ];
          extraSpecialArgs = { inherit inputs; };
        };
      };
    };
}
