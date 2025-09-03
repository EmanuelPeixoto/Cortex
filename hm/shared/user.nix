{ config, pkgs, ... }:

{
  home = {
    homeDirectory = "/home/emanuel";
    username = "emanuel";

    sessionVariables = {
      EDITOR = "nvim";
      BROWSER = "zen";
      TERMINAL = "ghostty";
    };
  };

  programs.home-manager.enable = true;
}
