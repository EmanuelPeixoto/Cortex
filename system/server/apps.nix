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
    nodePackages.node-pre-gyp
    nodePackages.pm2
    nodejs_22
    noip
    nvd
    pciutils
    php
    php83Extensions.zip
    php83Packages.composer
    qbittorrent-nox
    speedtest-cli
    unzip
    wget
    yt-dlp
    zip
  ];
}
