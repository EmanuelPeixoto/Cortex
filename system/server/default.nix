{
  imports = [
    ../shared/avahi.nix
    ../shared/flake-config.nix
    ../shared/locale.nix
    # ./acme.nix
    ./apps.nix
    ./firewall.nix
    ./hardware-configuration.nix
    ./minecraft-server.nix
    ./nextcloud.nix
    ./nginx.nix
    ./noip.nix
    ./nvidia.nix
    ./php.nix
    ./qbittorrent.nix
    ./ssh.nix
    ./swap.nix
    ./users.nix
  ];

  # Hostname
  networking.hostName = "NixOS-Server";

  # Boot
  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
    useOSProber = false;
  };

  # Networking
  networking.networkmanager.enable = true;

  programs = {
    dconf.enable = true;
    zsh.enable = true;
  };

  services = {
    vnstat.enable = true;
  };

  system.stateVersion = "24.11";
}
