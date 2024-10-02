{
  home.username = "emanuel";
  home.homeDirectory = "/home/emanuel";

  imports = [
    ../btop.nix
    ../git.nix
    ../lexis.nix
    ../yazi.nix
    ../zsh.nix
    ./apps.nix
    ./dark_theme.nix
    ./dunst.nix
    ./eww.nix
    ./hypr.nix
    ./keyring.nix
    ./kitty.nix
    ./minecraft-overlay.nix
    ./mpd.nix
    ./nextcloud-client.nix
    ./swww.nix
    ./temp.nix
    ./zen_browser.nix
  ];

  home.stateVersion = "24.05";

  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "firefox";
    TERMINAL = "kitty";
  };

  programs.home-manager.enable = true;
}
