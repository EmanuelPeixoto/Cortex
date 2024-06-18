{ ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    initExtra = "zsh /home/emanuel/NixOS/home-manager/motd.sh";

    shellAliases = {
      motd = "bash /home/emanuel/NixOS/home-manager/motd.sh";
      ssh = "kitten ssh";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [ ];
      theme = "afowler";
    };
  };
}
