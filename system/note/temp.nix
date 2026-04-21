{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # chromium
    cheese
  ];

  # networking.extraHosts = ''
  #   192.168.0.10   epeixoto.ddns.net
  # '';
}
