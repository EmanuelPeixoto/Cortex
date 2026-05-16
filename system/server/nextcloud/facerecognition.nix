{ pkgs, ... }:
let
  occ = "/run/current-system/sw/bin/nextcloud-occ";
  nextcloudUser = "root";
  analyzeJobs = 18;
in
{
  system.activationScripts.nextcloud-facerecognition-app = {
    deps = [ "var" ];
    text = ''
      ${occ} app:enable facerecognition 2>/dev/null || true
    '';
  };

  systemd.services = {

    nextcloud-face-sync = {
      description = "Nextcloud Face Recognition – Sync";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${occ} face:background_job -u ${nextcloudUser} --sync-mode";
        User = "nextcloud";
        Group = "nextcloud";
      };
    };

    "nextcloud-face-analyze@" = {
      description = "Nextcloud Face Recognition – Analyze (instance %i)";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${occ} face:background_job -u ${nextcloudUser} --analyze-mode";
        User = "nextcloud";
        Group = "nextcloud";
        PrivateTmp = true;
        NoNewPrivileges = true;
      };
    };

    nextcloud-face-analyze-all = {
      description = "Nextcloud Face Recognition – Analyze (parallel)";
      after = [ "nextcloud-face-sync.service" ];
      requires = [ "nextcloud-face-sync.service" ];
      serviceConfig = {
        Type = "oneshot";
        User = "root";
        ExecStart = pkgs.writeShellScript "face-analyze-parallel" ''
          set -e
          pids=()
          for i in $(seq 1 ${toString analyzeJobs}); do
            systemctl start --wait nextcloud-face-analyze@"$i".service &
            pids+=($!)
          done
          for pid in "''${pids[@]}"; do
            wait "$pid"
          done
        '';
      };
    };

    nextcloud-face-cluster = {
      description = "Nextcloud Face Recognition – Cluster";
      after = [ "nextcloud-face-analyze-all.service" ];
      requires = [ "nextcloud-face-analyze-all.service" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${occ} face:background_job -u ${nextcloudUser} --cluster-mode";
        User = "nextcloud";
        Group = "nextcloud";
      };
    };

  };

  systemd.timers.nextcloud-face-sync = {
    wantedBy = [ "timers.target" ];
    unitConfig.Description = "Nextcloud Face Recognition – hourly pipeline trigger";
    timerConfig = {
      OnCalendar = "hourly";
      Persistent = true;
    };
  };
}
