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
    stateVersion = "24.05";
    username = "emanuel";

    packages = with pkgs; [
      lazygit                   # Simple terminal UI for git commands
    ];
  };

  programs.home-manager.enable = true;
}
