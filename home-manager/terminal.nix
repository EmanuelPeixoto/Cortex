{lib, config, pkgs, ... }:
{


# Enable zsh and ohMyZsh
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;
    
    initExtra = "zsh /home/emanuel/NixOS/home-manager/motd";

    shellAliases = {
      motd = "bash /home/emanuel/NixOS/home-manager/motd";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [ ];
      theme = "afowler"; 
    };
  };


}
