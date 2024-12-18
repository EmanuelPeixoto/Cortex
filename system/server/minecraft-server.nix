{ config, pkgs, ... }:
let
  minecraft-backup = import ./scripts/minecraft-backup.nix { inherit pkgs; };
  minecraft-restart = import ./scripts/minecraft-restart.nix {inherit config pkgs; };
in
{
  services.minecraft-server = {
    enable = true;
    package = pkgs.papermcServers.papermc-1_21;
    eula = true;
    declarative = true;
    openFirewall = true;
    jvmOpts = "-Xms2G -Xmx4G";
    serverProperties = {
      "rcon.password" = "ihavefirewall";
      difficulty = "normal";
      enable-rcon = true;
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
      OnCalendar = "00:00,12:00";
      Unit = "minecraft-backup.service";
    };
  };

  systemd.services.minecraft-restart = {
    description = "Minecraft Server Restart";
    serviceConfig = {
      Type = "oneshot";
      User = "minecraft";
      Group = "minecraft";
      ExecStart = "${minecraft-restart}/bin/minecraft-restart";
    };
  };

  systemd.timers.minecraft-restart = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "02:30:00";
      Unit = "minecraft-restart.service";
    };
  };
}
