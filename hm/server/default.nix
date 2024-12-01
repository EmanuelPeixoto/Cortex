{ pkgs, ... }:
{
  imports = [
    ../shared/btop.nix
    ../shared/git.nix
    ../shared/lexis.nix
    ../shared/yazi.nix
    ../shared/zsh.nix
  ];

  home = {
    homeDirectory = "/home/emanuel";
    stateVersion = "23.11";
    username = "emanuel";

    sessionVariables = {
      EDITOR = "nvim";
    };

    packages = with pkgs; [
      curl
      ffmpeg
      gcc
      iftop
      lazygit
      lm_sensors
      neofetch
      nload
      pciutils
      progress
      speedtest-cli
      unzip
      ventoy-full
      wget
      wl-clipboard
      yt-dlp
      zip
    ];
  };

  programs.home-manager.enable = true;
}
