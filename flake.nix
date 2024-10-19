{
  description = "My NixOS flake";
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
    systems = {
      x86_64-linux = "x86_64-linux";
      aarch64-linux = "aarch64-linux";
    };
    pkgsForSystem = system: import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    pkgs = {
      x86_64-linux = pkgsForSystem systems.x86_64-linux;
      aarch64-linux = pkgsForSystem systems.aarch64-linux;
    };
  in {
    devShells.${systems.x86_64-linux}.default =
      let
        hm = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgs.x86_64-linux;
          modules = [ ./hm/minimal ];
          extraSpecialArgs = { inherit inputs; };
        };
      in
      pkgs.x86_64-linux.mkShell {
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
          system = systems.x86_64-linux;
          modules = [
            ./system/note
            home-manager.nixosModules.home-manager
            sops-nix.nixosModules.sops
          ];
          specialArgs = { inherit inputs; };
        };
        NixOS-Server = nixpkgs.lib.nixosSystem {
          system = systems.x86_64-linux;
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
          pkgs = pkgs.x86_64-linux;
          modules = [ ./hm/note ];
          extraSpecialArgs = { inherit inputs; };
        };
        server = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgs.x86_64-linux;
          modules = [ ./hm/server ];
          extraSpecialArgs = { inherit inputs; };
        };
        rpi3 = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgs.aarch64-linux;
          modules = [ ./hm/rpi3 ];
          extraSpecialArgs = { inherit inputs; };
        };
      };
    };
  }
