{
  imports = [
    ../bluetooth.nix
    ../flake-config.nix
    ../locale.nix
    ../scti.nix
    ../wireshark.nix
    ./apps.nix
    ./battery.nix
    ./firewall.nix
    ./font.nix
    ./hardware-configuration.nix
    ./hotspot.nix
    ./keyring.nix
    ./ly.nix
    ./plymouth.nix
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
  };

  system.stateVersion = "24.05";
}
