{
  home.username = "emanuel";
  home.homeDirectory = "/home/emanuel";

  imports = [
    ../shared/btop.nix
    ../shared/git.nix
    ../shared/lexis.nix
    ../shared/yazi.nix
    ../shared/zsh.nix
    ./apps.nix
    ./dark_theme.nix
    ./dunst.nix
    ./eww.nix
    ./hyprland.nix
    ./hyprlock.nix
    ./keyring.nix
    ./kitty.nix
    ./minecraft-overlay.nix
    ./mpd.nix
    ./nextcloud-client.nix
    ./swww.nix
    ./zen_browser.nix
  ];

  home.stateVersion = "24.05";

  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "zen";
    TERMINAL = "kitty";
  };

  programs.home-manager.enable = true;
}
