{
  home.username = "emanuel";
  home.homeDirectory = "/home/emanuel";

  imports = [
    ../shared/btop.nix
    ../shared/git.nix
    # ../shared/lexis.nix
    ../shared/yazi.nix
    ../shared/zsh.nix
    ../note/apps.nix
    # ./default-apps.nix
    ../note/dunst.nix
    ../note/eww.nix
    ../note/hypridle.nix
    ../note/hyprland.nix
    ../note/hyprlock.nix
    # ./keyring.nix
    ../note/kitty.nix
    # ./minecraft-overlay.nix
    # ./mpd.nix
    # ./nextcloud-client.nix
    ../note/swww.nix
    # ./theme.nix
    ../note/zen-browser.nix
  ];

  home.stateVersion = "24.05";

  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "zen";
    TERMINAL = "kitty";
    FLAKE = "/home/emanuel/Cortex";
  };

  targets.genericLinux.enable = true;
  home.keyboard.layout = "br";

  xdg = {
    enable = true;
    mime.enable = true;
    systemDirs.data = [ "/usr/share" "/usr/local/share" ];
  };

  programs.home-manager.enable = true;
}
