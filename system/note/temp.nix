{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # chromium
    docker-compose
  ];

  # networking.extraHosts = ''
  #   192.168.0.10   epeixoto.ddns.net
  # '';

  services.xserver.desktopManager.cinnamon.enable = true;
  services.power-profiles-daemon.enable = false;

  virtualisation.docker.enable = true;
  users.users.emanuel.extraGroups = [ "docker" ];

}
