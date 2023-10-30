{
  description = "My NixOS config in flake";


  inputs ={
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
  };

  outputs = { self, nixpkgs }:
  let
    system = "x86_64-Linux";

    pkgs = import nixpkgs {
      inherit system;

      config = {
        allowUnfree = true;
      };

    };
  in{
    nixosConfigurations = {
      nixconf = nixpkgs.lib.nixosSystem {
        modules = [
          ./nixos/configuration.nix
        ];
      };
    };
  };
}
