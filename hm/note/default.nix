{
    imports = [
    ../shared/btop.nix
    ../shared/fastfetch.nix
    ../shared/git.nix
    ../shared/lexis.nix
    ../shared/nix-index.nix
    ../shared/tmux.nix
    ../shared/yazi.nix
    ../shared/zsh.nix
    ./apps.nix
    ./default-apps.nix
    ./dunst.nix
    ./firefox.nix
    ./ghostty.nix
    ./go.nix
    ./hypridle.nix
    ./hyprland.nix
    ./hyprlock.nix
    ./java.nix
    ./keepassxc.nix
    ./keyring.nix
    ./minecraft-overlay.nix
    ./mpd.nix
    ./nextcloud-client.nix
    ./obs.nix
    ./quickshell.nix
    ./stylix.nix
    ./swww.nix
    ./zen-browser.nix
  ];

  home = {
    homeDirectory = "/home/emanuel";
    stateVersion = "25.05";
    username = "emanuel";

    sessionVariables = {
      EDITOR = "nvim";
      BROWSER = "zen";
      TERMINAL = "ghostty";
    };
  };

  programs.home-manager.enable = true;
}
