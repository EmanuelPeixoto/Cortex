{ pkgs, ... }:
{
  programs.firefox = {
    enable = false;
    nativeMessagingHosts = [ pkgs.keepassxc ];
  };
}
