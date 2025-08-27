{ pkgs, ... }:
let
  occ = "/run/current-system/sw/bin/nextcloud-occ";
  nextcloudUser = "root";
  analyzeJobs = 12;
in {
  systemd.services = {

    # Sync service - runs only once, must finish before analyze
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

    # Service that runs all analyze instances in parallel and waits to finish
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

    # Cluster service - runs after parallel analyze finishes
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

  # Timer to trigger the whole sequence of jobs every hour
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
