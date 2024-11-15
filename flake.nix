{
  description = "My NixOS flake";
  inputs = {
    ags.url = "github:aylur/ags";
    home-manager.url = "github:nix-community/home-manager";
    lexis.url = "github:EmanuelPeixoto/Lexis";
    nix-colors.url = "github:misterio77/nix-colors";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    sops-nix.url = "github:Mic92/sops-nix";
    zen-browser.url = "github:MarceColl/zen-browser-flake";
  };
  outputs = { nixpkgs, nixpkgs-stable, home-manager, sops-nix, ... }@inputs:
  let
    systems = {
      x86_64-linux = "x86_64-linux";
      aarch64-linux = "aarch64-linux";
    };
    overlay-stable = final: prev: {
      stable = import nixpkgs-stable {
        system = prev.system;
        config.allowUnfree = true;
      };
    };
    pkgsForSystem = system: import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [ overlay-stable ];
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
