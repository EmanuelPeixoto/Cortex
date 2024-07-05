{
  description = "NixOS flake configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    lexis.url = "github:EmanuelPeixoto/Lexis";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, ... }@inputs:
  let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

  in {
    nixosConfigurations = {
      NixOS-Note = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./system/note
          home-manager.nixosModules.home-manager
        ];
        specialArgs = { inherit inputs; };
      };
      NixOS-Server = nixpkgs.lib.nixosSystem {
        inherit system;
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
