{ config, ... }:
{
  programs.go = {
    enable = false;
    env.GOPATH = "${config.home.homeDirectory}/.config/go";
  };
}
