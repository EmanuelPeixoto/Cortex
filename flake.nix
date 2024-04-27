{
  description = "NixOS flake configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-topology.url = "github:oddlama/nix-topology";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, nix-topology, ... }:
  let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      config = {
        overlays = [nix-topology.overlays.default];
        allowUnfree = true;
      };
    };

  in{
    nixosConfigurations = {
      NixOS-Note = nixpkgs.lib.nixosSystem {
        modules = [
          ./nixos/configuration.nix
          home-manager.nixosModules.home-manager
          nix-topology.nixosModules.default
        ];
      };
    };
    homeConfigurations = {
      emanuel = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home-manager/home.nix ];
      };
    };
    topology = import nix-topology {
      inherit pkgs;
      modules = [
      ./topology.nix
      { nixosConfigurations = self.nixosConfigurations; }
  ];
};
  };
}
