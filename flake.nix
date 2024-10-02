{
  description = "My NixOS flake, with home-manager, system (server and notebook) and minimal configuration to be used with shell";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    lexis.url = "github:EmanuelPeixoto/Lexis";
    zen-browser.url = "github:MarceColl/zen-browser-flake";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
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

      minimal = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./hm/minimal ];
      };
    };

    defaultPackage.${system} = self.homeConfigurations.minimal.activationPackage;
  };
}
