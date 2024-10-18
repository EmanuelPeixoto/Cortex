{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    jetbrains.idea-ultimate # scti poo
    docker-compose # scti
    maven # scti poo
    jdk17 # scti poo
    dia # ausberto
    postman # scti poo
  ];

  #scti
  virtualisation.docker.enable = true;

  #joao
  virtualisation.waydroid.enable = true;


# virtual box
  boot.kernelModules = [ "vboxdrv" "vboxnetadp" "vboxnetflt" ];
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "emanuel" ];

    services.postgresql = {
    enable = true;
    enableTCPIP = true;
    authentication = pkgs.lib.mkOverride 10 ''
      #type database DBuser auth-method
      local all      all    trust
      #type database DBuser Address      auth-method
      host  all      all    127.0.0.1/32 trust
      host  all      all    ::1/128      trust
    '';
  };
}
