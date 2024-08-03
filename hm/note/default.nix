{ ... }:
{
  home.username = "emanuel";
  home.homeDirectory = "/home/emanuel";

  imports = [
    ../git.nix
    ../htop.nix
    ../lexis.nix
    ../zsh.nix
    ./apps.nix
    ./battery.nix
    ./dark_theme.nix
    ./eww.nix
    ./hypr.nix
    ./kitty.nix
    ./mpd.nix
    ./nextcloud-client.nix
    ./swww.nix
  ];

  home.stateVersion = "23.11";

  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "firefox";
    TERMINAL = "kitty";
  };

  programs.home-manager.enable = true;
}
