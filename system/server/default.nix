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
    ./remote-build.nix
    ./rstudio.nix
    ./smartd.nix
    # ./steam.nix
    ./sunshine.nix
    ./users.nix
    ./web
    ./zfs.nix
  ];

  # Hostname
  networking.hostName = "NixOS-Server";

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
    vnstat.enable = true;
  };

  system.stateVersion = "24.11";
}
