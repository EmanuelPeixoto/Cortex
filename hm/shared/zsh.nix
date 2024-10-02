{ config, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    initExtra = "zsh ${config.home.homeDirectory}/Cortex/hm/shared/motd.sh";

    shellAliases = {
      motd = "bash ${config.home.homeDirectory}/Cortex/hm/shared/motd.sh";
      ssh = "kitten ssh";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [ ];
      theme = "afowler";
    };
  };
}
