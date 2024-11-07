{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # jetbrains.idea-ultimate # scti poo
    # docker-compose # scti
    # maven # scti poo
    # jdk17 # scti poo
    # postman # scti poo
  ];

  #scti
  # virtualisation.docker.enable = true;

  #joao
  virtualisation.waydroid.enable = true;


# virtual box
  boot.kernelModules = [ "vboxdrv" "vboxnetadp" "vboxnetflt" ];
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "emanuel" ];
}
