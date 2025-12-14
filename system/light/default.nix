{
  imports = [
    ../note/apps.nix
    ../note/firewall.nix
    ../note/hotspot.nix
    ../note/keyring.nix
    ../note/ly.nix
    ../note/plymouth.nix
    ../note/sdr.nix
    ../note/sound.nix
    ../note/temp.nix
    ../note/users.nix
    ../note/webserver.nix
    ../note/wireshark.nix
    ../shared/avahi.nix
    ../shared/bluetooth.nix
    ../shared/flake-config.nix
    ../shared/locale.nix
    ../shared/ssh.nix
    ./amd.nix
    ./apps.nix
    ./hardware-configuration.nix
    ./power.nix
    ./xserver.nix
    ./zram.nix
  ];

  # Hostname
  networking.hostName = "NixOS-Light";

  # Boot
  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
  };

  # Network Manager
  networking.networkmanager.enable = true;

  programs = {
    dconf.enable = true;
    zsh.enable = true;
  };

  system.stateVersion = "25.05";
}
