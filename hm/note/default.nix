{ ... }:
{
  home.username = "emanuel";
  home.homeDirectory = "/home/emanuel";

  imports = [
    ../git.nix
    ../htop.nix
    ../lexis.nix
    ../yazi.nix
    ../zsh.nix
    ./apps.nix
    ./dark_theme.nix
    ./eww.nix
    ./hypr.nix
    ./keyring.nix
    ./kitty.nix
    ./minecraft-overlay.nix
    ./mpd.nix
    ./nextcloud-client.nix
    ./swww.nix
  ];

  home.stateVersion = "24.05";

  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "firefox";
    TERMINAL = "kitty";
  };

  programs.home-manager.enable = true;
}
