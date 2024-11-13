{ pkgs, ... }:
{
  imports = [
    ../shared/btop.nix
    ../shared/git.nix
    ../shared/lexis.nix
    ../shared/yazi.nix
    ../shared/zsh.nix
    # ./pm2.nix
  ];

  home = {
    homeDirectory = "/home/emanuel";
    stateVersion = "23.11";
    username = "emanuel";

    sessionVariables = {
      EDITOR = "nvim";
    };

    packages = with pkgs; [
      git
      htop
      progress
      ventoy-full
      wl-clipboard
      yazi
    ];
  };

  programs.home-manager.enable = true;
}
