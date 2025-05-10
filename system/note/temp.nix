{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # chromium
    docker-compose
    code-cursor
  ];

  # networking.extraHosts = ''
  #   192.168.0.10   epeixoto.ddns.net
  # '';

  services = {
    xserver = {
      enable = true;
      desktopManager.cinnamon.enable = true;
    };
    power-profiles-daemon.enable = false;
  };

  virtualisation.docker.enable = true;
  users.users.emanuel.extraGroups = [ "docker" ];
}
