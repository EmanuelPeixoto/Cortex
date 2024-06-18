{ ... }:
{
  home.username = "emanuel";
  home.homeDirectory = "/home/emanuel/";

  imports = [
    ./apps.nix
    ./dark_theme.nix
    ./eww.nix
    ./git.nix
    ./htop.nix
    ./hypr.nix
    ./kitty.nix
    ./minecraft-overlay.nix
    ./mpd.nix
    ./nextcloud.nix
    ./nixvim.nix
    ./swww.nix
    ./zsh.nix
  ];

  home.stateVersion = "23.11";

  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "firefox";
    TERMINAL = "kitty";
  };

  programs.home-manager.enable = true;
}
