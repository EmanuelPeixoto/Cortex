{
  imports = [
    ../shared/btop.nix
    ../shared/fastfetch.nix
    ../shared/git.nix
    ../shared/ia.nix
    ../shared/nix-index.nix
    ../shared/tmux.nix
    ../shared/user.nix
    ../shared/yazi.nix
    ../shared/zsh.nix
    ./apps.nix
    ./lexis.nix
    ./virtual-monitor.nix
  ];

  home.stateVersion = "24.11";
}
