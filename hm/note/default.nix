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
    ./ghostty.nix
    ./go.nix
    ./hypridle.nix
    ./hyprland.nix
    ./hyprlock.nix
    ./keyring.nix
    ./minecraft-overlay.nix
    ./mpd.nix
    ./nextcloud-client.nix
    ./nix-index.nix
    ./obs.nix
    ./stylix.nix
    ./swww.nix
    ./zen-browser.nix
  ];

  home = {
    homeDirectory = "/home/emanuel";
    stateVersion = "24.11";
    username = "emanuel";

    sessionVariables = {
      EDITOR = "nvim";
      BROWSER = "zen";
      TERMINAL = "ghostty";
    };
  };

  programs.home-manager.enable = true;
}
