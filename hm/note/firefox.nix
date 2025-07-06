{ pkgs, ... }:
{
  programs.firefox.enable = true;
  programs.firefox.nativeMessagingHosts = [ pkgs.keepassxc ];
}
