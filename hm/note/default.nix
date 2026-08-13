{ inputs, ... }:
{
    imports = [
    inputs.noctalia.homeModules.default
    ../shared/btop.nix
    ../shared/fastfetch.nix
    ../shared/git.nix
    ../shared/ia.nix
    ../shared/lexis.nix
    ../shared/nix-index.nix
    ../shared/tmux.nix
    ../shared/user.nix
    ../shared/yazi.nix
    ../shared/zsh.nix
    ./apps.nix
    ./chirp.nix
    ./default-apps.nix
    ./firefox.nix
    ./ghostty.nix
    ./gimp.nix
    ./go.nix
    ./hyprland.nix
    ./java.nix
    ./keepassxc.nix
    ./keyring.nix
    ./minecraft-overlay.nix
    ./mpd.nix
    ./nextcloud-client.nix
    ./noctalia.nix
    ./obs.nix
    ./stylix.nix
    ./thunderbird.nix
    ./zen-browser.nix
  ];

  home.stateVersion = "25.05";
}
