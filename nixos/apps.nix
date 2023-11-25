{lib, config, pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
  curl
  elixir
  ffmpeg
  font-manager
  gcc
  gdb
  gh
  git
  glibc
  glxinfo
  gnat
  gnumake
  gnupg
  gparted
  home-manager
  htop
  iftop
  insomnia
  jdk
  jmtpfs
  kate
  killall
  libfprint
  libmtp
  libpulseaudio
  libreoffice
  libva-utils
  lm_sensors
  lshw
  maim
  mesa-demos
  mpv
  neofetch
  neovim
  ngrok
  nload
  nmap
  pamixer
  paprefs
  pavucontrol
  pciutils
  pkg-config
  playerctl
  postgresql
  pulseaudioFull
  ranger
  speedtest-cli
  steam-run
  steam-tui
  stress
  tetex
  texstudio
  unzip
  usbutils
  vlc
  vscode
  vulkan-tools
  wget
  xclip
  xfce.thunar
  xorg.xinit
  yt-dlp
  zip
  ];


}
