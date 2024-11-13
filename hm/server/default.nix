{ pkgs, ... }:
{
  home.username = "emanuel";
  home.homeDirectory = "/home/emanuel";

  imports = [
    ../shared/btop.nix
    ../shared/git.nix
    ../shared/lexis.nix
    ../shared/yazi.nix
    ../shared/zsh.nix
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
    lazygit
    progress
    ventoy-full
    wl-clipboard
    yazi
  ];

  programs.home-manager.enable = true;
}
