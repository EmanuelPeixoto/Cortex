{ ... }:
{
  imports = [
    ../bluetooth.nix
    ../flake-config.nix
    ../locale.nix
    ../wireshark.nix
    ./apps.nix
    ./battery.nix
    ./custom-perms.nix
    ./firewall.nix
    ./font.nix
    ./hardware-configuration.nix
    ./hotspot.nix
    ./sound.nix
    ./steam.nix
    ./users.nix
  ];

  # Hostname
  networking.hostName = "NixOS-Note";

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.networkmanager.enable = true;

  programs = {
    dconf.enable = true;
    zsh.enable = true;
  };

  services = {
    blueman.enable = true;
    openssh.enable = true;
    vnstat.enable = true;
    logind.lidSwitch = "lock";
  };

  system.stateVersion = "23.11";
}
