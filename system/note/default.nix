{ ... }:
{
  imports = [
    ../bluetooth.nix
    ../flake-config.nix
    ../locale.nix
    ../wireshark.nix
    ./apps.nix
    ./custom-perms.nix
    ./firewall.nix
    ./font.nix
    ./hardware-configuration.nix
    ./hotspot.nix
    # ./intel.nix
    ./sound.nix
    ./steam.nix
    ./users.nix
  ];

  # Hostname
  networking.hostName = "NixOS-Note";

  # Boot
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = false;

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
