{ config, pkgs, ... }:
let
    motd = import ./scripts/motd.nix { inherit pkgs; };
    yt-dlp = import ./scripts/yt-dlp.nix { inherit pkgs; };
in
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    initExtra = "${pkgs.zsh}/bin/zsh ${motd}/bin/motd";

    shellAliases = {
      cfg = "${pkgs.yazi}/bin/yazi ${config.home.homeDirectory}/.config/Cortex";
      motd = "${pkgs.zsh}/bin/zsh ${motd}/bin/motd";
      ssh = "${pkgs.kitty}/bin/kitten ssh";
      yt-dlp-menu = "${pkgs.zsh}/bin/zsh ${yt-dlp}/bin/yt-dlp";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [ ];
      theme = "afowler";
    };
  };
}
