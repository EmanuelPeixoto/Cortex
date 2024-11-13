{
  imports = [
    ../shared/bluetooth.nix
    ../shared/flake-config.nix
    ../shared/locale.nix
    ../shared/wireshark.nix
    ./apps.nix
    ./battery.nix
    ./firewall.nix
    ./font.nix
    ./hardware-configuration.nix
    ./hotspot.nix
    ./keyring.nix
    ./ly.nix
    ./plymouth.nix
    ./postgres.nix
    ./sound.nix
    ./steam.nix
    ./temp.nix
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

  # Hyprlock pam
  security.pam.services.hyprlock = {};

  system.stateVersion = "24.05";
}
