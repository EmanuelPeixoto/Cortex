{ config, pkgs, lib, ... }:
{
  environment.systemPackages = lib.mkIf config.virtualisation.docker.enable [
    pkgs.docker-compose
  ];

  virtualisation.docker = {
    enable = false;
    rootless = lib.mkIf config.virtualisation.docker.enable {
      enable = true;
      setSocketVariable = true;
    };
  };

  users.users.emanuel.extraGroups = lib.mkIf config.virtualisation.docker.enable [ "docker" ];
}
