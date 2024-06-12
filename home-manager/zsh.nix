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
      bar = "eww close-all && home-manager switch --flake ~/NixOS && eww open bar";
      ssh = "kitten ssh";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [ ];
      theme = "afowler";
    };
  };
}
