{
  imports = [
    ../shared/avahi.nix
    ../shared/flake-config.nix
    ../shared/locale.nix
    ../shared/ssh.nix
    ./acme.nix
    ./apps.nix
    ./backup.nix
    ./docker.nix
    ./firewall.nix
    ./hardware-configuration.nix
    ./nextcloud
    ./nvidia.nix
    ./qbittorrent.nix
    # ./rstudio.nix
    ./smartd.nix
    ./steam.nix
    ./sunshine.nix
    ./tailscale.nix
    ./users.nix
    ./web
    ./zfs.nix
  ];

  # Networking
  networking = {
    hostName = "NixOS-Server";
    networkmanager.enable = true;
  };

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  programs = {
    dconf.enable = true;
    zsh.enable = true;
  };

  services = {
    vnstat.enable = true;
  };

  system.stateVersion = "24.11";
}
