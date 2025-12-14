{
    imports = [
    ../note/clipse.nix
    ../note/default-apps.nix
    ../note/firefox.nix
    ../note/keepassxc.nix
    ../note/keyring.nix
    ../note/minecraft-overlay.nix
    ../note/mpd.nix
    ../note/nextcloud-client.nix
    ../note/stylix.nix
    ../note/thunderbird.nix
    ../note/zen-browser.nix
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
    ./dwm
    ./kitty.nix
  ];

  home.stateVersion = "25.05";
}
