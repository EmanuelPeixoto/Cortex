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
    gopls
    gotty
    gparted
    htop
    iftop
    jdk
    jmtpfs
    kate
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
    obs-studio
    openshot-qt
    pamixer
    paprefs
    pavucontrol
    pciutils
    pkg-config
    playerctl
    postgresql
    pulseaudioFull
    qbittorrent
    ranger
    speedtest-cli
    stress
    telegram-desktop
    tetex
    texstudio
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
