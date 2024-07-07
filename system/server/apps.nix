{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    curl
    ffmpeg
    gcc
    iftop
    lm_sensors
    neofetch
    nh
    nix-output-monitor
    nload
    nodePackages.node-pre-gyp
    nodePackages.pm2
    nodejs_20
    noip
    nvd
    pciutils
    php
    php81Extensions.zip
    php81Packages.composer
    qbittorrent-nox
    speedtest-cli
    unzip
    wget
    yt-dlp
    zip
  ];
}
