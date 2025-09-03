{
  description = "My NixOS flake";

  inputs = {
    dsdfme.url = "github:lwvmobile/dsd-fme";
    home-manager.url = "github:nix-community/home-manager";
    lexis.url = "github:EmanuelPeixoto/Lexis";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    quickshell.url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
    quickshell.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:danth/stylix";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
  };

  outputs = { nixpkgs, nixpkgs-stable, home-manager, ... }@inputs:
    let
      lib = nixpkgs.lib;
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];

      forAllSystems = lib.genAttrs supportedSystems;

      overlay-stable = final: prev: {
        stable = import nixpkgs-stable {
          inherit (prev) system;
          config = {
            inherit (prev.config) allowUnfree;
          };
        };
      };

      mkPkgs = system: import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [ overlay-stable ];
      };

    in {
      pkgs = forAllSystems mkPkgs;

      nixosConfigurations = {
        NixOS-Note = lib.nixosSystem {
          system = "x86_64-linux";
          pkgs = mkPkgs "x86_64-linux";
          modules = [
            ./system/note
            home-manager.nixosModules.home-manager
          ];
          specialArgs = { inherit inputs; };
        };

        NixOS-Note-ISO = lib.nixosSystem {
          system = "x86_64-linux";
          pkgs = mkPkgs "x86_64-linux";
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

        NixOS-Server = lib.nixosSystem {
          system = "x86_64-linux";
          pkgs = mkPkgs "x86_64-linux";
          modules = [
            ./system/server
            home-manager.nixosModules.home-manager
          ];
          specialArgs = { inherit inputs; };
        };
      };

      homeConfigurations = {
        note = home-manager.lib.homeManagerConfiguration {
          pkgs = mkPkgs "x86_64-linux";
          modules = [ ./hm/note ];
          extraSpecialArgs = { inherit inputs; };
        };

        server = home-manager.lib.homeManagerConfiguration {
          pkgs = mkPkgs "x86_64-linux";
          modules = [ ./hm/server ];
          extraSpecialArgs = { inherit inputs; };
        };

        rpi3 = home-manager.lib.homeManagerConfiguration {
          pkgs = mkPkgs "aarch64-linux";
          modules = [ ./hm/rpi3 ];
          extraSpecialArgs = { inherit inputs; };
        };
      };
    };
}
