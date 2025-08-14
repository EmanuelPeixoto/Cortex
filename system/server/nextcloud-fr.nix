{ pkgs, ... }:
let
  occ = "/run/current-system/sw/bin/nextcloud-occ";
  nextcloudUser = "root";
  analyzeJobs = 12;
in {
  systemd.services = {

    # Serviço sync - roda só uma vez, deve terminar antes do analyze
    nextcloud-face-sync = {
      description = "Nextcloud Face Recognition Sync Mode";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${occ} face:background_job -u ${nextcloudUser} --sync-mode";
      };
    };

    # Template analyze
    "nextcloud-face-analyze@" = {
      description = "Nextcloud Face Recognition Analyze Mode Instance %i";
      serviceConfig = {
        Type = "simple";
        ExecStart = "${occ} face:background_job -u ${nextcloudUser} --analyze-mode";
        PrivateTmp = true;
        NoNewPrivileges = true;
      };
    };

    # Serviço que roda todas as instâncias analyze em paralelo e espera terminar
    nextcloud-face-analyze-parallel-run = {
      description = "Run multiple analyze instances in parallel and wait";
      serviceConfig = {
        Type = "simple";
        ExecStart = pkgs.writeShellScript "nextcloud-face-parallel" ''
          for i in $(seq 1 ${toString analyzeJobs}); do
          systemctl start nextcloud-face-analyze@$i.service &
          done
          wait
        '';
      };
      after = [ "nextcloud-face-sync.service" ];
      requires = [ "nextcloud-face-sync.service" ];
    };

    # Serviço cluster - roda após analyze paralelo terminar
    nextcloud-face-cluster = {
      description = "Nextcloud Face Recognition Cluster Mode";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${occ} face:background_job -u ${nextcloudUser} --cluster-mode";
      };
      after = [ "nextcloud-face-analyze-parallel-run.service" ];
      requires = [ "nextcloud-face-analyze-parallel-run.service" ];
    };

  };

  # Timer para disparar toda sequência de jobs a cada hora
  systemd.timers.nextcloud-face-run-all-timer = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "hourly";
      Persistent = true;
    };
    unitConfig = {
      Description = "Run all Nextcloud Face Recognition steps hourly";
      Requires = [ "nextcloud-face-sync.service" ];
    };
  };
}

