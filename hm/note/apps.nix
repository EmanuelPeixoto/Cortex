{ pkgs, ... }:
let
  catfolder = import ../shared/scripts/catfolder.nix { inherit pkgs; };
  hotspot = import ./scripts/hotspot.nix { inherit pkgs; };
  motd = import ../shared/scripts/motd.nix { inherit pkgs; };
  yt-tlp-menu = import ../shared/scripts/yt-dlp-menu.nix { inherit pkgs; };
in
{
  home.packages = with pkgs; [
    catfolder
    hotspot
    motd
    yt-tlp-menu

    aircrack-ng
    android-tools
    audacity
    curl
    czkawka-full
    # davinci-resolve
    discord
    exfatprogs
    ffmpeg
    glibc
    gnumake
    iftop
    inetutils
    iw
    killall
    lazygit
    lm_sensors
    lshw
    ncdu
    netcat
    nload
    nmap
    nomacs
    openssl
    pciutils
    # platformio
    progress
    pwvucontrol
    qbittorrent
    qemu_kvm
    qpwgraph
    simple-mtpfs
    speedtest-cli
    stress
    telegram-desktop
    texliveSmall
    tor-browser
    unrar
    unzip
    usbutils
    vlc
    wget
    wl-clipboard
    yt-dlp
    zathura
    zip
  ];
}
