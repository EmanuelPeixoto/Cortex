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
    ../shared/user.nix
    ./apps.nix
  ];

  home.stateVersion = "24.11";
}
