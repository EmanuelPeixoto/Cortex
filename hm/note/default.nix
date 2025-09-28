{
    imports = [
    ../shared/btop.nix
    ../shared/fastfetch.nix
    ../shared/git.nix
    ../shared/lexis.nix
    ../shared/nix-index.nix
    ../shared/tmux.nix
    ../shared/user.nix
    ../shared/yazi.nix
    ../shared/zsh.nix
    ./apps.nix
    ./default-apps.nix
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
    ./thunderbird.nix
    ./zen-browser.nix
  ];

  home.stateVersion = "25.05";
}
