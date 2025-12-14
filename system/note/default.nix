{
  imports = [
    ../shared/avahi.nix
    ../shared/bluetooth.nix
    ../shared/flake-config.nix
    ../shared/locale.nix
    ../shared/ssh.nix
    ./apps.nix
    ./battery.nix
    ./docker.nix
    ./firewall.nix
    ./hardware-configuration.nix
    ./hotspot.nix
    ./keyring.nix
    ./ly.nix
    ./nvidia.nix
    ./plymouth.nix
    ./postgres.nix
    ./rstudio.nix
    ./sdr.nix
    ./sound.nix
    ./steam.nix
    ./temp.nix
    ./users.nix
    ./webserver.nix
    ./wireshark.nix
  ];

  # Hostname
  networking.hostName = "NixOS-Note";

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Network Manager
  networking.networkmanager.enable = true;

  programs = {
    dconf.enable = true;
    hyprland.enable = true;
    zsh.enable = true;
  };

  services = {
    upower.enable = true;
    vnstat.enable = true;
  };

  # Hyprlock pam
  security.pam.services.hyprlock = {};
  services.logind.settings.Login.HandleLidSwitch = "lock";

  system.stateVersion = "25.05";
}
