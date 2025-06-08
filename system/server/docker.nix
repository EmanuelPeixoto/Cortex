{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    docker-compose
  ];

  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  users.users.emanuel.extraGroups = [ "docker" ];

  networking.firewall.allowedTCPPorts = [ 8080 ];
}
