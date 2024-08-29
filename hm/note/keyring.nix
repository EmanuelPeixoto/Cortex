{ pkgs, ... }:
{
  home.packages = with pkgs; [
    seahorse
  ];

  services.gnome-keyring = {
    enable = true;
    components = ["pkcs11" "secrets" "ssh"];
  };}
