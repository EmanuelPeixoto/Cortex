{lib, config, pkgs, ... }:
{


  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };
  home.packages = with pkgs; [
    aircrack-ng
    alacritty
    arduino
    arduino-cli
    audacity
    curl
    discord
    dmenu
    elixir
    exfatprogs
    f3
    ffmpeg
    firefox
    gcc
    gdb
    gh
    gimp
    git
    glibc
    glxinfo
    gnumake
    gnupg
    go
    gotty
    gparted
    htop
    iftop
    jdk
    jmtpfs
    killall
    libmtp
    libreoffice
    libva-utils
    lm_sensors
    lshw
    maim
    mixxx
    mpv
    ncmpcpp
    neofetch
    nload
    nmap
    nodejs_20
    nomacs
    obs-studio
    openshot-qt
    pamixer
    paprefs
    pavucontrol
    pciutils
    pkg-config
    playerctl
    pmutils
    postgresql
    prismlauncher
    pulseaudioFull
    qbittorrent
    ranger
    speedtest-cli
    stress
    telegram-desktop
    tetex
    thunderbird
    tor
    tor-browser-bundle-bin
    unzip
    usbutils
    ventoy-full
    vlc
    vulkan-tools
    wget
    wine
    xclip
    xfce.thunar
    xorg.xinit
    yt-dlp
    zip
  ];

}
