{ lib, modulesPath, ... }:
{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-graphical-calamares.nix"
    ./default.nix
  ];

  boot.loader.timeout = lib.mkForce 10;
  boot.plymouth.enable = lib.mkForce false;
  networking.networkmanager.enable = lib.mkForce false;

  nixpkgs.hostPlatform = "x86_64-linux";
}
