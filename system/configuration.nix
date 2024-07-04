{ ... }:
{
  imports = [
    ./apps.nix
    ./bluetooth.nix
    ./firewall.nix
    ./font.nix
    ./hardware-configuration.nix
    ./hotspot.nix
    # ./intel.nix
    ./locale.nix
    ./sound.nix
    ./steam.nix
    ./users.nix
    ./wireshark.nix
  ];

  # Hostname
  networking.hostName = "NixOS-Note";

  # Boot
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = false;

  # Experimental features
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  environment.sessionVariables.FLAKE = "/home/emanuel/NixOS";

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
