{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # chromium
    code-cursor
  ];

  # networking.extraHosts = ''
  #   192.168.0.10   epeixoto.ddns.net
  # '';
}
