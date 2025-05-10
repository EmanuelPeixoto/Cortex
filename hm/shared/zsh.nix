{ config, pkgs, ... }:
let
    motd = import ./scripts/motd.nix { inherit pkgs; };
    yt-dlp = import ./scripts/yt-dlp.nix { inherit pkgs; };
in
{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    initContent = "${pkgs.zsh}/bin/zsh ${motd}/bin/motd";

    shellAliases = {
      catfolder = "find . -type f -exec echo \"=== {} ===\" \\; -exec cat {} \\;";
      cfg = "yy ${config.home.homeDirectory}/.config/Cortex";
      motd = "${pkgs.zsh}/bin/zsh ${motd}/bin/motd";
      yt-dlp-menu = "${pkgs.zsh}/bin/zsh ${yt-dlp}/bin/yt-dlp";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [ ];
      theme = "afowler";
    };
  };
}
