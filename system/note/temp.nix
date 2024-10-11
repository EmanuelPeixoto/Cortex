{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    jetbrains.idea-ultimate
    docker-compose
  ];

  virtualisation.docker.enable = true;
  virtualisation.waydroid.enable = true;
}
