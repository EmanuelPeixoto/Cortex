{ inputs, pkgs, ... }:
{
  imports = [
    inputs.zen-browser.homeModules.default
  ];

  programs.zen-browser = {
    enable = true;
    nativeMessagingHosts = [ pkgs.keepassxc ];
  };
}
