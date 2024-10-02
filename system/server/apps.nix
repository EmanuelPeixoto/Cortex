{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    curl
    ffmpeg
    gcc
    go
    iftop
    lm_sensors
    neofetch
    nh
    nix-output-monitor
    nload
    noip
    nvd
    pciutils
    php
    qbittorrent-nox
    speedtest-cli
    unzip
    wget
    yt-dlp
    zip
  ];
}
