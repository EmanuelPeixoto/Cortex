{ pkgs, ... }:
let
    motd = import ./scripts/motd.nix { inherit pkgs; };
in
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    initExtra = "${pkgs.zsh}/bin/zsh ${motd}/bin/motd";

    shellAliases = {
      motd = "${pkgs.zsh}/bin/zsh ${motd}/bin/motd";
      ssh = "${pkgs.kitty}/bin/kitten ${pkgs.openssh}/bin/ssh";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [ ];
      theme = "afowler";
    };
  };
}
