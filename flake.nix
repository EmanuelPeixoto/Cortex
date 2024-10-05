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
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { nixpkgs, home-manager, sops-nix, ... }@inputs:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    devShells.${system}.default =
      let
        hm = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./hm/minimal ];
          extraSpecialArgs = { inherit inputs; };
        };
      in
      pkgs.mkShell {
        packages = [ hm.activationPackage ];
        shellHook = ''
          ${hm.activationPackage}/activate
          if [ -x "$(command -v zsh)" ]; then
          exec zsh
          fi
        '';
      };
      nixosConfigurations = {
        NixOS-Note = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./system/note
            home-manager.nixosModules.home-manager
            sops-nix.nixosModules.sops
          ];
          specialArgs = { inherit inputs; };
        };
        NixOS-Server = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./system/server
            home-manager.nixosModules.home-manager
            sops-nix.nixosModules.sops
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
