{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    jetbrains.idea-ultimate
    docker-compose
  ];

  virtualisation.docker.enable = true;
  virtualisation.waydroid.enable = true;

  boot.kernelModules = [ "vboxdrv" "vboxnetadp" "vboxnetflt" ];
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "emanuel" ];
}
