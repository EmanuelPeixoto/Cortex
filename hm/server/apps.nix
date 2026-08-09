{ pkgs, ... }:
let
  catfolder = import ../shared/scripts/catfolder.nix { inherit pkgs; };
  motd = import ../shared/scripts/motd.nix { inherit pkgs; };
  yt-tlp-menu = import ../shared/scripts/yt-dlp-menu.nix { inherit pkgs; };
in
{
  home.packages = with pkgs; [
    catfolder
    motd
    yt-tlp-menu

    curl
    ffmpeg
    gcc
    gnumake
    iftop
    lazygit
    lm_sensors
    ncdu
    nload
    pciutils
    progress
    speedtest-cli
    unzip
    # ventoy
    wget
    wl-clipboard
    yt-dlp
    zip
  ];
}
