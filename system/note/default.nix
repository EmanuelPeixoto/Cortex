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
    ./scti.nix
    ./sound.nix
    ./steam.nix
    ./users.nix
  ];

  boot = {
    plymouth = {
      enable = true;
      theme = "breeze";
      # logo = "/home/emanuel/Downloads/apple.png";
    };

  # Enable "Silent Boot"
  consoleLogLevel = 0;
  initrd.verbose = false;
  kernelParams = [
    "quiet"
    "splash"
    "boot.shell_on_fail"
    "loglevel=3"
    "rd.systemd.show_status=false"
    "rd.udev.log_level=3"
    "udev.log_priority=3"
  ];
    # Hide the OS choice for bootloaders.
    # It's still possible to open the bootloader list by pressing any key
    # It will just not appear on screen unless a key is pressed
    loader.timeout = 0;
  };


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
    hyprland.enable = true;
  };

  services = {
    blueman.enable = true;
    openssh.enable = true;
    vnstat.enable = true;
    displayManager.ly.enable = true;
  };

  system.stateVersion = "24.05";
}
