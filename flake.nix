{
  description = "NixOS flake configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    nixvim.url = "github:EmanuelPeixoto/NixVim";
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
          ./nixos/configuration.nix
          home-manager.nixosModules.home-manager
        ];
        specialArgs = { inherit inputs; };
      };
    };
    homeConfigurations = {
      emanuel = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home-manager/home.nix ];
        extraSpecialArgs = { inherit inputs; };
      };
    };
  };
}
