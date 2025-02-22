{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # chromium
    docker-compose
  ];

  # networking.extraHosts = ''
  #   192.168.0.10   epeixoto.ddns.net
  # '';

  virtualisation.docker.enable = true;
  users.users.emanuel.extraGroups = [ "docker" ];

}
