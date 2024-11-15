{
    imports = [
    ../shared/btop.nix
    ../shared/git.nix
    ../shared/lexis.nix
    ../shared/yazi.nix
    ../shared/zsh.nix
    ./ags.nix
    ./apps.nix
    ./default-apps.nix
    ./dunst.nix
    ./eww.nix
    ./go.nix
    ./hypridle.nix
    ./hyprland.nix
    ./hyprlock.nix
    ./keyring.nix
    ./kitty.nix
    ./minecraft-overlay.nix
    ./mpd.nix
    ./nextcloud-client.nix
    ./nix-colors.nix
    ./nix-index.nix
    ./swww.nix
    ./theme.nix
    ./zen-browser.nix
  ];

  home = {
    homeDirectory = "/home/emanuel";
    stateVersion = "24.05";
    username = "emanuel";

    sessionVariables = {
      EDITOR = "nvim";
      BROWSER = "zen";
      TERMINAL = "kitty";
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";
    };
  };

  programs.home-manager.enable = true;
}
