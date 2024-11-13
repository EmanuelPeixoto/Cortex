{ pkgs, ... }:
let
  minecraft-backup = import ./scripts/minecraft-backup.nix { inherit pkgs; };
in
{
  services.minecraft-server = {
    enable = true;
    eula = true;
    declarative = true;
    openFirewall = true;
    jvmOpts = "-Xms2G -Xmx4G";
    serverProperties = {
      difficulty = "normal";
      level-name = "mapa_da_galera";
      max-players = 5;
      motd = "Dois de Campos e um intruso";
      online-mode = false;
      server-port = 25565;
      simulation-distance = 8;
      view-distance = 8;
      white-list = false;
    };
  };

  users.users.minecraft = {
    isSystemUser = true;
    group = "minecraft";
    home = "/var/lib/minecraft";
    createHome = true;
  };

  systemd.services.minecraft-backup = {
    description = "Minecraft Server Backup";
    serviceConfig = {
      Type = "oneshot";
      User = "minecraft";
      Group = "minecraft";
      ExecStart = "${pkgs.bash}/bin/bash ${minecraft-backup}/bin/minecraft-backup";
      WorkingDirectory = "/var/lib/minecraft";
    };
    environment = {
      HOME = "/var/lib/minecraft";
    };
  };

  systemd.timers.minecraft-backup = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "12:00:00";
      Unit = "minecraft-backup.service";
    };
  };
}
