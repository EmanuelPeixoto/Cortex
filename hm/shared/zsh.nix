{ config, pkgs, ... }:
let
    motd = import ./scripts/motd.nix { inherit pkgs; };
in
{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    initContent = "${motd}/bin/motd";

    shellAliases = {
      cfg = "yy ${config.home.homeDirectory}/.config/Cortex";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [ ];
      theme = "afowler";
    };
  };
}
