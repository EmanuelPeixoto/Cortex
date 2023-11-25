{
  description = "My NixOS config in flake";


  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };


  outputs = { self, nixpkgs, home-manager, ... }:
  let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
      };
    };

  in{
    nixosConfigurations = {
      nixconf = nixpkgs.lib.nixosSystem {
        modules = [ ./nixos/configuration.nix ];
      };
    };
    homeConfigurations = {
      emanuel = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home-manager/home.nix ];
      };
    };
  };
}
