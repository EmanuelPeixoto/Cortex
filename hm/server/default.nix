{ pkgs, ... }:
{
  home.username = "emanuel";
  home.homeDirectory = "/home/emanuel/";

  imports = [
    ../git.nix
    ../htop.nix
    ../lexis.nix
    ../zsh.nix
    # ./pm2.nix
  ];

  home.stateVersion = "23.11"; # Please read the comment before changing.

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  home.packages = with pkgs; [
    git
    htop
    progress
    ventoy-full
    wl-clipboard
    yazi
  ];

  programs.home-manager.enable = true;
}
