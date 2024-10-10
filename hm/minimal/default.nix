{ pkgs, ... }:
{
  imports = [
    ../shared/btop.nix
    ../shared/git.nix
    ../shared/lexis.nix
    ../shared/yazi.nix
    ../shared/zsh.nix
  ];

  home.username = "emanuel";
  home.homeDirectory = "/home/emanuel";
  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    lazygit                   # Simple terminal UI for git commands
  ];

  programs.home-manager.enable = true;
}
